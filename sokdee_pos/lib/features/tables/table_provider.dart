import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'table_provider.g.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum TableStatus { available, occupied, waitingPayment }

class RestaurantTable {
  const RestaurantTable({
    required this.id,
    required this.tableNumber,
    required this.status,
    this.zone,
    this.capacity,
    this.openedAt,
    this.activeOrderId,
  });

  final String id;
  final String tableNumber;
  final TableStatus status;
  final String? zone;
  final int? capacity;
  final DateTime? openedAt;
  final String? activeOrderId;

  /// How long this table has been occupied
  Duration? get occupiedDuration =>
      openedAt != null ? DateTime.now().difference(openedAt!) : null;

  factory RestaurantTable.fromJson(Map<String, dynamic> j) {
    TableStatus status;
    switch (j['status'] as String? ?? 'available') {
      case 'occupied':
        status = TableStatus.occupied;
      case 'waiting_payment':
        status = TableStatus.waitingPayment;
      default:
        status = TableStatus.available;
    }
    return RestaurantTable(
      id: j['id'] as String,
      tableNumber: j['table_number'] as String,
      status: status,
      zone: j['zone'] as String?,
      capacity: j['capacity'] as int?,
      openedAt: j['opened_at'] != null
          ? DateTime.tryParse(j['opened_at'] as String)
          : null,
      activeOrderId: j['active_order_id'] as String?,
    );
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

@riverpod
Future<List<RestaurantTable>> tableList(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/tables');
  final list = data['tables'] as List<dynamic>? ?? [];
  return list
      .map((e) => RestaurantTable.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
class TableActions extends _$TableActions {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<String?> openTable(String tableId) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      final resp = await client.post('/orders', body: {'table_id': tableId});
      ref.invalidate(tableListProvider);
      state = const AsyncValue.data(null);
      return resp['id'] as String?;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> mergeTables(List<String> tableIds, String targetOrderId) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/tables/merge', body: {
        'table_ids': tableIds,
        'target_order_id': targetOrderId,
      });
      ref.invalidate(tableListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> moveOrder(
    String fromTableId,
    String toTableId,
    String approvedBy,
  ) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/tables/$fromTableId/move', body: {
        'to_table_id': toTableId,
        'approved_by': approvedBy,
      });
      ref.invalidate(tableListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
