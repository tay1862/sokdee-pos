import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'inventory_provider.g.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class Category {
  const Category({
    required this.id,
    required this.name,
    this.parentId,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? parentId;
  final int sortOrder;
  final bool isActive;

  factory Category.fromJson(Map<String, dynamic> j) => Category(
        id: j['id'] as String,
        name: j['name'] as String,
        parentId: j['parent_id'] as String?,
        sortOrder: j['sort_order'] as int? ?? 0,
        isActive: j['is_active'] as bool? ?? true,
      );
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.sellPrice,
    this.costPrice,
    this.barcode,
    this.unit,
    this.minStock = 0,
    this.isActive = true,
    this.hasVariants = false,
    this.stockQty = 0,
    this.categoryIds = const [],
  });

  final String id;
  final String name;
  final double sellPrice;
  final double? costPrice;
  final String? barcode;
  final String? unit;
  final int minStock;
  final bool isActive;
  final bool hasVariants;
  final int stockQty;
  final List<String> categoryIds;

  bool get isLowStock => stockQty <= minStock && minStock > 0;
  bool get isOutOfStock => stockQty <= 0;

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as String,
        name: j['name'] as String,
        sellPrice: (j['sell_price'] as num).toDouble(),
        costPrice: j['cost_price'] != null ? (j['cost_price'] as num).toDouble() : null,
        barcode: j['barcode'] as String?,
        unit: j['unit'] as String?,
        minStock: j['min_stock'] as int? ?? 0,
        isActive: j['is_active'] as bool? ?? true,
        hasVariants: j['has_variants'] as bool? ?? false,
        stockQty: j['stock_qty'] as int? ?? 0,
        categoryIds: (j['category_ids'] as List<dynamic>?)?.cast<String>() ?? [],
      );
}

// ─── Providers ────────────────────────────────────────────────────────────────

@riverpod
Future<List<Category>> categoryList(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/categories');
  final list = data['categories'] as List<dynamic>? ?? [];
  return list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
}

@riverpod
Future<List<Product>> productList(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/products');
  final list = data['products'] as List<dynamic>? ?? [];
  return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
}

@riverpod
Future<List<Product>> productsByCategory(Ref ref, String categoryId) async {
  final products = await ref.watch(productListProvider.future);
  if (categoryId == 'all') return products;
  return products.where((p) => p.categoryIds.contains(categoryId)).toList();
}

@riverpod
class ProductActions extends _$ProductActions {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createProduct(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/products', body: data);
      ref.invalidate(productListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.patch('/products/$id', body: data);
      ref.invalidate(productListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.delete('/products/$id');
      ref.invalidate(productListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
