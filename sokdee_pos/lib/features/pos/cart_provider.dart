import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/features/pos/cart_model.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  CartState build() => const CartState();

  // ─── Item management ────────────────────────────────────────────────────────

  void addItem(CartItem item) {
    final items = List<CartItem>.from(state.items);
    final idx = _findIndex(item.productId, item.variantId);

    if (idx >= 0) {
      // Increment quantity if same product+variant
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + item.quantity);
    } else {
      items.add(item);
    }
    state = state.copyWith(items: items);
  }

  void updateQuantity(String productId, String? variantId, int qty) {
    if (qty <= 0) {
      removeItem(productId, variantId);
      return;
    }
    final items = List<CartItem>.from(state.items);
    final idx = _findIndex(productId, variantId);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: qty);
      state = state.copyWith(items: items);
    }
  }

  void removeItem(String productId, String? variantId) {
    final items = state.items
        .where((i) => !(i.productId == productId && i.variantId == variantId))
        .toList();
    state = state.copyWith(items: items);
  }

  void applyItemDiscount(String productId, String? variantId, double discount) {
    final items = List<CartItem>.from(state.items);
    final idx = _findIndex(productId, variantId);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(discount: discount);
      state = state.copyWith(items: items);
    }
  }

  void setItemNotes(String productId, String? variantId, String notes) {
    final items = List<CartItem>.from(state.items);
    final idx = _findIndex(productId, variantId);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(notes: notes);
      state = state.copyWith(items: items);
    }
  }

  // ─── Order-level ────────────────────────────────────────────────────────────

  void applyOrderDiscount(double discount) {
    state = state.copyWith(orderDiscount: discount);
  }

  void setTable(String? tableId) {
    state = state.copyWith(tableId: tableId);
  }

  void setOrderId(String orderId) {
    state = state.copyWith(orderId: orderId);
  }

  void clear() {
    state = const CartState();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  int _findIndex(String productId, String? variantId) {
    return state.items.indexWhere(
      (i) => i.productId == productId && i.variantId == variantId,
    );
  }

  Map<String, dynamic> toOrderPayload() => {
        if (state.tableId != null) 'table_id': state.tableId,
        'items': state.items.map((i) => i.toJson()).toList(),
        'discount_amount': state.orderDiscount,
        'tax_amount': state.taxAmount,
        'total': state.total,
        'subtotal': state.subtotal,
      };
}
