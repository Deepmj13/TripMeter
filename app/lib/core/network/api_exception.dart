import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
    this.isNetworkError = false,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;
  final bool isNetworkError;

  bool get isCursorExpired => code == 'CURSOR_EXPIRED';
  bool get isVersionConflict =>
      code == 'EXPENSE_VERSION_CONFLICT' ||
      code == 'SETTLEMENT_VERSION_CONFLICT' ||
      statusCode == 409;
  bool get isAuthError => statusCode == 401 || statusCode == 403;
  bool get isRetryable =>
      isNetworkError || statusCode == 429 || (statusCode ?? 0) >= 500;
  bool get requiresReauth => code == 'AUTH_REFRESH_REUSED';

  static ApiException fromDio(DioException error) {
    final response = error.response;
    if (response == null) {
      return ApiException(
        code: 'NETWORK_ERROR',
        message: 'The network is unavailable. Your changes stay on this device.',
        isNetworkError: true,
      );
    }
    final payload = response.data;
    if (payload is Map && payload['error'] is Map) {
      final body = (payload['error'] as Map).cast<String, dynamic>();
      return ApiException(
        code: body['code']?.toString() ?? 'UNKNOWN_ERROR',
        message: body['message']?.toString() ?? 'The request failed',
        statusCode: response.statusCode,
        details: (body['details'] as Map?)?.cast<String, dynamic>(),
      );
    }
    return ApiException(
      code: 'HTTP_${response.statusCode}',
      message: 'The request failed (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  @override
  String toString() => message;
}
