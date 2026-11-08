import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../shared/models/models.dart';
import '../auth/session_manager.dart';
import '../database/app_database.dart';
import '../database/database_manager.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';

/// Coordinates the durable local outbox and the two server change feeds.
///
/// Order of a cycle:
/// 1. Pull user-level events (so revoked trip access is applied before any
///    queued write for that trip can be sent).
/// 2. Push pending outbox operations in creation order.
/// 3. Pull every cached trip feed.
/// 4. Pull user-level events once more to catch access changes that happened
///    while the outbox was draining.
class SyncManager extends ChangeNotifier {
  SyncManager({
    required this.api,
    required this.session,
    required this.databases,
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  final ApiClient api;
  final SessionManager session;
  final DatabaseManager databases;
  final Connectivity _connectivity;

  static const int _maxAutomaticAttempts = 8;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _timer;
  bool _started = false;
  bool _syncing = false;
  String? _lastError;
  DateTime? _lastSyncedAt;

  bool get isSyncing => _syncing;
  String? get lastError => _lastError;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  void start() {
    if (_started) {
      // A different account may have signed in since the first start; run a
      // cycle immediately instead of waiting for the next timer tick.
      unawaited(syncNow());
      return;
    }
    _started = true;
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        if (results.any((result) => result != ConnectivityResult.none)) {
          unawaited(syncNow());
        }
      },
    );
    _timer = Timer.periodic(const Duration(minutes: 2), (_) {
      unawaited(syncNow());
    });
    unawaited(syncNow());
  }

  Future<void> onAppResumed() async {
    final results = await _connectivity.checkConnectivity();
    if (results.any((result) => result != ConnectivityResult.none)) {
      await syncNow();
    }
  }

