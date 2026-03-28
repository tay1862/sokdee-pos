import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Categorized app errors
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Access denied']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

class BusinessException extends AppException {
  const BusinessException(super.message, {this.code});
  final String? code;
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found']);
}

/// Converts a Dio error into a typed AppException
AppException mapDioError(DioException e) {
  final statusCode = e.response?.statusCode;
  final data = e.response?.data;
  final serverMessage = _extractMessage(data);

  switch (statusCode) {
    case 401:
      return UnauthorizedException(serverMessage ?? 'Session expired');
    case 403:
      return ForbiddenException(serverMessage ?? 'Access denied');
    case 404:
      return NotFoundException(serverMessage ?? 'Not found');
    case 409:
    case 422:
      return BusinessException(
        serverMessage ?? 'Business rule violation',
        code: _extractCode(data),
      );
    default:
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const NetworkException();
      }
      return BusinessException(serverMessage ?? e.message ?? 'Unknown error');
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    return (data['error'] as Map<String, dynamic>?)?['message'] as String?;
  }
  return null;
}

String? _extractCode(dynamic data) {
  if (data is Map<String, dynamic>) {
    return (data['error'] as Map<String, dynamic>?)?['code'] as String?;
  }
  return null;
}

/// Shows a snackbar for common errors
void showErrorSnackbar(BuildContext context, AppException error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error.message),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
