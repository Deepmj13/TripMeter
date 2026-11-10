import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/auth/session_manager.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../shared/models/models.dart';

/// Registration and sign-in are the first requests a fresh install makes, and
/// the production API may be cold-starting (serverless free tier can take a
/// minute or more to wake). They get a much longer receive timeout than
/// regular requests, automatic retries on network errors, and never carry a
/// stale cached access token.
const _authRequestTimeout = Duration(seconds: 120);
const _authMaxAttempts = 3;

class AuthRepository {
  AuthRepository({
    required this.api,
    required this.session,
    required this.databases,
  });

  final ApiClient api;
  final SessionManager session;
  final DatabaseManager databases;

  static final Random _random = Random();

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final deviceId = await _deviceId();
    try {
      final data = await _postAuth('/auth/register', {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'deviceId': deviceId,
      });
      await _completeSignIn(data);
      return session.user!;
    } on ApiException catch (error) {
      // A previous attempt may have reached the server even though the
      // response was lost (timeout or dropped connection). In that case the
      // account already exists and the credentials above are valid: sign in
      // instead of stranding the user on the register screen.
      if (error.code == 'EMAIL_IN_USE') {
        final data = await _postAuth('/auth/login', {
          'email': email.trim(),
          'password': password,
          'deviceId': deviceId,
        });
        await _completeSignIn(data);
        return session.user!;
      }
      rethrow;
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final data = await _postAuth('/auth/login', {
      'email': email.trim(),
      'password': password,
      'deviceId': await _deviceId(),
    });
    await _completeSignIn(data);
    return session.user!;
  }

  /// Posts an auth endpoint with a long timeout and retries network errors.
  Future<Map<String, dynamic>> _postAuth(
    String path,
    Map<String, dynamic> payload,
  ) async {
    var attempt = 1;
    while (true) {
      try {
        return await api.post(
          path,
          data: payload,
          receiveTimeout: _authRequestTimeout,
          skipAuth: true,
        );
      } on ApiException catch (error) {
        if (!error.isNetworkError) rethrow;
        if (attempt >= _authMaxAttempts) {
          // The sync-oriented "changes stay on this device" wording makes no
          // sense on the sign-in screen; explain the likely cold start.
          throw ApiException(
            code: error.code,
            statusCode: error.statusCode,
            message:
                'Could not reach the server. It may be starting up; '
                'please try again in a moment.',
            isNetworkError: true,
          );
        }
        await Future<void>.delayed(
          Duration(seconds: min(attempt, 3) + _random.nextInt(2)),
        );
        attempt++;
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    await api.post('/auth/forgot-password', data: {'email': email.trim()});
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await api.post(
      '/auth/reset-password',
      data: {'token': token, 'newPassword': newPassword},
    );
  }

  Future<void> refreshProfile() async {
    final data = await api.get('/users/me');
    final user = AppUser.fromJson(data);
    await session.updateUser(user);
    await databases.database.saveProfile(user, 0);
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? currentPassword,
    Map<String, bool>? notificationPreferences,
  }) async {
    final data = await api.patch(
      '/users/me',
      data: {
        if (name != null) 'name': name.trim(),
        if (email != null) 'email': email.trim(),
        'currentPassword': ?currentPassword,
        'notificationPreferences': ?notificationPreferences,
      },
    );
    await session.updateUser(AppUser.fromJson(data));
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await api.post(
      '/auth/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<List<AuthSession>> sessions() async {
    final data = await api.get('/users/me/sessions');
    return (data['items'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => AuthSession.fromJson(item.cast<String, dynamic>()))
        .toList();
  }

  Future<void> revokeSession(String sessionId) async {
    await api.delete('/users/me/sessions/$sessionId');
  }

  Future<void> logout() async {
    final token = session.refreshToken;
    if (token != null) {
      try {
        await api.post('/auth/logout', data: {'refreshToken': token});
      } on ApiException {
        // Local logout must succeed even if the server is unreachable.
      }
    }
    await databases.close(deleteFile: true);
    await session.clearLocalSession();
  }

  Future<void> deleteAccount(String password) async {
    await api.delete('/users/me', data: {'password': password});
    await databases.close(deleteFile: true);
    await session.clearLocalSession();
  }

  Future<void> _completeSignIn(Map<String, dynamic> data) async {
    await session.applySession(data);
    final userId = session.user?.id;
    if (userId == null) {
      throw ApiException(code: 'AUTH_TOKEN_INVALID', message: 'Sign in failed');
    }
    await databases.open(userId);
    await databases.database.saveProfile(session.user!, 0);
  }

  Future<String> _deviceId() async {
    // The server only uses this for session bookkeeping; the app's persistent
    // installation identifier is generated by the session manager on demand.
    return '${defaultTargetPlatform.name}-${session.user?.id ?? 'anonymous'}';
  }
}

/// A server-side refresh-token family, shown as a signed-in device.
class AuthSession {
  const AuthSession({
    required this.sessionId,
    this.deviceId,
    this.userAgent,
    this.issuedAt,
    this.lastUsedAt,
    this.expiresAt,
  });

  final String sessionId;
  final String? deviceId;
  final String? userAgent;
  final DateTime? issuedAt;
  final DateTime? lastUsedAt;
  final DateTime? expiresAt;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        sessionId: json['sessionId']?.toString() ?? '',
        deviceId: json['deviceId']?.toString(),
        userAgent: json['userAgent']?.toString(),
        issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
        lastUsedAt: DateTime.tryParse(json['lastUsedAt']?.toString() ?? ''),
        expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      );
}
