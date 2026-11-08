import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/models/models.dart';

enum SessionStatus { restoring, authenticated, offline, unauthenticated }

class SessionManager extends ChangeNotifier {
  SessionManager({
    required this.dio,
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _accessKey = 'tripmeter.access_token';
  static const _refreshKey = 'tripmeter.refresh_token';
  static const _userKey = 'tripmeter.user';
  static const _expiryKey = 'tripmeter.access_expiry';

  final Dio dio;
  final FlutterSecureStorage _secureStorage;

  SessionStatus _status = SessionStatus.restoring;
  AppUser? _user;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessExpiresAt;
  Future<bool>? _refreshing;

  SessionStatus get status => _status;
  AppUser? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated =>
      _user != null && _status != SessionStatus.unauthenticated;

  /// The refresh-token family backing the current access token, when the JWT
  /// can be decoded locally. Used to label the current device in the session
  /// list.
  String? get currentFamilyId {
    final token = _accessToken;
    if (token == null) return null;
    final parts = token.split('.');
    if (parts.length < 2) return null;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is Map) return payload['familyId']?.toString();
    } catch (_) {
      // A malformed cached token is handled by the auth interceptor.
    }
    return null;
  }
  bool get isOffline => _status == SessionStatus.offline;
  bool get needsRefresh {
    final expiry = _accessExpiresAt;
    if (expiry == null) return true;
    return expiry.isBefore(DateTime.now().add(const Duration(seconds: 30)));
  }

  Future<void> restore() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshKey);
      final userJson = await _secureStorage.read(key: _userKey);
      if (refreshToken == null || userJson == null) {
        _setUnauthenticated();
        return;
      }
      _refreshToken = refreshToken;
      _accessToken = await _secureStorage.read(key: _accessKey);
      final expiry = await _secureStorage.read(key: _expiryKey);
      _accessExpiresAt = expiry == null ? null : DateTime.tryParse(expiry);
      _user = AppUser.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
      _status = SessionStatus.authenticated;
      notifyListeners();
    } catch (_) {
      _setUnauthenticated();
    }
  }

  Future<void> applySession(Map<String, dynamic> data) async {
    _accessToken = data['accessToken']?.toString();
    _refreshToken = data['refreshToken']?.toString();
    final expiresIn = (data['expiresIn'] as num?)?.toInt() ?? 900;
    _accessExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    final rawUser = data['user'];
    if (rawUser is Map) {
      _user = AppUser.fromJson(rawUser.cast<String, dynamic>());
    }
    _status = SessionStatus.authenticated;

    if (_accessToken != null) {
      await _secureStorage.write(key: _accessKey, value: _accessToken);
    }
    if (_refreshToken != null) {
      await _secureStorage.write(key: _refreshKey, value: _refreshToken);
    }
    if (_user != null) {
      await _secureStorage.write(key: _userKey, value: jsonEncode(_user!.toJson()));
    }
    if (_accessExpiresAt != null) {
      await _secureStorage.write(
        key: _expiryKey,
        value: _accessExpiresAt!.toIso8601String(),
      );
    }
    notifyListeners();
  }

  Future<bool> refresh() {
    final existing = _refreshing;
    if (existing != null) return existing;
    final future = _doRefresh();
    _refreshing = future;
    return future.whenComplete(() {
      _refreshing = null;
    });
  }

  Future<bool> _doRefresh() async {
    final token = _refreshToken;
    if (token == null || token.isEmpty) return false;
    try {
      final response = await dio.post<dynamic>(
        '/auth/refresh',
        data: {'refreshToken': token},
        options: Options(extra: {'skipAuth': true}),
      );
      final payload = response.data;
      if (payload is Map && payload['data'] is Map) {
        await applySession(
          (payload['data'] as Map).cast<String, dynamic>(),
        );
        return true;
      }
      return false;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        await clearLocalSession();
        notifyListeners();
        return false;
      }
      // Network unavailable: keep the cached session and continue in offline
      // read/write mode for the same authenticated user.
      _status = SessionStatus.offline;
      notifyListeners();
      return false;
    }
  }

  void markOffline() {
    if (_user == null) return;
    _status = SessionStatus.offline;
    notifyListeners();
  }

  void markOnline() {
    if (_user == null) return;
    _status = SessionStatus.authenticated;
    notifyListeners();
  }

  Future<void> updateUser(AppUser user) async {
    _user = user;
    await _secureStorage.write(key: _userKey, value: jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> clearLocalSession() async {
    _accessToken = null;
    _refreshToken = null;
    _accessExpiresAt = null;
    _user = null;
    _status = SessionStatus.unauthenticated;
    await _secureStorage.delete(key: _accessKey);
    await _secureStorage.delete(key: _refreshKey);
    await _secureStorage.delete(key: _userKey);
    await _secureStorage.delete(key: _expiryKey);
  }

  void _setUnauthenticated() {
    _status = SessionStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }
}
