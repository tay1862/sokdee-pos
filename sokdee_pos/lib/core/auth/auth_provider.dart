import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'auth_provider.g.dart';

const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';
const _userDataKey = 'user_data';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    return _restoreSession();
  }

  /// Restore session from secure storage on app start
  Future<AuthState> _restoreSession() async {
    final token = await _storage.read(key: _accessTokenKey);
    final userData = await _storage.read(key: _userDataKey);
    if (token == null || userData == null) {
      return const AuthUnauthenticated();
    }
    try {
      final data = jsonDecode(userData) as Map<String, dynamic>;
      return AuthAuthenticated(
        userId: data['user_id'] as String,
        tenantId: data['tenant_id'] as String,
        role: data['role'] as String,
        deviceId: data['device_id'] as String? ?? '',
        accessToken: token,
      );
    } catch (_) {
      return const AuthUnauthenticated();
    }
  }

  /// Login with PIN
  Future<void> login({
    required String tenantId,
    required String username,
    required String pin,
    required String deviceId,
  }) async {
    state = const AsyncValue.loading();

    final client = ref.read(apiClientProvider);
    try {
      final response = await client.post('/auth/login', body: {
        'tenant_id': tenantId,
        'username': username,
        'pin': pin,
        'device_id': deviceId,
      });

      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;

      // Decode JWT payload to extract claims
      final claims = _decodeJwtPayload(accessToken);
      final userId = claims['sub'] as String;
      final role = claims['role'] as String;

      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      await _storage.write(
        key: _userDataKey,
        value: jsonEncode({
          'user_id': userId,
          'tenant_id': tenantId,
          'role': role,
          'device_id': deviceId,
        }),
      );

      state = AsyncValue.data(
        AuthAuthenticated(
          userId: userId,
          tenantId: tenantId,
          role: role,
          deviceId: deviceId,
          accessToken: accessToken,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(AuthError(e.toString()));
    }
  }

  /// Logout — clear tokens
  Future<void> logout() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken != null) {
      try {
        final client = ref.read(apiClientProvider);
        await client.post('/auth/logout', body: {'refresh_token': refreshToken});
      } catch (_) {}
    }
    await _storage.deleteAll();
    state = const AsyncValue.data(AuthUnauthenticated());
  }

  /// Get current access token (refreshing if needed)
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  /// Decode JWT payload without verification (verification done server-side)
  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }
}

/// Convenience provider to get current auth state synchronously
@riverpod
AuthState? currentAuth(Ref ref) {
  return ref.watch(authProvider).valueOrNull;
}

/// Provider to check if user has a specific role or higher
@riverpod
bool hasRole(Ref ref, String minRole) {
  final auth = ref.watch(currentAuthProvider);
  if (auth is! AuthAuthenticated) return false;
  return _roleLevel(auth.role) >= _roleLevel(minRole);
}

int _roleLevel(String role) {
  switch (role) {
    case 'super_admin':
      return 5;
    case 'owner':
      return 4;
    case 'manager':
      return 3;
    case 'cashier':
      return 2;
    case 'kitchen_staff':
      return 1;
    default:
      return 0;
  }
}
