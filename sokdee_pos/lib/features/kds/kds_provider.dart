import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';

part 'kds_provider.g.dart';

// ─── KDS Order Model ──────────────────────────────────────────────────────────

enum KdsItemStatus { pending, preparing, done }

class KdsItem {
  KdsItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.notes,
    this.modifiers = const [],
    this.status = KdsItemStatus.pending,
  });

  final String id;
  final String name;
  final int quantity;
  final String? notes;
  final List<String> modifiers;
  KdsItemStatus status;
}

class KdsOrder {
  KdsOrder({
    required this.orderId,
    required this.tableNumber,
    required this.items,
    required this.receivedAt,
  });

  final String orderId;
  final String tableNumber;
  final List<KdsItem> items;
  final DateTime receivedAt;

  Duration get elapsed => DateTime.now().difference(receivedAt);

  bool get allDone => items.every((i) => i.status == KdsItemStatus.done);

  KdsOrderUrgency get urgency {
    final mins = elapsed.inMinutes;
    if (mins >= 30) return KdsOrderUrgency.urgent;
    if (mins >= 15) return KdsOrderUrgency.warning;
    return KdsOrderUrgency.normal;
  }
}

enum KdsOrderUrgency { normal, warning, urgent }

// ─── KDS State ────────────────────────────────────────────────────────────────

class KdsState {
  const KdsState({
    this.orders = const [],
    this.isConnected = false,
  });

  final List<KdsOrder> orders;
  final bool isConnected;

  KdsState copyWith({List<KdsOrder>? orders, bool? isConnected}) => KdsState(
        orders: orders ?? this.orders,
        isConnected: isConnected ?? this.isConnected,
      );
}

// ─── KDS Notifier ─────────────────────────────────────────────────────────────

@riverpod
class KdsNotifier extends _$KdsNotifier {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  static const _wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://localhost:8080/ws/kds',
  );

  @override
  KdsState build() {
    ref.onDispose(_disconnect);
    _connect();
    return const KdsState();
  }

  Future<void> _connect() async {
    final auth = ref.read(currentAuthProvider);
    if (auth is! AuthAuthenticated) return;

    final token = auth.accessToken;
    final uri = Uri.parse('$_wsBaseUrl?token=$token');

    try {
      _channel = WebSocketChannel.connect(uri);
      state = state.copyWith(isConnected: true);

      _sub = _channel!.stream.listen(
        _onMessage,
        onError: (_) => state = state.copyWith(isConnected: false),
        onDone: () => state = state.copyWith(isConnected: false),
      );
    } catch (_) {
      state = state.copyWith(isConnected: false);
    }
  }

  void _disconnect() {
    _sub?.cancel();
    _channel?.sink.close();
  }

  void _onMessage(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = json['type'] as String;
      final payload = json['payload'] as Map<String, dynamic>? ?? {};

      switch (type) {
        case 'new_order':
          _handleNewOrder(payload);
        case 'add_items':
          _handleAddItems(payload);
        case 'item_ready':
          _handleItemReady(payload);
        case 'order_ready':
          _handleOrderReady(payload);
      }
    } catch (_) {}
  }

  void _handleNewOrder(Map<String, dynamic> payload) {
    final orderId = payload['order_id'] as String;
    final table = payload['table'] as String? ?? '';
    final rawItems = payload['items'] as List<dynamic>? ?? [];
    final receivedAt = DateTime.tryParse(payload['received_at'] as String? ?? '') ?? DateTime.now();

    final items = rawItems.map((i) {
      final m = i as Map<String, dynamic>;
      return KdsItem(
        id: m['id'] as String? ?? orderId + m['name'].toString(),
        name: m['name'] as String? ?? '',
        quantity: m['quantity'] as int? ?? 1,
        notes: m['notes'] as String?,
        modifiers: (m['modifiers'] as List<dynamic>?)?.cast<String>() ?? [],
      );
    }).toList();

    final orders = List<KdsOrder>.from(state.orders)
      ..add(KdsOrder(
        orderId: orderId,
        tableNumber: table,
        items: items,
        receivedAt: receivedAt,
      ));
    state = state.copyWith(orders: orders);
  }

  void _handleAddItems(Map<String, dynamic> payload) {
    final orderId = payload['order_id'] as String;
    final rawItems = payload['items'] as List<dynamic>? ?? [];
    final orders = List<KdsOrder>.from(state.orders);
    final idx = orders.indexWhere((o) => o.orderId == orderId);
    if (idx < 0) return;

    final newItems = rawItems.map((i) {
      final m = i as Map<String, dynamic>;
      return KdsItem(
        id: m['id'] as String? ?? orderId + m['name'].toString(),
        name: m['name'] as String? ?? '',
        quantity: m['quantity'] as int? ?? 1,
        notes: m['notes'] as String?,
      );
    }).toList();

    orders[idx].items.addAll(newItems);
    state = state.copyWith(orders: orders);
  }

  void _handleItemReady(Map<String, dynamic> payload) {
    final orderId = payload['order_id'] as String;
    final itemId = payload['item_id'] as String;
    final orders = List<KdsOrder>.from(state.orders);
    final orderIdx = orders.indexWhere((o) => o.orderId == orderId);
    if (orderIdx < 0) return;

    final item = orders[orderIdx].items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => KdsItem(id: '', name: '', quantity: 0),
    );
    if (item.id.isNotEmpty) {
      item.status = KdsItemStatus.done;
    }
    state = state.copyWith(orders: orders);
  }

  void _handleOrderReady(Map<String, dynamic> payload) {
    final orderId = payload['order_id'] as String;
    final orders = state.orders.where((o) => o.orderId != orderId).toList();
    state = state.copyWith(orders: orders);
  }

  /// Mark an item as done and broadcast to hub
  void markItemDone(String orderId, String itemId) {
    _sendMessage({'type': 'item_ready', 'payload': {'order_id': orderId, 'item_id': itemId}});
    _handleItemReady({'order_id': orderId, 'item_id': itemId});

    // Check if all items done → broadcast order_ready
    final order = state.orders.firstWhere(
      (o) => o.orderId == orderId,
      orElse: () => KdsOrder(orderId: '', tableNumber: '', items: [], receivedAt: DateTime.now()),
    );
    if (order.orderId.isNotEmpty && order.allDone) {
      _sendMessage({'type': 'order_ready', 'payload': {'order_id': orderId, 'table': order.tableNumber}});
      _handleOrderReady({'order_id': orderId});
    }
  }

  void _sendMessage(Map<String, dynamic> msg) {
    try {
      _channel?.sink.add(jsonEncode(msg));
    } catch (_) {}
  }
}
