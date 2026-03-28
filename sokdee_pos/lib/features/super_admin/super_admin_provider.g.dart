// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'super_admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tenantListHash() => r'7d5a4b4070ade1cb7309de1a9c467361c6a715aa';

/// See also [tenantList].
@ProviderFor(tenantList)
final tenantListProvider =
    AutoDisposeFutureProvider<List<TenantSummary>>.internal(
  tenantList,
  name: r'tenantListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tenantListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TenantListRef = AutoDisposeFutureProviderRef<List<TenantSummary>>;
String _$planListHash() => r'383f3e7e4a893a75915c06616901b68b45069c8f';

/// See also [planList].
@ProviderFor(planList)
final planListProvider =
    AutoDisposeFutureProvider<List<SubscriptionPlan>>.internal(
  planList,
  name: r'planListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$planListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlanListRef = AutoDisposeFutureProviderRef<List<SubscriptionPlan>>;
String _$tenantActionsHash() => r'7f34987ba62351554289007b8a36a46610d647ac';

/// See also [TenantActions].
@ProviderFor(TenantActions)
final tenantActionsProvider =
    AutoDisposeNotifierProvider<TenantActions, AsyncValue<void>>.internal(
  TenantActions.new,
  name: r'tenantActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tenantActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TenantActions = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
