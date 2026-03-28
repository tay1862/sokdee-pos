import 'package:equatable/equatable.dart';

// ─── Cart Item ────────────────────────────────────────────────────────────────

class CartItem extends Equatable {
  const CartItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.variantId,
    this.variantName,
    this.discount = 0,
    this.notes,
    this.modifiers = const [],
  });

  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final double discount;
  final String? notes;
  final List<String> modifiers;

  double get lineTotal => (unitPrice * quantity) - discount;

  CartItem copyWith({
    int? quantity,
    double? discount,
    String? notes,
    List<String>? modifiers,
  }) =>
      CartItem(
        productId: productId,
        productName: productName,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        variantId: variantId,
        variantName: variantName,
        discount: discount ?? this.discount,
        notes: notes ?? this.notes,
        modifiers: modifiers ?? this.modifiers,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'unit_price': unitPrice,
        'quantity': quantity,
        if (variantId != null) 'variant_id': variantId,
        'discount': discount,
        if (notes != null) 'notes': notes,
        'modifiers': modifiers,
        'line_total': lineTotal,
      };

  @override
  List<Object?> get props => [productId, variantId, quantity, discount, notes, modifiers];
}

// ─── Cart State ───────────────────────────────────────────────────────────────

class CartState extends Equatable {
  const CartState({
    this.items = const [],
    this.orderDiscount = 0,
    this.taxRate = 0,
    this.tableId,
    this.orderId,
  });

  final List<CartItem> items;
  final double orderDiscount;
  final double taxRate;
  final String? tableId;
  final String? orderId;

  double get subtotal => items.fold(0, (sum, i) => sum + i.lineTotal);
  double get taxAmount => subtotal * taxRate;
  double get total => subtotal - orderDiscount + taxAmount;

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  CartState copyWith({
    List<CartItem>? items,
    double? orderDiscount,
    double? taxRate,
    String? tableId,
    String? orderId,
  }) =>
      CartState(
        items: items ?? this.items,
        orderDiscount: orderDiscount ?? this.orderDiscount,
        taxRate: taxRate ?? this.taxRate,
        tableId: tableId ?? this.tableId,
        orderId: orderId ?? this.orderId,
      );

  @override
  List<Object?> get props => [items, orderDiscount, taxRate, tableId, orderId];
}