  Future<void> syncNow() async {
    if (_syncing || !session.isAuthenticated) return;
    final user = session.user;
    if (user == null) return;

    _syncing = true;
    _lastError = null;
    notifyListeners();
    final db = databases.database;
    try {
      await db.recoverInFlightOperations();
      await _pullUserFeed(db, user.id);
      await _pushOutbox(db);
      await _pullTripFeeds(db, user.id);
      await _pullUserFeed(db, user.id);
      session.markOnline();
      _lastSyncedAt = DateTime.now();
    } on ApiException catch (error) {
      _lastError = error.message;
      if (error.isNetworkError) session.markOffline();
      if (error.requiresReauth) {
        await session.clearLocalSession();
      }
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------------- pull

  Future<void> _pullUserFeed(AppDatabase db, String userId) async {
    var cursor = await db.userCursor(userId);
    if (cursor == 0) {
      await _loadUserSnapshot(db, userId);
      cursor = await db.userCursor(userId);
    }

    for (var page = 0; page < 100; page += 1) {
      Map<String, dynamic> data;
      try {
        data = await api.get(
          '/users/me/changes',
          query: {'after': cursor, 'limit': 100},
        );
      } on ApiException catch (error) {
        if (!error.isCursorExpired) rethrow;
        await _loadUserSnapshot(db, userId);
        cursor = await db.userCursor(userId);
        continue;
      }

      final changes = (data['changes'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList();
      for (final event in changes) {
        await db.applyUserEvent(event, userId: userId);
        await _handleUserEvent(db, userId, event);
        final sequence = _asInt(event['sequence']);
        if (sequence > cursor) cursor = sequence;
      }
      if (data['hasMore'] != true) break;
    }
  }

  Future<void> _handleUserEvent(
    AppDatabase db,
    String userId,
    Map<String, dynamic> event,
  ) async {
    final eventType = event['eventType']?.toString() ?? '';
    final tripId =
        event['tripId']?.toString() ?? (event['payload'] as Map?)?['tripId']?.toString();

    if (eventType == 'trip.access.granted' && tripId != null) {
      await _loadTripSnapshot(db, tripId, userId);
      await _pullTripFeed(db, tripId, userId);
    } else if (eventType.startsWith('invitation.')) {
      await _refreshInvitations(db);
    }
  }

  Future<void> _loadUserSnapshot(AppDatabase db, String userId) async {
    final data = await api.get('/users/me/snapshot');
    await db.replaceUserSnapshot(
      UserSnapshot.fromJson(data),
      userId: userId,
    );
    await _refreshInvitations(db);
  }

  Future<void> _refreshInvitations(AppDatabase db) async {
    try {
      final data = await api.get('/invitations');
      for (final item in (data['items'] as List? ?? const []).whereType<Map>()) {
        await db.upsertInvitation(
          Invitation.fromJson(item.cast<String, dynamic>()),
        );
      }
    } on ApiException {
      // Invitation details are a best-effort enrichment of the user feed. The
      // feed's cursor still advances so the next cycle can try again.
    }
  }

  Future<void> _pullTripFeeds(AppDatabase db, String userId) async {
    final trips = await db.trips();
    for (final trip in trips) {
      try {
        await _pullTripFeed(db, trip.id, userId);
      } on ApiException catch (error) {
        if (error.statusCode == 403 || error.statusCode == 404) {
          await db.deleteTripLocal(trip.id);
        } else {
          _lastError = error.message;
        }
      }
    }
  }

  Future<void> _pullTripFeed(
    AppDatabase db,
    String tripId,
    String userId,
  ) async {
    var cursor = await db.tripCursor(tripId);
    if (cursor == 0) {
      await _loadTripSnapshot(db, tripId, userId);
      cursor = await db.tripCursor(tripId);
    }

    for (var page = 0; page < 100; page += 1) {
      Map<String, dynamic> data;
      try {
        data = await api.get(
          '/trips/$tripId/changes',
          query: {'after': cursor, 'limit': 100},
        );
      } on ApiException catch (error) {
        if (!error.isCursorExpired) rethrow;
        await _loadTripSnapshot(db, tripId, userId);
        cursor = await db.tripCursor(tripId);
        continue;
      }

      final changes = (data['changes'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList();
      for (final event in changes) {
        await db.applyTripEvent(event, tripId: tripId);
        final sequence = _asInt(event['sequence']);
        if (sequence > cursor) cursor = sequence;
      }
      if (data['hasMore'] != true) break;
    }
  }

  Future<void> _loadTripSnapshot(
    AppDatabase db,
    String tripId,
    String userId,
  ) async {
    final data = await api.get('/trips/$tripId/snapshot');
    await db.replaceTripSnapshot(
      TripSnapshot.fromJson(data),
      currentUserId: userId,
    );
  }

  // ------------------------------------------------------------------- push

  Future<void> _pushOutbox(AppDatabase db) async {
    final operations = await db.allPendingOperations();
    final now = DateTime.now().toUtc();
    for (final operation in operations) {
      final nextAttemptAt = DateTime.tryParse(operation.nextAttemptAt ?? '');
      if (nextAttemptAt != null && nextAttemptAt.isAfter(now)) continue;

      await db.markOperation(operation.id, state: 'inFlight');
      try {
        final payload = _decode(operation.payload);
        final ifMatch = operation.baseVersion?.toString();
        final response = switch (operation.method) {
          'POST' => await api.post(
              operation.endpoint,
              data: payload,
              idempotencyKey: operation.id,
            ),
          'PATCH' => await api.patch(
              operation.endpoint,
              data: payload,
              idempotencyKey: operation.id,
              ifMatch: ifMatch,
            ),
          'DELETE' => await api.delete(
              operation.endpoint,
              data: payload,
              idempotencyKey: operation.id,
              ifMatch: ifMatch,
            ),
          _ => throw StateError('Unsupported outbox method ${operation.method}'),
        };
        await _applyWriteResponse(db, operation, response);
        await db.deleteOperation(operation.id);
      } on ApiException catch (error) {
        await _handlePushFailure(db, operation, error);
      } catch (error) {
        await db.markOperation(
          operation.id,
          state: 'pending',
          lastError: error.toString(),
        );
      }
    }
  }

  Future<void> _applyWriteResponse(
    AppDatabase db,
    LocalOutboxOperation operation,
    Map<String, dynamic> response,
  ) async {
    switch (operation.entityType) {
      case 'expense':
        final expense = Expense.fromJson({
          ...response,
          'tripId': response['tripId'] ?? operation.tripId,
        });
        await db.saveSyncedExpense(expense);
      case 'settlement':
        final settlement = Settlement.fromJson({
          ...response,
          'tripId': response['tripId'] ?? operation.tripId,
        });
        await db.saveSyncedSettlement(settlement);
      case 'member':
        await db.upsertMember(TripMember.fromJson(response));
      case 'invitation':
        await db.upsertInvitation(Invitation.fromJson(response));
    }
  }

  Future<void> _handlePushFailure(
    AppDatabase db,
    LocalOutboxOperation operation,
    ApiException error,
  ) async {
    final attempts = operation.attemptCount + 1;
    if (error.isRetryable && attempts < _maxAutomaticAttempts) {
      final seconds = min(2 << min(attempts - 1, 7), 300);
      final jitter = Random().nextInt(1000) / 1000;
      final nextAttempt = DateTime.now()
          .toUtc()
          .add(Duration(seconds: seconds, milliseconds: (jitter * 1000).round()));
      await db.markOperation(
        operation.id,
        state: 'pending',
        attemptCount: attempts,
        lastError: error.message,
        nextAttemptAt: nextAttempt.toIso8601String(),
      );
      return;
    }

    // A version/state conflict, validation failure or exhausted retry budget
    // becomes an explicit conflict record. The local overlay is cleared so the
    // next pull can apply the authoritative server snapshot without repeatedly
    // re-raising the same conflict.
    final serverPayload = await _fetchServerPayload(operation);
    await db.addConflict(
      tripId: operation.tripId,
      entityType: operation.entityType,
      entityId: operation.entityId,
      localPayload: _decode(operation.payload),
      serverPayload: serverPayload ?? {'error': error.code, 'message': error.message},
      baseVersion: operation.baseVersion,
      serverVersion: _asNullableInt(serverPayload?['version']),
    );
    await db.clearPendingLocalChange(
      operation.entityType,
      operation.entityId,
      syncStatus: 'conflict',
    );
    await db.markOperation(
      operation.id,
      state: 'failed',
      attemptCount: attempts,
      lastError: error.message,
    );
    await db.deleteOperation(operation.id);
  }

  Future<Map<String, dynamic>?> _fetchServerPayload(
    LocalOutboxOperation operation,
  ) async {
    final path = switch (operation.entityType) {
      'expense' =>
        '/trips/${operation.tripId}/expenses/${operation.entityId}',
      'settlement' =>
        '/trips/${operation.tripId}/settlements/${operation.entityId}',
      _ => null,
    };
    if (path == null) return null;
    try {
      return await api.get(path);
    } on ApiException {
      return null;
    }
  }

  // ---------------------------------------------------------------- helpers

  Map<String, dynamic> _decode(String raw) {
    final decoded = jsonDecode(raw);
    return decoded is Map ? decoded.cast<String, dynamic>() : <String, dynamic>{};
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
