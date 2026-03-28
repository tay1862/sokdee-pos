import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

/// Refund screen — requires Manager/Owner PIN approval
class RefundScreen extends ConsumerStatefulWidget {
  const RefundScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends ConsumerState<RefundScreen> {
  final _reasonCtrl = TextEditingController();
  final _approverPinCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _approverPinCtrl.dispose();
    super.dispose();
  }

  Future<void> _processRefund() async {
    if (_reasonCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Reason is required');
      return;
    }
    if (_approverPinCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Manager/Owner PIN is required');
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    try {
      final client = ref.read(apiClientProvider);

      // Verify approver PIN first
      final verifyResp = await client.post('/auth/verify-pin', body: {
        'pin': _approverPinCtrl.text.trim(),
        'required_role': 'manager',
      });
      final approverId = verifyResp['user_id'] as String?;
      if (approverId == null) {
        setState(() => _error = 'Invalid PIN or insufficient permissions');
        return;
      }

      // Process refund
      await client.post('/orders/${widget.orderId}/refund', body: {
        'reason': _reasonCtrl.text.trim(),
        'approved_by': approverId,
        'items': [], // Full order refund
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund processed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process Refund')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.orange.shade50,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Refund requires Manager or Owner approval. '
                        'This action will return money to the customer and restore stock.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Order ID: ${widget.orderId}',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonCtrl,
              decoration: const InputDecoration(
                labelText: 'Reason for Refund *',
                hintText: 'e.g. Customer returned item, Wrong order',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _approverPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Manager/Owner PIN *',
                prefixIcon: Icon(Icons.lock_outline),
                helperText: 'Enter Manager or Owner PIN to approve',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _processRefund,
                icon: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.undo),
                label: const Text('Process Refund'),
                style: FilledButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
