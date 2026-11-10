import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../auth/session_manager.dart';

/// Routes incoming invitation and password-reset links.
///
/// An invitation token that arrives before sign-in is kept in secure storage
/// until the user authenticates, so it survives registration and app restarts.
class DeepLinkService {
  DeepLinkService({
    required this.session,
    required this.router,
    FlutterSecureStorage? storage,
    AppLinks? links,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _links = links ?? AppLinks();

  static const pendingInvitationKey = 'tripmeter.pending_invitation_token';

  final SessionManager session;
  final GoRouter router;
  final FlutterSecureStorage _storage;
  final AppLinks _links;

  StreamSubscription<Uri>? _subscription;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    session.addListener(_onSessionChanged);
    try {
      final initial = await _links.getInitialLink();
      if (initial != null) await _handle(initial);
      _subscription = _links.uriLinkStream.listen(
        (uri) => unawaited(_handle(uri)),
        onError: (_) {},
      );
    } catch (_) {
      // Deep links are unavailable on some desktop targets; the in-app
      // invitation token entry remains available.
    }
    if (session.isAuthenticated) unawaited(_onSessionChanged());
  }

  Future<void> _onSessionChanged() async {
    if (!session.isAuthenticated) return;
    final token = await _storage.read(key: pendingInvitationKey);
    if (token == null || token.isEmpty) return;
    await _storage.delete(key: pendingInvitationKey);
    _openInvitations(token);
  }

  Future<void> _handle(Uri uri) async {
    final segments = <String>[
      if (uri.host.isNotEmpty) ...uri.host.split('.'),
      ...uri.pathSegments,
    ].where((segment) => segment.isNotEmpty).toList();

    String? tokenAfter(String marker) {
      final index = segments.indexOf(marker);
      if (index < 0 || index + 1 >= segments.length) return null;
      return segments[index + 1];
    }

    final queryToken = uri.queryParameters['token'];
    final reset = segments.contains('reset-password') ||
        segments.contains('reset_password');
    final invite = segments.contains('invite') ||
        segments.contains('invitation') ||
        segments.contains('invitations');

    if (reset) {
      final token = queryToken ?? tokenAfter('reset-password') ?? tokenAfter('reset_password');
      router.go(_path('/reset-password', token));
      return;
    }
    if (invite || queryToken != null) {
      final token = queryToken ??
          tokenAfter('invite') ??
          tokenAfter('invitation') ??
          tokenAfter('invitations');
      if (token == null || token.isEmpty) return;
      if (session.isAuthenticated) {
        _openInvitations(token);
      } else {
        await _storage.write(key: pendingInvitationKey, value: token);
        router.go('/login');
      }
    }
  }

  void _openInvitations(String token) {
    router.go(_path('/invitations', token));
  }

  String _path(String path, String? token) {
    if (token == null || token.isEmpty) return path;
    return Uri(path: path, queryParameters: {'token': token}).toString();
  }

  void dispose() {
    session.removeListener(_onSessionChanged);
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
