import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/database/app_database.dart';
import 'package:sokdee_pos/core/database/daos/sync_dao.dart';
import 'package:sokdee_pos/core/network/api_client.dart';
import 'package:sokdee_pos/core/sync/sync_engine.dart';

class ConflictResolutionScreen extends ConsumerWidget {
  const ConflictResolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conflictsAsync = ref.watch(unresolvedConflictsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sync Conflicts')),
      body: conflictsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (conflicts) {
          if (conflicts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('No conflicts to resolve'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conflicts.length,
            itemBuilder: (_, i) => _ConflictCard(conflict: conflicts[i]),
          );
        },
      ),
    );
  }
}

class _ConflictCard extends ConsumerStatefulWidget {
  const _ConflictCard({required this.conflict});
  final ConflictLogsTableData conflict;

  @override
  ConsumerState<_ConflictCard> createState() => _ConflictCardState();
}

class _ConflictCardState extends ConsumerState<_ConflictCard> {
  final _customCtrl = TextEditingController();
  bool _isResolving = false;

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  Future<void> _resolve(String resolution) async {
    setState(() => _isResolving = true);
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/sync/conflicts/${widget.conflict.id}/resolve', body: {
        'resolution': resolution,
        if (resolution == 'manual' && _customCtrl.text.isNotEmpty)
          'custom_value': _customCtrl.text.trim(),
      });

      final db = ref.read(appDatabaseProvider);
      final dao = SyncDao(db);
      await dao.resolveConflict(widget.conflict.id, resolution, 'current_user');
      ref.invalidate(unresolvedConflictsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isResolving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Map<String, dynamic> local = {};
    Map<String, dynamic> server = {};
    try {
      if (widget.conflict.localValue != null) {
        local = jsonDecode(widget.conflict.localValue!) as Map<String, dynamic>;
      }
      if (widget.conflict.serverValue != null) {
        server = jsonDecode(widget.conflict.serverValue!) as Map<String, dynamic>;
      }
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '${widget.conflict.entityType} conflict',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Local vs Server comparison
            Row(
              children: [
                Expanded(
                  child: _ValueBox(
                    label: 'Local Value',
                    value: local,
                    color: Colors.blue.shade50,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ValueBox(
                    label: 'Server Value',
                    value: server,
                    color: Colors.green.shade50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Resolution options
            Text('Choose resolution:', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isResolving ? null : () => _resolve('use_local'),
                    child: const Text('Use Local'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isResolving ? null : () => _resolve('use_server'),
                    child: const Text('Use Server'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customCtrl,
              decoration: const InputDecoration(
                labelText: 'Custom value (optional)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isResolving ? null : () => _resolve('manual'),
                child: const Text('Apply Custom Value'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueBox extends StatelessWidget {
  const _ValueBox({required this.label, required this.value, required this.color});
  final String label;
  final Map<String, dynamic> value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          const SizedBox(height: 4),
          ...value.entries.map(
            (e) => Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
