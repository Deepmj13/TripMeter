import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripmeter/core/database/app_database.dart';
import 'package:tripmeter/shared/models/models.dart';

AppDatabase openDatabase(File file) => AppDatabase(NativeDatabase(file));

Expense buildExpense({
  String id = 'expense-1',
  String title = 'Dinner',
  int version = 1,
  int amountMinor = 2000,
}) {
  return Expense(
    id: id,
    tripId: 'trip-1',
    title: title,
    amountMinor: amountMinor,
    currency: 'INR',
    paidByMemberId: 'member-a',
    createdByUserId: 'user-1',
    splitType: 'equal',
    splits: const [
      ExpenseSplit(memberId: 'member-a', amountMinor: 1000),
      ExpenseSplit(memberId: 'member-b', amountMinor: 1000),
    ],
    expenseDate: '2026-02-01',
    category: 'food',
    status: 'active',
    version: version,
  );
}

Future<void> savePendingExpense(
  AppDatabase db, {
  String title = 'Local dinner',
  int version = 1,
  String operationId = 'op-1',
}) {
  return db.saveLocalExpense(
    buildExpense(title: title, version: version),
    operationId: operationId,
    operationType: 'create',
    method: 'POST',
    endpoint: '/trips/trip-1/expenses',
    payload: buildExpense(title: title, version: version).toJson(),
    baseVersion: version,
    pending: true,
  );
}

Map<String, dynamic> expenseEvent({
  required int sequence,
  String title = 'Server dinner',
  int version = 2,
}) {
  return {
    'sequence': sequence,
    'entityType': 'expense',
    'entityId': 'expense-1',
    'payload': buildExpense(title: title, version: version).toJson(),
  };
}

void main() {
  late Directory tempDir;
  late File databaseFile;
  late AppDatabase db;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('tripmeter_test_');
    databaseFile = File('${tempDir.path}/local.sqlite');
    db = openDatabase(databaseFile);
  });

  tearDown(() async {
    await db.close();
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {
      // Windows can briefly hold the sqlite handle.
    }
  });

  test('expense, splits and outbox operation are written together', () async {
    await savePendingExpense(db);

    final expenses = await db.expenses('trip-1');
    expect(expenses, hasLength(1));
    expect(expenses.single.splits, hasLength(2));
    expect(expenses.single.hasPendingLocalChange, isTrue);
    expect(expenses.single.syncStatus, 'pending');

    final operations = await db.operationsForTrip('trip-1');
    expect(operations, hasLength(1));
    expect(operations.single.id, 'op-1');
    expect(operations.single.entityType, 'expense');
    expect(operations.single.endpoint, '/trips/trip-1/expenses');
  });

  test('durable outbox survives closing and reopening the database', () async {
    await savePendingExpense(db, operationId: 'durable-op');
    await db.close();

    db = openDatabase(databaseFile);
    final operations = await db.allPendingOperations();
    expect(operations, hasLength(1));
    expect(operations.single.id, 'durable-op');

    final expenses = await db.expenses('trip-1');
    expect(expenses.single.title, 'Local dinner');
    expect(expenses.single.hasPendingLocalChange, isTrue);
  });

  test('in-flight operations are recovered after a restart', () async {
    await savePendingExpense(db, operationId: 'inflight-op');
    await db.markOperation('inflight-op', state: 'inFlight', attemptCount: 3);

    await db.recoverInFlightOperations();
    final operations = await db.allPendingOperations();
    expect(operations.single.state, 'pending');
    expect(operations.single.attemptCount, 3);
  });

  test('duplicate and out-of-order events are ignored', () async {
    expect(
      await db.applyTripEvent(expenseEvent(sequence: 2), tripId: 'trip-1'),
      isTrue,
    );
    expect(
      await db.applyTripEvent(expenseEvent(sequence: 2), tripId: 'trip-1'),
      isFalse,
    );
    expect(
      await db.applyTripEvent(
        expenseEvent(sequence: 1, title: 'Stale dinner'),
        tripId: 'trip-1',
      ),
      isFalse,
    );

    expect(await db.tripCursor('trip-1'), 2);
    final expense = await db.getExpense('expense-1');
    expect(expense?.title, 'Server dinner');
  });

  test('a server event over a pending change records a conflict', () async {
    await savePendingExpense(db, title: 'Local dinner', version: 1);

    await db.applyTripEvent(
      expenseEvent(sequence: 3, title: 'Server dinner', version: 2),
      tripId: 'trip-1',
    );

    final conflicts = await db.openConflicts();
    expect(conflicts, hasLength(1));
    expect(conflicts.single.entityId, 'expense-1');

    // The local overlay is cleared when the conflict is acknowledged, then the
    // authoritative server state can be applied by the next pull.
    await db.clearPendingLocalChange('expense', 'expense-1');
    await db.applyTripEvent(
      expenseEvent(sequence: 4, title: 'Server dinner', version: 2),
      tripId: 'trip-1',
    );

    final expense = await db.getExpense('expense-1');
    expect(expense?.title, 'Server dinner');
    expect(expense?.hasPendingLocalChange, isFalse);
  });
}
