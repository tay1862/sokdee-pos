import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/features/inventory/inventory_provider.dart';
import 'package:sokdee_pos/features/inventory/product_form.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Products'), Tab(text: 'Categories')],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(productListProvider);
              ref.invalidate(categoryListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProductsTab(
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            onCategoryChanged: (v) => setState(() => _selectedCategory = v),
          ),
          const _CategoriesTab(),
        ],
      ),
    );
  }

  void _showProductForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ProductForm(),
    );
  }
}

// ─── Products Tab ─────────────────────────────────────────────────────────────

class _ProductsTab extends ConsumerWidget {
  const _ProductsTab({
    required this.searchQuery,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategoryChanged,
  });

  final String searchQuery;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),

        // Category filter chips
        categoriesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (cats) => SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: selectedCategory == 'all',
                  onTap: () => onCategoryChanged('all'),
                ),
                ...cats.map((c) => _CategoryChip(
                      label: c.name,
                      selected: selectedCategory == c.id,
                      onTap: () => onCategoryChanged(c.id),
                    )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Product list
        Expanded(
          child: productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (products) {
              final filtered = products.where((p) {
                final matchSearch = searchQuery.isEmpty ||
                    p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    (p.barcode?.contains(searchQuery) ?? false);
                final matchCat = selectedCategory == 'all' ||
                    p.categoryIds.contains(selectedCategory);
                return matchSearch && matchCat;
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text('No products found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _ProductTile(product: filtered[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: product.isOutOfStock
              ? Colors.red.shade100
              : product.isLowStock
                  ? Colors.orange.shade100
                  : theme.colorScheme.primaryContainer,
          child: Text(
            product.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: product.isOutOfStock
                  ? Colors.red
                  : product.isLowStock
                      ? Colors.orange
                      : theme.colorScheme.primary,
            ),
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          '${product.sellPrice.toStringAsFixed(0)} ₭'
          '${product.barcode != null ? ' • ${product.barcode}' : ''}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (product.isOutOfStock)
              const Chip(
                label: Text('Out', style: TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: Colors.red,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            else if (product.isLowStock)
              Chip(
                label: Text('Low: ${product.stockQty}', style: const TextStyle(fontSize: 10)),
                backgroundColor: Colors.orange.shade100,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            else
              Text('Stock: ${product.stockQty}', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ─── Categories Tab ───────────────────────────────────────────────────────────

class _CategoriesTab extends ConsumerWidget {
  const _CategoriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (cats) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cats.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.folder_outlined),
          title: Text(cats[i].name),
          subtitle: cats[i].parentId != null ? const Text('Sub-category') : null,
          trailing: Switch(
            value: cats[i].isActive,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
