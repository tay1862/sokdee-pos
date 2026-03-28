import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'reports_screen.g.dart';

@riverpod
Future<Map<String, dynamic>> dailySalesReport(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  return client.get('/reports/sales/daily');
}

@riverpod
Future<Map<String, dynamic>> monthlySalesReport(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  return client.get('/reports/sales/monthly');
}

@riverpod
Future<Map<String, dynamic>> stockReport(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  return client.get('/reports/stock');
}

@riverpod
Future<Map<String, dynamic>> pnlReport(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  return client.get('/reports/pnl');
}

@riverpod
Future<Map<String, dynamic>> cashierReport(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  return client.get('/reports/cashier');
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isOwner {
    final auth = ref.read(currentAuthProvider);
    return auth is AuthAuthenticated && auth.role == 'owner';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Monthly'),
            Tab(text: 'Stock'),
            Tab(text: 'Cashier'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: _exportReport,
            tooltip: 'Export',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DailyTab(),
          _MonthlyTab(),
          _StockTab(),
          _CashierTab(),
        ],
      ),
    );
  }

  void _exportReport() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Export Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as CSV'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Daily Tab ────────────────────────────────────────────────────────────────

class _DailyTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(dailySalesReportProvider);
    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(
            title: 'Today\'s Sales',
            value: '${(data['total_sales'] as num?)?.toStringAsFixed(0) ?? '0'} ₭',
            subtitle: '${data['transaction_count'] ?? 0} transactions',
            icon: Icons.point_of_sale,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _PaymentBreakdown(data: data['by_payment_method'] as Map<String, dynamic>? ?? {}),
          const SizedBox(height: 12),
          _TopProductsList(products: data['top_products'] as List<dynamic>? ?? []),
        ],
      ),
    );
  }
}

// ─── Monthly Tab ──────────────────────────────────────────────────────────────

class _MonthlyTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(monthlySalesReportProvider);
    final pnlAsync = ref.watch(pnlReportProvider);
    final isOwner = ref.watch(hasRoleProvider('owner'));

    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(
            title: 'This Month',
            value: '${(data['total_sales'] as num?)?.toStringAsFixed(0) ?? '0'} ₭',
            subtitle: 'vs last month: ${(data['prev_month_sales'] as num?)?.toStringAsFixed(0) ?? '0'} ₭',
            icon: Icons.calendar_month,
            color: Colors.green,
          ),
          if (isOwner) ...[
            const SizedBox(height: 12),
            pnlAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
              data: (pnl) => _SummaryCard(
                title: 'Gross Profit',
                value: '${(pnl['gross_profit'] as num?)?.toStringAsFixed(0) ?? '0'} ₭',
                subtitle: 'Margin: ${(pnl['gross_margin_pct'] as num?)?.toStringAsFixed(1) ?? '0'}%',
                icon: Icons.trending_up,
                color: Colors.purple,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Stock Tab ────────────────────────────────────────────────────────────────

class _StockTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(stockReportProvider);
    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Products',
                  value: '${data['total_products'] ?? 0}',
                  icon: Icons.inventory_2_outlined,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Stock Value',
                  value: '${(data['total_value'] as num?)?.toStringAsFixed(0) ?? '0'} ₭',
                  icon: Icons.attach_money,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if ((data['low_stock_items'] as List?)?.isNotEmpty == true) ...[
            Text('Low Stock', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...(data['low_stock_items'] as List<dynamic>).map(
              (item) => _StockItemTile(item: item as Map<String, dynamic>, isLow: true),
            ),
          ],
          if ((data['out_of_stock_items'] as List?)?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text('Out of Stock', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...(data['out_of_stock_items'] as List<dynamic>).map(
              (item) => _StockItemTile(item: item as Map<String, dynamic>, isLow: false),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Cashier Tab ──────────────────────────────────────────────────────────────

class _CashierTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(cashierReportProvider);
    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (data) {
        final cashiers = data['cashiers'] as List<dynamic>? ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cashiers.length,
          itemBuilder: (_, i) {
            final c = cashiers[i] as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(child: Text((c['cashier_name'] as String? ?? '?').substring(0, 1))),
                title: Text(c['cashier_name'] as String? ?? ''),
                subtitle: Text('${c['transaction_count']} txns • Avg: ${(c['avg_transaction'] as num?)?.toStringAsFixed(0) ?? '0'} ₭'),
                trailing: Text(
                  '${(c['total_sales'] as num?)?.toStringAsFixed(0) ?? '0'} ₭',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });
  final String title, value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: color)),
                  if (subtitle != null)
                    Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentBreakdown extends StatelessWidget {
  const _PaymentBreakdown({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By Payment Method', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...data.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text(e.key.toUpperCase()),
                    const Spacer(),
                    Text('${(e.value as num).toStringAsFixed(0)} ₭',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopProductsList extends StatelessWidget {
  const _TopProductsList({required this.products});
  final List<dynamic> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Products', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...products.take(5).map((p) {
              final product = p as Map<String, dynamic>;
              return ListTile(
                dense: true,
                title: Text(product['product_name'] as String? ?? ''),
                subtitle: Text('Qty: ${product['quantity']}'),
                trailing: Text('${(product['revenue'] as num?)?.toStringAsFixed(0) ?? '0'} ₭'),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StockItemTile extends StatelessWidget {
  const _StockItemTile({required this.item, required this.isLow});
  final Map<String, dynamic> item;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(
        isLow ? Icons.warning_amber : Icons.remove_circle_outline,
        color: isLow ? Colors.orange : Colors.red,
        size: 20,
      ),
      title: Text(item['product_name'] as String? ?? ''),
      trailing: Text(
        'Stock: ${item['stock_qty']}',
        style: TextStyle(color: isLow ? Colors.orange : Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
