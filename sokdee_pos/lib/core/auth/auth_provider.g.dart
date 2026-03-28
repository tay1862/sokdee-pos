// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentAuthHash() => r'c45b710fc684c7fde2c78ca6909ea011b0fe769f';

/// Convenience provider to get current auth state synchronously
///
/// Copied from [currentAuth].
@ProviderFor(currentAuth)
final currentAuthProvider = AutoDisposeProvider<AuthState?>.internal(
  currentAuth,
  name: r'currentAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentAuthRef = AutoDisposeProviderRef<AuthState?>;
String _$hasRoleHash() => r'53ec2f727b8e381fd75b3dae6e604f413554ee1a';

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

/// Provider to check if user has a specific role or higher
///
/// Copied from [hasRole].
@ProviderFor(hasRole)
const hasRoleProvider = HasRoleFamily();

/// Provider to check if user has a specific role or higher
///
/// Copied from [hasRole].
class HasRoleFamily extends Family<bool> {
  /// Provider to check if user has a specific role or higher
  ///
  /// Copied from [hasRole].
  const HasRoleFamily();

  /// Provider to check if user has a specific role or higher
  ///
  /// Copied from [hasRole].
  HasRoleProvider call(
    String minRole,
  ) {
    return HasRoleProvider(
      minRole,
    );
  }

  @override
  HasRoleProvider getProviderOverride(
    covariant HasRoleProvider provider,
  ) {
    return call(
      provider.minRole,
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
  String? get name => r'hasRoleProvider';
}

/// Provider to check if user has a specific role or higher
///
/// Copied from [hasRole].
class HasRoleProvider extends AutoDisposeProvider<bool> {
  /// Provider to check if user has a specific role or higher
  ///
  /// Copied from [hasRole].
  HasRoleProvider(
    String minRole,
  ) : this._internal(
          (ref) => hasRole(
            ref as HasRoleRef,
            minRole,
          ),
          from: hasRoleProvider,
          name: r'hasRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasRoleHash,
          dependencies: HasRoleFamily._dependencies,
          allTransitiveDependencies: HasRoleFamily._allTransitiveDependencies,
          minRole: minRole,
        );

  HasRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.minRole,
  }) : super.internal();

  final String minRole;

  @override
  Override overrideWith(
    bool Function(HasRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasRoleProvider._internal(
        (ref) => create(ref as HasRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        minRole: minRole,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HasRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasRoleProvider && other.minRole == minRole;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, minRole.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasRoleRef on AutoDisposeProviderRef<bool> {
  /// The parameter `minRole` of this provider.
  String get minRole;
}

class _HasRoleProviderElement extends AutoDisposeProviderElement<bool>
    with HasRoleRef {
  _HasRoleProviderElement(super.provider);

  @override
  String get minRole => (origin as HasRoleProvider).minRole;
}

String _$authHash() => r'6b1b41e117309f5aee446d3e27d6cf58f6748c1a';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AutoDisposeAsyncNotifierProvider<Auth, AuthState>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AutoDisposeAsyncNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
