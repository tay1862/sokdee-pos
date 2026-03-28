import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/database/daos/orders_dao.dart';
import 'package:sokdee_pos/core/database/daos/products_dao.dart';
import 'package:sokdee_pos/core/database/daos/sync_dao.dart';
import 'package:sokdee_pos/core/database/tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SubscriptionPlansTable,
    TenantsTable,
    UsersTable,
    CategoriesTable,
    ProductsTable,
    ProductVariantsTable,
    OrdersTable,
    OrderItemsTable,
    PaymentsTable,
    RestaurantTablesTable,
    ShiftsTable,
    SyncQueueTable,
    ConflictLogsTable,
    ExchangeRatesTable,
    DiscountsTable,
    RefundsTable,
    VoidLogsTable,
  ],
  daos: [
    ProductsDao,
    OrdersDao,
    SyncDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future migrations go here
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'sokdee_pos');
  }
}

@riverpod
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
