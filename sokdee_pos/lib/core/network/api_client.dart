import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080/api/v1',
);

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

/// Low-level HTTP client wrapping Dio
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(path, data: body);
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParams,
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(path, data: body);
    return response.data ?? {};
  }

  Future<void> delete(String path) async {
    await _dio.delete<void>(path);
  }
}

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ),
  );

  // Auth interceptor — attach Bearer token to every request
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // 401 → attempt token refresh
        if (error.response?.statusCode == 401) {
          final refreshToken = await _storage.read(key: 'refresh_token');
          if (refreshToken != null) {
            try {
              final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
              final resp = await refreshDio.post<Map<String, dynamic>>(
                '/auth/refresh',
                data: {'refresh_token': refreshToken},
              );
              final newToken = resp.data?['access_token'] as String?;
              final newRefresh = resp.data?['refresh_token'] as String?;
              if (newToken != null) {
                await _storage.write(key: 'access_token', value: newToken);
                if (newRefresh != null) {
                  await _storage.write(
                    key: 'refresh_token',
                    value: newRefresh,
                  );
                }
                // Retry original request
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final retryResp = await dio.fetch<Map<String, dynamic>>(
                  error.requestOptions,
                );
                return handler.resolve(retryResp);
              }
            } catch (_) {}
          }
        }
        handler.next(error);
      },
    ),
  );

  return ApiClient(dio);
}
