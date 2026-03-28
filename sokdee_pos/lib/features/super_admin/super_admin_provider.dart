import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'super_admin_provider.g.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class TenantSummary {
  const TenantSummary({
    required this.id,
    required this.name,
    required this.storeType,
    required this.planName,
    required this.status,
    this.expiresAt,
    required this.userCount,
  });

  final String id;
  final String name;
  final String storeType;
  final String planName;
  final String status;
  final DateTime? expiresAt;
  final int userCount;

  factory TenantSummary.fromJson(Map<String, dynamic> json) => TenantSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        storeType: json['store_type'] as String,
        planName: json['plan_name'] as String? ?? '',
        status: json['status'] as String,
        expiresAt: json['expires_at'] != null
            ? DateTime.tryParse(json['expires_at'] as String)
            : null,
        userCount: json['user_count'] as int? ?? 0,
      );
}

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    this.maxUsers,
    this.maxProducts,
    required this.features,
  });

  final String id;
  final String name;
  final int? maxUsers;
  final int? maxProducts;
  final Map<String, dynamic> features;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        maxUsers: json['max_users'] as int?,
        maxProducts: json['max_products'] as int?,
        features: json['features'] as Map<String, dynamic>? ?? {},
      );
}

// ─── Providers ────────────────────────────────────────────────────────────────

@riverpod
Future<List<TenantSummary>> tenantList(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/admin/tenants');
  final list = data['tenants'] as List<dynamic>? ?? [];
  return list
      .map((e) => TenantSummary.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
Future<List<SubscriptionPlan>> planList(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/admin/plans');
  final list = data['plans'] as List<dynamic>? ?? [];
  return list
      .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
      .toList();
}

@riverpod
class TenantActions extends _$TenantActions {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> suspend(String tenantId) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.patch('/admin/tenants/$tenantId/suspend');
      ref.invalidate(tenantListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> activate(String tenantId) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.patch('/admin/tenants/$tenantId/activate');
      ref.invalidate(tenantListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
