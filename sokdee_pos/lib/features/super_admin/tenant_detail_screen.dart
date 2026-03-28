import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/network/api_client.dart';
import 'package:sokdee_pos/features/super_admin/super_admin_provider.dart';

class TenantDetailScreen extends ConsumerWidget {
  const TenantDetailScreen({super.key, required this.tenantId});
  final String tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(_tenantDetailProvider(tenantId));

    return Scaffold(
      appBar: AppBar(title: const Text('Tenant Detail')),
      body: tenantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tenant) => _TenantDetailBody(tenant: tenant),
      ),
    );
  }
}

final _tenantDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  return client.get('/admin/tenants/$id');
});

class _TenantDetailBody extends ConsumerWidget {
  const _TenantDetailBody({required this.tenant});
  final Map<String, dynamic> tenant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = tenant['status'] as String? ?? '';
    final actions = ref.read(tenantActionsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoTile(label: 'Name', value: tenant['name'] as String? ?? ''),
        _InfoTile(label: 'Store Type', value: tenant['store_type'] as String? ?? ''),
        _InfoTile(label: 'Status', value: status),
        _InfoTile(label: 'Language', value: tenant['default_lang'] as String? ?? ''),
        _InfoTile(label: 'Currency', value: tenant['base_currency'] as String? ?? ''),
        if (tenant['expires_at'] != null)
          _InfoTile(label: 'Expires At', value: tenant['expires_at'] as String),
        const SizedBox(height: 24),
        if (status == 'active')
          OutlinedButton.icon(
            onPressed: () => actions.suspend(tenant['id'] as String),
            icon: const Icon(Icons.pause_circle_outline),
            label: const Text('Suspend Tenant'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
          ),
        if (status == 'suspended')
          FilledButton.icon(
            onPressed: () => actions.activate(tenant['id'] as String),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Activate Tenant'),
          ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
