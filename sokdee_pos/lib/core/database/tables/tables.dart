import 'package:drift/drift.dart';

// ─── Subscription Plans ───────────────────────────────────────────────────────

class SubscriptionPlansTable extends Table {
  @override
  String get tableName => 'subscription_plans';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get name => text().withLength(max: 50)();
  IntColumn get maxUsers => integer().nullable()();
  IntColumn get maxProducts => integer().nullable()();
  TextColumn get features => text()(); // JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Tenants ──────────────────────────────────────────────────────────────────

class TenantsTable extends Table {
  @override
  String get tableName => 'tenants';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get name => text().withLength(max: 255)();
  TextColumn get storeType => text().withLength(max: 50)();
  TextColumn get planId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get defaultLang => text().withDefault(const Constant('lo'))();
  TextColumn get baseCurrency => text().withDefault(const Constant('LAK'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  // Local sync fields
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Users ────────────────────────────────────────────────────────────────────

class UsersTable extends Table {
  @override
  String get tableName => 'users';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get username => text().withLength(max: 100)();
  TextColumn get displayName => text().withLength(max: 255)();
  TextColumn get role => text().withLength(max: 30)();
  TextColumn get pinHash => text().withLength(max: 255)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get failedPinAttempts =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get lockedUntil => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Categories ───────────────────────────────────────────────────────────────

class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get name => text().withLength(max: 255)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Products ─────────────────────────────────────────────────────────────────

class ProductsTable extends Table {
  @override
  String get tableName => 'products';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get name => text().withLength(max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get sellPrice => real()();
  RealColumn get costPrice => real().nullable()();
  TextColumn get unit => text().nullable()();
  IntColumn get minStock => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get hasVariants => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Product Variants ─────────────────────────────────────────────────────────

class ProductVariantsTable extends Table {
  @override
  String get tableName => 'product_variants';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get productId => text()();
  TextColumn get tenantId => text()();
  TextColumn get name => text().withLength(max: 255)();
  TextColumn get barcode => text().nullable()();
  RealColumn get sellPrice => real().nullable()();
  RealColumn get costPrice => real().nullable()();
  IntColumn get stockQty => integer().withDefault(const Constant(0))();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Restaurant Tables ────────────────────────────────────────────────────────

class RestaurantTablesTable extends Table {
  @override
  String get tableName => 'restaurant_tables';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get zone => text().nullable()();
  TextColumn get tableNumber => text().withLength(max: 20)();
  IntColumn get capacity => integer().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('available'))();
  DateTimeColumn get openedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Shifts ───────────────────────────────────────────────────────────────────

class ShiftsTable extends Table {
  @override
  String get tableName => 'shifts';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get cashierId => text()();
  TextColumn get deviceId => text().nullable()();
  RealColumn get openingBalance => real()();
  RealColumn get closingBalance => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get openedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Orders ───────────────────────────────────────────────────────────────────

class OrdersTable extends Table {
  @override
  String get tableName => 'orders';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get orderNumber => text().withLength(max: 50)();
  TextColumn get tableId => text().nullable()();
  TextColumn get cashierId => text()();
  TextColumn get shiftId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  TextColumn get idempotencyKey => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get paidAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Order Items ──────────────────────────────────────────────────────────────

class OrderItemsTable extends Table {
  @override
  String get tableName => 'order_items';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get orderId => text()();
  TextColumn get tenantId => text()();
  TextColumn get productId => text()();
  TextColumn get variantId => text().nullable()();
  TextColumn get productName => text().withLength(max: 255)();
  RealColumn get unitPrice => real()();
  IntColumn get quantity => integer()();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get lineTotal => real()();
  TextColumn get modifiers => text().nullable()(); // JSON
  TextColumn get notes => text().nullable()();
  TextColumn get kdsStatus =>
      text().withDefault(const Constant('pending'))();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Payments ─────────────────────────────────────────────────────────────────

class PaymentsTable extends Table {
  @override
  String get tableName => 'payments';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get orderId => text()();
  TextColumn get tenantId => text()();
  TextColumn get method => text().withLength(max: 30)();
  TextColumn get currency => text().withLength(max: 3)();
  RealColumn get amount => real()();
  RealColumn get amountLak => real()();
  RealColumn get exchangeRate => real().withDefault(const Constant(1))();
  RealColumn get changeAmount => real().withDefault(const Constant(0))();
  TextColumn get confirmedBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Exchange Rates ───────────────────────────────────────────────────────────

class ExchangeRatesTable extends Table {
  @override
  String get tableName => 'exchange_rates';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get currency => text().withLength(max: 3)();
  RealColumn get rate => real()();
  TextColumn get setBy => text().nullable()();
  DateTimeColumn get effectiveAt =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Discounts ────────────────────────────────────────────────────────────────

class DiscountsTable extends Table {
  @override
  String get tableName => 'discounts';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get name => text().withLength(max: 255)();
  TextColumn get type => text().withLength(max: 20)();
  RealColumn get value => real()();
  TextColumn get scope => text().withLength(max: 20)();
  TextColumn get productId => text().nullable()();
  DateTimeColumn get startsAt => dateTime().nullable()();
  DateTimeColumn get endsAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get requiresApproval =>
      boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Sync Queue ───────────────────────────────────────────────────────────────

class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get entityType => text().withLength(max: 100)();
  TextColumn get entityId => text()();
  TextColumn get operation => text().withLength(max: 20)();
  TextColumn get payload => text()(); // JSON
  TextColumn get idempotencyKey => text().unique()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Conflict Logs ────────────────────────────────────────────────────────────

class ConflictLogsTable extends Table {
  @override
  String get tableName => 'conflict_logs';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get entityType => text().withLength(max: 100)();
  TextColumn get entityId => text()();
  TextColumn get localValue => text().nullable()(); // JSON
  TextColumn get serverValue => text().nullable()(); // JSON
  TextColumn get resolution => text().nullable()();
  TextColumn get resolvedBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Refunds ──────────────────────────────────────────────────────────────────

class RefundsTable extends Table {
  @override
  String get tableName => 'refunds';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get originalOrderId => text()();
  TextColumn get reason => text()();
  TextColumn get approvedBy => text()();
  RealColumn get totalRefund => real()();
  TextColumn get currency => text().withLength(max: 3)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Void Logs ────────────────────────────────────────────────────────────────

class VoidLogsTable extends Table {
  @override
  String get tableName => 'void_logs';

  TextColumn get id => text().clientDefault(() => _uuid())();
  TextColumn get tenantId => text()();
  TextColumn get orderId => text()();
  TextColumn get reason => text()();
  TextColumn get voidedBy => text()();
  TextColumn get shiftId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ─── Helper ───────────────────────────────────────────────────────────────────

String _uuid() {
  // Simple UUID v4 generation — replaced by uuid package at runtime
  final now = DateTime.now().microsecondsSinceEpoch;
  return 'local-$now';
}
