import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokdee_pos/core/theme/app_theme.dart';
import 'package:sokdee_pos/core/utils/connectivity_provider.dart';
import 'package:sokdee_pos/features/inventory/inventory_provider.dart';
import 'package:sokdee_pos/features/pos/barcode_handler.dart';
import 'package:sokdee_pos/features/pos/cart_model.dart';
import 'package:sokdee_pos/features/pos/cart_provider.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);

    return BarcodeHandler(
      onBarcode: (barcode) => _handleBarcode(barcode),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SOKDEE POS'),
          actions: [
            if (!isOnline)
              const Chip(
                label: Text('OFFLINE', style: TextStyle(color: Colors.white, fontSize: 11)),
                backgroundColor: Colors.orange,
                padding: EdgeInsets.zero,
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: ResponsiveWidget(
          phone: _buildPhoneLayout(),
          tablet: _buildTabletLayout(),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Left: Categories + Products (2/3 width)
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _SearchBar(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              _CategoryBar(
                selected: _selectedCategory,
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
              Expanded(
                child: _ProductGrid(
                  categoryId: _selectedCategory,
                  searchQuery: _searchQuery,
                  onProductTap: _addToCart,
                ),
              ),
            ],
          ),
        ),
        // Right: Order summary (1/3 width)
        SizedBox(
          width: 340,
          child: _OrderSummaryPanel(
            onCheckout: () => _goToPayment(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLayout() {
    return Column(
      children: [
        _SearchBar(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
        _CategoryBar(
          selected: _selectedCategory,
          onChanged: (v) => setState(() => _selectedCategory = v),
        ),
        Expanded(
          child: _ProductGrid(
            categoryId: _selectedCategory,
            searchQuery: _searchQuery,
            onProductTap: _addToCart,
          ),
        ),
        _CartBottomBar(onCheckout: _goToPayment),
      ],
    );
  }

  void _addToCart(Product product) {
    if (product.isOutOfStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} is out of stock')),
      );
      return;
    }
    ref.read(cartNotifierProvider.notifier).addItem(
          CartItem(
            productId: product.id,
            productName: product.name,
            unitPrice: product.sellPrice,
            quantity: 1,
          ),
        );
  }

  void _handleBarcode(String barcode) {
    final products = ref.read(productListProvider).valueOrNull ?? [];
    final product = products.firstWhere(
      (p) => p.barcode == barcode,
      orElse: () => const Product(id: '', name: '', sellPrice: 0),
    );
    if (product.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product not found: $barcode'),
          action: SnackBarAction(label: 'Add', onPressed: () {}),
        ),
      );
      return;
    }
    _addToCart(product);
  }

  void _goToPayment() {
    final cart = ref.read(cartNotifierProvider);
    if (cart.isEmpty) return;
    context.go('/pos/payment/new');
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Search or scan barcode...',
          prefixIcon: Icon(Icons.search),
          isDense: true,
        ),
      ),
    );
  }
}

// ─── Category Bar ─────────────────────────────────────────────────────────────

class _CategoryBar extends ConsumerWidget {
  const _CategoryBar({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);
    return SizedBox(
      height: 44,
      child: categoriesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (cats) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            _CatChip(label: 'All', selected: selected == 'all', onTap: () => onChanged('all')),
            ...cats.map((c) => _CatChip(
                  label: c.name,
                  selected: selected == c.id,
                  onTap: () => onChanged(c.id),
                )),
          ],
        ),
      ),
    );
  }
}

class _CatChip extends StatelessWidget {
  const _CatChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
    );
  }
}

// ─── Product Grid ─────────────────────────────────────────────────────────────

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({
    required this.categoryId,
    required this.searchQuery,
    required this.onProductTap,
  });

  final String categoryId;
  final String searchQuery;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (products) {
        final filtered = products.where((p) {
          if (!p.isActive) return false;
          final matchSearch = searchQuery.isEmpty ||
              p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              (p.barcode?.contains(searchQuery) ?? false);
          final matchCat = categoryId == 'all' || p.categoryIds.contains(categoryId);
          return matchSearch && matchCat;
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _ProductCard(
            product: filtered[i],
            onTap: () => onProductTap(filtered[i]),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnavailable = product.isOutOfStock;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isUnavailable ? null : onTap,
        child: Opacity(
          opacity: isUnavailable ? 0.5 : 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        product.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  isUnavailable ? 'Out of Stock' : '${product.sellPrice.toStringAsFixed(0)} ₭',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isUnavailable ? Colors.red : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Order Summary Panel ──────────────────────────────────────────────────────

class _OrderSummaryPanel extends ConsumerWidget {
  const _OrderSummaryPanel({required this.onCheckout});
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Text('Order', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (!cart.isEmpty)
                  TextButton.icon(
                    onPressed: () => ref.read(cartNotifierProvider.notifier).clear(),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
          ),

          // Items
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 48, color: theme.colorScheme.outlineVariant),
                        const SizedBox(height: 8),
                        Text('No items', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) => _CartItemTile(item: cart.items[i]),
                  ),
          ),

          // Totals
          if (!cart.isEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _TotalRow(label: 'Subtotal', value: cart.subtotal),
                  if (cart.orderDiscount > 0)
                    _TotalRow(label: 'Discount', value: -cart.orderDiscount, isNegative: true),
                  if (cart.taxAmount > 0)
                    _TotalRow(label: 'Tax', value: cart.taxAmount),
                  const Divider(),
                  _TotalRow(label: 'TOTAL', value: cart.total, isBold: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onCheckout,
                      icon: const Icon(Icons.payment),
                      label: Text('Pay ${cart.total.toStringAsFixed(0)} ₭'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartNotifierProvider.notifier);

    return ListTile(
      dense: true,
      title: Text(item.productName, style: const TextStyle(fontSize: 13)),
      subtitle: Text('${item.unitPrice.toStringAsFixed(0)} ₭ × ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${item.lineTotal.toStringAsFixed(0)} ₭',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(width: 4),
          // Quantity controls
          SizedBox(
            width: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: () => notifier.updateQuantity(item.productId, item.variantId, item.quantity - 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
                Text('${item.quantity}', style: const TextStyle(fontSize: 13)),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () => notifier.updateQuantity(item.productId, item.variantId, item.quantity + 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value, this.isBold = false, this.isNegative = false});
  final String label;
  final double value;
  final bool isBold;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(
            '${isNegative ? '-' : ''}${value.abs().toStringAsFixed(0)} ₭',
            style: style?.copyWith(color: isNegative ? Colors.red : null),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Bottom Bar (phone) ──────────────────────────────────────────────────

class _CartBottomBar extends ConsumerWidget {
  const _CartBottomBar({required this.onCheckout});
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);
    if (cart.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Text('${cart.itemCount} items', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          FilledButton(
            onPressed: onCheckout,
            child: Text('Pay ${cart.total.toStringAsFixed(0)} ₭'),
          ),
        ],
      ),
    );
  }
}
