import 'package:dio/dio.dart';

import '../auth/session_manager.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(this.dio, this.session);

  final Dio dio;
  final SessionManager session;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _request('GET', path, query: query);

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    String? idempotencyKey,
    Duration? receiveTimeout,
    bool skipAuth = false,
  }) =>
      _request(
        'POST',
        path,
        data: data,
        idempotencyKey: idempotencyKey,
        receiveTimeout: receiveTimeout,
        skipAuth: skipAuth,
      );

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? data,
    String? idempotencyKey,
    String? ifMatch,
  }) =>
      _request(
        'PATCH',
        path,
        data: data,
        idempotencyKey: idempotencyKey,
        ifMatch: ifMatch,
      );

  Future<Map<String, dynamic>> delete(
    String path, {
    Object? data,
    String? idempotencyKey,
    String? ifMatch,
  }) =>
      _request(
        'DELETE',
        path,
        data: data,
        idempotencyKey: idempotencyKey,
        ifMatch: ifMatch,
      );

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    String? idempotencyKey,
    String? ifMatch,
    Duration? receiveTimeout,
    bool skipAuth = false,
  }) async {
    try {
      final response = await dio.request<dynamic>(
        path,
        data: data,
        queryParameters: query,
        options: Options(
          method: method,
          receiveTimeout: receiveTimeout,
          headers: {
            'Idempotency-Key': ?idempotencyKey,
            'If-Match': ?ifMatch,
          },
          extra: {'skipAuth': skipAuth},
        ),
      );
      final payload = response.data;
      if (payload is Map) {
        final map = payload.cast<String, dynamic>();
        final body = map['data'];
        if (body is Map) return body.cast<String, dynamic>();
        if (body is List) return {'items': body};
        return {'value': body};
      }
      return {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

/// Adds the access token and performs a single refresh-and-retry on 401.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.session);

  final SessionManager session;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = session.accessToken;
    if (options.extra['skipAuth'] != true && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final options = err.requestOptions;
    if (response?.statusCode != 401 ||
        options.extra['skipAuth'] == true ||
        options.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    final refreshed = await session.refresh();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    try {
      final retryOptions = Options(
        method: options.method,
        headers: {
          ...options.headers,
          'Authorization': 'Bearer ${session.accessToken}',
        },
        extra: {...options.extra, 'retried': true},
      );
      final retry = await session.dio.request<dynamic>(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: retryOptions,
      );
      handler.resolve(retry);
    } on DioException catch (error) {
      handler.next(error);
    }
  }
}
