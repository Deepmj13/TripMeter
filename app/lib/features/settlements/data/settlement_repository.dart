import 'package:uuid/uuid.dart';

import '../../../core/auth/session_manager.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

class SettlementRepository {
  SettlementRepository({
    required this.api,
    required this.session,
    required this.databases,
  });

  final ApiClient api;
  final SessionManager session;
  final DatabaseManager databases;

  AppDatabase get database => databases.database;

  Stream<List<Settlement>> watchSettlements(String tripId) =>
      database.watchSettlements(tripId);

  Future<List<Settlement>> settlements(String tripId) =>
      database.settlements(tripId);

  Future<Settlement> create({
    required String tripId,
    required String paidByMemberId,
    required String paidToMemberId,
    required int amountMinor,
    required String paymentDate,
    String note = '',
  }) async {
    final userId = session.user?.id;
    if (userId == null) {
      throw StateError('An authenticated user is required');
    }
    final id = const Uuid().v4();
    final settlement = Settlement(
      id: id,
      tripId: tripId,
      paidByMemberId: paidByMemberId,
      paidToMemberId: paidToMemberId,
      amountMinor: amountMinor,
      paymentDate: paymentDate,
      status: 'pending',
      recordedByUserId: userId,
      note: note.trim(),
      version: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final payload = {
      'id': id,
      'paidByMemberId': paidByMemberId,
      'paidToMemberId': paidToMemberId,
      'amountMinor': amountMinor,
      'paymentDate': paymentDate,
      if (note.trim().isNotEmpty) 'note': note.trim(),
    };
    await database.saveLocalSettlement(
      settlement,
      operationId: id,
      operationType: 'create',
      method: 'POST',
      endpoint: '/trips/$tripId/settlements',
      payload: payload,
      pending: true,
    );
    return settlement;
  }

  Future<Settlement> confirm(Settlement settlement) =>
      _transition(settlement, 'confirm', 'confirmed');

  Future<Settlement> reject(Settlement settlement, {String? reason}) =>
      _transition(settlement, 'reject', 'rejected', reason: reason);

  Future<Settlement> cancel(Settlement settlement) =>
      _transition(settlement, 'cancel', 'cancelled');

  Future<Settlement> _transition(
    Settlement settlement,
    String action,
    String status, {
    String? reason,
  }) async {
    final userId = session.user?.id;
    final now = DateTime.now();
    final updated = Settlement(
      id: settlement.id,
      tripId: settlement.tripId,
      paidByMemberId: settlement.paidByMemberId,
      paidToMemberId: settlement.paidToMemberId,
      amountMinor: settlement.amountMinor,
      paymentDate: settlement.paymentDate,
      status: status,
      recordedByUserId: settlement.recordedByUserId,
      confirmedByUserId: status == 'confirmed' ? userId : settlement.confirmedByUserId,
      statusChangedByUserId: userId,
      statusChangedAt: now.toUtc().toIso8601String(),
      rejectionReason: status == 'rejected' ? reason?.trim() : settlement.rejectionReason,
      note: settlement.note,
      version: settlement.version,
      confirmedAt: status == 'confirmed'
          ? now.toUtc().toIso8601String()
          : settlement.confirmedAt,
      createdAt: settlement.createdAt,
      updatedAt: now,
    );
    final operationId = const Uuid().v4();
    await database.saveLocalSettlement(
      updated,
      operationId: operationId,
      operationType: action,
      method: 'POST',
      endpoint:
          '/trips/${settlement.tripId}/settlements/${settlement.id}/$action',
      payload: {
        if (status == 'rejected' && reason != null && reason.trim().isNotEmpty)
          'reason': reason.trim(),
      },
      baseVersion: settlement.version,
      pending: true,
    );
    return updated;
  }
}
