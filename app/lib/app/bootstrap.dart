import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/auth/session_manager.dart';
import '../core/database/database_manager.dart';
import '../core/network/api_client.dart';
import '../core/sync/sync_manager.dart';
import 'app_services.dart';

const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
const _productionBaseUrl = 'https://tripmeter.onrender.com/v1';

String defaultApiBaseUrl() {
  if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
  if (kReleaseMode) return _productionBaseUrl;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000/v1';
  }
  return 'http://localhost:3000/v1';
}

Future<AppServices> bootstrapServices() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: defaultApiBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  final session = SessionManager(dio: dio);
  dio.interceptors.add(AuthInterceptor(session));

  // Wake the API while the user is still on the sign-in screen. The hosted
  // server sleeps when idle and its first response can take well over the
  // regular request timeouts; this ping starts that cold boot immediately.
  unawaited(_warmUpApi(dio));

  final api = ApiClient(dio, session);
  final databases = DatabaseManager();
  final sync = SyncManager(api: api, session: session, databases: databases);

  await session.restore();
  // A revoked/deleted account (or a refresh-token reuse) clears the session
  // outside the normal logout flow. Purge the cached financial data so it is
  // never left readable on the device.
  session.addListener(() {
    if (!session.isAuthenticated && databases.isOpen) {
      unawaited(databases.close(deleteFile: true));
    }
  });
  final user = session.user;
  if (session.isAuthenticated && user != null) {
    await databases.open(user.id);
    sync.start();
  }

  return AppServices(
    session: session,
    databases: databases,
    api: api,
    sync: sync,
  );
}

/// Best-effort request that triggers the API cold boot. Its own patience is
/// larger than any regular timeout because the server may take a minute or
/// more to wake; failures are ignored because sign-in retries on its own.
Future<void> _warmUpApi(Dio dio) async {
  try {
    await dio.get<dynamic>(
      '/health/ready',
      options: Options(
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        extra: {'skipAuth': true},
      ),
    );
  } catch (_) {
    // Sign-in shows a proper error and retries when the user is ready.
  }
}
