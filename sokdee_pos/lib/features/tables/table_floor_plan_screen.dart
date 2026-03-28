import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokdee_pos/features/tables/table_provider.dart';

class TableFloorPlanScreen extends ConsumerStatefulWidget {
  const TableFloorPlanScreen({super.key});

  @override
  ConsumerState<TableFloorPlanScreen> createState() =>
      _TableFloorPlanScreenState();
}

class _TableFloorPlanScreenState extends ConsumerState<TableFloorPlanScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh every 30 seconds to update elapsed times
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidate(tableListProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tableListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floor Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(tableListProvider),
          ),
        ],
      ),
      body: tablesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tables) {
          if (tables.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tables configured'),
                  Text('Add tables in Settings', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // Group by zone
          final zones = <String, List<RestaurantTable>>{};
          for (final t in tables) {
            final zone = t.zone ?? 'Main';
            zones.putIfAbsent(zone, () => []).add(t);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Legend
                _Legend(),
                const SizedBox(height: 16),
                // Zones
                ...zones.entries.map(
                  (e) => _ZoneSection(
                    zoneName: e.key,
                    tables: e.value,
                    onTableTap: (table) => _onTableTap(table),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onTableTap(RestaurantTable table) async {
    switch (table.status) {
      case TableStatus.available:
        // Open new order for this table
        final orderId = await ref
            .read(tableActionsProvider.notifier)
            .openTable(table.id);
        if (orderId != null && mounted) {
          context.go('/pos/order/${table.id}');
        }
      case TableStatus.occupied:
      case TableStatus.waitingPayment:
        // Go to existing order
        context.go('/pos/order/${table.id}');
    }
  }
}

// ─── Zone Section ─────────────────────────────────────────────────────────────

class _ZoneSection extends StatelessWidget {
  const _ZoneSection({
    required this.zoneName,
    required this.tables,
    required this.onTableTap,
  });

  final String zoneName;
  final List<RestaurantTable> tables;
  final ValueChanged<RestaurantTable> onTableTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            zoneName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: tables.length,
          itemBuilder: (_, i) => _TableCard(
            table: tables[i],
            onTap: () => onTableTap(tables[i]),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Table Card ───────────────────────────────────────────────────────────────

class _TableCard extends StatelessWidget {
  const _TableCard({required this.table, required this.onTap});

  final RestaurantTable table;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(table.status);
    final duration = table.occupiedDuration;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.table_restaurant, color: color, size: 32),
              const SizedBox(height: 4),
              Text(
                table.tableNumber,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (duration != null) ...[
                const SizedBox(height: 2),
                Text(
                  _formatDuration(duration),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _durationColor(duration),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else
                Text(
                  _statusLabel(table.status),
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.blue;
      case TableStatus.waitingPayment:
        return Colors.orange;
    }
  }

  String _statusLabel(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.waitingPayment:
        return 'Waiting';
    }
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }

  Color _durationColor(Duration d) {
    if (d.inMinutes > 90) return Colors.red;
    if (d.inMinutes > 60) return Colors.orange;
    return Colors.blue;
  }
}

// ─── Legend ───────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: [
        _LegendItem(color: Colors.green, label: 'Available'),
        _LegendItem(color: Colors.blue, label: 'Occupied'),
        _LegendItem(color: Colors.orange, label: 'Waiting Payment'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
