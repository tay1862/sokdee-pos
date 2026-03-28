import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/auth/feature_provider.dart';

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
    final featureFlag = ref.watch(hasFeatureProvider(feature));

    return featureFlag.when(
      data: (hasFeature) {
        if (hasFeature) return child;
        return fallback ?? UpgradePlanBanner(feature: feature);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => fallback ?? UpgradePlanBanner(feature: feature),
    );
  }
}

class UpgradePlanBanner extends StatelessWidget {
  const UpgradePlanBanner({super.key, required this.feature});

  final String feature;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Feature Unavailable',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'The \'$feature\' feature is not included in your current subscription plan. Upgrade your plan to unlock.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to upgrade plan screen or show dialog
              },
              child: const Text('Upgrade Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
