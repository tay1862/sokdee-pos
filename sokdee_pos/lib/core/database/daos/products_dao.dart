import 'package:drift/drift.dart';
import 'package:sokdee_pos/core/database/app_database.dart';
import 'package:sokdee_pos/core/database/tables/tables.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [ProductsTable, ProductVariantsTable, CategoriesTable])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  /// Get all active products for a tenant
  Future<List<ProductsTableData>> getProducts(String tenantId) =>
      (select(productsTable)
            ..where((t) => t.tenantId.equals(tenantId) & t.isActive.isValue(true)))
          .get();

  /// Get product by barcode
  Future<ProductsTableData?> getByBarcode(
    String tenantId,
    String barcode,
  ) =>
      (select(productsTable)
            ..where(
              (t) =>
                  t.tenantId.equals(tenantId) & t.barcode.equals(barcode),
            )
            ..limit(1))
          .getSingleOrNull();

  /// Insert or update a product
  Future<void> upsertProduct(ProductsTableCompanion product) =>
      into(productsTable).insertOnConflictUpdate(product);

  /// Get variants for a product
  Future<List<ProductVariantsTableData>> getVariants(String productId) =>
      (select(productVariantsTable)
            ..where((t) => t.productId.equals(productId)))
          .get();

  /// Get unsynced products
  Future<List<ProductsTableData>> getUnsynced(String tenantId) =>
      (select(productsTable)
            ..where(
              (t) =>
                  t.tenantId.equals(tenantId) &
                  t.isSynced.isValue(false),
            ))
          .get();
}
