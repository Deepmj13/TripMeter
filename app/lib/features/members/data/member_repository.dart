import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

class MemberRepository {
  MemberRepository({required this.api, required this.databases});

  final ApiClient api;
  final DatabaseManager databases;

  AppDatabase get database => databases.database;

  Stream<List<LocalMember>> watchMembers(String tripId) =>
      database.watchMembers(tripId);

  Future<List<LocalMember>> members(String tripId) =>
      database.members(tripId);

  Future<TripMember> addGuest(
    String tripId, {
    required String displayName,
    String? email,
  }) async {
    final id = const Uuid().v4();
    final data = await api.post(
      '/trips/$tripId/members',
      data: {
        'id': id,
        'displayName': displayName.trim(),
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      },
      idempotencyKey: id,
    );
    final member = TripMember.fromJson(data);
    await database.upsertMember(member);
    return member;
  }

  Future<TripMember> update(
    String tripId,
    String memberId, {
    String? displayName,
    String? email,
  }) async {
    final data = await api.patch(
      '/trips/$tripId/members/$memberId',
      data: {
        if (displayName != null) 'displayName': displayName.trim(),
        if (email != null) 'email': email.trim(),
      },
      idempotencyKey: const Uuid().v4(),
    );
    final member = TripMember.fromJson(data);
    await database.upsertMember(member);
    return member;
  }

  Future<TripMember> changeRole(
    String tripId,
    String memberId,
    String role,
  ) async {
    final data = await api.patch(
      '/trips/$tripId/members/$memberId/role',
      data: {'role': role},
      idempotencyKey: const Uuid().v4(),
    );
    final member = TripMember.fromJson(data);
    await database.upsertMember(member);
    return member;
  }

  Future<void> remove(String tripId, String memberId) async {
    await api.post(
      '/trips/$tripId/members/$memberId/remove',
      idempotencyKey: const Uuid().v4(),
    );
    final local = await (database.select(database.localMembers)
          ..where((t) => t.id.equals(memberId)))
        .getSingleOrNull();
    if (local != null) {
      await database.upsertMember(
        TripMember(
          id: local.id,
          tripId: local.tripId,
          userId: local.userId,
          displayName: local.displayName,
          email: local.emailNormalized,
          memberKind: local.memberKind,
          role: local.role,
          status: 'removed',
          joinedAt: local.joinedAt,
          serverVersion: local.serverVersion,
        ),
      );
    }
  }

  Future<TripMember> claim(String tripId, String memberId) async {
    final data = await api.post(
      '/trips/$tripId/members/$memberId/claim',
      idempotencyKey: const Uuid().v4(),
    );
    final member = TripMember.fromJson(data);
    await database.upsertMember(member);
    return member;
  }
}
