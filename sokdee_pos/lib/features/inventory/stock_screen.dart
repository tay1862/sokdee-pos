import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';
import 'package:sokdee_pos/features/inventory/inventory_provider.dart';

part 'stock_screen.g.dart';

// ─── Stock transaction model ──────────────────────────────────────────────────

class StockTransaction {
  const StockTransaction({
    required this.id,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.createdAt,
    this.reason,
  });

  final String id;
  final String productName;
  final String type;
  final int quantity;
  final DateTime createdAt;
  final String? reason;

  factory StockTransaction.fromJson(Map<String, dynamic> j) => StockTransaction(
        id: j['id'] as String,
        productName: j['product_name'] as String? ?? '',
        type: j['type'] as String,
        quantity: j['quantity'] as int,
        createdAt: DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now(),
        reason: j['reason'] as String?,
      );
}

@riverpod
Future<List<StockTransaction>> stockTransactions(Ref ref, String productId) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/stock/transactions', queryParams: {'product_id': productId});
  final list = data['transactions'] as List<dynamic>? ?? [];
  return list.map((e) => StockTransaction.fromJson(e as Map<String, dynamic>)).toList();
}

// ─── Stock Management Screen ──────────────────────────────────────────────────

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Stock In'), Tab(text: 'Adjustment')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _StockInForm(),
          _StockAdjustForm(),
        ],
      ),
    );
  }
}

// ─── Stock In Form ────────────────────────────────────────────────────────────

class _StockInForm extends ConsumerStatefulWidget {
  const _StockInForm();

  @override
  ConsumerState<_StockInForm> createState() => _StockInFormState();
}

class _StockInFormState extends ConsumerState<_StockInForm> {
  Product? _selectedProduct;
  final _qtyCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedProduct == null || _qtyCtrl.text.isEmpty) return;
    setState(() { _isLoading = true; _message = null; });
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/stock/in', body: {
        'product_id': _selectedProduct!.id,
        'quantity': int.tryParse(_qtyCtrl.text) ?? 0,
        if (_costCtrl.text.isNotEmpty) 'cost_price': double.tryParse(_costCtrl.text),
      });
      setState(() { _message = 'Stock updated successfully'; });
      _qtyCtrl.clear();
      _costCtrl.clear();
      ref.invalidate(productListProvider);
    } catch (e) {
      setState(() { _message = 'Error: $e'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Stock', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          productsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (products) => DropdownButtonFormField<Product>(
              value: _selectedProduct,
              decoration: const InputDecoration(labelText: 'Select Product'),
              items: products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (p) => setState(() => _selectedProduct = p),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _qtyCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity *', prefixIcon: Icon(Icons.add_box_outlined)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _costCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Cost Price (₭)', prefixIcon: Icon(Icons.attach_money)),
          ),
          const SizedBox(height: 20),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_message!, style: TextStyle(color: _message!.startsWith('Error') ? Colors.red : Colors.green)),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: const Icon(Icons.add),
              label: const Text('Add Stock'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stock Adjust Form ────────────────────────────────────────────────────────

class _StockAdjustForm extends ConsumerStatefulWidget {
  const _StockAdjustForm();

  @override
  ConsumerState<_StockAdjustForm> createState() => _StockAdjustFormState();
}

class _StockAdjustFormState extends ConsumerState<_StockAdjustForm> {
  Product? _selectedProduct;
  final _qtyCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedProduct == null || _qtyCtrl.text.isEmpty || _reasonCtrl.text.isEmpty) return;
    setState(() { _isLoading = true; _message = null; });
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/stock/adjust', body: {
        'product_id': _selectedProduct!.id,
        'quantity': int.tryParse(_qtyCtrl.text) ?? 0,
        'reason': _reasonCtrl.text.trim(),
      });
      setState(() { _message = 'Adjustment recorded'; });
      _qtyCtrl.clear();
      _reasonCtrl.clear();
      ref.invalidate(productListProvider);
    } catch (e) {
      setState(() { _message = 'Error: $e'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Adjustment', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Use negative values to reduce stock', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          productsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (products) => DropdownButtonFormField<Product>(
              value: _selectedProduct,
              decoration: const InputDecoration(labelText: 'Select Product'),
              items: products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (p) => setState(() => _selectedProduct = p),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _qtyCtrl,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: const InputDecoration(
              labelText: 'Quantity (+ or -) *',
              helperText: 'e.g. -5 to reduce, +10 to add',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonCtrl,
            decoration: const InputDecoration(labelText: 'Reason *', hintText: 'e.g. Damaged, Physical count'),
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_message!, style: TextStyle(color: _message!.startsWith('Error') ? Colors.red : Colors.green)),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: const Icon(Icons.tune),
              label: const Text('Record Adjustment'),
            ),
          ),
        ],
      ),
    );
  }
}
