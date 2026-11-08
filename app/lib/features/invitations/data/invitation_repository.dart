import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

class InvitationRepository {
  InvitationRepository({required this.api, required this.databases});

  final ApiClient api;
  final DatabaseManager databases;

  AppDatabase get database => databases.database;

  Stream<List<LocalInvitation>> watchInvitations() =>
      database.watchInvitations();

  Future<List<Invitation>> list() async {
    final data = await api.get('/invitations');
    final items = (data['items'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Invitation.fromJson(item.cast<String, dynamic>()))
        .toList();
    for (final invitation in items) {
      await database.upsertInvitation(invitation);
    }
    return items;
  }

  Future<Invitation> create(String tripId, String email) async {
    final id = const Uuid().v4();
    final data = await api.post(
      '/trips/$tripId/invitations',
      data: {'email': email.trim()},
      idempotencyKey: id,
    );
    final invitation = Invitation.fromJson(data);
    await database.upsertInvitation(invitation);
    return invitation;
  }

  Future<Invitation> get(String invitationId) async {
    final data = await api.get('/invitations/$invitationId');
    final invitation = Invitation.fromJson(data);
    await database.upsertInvitation(invitation);
    return invitation;
  }

  Future<Invitation> resend(String invitationId) async {
    final data = await api.post(
      '/invitations/$invitationId/resend',
      idempotencyKey: const Uuid().v4(),
    );
    final invitation = Invitation.fromJson(data);
    await database.upsertInvitation(invitation);
    return invitation;
  }

  Future<Invitation> revoke(String invitationId) async {
    final data = await api.post(
      '/invitations/$invitationId/revoke',
      idempotencyKey: const Uuid().v4(),
    );
    final invitation = Invitation.fromJson(data);
    await database.upsertInvitation(invitation);
    return invitation;
  }

  /// Accepts an invitation by ID after the user has authenticated.
  Future<Trip> acceptById(String invitationId) async {
    final data = await api.post(
      '/invitations/$invitationId/accept',
      idempotencyKey: const Uuid().v4(),
    );
    return _applyAcceptance(data);
  }

  /// Accepts an invitation from a secure deep-link token.
  Future<Trip> acceptByToken(String token) async {
    final data = await api.post(
      '/invitations/accept',
      data: {'token': token},
      idempotencyKey: const Uuid().v4(),
    );
    return _applyAcceptance(data);
  }

  Future<void> decline({String? token, String? invitationId}) async {
    await api.post(
      '/invitations/decline',
      data: {
        'token': ?token,
        'invitationId': ?invitationId,
      },
    );
    if (invitationId != null) {
      final existing = await (database.select(database.localInvitations)
            ..where((t) => t.id.equals(invitationId)))
          .getSingleOrNull();
      if (existing != null) {
        await database.upsertInvitation(
          Invitation(
            id: existing.id,
            tripId: existing.tripId,
            tripName: existing.tripName,
            email: existing.emailNormalized,
            status: 'declined',
            role: existing.role,
            expiresAt: existing.expiresAt,
            createdAt: DateTime.tryParse(existing.createdAt),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<Trip> _applyAcceptance(Map<String, dynamic> data) async {
    final invitationJson = (data['invitation'] as Map?)?.cast<String, dynamic>();
    final membershipJson = (data['membership'] as Map?)?.cast<String, dynamic>();
    final tripId = data['tripId']?.toString() ?? invitationJson?['tripId']?.toString();

    if (invitationJson != null) {
      await database.upsertInvitation(Invitation.fromJson(invitationJson));
    }
    if (membershipJson != null) {
      await database.upsertMember(TripMember.fromJson(membershipJson));
    }
    if (tripId == null) {
      throw StateError('Invitation acceptance did not return a trip');
    }

    final snapshot = await api.get('/trips/$tripId/snapshot');
    final parsed = TripSnapshot.fromJson(snapshot);
    await database.replaceTripSnapshot(parsed);
    return parsed.trip;
  }
}
