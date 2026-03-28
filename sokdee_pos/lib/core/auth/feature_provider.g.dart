// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasFeatureHash() => r'3feebb4ad97aab46b04e27c701b96008e72dbef5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [hasFeature].
@ProviderFor(hasFeature)
const hasFeatureProvider = HasFeatureFamily();

/// See also [hasFeature].
class HasFeatureFamily extends Family<AsyncValue<bool>> {
  /// See also [hasFeature].
  const HasFeatureFamily();

  /// See also [hasFeature].
  HasFeatureProvider call(
    String feature,
  ) {
    return HasFeatureProvider(
      feature,
    );
  }

  @override
  HasFeatureProvider getProviderOverride(
    covariant HasFeatureProvider provider,
  ) {
    return call(
      provider.feature,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hasFeatureProvider';
}

/// See also [hasFeature].
class HasFeatureProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [hasFeature].
  HasFeatureProvider(
    String feature,
  ) : this._internal(
          (ref) => hasFeature(
            ref as HasFeatureRef,
            feature,
          ),
          from: hasFeatureProvider,
          name: r'hasFeatureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasFeatureHash,
          dependencies: HasFeatureFamily._dependencies,
          allTransitiveDependencies:
              HasFeatureFamily._allTransitiveDependencies,
          feature: feature,
        );

  HasFeatureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feature,
  }) : super.internal();

  final String feature;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasFeatureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasFeatureProvider._internal(
        (ref) => create(ref as HasFeatureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feature: feature,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasFeatureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasFeatureProvider && other.feature == feature;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feature.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasFeatureRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `feature` of this provider.
  String get feature;
}

class _HasFeatureProviderElement extends AutoDisposeFutureProviderElement<bool>
    with HasFeatureRef {
  _HasFeatureProviderElement(super.provider);

  @override
  String get feature => (origin as HasFeatureProvider).feature;
}

String _$tenantFeaturesHash() => r'81739937b5d3bb6653fa599f21bfb5cf4cf5ced3';

/// See also [TenantFeatures].
@ProviderFor(TenantFeatures)
final tenantFeaturesProvider =
    AsyncNotifierProvider<TenantFeatures, List<String>>.internal(
  TenantFeatures.new,
  name: r'tenantFeaturesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tenantFeaturesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TenantFeatures = AsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
