import 'package:drift/drift.dart';
import 'package:sokdee_pos/core/database/app_database.dart';
import 'package:sokdee_pos/core/database/tables/tables.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncQueueTable, ConflictLogsTable])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  /// Get all pending sync operations
  Future<List<SyncQueueTableData>> getPendingOperations(String tenantId) =>
      (select(syncQueueTable)
            ..where(
              (t) =>
                  t.tenantId.equals(tenantId) &
                  t.status.equals('pending'),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  /// Enqueue a sync operation
  Future<void> enqueue(SyncQueueTableCompanion op) =>
      into(syncQueueTable).insertOnConflictUpdate(op);

  /// Mark operation as synced
  Future<void> markSynced(String id) => (update(syncQueueTable)
        ..where((t) => t.id.equals(id)))
      .write(
        SyncQueueTableCompanion(
          status: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ),
      );

  /// Mark operation as failed
  Future<void> markFailed(String id) => (update(syncQueueTable)
        ..where((t) => t.id.equals(id)))
      .write(const SyncQueueTableCompanion(status: Value('failed')));

  /// Get unresolved conflicts
  Future<List<ConflictLogsTableData>> getUnresolvedConflicts(
    String tenantId,
  ) =>
      (select(conflictLogsTable)
            ..where(
              (t) =>
                  t.tenantId.equals(tenantId) &
                  t.resolution.isNull(),
            ))
          .get();

  /// Insert conflict log
  Future<void> insertConflict(ConflictLogsTableCompanion conflict) =>
      into(conflictLogsTable).insert(conflict);

  /// Resolve conflict
  Future<void> resolveConflict(
    String id,
    String resolution,
    String resolvedBy,
  ) =>
      (update(conflictLogsTable)..where((t) => t.id.equals(id))).write(
        ConflictLogsTableCompanion(
          resolution: Value(resolution),
          resolvedBy: Value(resolvedBy),
          resolvedAt: Value(DateTime.now()),
        ),
      );

  /// Cleanup old synced operations (older than 7 days)
  Future<void> cleanup() => (delete(syncQueueTable)
        ..where(
          (t) =>
              t.status.equals('synced') &
              t.syncedAt.isSmallerThanValue(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
        ))
      .go();
}
