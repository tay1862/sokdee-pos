import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'feature_gate.g.dart';

// ─── Plan features cache ──────────────────────────────────────────────────────

@riverpod
Future<Map<String, dynamic>> tenantFeatures(Ref ref) async {
  final auth = ref.watch(currentAuthProvider);
  if (auth is! AuthAuthenticated) return {};
  final client = ref.read(apiClientProvider);
  final data = await client.get('/settings');
  return (data['features'] as Map<String, dynamic>?) ?? {};
}

/// Returns true if the current tenant's plan includes [feature]
@riverpod
bool hasFeature(Ref ref, String feature) {
  final featuresAsync = ref.watch(tenantFeaturesProvider);
  final features = featuresAsync.valueOrNull ?? {};
  return features[feature] == true;
}

// ─── FeatureGate widget ───────────────────────────────────────────────────────

/// Shows [child] only if the tenant's plan includes [feature].
/// Shows [fallback] (or nothing) otherwise.
class FeatureGate extends ConsumerWidget {
  const FeatureGate({
    super.key,
    required this.feature,
    required this.child,
    this.fallback,
  });

  final String feature;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(hasFeatureProvider(feature));
    if (enabled) return child;
    return fallback ?? const SizedBox.shrink();
  }
}

// ─── RoleGate widget ──────────────────────────────────────────────────────────

/// Shows [child] only if the current user's role is >= [minRole].
class RoleGate extends ConsumerWidget {
  const RoleGate({
    super.key,
    required this.minRole,
    required this.child,
    this.fallback,
  });

  final String minRole;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(hasRoleProvider(minRole));
    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}

// ─── UpgradePlanBanner ────────────────────────────────────────────────────────

class UpgradePlanBanner extends StatelessWidget {
  const UpgradePlanBanner({super.key, this.featureName});
  final String? featureName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: theme.colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  featureName != null ? 'Upgrade to use $featureName' : 'Upgrade your plan',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Contact your administrator to upgrade',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
