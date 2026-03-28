import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokdee_pos/features/super_admin/super_admin_provider.dart';

class TenantListScreen extends ConsumerWidget {
  const TenantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantsAsync = ref.watch(tenantListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(tenantListProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/setup-wizard'),
        icon: const Icon(Icons.add),
        label: const Text('New Tenant'),
      ),
      body: tenantsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tenants) => tenants.isEmpty
            ? const Center(child: Text('No tenants yet'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tenants.length,
                itemBuilder: (context, i) => _TenantCard(tenant: tenants[i]),
              ),
      ),
    );
  }
}

class _TenantCard extends ConsumerWidget {
  const _TenantCard({required this.tenant});
  final TenantSummary tenant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isExpiringSoon = tenant.expiresAt != null &&
        tenant.expiresAt!.difference(DateTime.now()).inDays <= 7;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _statusColor(tenant.status, theme),
          child: Text(
            tenant.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(tenant.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tenant.storeType} • ${tenant.planName}'),
            Row(
              children: [
                _StatusChip(status: tenant.status),
                if (isExpiringSoon) ...[
                  const SizedBox(width: 8),
                  const _WarningChip(label: '⚠️ Expiring soon'),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) async {
            final actions = ref.read(tenantActionsProvider.notifier);
            if (action == 'suspend') await actions.suspend(tenant.id);
            if (action == 'activate') await actions.activate(tenant.id);
            if (action == 'detail') context.go('/super-admin/tenants/${tenant.id}');
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'detail', child: Text('View Detail')),
            if (tenant.status == 'active')
              const PopupMenuItem(value: 'suspend', child: Text('Suspend')),
            if (tenant.status == 'suspended')
              const PopupMenuItem(value: 'activate', child: Text('Activate')),
          ],
        ),
        onTap: () => context.go('/super-admin/tenants/${tenant.id}'),
      ),
    );
  }

  Color _statusColor(String status, ThemeData theme) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'suspended':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'active':
        color = Colors.green;
      case 'suspended':
        color = Colors.orange;
      case 'expired':
        color = Colors.red;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: const TextStyle(fontSize: 11, color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _WarningChip extends StatelessWidget {
  const _WarningChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: Colors.amber.shade100,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
