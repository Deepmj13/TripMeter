import 'package:drift/drift.dart';

@DataClassName('LocalUserProfileData')
class LocalUserProfile extends Table {
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  BoolColumn get emailVerified => boolean().withDefault(const Constant(false))();
  TextColumn get notificationPreferencesJson =>
      text().withDefault(const Constant('{}'))();
  IntColumn get serverSyncVersion => integer().withDefault(const Constant(0))();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('LocalTrip')
class LocalTrips extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get destination => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get currency => text()();
  IntColumn get currencyExponent => integer().withDefault(const Constant(2))();
  TextColumn get ownerUserId => text()();
  TextColumn get createdByUserId => text()();
  TextColumn get myRole => text().withDefault(const Constant('member'))();
  TextColumn get memberId => text().nullable()();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  TextColumn get archivedAt => text().nullable()();
  IntColumn get serverSyncVersion => integer().withDefault(const Constant(0))();
  TextColumn get cachedAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalMember')
class LocalMembers extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get displayName => text()();
  TextColumn get emailNormalized => text().nullable()();
  TextColumn get memberKind => text()();
  TextColumn get role => text()();
  TextColumn get status => text()();
  TextColumn get joinedAt => text().nullable()();
  IntColumn get serverVersion => integer().withDefault(const Constant(0))();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalInvitation')
class LocalInvitations extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get tripName => text().nullable()();
  TextColumn get emailNormalized => text()();
  TextColumn get role => text()();
  TextColumn get status => text()();
  TextColumn get expiresAt => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalExpense')
class LocalExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get paidByMemberId => text()();
  TextColumn get createdByUserId => text()();
  TextColumn get updatedByUserId => text().nullable()();
  TextColumn get deletedByUserId => text().nullable()();
  TextColumn get title => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  TextColumn get splitType => text()();
  TextColumn get category => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get expenseDate => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get serverVersion => integer().nullable()();
  IntColumn get baseVersion => integer().nullable()();
  BoolColumn get hasPendingLocalChange =>
      boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  TextColumn get serverPayload => text().nullable()();
  TextColumn get localPatch => text().nullable()();
  TextColumn get clientCreatedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalExpenseSplit')
class LocalExpenseSplits extends Table {
  TextColumn get expenseId => text()();
  TextColumn get memberId => text()();
  IntColumn get amountMinor => integer()();

  @override
  Set<Column> get primaryKey => {expenseId, memberId};
}

@DataClassName('LocalSettlement')
class LocalSettlements extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get paidByMemberId => text()();
  TextColumn get paidToMemberId => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get paymentDate => text()();
  TextColumn get status => text()();
  TextColumn get recordedByUserId => text()();
  TextColumn get confirmedByUserId => text().nullable()();
  TextColumn get statusChangedByUserId => text().nullable()();
  TextColumn get statusChangedAt => text().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get serverVersion => integer().nullable()();
  IntColumn get baseVersion => integer().nullable()();
  BoolColumn get hasPendingLocalChange =>
      boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  TextColumn get serverPayload => text().nullable()();
  TextColumn get localPatch => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text().nullable()();
  TextColumn get confirmedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalOutboxOperation')
class OutboxOperations extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operationType => text()();
  TextColumn get method => text()();
  TextColumn get endpoint => text()();
  TextColumn get payload => text()();
  TextColumn get requestHash => text()();
  IntColumn get baseVersion => integer().nullable()();
  TextColumn get state => text().withDefault(const Constant('pending'))();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get nextAttemptAt => text().nullable()();
  TextColumn get lockedAt => text().nullable()();
  TextColumn get lastError => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncCursor')
class SyncCursors extends Table {
  TextColumn get tripId => text()();
  IntColumn get lastSequence => integer().withDefault(const Constant(0))();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {tripId};
}

@DataClassName('UserSyncCursor')
class UserSyncCursors extends Table {
  TextColumn get userId => text()();
  IntColumn get lastSequence => integer().withDefault(const Constant(0))();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('SyncConflict')
class SyncConflicts extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get localPayload => text()();
  TextColumn get serverPayload => text()();
  IntColumn get baseVersion => integer().nullable()();
  IntColumn get serverVersion => integer().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get resolvedAt => text().nullable()();
  TextColumn get resolution => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DeviceStateEntry')
class DeviceState extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

const localTableNames = [
  'local_user_profile',
  'local_trips',
  'local_members',
  'local_invitations',
  'local_expenses',
  'local_expense_splits',
  'local_settlements',
  'outbox_operations',
  'sync_cursors',
  'user_sync_cursors',
  'sync_conflicts',
  'device_state',
];
