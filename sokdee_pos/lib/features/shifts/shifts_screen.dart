import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'shifts_screen.g.dart';

class ShiftSummary {
  const ShiftSummary({
    required this.shiftId,
    required this.totalSales,
    required this.totalCash,
    required this.totalQr,
    required this.totalTransfer,
    required this.expectedCash,
    required this.actualCash,
    required this.cashDifference,
    required this.transactionCount,
    required this.voidCount,
    required this.refundCount,
  });
  final String shiftId;
  final double totalSales, totalCash, totalQr, totalTransfer;
  final double expectedCash, actualCash, cashDifference;
  final int transactionCount, voidCount, refundCount;

  factory ShiftSummary.fromJson(Map<String, dynamic> j) => ShiftSummary(
        shiftId: j['shift_id'] as String? ?? '',
        totalSales: (j['total_sales'] as num?)?.toDouble() ?? 0,
        totalCash: (j['total_cash'] as num?)?.toDouble() ?? 0,
        totalQr: (j['total_qr'] as num?)?.toDouble() ?? 0,
        totalTransfer: (j['total_transfer'] as num?)?.toDouble() ?? 0,
        expectedCash: (j['expected_cash'] as num?)?.toDouble() ?? 0,
        actualCash: (j['actual_cash'] as num?)?.toDouble() ?? 0,
        cashDifference: (j['cash_difference'] as num?)?.toDouble() ?? 0,
        transactionCount: j['transaction_count'] as int? ?? 0,
        voidCount: j['void_count'] as int? ?? 0,
        refundCount: j['refund_count'] as int? ?? 0,
      );
}

@riverpod
Future<List<Map<String, dynamic>>> shiftList(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/shifts');
  final list = data['shifts'] as List<dynamic>? ?? [];
  return list.cast<Map<String, dynamic>>();
}

class ShiftsScreen extends ConsumerStatefulWidget {
  const ShiftsScreen({super.key});

  @override
  ConsumerState<ShiftsScreen> createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends ConsumerState<ShiftsScreen> {
  final _openingCtrl = TextEditingController();
  final _closingCtrl = TextEditingController();
  bool _isLoading = false;
  String? _message;
  ShiftSummary? _lastSummary;
  String? _activeShiftId;

  @override
  void dispose() {
    _openingCtrl.dispose();
    _closingCtrl.dispose();
    super.dispose();
  }

  Future<void> _openShift() async {
    setState(() { _isLoading = true; _message = null; });
    try {
      final client = ref.read(apiClientProvider);
      final resp = await client.post('/shifts/open', body: {
        'opening_balance': double.tryParse(_openingCtrl.text) ?? 0,
      });
      setState(() {
        _activeShiftId = resp['id'] as String?;
        _message = 'Shift opened successfully';
      });
      ref.invalidate(shiftListProvider);
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _closeShift() async {
    if (_activeShiftId == null) return;
    setState(() { _isLoading = true; _message = null; });
    try {
      final client = ref.read(apiClientProvider);
      final resp = await client.post('/shifts/$_activeShiftId/close', body: {
        'closing_balance': double.tryParse(_closingCtrl.text) ?? 0,
      });
      final summaryJson = resp['summary'] as Map<String, dynamic>?;
      setState(() {
        _lastSummary = summaryJson != null ? ShiftSummary.fromJson(summaryJson) : null;
        _activeShiftId = null;
        _message = 'Shift closed';
      });
      ref.invalidate(shiftListProvider);
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shiftsAsync = ref.watch(shiftListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shift Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Open/Close shift card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_activeShiftId == null ? 'Open New Shift' : 'Close Current Shift',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (_activeShiftId == null) ...[
                      TextField(
                        controller: _openingCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Opening Balance (₭)'),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _openShift,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Open Shift'),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: _closingCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Closing Balance (₭)'),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _closeShift,
                          icon: const Icon(Icons.stop),
                          label: const Text('Close Shift'),
                          style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                        ),
                      ),
                    ],
                    if (_message != null) ...[
                      const SizedBox(height: 8),
                      Text(_message!,
                          style: TextStyle(
                              color: _message!.startsWith('Error') ? Colors.red : Colors.green)),
                    ],
                  ],
                ),
              ),
            ),

            // Last shift summary
            if (_lastSummary != null) ...[
              const SizedBox(height: 16),
              _ShiftSummaryCard(summary: _lastSummary!),
            ],

            // Shift history
            const SizedBox(height: 16),
            Text('Shift History', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            shiftsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (shifts) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shifts.length,
                itemBuilder: (_, i) {
                  final s = shifts[i];
                  return ListTile(
                    leading: Icon(
                      s['status'] == 'open' ? Icons.play_circle : Icons.stop_circle,
                      color: s['status'] == 'open' ? Colors.green : Colors.grey,
                    ),
                    title: Text('Shift ${(s['id'] as String).substring(0, 8)}...'),
                    subtitle: Text('${s['status']} • ${s['opened_at']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShiftSummaryCard extends StatelessWidget {
  const _ShiftSummaryCard({required this.summary});
  final ShiftSummary summary;

  @override
  Widget build(BuildContext context) {
    final diff = summary.cashDifference;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shift Summary', style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            _Row('Total Sales', '${summary.totalSales.toStringAsFixed(0)} ₭'),
            _Row('Cash', '${summary.totalCash.toStringAsFixed(0)} ₭'),
            _Row('QR', '${summary.totalQr.toStringAsFixed(0)} ₭'),
            _Row('Transfer', '${summary.totalTransfer.toStringAsFixed(0)} ₭'),
            const Divider(),
            _Row('Expected Cash', '${summary.expectedCash.toStringAsFixed(0)} ₭'),
            _Row('Actual Cash', '${summary.actualCash.toStringAsFixed(0)} ₭'),
            _Row(
              'Difference',
              '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(0)} ₭',
              valueColor: diff < 0 ? Colors.red : diff > 0 ? Colors.orange : Colors.green,
            ),
            const Divider(),
            _Row('Transactions', '${summary.transactionCount}'),
            _Row('Voids', '${summary.voidCount}'),
            _Row('Refunds', '${summary.refundCount}'),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.valueColor});
  final String label, value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: valueColor)),
        ],
      ),
    );
  }
}
