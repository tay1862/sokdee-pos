import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';
import 'package:sokdee_pos/features/pos/cart_provider.dart';

part 'payment_screen.g.dart';

// ─── Exchange Rate Provider ───────────────────────────────────────────────────

@riverpod
Future<Map<String, double>> exchangeRates(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/settings/exchange-rates');
  final rates = data['rates'] as Map<String, dynamic>? ?? {};
  return rates.map((k, v) => MapEntry(k, (v as num).toDouble()));
}

// ─── Payment Screen ───────────────────────────────────────────────────────────

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _method = 'cash';
  String _currency = 'LAK';
  final _amountCtrl = TextEditingController();
  bool _isProcessing = false;
  String? _error;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  double get _orderTotal => ref.read(cartNotifierProvider).total;

  double get _changeAmount {
    final paid = double.tryParse(_amountCtrl.text) ?? 0;
    final rate = _getRate();
    final paidLak = paid * rate;
    return paidLak > _orderTotal ? paidLak - _orderTotal : 0;
  }

  double _getRate() {
    if (_currency == 'LAK') return 1;
    final rates = ref.read(exchangeRatesProvider).valueOrNull ?? {};
    return rates[_currency] ?? 0;
  }

  Future<void> _processPayment() async {
    final paid = double.tryParse(_amountCtrl.text) ?? 0;
    if (paid <= 0) {
      setState(() => _error = 'Please enter payment amount');
      return;
    }

    final rate = _getRate();
    if (_currency != 'LAK' && rate == 0) {
      setState(() => _error = 'Exchange rate not configured for $_currency');
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final client = ref.read(apiClientProvider);
      final cart = ref.read(cartNotifierProvider);

      // Create order if new
      String orderId = widget.orderId;
      if (orderId == 'new') {
        final orderResp = await client.post('/orders', body: cart.toOrderPayload());
        orderId = orderResp['id'] as String;
      }

      // Process payment
      await client.post('/orders/$orderId/pay', body: {
        'payments': [
          {
            'method': _method,
            'currency': _currency,
            'amount': paid,
            'exchange_rate': rate,
          },
        ],
      });

      ref.read(cartNotifierProvider.notifier).clear();
      if (mounted) context.go('/pos');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotifierProvider);
    final ratesAsync = ref.watch(exchangeRatesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order total
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('Total', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    Text(
                      '${cart.total.toStringAsFixed(0)} ₭',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Payment method
            Text('Payment Method', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'cash', label: Text('Cash'), icon: Icon(Icons.money)),
                ButtonSegment(value: 'qr', label: Text('QR'), icon: Icon(Icons.qr_code)),
                ButtonSegment(value: 'transfer', label: Text('Transfer'), icon: Icon(Icons.swap_horiz)),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() => _method = s.first),
            ),
            const SizedBox(height: 16),

            // Currency selector
            ratesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (rates) {
                final available = ['LAK', ...rates.keys.where((k) => rates[k]! > 0)];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Currency', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: available.map((c) => ChoiceChip(
                            label: Text(c),
                            selected: _currency == c,
                            onSelected: (_) => setState(() => _currency = c),
                          )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

            // Amount input
            if (_method == 'cash') ...[
              Text('Amount Received', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Amount ($_currency)',
                  prefixIcon: const Icon(Icons.money),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              // Change display
              if (_amountCtrl.text.isNotEmpty && _changeAmount >= 0)
                Card(
                  color: _changeAmount > 0 ? Colors.green.shade50 : null,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Text('Change'),
                        const Spacer(),
                        Text(
                          '${_changeAmount.toStringAsFixed(0)} ₭',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _changeAmount > 0 ? Colors.green : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ] else if (_method == 'qr') ...[
              // Static QR display
              const _StaticQRDisplay(),
              const SizedBox(height: 12),
              // Confirm button acts as "customer paid"
              OutlinedButton.icon(
                onPressed: () => setState(() => _amountCtrl.text = cart.total.toStringAsFixed(0)),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Customer has paid'),
              ),
            ] else ...[
              // Transfer
              TextField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Transfer Amount',
                  prefixIcon: Icon(Icons.swap_horiz),
                ),
              ),
            ],

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isProcessing ? null : _processPayment,
                icon: _isProcessing
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check),
                label: const Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticQRDisplay extends ConsumerWidget {
  const _StaticQRDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.qr_code, size: 120),
            const SizedBox(height: 8),
            Text(
              'Scan to pay',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Configure QR in Settings',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
