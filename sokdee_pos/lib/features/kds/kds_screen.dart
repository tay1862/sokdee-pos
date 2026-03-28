import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/utils/printer_service.dart';
import 'package:sokdee_pos/features/kds/kds_provider.dart';

class KdsScreen extends ConsumerStatefulWidget {
  const KdsScreen({super.key});

  @override
  ConsumerState<KdsScreen> createState() => _KdsScreenState();
}

class _KdsScreenState extends ConsumerState<KdsScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Refresh every minute to update elapsed time colors
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kds = ref.watch(kdsNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        title: const Text('Kitchen Display', style: TextStyle(color: Colors.white)),
        actions: [
          // Connection status
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  kds.isConnected ? Icons.wifi : Icons.wifi_off,
                  color: kds.isConnected ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  kds.isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: kds.isConnected ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Pending count badges
          if (kds.orders.isNotEmpty) ...[
            _CountBadge(
              count: kds.orders.where((o) => o.urgency == KdsOrderUrgency.urgent).length,
              color: Colors.red,
            ),
            _CountBadge(
              count: kds.orders.where((o) => o.urgency == KdsOrderUrgency.warning).length,
              color: Colors.yellow,
            ),
          ],
        ],
      ),
      body: kds.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey.shade600),
                  const SizedBox(height: 16),
                  Text(
                    'No pending orders',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 20),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: kds.orders.length,
              itemBuilder: (_, i) => _KdsOrderCard(order: kds.orders[i]),
            ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────

class _KdsOrderCard extends ConsumerWidget {
  const _KdsOrderCard({required this.order});
  final KdsOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderColor = _urgencyColor(order.urgency);
    final elapsed = order.elapsed;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Text(
                  'Table ${order.tableNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatElapsed(elapsed),
                  style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: order.items.length,
              itemBuilder: (_, i) => _KdsItemRow(
                item: order.items[i],
                onDone: () => ref.read(kdsNotifierProvider.notifier)
                    .markItemDone(order.orderId, order.items[i].id),
              ),
            ),
          ),

          // Print button
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _printTicket(order),
                icon: const Icon(Icons.print, size: 16, color: Colors.white70),
                label: const Text('Print', style: TextStyle(color: Colors.white70)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _urgencyColor(KdsOrderUrgency urgency) {
    switch (urgency) {
      case KdsOrderUrgency.urgent:
        return Colors.red;
      case KdsOrderUrgency.warning:
        return Colors.yellow;
      case KdsOrderUrgency.normal:
        return Colors.green;
    }
  }

  String _formatElapsed(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }

  void _printTicket(KdsOrder order) {
    final ticket = KDSTicketData(
      tableNumber: order.tableNumber,
      orderNumber: order.orderId,
      receivedAt: order.receivedAt,
      items: order.items
          .map((i) => KDSTicketItem(
                name: i.name,
                quantity: i.quantity,
                notes: i.notes,
                modifiers: i.modifiers,
              ))
          .toList(),
    );
    // In production: use PrinterFactory.create(...).printKDSTicket(ticket)
    _ = ticket; // suppress unused warning
  }
}

// ─── Item Row ─────────────────────────────────────────────────────────────────

class _KdsItemRow extends StatelessWidget {
  const _KdsItemRow({required this.item, required this.onDone});
  final KdsItem item;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final isDone = item.status == KdsItemStatus.done;

    return GestureDetector(
      onTap: isDone ? null : onDone,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.withOpacity(0.15) : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDone ? Colors.green : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.quantity}× ${item.name}',
                    style: TextStyle(
                      color: isDone ? Colors.green : Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (item.modifiers.isNotEmpty)
                    Text(
                      item.modifiers.join(', '),
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  if (item.notes != null)
                    Text(
                      '* ${item.notes}',
                      style: const TextStyle(color: Colors.orange, fontSize: 11),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Count Badge ──────────────────────────────────────────────────────────────

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text('$count', style: const TextStyle(fontSize: 11, color: Colors.black)),
        backgroundColor: color,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
