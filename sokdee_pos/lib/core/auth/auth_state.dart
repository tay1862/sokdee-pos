import 'package:equatable/equatable.dart';

/// Represents the current authentication state of the app
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — checking stored token
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.userId,
    required this.tenantId,
    required this.role,
    required this.deviceId,
    required this.accessToken,
  });

  final String userId;
  final String tenantId;
  final String role;
  final String deviceId;
  final String accessToken;

  @override
  List<Object?> get props => [userId, tenantId, role, deviceId];
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Authentication error
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
