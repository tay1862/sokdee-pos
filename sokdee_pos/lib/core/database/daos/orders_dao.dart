import 'package:drift/drift.dart';
import 'package:sokdee_pos/core/database/app_database.dart';
import 'package:sokdee_pos/core/database/tables/tables.dart';

part 'orders_dao.g.dart';

@DriftAccessor(tables: [OrdersTable, OrderItemsTable, PaymentsTable])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.db);

  /// Get open orders for a tenant
  Future<List<OrdersTableData>> getOpenOrders(String tenantId) =>
      (select(ordersTable)
            ..where(
              (t) =>
                  t.tenantId.equals(tenantId) & t.status.equals('open'),
            ))
          .get();

  /// Get order by id
  Future<OrdersTableData?> getOrder(String id) =>
      (select(ordersTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get items for an order
  Future<List<OrderItemsTableData>> getOrderItems(String orderId) =>
      (select(orderItemsTable)
            ..where((t) => t.orderId.equals(orderId)))
          .get();

  /// Insert order
  Future<void> insertOrder(OrdersTableCompanion order) =>
      into(ordersTable).insert(order);

  /// Update order
  Future<bool> updateOrder(OrdersTableCompanion order) =>
      update(ordersTable).replace(order);

  /// Insert order item
  Future<void> insertOrderItem(OrderItemsTableCompanion item) =>
      into(orderItemsTable).insert(item);

  /// Insert payment
  Future<void> insertPayment(PaymentsTableCompanion payment) =>
      into(paymentsTable).insert(payment);

  /// Get unsynced orders
  Future<List<OrdersTableData>> getUnsynced(String tenantId) =>
      (select(ordersTable)
            ..where(
              (t) =>
                  t.tenantId.equals(tenantId) &
                  t.isSynced.isValue(false),
            ))
          .get();
}
