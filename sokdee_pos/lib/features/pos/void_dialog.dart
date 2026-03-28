import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

/// Shows a confirmation dialog to void an order.
/// Requires Manager/Owner PIN approval.
Future<bool> showVoidDialog(
  BuildContext context,
  WidgetRef ref,
  String orderId,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => _VoidDialog(orderId: orderId, ref: ref),
  );
  return result ?? false;
}

class _VoidDialog extends StatefulWidget {
  const _VoidDialog({required this.orderId, required this.ref});
  final String orderId;
  final WidgetRef ref;

  @override
  State<_VoidDialog> createState() => _VoidDialogState();
}

class _VoidDialogState extends State<_VoidDialog> {
  final _reasonCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_reasonCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Reason is required');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = widget.ref.read(apiClientProvider);
      await client.post('/orders/${widget.orderId}/void', body: {
        'reason': _reasonCtrl.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Void Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('This action cannot be undone. Please provide a reason.'),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonCtrl,
            decoration: const InputDecoration(labelText: 'Reason *'),
            maxLines: 2,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _confirm,
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: _isLoading
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Void Order'),
        ),
      ],
    );
  }
}
