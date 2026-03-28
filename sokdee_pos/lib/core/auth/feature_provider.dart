import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'feature_provider.g.dart';

@Riverpod(keepAlive: true)
class TenantFeatures extends _$TenantFeatures {
  @override
  FutureOr<List<String>> build() async {
    final auth = ref.watch(currentAuthProvider);
    if (auth is! AuthAuthenticated) return [];

    try {
      final client = ref.read(apiClientProvider);
      final response = await client.get('/tenants/${auth.tenantId}');
      
      // Extract subscription_plan and map to features
      // Alternatively, the backend could return a 'features' array directly.
      // Here we assume backend returns a 'subscription_plan' string or 'features' array.
      final features = response['features'] as List<dynamic>?;
      if (features != null) {
        return features.cast<String>();
      }
      
      // Fallback: Map plan to features (simplified client-side logic)
      final plan = response['subscription_plan'] as String? ?? 'starter';
      return _mapPlanToFeatures(plan);
    } catch (_) {
      return [];
    }
  }

  List<String> _mapPlanToFeatures(String plan) {
    final features = <String>['sales', 'basic_reports'];
    if (plan == 'basic' || plan == 'pro' || plan == 'enterprise') {
      features.addAll(['inventory_basic']);
    }
    if (plan == 'pro' || plan == 'enterprise') {
      features.addAll(['kds', 'table_management', 'advanced_reports', 'inventory_advanced']);
    }
    if (plan == 'enterprise') {
      features.addAll(['multi_branch', 'api_access']);
    }
    return features;
  }
}

@riverpod
Future<bool> hasFeature(Ref ref, String feature) async {
  final features = await ref.watch(tenantFeaturesProvider.future);
  return features.contains(feature);
}
