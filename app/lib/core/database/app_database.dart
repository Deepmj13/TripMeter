import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/models/models.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalUserProfile,
    LocalTrips,
    LocalMembers,
    LocalInvitations,
    LocalExpenses,
    LocalExpenseSplits,
    LocalSettlements,
    OutboxOperations,
    SyncCursors,
    UserSyncCursors,
    SyncConflicts,
    DeviceState,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_local_expenses_trip_date '
            'ON local_expenses(trip_id, expense_date DESC, id DESC)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_local_expenses_trip_sync '
            'ON local_expenses(trip_id, sync_status)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_local_members_trip '
            'ON local_members(trip_id)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_local_settlements_trip '
            'ON local_settlements(trip_id, payment_date DESC)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_outbox_ready '
            'ON outbox_operations(state, next_attempt_at, created_at)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_conflicts_open '
            'ON sync_conflicts(trip_id, resolved_at)',
          );
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // Email verification was removed from the product; drop the
            // cached flag from existing installs.
            await migrator.dropColumn(localUserProfile, 'email_verified');
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------- profile

  Future<void> saveProfile(AppUser user, int syncVersion) async {
    await into(localUserProfile).insertOnConflictUpdate(
      LocalUserProfileCompanion(
        userId: Value(user.id),
        name: Value(user.name),
        email: Value(user.email),
        notificationPreferencesJson:
            Value(jsonEncode(user.notificationPreferences)),
        serverSyncVersion: Value(syncVersion),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> updateProfileName(String userId, String name) async {
    await (update(localUserProfile)..where((t) => t.userId.equals(userId))).write(
      LocalUserProfileCompanion(name: Value(name), updatedAt: Value(_now())),
    );
  }

  Future<LocalUserProfileData?> getProfile() =>
      (select(localUserProfile)..limit(1)).getSingleOrNull();

  // ------------------------------------------------------------------ trips

  Stream<List<LocalTrip>> watchTrips() =>
      (select(localTrips)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();

  Future<List<LocalTrip>> trips() =>
      (select(localTrips)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();

  Future<LocalTrip?> getTrip(String tripId) =>
      (select(localTrips)..where((t) => t.id.equals(tripId))).getSingleOrNull();

  Future<void> upsertTrip(Trip trip, {int? serverSyncVersion}) async {
    final existing = await getTrip(trip.id);
    await into(localTrips).insertOnConflictUpdate(
      _tripCompanion(
        trip,
        myRole: trip.myRole == 'member' && existing != null
            ? existing.myRole
            : trip.myRole,
        memberId: trip.memberId ?? existing?.memberId,
        serverSyncVersion: serverSyncVersion ?? existing?.serverSyncVersion ?? 0,
      ),
    );
  }

  Future<void> deleteTripLocal(String tripId) async {
    await transaction(() => _purgeTrip(tripId));
  }

  // ---------------------------------------------------------------- members

  Stream<List<LocalMember>> watchMembers(String tripId) => (select(localMembers)
        ..where((t) => t.tripId.equals(tripId))
        ..orderBy([
          (t) => OrderingTerm.asc(t.status),
          (t) => OrderingTerm.asc(t.displayName),
        ]))
      .watch();

  Future<List<LocalMember>> members(String tripId) =>
      (select(localMembers)..where((t) => t.tripId.equals(tripId))).get();

  Future<void> upsertMember(TripMember member) async {
    await into(localMembers).insertOnConflictUpdate(
      _memberCompanion(member),
    );
  }

  // ------------------------------------------------------------ invitations

  Stream<List<LocalInvitation>> watchInvitations() =>
      (select(localInvitations)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<void> upsertInvitation(Invitation invitation) async {
    if (invitation.email.isEmpty) {
      final existing = await (select(localInvitations)
            ..where((t) => t.id.equals(invitation.id)))
          .getSingleOrNull();
      if (existing != null) {
        await (update(localInvitations)..where((t) => t.id.equals(invitation.id)))
            .write(
          LocalInvitationsCompanion(
            status: Value(invitation.status),
            updatedAt: Value(invitation.updatedAt?.toIso8601String() ?? _now()),
          ),
        );
      }
      return;
    }
    await into(localInvitations).insertOnConflictUpdate(
      LocalInvitationsCompanion(
        id: Value(invitation.id),
        tripId: Value(invitation.tripId),
        tripName: Value(invitation.tripName),
        emailNormalized: Value(invitation.email),
        role: Value(invitation.role),
        status: Value(invitation.status),
        expiresAt: Value(invitation.expiresAt),
        createdAt:
            Value(invitation.createdAt?.toIso8601String() ?? _now()),
        updatedAt:
            Value(invitation.updatedAt?.toIso8601String() ?? _now()),
      ),
    );
  }

  // --------------------------------------------------------------- expenses

  Stream<List<Expense>> watchExpenses(String tripId) {
    final query = select(localExpenses)
      ..where((t) => t.tripId.equals(tripId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.expenseDate),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().asyncMap((rows) async {
      final result = <Expense>[];
      for (final row in rows) {
        result.add(await _readExpense(row));
      }
      return result;
    });
  }

  Future<List<Expense>> expenses(String tripId) async {
    final rows = await (select(localExpenses)
          ..where((t) => t.tripId.equals(tripId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.expenseDate),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();
    return Future.wait(rows.map(_readExpense));
  }

  Future<Expense?> getExpense(String expenseId) async {
    final row = await (select(localExpenses)
          ..where((t) => t.id.equals(expenseId)))
        .getSingleOrNull();
    return row == null ? null : _readExpense(row);
  }

  Future<LocalExpense?> getLocalExpense(String expenseId) =>
      (select(localExpenses)..where((t) => t.id.equals(expenseId)))
          .getSingleOrNull();

  Future<void> saveLocalExpense(
    Expense expense, {
    required String operationId,
    required String operationType,
    required String method,
    required String endpoint,
    required Map<String, dynamic> payload,
    int? baseVersion,
    required bool pending,
  }) async {
    await transaction(() async {
      await _writeExpense(
        expense,
        pending: pending,
        baseVersion: baseVersion,
      );
      await into(outboxOperations).insertOnConflictUpdate(
        _outboxCompanion(
          id: operationId,
          tripId: expense.tripId,
          entityType: 'expense',
          entityId: expense.id,
          operationType: operationType,
          method: method,
          endpoint: endpoint,
          payload: payload,
          baseVersion: baseVersion,
        ),
      );
    });
  }

  Future<void> saveSyncedExpense(Expense expense) async {
    await transaction(() async {
      await _writeExpense(expense, pending: false);
    });
  }

  /// Clears the pending overlay after a conflict has been recorded or the
  /// server version has been applied. The local row is kept so the UI can show
  /// the current server state.
  Future<void> clearPendingLocalChange(
    String entityType,
    String entityId, {
    String syncStatus = 'synced',
  }) async {
    if (entityType == 'expense') {
      await (update(localExpenses)..where((t) => t.id.equals(entityId))).write(
        LocalExpensesCompanion(
          hasPendingLocalChange: const Value(false),
          syncStatus: Value(syncStatus),
          localPatch: const Value(null),
          updatedAt: Value(_now()),
        ),
      );
    } else if (entityType == 'settlement') {
      await (update(localSettlements)..where((t) => t.id.equals(entityId))).write(
        LocalSettlementsCompanion(
          hasPendingLocalChange: const Value(false),
          syncStatus: Value(syncStatus),
          localPatch: const Value(null),
          updatedAt: Value(_now()),
        ),
      );
    }
  }

  Future<void> markExpenseDeletedLocal(String expenseId) async {
    await (update(localExpenses)..where((t) => t.id.equals(expenseId))).write(
      LocalExpensesCompanion(
        deletedAt: Value(_now()),
        status: Value('deleted'),
        hasPendingLocalChange: const Value(true),
        syncStatus: const Value('pending'),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> removeExpenseLocal(String expenseId) async {
    await transaction(() async {
      await (delete(localExpenseSplits)
            ..where((t) => t.expenseId.equals(expenseId)))
          .go();
      await (delete(localExpenses)..where((t) => t.id.equals(expenseId))).go();
    });
  }

  // ------------------------------------------------------------ settlements

  Stream<List<Settlement>> watchSettlements(String tripId) {
    final query = select(localSettlements)
      ..where((t) => t.tripId.equals(tripId))
      ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]);
    return query.watch().map((rows) => rows.map(_readSettlement).toList());
  }

  Future<List<Settlement>> settlements(String tripId) async {
    final rows = await (select(localSettlements)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
        .get();
    return rows.map(_readSettlement).toList();
  }

  Future<LocalSettlement?> getLocalSettlement(String settlementId) =>
      (select(localSettlements)..where((t) => t.id.equals(settlementId)))
          .getSingleOrNull();

  Future<void> saveLocalSettlement(
    Settlement settlement, {
    required String operationId,
    required String operationType,
    required String method,
    required String endpoint,
    required Map<String, dynamic> payload,
    int? baseVersion,
    required bool pending,
  }) async {
    await transaction(() async {
      await _writeSettlement(
        settlement,
        pending: pending,
        baseVersion: baseVersion,
      );
      await into(outboxOperations).insertOnConflictUpdate(
        _outboxCompanion(
          id: operationId,
          tripId: settlement.tripId,
          entityType: 'settlement',
          entityId: settlement.id,
          operationType: operationType,
          method: method,
          endpoint: endpoint,
          payload: payload,
          baseVersion: baseVersion,
        ),
      );
    });
  }

  Future<void> saveSyncedSettlement(Settlement settlement) async {
    await _writeSettlement(settlement, pending: false);
  }

  // ----------------------------------------------------------------- outbox

  Future<void> enqueueOperation({
    required String id,
    required String tripId,
    required String entityType,
    required String entityId,
    required String operationType,
    required String method,
    required String endpoint,
    required Map<String, dynamic> payload,
    int? baseVersion,
  }) async {
    await into(outboxOperations).insertOnConflictUpdate(
      _outboxCompanion(
        id: id,
        tripId: tripId,
        entityType: entityType,
        entityId: entityId,
        operationType: operationType,
        method: method,
        endpoint: endpoint,
        payload: payload,
        baseVersion: baseVersion,
      ),
    );
  }

  Future<List<LocalOutboxOperation>> operationsForTrip(String tripId) =>
      (select(outboxOperations)
            ..where((t) =>
                t.tripId.equals(tripId) &
                t.state.isIn(const ['pending', 'inFlight']))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<LocalOutboxOperation>> allPendingOperations() =>
      (select(outboxOperations)
            ..where((t) => t.state.isIn(const ['pending', 'inFlight']))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<LocalOutboxOperation>> operationsForEntity(
    String entityId,
  ) =>
      (select(outboxOperations)
            ..where((t) =>
                t.entityId.equals(entityId) &
                t.state.isIn(const ['pending', 'inFlight']))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Stream<int> watchPendingOperationCount() {
    final query = selectOnly(outboxOperations)
      ..addColumns([outboxOperations.id.count()])
      ..where(outboxOperations.state.isIn(const ['pending', 'inFlight']));
    return query.watchSingle().map((row) => row.read(outboxOperations.id.count()) ?? 0);
  }

  Future<int> pendingOperationCount() async {
    final count = outboxOperations.id.count();
    final query = selectOnly(outboxOperations)
      ..addColumns([count])
      ..where(outboxOperations.state.isIn(const ['pending', 'inFlight']));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> markOperation(
    String operationId, {
    required String state,
    String? lastError,
    int? attemptCount,
    String? nextAttemptAt,
  }) async {
    await (update(outboxOperations)
          ..where((t) => t.id.equals(operationId)))
        .write(
      OutboxOperationsCompanion(
        state: Value(state),
        lastError: Value(lastError),
        attemptCount:
            attemptCount == null ? const Value.absent() : Value(attemptCount),
        nextAttemptAt: Value(nextAttemptAt),
        lockedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> deleteOperation(String operationId) async {
    await (delete(outboxOperations)..where((t) => t.id.equals(operationId))).go();
  }

  Future<void> recoverInFlightOperations() async {
    await (update(outboxOperations)..where((t) => t.state.equals('inFlight')))
        .write(
      OutboxOperationsCompanion(
        state: const Value('pending'),
        lockedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  // --------------------------------------------------------------- conflicts

  Stream<List<SyncConflict>> watchConflicts() => (select(syncConflicts)
        ..where((t) => t.resolvedAt.isNull())
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Future<List<SyncConflict>> openConflicts() => (select(syncConflicts)
        ..where((t) => t.resolvedAt.isNull())
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .get();

  Future<void> addConflict({
    required String tripId,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> localPayload,
    required Map<String, dynamic> serverPayload,
    int? baseVersion,
    int? serverVersion,
  }) async {
    await into(syncConflicts).insertOnConflictUpdate(
      SyncConflictsCompanion(
        id: Value(const Uuid().v4()),
        tripId: Value(tripId),
        entityType: Value(entityType),
        entityId: Value(entityId),
        localPayload: Value(jsonEncode(localPayload)),
        serverPayload: Value(jsonEncode(serverPayload)),
        baseVersion: Value(baseVersion),
        serverVersion: Value(serverVersion),
        createdAt: Value(_now()),
      ),
    );
  }

  Future<void> resolveConflict(
    String conflictId, {
    required String resolution,
  }) async {
    await (update(syncConflicts)..where((t) => t.id.equals(conflictId))).write(
      SyncConflictsCompanion(
        resolvedAt: Value(_now()),
        resolution: Value(resolution),
      ),
    );
  }

  // ------------------------------------------------------------------ cursors

  Future<int> tripCursor(String tripId) async {
    final row = await (select(syncCursors)
          ..where((t) => t.tripId.equals(tripId)))
        .getSingleOrNull();
    return row?.lastSequence ?? 0;
  }

  Future<void> setTripCursor(String tripId, int sequence) async {
    await into(syncCursors).insertOnConflictUpdate(
      SyncCursorsCompanion(
        tripId: Value(tripId),
        lastSequence: Value(sequence),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<int> userCursor(String userId) async {
    final row = await (select(userSyncCursors)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    return row?.lastSequence ?? 0;
  }

  Future<void> setUserCursor(String userId, int sequence) async {
    await into(userSyncCursors).insertOnConflictUpdate(
      UserSyncCursorsCompanion(
        userId: Value(userId),
        lastSequence: Value(sequence),
        updatedAt: Value(_now()),
      ),
    );
  }

  // ------------------------------------------------------------ event apply

  Future<bool> applyTripEvent(
    Map<String, dynamic> event, {
    required String tripId,
  }) async {
    final sequence = _int(event['sequence']);
    final current = await tripCursor(tripId);
    if (sequence <= current) return false;

    final entityType = event['entityType']?.toString() ?? '';    final payload = (event['payload'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    await transaction(() async {
      switch (entityType) {
        case 'expense':
          await _applyServerExpense(payload, tripId);
        case 'settlement':
          await _applyServerSettlement(payload, tripId);
        case 'member':
          if (payload['id'] != null) {
            await upsertMember(TripMember.fromJson(payload));
          }
        case 'trip':
          if (payload['id'] != null) {
            await upsertTrip(Trip.fromJson({...payload, 'myRole': 'member'}));
          }
      }
      await setTripCursor(tripId, sequence);
    });
    return true;
  }

  Future<void> _applyServerExpense(
    Map<String, dynamic> payload,
    String tripId,
  ) async {
    if (payload['id'] == null) return;
    final expense = Expense.fromJson({...payload, 'tripId': tripId});
    final existing = await getLocalExpense(expense.id);
    if (existing != null && (existing.serverVersion ?? 0) > expense.version) {
      return;
    }
    if (existing != null && existing.hasPendingLocalChange) {
      await addConflict(
        tripId: tripId,
        entityType: 'expense',
        entityId: expense.id,
        localPayload: _localExpenseJson(existing, await _splitsFor(expense.id)),
        serverPayload: expense.toJson(),
        baseVersion: existing.baseVersion,
        serverVersion: expense.version,
      );
      return;
    }
    await _writeExpense(expense, pending: false);
  }

  Future<void> _applyServerSettlement(
    Map<String, dynamic> payload,
    String tripId,
  ) async {
    if (payload['id'] == null) return;
    final settlement = Settlement.fromJson({...payload, 'tripId': tripId});
    final existing = await getLocalSettlement(settlement.id);
    if (existing != null && (existing.serverVersion ?? 0) > settlement.version) {
      return;
    }
    if (existing != null && existing.hasPendingLocalChange) {
      await addConflict(
        tripId: tripId,
        entityType: 'settlement',
        entityId: settlement.id,
        localPayload:
            Map<String, dynamic>.from(jsonDecode(existing.localPatch ?? '{}') as Map),
        serverPayload: settlement.toJson(),
        baseVersion: existing.baseVersion,
        serverVersion: settlement.version,
      );
      return;
    }
    await _writeSettlement(settlement, pending: false);
  }

  Future<void> applyUserEvent(
    Map<String, dynamic> event, {
    required String userId,
  }) async {
    final sequence = _int(event['sequence']);
    final current = await userCursor(userId);
    if (sequence <= current) return;
    final eventType = event['eventType']?.toString() ?? '';
    final payload = (event['payload'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final tripId = event['tripId']?.toString() ?? payload['tripId']?.toString();

    await transaction(() async {
      if (eventType == 'trip.access.revoked' && tripId != null) {
        await _purgeTrip(tripId);
      } else if (eventType.startsWith('invitation.') && payload['invitationId'] != null) {
        final existing = await (select(localInvitations)
              ..where((t) => t.id.equals(payload['invitationId'].toString())))
            .getSingleOrNull();
        if (existing != null) {
          await (update(localInvitations)
                ..where((t) => t.id.equals(existing.id)))
              .write(
            LocalInvitationsCompanion(
              status: Value(payload['status']?.toString() ?? existing.status),
              updatedAt: Value(_now()),
            ),
          );
        }
      }
      await setUserCursor(userId, sequence);
    });
  }

  // --------------------------------------------------------------- snapshots

  Future<void> replaceUserSnapshot(
    UserSnapshot snapshot, {
    required String userId,
  }) async {
    await transaction(() async {
      await saveProfile(snapshot.profile, snapshot.sequence);
      final keepIds = snapshot.trips.map((trip) => trip.id).toSet();
      final existingTrips = await trips();
      for (final existing in existingTrips) {
        if (keepIds.contains(existing.id)) continue;
        final pending = await operationsForTrip(existing.id);
        if (pending.isEmpty) await _purgeTrip(existing.id);
      }
      for (final trip in snapshot.trips) {
        await upsertTrip(trip, serverSyncVersion: snapshot.sequence);
      }
      await delete(localInvitations).go();
      for (final invitation in snapshot.invitations) {
        await upsertInvitation(invitation);
      }
      await setUserCursor(userId, snapshot.sequence);
    });
  }

  Future<void> replaceTripSnapshot(
    TripSnapshot snapshot, {
    String? currentUserId,
  }) async {
    await transaction(() async {
      final existingTrip = await getTrip(snapshot.trip.id);
      var role = existingTrip?.myRole ?? 'member';
      String? memberId = existingTrip?.memberId;
      if (currentUserId != null) {
        for (final member in snapshot.members) {
          if (member.userId == currentUserId) {
            role = member.role;
            memberId = member.id;
          }
        }
      }
      await into(localTrips).insertOnConflictUpdate(
        _tripCompanion(
          snapshot.trip,
          myRole: role,
          memberId: memberId,
          serverSyncVersion: snapshot.sequence,
        ),
      );

      await (delete(localMembers)
            ..where((t) => t.tripId.equals(snapshot.trip.id)))
          .go();
      for (final member in snapshot.members) {
        await into(localMembers).insertOnConflictUpdate(_memberCompanion(member));
      }

      final expenseRows = await (select(localExpenses)
            ..where((t) => t.tripId.equals(snapshot.trip.id)))
          .get();
      final pendingExpenseIds = expenseRows
          .where((expense) => expense.hasPendingLocalChange)
          .map((expense) => expense.id)
          .toSet();
      final snapshotExpenseIds = snapshot.expenses.map((e) => e.id).toSet();
      for (final local in expenseRows) {
        if (!pendingExpenseIds.contains(local.id)) {
          await (delete(localExpenseSplits)
                ..where((t) => t.expenseId.equals(local.id)))
              .go();
          await (delete(localExpenses)..where((t) => t.id.equals(local.id))).go();
        }
      }
      for (final expense in snapshot.expenses) {
        if (snapshotExpenseIds.contains(expense.id) &&
            !pendingExpenseIds.contains(expense.id)) {
          await _writeExpense(expense, pending: false);
        }
      }

      final settlementRows = await (select(localSettlements)
            ..where((t) => t.tripId.equals(snapshot.trip.id)))
          .get();
      final pendingSettlementIds = settlementRows
          .where((settlement) => settlement.hasPendingLocalChange)
          .map((settlement) => settlement.id)
          .toSet();
      for (final local in settlementRows) {
        if (!pendingSettlementIds.contains(local.id)) {
          await (delete(localSettlements)..where((t) => t.id.equals(local.id)))
              .go();
        }
      }
      for (final settlement in snapshot.settlements) {
        if (!pendingSettlementIds.contains(settlement.id)) {
          await _writeSettlement(settlement, pending: false);
        }
      }

      await setTripCursor(snapshot.trip.id, snapshot.sequence);
    });
  }

  // -------------------------------------------------------------- device state

  Future<String?> getDeviceState(String key) async {
    final row = await (select(deviceState)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setDeviceState(String key, String value) async {
    await into(deviceState)
        .insertOnConflictUpdate(DeviceStateCompanion.insert(key: key, value: value));
  }

  Future<void> clearAll() async {
    await transaction(() async {
      await delete(localExpenseSplits).go();
      await delete(localExpenses).go();
      await delete(localSettlements).go();
      await delete(localMembers).go();
      await delete(localTrips).go();
      await delete(localInvitations).go();
      await delete(localUserProfile).go();
      await delete(outboxOperations).go();
      await delete(syncCursors).go();
      await delete(userSyncCursors).go();
      await delete(syncConflicts).go();
      await delete(deviceState).go();
    });
  }

  // ------------------------------------------------------------------ private

  Future<void> _purgeTrip(String tripId) async {
    final expenseIds = await (select(localExpenses)
          ..where((t) => t.tripId.equals(tripId)))
        .get()
        .then((rows) => rows.map((row) => row.id).toList());
    for (final id in expenseIds) {
      await (delete(localExpenseSplits)..where((t) => t.expenseId.equals(id))).go();
    }
    await (delete(localExpenses)..where((t) => t.tripId.equals(tripId))).go();
    await (delete(localSettlements)..where((t) => t.tripId.equals(tripId))).go();
    await (delete(localMembers)..where((t) => t.tripId.equals(tripId))).go();
    await (delete(localTrips)..where((t) => t.id.equals(tripId))).go();
    await (delete(outboxOperations)..where((t) => t.tripId.equals(tripId))).go();
    await (delete(syncCursors)..where((t) => t.tripId.equals(tripId))).go();
    await (delete(syncConflicts)..where((t) => t.tripId.equals(tripId))).go();
  }

  Future<void> _writeExpense(
    Expense expense, {
    required bool pending,
    int? baseVersion,
  }) async {
    final existing = await getLocalExpense(expense.id);
    await into(localExpenses).insertOnConflictUpdate(
      LocalExpensesCompanion(
        id: Value(expense.id),
        tripId: Value(expense.tripId),
        paidByMemberId: Value(expense.paidByMemberId),
        createdByUserId: Value(expense.createdByUserId),
        updatedByUserId: Value(expense.updatedByUserId),
        deletedByUserId: Value(expense.deletedByUserId),
        title: Value(expense.title),
        amountMinor: Value(expense.amountMinor),
        currency: Value(expense.currency),
        splitType: Value(expense.splitType),
        category: Value(expense.category),
        description: Value(expense.description),
        expenseDate: Value(expense.expenseDate),
        status: Value(expense.status),
        version: Value(expense.version),
        serverVersion: Value(expense.version),
        baseVersion: Value(baseVersion ?? existing?.baseVersion),
        hasPendingLocalChange: Value(pending),
        syncStatus: Value(pending ? 'pending' : 'synced'),
        serverPayload: Value(pending ? null : jsonEncode(expense.toJson())),
        localPatch: Value(pending ? jsonEncode(expense.toJson()) : null),
        clientCreatedAt: Value(expense.clientCreatedAt),
        createdAt: Value(existing?.createdAt ?? _now()),
        updatedAt: Value(_now()),
        deletedAt: Value(expense.deletedAt),
      ),
    );
    await (delete(localExpenseSplits)
          ..where((t) => t.expenseId.equals(expense.id)))
        .go();
    await batch((batch) {
      batch.insertAll(
        localExpenseSplits,
        expense.splits
            .map(
              (split) => LocalExpenseSplitsCompanion.insert(
                expenseId: expense.id,
                memberId: split.memberId,
                amountMinor: split.amountMinor,
              ),
            )
            .toList(),
      );
    });
  }

  Future<void> _writeSettlement(
    Settlement settlement, {
    required bool pending,
    int? baseVersion,
  }) async {
    final existing = await getLocalSettlement(settlement.id);
    await into(localSettlements).insertOnConflictUpdate(
      LocalSettlementsCompanion(
        id: Value(settlement.id),
        tripId: Value(settlement.tripId),
        paidByMemberId: Value(settlement.paidByMemberId),
        paidToMemberId: Value(settlement.paidToMemberId),
        amountMinor: Value(settlement.amountMinor),
        paymentDate: Value(settlement.paymentDate),
        status: Value(settlement.status),
        recordedByUserId: Value(settlement.recordedByUserId),
        confirmedByUserId: Value(settlement.confirmedByUserId),
        statusChangedByUserId: Value(settlement.statusChangedByUserId),
        statusChangedAt: Value(settlement.statusChangedAt),
        rejectionReason: Value(settlement.rejectionReason),
        note: Value(settlement.note),
        version: Value(settlement.version),
        serverVersion: Value(settlement.version),
        baseVersion: Value(baseVersion ?? existing?.baseVersion),
        hasPendingLocalChange: Value(pending),
        syncStatus: Value(pending ? 'pending' : 'synced'),
        serverPayload: Value(pending ? null : jsonEncode(settlement.toJson())),
        localPatch: Value(pending ? jsonEncode(settlement.toJson()) : null),
        createdAt: Value(existing?.createdAt ?? _now()),
        updatedAt: Value(_now()),
        confirmedAt: Value(settlement.confirmedAt),
      ),
    );
  }

  Future<Expense> _readExpense(LocalExpense row) async {
    final splits = await _splitsFor(row.id);
    return Expense(
      id: row.id,
      tripId: row.tripId,
      title: row.title,
      amountMinor: row.amountMinor,
      currency: row.currency,
      paidByMemberId: row.paidByMemberId,
      createdByUserId: row.createdByUserId,
      updatedByUserId: row.updatedByUserId,
      deletedByUserId: row.deletedByUserId,
      splitType: row.splitType,
      splits: splits,
      category: row.category,
      expenseDate: row.expenseDate,
      description: row.description,
      status: row.status,
      version: row.serverVersion ?? row.version,
      clientCreatedAt: row.clientCreatedAt,
      deletedAt: row.deletedAt,
      createdAt: DateTime.tryParse(row.createdAt),
      updatedAt: DateTime.tryParse(row.updatedAt),
      hasPendingLocalChange: row.hasPendingLocalChange,
      syncStatus: row.syncStatus,
    );
  }

  Future<List<ExpenseSplit>> _splitsFor(String expenseId) async {
    final rows = await (select(localExpenseSplits)
          ..where((t) => t.expenseId.equals(expenseId)))
        .get();
    return rows
        .map((row) => ExpenseSplit(memberId: row.memberId, amountMinor: row.amountMinor))
        .toList();
  }

  Settlement _readSettlement(LocalSettlement row) => Settlement(
        id: row.id,
        tripId: row.tripId,
        paidByMemberId: row.paidByMemberId,
        paidToMemberId: row.paidToMemberId,
        amountMinor: row.amountMinor,
        paymentDate: row.paymentDate,
        status: row.status,
        recordedByUserId: row.recordedByUserId,
        confirmedByUserId: row.confirmedByUserId,
        statusChangedByUserId: row.statusChangedByUserId,
        statusChangedAt: row.statusChangedAt,
        rejectionReason: row.rejectionReason,
        note: row.note,
        version: row.serverVersion ?? row.version,
        confirmedAt: row.confirmedAt,
        createdAt: DateTime.tryParse(row.createdAt),
        updatedAt: row.updatedAt == null ? null : DateTime.tryParse(row.updatedAt!),
        hasPendingLocalChange: row.hasPendingLocalChange,
        syncStatus: row.syncStatus,
      );

  Map<String, dynamic> _localExpenseJson(
    LocalExpense row,
    List<ExpenseSplit> splits,
  ) =>
      {
        'id': row.id,
        'tripId': row.tripId,
        'title': row.title,
        'amountMinor': row.amountMinor,
        'currency': row.currency,
        'paidByMemberId': row.paidByMemberId,
        'splitType': row.splitType,
        'splits': splits.map((split) => split.toJson()).toList(),
        'category': row.category,
        'expenseDate': row.expenseDate,
        'description': row.description,
        'version': row.serverVersion ?? row.version,
        'status': row.status,
        'deletedAt': row.deletedAt,
      };

  LocalTripsCompanion _tripCompanion(
    Trip trip, {
    required String myRole,
    String? memberId,
    required int serverSyncVersion,
  }) =>
      LocalTripsCompanion(
        id: Value(trip.id),
        name: Value(trip.name),
        destination: Value(trip.destination),
        description: Value(trip.description),
        currency: Value(trip.currency),
        currencyExponent: Value(trip.currencyExponent),
        ownerUserId: Value(trip.ownerUserId),
        createdByUserId: Value(trip.createdByUserId),
        myRole: Value(myRole),
        memberId: Value(memberId),
        startDate: Value(trip.startDate),
        endDate: Value(trip.endDate),
        archivedAt: Value(trip.archivedAt),
        serverSyncVersion: Value(serverSyncVersion),
        cachedAt: Value(_now()),
        updatedAt: Value(trip.updatedAt?.toIso8601String() ?? _now()),
      );

  LocalMembersCompanion _memberCompanion(TripMember member) =>
      LocalMembersCompanion(
        id: Value(member.id),
        tripId: Value(member.tripId),
        userId: Value(member.userId),
        displayName: Value(member.displayName),
        emailNormalized: Value(member.email),
        memberKind: Value(member.memberKind),
        role: Value(member.role),
        status: Value(member.status),
        joinedAt: Value(member.joinedAt),
        serverVersion: Value(member.serverVersion),
        updatedAt: Value(member.updatedAt?.toIso8601String() ?? _now()),
      );

  OutboxOperationsCompanion _outboxCompanion({
    required String id,
    required String tripId,
    required String entityType,
    required String entityId,
    required String operationType,
    required String method,
    required String endpoint,
    required Map<String, dynamic> payload,
    int? baseVersion,
  }) =>
      OutboxOperationsCompanion(
        id: Value(id),
        tripId: Value(tripId),
        entityType: Value(entityType),
        entityId: Value(entityId),
        operationType: Value(operationType),
        method: Value(method),
        endpoint: Value(endpoint),
        payload: Value(jsonEncode(payload)),
        requestHash: Value(id),
        baseVersion: Value(baseVersion),
        state: const Value('pending'),
        attemptCount: const Value(0),
        nextAttemptAt: const Value(null),
        lockedAt: const Value(null),
        lastError: const Value(null),
        createdAt: Value(_now()),
        updatedAt: Value(_now()),
      );

  String _now() => DateTime.now().toUtc().toIso8601String();

  int _int(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

/// Permission helpers mirroring the server-side role rules.
extension LocalTripPermissions on LocalTrip {
  bool get isArchived => archivedAt != null;
  bool get canWrite => archivedAt == null;
  bool get isAdmin => myRole == 'owner' || myRole == 'admin';
}

