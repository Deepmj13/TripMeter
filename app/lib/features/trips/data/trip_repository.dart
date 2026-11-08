import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

class TripRepository {
  TripRepository({required this.api, required this.databases});

  final ApiClient api;
  final DatabaseManager databases;

  AppDatabase get database => databases.database;

  Stream<List<LocalTrip>> watchTrips() => database.watchTrips();

  Future<List<LocalTrip>> trips() => database.trips();

  Future<LocalTrip?> localTrip(String tripId) => database.getTrip(tripId);

  /// Pulls a full trip snapshot into the local cache. Used after accepting an
  /// invitation and whenever a change feed cursor has expired.
  Future<void> refreshSnapshot(String tripId, {String? currentUserId}) async {
    final data = await api.get('/trips/$tripId/snapshot');
    await database.replaceTripSnapshot(
      TripSnapshot.fromJson(data),
      currentUserId: currentUserId,
    );
  }

  Future<Trip> create({
    required String name,
    String? destination,
    String? description,
    String? startDate,
    String? endDate,
    String currency = 'INR',
  }) async {
    final id = const Uuid().v4();
    final data = await api.post(
      '/trips',
      data: {
        'id': id,
        'name': name.trim(),
        if (destination != null && destination.trim().isNotEmpty)
          'destination': destination.trim(),
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
        'startDate': ?startDate,
        'endDate': ?endDate,
        'currency': currency,
      },
      idempotencyKey: id,
    );
    final tripJson = (data['trip'] as Map).cast<String, dynamic>();
    final memberJson = (data['membership'] as Map?)?.cast<String, dynamic>();
    final trip = Trip.fromJson({
      ...tripJson,
      'myRole': data['myRole'] ?? memberJson?['role'] ?? 'owner',
      'memberId': memberJson?['id'],
    });
    await database.upsertTrip(trip);
    if (memberJson != null) {
      await database.upsertMember(TripMember.fromJson(memberJson));
    }
    return trip;
  }

  Future<Trip> update(
    String tripId, {
    String? name,
    String? destination,
    String? description,
    String? startDate,
    String? endDate,
  }) async {
    final data = await api.patch(
      '/trips/$tripId',
      data: {
        if (name != null) 'name': name.trim(),
        if (destination != null) 'destination': destination.trim(),
        if (description != null) 'description': description.trim(),
        'startDate': ?startDate,
        'endDate': ?endDate,
      },
      idempotencyKey: const Uuid().v4(),
    );
    final existing = await database.getTrip(tripId);
    final trip = Trip.fromJson({
      ...(data['trip'] as Map).cast<String, dynamic>(),
      'myRole': existing?.myRole ?? 'member',
      'memberId': existing?.memberId,
    });
    await database.upsertTrip(trip);
    return trip;
  }

  Future<void> archive(String tripId, {bool archived = true}) async {
    final action = archived ? 'archive' : 'unarchive';
    final data = await api.post(
      '/trips/$tripId/$action',
      idempotencyKey: const Uuid().v4(),
    );
    final existing = await database.getTrip(tripId);
    final trip = Trip.fromJson({
      ...(data['trip'] as Map).cast<String, dynamic>(),
      'myRole': existing?.myRole ?? 'member',
      'memberId': existing?.memberId,
    });
    await database.upsertTrip(trip);
  }

  Future<void> transferOwnership(String tripId, String memberId) async {
    await api.post(
      '/trips/$tripId/transfer-ownership',
      data: {'memberId': memberId},
      idempotencyKey: const Uuid().v4(),
    );
    final local = await database.getTrip(tripId);
    if (local != null) {
      await database.upsertTrip(
        Trip(
          id: local.id,
          name: local.name,
          destination: local.destination,
          description: local.description,
          currency: local.currency,
          currencyExponent: local.currencyExponent,
          startDate: local.startDate,
          endDate: local.endDate,
          archivedAt: local.archivedAt,
          ownerUserId: local.ownerUserId,
          createdByUserId: local.createdByUserId,
          myRole: local.myRole,
          memberId: local.memberId,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> leave(String tripId) async {
    await api.post(
      '/trips/$tripId/leave',
      data: {'acknowledgeOutstandingBalance': true},
      idempotencyKey: const Uuid().v4(),
    );
    await database.deleteTripLocal(tripId);
  }

  Future<Map<String, dynamic>> summary(String tripId) =>
      api.get('/trips/$tripId/summary');

  Future<Map<String, dynamic>> audit(String tripId, {int after = 0}) =>
      api.get('/trips/$tripId/audit', query: {'after': after, 'limit': 50});

  Future<void> touchLocalRole(String tripId, String role, String memberId) async {
    final local = await database.getTrip(tripId);
    if (local == null) return;
    await database.upsertTrip(
      Trip(
        id: local.id,
        name: local.name,
        destination: local.destination,
        description: local.description,
        currency: local.currency,
        currencyExponent: local.currencyExponent,
        startDate: local.startDate,
        endDate: local.endDate,
        archivedAt: local.archivedAt,
        ownerUserId: local.ownerUserId,
        createdByUserId: local.createdByUserId,
        myRole: role,
        memberId: memberId,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
