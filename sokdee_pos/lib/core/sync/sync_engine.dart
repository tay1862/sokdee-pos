import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';
import 'package:sokdee_pos/core/database/app_database.dart';
import 'package:sokdee_pos/core/database/daos/sync_dao.dart';
import 'package:sokdee_pos/core/database/tables/tables.dart';
import 'package:sokdee_pos/core/network/api_client.dart';
import 'package:sokdee_pos/core/utils/connectivity_provider.dart';
import 'package:uuid/uuid.dart';

part 'sync_engine.g.dart';

const _uuid = Uuid();

// ─── Sync Operation ───────────────────────────────────────────────────────────

class SyncOperation {
  const SyncOperation({
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.tenantId,
    required this.deviceId,
  });

  final String entityType;
  final String entityId;
  final String operation; // create, update, delete
  final Map<String, dynamic> payload;
  final String tenantId;
  final String deviceId;

  String get idempotencyKey =>
      '$deviceId:$entityType:$entityId:${DateTime.now().millisecondsSinceEpoch}';
}

// ─── Sync Result ──────────────────────────────────────────────────────────────

class SyncResult {
  const SyncResult({
    this.synced = 0,
    this.conflicts = 0,
    this.failed = 0,
  });

  final int synced;
  final int conflicts;
  final int failed;

  bool get hasConflicts => conflicts > 0;
}

// ─── Sync Engine ──────────────────────────────────────────────────────────────

@riverpod
class SyncEngine extends _$SyncEngine {
  Timer? _autoSyncTimer;

  @override
  AsyncValue<SyncResult?> build() {
    // Watch connectivity — auto-flush when coming online
    ref.listen(isOnlineProvider, (prev, next) {
      if (next && prev == false) {
        Future.delayed(const Duration(seconds: 5), flush);
      }
    });

    ref.onDispose(() => _autoSyncTimer?.cancel());
    return const AsyncValue.data(null);
  }

  /// Enqueue a write operation for later sync
  Future<void> enqueue(SyncOperation op) async {
    final db = ref.read(appDatabaseProvider);
    final dao = SyncDao(db);

    await dao.enqueue(
      SyncQueueTableCompanion.insert(
        tenantId: op.tenantId,
        deviceId: Value(op.deviceId),
        entityType: op.entityType,
        entityId: op.entityId,
        operation: op.operation,
        payload: jsonEncode(op.payload),
        idempotencyKey: op.idempotencyKey,
      ),
    );
  }

  /// Flush all pending operations to the backend
  Future<SyncResult> flush() async {
    final auth = ref.read(currentAuthProvider);
    if (auth is! AuthAuthenticated) return const SyncResult();

    final db = ref.read(appDatabaseProvider);
    final dao = SyncDao(db);
    final client = ref.read(apiClientProvider);

    final pending = await dao.getPendingOperations(auth.tenantId);
    if (pending.isEmpty) return const SyncResult();

    state = const AsyncValue.loading();

    int synced = 0, conflicts = 0, failed = 0;

    try {
      final operations = pending.map((op) => {
            'entity_type': op.entityType,
            'entity_id': op.entityId,
            'operation': op.operation,
            'payload': jsonDecode(op.payload),
            'idempotency_key': op.idempotencyKey,
          }).toList();

      final response = await client.post('/sync/push', body: {'operations': operations});

      final syncedIds = (response['synced'] as List<dynamic>?)?.cast<String>() ?? [];
      final conflictList = response['conflicts'] as List<dynamic>? ?? [];

      // Mark synced
      for (final id in syncedIds) {
        final op = pending.firstWhere(
          (p) => p.idempotencyKey == id,
          orElse: () => pending.first,
        );
        await dao.markSynced(op.id);
        synced++;
      }

      // Record conflicts
      for (final c in conflictList) {
        final conflict = c as Map<String, dynamic>;
        await dao.insertConflict(
          ConflictLogsTableCompanion.insert(
            tenantId: auth.tenantId,
            entityType: conflict['entity_type'] as String,
            entityId: conflict['entity_id'] as String,
            localValue: Value(jsonEncode(conflict['local_value'])),
            serverValue: Value(jsonEncode(conflict['server_value'])),
          ),
        );
        conflicts++;
      }

      // Mark failed ops
      for (final op in pending) {
        if (!syncedIds.contains(op.idempotencyKey)) {
          final isConflict = conflictList.any(
            (c) => (c as Map<String, dynamic>)['entity_id'] == op.entityId,
          );
          if (!isConflict) {
            await dao.markFailed(op.id);
            failed++;
          }
        }
      }

      // Cleanup old synced ops
      await dao.cleanup();

      final result = SyncResult(synced: synced, conflicts: conflicts, failed: failed);
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return SyncResult(failed: pending.length);
    }
  }

  /// Pull latest data from server (incremental)
  Future<void> pull({String? since}) async {
    final auth = ref.read(currentAuthProvider);
    if (auth is! AuthAuthenticated) return;

    final client = ref.read(apiClientProvider);
    final params = <String, dynamic>{
      'entities': 'products,categories,settings',
      if (since != null) 'since': since,
    };

    try {
      await client.get('/sync/pull', queryParams: params);
      // TODO: apply pulled data to local DB in subsequent tasks
    } catch (_) {}
  }
}

// ─── Conflict Resolution Provider ────────────────────────────────────────────

@riverpod
Future<List<ConflictLogsTableData>> unresolvedConflicts(Ref ref) async {
  final auth = ref.watch(currentAuthProvider);
  if (auth is! AuthAuthenticated) return [];

  final db = ref.read(appDatabaseProvider);
  final dao = SyncDao(db);
  return dao.getUnresolvedConflicts(auth.tenantId);
}

// Value helper for optional Drift columns
class Value<T> {
  const Value(this.value);
  final T value;
}
