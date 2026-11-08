import 'package:uuid/uuid.dart';

import '../../../core/auth/session_manager.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_manager.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/money.dart';
import '../../../shared/models/models.dart';

class ExpenseRepository {
  ExpenseRepository({
    required this.api,
    required this.session,
    required this.databases,
  });

  final ApiClient api;
  final SessionManager session;
  final DatabaseManager databases;

  AppDatabase get database => databases.database;

  Stream<List<Expense>> watchExpenses(String tripId) =>
      database.watchExpenses(tripId);

  Future<List<Expense>> expenses(String tripId) =>
      database.expenses(tripId);

  Future<Expense?> get(String expenseId) => database.getExpense(expenseId);

  /// Saves the expense locally and queues it in the durable outbox. The caller
  /// gets a usable expense immediately, even when the device is offline.
  Future<Expense> create({
    required String tripId,
    required String title,
    required int amountMinor,
    required String currency,
    required String paidByMemberId,
    required String splitType,
    required List<String> participantMemberIds,
    required Map<String, int> customSplits,
    required String expenseDate,
    String category = 'other',
    String description = '',
  }) async {
    final userId = session.user?.id;
    if (userId == null) {
      throw StateError('An authenticated user is required');
    }
    final id = const Uuid().v4();
    final splits = splitType == 'equal'
        ? allocateEqualSplit(amountMinor, participantMemberIds)
        : Map<String, int>.from(customSplits);
    final now = DateTime.now().toUtc().toIso8601String();

    final expense = Expense(
      id: id,
      tripId: tripId,
      title: title.trim(),
      amountMinor: amountMinor,
      currency: currency,
      paidByMemberId: paidByMemberId,
      createdByUserId: userId,
      splitType: splitType,
      splits: splits.entries
          .map((entry) => ExpenseSplit(
                memberId: entry.key,
                amountMinor: entry.value,
              ))
          .toList(),
      category: category,
      expenseDate: expenseDate,
      description: description.trim(),
      status: 'active',
      version: 1,
      clientCreatedAt: now,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final payload = _createPayload(expense, participantMemberIds);
    await database.saveLocalExpense(
      expense,
      operationId: id,
      operationType: 'create',
      method: 'POST',
      endpoint: '/trips/$tripId/expenses',
      payload: payload,
      pending: true,
    );
    return expense;
  }

  Future<Expense> update({
    required Expense existing,
    required String title,
    required int amountMinor,
    required String paidByMemberId,
    required String splitType,
    required List<String> participantMemberIds,
    required Map<String, int> customSplits,
    required String expenseDate,
    required String category,
    required String description,
  }) async {
    final splits = splitType == 'equal'
        ? allocateEqualSplit(amountMinor, participantMemberIds)
        : Map<String, int>.from(customSplits);
    final updated = Expense(
      id: existing.id,
      tripId: existing.tripId,
      title: title.trim(),
      amountMinor: amountMinor,
      currency: existing.currency,
      paidByMemberId: paidByMemberId,
      createdByUserId: existing.createdByUserId,
      updatedByUserId: session.user?.id,
      deletedByUserId: existing.deletedByUserId,
      splitType: splitType,
      splits: splits.entries
          .map((entry) => ExpenseSplit(
                memberId: entry.key,
                amountMinor: entry.value,
              ))
          .toList(),
      category: category,
      expenseDate: expenseDate,
      description: description.trim(),
      status: existing.status,
      version: existing.version,
      clientCreatedAt: existing.clientCreatedAt,
      deletedAt: existing.deletedAt,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    final baseVersion = existing.version;
    final operationId = const Uuid().v4();
    await database.saveLocalExpense(
      updated,
      operationId: operationId,
      operationType: 'update',
      method: 'PATCH',
      endpoint: '/trips/${existing.tripId}/expenses/${existing.id}',
      payload: _updatePayload(updated, participantMemberIds),
      baseVersion: baseVersion,
      pending: true,
    );
    return updated;
  }

  Future<void> delete(Expense expense) async {
    final operationId = const Uuid().v4();
    await database.transaction(() async {
      await database.markExpenseDeletedLocal(expense.id);
      await database.enqueueOperation(
        id: operationId,
        tripId: expense.tripId,
        entityType: 'expense',
        entityId: expense.id,
        operationType: 'delete',
        method: 'DELETE',
        endpoint: '/trips/${expense.tripId}/expenses/${expense.id}',
        payload: const {},
        baseVersion: expense.version,
      );
    });
  }

  /// `POST /trips/:tripId/expenses` accepts the client-generated id so the
  /// server stores the same id the device already references locally.
  Map<String, dynamic> _createPayload(
    Expense expense,
    List<String> participantMemberIds,
  ) =>
      {
        'id': expense.id,
        ..._updatePayload(expense, participantMemberIds),
        if (expense.clientCreatedAt != null)
          'clientCreatedAt': expense.clientCreatedAt,
      };

  /// `PATCH /trips/:tripId/expenses/:expenseId` uses `forbidNonWhitelisted`
  /// validation, so it must contain no `id` or other create-only fields.
  Map<String, dynamic> _updatePayload(
    Expense expense,
    List<String> participantMemberIds,
  ) =>
      {
        'title': expense.title,
        'amountMinor': expense.amountMinor,
        'paidByMemberId': expense.paidByMemberId,
        'splitType': expense.splitType,
        if (expense.splitType == 'equal')
          'participantMemberIds': participantMemberIds.toSet().toList(),
        if (expense.splitType == 'custom')
          'splits': expense.splits.map((split) => split.toJson()).toList(),
        'expenseDate': expense.expenseDate,
        'category': expense.category,
        'description': expense.description,
      };
}
