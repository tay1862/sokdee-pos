import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';
import 'package:sokdee_pos/features/inventory/inventory_provider.dart';
import 'package:sokdee_pos/features/pos/cart_model.dart';
import 'package:sokdee_pos/features/pos/cart_provider.dart';

part 'order_screen.g.dart';

// ─── Active order provider ────────────────────────────────────────────────────

@riverpod
Future<Map<String, dynamic>?> activeTableOrder(Ref ref, String tableId) async {
  final client = ref.watch(apiClientProvider);
  try {
    final data = await client.get('/orders', queryParams: {
      'table_id': tableId,
      'status': 'open',
    });
    final orders = data['orders'] as List<dynamic>? ?? [];
    if (orders.isEmpty) return null;
    return orders.first as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

// ─── Order Screen ─────────────────────────────────────────────────────────────

/// Restaurant order screen — supports multiple rounds of ordering per table.
class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key, this.tableId});
  final String? tableId;

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isSendingToKds = false;

  @override
  Widget build(BuildContext context) {
    final tableId = widget.tableId;
    final cart = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tableId != null ? 'Table $tableId' : 'Order'),
        actions: [
          if (cart.isNotEmpty)
            TextButton.icon(
              onPressed: () => ref.read(cartNotifierProvider.notifier).clear(),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
        ],
      ),
      body: Row(
        children: [
          // Left: product selection
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _SearchBar(
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
          // Right: current round summary
          SizedBox(
            width: 300,
            child: _RoundSummary(
              tableId: tableId,
              isSending: _isSendingToKds,
              onSendToKitchen: () => _sendToKitchen(),
              onCheckout: () => context.go('/pos/payment/new'),
            ),
          ),
        ],
      ),
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

  Future<void> _sendToKitchen() async {
    final cart = ref.read(cartNotifierProvider);
    if (cart.isEmpty) return;

    setState(() => _isSendingToKds = true);
    try {
      final client = ref.read(apiClientProvider);
      final tableId = widget.tableId;

      // Get or create order for this table
      String orderId;
      final existing = tableId != null
          ? await ref.read(activeTableOrderProvider(tableId).future)
          : null;

      if (existing != null) {
        orderId = existing['id'] as String;
        // Add new items to existing order
        await client.patch('/orders/$orderId', body: {
          'items': cart.items.map((i) => i.toJson()).toList(),
        });
      } else {
        final resp = await client.post('/orders', body: {
          if (tableId != null) 'table_id': tableId,
          ...cart.toOrderPayload(),
        });
        orderId = resp['id'] as String;
      }

      ref.read(cartNotifierProvider.notifier).setOrderId(orderId);
      ref.read(cartNotifierProvider.notifier).clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order sent to kitchen'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingToKds = false);
    }
  }
}

// ─── Round Summary Panel ──────────────────────────────────────────────────────

class _RoundSummary extends ConsumerWidget {
  const _RoundSummary({
    required this.tableId,
    required this.isSending,
    required this.onSendToKitchen,
    required this.onCheckout,
  });

  final String? tableId;
  final bool isSending;
  final VoidCallback onSendToKitchen;
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
          Container(
            padding: const EdgeInsets.all(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Text('New Round', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${cart.itemCount} items', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      'Add items for this round',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      return ListTile(
                        dense: true,
                        title: Text(item.productName, style: const TextStyle(fontSize: 13)),
                        subtitle: Text('${item.unitPrice.toStringAsFixed(0)} ₭'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () => ref.read(cartNotifierProvider.notifier)
                                  .updateQuantity(item.productId, item.variantId, item.quantity - 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => ref.read(cartNotifierProvider.notifier)
                                  .updateQuantity(item.productId, item.variantId, item.quantity + 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (!cart.isEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Subtotal'),
                      const Spacer(),
                      Text('${cart.subtotal.toStringAsFixed(0)} ₭',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Send to kitchen button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSending ? null : onSendToKitchen,
                      icon: isSending
                          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send),
                      label: const Text('Send to Kitchen'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onCheckout,
                      icon: const Icon(Icons.payment),
                      label: const Text('Checkout'),
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

// ─── Reused widgets ───────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          isDense: true,
        ),
      ),
    );
  }
}

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
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(label: const Text('All'), selected: selected == 'all', onSelected: (_) => onChanged('all')),
            ),
            ...cats.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(label: Text(c.name), selected: selected == c.id, onSelected: (_) => onChanged(c.id)),
                )),
          ],
        ),
      ),
    );
  }
}

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.categoryId, required this.searchQuery, required this.onProductTap});
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
          final matchSearch = searchQuery.isEmpty || p.name.toLowerCase().contains(searchQuery.toLowerCase());
          final matchCat = categoryId == 'all' || p.categoryIds.contains(categoryId);
          return matchSearch && matchCat;
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: filtered.length,
          itemBuilder: (_, i) {
            final p = filtered[i];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: p.isOutOfStock ? null : () => onProductTap(p),
                child: Opacity(
                  opacity: p.isOutOfStock ? 0.5 : 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(p.name.substring(0, 1).toUpperCase()),
                        ),
                        const SizedBox(height: 6),
                        Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        Text('${p.sellPrice.toStringAsFixed(0)} ₭',
                            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
