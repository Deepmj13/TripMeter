// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalUserProfileTable extends LocalUserProfile
    with TableInfo<$LocalUserProfileTable, LocalUserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationPreferencesJsonMeta =
      const VerificationMeta('notificationPreferencesJson');
  @override
  late final GeneratedColumn<String> notificationPreferencesJson =
      GeneratedColumn<String>(
        'notification_preferences_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _serverSyncVersionMeta = const VerificationMeta(
    'serverSyncVersion',
  );
  @override
  late final GeneratedColumn<int> serverSyncVersion = GeneratedColumn<int>(
    'server_sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    name,
    email,
    notificationPreferencesJson,
    serverSyncVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('notification_preferences_json')) {
      context.handle(
        _notificationPreferencesJsonMeta,
        notificationPreferencesJson.isAcceptableOrUnknown(
          data['notification_preferences_json']!,
          _notificationPreferencesJsonMeta,
        ),
      );
    }
    if (data.containsKey('server_sync_version')) {
      context.handle(
        _serverSyncVersionMeta,
        serverSyncVersion.isAcceptableOrUnknown(
          data['server_sync_version']!,
          _serverSyncVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalUserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserProfileData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      notificationPreferencesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_preferences_json'],
      )!,
      serverSyncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_sync_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalUserProfileTable createAlias(String alias) {
    return $LocalUserProfileTable(attachedDatabase, alias);
  }
}

class LocalUserProfileData extends DataClass
    implements Insertable<LocalUserProfileData> {
  final String userId;
  final String name;
  final String email;
  final String notificationPreferencesJson;
  final int serverSyncVersion;
  final String updatedAt;
  const LocalUserProfileData({
    required this.userId,
    required this.name,
    required this.email,
    required this.notificationPreferencesJson,
    required this.serverSyncVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['notification_preferences_json'] = Variable<String>(
      notificationPreferencesJson,
    );
    map['server_sync_version'] = Variable<int>(serverSyncVersion);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  LocalUserProfileCompanion toCompanion(bool nullToAbsent) {
    return LocalUserProfileCompanion(
      userId: Value(userId),
      name: Value(name),
      email: Value(email),
      notificationPreferencesJson: Value(notificationPreferencesJson),
      serverSyncVersion: Value(serverSyncVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalUserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserProfileData(
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      notificationPreferencesJson: serializer.fromJson<String>(
        json['notificationPreferencesJson'],
      ),
      serverSyncVersion: serializer.fromJson<int>(json['serverSyncVersion']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'notificationPreferencesJson': serializer.toJson<String>(
        notificationPreferencesJson,
      ),
      'serverSyncVersion': serializer.toJson<int>(serverSyncVersion),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  LocalUserProfileData copyWith({
    String? userId,
    String? name,
    String? email,
    String? notificationPreferencesJson,
    int? serverSyncVersion,
    String? updatedAt,
  }) => LocalUserProfileData(
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    notificationPreferencesJson:
        notificationPreferencesJson ?? this.notificationPreferencesJson,
    serverSyncVersion: serverSyncVersion ?? this.serverSyncVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalUserProfileData copyWithCompanion(LocalUserProfileCompanion data) {
    return LocalUserProfileData(
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      notificationPreferencesJson: data.notificationPreferencesJson.present
          ? data.notificationPreferencesJson.value
          : this.notificationPreferencesJson,
      serverSyncVersion: data.serverSyncVersion.present
          ? data.serverSyncVersion.value
          : this.serverSyncVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfileData(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('notificationPreferencesJson: $notificationPreferencesJson, ')
          ..write('serverSyncVersion: $serverSyncVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    name,
    email,
    notificationPreferencesJson,
    serverSyncVersion,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserProfileData &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.email == this.email &&
          other.notificationPreferencesJson ==
              this.notificationPreferencesJson &&
          other.serverSyncVersion == this.serverSyncVersion &&
          other.updatedAt == this.updatedAt);
}

class LocalUserProfileCompanion extends UpdateCompanion<LocalUserProfileData> {
  final Value<String> userId;
  final Value<String> name;
  final Value<String> email;
  final Value<String> notificationPreferencesJson;
  final Value<int> serverSyncVersion;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const LocalUserProfileCompanion({
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.notificationPreferencesJson = const Value.absent(),
    this.serverSyncVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserProfileCompanion.insert({
    required String userId,
    required String name,
    required String email,
    this.notificationPreferencesJson = const Value.absent(),
    this.serverSyncVersion = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       name = Value(name),
       email = Value(email),
       updatedAt = Value(updatedAt);
  static Insertable<LocalUserProfileData> custom({
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? notificationPreferencesJson,
    Expression<int>? serverSyncVersion,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (notificationPreferencesJson != null)
        'notification_preferences_json': notificationPreferencesJson,
      if (serverSyncVersion != null) 'server_sync_version': serverSyncVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserProfileCompanion copyWith({
    Value<String>? userId,
    Value<String>? name,
    Value<String>? email,
    Value<String>? notificationPreferencesJson,
    Value<int>? serverSyncVersion,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserProfileCompanion(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      notificationPreferencesJson:
          notificationPreferencesJson ?? this.notificationPreferencesJson,
      serverSyncVersion: serverSyncVersion ?? this.serverSyncVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notificationPreferencesJson.present) {
      map['notification_preferences_json'] = Variable<String>(
        notificationPreferencesJson.value,
      );
    }
    if (serverSyncVersion.present) {
      map['server_sync_version'] = Variable<int>(serverSyncVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfileCompanion(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('notificationPreferencesJson: $notificationPreferencesJson, ')
          ..write('serverSyncVersion: $serverSyncVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTripsTable extends LocalTrips
    with TableInfo<$LocalTripsTable, LocalTrip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyExponentMeta = const VerificationMeta(
    'currencyExponent',
  );
  @override
  late final GeneratedColumn<int> currencyExponent = GeneratedColumn<int>(
    'currency_exponent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _myRoleMeta = const VerificationMeta('myRole');
  @override
  late final GeneratedColumn<String> myRole = GeneratedColumn<String>(
    'my_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<String> archivedAt = GeneratedColumn<String>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSyncVersionMeta = const VerificationMeta(
    'serverSyncVersion',
  );
  @override
  late final GeneratedColumn<int> serverSyncVersion = GeneratedColumn<int>(
    'server_sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<String> cachedAt = GeneratedColumn<String>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    destination,
    description,
    currency,
    currencyExponent,
    ownerUserId,
    createdByUserId,
    myRole,
    memberId,
    startDate,
    endDate,
    archivedAt,
    serverSyncVersion,
    cachedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTrip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('currency_exponent')) {
      context.handle(
        _currencyExponentMeta,
        currencyExponent.isAcceptableOrUnknown(
          data['currency_exponent']!,
          _currencyExponentMeta,
        ),
      );
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByUserIdMeta);
    }
    if (data.containsKey('my_role')) {
      context.handle(
        _myRoleMeta,
        myRole.isAcceptableOrUnknown(data['my_role']!, _myRoleMeta),
      );
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('server_sync_version')) {
      context.handle(
        _serverSyncVersionMeta,
        serverSyncVersion.isAcceptableOrUnknown(
          data['server_sync_version']!,
          _serverSyncVersionMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTrip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTrip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      currencyExponent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}currency_exponent'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      )!,
      myRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}my_role'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archived_at'],
      ),
      serverSyncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_sync_version'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalTripsTable createAlias(String alias) {
    return $LocalTripsTable(attachedDatabase, alias);
  }
}

class LocalTrip extends DataClass implements Insertable<LocalTrip> {
  final String id;
  final String name;
  final String? destination;
  final String? description;
  final String currency;
  final int currencyExponent;
  final String ownerUserId;
  final String createdByUserId;
  final String myRole;
  final String? memberId;
  final String? startDate;
  final String? endDate;
  final String? archivedAt;
  final int serverSyncVersion;
  final String cachedAt;
  final String updatedAt;
  const LocalTrip({
    required this.id,
    required this.name,
    this.destination,
    this.description,
    required this.currency,
    required this.currencyExponent,
    required this.ownerUserId,
    required this.createdByUserId,
    required this.myRole,
    this.memberId,
    this.startDate,
    this.endDate,
    this.archivedAt,
    required this.serverSyncVersion,
    required this.cachedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['currency'] = Variable<String>(currency);
    map['currency_exponent'] = Variable<int>(currencyExponent);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['created_by_user_id'] = Variable<String>(createdByUserId);
    map['my_role'] = Variable<String>(myRole);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<String>(archivedAt);
    }
    map['server_sync_version'] = Variable<int>(serverSyncVersion);
    map['cached_at'] = Variable<String>(cachedAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  LocalTripsCompanion toCompanion(bool nullToAbsent) {
    return LocalTripsCompanion(
      id: Value(id),
      name: Value(name),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      currency: Value(currency),
      currencyExponent: Value(currencyExponent),
      ownerUserId: Value(ownerUserId),
      createdByUserId: Value(createdByUserId),
      myRole: Value(myRole),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      serverSyncVersion: Value(serverSyncVersion),
      cachedAt: Value(cachedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalTrip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTrip(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      destination: serializer.fromJson<String?>(json['destination']),
      description: serializer.fromJson<String?>(json['description']),
      currency: serializer.fromJson<String>(json['currency']),
      currencyExponent: serializer.fromJson<int>(json['currencyExponent']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      createdByUserId: serializer.fromJson<String>(json['createdByUserId']),
      myRole: serializer.fromJson<String>(json['myRole']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      archivedAt: serializer.fromJson<String?>(json['archivedAt']),
      serverSyncVersion: serializer.fromJson<int>(json['serverSyncVersion']),
      cachedAt: serializer.fromJson<String>(json['cachedAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'destination': serializer.toJson<String?>(destination),
      'description': serializer.toJson<String?>(description),
      'currency': serializer.toJson<String>(currency),
      'currencyExponent': serializer.toJson<int>(currencyExponent),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'createdByUserId': serializer.toJson<String>(createdByUserId),
      'myRole': serializer.toJson<String>(myRole),
      'memberId': serializer.toJson<String?>(memberId),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'archivedAt': serializer.toJson<String?>(archivedAt),
      'serverSyncVersion': serializer.toJson<int>(serverSyncVersion),
      'cachedAt': serializer.toJson<String>(cachedAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  LocalTrip copyWith({
    String? id,
    String? name,
    Value<String?> destination = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? currency,
    int? currencyExponent,
    String? ownerUserId,
    String? createdByUserId,
    String? myRole,
    Value<String?> memberId = const Value.absent(),
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    Value<String?> archivedAt = const Value.absent(),
    int? serverSyncVersion,
    String? cachedAt,
    String? updatedAt,
  }) => LocalTrip(
    id: id ?? this.id,
    name: name ?? this.name,
    destination: destination.present ? destination.value : this.destination,
    description: description.present ? description.value : this.description,
    currency: currency ?? this.currency,
    currencyExponent: currencyExponent ?? this.currencyExponent,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    createdByUserId: createdByUserId ?? this.createdByUserId,
    myRole: myRole ?? this.myRole,
    memberId: memberId.present ? memberId.value : this.memberId,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    serverSyncVersion: serverSyncVersion ?? this.serverSyncVersion,
    cachedAt: cachedAt ?? this.cachedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalTrip copyWithCompanion(LocalTripsCompanion data) {
    return LocalTrip(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      description: data.description.present
          ? data.description.value
          : this.description,
      currency: data.currency.present ? data.currency.value : this.currency,
      currencyExponent: data.currencyExponent.present
          ? data.currencyExponent.value
          : this.currencyExponent,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      myRole: data.myRole.present ? data.myRole.value : this.myRole,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      serverSyncVersion: data.serverSyncVersion.present
          ? data.serverSyncVersion.value
          : this.serverSyncVersion,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTrip(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('destination: $destination, ')
          ..write('description: $description, ')
          ..write('currency: $currency, ')
          ..write('currencyExponent: $currencyExponent, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('myRole: $myRole, ')
          ..write('memberId: $memberId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('serverSyncVersion: $serverSyncVersion, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    destination,
    description,
    currency,
    currencyExponent,
    ownerUserId,
    createdByUserId,
    myRole,
    memberId,
    startDate,
    endDate,
    archivedAt,
    serverSyncVersion,
    cachedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTrip &&
          other.id == this.id &&
          other.name == this.name &&
          other.destination == this.destination &&
          other.description == this.description &&
          other.currency == this.currency &&
          other.currencyExponent == this.currencyExponent &&
          other.ownerUserId == this.ownerUserId &&
          other.createdByUserId == this.createdByUserId &&
          other.myRole == this.myRole &&
          other.memberId == this.memberId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.archivedAt == this.archivedAt &&
          other.serverSyncVersion == this.serverSyncVersion &&
          other.cachedAt == this.cachedAt &&
          other.updatedAt == this.updatedAt);
}

class LocalTripsCompanion extends UpdateCompanion<LocalTrip> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> destination;
  final Value<String?> description;
  final Value<String> currency;
  final Value<int> currencyExponent;
  final Value<String> ownerUserId;
  final Value<String> createdByUserId;
  final Value<String> myRole;
  final Value<String?> memberId;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<String?> archivedAt;
  final Value<int> serverSyncVersion;
  final Value<String> cachedAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const LocalTripsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.destination = const Value.absent(),
    this.description = const Value.absent(),
    this.currency = const Value.absent(),
    this.currencyExponent = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.myRole = const Value.absent(),
    this.memberId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.serverSyncVersion = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTripsCompanion.insert({
    required String id,
    required String name,
    this.destination = const Value.absent(),
    this.description = const Value.absent(),
    required String currency,
    this.currencyExponent = const Value.absent(),
    required String ownerUserId,
    required String createdByUserId,
    this.myRole = const Value.absent(),
    this.memberId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.serverSyncVersion = const Value.absent(),
    required String cachedAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       currency = Value(currency),
       ownerUserId = Value(ownerUserId),
       createdByUserId = Value(createdByUserId),
       cachedAt = Value(cachedAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalTrip> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? destination,
    Expression<String>? description,
    Expression<String>? currency,
    Expression<int>? currencyExponent,
    Expression<String>? ownerUserId,
    Expression<String>? createdByUserId,
    Expression<String>? myRole,
    Expression<String>? memberId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? archivedAt,
    Expression<int>? serverSyncVersion,
    Expression<String>? cachedAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (destination != null) 'destination': destination,
      if (description != null) 'description': description,
      if (currency != null) 'currency': currency,
      if (currencyExponent != null) 'currency_exponent': currencyExponent,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (myRole != null) 'my_role': myRole,
      if (memberId != null) 'member_id': memberId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (serverSyncVersion != null) 'server_sync_version': serverSyncVersion,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTripsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? destination,
    Value<String?>? description,
    Value<String>? currency,
    Value<int>? currencyExponent,
    Value<String>? ownerUserId,
    Value<String>? createdByUserId,
    Value<String>? myRole,
    Value<String?>? memberId,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<String?>? archivedAt,
    Value<int>? serverSyncVersion,
    Value<String>? cachedAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalTripsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      currencyExponent: currencyExponent ?? this.currencyExponent,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      myRole: myRole ?? this.myRole,
      memberId: memberId ?? this.memberId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      archivedAt: archivedAt ?? this.archivedAt,
      serverSyncVersion: serverSyncVersion ?? this.serverSyncVersion,
      cachedAt: cachedAt ?? this.cachedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (currencyExponent.present) {
      map['currency_exponent'] = Variable<int>(currencyExponent.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (myRole.present) {
      map['my_role'] = Variable<String>(myRole.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<String>(archivedAt.value);
    }
    if (serverSyncVersion.present) {
      map['server_sync_version'] = Variable<int>(serverSyncVersion.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<String>(cachedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTripsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('destination: $destination, ')
          ..write('description: $description, ')
          ..write('currency: $currency, ')
          ..write('currencyExponent: $currencyExponent, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('myRole: $myRole, ')
          ..write('memberId: $memberId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('serverSyncVersion: $serverSyncVersion, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMembersTable extends LocalMembers
    with TableInfo<$LocalMembersTable, LocalMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailNormalizedMeta = const VerificationMeta(
    'emailNormalized',
  );
  @override
  late final GeneratedColumn<String> emailNormalized = GeneratedColumn<String>(
    'email_normalized',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memberKindMeta = const VerificationMeta(
    'memberKind',
  );
  @override
  late final GeneratedColumn<String> memberKind = GeneratedColumn<String>(
    'member_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<String> joinedAt = GeneratedColumn<String>(
    'joined_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    userId,
    displayName,
    emailNormalized,
    memberKind,
    role,
    status,
    joinedAt,
    serverVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('email_normalized')) {
      context.handle(
        _emailNormalizedMeta,
        emailNormalized.isAcceptableOrUnknown(
          data['email_normalized']!,
          _emailNormalizedMeta,
        ),
      );
    }
    if (data.containsKey('member_kind')) {
      context.handle(
        _memberKindMeta,
        memberKind.isAcceptableOrUnknown(data['member_kind']!, _memberKindMeta),
      );
    } else if (isInserting) {
      context.missing(_memberKindMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      emailNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_normalized'],
      ),
      memberKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_kind'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}joined_at'],
      ),
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalMembersTable createAlias(String alias) {
    return $LocalMembersTable(attachedDatabase, alias);
  }
}

class LocalMember extends DataClass implements Insertable<LocalMember> {
  final String id;
  final String tripId;
  final String? userId;
  final String displayName;
  final String? emailNormalized;
  final String memberKind;
  final String role;
  final String status;
  final String? joinedAt;
  final int serverVersion;
  final String updatedAt;
  const LocalMember({
    required this.id,
    required this.tripId,
    this.userId,
    required this.displayName,
    this.emailNormalized,
    required this.memberKind,
    required this.role,
    required this.status,
    this.joinedAt,
    required this.serverVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || emailNormalized != null) {
      map['email_normalized'] = Variable<String>(emailNormalized);
    }
    map['member_kind'] = Variable<String>(memberKind);
    map['role'] = Variable<String>(role);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || joinedAt != null) {
      map['joined_at'] = Variable<String>(joinedAt);
    }
    map['server_version'] = Variable<int>(serverVersion);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  LocalMembersCompanion toCompanion(bool nullToAbsent) {
    return LocalMembersCompanion(
      id: Value(id),
      tripId: Value(tripId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      displayName: Value(displayName),
      emailNormalized: emailNormalized == null && nullToAbsent
          ? const Value.absent()
          : Value(emailNormalized),
      memberKind: Value(memberKind),
      role: Value(role),
      status: Value(status),
      joinedAt: joinedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedAt),
      serverVersion: Value(serverVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMember(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      userId: serializer.fromJson<String?>(json['userId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      emailNormalized: serializer.fromJson<String?>(json['emailNormalized']),
      memberKind: serializer.fromJson<String>(json['memberKind']),
      role: serializer.fromJson<String>(json['role']),
      status: serializer.fromJson<String>(json['status']),
      joinedAt: serializer.fromJson<String?>(json['joinedAt']),
      serverVersion: serializer.fromJson<int>(json['serverVersion']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'userId': serializer.toJson<String?>(userId),
      'displayName': serializer.toJson<String>(displayName),
      'emailNormalized': serializer.toJson<String?>(emailNormalized),
      'memberKind': serializer.toJson<String>(memberKind),
      'role': serializer.toJson<String>(role),
      'status': serializer.toJson<String>(status),
      'joinedAt': serializer.toJson<String?>(joinedAt),
      'serverVersion': serializer.toJson<int>(serverVersion),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  LocalMember copyWith({
    String? id,
    String? tripId,
    Value<String?> userId = const Value.absent(),
    String? displayName,
    Value<String?> emailNormalized = const Value.absent(),
    String? memberKind,
    String? role,
    String? status,
    Value<String?> joinedAt = const Value.absent(),
    int? serverVersion,
    String? updatedAt,
  }) => LocalMember(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    userId: userId.present ? userId.value : this.userId,
    displayName: displayName ?? this.displayName,
    emailNormalized: emailNormalized.present
        ? emailNormalized.value
        : this.emailNormalized,
    memberKind: memberKind ?? this.memberKind,
    role: role ?? this.role,
    status: status ?? this.status,
    joinedAt: joinedAt.present ? joinedAt.value : this.joinedAt,
    serverVersion: serverVersion ?? this.serverVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalMember copyWithCompanion(LocalMembersCompanion data) {
    return LocalMember(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      emailNormalized: data.emailNormalized.present
          ? data.emailNormalized.value
          : this.emailNormalized,
      memberKind: data.memberKind.present
          ? data.memberKind.value
          : this.memberKind,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMember(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('emailNormalized: $emailNormalized, ')
          ..write('memberKind: $memberKind, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    userId,
    displayName,
    emailNormalized,
    memberKind,
    role,
    status,
    joinedAt,
    serverVersion,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMember &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.emailNormalized == this.emailNormalized &&
          other.memberKind == this.memberKind &&
          other.role == this.role &&
          other.status == this.status &&
          other.joinedAt == this.joinedAt &&
          other.serverVersion == this.serverVersion &&
          other.updatedAt == this.updatedAt);
}

class LocalMembersCompanion extends UpdateCompanion<LocalMember> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> userId;
  final Value<String> displayName;
  final Value<String?> emailNormalized;
  final Value<String> memberKind;
  final Value<String> role;
  final Value<String> status;
  final Value<String?> joinedAt;
  final Value<int> serverVersion;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const LocalMembersCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.emailNormalized = const Value.absent(),
    this.memberKind = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMembersCompanion.insert({
    required String id,
    required String tripId,
    this.userId = const Value.absent(),
    required String displayName,
    this.emailNormalized = const Value.absent(),
    required String memberKind,
    required String role,
    required String status,
    this.joinedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       displayName = Value(displayName),
       memberKind = Value(memberKind),
       role = Value(role),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<LocalMember> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<String>? emailNormalized,
    Expression<String>? memberKind,
    Expression<String>? role,
    Expression<String>? status,
    Expression<String>? joinedAt,
    Expression<int>? serverVersion,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (emailNormalized != null) 'email_normalized': emailNormalized,
      if (memberKind != null) 'member_kind': memberKind,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? userId,
    Value<String>? displayName,
    Value<String?>? emailNormalized,
    Value<String>? memberKind,
    Value<String>? role,
    Value<String>? status,
    Value<String?>? joinedAt,
    Value<int>? serverVersion,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalMembersCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      emailNormalized: emailNormalized ?? this.emailNormalized,
      memberKind: memberKind ?? this.memberKind,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (emailNormalized.present) {
      map['email_normalized'] = Variable<String>(emailNormalized.value);
    }
    if (memberKind.present) {
      map['member_kind'] = Variable<String>(memberKind.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<String>(joinedAt.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMembersCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('emailNormalized: $emailNormalized, ')
          ..write('memberKind: $memberKind, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalInvitationsTable extends LocalInvitations
    with TableInfo<$LocalInvitationsTable, LocalInvitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalInvitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripNameMeta = const VerificationMeta(
    'tripName',
  );
  @override
  late final GeneratedColumn<String> tripName = GeneratedColumn<String>(
    'trip_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailNormalizedMeta = const VerificationMeta(
    'emailNormalized',
  );
  @override
  late final GeneratedColumn<String> emailNormalized = GeneratedColumn<String>(
    'email_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<String> expiresAt = GeneratedColumn<String>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    tripName,
    emailNormalized,
    role,
    status,
    expiresAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_invitations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalInvitation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('trip_name')) {
      context.handle(
        _tripNameMeta,
        tripName.isAcceptableOrUnknown(data['trip_name']!, _tripNameMeta),
      );
    }
    if (data.containsKey('email_normalized')) {
      context.handle(
        _emailNormalizedMeta,
        emailNormalized.isAcceptableOrUnknown(
          data['email_normalized']!,
          _emailNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emailNormalizedMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalInvitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalInvitation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      tripName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_name'],
      ),
      emailNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_normalized'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expires_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalInvitationsTable createAlias(String alias) {
    return $LocalInvitationsTable(attachedDatabase, alias);
  }
}

class LocalInvitation extends DataClass implements Insertable<LocalInvitation> {
  final String id;
  final String tripId;
  final String? tripName;
  final String emailNormalized;
  final String role;
  final String status;
  final String expiresAt;
  final String createdAt;
  final String updatedAt;
  const LocalInvitation({
    required this.id,
    required this.tripId,
    this.tripName,
    required this.emailNormalized,
    required this.role,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || tripName != null) {
      map['trip_name'] = Variable<String>(tripName);
    }
    map['email_normalized'] = Variable<String>(emailNormalized);
    map['role'] = Variable<String>(role);
    map['status'] = Variable<String>(status);
    map['expires_at'] = Variable<String>(expiresAt);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  LocalInvitationsCompanion toCompanion(bool nullToAbsent) {
    return LocalInvitationsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      tripName: tripName == null && nullToAbsent
          ? const Value.absent()
          : Value(tripName),
      emailNormalized: Value(emailNormalized),
      role: Value(role),
      status: Value(status),
      expiresAt: Value(expiresAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalInvitation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalInvitation(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      tripName: serializer.fromJson<String?>(json['tripName']),
      emailNormalized: serializer.fromJson<String>(json['emailNormalized']),
      role: serializer.fromJson<String>(json['role']),
      status: serializer.fromJson<String>(json['status']),
      expiresAt: serializer.fromJson<String>(json['expiresAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'tripName': serializer.toJson<String?>(tripName),
      'emailNormalized': serializer.toJson<String>(emailNormalized),
      'role': serializer.toJson<String>(role),
      'status': serializer.toJson<String>(status),
      'expiresAt': serializer.toJson<String>(expiresAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  LocalInvitation copyWith({
    String? id,
    String? tripId,
    Value<String?> tripName = const Value.absent(),
    String? emailNormalized,
    String? role,
    String? status,
    String? expiresAt,
    String? createdAt,
    String? updatedAt,
  }) => LocalInvitation(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    tripName: tripName.present ? tripName.value : this.tripName,
    emailNormalized: emailNormalized ?? this.emailNormalized,
    role: role ?? this.role,
    status: status ?? this.status,
    expiresAt: expiresAt ?? this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalInvitation copyWithCompanion(LocalInvitationsCompanion data) {
    return LocalInvitation(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      tripName: data.tripName.present ? data.tripName.value : this.tripName,
      emailNormalized: data.emailNormalized.present
          ? data.emailNormalized.value
          : this.emailNormalized,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalInvitation(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('tripName: $tripName, ')
          ..write('emailNormalized: $emailNormalized, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    tripName,
    emailNormalized,
    role,
    status,
    expiresAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalInvitation &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.tripName == this.tripName &&
          other.emailNormalized == this.emailNormalized &&
          other.role == this.role &&
          other.status == this.status &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalInvitationsCompanion extends UpdateCompanion<LocalInvitation> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> tripName;
  final Value<String> emailNormalized;
  final Value<String> role;
  final Value<String> status;
  final Value<String> expiresAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const LocalInvitationsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.tripName = const Value.absent(),
    this.emailNormalized = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalInvitationsCompanion.insert({
    required String id,
    required String tripId,
    this.tripName = const Value.absent(),
    required String emailNormalized,
    required String role,
    required String status,
    required String expiresAt,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       emailNormalized = Value(emailNormalized),
       role = Value(role),
       status = Value(status),
       expiresAt = Value(expiresAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalInvitation> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? tripName,
    Expression<String>? emailNormalized,
    Expression<String>? role,
    Expression<String>? status,
    Expression<String>? expiresAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (tripName != null) 'trip_name': tripName,
      if (emailNormalized != null) 'email_normalized': emailNormalized,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalInvitationsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? tripName,
    Value<String>? emailNormalized,
    Value<String>? role,
    Value<String>? status,
    Value<String>? expiresAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalInvitationsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      tripName: tripName ?? this.tripName,
      emailNormalized: emailNormalized ?? this.emailNormalized,
      role: role ?? this.role,
      status: status ?? this.status,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (tripName.present) {
      map['trip_name'] = Variable<String>(tripName.value);
    }
    if (emailNormalized.present) {
      map['email_normalized'] = Variable<String>(emailNormalized.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<String>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalInvitationsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('tripName: $tripName, ')
          ..write('emailNormalized: $emailNormalized, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExpensesTable extends LocalExpenses
    with TableInfo<$LocalExpensesTable, LocalExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidByMemberIdMeta = const VerificationMeta(
    'paidByMemberId',
  );
  @override
  late final GeneratedColumn<String> paidByMemberId = GeneratedColumn<String>(
    'paid_by_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByUserIdMeta = const VerificationMeta(
    'updatedByUserId',
  );
  @override
  late final GeneratedColumn<String> updatedByUserId = GeneratedColumn<String>(
    'updated_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedByUserIdMeta = const VerificationMeta(
    'deletedByUserId',
  );
  @override
  late final GeneratedColumn<String> deletedByUserId = GeneratedColumn<String>(
    'deleted_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitTypeMeta = const VerificationMeta(
    'splitType',
  );
  @override
  late final GeneratedColumn<String> splitType = GeneratedColumn<String>(
    'split_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _expenseDateMeta = const VerificationMeta(
    'expenseDate',
  );
  @override
  late final GeneratedColumn<String> expenseDate = GeneratedColumn<String>(
    'expense_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasPendingLocalChangeMeta =
      const VerificationMeta('hasPendingLocalChange');
  @override
  late final GeneratedColumn<bool> hasPendingLocalChange =
      GeneratedColumn<bool>(
        'has_pending_local_change',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_pending_local_change" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _serverPayloadMeta = const VerificationMeta(
    'serverPayload',
  );
  @override
  late final GeneratedColumn<String> serverPayload = GeneratedColumn<String>(
    'server_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPatchMeta = const VerificationMeta(
    'localPatch',
  );
  @override
  late final GeneratedColumn<String> localPatch = GeneratedColumn<String>(
    'local_patch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientCreatedAtMeta = const VerificationMeta(
    'clientCreatedAt',
  );
  @override
  late final GeneratedColumn<String> clientCreatedAt = GeneratedColumn<String>(
    'client_created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    paidByMemberId,
    createdByUserId,
    updatedByUserId,
    deletedByUserId,
    title,
    amountMinor,
    currency,
    splitType,
    category,
    description,
    expenseDate,
    status,
    version,
    serverVersion,
    baseVersion,
    hasPendingLocalChange,
    syncStatus,
    serverPayload,
    localPatch,
    clientCreatedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('paid_by_member_id')) {
      context.handle(
        _paidByMemberIdMeta,
        paidByMemberId.isAcceptableOrUnknown(
          data['paid_by_member_id']!,
          _paidByMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paidByMemberIdMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByUserIdMeta);
    }
    if (data.containsKey('updated_by_user_id')) {
      context.handle(
        _updatedByUserIdMeta,
        updatedByUserId.isAcceptableOrUnknown(
          data['updated_by_user_id']!,
          _updatedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('deleted_by_user_id')) {
      context.handle(
        _deletedByUserIdMeta,
        deletedByUserId.isAcceptableOrUnknown(
          data['deleted_by_user_id']!,
          _deletedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('split_type')) {
      context.handle(
        _splitTypeMeta,
        splitType.isAcceptableOrUnknown(data['split_type']!, _splitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_splitTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('expense_date')) {
      context.handle(
        _expenseDateMeta,
        expenseDate.isAcceptableOrUnknown(
          data['expense_date']!,
          _expenseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('has_pending_local_change')) {
      context.handle(
        _hasPendingLocalChangeMeta,
        hasPendingLocalChange.isAcceptableOrUnknown(
          data['has_pending_local_change']!,
          _hasPendingLocalChangeMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('server_payload')) {
      context.handle(
        _serverPayloadMeta,
        serverPayload.isAcceptableOrUnknown(
          data['server_payload']!,
          _serverPayloadMeta,
        ),
      );
    }
    if (data.containsKey('local_patch')) {
      context.handle(
        _localPatchMeta,
        localPatch.isAcceptableOrUnknown(data['local_patch']!, _localPatchMeta),
      );
    }
    if (data.containsKey('client_created_at')) {
      context.handle(
        _clientCreatedAtMeta,
        clientCreatedAt.isAcceptableOrUnknown(
          data['client_created_at']!,
          _clientCreatedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      paidByMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_by_member_id'],
      )!,
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      )!,
      updatedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_user_id'],
      ),
      deletedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_by_user_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      splitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      expenseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      ),
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      ),
      hasPendingLocalChange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_pending_local_change'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      serverPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_payload'],
      ),
      localPatch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_patch'],
      ),
      clientCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_created_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalExpensesTable createAlias(String alias) {
    return $LocalExpensesTable(attachedDatabase, alias);
  }
}

class LocalExpense extends DataClass implements Insertable<LocalExpense> {
  final String id;
  final String tripId;
  final String paidByMemberId;
  final String createdByUserId;
  final String? updatedByUserId;
  final String? deletedByUserId;
  final String title;
  final int amountMinor;
  final String currency;
  final String splitType;
  final String category;
  final String description;
  final String expenseDate;
  final String status;
  final int version;
  final int? serverVersion;
  final int? baseVersion;
  final bool hasPendingLocalChange;
  final String syncStatus;
  final String? serverPayload;
  final String? localPatch;
  final String? clientCreatedAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  const LocalExpense({
    required this.id,
    required this.tripId,
    required this.paidByMemberId,
    required this.createdByUserId,
    this.updatedByUserId,
    this.deletedByUserId,
    required this.title,
    required this.amountMinor,
    required this.currency,
    required this.splitType,
    required this.category,
    required this.description,
    required this.expenseDate,
    required this.status,
    required this.version,
    this.serverVersion,
    this.baseVersion,
    required this.hasPendingLocalChange,
    required this.syncStatus,
    this.serverPayload,
    this.localPatch,
    this.clientCreatedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['paid_by_member_id'] = Variable<String>(paidByMemberId);
    map['created_by_user_id'] = Variable<String>(createdByUserId);
    if (!nullToAbsent || updatedByUserId != null) {
      map['updated_by_user_id'] = Variable<String>(updatedByUserId);
    }
    if (!nullToAbsent || deletedByUserId != null) {
      map['deleted_by_user_id'] = Variable<String>(deletedByUserId);
    }
    map['title'] = Variable<String>(title);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['split_type'] = Variable<String>(splitType);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    map['expense_date'] = Variable<String>(expenseDate);
    map['status'] = Variable<String>(status);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    if (!nullToAbsent || baseVersion != null) {
      map['base_version'] = Variable<int>(baseVersion);
    }
    map['has_pending_local_change'] = Variable<bool>(hasPendingLocalChange);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverPayload != null) {
      map['server_payload'] = Variable<String>(serverPayload);
    }
    if (!nullToAbsent || localPatch != null) {
      map['local_patch'] = Variable<String>(localPatch);
    }
    if (!nullToAbsent || clientCreatedAt != null) {
      map['client_created_at'] = Variable<String>(clientCreatedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    return map;
  }

  LocalExpensesCompanion toCompanion(bool nullToAbsent) {
    return LocalExpensesCompanion(
      id: Value(id),
      tripId: Value(tripId),
      paidByMemberId: Value(paidByMemberId),
      createdByUserId: Value(createdByUserId),
      updatedByUserId: updatedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByUserId),
      deletedByUserId: deletedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedByUserId),
      title: Value(title),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      splitType: Value(splitType),
      category: Value(category),
      description: Value(description),
      expenseDate: Value(expenseDate),
      status: Value(status),
      version: Value(version),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      baseVersion: baseVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(baseVersion),
      hasPendingLocalChange: Value(hasPendingLocalChange),
      syncStatus: Value(syncStatus),
      serverPayload: serverPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(serverPayload),
      localPatch: localPatch == null && nullToAbsent
          ? const Value.absent()
          : Value(localPatch),
      clientCreatedAt: clientCreatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clientCreatedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExpense(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      paidByMemberId: serializer.fromJson<String>(json['paidByMemberId']),
      createdByUserId: serializer.fromJson<String>(json['createdByUserId']),
      updatedByUserId: serializer.fromJson<String?>(json['updatedByUserId']),
      deletedByUserId: serializer.fromJson<String?>(json['deletedByUserId']),
      title: serializer.fromJson<String>(json['title']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      splitType: serializer.fromJson<String>(json['splitType']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      expenseDate: serializer.fromJson<String>(json['expenseDate']),
      status: serializer.fromJson<String>(json['status']),
      version: serializer.fromJson<int>(json['version']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      baseVersion: serializer.fromJson<int?>(json['baseVersion']),
      hasPendingLocalChange: serializer.fromJson<bool>(
        json['hasPendingLocalChange'],
      ),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverPayload: serializer.fromJson<String?>(json['serverPayload']),
      localPatch: serializer.fromJson<String?>(json['localPatch']),
      clientCreatedAt: serializer.fromJson<String?>(json['clientCreatedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'paidByMemberId': serializer.toJson<String>(paidByMemberId),
      'createdByUserId': serializer.toJson<String>(createdByUserId),
      'updatedByUserId': serializer.toJson<String?>(updatedByUserId),
      'deletedByUserId': serializer.toJson<String?>(deletedByUserId),
      'title': serializer.toJson<String>(title),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'splitType': serializer.toJson<String>(splitType),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'expenseDate': serializer.toJson<String>(expenseDate),
      'status': serializer.toJson<String>(status),
      'version': serializer.toJson<int>(version),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'baseVersion': serializer.toJson<int?>(baseVersion),
      'hasPendingLocalChange': serializer.toJson<bool>(hasPendingLocalChange),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverPayload': serializer.toJson<String?>(serverPayload),
      'localPatch': serializer.toJson<String?>(localPatch),
      'clientCreatedAt': serializer.toJson<String?>(clientCreatedAt),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
    };
  }

  LocalExpense copyWith({
    String? id,
    String? tripId,
    String? paidByMemberId,
    String? createdByUserId,
    Value<String?> updatedByUserId = const Value.absent(),
    Value<String?> deletedByUserId = const Value.absent(),
    String? title,
    int? amountMinor,
    String? currency,
    String? splitType,
    String? category,
    String? description,
    String? expenseDate,
    String? status,
    int? version,
    Value<int?> serverVersion = const Value.absent(),
    Value<int?> baseVersion = const Value.absent(),
    bool? hasPendingLocalChange,
    String? syncStatus,
    Value<String?> serverPayload = const Value.absent(),
    Value<String?> localPatch = const Value.absent(),
    Value<String?> clientCreatedAt = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    Value<String?> deletedAt = const Value.absent(),
  }) => LocalExpense(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    paidByMemberId: paidByMemberId ?? this.paidByMemberId,
    createdByUserId: createdByUserId ?? this.createdByUserId,
    updatedByUserId: updatedByUserId.present
        ? updatedByUserId.value
        : this.updatedByUserId,
    deletedByUserId: deletedByUserId.present
        ? deletedByUserId.value
        : this.deletedByUserId,
    title: title ?? this.title,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    splitType: splitType ?? this.splitType,
    category: category ?? this.category,
    description: description ?? this.description,
    expenseDate: expenseDate ?? this.expenseDate,
    status: status ?? this.status,
    version: version ?? this.version,
    serverVersion: serverVersion.present
        ? serverVersion.value
        : this.serverVersion,
    baseVersion: baseVersion.present ? baseVersion.value : this.baseVersion,
    hasPendingLocalChange: hasPendingLocalChange ?? this.hasPendingLocalChange,
    syncStatus: syncStatus ?? this.syncStatus,
    serverPayload: serverPayload.present
        ? serverPayload.value
        : this.serverPayload,
    localPatch: localPatch.present ? localPatch.value : this.localPatch,
    clientCreatedAt: clientCreatedAt.present
        ? clientCreatedAt.value
        : this.clientCreatedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalExpense copyWithCompanion(LocalExpensesCompanion data) {
    return LocalExpense(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      paidByMemberId: data.paidByMemberId.present
          ? data.paidByMemberId.value
          : this.paidByMemberId,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      updatedByUserId: data.updatedByUserId.present
          ? data.updatedByUserId.value
          : this.updatedByUserId,
      deletedByUserId: data.deletedByUserId.present
          ? data.deletedByUserId.value
          : this.deletedByUserId,
      title: data.title.present ? data.title.value : this.title,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      expenseDate: data.expenseDate.present
          ? data.expenseDate.value
          : this.expenseDate,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      hasPendingLocalChange: data.hasPendingLocalChange.present
          ? data.hasPendingLocalChange.value
          : this.hasPendingLocalChange,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      serverPayload: data.serverPayload.present
          ? data.serverPayload.value
          : this.serverPayload,
      localPatch: data.localPatch.present
          ? data.localPatch.value
          : this.localPatch,
      clientCreatedAt: data.clientCreatedAt.present
          ? data.clientCreatedAt.value
          : this.clientCreatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpense(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('updatedByUserId: $updatedByUserId, ')
          ..write('deletedByUserId: $deletedByUserId, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('splitType: $splitType, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('hasPendingLocalChange: $hasPendingLocalChange, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('localPatch: $localPatch, ')
          ..write('clientCreatedAt: $clientCreatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    tripId,
    paidByMemberId,
    createdByUserId,
    updatedByUserId,
    deletedByUserId,
    title,
    amountMinor,
    currency,
    splitType,
    category,
    description,
    expenseDate,
    status,
    version,
    serverVersion,
    baseVersion,
    hasPendingLocalChange,
    syncStatus,
    serverPayload,
    localPatch,
    clientCreatedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExpense &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.paidByMemberId == this.paidByMemberId &&
          other.createdByUserId == this.createdByUserId &&
          other.updatedByUserId == this.updatedByUserId &&
          other.deletedByUserId == this.deletedByUserId &&
          other.title == this.title &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.splitType == this.splitType &&
          other.category == this.category &&
          other.description == this.description &&
          other.expenseDate == this.expenseDate &&
          other.status == this.status &&
          other.version == this.version &&
          other.serverVersion == this.serverVersion &&
          other.baseVersion == this.baseVersion &&
          other.hasPendingLocalChange == this.hasPendingLocalChange &&
          other.syncStatus == this.syncStatus &&
          other.serverPayload == this.serverPayload &&
          other.localPatch == this.localPatch &&
          other.clientCreatedAt == this.clientCreatedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalExpensesCompanion extends UpdateCompanion<LocalExpense> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> paidByMemberId;
  final Value<String> createdByUserId;
  final Value<String?> updatedByUserId;
  final Value<String?> deletedByUserId;
  final Value<String> title;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> splitType;
  final Value<String> category;
  final Value<String> description;
  final Value<String> expenseDate;
  final Value<String> status;
  final Value<int> version;
  final Value<int?> serverVersion;
  final Value<int?> baseVersion;
  final Value<bool> hasPendingLocalChange;
  final Value<String> syncStatus;
  final Value<String?> serverPayload;
  final Value<String?> localPatch;
  final Value<String?> clientCreatedAt;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<int> rowid;
  const LocalExpensesCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.paidByMemberId = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.updatedByUserId = const Value.absent(),
    this.deletedByUserId = const Value.absent(),
    this.title = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.splitType = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.hasPendingLocalChange = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverPayload = const Value.absent(),
    this.localPatch = const Value.absent(),
    this.clientCreatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExpensesCompanion.insert({
    required String id,
    required String tripId,
    required String paidByMemberId,
    required String createdByUserId,
    this.updatedByUserId = const Value.absent(),
    this.deletedByUserId = const Value.absent(),
    required String title,
    required int amountMinor,
    required String currency,
    required String splitType,
    required String category,
    this.description = const Value.absent(),
    required String expenseDate,
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.hasPendingLocalChange = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverPayload = const Value.absent(),
    this.localPatch = const Value.absent(),
    this.clientCreatedAt = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       paidByMemberId = Value(paidByMemberId),
       createdByUserId = Value(createdByUserId),
       title = Value(title),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       splitType = Value(splitType),
       category = Value(category),
       expenseDate = Value(expenseDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalExpense> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? paidByMemberId,
    Expression<String>? createdByUserId,
    Expression<String>? updatedByUserId,
    Expression<String>? deletedByUserId,
    Expression<String>? title,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? splitType,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? expenseDate,
    Expression<String>? status,
    Expression<int>? version,
    Expression<int>? serverVersion,
    Expression<int>? baseVersion,
    Expression<bool>? hasPendingLocalChange,
    Expression<String>? syncStatus,
    Expression<String>? serverPayload,
    Expression<String>? localPatch,
    Expression<String>? clientCreatedAt,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (paidByMemberId != null) 'paid_by_member_id': paidByMemberId,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (updatedByUserId != null) 'updated_by_user_id': updatedByUserId,
      if (deletedByUserId != null) 'deleted_by_user_id': deletedByUserId,
      if (title != null) 'title': title,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (splitType != null) 'split_type': splitType,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (serverVersion != null) 'server_version': serverVersion,
      if (baseVersion != null) 'base_version': baseVersion,
      if (hasPendingLocalChange != null)
        'has_pending_local_change': hasPendingLocalChange,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverPayload != null) 'server_payload': serverPayload,
      if (localPatch != null) 'local_patch': localPatch,
      if (clientCreatedAt != null) 'client_created_at': clientCreatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? paidByMemberId,
    Value<String>? createdByUserId,
    Value<String?>? updatedByUserId,
    Value<String?>? deletedByUserId,
    Value<String>? title,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String>? splitType,
    Value<String>? category,
    Value<String>? description,
    Value<String>? expenseDate,
    Value<String>? status,
    Value<int>? version,
    Value<int?>? serverVersion,
    Value<int?>? baseVersion,
    Value<bool>? hasPendingLocalChange,
    Value<String>? syncStatus,
    Value<String?>? serverPayload,
    Value<String?>? localPatch,
    Value<String?>? clientCreatedAt,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalExpensesCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      updatedByUserId: updatedByUserId ?? this.updatedByUserId,
      deletedByUserId: deletedByUserId ?? this.deletedByUserId,
      title: title ?? this.title,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      splitType: splitType ?? this.splitType,
      category: category ?? this.category,
      description: description ?? this.description,
      expenseDate: expenseDate ?? this.expenseDate,
      status: status ?? this.status,
      version: version ?? this.version,
      serverVersion: serverVersion ?? this.serverVersion,
      baseVersion: baseVersion ?? this.baseVersion,
      hasPendingLocalChange:
          hasPendingLocalChange ?? this.hasPendingLocalChange,
      syncStatus: syncStatus ?? this.syncStatus,
      serverPayload: serverPayload ?? this.serverPayload,
      localPatch: localPatch ?? this.localPatch,
      clientCreatedAt: clientCreatedAt ?? this.clientCreatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (paidByMemberId.present) {
      map['paid_by_member_id'] = Variable<String>(paidByMemberId.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (updatedByUserId.present) {
      map['updated_by_user_id'] = Variable<String>(updatedByUserId.value);
    }
    if (deletedByUserId.present) {
      map['deleted_by_user_id'] = Variable<String>(deletedByUserId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(splitType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<String>(expenseDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (hasPendingLocalChange.present) {
      map['has_pending_local_change'] = Variable<bool>(
        hasPendingLocalChange.value,
      );
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverPayload.present) {
      map['server_payload'] = Variable<String>(serverPayload.value);
    }
    if (localPatch.present) {
      map['local_patch'] = Variable<String>(localPatch.value);
    }
    if (clientCreatedAt.present) {
      map['client_created_at'] = Variable<String>(clientCreatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpensesCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('updatedByUserId: $updatedByUserId, ')
          ..write('deletedByUserId: $deletedByUserId, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('splitType: $splitType, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('hasPendingLocalChange: $hasPendingLocalChange, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('localPatch: $localPatch, ')
          ..write('clientCreatedAt: $clientCreatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExpenseSplitsTable extends LocalExpenseSplits
    with TableInfo<$LocalExpenseSplitsTable, LocalExpenseSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExpenseSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [expenseId, memberId, amountMinor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_expense_splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExpenseSplit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {expenseId, memberId};
  @override
  LocalExpenseSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExpenseSplit(
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
    );
  }

  @override
  $LocalExpenseSplitsTable createAlias(String alias) {
    return $LocalExpenseSplitsTable(attachedDatabase, alias);
  }
}

class LocalExpenseSplit extends DataClass
    implements Insertable<LocalExpenseSplit> {
  final String expenseId;
  final String memberId;
  final int amountMinor;
  const LocalExpenseSplit({
    required this.expenseId,
    required this.memberId,
    required this.amountMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['expense_id'] = Variable<String>(expenseId);
    map['member_id'] = Variable<String>(memberId);
    map['amount_minor'] = Variable<int>(amountMinor);
    return map;
  }

  LocalExpenseSplitsCompanion toCompanion(bool nullToAbsent) {
    return LocalExpenseSplitsCompanion(
      expenseId: Value(expenseId),
      memberId: Value(memberId),
      amountMinor: Value(amountMinor),
    );
  }

  factory LocalExpenseSplit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExpenseSplit(
      expenseId: serializer.fromJson<String>(json['expenseId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'expenseId': serializer.toJson<String>(expenseId),
      'memberId': serializer.toJson<String>(memberId),
      'amountMinor': serializer.toJson<int>(amountMinor),
    };
  }

  LocalExpenseSplit copyWith({
    String? expenseId,
    String? memberId,
    int? amountMinor,
  }) => LocalExpenseSplit(
    expenseId: expenseId ?? this.expenseId,
    memberId: memberId ?? this.memberId,
    amountMinor: amountMinor ?? this.amountMinor,
  );
  LocalExpenseSplit copyWithCompanion(LocalExpenseSplitsCompanion data) {
    return LocalExpenseSplit(
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpenseSplit(')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('amountMinor: $amountMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(expenseId, memberId, amountMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExpenseSplit &&
          other.expenseId == this.expenseId &&
          other.memberId == this.memberId &&
          other.amountMinor == this.amountMinor);
}

class LocalExpenseSplitsCompanion extends UpdateCompanion<LocalExpenseSplit> {
  final Value<String> expenseId;
  final Value<String> memberId;
  final Value<int> amountMinor;
  final Value<int> rowid;
  const LocalExpenseSplitsCompanion({
    this.expenseId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExpenseSplitsCompanion.insert({
    required String expenseId,
    required String memberId,
    required int amountMinor,
    this.rowid = const Value.absent(),
  }) : expenseId = Value(expenseId),
       memberId = Value(memberId),
       amountMinor = Value(amountMinor);
  static Insertable<LocalExpenseSplit> custom({
    Expression<String>? expenseId,
    Expression<String>? memberId,
    Expression<int>? amountMinor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (expenseId != null) 'expense_id': expenseId,
      if (memberId != null) 'member_id': memberId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExpenseSplitsCompanion copyWith({
    Value<String>? expenseId,
    Value<String>? memberId,
    Value<int>? amountMinor,
    Value<int>? rowid,
  }) {
    return LocalExpenseSplitsCompanion(
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      amountMinor: amountMinor ?? this.amountMinor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpenseSplitsCompanion(')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettlementsTable extends LocalSettlements
    with TableInfo<$LocalSettlementsTable, LocalSettlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidByMemberIdMeta = const VerificationMeta(
    'paidByMemberId',
  );
  @override
  late final GeneratedColumn<String> paidByMemberId = GeneratedColumn<String>(
    'paid_by_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidToMemberIdMeta = const VerificationMeta(
    'paidToMemberId',
  );
  @override
  late final GeneratedColumn<String> paidToMemberId = GeneratedColumn<String>(
    'paid_to_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<String> paymentDate = GeneratedColumn<String>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedByUserIdMeta = const VerificationMeta(
    'recordedByUserId',
  );
  @override
  late final GeneratedColumn<String> recordedByUserId = GeneratedColumn<String>(
    'recorded_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedByUserIdMeta = const VerificationMeta(
    'confirmedByUserId',
  );
  @override
  late final GeneratedColumn<String> confirmedByUserId =
      GeneratedColumn<String>(
        'confirmed_by_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusChangedByUserIdMeta =
      const VerificationMeta('statusChangedByUserId');
  @override
  late final GeneratedColumn<String> statusChangedByUserId =
      GeneratedColumn<String>(
        'status_changed_by_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusChangedAtMeta = const VerificationMeta(
    'statusChangedAt',
  );
  @override
  late final GeneratedColumn<String> statusChangedAt = GeneratedColumn<String>(
    'status_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rejectionReasonMeta = const VerificationMeta(
    'rejectionReason',
  );
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
    'rejection_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasPendingLocalChangeMeta =
      const VerificationMeta('hasPendingLocalChange');
  @override
  late final GeneratedColumn<bool> hasPendingLocalChange =
      GeneratedColumn<bool>(
        'has_pending_local_change',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_pending_local_change" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _serverPayloadMeta = const VerificationMeta(
    'serverPayload',
  );
  @override
  late final GeneratedColumn<String> serverPayload = GeneratedColumn<String>(
    'server_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPatchMeta = const VerificationMeta(
    'localPatch',
  );
  @override
  late final GeneratedColumn<String> localPatch = GeneratedColumn<String>(
    'local_patch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<String> confirmedAt = GeneratedColumn<String>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    paidByMemberId,
    paidToMemberId,
    amountMinor,
    paymentDate,
    status,
    recordedByUserId,
    confirmedByUserId,
    statusChangedByUserId,
    statusChangedAt,
    rejectionReason,
    note,
    version,
    serverVersion,
    baseVersion,
    hasPendingLocalChange,
    syncStatus,
    serverPayload,
    localPatch,
    createdAt,
    updatedAt,
    confirmedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSettlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('paid_by_member_id')) {
      context.handle(
        _paidByMemberIdMeta,
        paidByMemberId.isAcceptableOrUnknown(
          data['paid_by_member_id']!,
          _paidByMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paidByMemberIdMeta);
    }
    if (data.containsKey('paid_to_member_id')) {
      context.handle(
        _paidToMemberIdMeta,
        paidToMemberId.isAcceptableOrUnknown(
          data['paid_to_member_id']!,
          _paidToMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paidToMemberIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('recorded_by_user_id')) {
      context.handle(
        _recordedByUserIdMeta,
        recordedByUserId.isAcceptableOrUnknown(
          data['recorded_by_user_id']!,
          _recordedByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordedByUserIdMeta);
    }
    if (data.containsKey('confirmed_by_user_id')) {
      context.handle(
        _confirmedByUserIdMeta,
        confirmedByUserId.isAcceptableOrUnknown(
          data['confirmed_by_user_id']!,
          _confirmedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('status_changed_by_user_id')) {
      context.handle(
        _statusChangedByUserIdMeta,
        statusChangedByUserId.isAcceptableOrUnknown(
          data['status_changed_by_user_id']!,
          _statusChangedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('status_changed_at')) {
      context.handle(
        _statusChangedAtMeta,
        statusChangedAt.isAcceptableOrUnknown(
          data['status_changed_at']!,
          _statusChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
        _rejectionReasonMeta,
        rejectionReason.isAcceptableOrUnknown(
          data['rejection_reason']!,
          _rejectionReasonMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('has_pending_local_change')) {
      context.handle(
        _hasPendingLocalChangeMeta,
        hasPendingLocalChange.isAcceptableOrUnknown(
          data['has_pending_local_change']!,
          _hasPendingLocalChangeMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('server_payload')) {
      context.handle(
        _serverPayloadMeta,
        serverPayload.isAcceptableOrUnknown(
          data['server_payload']!,
          _serverPayloadMeta,
        ),
      );
    }
    if (data.containsKey('local_patch')) {
      context.handle(
        _localPatchMeta,
        localPatch.isAcceptableOrUnknown(data['local_patch']!, _localPatchMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSettlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSettlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      paidByMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_by_member_id'],
      )!,
      paidToMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_to_member_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      recordedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_by_user_id'],
      )!,
      confirmedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_by_user_id'],
      ),
      statusChangedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_changed_by_user_id'],
      ),
      statusChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_changed_at'],
      ),
      rejectionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_reason'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      ),
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      ),
      hasPendingLocalChange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_pending_local_change'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      serverPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_payload'],
      ),
      localPatch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_patch'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_at'],
      ),
    );
  }

  @override
  $LocalSettlementsTable createAlias(String alias) {
    return $LocalSettlementsTable(attachedDatabase, alias);
  }
}

class LocalSettlement extends DataClass implements Insertable<LocalSettlement> {
  final String id;
  final String tripId;
  final String paidByMemberId;
  final String paidToMemberId;
  final int amountMinor;
  final String paymentDate;
  final String status;
  final String recordedByUserId;
  final String? confirmedByUserId;
  final String? statusChangedByUserId;
  final String? statusChangedAt;
  final String? rejectionReason;
  final String note;
  final int version;
  final int? serverVersion;
  final int? baseVersion;
  final bool hasPendingLocalChange;
  final String syncStatus;
  final String? serverPayload;
  final String? localPatch;
  final String createdAt;
  final String? updatedAt;
  final String? confirmedAt;
  const LocalSettlement({
    required this.id,
    required this.tripId,
    required this.paidByMemberId,
    required this.paidToMemberId,
    required this.amountMinor,
    required this.paymentDate,
    required this.status,
    required this.recordedByUserId,
    this.confirmedByUserId,
    this.statusChangedByUserId,
    this.statusChangedAt,
    this.rejectionReason,
    required this.note,
    required this.version,
    this.serverVersion,
    this.baseVersion,
    required this.hasPendingLocalChange,
    required this.syncStatus,
    this.serverPayload,
    this.localPatch,
    required this.createdAt,
    this.updatedAt,
    this.confirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['paid_by_member_id'] = Variable<String>(paidByMemberId);
    map['paid_to_member_id'] = Variable<String>(paidToMemberId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['payment_date'] = Variable<String>(paymentDate);
    map['status'] = Variable<String>(status);
    map['recorded_by_user_id'] = Variable<String>(recordedByUserId);
    if (!nullToAbsent || confirmedByUserId != null) {
      map['confirmed_by_user_id'] = Variable<String>(confirmedByUserId);
    }
    if (!nullToAbsent || statusChangedByUserId != null) {
      map['status_changed_by_user_id'] = Variable<String>(
        statusChangedByUserId,
      );
    }
    if (!nullToAbsent || statusChangedAt != null) {
      map['status_changed_at'] = Variable<String>(statusChangedAt);
    }
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['note'] = Variable<String>(note);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    if (!nullToAbsent || baseVersion != null) {
      map['base_version'] = Variable<int>(baseVersion);
    }
    map['has_pending_local_change'] = Variable<bool>(hasPendingLocalChange);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverPayload != null) {
      map['server_payload'] = Variable<String>(serverPayload);
    }
    if (!nullToAbsent || localPatch != null) {
      map['local_patch'] = Variable<String>(localPatch);
    }
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<String>(confirmedAt);
    }
    return map;
  }

  LocalSettlementsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettlementsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      paidByMemberId: Value(paidByMemberId),
      paidToMemberId: Value(paidToMemberId),
      amountMinor: Value(amountMinor),
      paymentDate: Value(paymentDate),
      status: Value(status),
      recordedByUserId: Value(recordedByUserId),
      confirmedByUserId: confirmedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedByUserId),
      statusChangedByUserId: statusChangedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(statusChangedByUserId),
      statusChangedAt: statusChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(statusChangedAt),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      note: Value(note),
      version: Value(version),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      baseVersion: baseVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(baseVersion),
      hasPendingLocalChange: Value(hasPendingLocalChange),
      syncStatus: Value(syncStatus),
      serverPayload: serverPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(serverPayload),
      localPatch: localPatch == null && nullToAbsent
          ? const Value.absent()
          : Value(localPatch),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
    );
  }

  factory LocalSettlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSettlement(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      paidByMemberId: serializer.fromJson<String>(json['paidByMemberId']),
      paidToMemberId: serializer.fromJson<String>(json['paidToMemberId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      paymentDate: serializer.fromJson<String>(json['paymentDate']),
      status: serializer.fromJson<String>(json['status']),
      recordedByUserId: serializer.fromJson<String>(json['recordedByUserId']),
      confirmedByUserId: serializer.fromJson<String?>(
        json['confirmedByUserId'],
      ),
      statusChangedByUserId: serializer.fromJson<String?>(
        json['statusChangedByUserId'],
      ),
      statusChangedAt: serializer.fromJson<String?>(json['statusChangedAt']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      note: serializer.fromJson<String>(json['note']),
      version: serializer.fromJson<int>(json['version']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      baseVersion: serializer.fromJson<int?>(json['baseVersion']),
      hasPendingLocalChange: serializer.fromJson<bool>(
        json['hasPendingLocalChange'],
      ),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverPayload: serializer.fromJson<String?>(json['serverPayload']),
      localPatch: serializer.fromJson<String?>(json['localPatch']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      confirmedAt: serializer.fromJson<String?>(json['confirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'paidByMemberId': serializer.toJson<String>(paidByMemberId),
      'paidToMemberId': serializer.toJson<String>(paidToMemberId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'paymentDate': serializer.toJson<String>(paymentDate),
      'status': serializer.toJson<String>(status),
      'recordedByUserId': serializer.toJson<String>(recordedByUserId),
      'confirmedByUserId': serializer.toJson<String?>(confirmedByUserId),
      'statusChangedByUserId': serializer.toJson<String?>(
        statusChangedByUserId,
      ),
      'statusChangedAt': serializer.toJson<String?>(statusChangedAt),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'note': serializer.toJson<String>(note),
      'version': serializer.toJson<int>(version),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'baseVersion': serializer.toJson<int?>(baseVersion),
      'hasPendingLocalChange': serializer.toJson<bool>(hasPendingLocalChange),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverPayload': serializer.toJson<String?>(serverPayload),
      'localPatch': serializer.toJson<String?>(localPatch),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'confirmedAt': serializer.toJson<String?>(confirmedAt),
    };
  }

  LocalSettlement copyWith({
    String? id,
    String? tripId,
    String? paidByMemberId,
    String? paidToMemberId,
    int? amountMinor,
    String? paymentDate,
    String? status,
    String? recordedByUserId,
    Value<String?> confirmedByUserId = const Value.absent(),
    Value<String?> statusChangedByUserId = const Value.absent(),
    Value<String?> statusChangedAt = const Value.absent(),
    Value<String?> rejectionReason = const Value.absent(),
    String? note,
    int? version,
    Value<int?> serverVersion = const Value.absent(),
    Value<int?> baseVersion = const Value.absent(),
    bool? hasPendingLocalChange,
    String? syncStatus,
    Value<String?> serverPayload = const Value.absent(),
    Value<String?> localPatch = const Value.absent(),
    String? createdAt,
    Value<String?> updatedAt = const Value.absent(),
    Value<String?> confirmedAt = const Value.absent(),
  }) => LocalSettlement(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    paidByMemberId: paidByMemberId ?? this.paidByMemberId,
    paidToMemberId: paidToMemberId ?? this.paidToMemberId,
    amountMinor: amountMinor ?? this.amountMinor,
    paymentDate: paymentDate ?? this.paymentDate,
    status: status ?? this.status,
    recordedByUserId: recordedByUserId ?? this.recordedByUserId,
    confirmedByUserId: confirmedByUserId.present
        ? confirmedByUserId.value
        : this.confirmedByUserId,
    statusChangedByUserId: statusChangedByUserId.present
        ? statusChangedByUserId.value
        : this.statusChangedByUserId,
    statusChangedAt: statusChangedAt.present
        ? statusChangedAt.value
        : this.statusChangedAt,
    rejectionReason: rejectionReason.present
        ? rejectionReason.value
        : this.rejectionReason,
    note: note ?? this.note,
    version: version ?? this.version,
    serverVersion: serverVersion.present
        ? serverVersion.value
        : this.serverVersion,
    baseVersion: baseVersion.present ? baseVersion.value : this.baseVersion,
    hasPendingLocalChange: hasPendingLocalChange ?? this.hasPendingLocalChange,
    syncStatus: syncStatus ?? this.syncStatus,
    serverPayload: serverPayload.present
        ? serverPayload.value
        : this.serverPayload,
    localPatch: localPatch.present ? localPatch.value : this.localPatch,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
  );
  LocalSettlement copyWithCompanion(LocalSettlementsCompanion data) {
    return LocalSettlement(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      paidByMemberId: data.paidByMemberId.present
          ? data.paidByMemberId.value
          : this.paidByMemberId,
      paidToMemberId: data.paidToMemberId.present
          ? data.paidToMemberId.value
          : this.paidToMemberId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      status: data.status.present ? data.status.value : this.status,
      recordedByUserId: data.recordedByUserId.present
          ? data.recordedByUserId.value
          : this.recordedByUserId,
      confirmedByUserId: data.confirmedByUserId.present
          ? data.confirmedByUserId.value
          : this.confirmedByUserId,
      statusChangedByUserId: data.statusChangedByUserId.present
          ? data.statusChangedByUserId.value
          : this.statusChangedByUserId,
      statusChangedAt: data.statusChangedAt.present
          ? data.statusChangedAt.value
          : this.statusChangedAt,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      note: data.note.present ? data.note.value : this.note,
      version: data.version.present ? data.version.value : this.version,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      hasPendingLocalChange: data.hasPendingLocalChange.present
          ? data.hasPendingLocalChange.value
          : this.hasPendingLocalChange,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      serverPayload: data.serverPayload.present
          ? data.serverPayload.value
          : this.serverPayload,
      localPatch: data.localPatch.present
          ? data.localPatch.value
          : this.localPatch,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettlement(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('paidToMemberId: $paidToMemberId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('status: $status, ')
          ..write('recordedByUserId: $recordedByUserId, ')
          ..write('confirmedByUserId: $confirmedByUserId, ')
          ..write('statusChangedByUserId: $statusChangedByUserId, ')
          ..write('statusChangedAt: $statusChangedAt, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('note: $note, ')
          ..write('version: $version, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('hasPendingLocalChange: $hasPendingLocalChange, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('localPatch: $localPatch, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    tripId,
    paidByMemberId,
    paidToMemberId,
    amountMinor,
    paymentDate,
    status,
    recordedByUserId,
    confirmedByUserId,
    statusChangedByUserId,
    statusChangedAt,
    rejectionReason,
    note,
    version,
    serverVersion,
    baseVersion,
    hasPendingLocalChange,
    syncStatus,
    serverPayload,
    localPatch,
    createdAt,
    updatedAt,
    confirmedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSettlement &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.paidByMemberId == this.paidByMemberId &&
          other.paidToMemberId == this.paidToMemberId &&
          other.amountMinor == this.amountMinor &&
          other.paymentDate == this.paymentDate &&
          other.status == this.status &&
          other.recordedByUserId == this.recordedByUserId &&
          other.confirmedByUserId == this.confirmedByUserId &&
          other.statusChangedByUserId == this.statusChangedByUserId &&
          other.statusChangedAt == this.statusChangedAt &&
          other.rejectionReason == this.rejectionReason &&
          other.note == this.note &&
          other.version == this.version &&
          other.serverVersion == this.serverVersion &&
          other.baseVersion == this.baseVersion &&
          other.hasPendingLocalChange == this.hasPendingLocalChange &&
          other.syncStatus == this.syncStatus &&
          other.serverPayload == this.serverPayload &&
          other.localPatch == this.localPatch &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.confirmedAt == this.confirmedAt);
}

class LocalSettlementsCompanion extends UpdateCompanion<LocalSettlement> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> paidByMemberId;
  final Value<String> paidToMemberId;
  final Value<int> amountMinor;
  final Value<String> paymentDate;
  final Value<String> status;
  final Value<String> recordedByUserId;
  final Value<String?> confirmedByUserId;
  final Value<String?> statusChangedByUserId;
  final Value<String?> statusChangedAt;
  final Value<String?> rejectionReason;
  final Value<String> note;
  final Value<int> version;
  final Value<int?> serverVersion;
  final Value<int?> baseVersion;
  final Value<bool> hasPendingLocalChange;
  final Value<String> syncStatus;
  final Value<String?> serverPayload;
  final Value<String?> localPatch;
  final Value<String> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> confirmedAt;
  final Value<int> rowid;
  const LocalSettlementsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.paidByMemberId = const Value.absent(),
    this.paidToMemberId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.status = const Value.absent(),
    this.recordedByUserId = const Value.absent(),
    this.confirmedByUserId = const Value.absent(),
    this.statusChangedByUserId = const Value.absent(),
    this.statusChangedAt = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.note = const Value.absent(),
    this.version = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.hasPendingLocalChange = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverPayload = const Value.absent(),
    this.localPatch = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettlementsCompanion.insert({
    required String id,
    required String tripId,
    required String paidByMemberId,
    required String paidToMemberId,
    required int amountMinor,
    required String paymentDate,
    required String status,
    required String recordedByUserId,
    this.confirmedByUserId = const Value.absent(),
    this.statusChangedByUserId = const Value.absent(),
    this.statusChangedAt = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.note = const Value.absent(),
    this.version = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.hasPendingLocalChange = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverPayload = const Value.absent(),
    this.localPatch = const Value.absent(),
    required String createdAt,
    this.updatedAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       paidByMemberId = Value(paidByMemberId),
       paidToMemberId = Value(paidToMemberId),
       amountMinor = Value(amountMinor),
       paymentDate = Value(paymentDate),
       status = Value(status),
       recordedByUserId = Value(recordedByUserId),
       createdAt = Value(createdAt);
  static Insertable<LocalSettlement> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? paidByMemberId,
    Expression<String>? paidToMemberId,
    Expression<int>? amountMinor,
    Expression<String>? paymentDate,
    Expression<String>? status,
    Expression<String>? recordedByUserId,
    Expression<String>? confirmedByUserId,
    Expression<String>? statusChangedByUserId,
    Expression<String>? statusChangedAt,
    Expression<String>? rejectionReason,
    Expression<String>? note,
    Expression<int>? version,
    Expression<int>? serverVersion,
    Expression<int>? baseVersion,
    Expression<bool>? hasPendingLocalChange,
    Expression<String>? syncStatus,
    Expression<String>? serverPayload,
    Expression<String>? localPatch,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? confirmedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (paidByMemberId != null) 'paid_by_member_id': paidByMemberId,
      if (paidToMemberId != null) 'paid_to_member_id': paidToMemberId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (status != null) 'status': status,
      if (recordedByUserId != null) 'recorded_by_user_id': recordedByUserId,
      if (confirmedByUserId != null) 'confirmed_by_user_id': confirmedByUserId,
      if (statusChangedByUserId != null)
        'status_changed_by_user_id': statusChangedByUserId,
      if (statusChangedAt != null) 'status_changed_at': statusChangedAt,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (note != null) 'note': note,
      if (version != null) 'version': version,
      if (serverVersion != null) 'server_version': serverVersion,
      if (baseVersion != null) 'base_version': baseVersion,
      if (hasPendingLocalChange != null)
        'has_pending_local_change': hasPendingLocalChange,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverPayload != null) 'server_payload': serverPayload,
      if (localPatch != null) 'local_patch': localPatch,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSettlementsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? paidByMemberId,
    Value<String>? paidToMemberId,
    Value<int>? amountMinor,
    Value<String>? paymentDate,
    Value<String>? status,
    Value<String>? recordedByUserId,
    Value<String?>? confirmedByUserId,
    Value<String?>? statusChangedByUserId,
    Value<String?>? statusChangedAt,
    Value<String?>? rejectionReason,
    Value<String>? note,
    Value<int>? version,
    Value<int?>? serverVersion,
    Value<int?>? baseVersion,
    Value<bool>? hasPendingLocalChange,
    Value<String>? syncStatus,
    Value<String?>? serverPayload,
    Value<String?>? localPatch,
    Value<String>? createdAt,
    Value<String?>? updatedAt,
    Value<String?>? confirmedAt,
    Value<int>? rowid,
  }) {
    return LocalSettlementsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      paidToMemberId: paidToMemberId ?? this.paidToMemberId,
      amountMinor: amountMinor ?? this.amountMinor,
      paymentDate: paymentDate ?? this.paymentDate,
      status: status ?? this.status,
      recordedByUserId: recordedByUserId ?? this.recordedByUserId,
      confirmedByUserId: confirmedByUserId ?? this.confirmedByUserId,
      statusChangedByUserId:
          statusChangedByUserId ?? this.statusChangedByUserId,
      statusChangedAt: statusChangedAt ?? this.statusChangedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      note: note ?? this.note,
      version: version ?? this.version,
      serverVersion: serverVersion ?? this.serverVersion,
      baseVersion: baseVersion ?? this.baseVersion,
      hasPendingLocalChange:
          hasPendingLocalChange ?? this.hasPendingLocalChange,
      syncStatus: syncStatus ?? this.syncStatus,
      serverPayload: serverPayload ?? this.serverPayload,
      localPatch: localPatch ?? this.localPatch,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (paidByMemberId.present) {
      map['paid_by_member_id'] = Variable<String>(paidByMemberId.value);
    }
    if (paidToMemberId.present) {
      map['paid_to_member_id'] = Variable<String>(paidToMemberId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<String>(paymentDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recordedByUserId.present) {
      map['recorded_by_user_id'] = Variable<String>(recordedByUserId.value);
    }
    if (confirmedByUserId.present) {
      map['confirmed_by_user_id'] = Variable<String>(confirmedByUserId.value);
    }
    if (statusChangedByUserId.present) {
      map['status_changed_by_user_id'] = Variable<String>(
        statusChangedByUserId.value,
      );
    }
    if (statusChangedAt.present) {
      map['status_changed_at'] = Variable<String>(statusChangedAt.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (hasPendingLocalChange.present) {
      map['has_pending_local_change'] = Variable<bool>(
        hasPendingLocalChange.value,
      );
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverPayload.present) {
      map['server_payload'] = Variable<String>(serverPayload.value);
    }
    if (localPatch.present) {
      map['local_patch'] = Variable<String>(localPatch.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<String>(confirmedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettlementsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('paidToMemberId: $paidToMemberId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('status: $status, ')
          ..write('recordedByUserId: $recordedByUserId, ')
          ..write('confirmedByUserId: $confirmedByUserId, ')
          ..write('statusChangedByUserId: $statusChangedByUserId, ')
          ..write('statusChangedAt: $statusChangedAt, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('note: $note, ')
          ..write('version: $version, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('hasPendingLocalChange: $hasPendingLocalChange, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('localPatch: $localPatch, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxOperationsTable extends OutboxOperations
    with TableInfo<$OutboxOperationsTable, LocalOutboxOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endpointMeta = const VerificationMeta(
    'endpoint',
  );
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
    'endpoint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestHashMeta = const VerificationMeta(
    'requestHash',
  );
  @override
  late final GeneratedColumn<String> requestHash = GeneratedColumn<String>(
    'request_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<String> nextAttemptAt = GeneratedColumn<String>(
    'next_attempt_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lockedAtMeta = const VerificationMeta(
    'lockedAt',
  );
  @override
  late final GeneratedColumn<String> lockedAt = GeneratedColumn<String>(
    'locked_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    entityType,
    entityId,
    operationType,
    method,
    endpoint,
    payload,
    requestHash,
    baseVersion,
    state,
    attemptCount,
    nextAttemptAt,
    lockedAt,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalOutboxOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(
        _endpointMeta,
        endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta),
      );
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('request_hash')) {
      context.handle(
        _requestHashMeta,
        requestHash.isAcceptableOrUnknown(
          data['request_hash']!,
          _requestHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestHashMeta);
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('locked_at')) {
      context.handle(
        _lockedAtMeta,
        lockedAt.isAcceptableOrUnknown(data['locked_at']!, _lockedAtMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalOutboxOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalOutboxOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      endpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endpoint'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      requestHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_hash'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locked_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OutboxOperationsTable createAlias(String alias) {
    return $OutboxOperationsTable(attachedDatabase, alias);
  }
}

class LocalOutboxOperation extends DataClass
    implements Insertable<LocalOutboxOperation> {
  final String id;
  final String tripId;
  final String entityType;
  final String entityId;
  final String operationType;
  final String method;
  final String endpoint;
  final String payload;
  final String requestHash;
  final int? baseVersion;
  final String state;
  final int attemptCount;
  final String? nextAttemptAt;
  final String? lockedAt;
  final String? lastError;
  final String createdAt;
  final String updatedAt;
  const LocalOutboxOperation({
    required this.id,
    required this.tripId,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.method,
    required this.endpoint,
    required this.payload,
    required this.requestHash,
    this.baseVersion,
    required this.state,
    required this.attemptCount,
    this.nextAttemptAt,
    this.lockedAt,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation_type'] = Variable<String>(operationType);
    map['method'] = Variable<String>(method);
    map['endpoint'] = Variable<String>(endpoint);
    map['payload'] = Variable<String>(payload);
    map['request_hash'] = Variable<String>(requestHash);
    if (!nullToAbsent || baseVersion != null) {
      map['base_version'] = Variable<int>(baseVersion);
    }
    map['state'] = Variable<String>(state);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<String>(nextAttemptAt);
    }
    if (!nullToAbsent || lockedAt != null) {
      map['locked_at'] = Variable<String>(lockedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  OutboxOperationsCompanion toCompanion(bool nullToAbsent) {
    return OutboxOperationsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operationType: Value(operationType),
      method: Value(method),
      endpoint: Value(endpoint),
      payload: Value(payload),
      requestHash: Value(requestHash),
      baseVersion: baseVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(baseVersion),
      state: Value(state),
      attemptCount: Value(attemptCount),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lockedAt: lockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalOutboxOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalOutboxOperation(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      method: serializer.fromJson<String>(json['method']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      payload: serializer.fromJson<String>(json['payload']),
      requestHash: serializer.fromJson<String>(json['requestHash']),
      baseVersion: serializer.fromJson<int?>(json['baseVersion']),
      state: serializer.fromJson<String>(json['state']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAt: serializer.fromJson<String?>(json['nextAttemptAt']),
      lockedAt: serializer.fromJson<String?>(json['lockedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operationType': serializer.toJson<String>(operationType),
      'method': serializer.toJson<String>(method),
      'endpoint': serializer.toJson<String>(endpoint),
      'payload': serializer.toJson<String>(payload),
      'requestHash': serializer.toJson<String>(requestHash),
      'baseVersion': serializer.toJson<int?>(baseVersion),
      'state': serializer.toJson<String>(state),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAt': serializer.toJson<String?>(nextAttemptAt),
      'lockedAt': serializer.toJson<String?>(lockedAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  LocalOutboxOperation copyWith({
    String? id,
    String? tripId,
    String? entityType,
    String? entityId,
    String? operationType,
    String? method,
    String? endpoint,
    String? payload,
    String? requestHash,
    Value<int?> baseVersion = const Value.absent(),
    String? state,
    int? attemptCount,
    Value<String?> nextAttemptAt = const Value.absent(),
    Value<String?> lockedAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => LocalOutboxOperation(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operationType: operationType ?? this.operationType,
    method: method ?? this.method,
    endpoint: endpoint ?? this.endpoint,
    payload: payload ?? this.payload,
    requestHash: requestHash ?? this.requestHash,
    baseVersion: baseVersion.present ? baseVersion.value : this.baseVersion,
    state: state ?? this.state,
    attemptCount: attemptCount ?? this.attemptCount,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lockedAt: lockedAt.present ? lockedAt.value : this.lockedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalOutboxOperation copyWithCompanion(OutboxOperationsCompanion data) {
    return LocalOutboxOperation(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      method: data.method.present ? data.method.value : this.method,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      payload: data.payload.present ? data.payload.value : this.payload,
      requestHash: data.requestHash.present
          ? data.requestHash.value
          : this.requestHash,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      state: data.state.present ? data.state.value : this.state,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lockedAt: data.lockedAt.present ? data.lockedAt.value : this.lockedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalOutboxOperation(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('method: $method, ')
          ..write('endpoint: $endpoint, ')
          ..write('payload: $payload, ')
          ..write('requestHash: $requestHash, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('state: $state, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lockedAt: $lockedAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    entityType,
    entityId,
    operationType,
    method,
    endpoint,
    payload,
    requestHash,
    baseVersion,
    state,
    attemptCount,
    nextAttemptAt,
    lockedAt,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalOutboxOperation &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operationType == this.operationType &&
          other.method == this.method &&
          other.endpoint == this.endpoint &&
          other.payload == this.payload &&
          other.requestHash == this.requestHash &&
          other.baseVersion == this.baseVersion &&
          other.state == this.state &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lockedAt == this.lockedAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OutboxOperationsCompanion extends UpdateCompanion<LocalOutboxOperation> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operationType;
  final Value<String> method;
  final Value<String> endpoint;
  final Value<String> payload;
  final Value<String> requestHash;
  final Value<int?> baseVersion;
  final Value<String> state;
  final Value<int> attemptCount;
  final Value<String?> nextAttemptAt;
  final Value<String?> lockedAt;
  final Value<String?> lastError;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const OutboxOperationsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.method = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.payload = const Value.absent(),
    this.requestHash = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lockedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxOperationsCompanion.insert({
    required String id,
    required String tripId,
    required String entityType,
    required String entityId,
    required String operationType,
    required String method,
    required String endpoint,
    required String payload,
    required String requestHash,
    this.baseVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lockedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operationType = Value(operationType),
       method = Value(method),
       endpoint = Value(endpoint),
       payload = Value(payload),
       requestHash = Value(requestHash),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalOutboxOperation> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operationType,
    Expression<String>? method,
    Expression<String>? endpoint,
    Expression<String>? payload,
    Expression<String>? requestHash,
    Expression<int>? baseVersion,
    Expression<String>? state,
    Expression<int>? attemptCount,
    Expression<String>? nextAttemptAt,
    Expression<String>? lockedAt,
    Expression<String>? lastError,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operationType != null) 'operation_type': operationType,
      if (method != null) 'method': method,
      if (endpoint != null) 'endpoint': endpoint,
      if (payload != null) 'payload': payload,
      if (requestHash != null) 'request_hash': requestHash,
      if (baseVersion != null) 'base_version': baseVersion,
      if (state != null) 'state': state,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lockedAt != null) 'locked_at': lockedAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operationType,
    Value<String>? method,
    Value<String>? endpoint,
    Value<String>? payload,
    Value<String>? requestHash,
    Value<int?>? baseVersion,
    Value<String>? state,
    Value<int>? attemptCount,
    Value<String?>? nextAttemptAt,
    Value<String?>? lockedAt,
    Value<String?>? lastError,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return OutboxOperationsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      method: method ?? this.method,
      endpoint: endpoint ?? this.endpoint,
      payload: payload ?? this.payload,
      requestHash: requestHash ?? this.requestHash,
      baseVersion: baseVersion ?? this.baseVersion,
      state: state ?? this.state,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lockedAt: lockedAt ?? this.lockedAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (requestHash.present) {
      map['request_hash'] = Variable<String>(requestHash.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<String>(nextAttemptAt.value);
    }
    if (lockedAt.present) {
      map['locked_at'] = Variable<String>(lockedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOperationsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('method: $method, ')
          ..write('endpoint: $endpoint, ')
          ..write('payload: $payload, ')
          ..write('requestHash: $requestHash, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('state: $state, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lockedAt: $lockedAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSequenceMeta = const VerificationMeta(
    'lastSequence',
  );
  @override
  late final GeneratedColumn<int> lastSequence = GeneratedColumn<int>(
    'last_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tripId, lastSequence, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('last_sequence')) {
      context.handle(
        _lastSequenceMeta,
        lastSequence.isAcceptableOrUnknown(
          data['last_sequence']!,
          _lastSequenceMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tripId};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      lastSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sequence'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String tripId;
  final int lastSequence;
  final String updatedAt;
  const SyncCursor({
    required this.tripId,
    required this.lastSequence,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<String>(tripId);
    map['last_sequence'] = Variable<int>(lastSequence);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(
      tripId: Value(tripId),
      lastSequence: Value(lastSequence),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      tripId: serializer.fromJson<String>(json['tripId']),
      lastSequence: serializer.fromJson<int>(json['lastSequence']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<String>(tripId),
      'lastSequence': serializer.toJson<int>(lastSequence),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  SyncCursor copyWith({String? tripId, int? lastSequence, String? updatedAt}) =>
      SyncCursor(
        tripId: tripId ?? this.tripId,
        lastSequence: lastSequence ?? this.lastSequence,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncCursor copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursor(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('tripId: $tripId, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tripId, lastSequence, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.tripId == this.tripId &&
          other.lastSequence == this.lastSequence &&
          other.updatedAt == this.updatedAt);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> tripId;
  final Value<int> lastSequence;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.tripId = const Value.absent(),
    this.lastSequence = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String tripId,
    this.lastSequence = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       updatedAt = Value(updatedAt);
  static Insertable<SyncCursor> custom({
    Expression<String>? tripId,
    Expression<int>? lastSequence,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (lastSequence != null) 'last_sequence': lastSequence,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? tripId,
    Value<int>? lastSequence,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      tripId: tripId ?? this.tripId,
      lastSequence: lastSequence ?? this.lastSequence,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (lastSequence.present) {
      map['last_sequence'] = Variable<int>(lastSequence.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSyncCursorsTable extends UserSyncCursors
    with TableInfo<$UserSyncCursorsTable, UserSyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSequenceMeta = const VerificationMeta(
    'lastSequence',
  );
  @override
  late final GeneratedColumn<int> lastSequence = GeneratedColumn<int>(
    'last_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, lastSequence, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('last_sequence')) {
      context.handle(
        _lastSequenceMeta,
        lastSequence.isAcceptableOrUnknown(
          data['last_sequence']!,
          _lastSequenceMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserSyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSyncCursor(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      lastSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sequence'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSyncCursorsTable createAlias(String alias) {
    return $UserSyncCursorsTable(attachedDatabase, alias);
  }
}

class UserSyncCursor extends DataClass implements Insertable<UserSyncCursor> {
  final String userId;
  final int lastSequence;
  final String updatedAt;
  const UserSyncCursor({
    required this.userId,
    required this.lastSequence,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['last_sequence'] = Variable<int>(lastSequence);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  UserSyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return UserSyncCursorsCompanion(
      userId: Value(userId),
      lastSequence: Value(lastSequence),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSyncCursor(
      userId: serializer.fromJson<String>(json['userId']),
      lastSequence: serializer.fromJson<int>(json['lastSequence']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'lastSequence': serializer.toJson<int>(lastSequence),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  UserSyncCursor copyWith({
    String? userId,
    int? lastSequence,
    String? updatedAt,
  }) => UserSyncCursor(
    userId: userId ?? this.userId,
    lastSequence: lastSequence ?? this.lastSequence,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSyncCursor copyWithCompanion(UserSyncCursorsCompanion data) {
    return UserSyncCursor(
      userId: data.userId.present ? data.userId.value : this.userId,
      lastSequence: data.lastSequence.present
          ? data.lastSequence.value
          : this.lastSequence,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSyncCursor(')
          ..write('userId: $userId, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, lastSequence, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSyncCursor &&
          other.userId == this.userId &&
          other.lastSequence == this.lastSequence &&
          other.updatedAt == this.updatedAt);
}

class UserSyncCursorsCompanion extends UpdateCompanion<UserSyncCursor> {
  final Value<String> userId;
  final Value<int> lastSequence;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const UserSyncCursorsCompanion({
    this.userId = const Value.absent(),
    this.lastSequence = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSyncCursorsCompanion.insert({
    required String userId,
    this.lastSequence = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       updatedAt = Value(updatedAt);
  static Insertable<UserSyncCursor> custom({
    Expression<String>? userId,
    Expression<int>? lastSequence,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (lastSequence != null) 'last_sequence': lastSequence,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSyncCursorsCompanion copyWith({
    Value<String>? userId,
    Value<int>? lastSequence,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSyncCursorsCompanion(
      userId: userId ?? this.userId,
      lastSequence: lastSequence ?? this.lastSequence,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lastSequence.present) {
      map['last_sequence'] = Variable<int>(lastSequence.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSyncCursorsCompanion(')
          ..write('userId: $userId, ')
          ..write('lastSequence: $lastSequence, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPayloadMeta = const VerificationMeta(
    'localPayload',
  );
  @override
  late final GeneratedColumn<String> localPayload = GeneratedColumn<String>(
    'local_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverPayloadMeta = const VerificationMeta(
    'serverPayload',
  );
  @override
  late final GeneratedColumn<String> serverPayload = GeneratedColumn<String>(
    'server_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<String> resolvedAt = GeneratedColumn<String>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolutionMeta = const VerificationMeta(
    'resolution',
  );
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
    'resolution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    entityType,
    entityId,
    localPayload,
    serverPayload,
    baseVersion,
    serverVersion,
    createdAt,
    resolvedAt,
    resolution,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflict> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('local_payload')) {
      context.handle(
        _localPayloadMeta,
        localPayload.isAcceptableOrUnknown(
          data['local_payload']!,
          _localPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localPayloadMeta);
    }
    if (data.containsKey('server_payload')) {
      context.handle(
        _serverPayloadMeta,
        serverPayload.isAcceptableOrUnknown(
          data['server_payload']!,
          _serverPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverPayloadMeta);
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('resolution')) {
      context.handle(
        _resolutionMeta,
        resolution.isAcceptableOrUnknown(data['resolution']!, _resolutionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflict(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      localPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_payload'],
      )!,
      serverPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_payload'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      ),
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolved_at'],
      ),
      resolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution'],
      ),
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflict extends DataClass implements Insertable<SyncConflict> {
  final String id;
  final String tripId;
  final String entityType;
  final String entityId;
  final String localPayload;
  final String serverPayload;
  final int? baseVersion;
  final int? serverVersion;
  final String createdAt;
  final String? resolvedAt;
  final String? resolution;
  const SyncConflict({
    required this.id,
    required this.tripId,
    required this.entityType,
    required this.entityId,
    required this.localPayload,
    required this.serverPayload,
    this.baseVersion,
    this.serverVersion,
    required this.createdAt,
    this.resolvedAt,
    this.resolution,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['local_payload'] = Variable<String>(localPayload);
    map['server_payload'] = Variable<String>(serverPayload);
    if (!nullToAbsent || baseVersion != null) {
      map['base_version'] = Variable<int>(baseVersion);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<String>(resolvedAt);
    }
    if (!nullToAbsent || resolution != null) {
      map['resolution'] = Variable<String>(resolution);
    }
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      localPayload: Value(localPayload),
      serverPayload: Value(serverPayload),
      baseVersion: baseVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(baseVersion),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      resolution: resolution == null && nullToAbsent
          ? const Value.absent()
          : Value(resolution),
    );
  }

  factory SyncConflict.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflict(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      localPayload: serializer.fromJson<String>(json['localPayload']),
      serverPayload: serializer.fromJson<String>(json['serverPayload']),
      baseVersion: serializer.fromJson<int?>(json['baseVersion']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      resolvedAt: serializer.fromJson<String?>(json['resolvedAt']),
      resolution: serializer.fromJson<String?>(json['resolution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'localPayload': serializer.toJson<String>(localPayload),
      'serverPayload': serializer.toJson<String>(serverPayload),
      'baseVersion': serializer.toJson<int?>(baseVersion),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'createdAt': serializer.toJson<String>(createdAt),
      'resolvedAt': serializer.toJson<String?>(resolvedAt),
      'resolution': serializer.toJson<String?>(resolution),
    };
  }

  SyncConflict copyWith({
    String? id,
    String? tripId,
    String? entityType,
    String? entityId,
    String? localPayload,
    String? serverPayload,
    Value<int?> baseVersion = const Value.absent(),
    Value<int?> serverVersion = const Value.absent(),
    String? createdAt,
    Value<String?> resolvedAt = const Value.absent(),
    Value<String?> resolution = const Value.absent(),
  }) => SyncConflict(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    localPayload: localPayload ?? this.localPayload,
    serverPayload: serverPayload ?? this.serverPayload,
    baseVersion: baseVersion.present ? baseVersion.value : this.baseVersion,
    serverVersion: serverVersion.present
        ? serverVersion.value
        : this.serverVersion,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    resolution: resolution.present ? resolution.value : this.resolution,
  );
  SyncConflict copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflict(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      localPayload: data.localPayload.present
          ? data.localPayload.value
          : this.localPayload,
      serverPayload: data.serverPayload.present
          ? data.serverPayload.value
          : this.serverPayload,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      resolution: data.resolution.present
          ? data.resolution.value
          : this.resolution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflict(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('localPayload: $localPayload, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolution: $resolution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    entityType,
    entityId,
    localPayload,
    serverPayload,
    baseVersion,
    serverVersion,
    createdAt,
    resolvedAt,
    resolution,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflict &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.localPayload == this.localPayload &&
          other.serverPayload == this.serverPayload &&
          other.baseVersion == this.baseVersion &&
          other.serverVersion == this.serverVersion &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt &&
          other.resolution == this.resolution);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflict> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> localPayload;
  final Value<String> serverPayload;
  final Value<int?> baseVersion;
  final Value<int?> serverVersion;
  final Value<String> createdAt;
  final Value<String?> resolvedAt;
  final Value<String?> resolution;
  final Value<int> rowid;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localPayload = const Value.absent(),
    this.serverPayload = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.resolution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    required String id,
    required String tripId,
    required String entityType,
    required String entityId,
    required String localPayload,
    required String serverPayload,
    this.baseVersion = const Value.absent(),
    this.serverVersion = const Value.absent(),
    required String createdAt,
    this.resolvedAt = const Value.absent(),
    this.resolution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       localPayload = Value(localPayload),
       serverPayload = Value(serverPayload),
       createdAt = Value(createdAt);
  static Insertable<SyncConflict> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? localPayload,
    Expression<String>? serverPayload,
    Expression<int>? baseVersion,
    Expression<int>? serverVersion,
    Expression<String>? createdAt,
    Expression<String>? resolvedAt,
    Expression<String>? resolution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (localPayload != null) 'local_payload': localPayload,
      if (serverPayload != null) 'server_payload': serverPayload,
      if (baseVersion != null) 'base_version': baseVersion,
      if (serverVersion != null) 'server_version': serverVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (resolution != null) 'resolution': resolution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? localPayload,
    Value<String>? serverPayload,
    Value<int?>? baseVersion,
    Value<int?>? serverVersion,
    Value<String>? createdAt,
    Value<String?>? resolvedAt,
    Value<String?>? resolution,
    Value<int>? rowid,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      localPayload: localPayload ?? this.localPayload,
      serverPayload: serverPayload ?? this.serverPayload,
      baseVersion: baseVersion ?? this.baseVersion,
      serverVersion: serverVersion ?? this.serverVersion,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolution: resolution ?? this.resolution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (localPayload.present) {
      map['local_payload'] = Variable<String>(localPayload.value);
    }
    if (serverPayload.present) {
      map['server_payload'] = Variable<String>(serverPayload.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<String>(resolvedAt.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('localPayload: $localPayload, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolution: $resolution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceStateTable extends DeviceState
    with TableInfo<$DeviceStateTable, DeviceStateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceStateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DeviceStateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceStateEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $DeviceStateTable createAlias(String alias) {
    return $DeviceStateTable(attachedDatabase, alias);
  }
}

class DeviceStateEntry extends DataClass
    implements Insertable<DeviceStateEntry> {
  final String key;
  final String value;
  const DeviceStateEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  DeviceStateCompanion toCompanion(bool nullToAbsent) {
    return DeviceStateCompanion(key: Value(key), value: Value(value));
  }

  factory DeviceStateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceStateEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DeviceStateEntry copyWith({String? key, String? value}) =>
      DeviceStateEntry(key: key ?? this.key, value: value ?? this.value);
  DeviceStateEntry copyWithCompanion(DeviceStateCompanion data) {
    return DeviceStateEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceStateEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceStateEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class DeviceStateCompanion extends UpdateCompanion<DeviceStateEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const DeviceStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceStateCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<DeviceStateEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceStateCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return DeviceStateCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceStateCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalUserProfileTable localUserProfile = $LocalUserProfileTable(
    this,
  );
  late final $LocalTripsTable localTrips = $LocalTripsTable(this);
  late final $LocalMembersTable localMembers = $LocalMembersTable(this);
  late final $LocalInvitationsTable localInvitations = $LocalInvitationsTable(
    this,
  );
  late final $LocalExpensesTable localExpenses = $LocalExpensesTable(this);
  late final $LocalExpenseSplitsTable localExpenseSplits =
      $LocalExpenseSplitsTable(this);
  late final $LocalSettlementsTable localSettlements = $LocalSettlementsTable(
    this,
  );
  late final $OutboxOperationsTable outboxOperations = $OutboxOperationsTable(
    this,
  );
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  late final $UserSyncCursorsTable userSyncCursors = $UserSyncCursorsTable(
    this,
  );
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final $DeviceStateTable deviceState = $DeviceStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localUserProfile,
    localTrips,
    localMembers,
    localInvitations,
    localExpenses,
    localExpenseSplits,
    localSettlements,
    outboxOperations,
    syncCursors,
    userSyncCursors,
    syncConflicts,
    deviceState,
  ];
}

typedef $$LocalUserProfileTableCreateCompanionBuilder =
    LocalUserProfileCompanion Function({
      required String userId,
      required String name,
      required String email,
      Value<String> notificationPreferencesJson,
      Value<int> serverSyncVersion,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserProfileTableUpdateCompanionBuilder =
    LocalUserProfileCompanion Function({
      Value<String> userId,
      Value<String> name,
      Value<String> email,
      Value<String> notificationPreferencesJson,
      Value<int> serverSyncVersion,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$LocalUserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserProfileTable> {
  $$LocalUserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationPreferencesJson => $composableBuilder(
    column: $table.notificationPreferencesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSyncVersion => $composableBuilder(
    column: $table.serverSyncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserProfileTable> {
  $$LocalUserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationPreferencesJson => $composableBuilder(
    column: $table.notificationPreferencesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSyncVersion => $composableBuilder(
    column: $table.serverSyncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserProfileTable> {
  $$LocalUserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notificationPreferencesJson => $composableBuilder(
    column: $table.notificationPreferencesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverSyncVersion => $composableBuilder(
    column: $table.serverSyncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalUserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserProfileTable,
          LocalUserProfileData,
          $$LocalUserProfileTableFilterComposer,
          $$LocalUserProfileTableOrderingComposer,
          $$LocalUserProfileTableAnnotationComposer,
          $$LocalUserProfileTableCreateCompanionBuilder,
          $$LocalUserProfileTableUpdateCompanionBuilder,
          (
            LocalUserProfileData,
            BaseReferences<
              _$AppDatabase,
              $LocalUserProfileTable,
              LocalUserProfileData
            >,
          ),
          LocalUserProfileData,
          PrefetchHooks Function()
        > {
  $$LocalUserProfileTableTableManager(
    _$AppDatabase db,
    $LocalUserProfileTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> notificationPreferencesJson =
                    const Value.absent(),
                Value<int> serverSyncVersion = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfileCompanion(
                userId: userId,
                name: name,
                email: email,
                notificationPreferencesJson: notificationPreferencesJson,
                serverSyncVersion: serverSyncVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String name,
                required String email,
                Value<String> notificationPreferencesJson =
                    const Value.absent(),
                Value<int> serverSyncVersion = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfileCompanion.insert(
                userId: userId,
                name: name,
                email: email,
                notificationPreferencesJson: notificationPreferencesJson,
                serverSyncVersion: serverSyncVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalUserProfileTable, LocalUserProfileData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalUserProfileTable,
                    LocalUserProfileData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserProfileTable,
      LocalUserProfileData,
      $$LocalUserProfileTableFilterComposer,
      $$LocalUserProfileTableOrderingComposer,
      $$LocalUserProfileTableAnnotationComposer,
      $$LocalUserProfileTableCreateCompanionBuilder,
      $$LocalUserProfileTableUpdateCompanionBuilder,
      (
        LocalUserProfileData,
        BaseReferences<
          _$AppDatabase,
          $LocalUserProfileTable,
          LocalUserProfileData
        >,
      ),
      LocalUserProfileData,
      PrefetchHooks Function()
    >;
typedef $$LocalTripsTableCreateCompanionBuilder = LocalTripsCompanion Function({
  required String id,
  required String name,
  Value<String?> destination,
  Value<String?> description,
  required String currency,
  Value<int> currencyExponent,
  required String ownerUserId,
  required String createdByUserId,
  Value<String> myRole,
  Value<String?> memberId,
  Value<String?> startDate,
  Value<String?> endDate,
  Value<String?> archivedAt,
  Value<int> serverSyncVersion,
  required String cachedAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$LocalTripsTableUpdateCompanionBuilder = LocalTripsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> destination,
  Value<String?> description,
  Value<String> currency,
  Value<int> currencyExponent,
  Value<String> ownerUserId,
  Value<String> createdByUserId,
  Value<String> myRole,
  Value<String?> memberId,
  Value<String?> startDate,
  Value<String?> endDate,
  Value<String?> archivedAt,
  Value<int> serverSyncVersion,
  Value<String> cachedAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$LocalTripsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTripsTable> {
  $$LocalTripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currencyExponent => $composableBuilder(
    column: $table.currencyExponent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get myRole => $composableBuilder(
    column: $table.myRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSyncVersion => $composableBuilder(
    column: $table.serverSyncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTripsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTripsTable> {
  $$LocalTripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currencyExponent => $composableBuilder(
    column: $table.currencyExponent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get myRole => $composableBuilder(
    column: $table.myRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSyncVersion => $composableBuilder(
    column: $table.serverSyncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTripsTable> {
  $$LocalTripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get currencyExponent => $composableBuilder(
    column: $table.currencyExponent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get myRole =>
      $composableBuilder(column: $table.myRole, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverSyncVersion => $composableBuilder(
    column: $table.serverSyncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalTripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTripsTable,
          LocalTrip,
          $$LocalTripsTableFilterComposer,
          $$LocalTripsTableOrderingComposer,
          $$LocalTripsTableAnnotationComposer,
          $$LocalTripsTableCreateCompanionBuilder,
          $$LocalTripsTableUpdateCompanionBuilder,
          (
            LocalTrip,
            BaseReferences<_$AppDatabase, $LocalTripsTable, LocalTrip>,
          ),
          LocalTrip,
          PrefetchHooks Function()
        > {
  $$LocalTripsTableTableManager(_$AppDatabase db, $LocalTripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> currencyExponent = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<String> createdByUserId = const Value.absent(),
                Value<String> myRole = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String?> archivedAt = const Value.absent(),
                Value<int> serverSyncVersion = const Value.absent(),
                Value<String> cachedAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTripsCompanion(
                id: id,
                name: name,
                destination: destination,
                description: description,
                currency: currency,
                currencyExponent: currencyExponent,
                ownerUserId: ownerUserId,
                createdByUserId: createdByUserId,
                myRole: myRole,
                memberId: memberId,
                startDate: startDate,
                endDate: endDate,
                archivedAt: archivedAt,
                serverSyncVersion: serverSyncVersion,
                cachedAt: cachedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> destination = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required String currency,
                Value<int> currencyExponent = const Value.absent(),
                required String ownerUserId,
                required String createdByUserId,
                Value<String> myRole = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String?> archivedAt = const Value.absent(),
                Value<int> serverSyncVersion = const Value.absent(),
                required String cachedAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalTripsCompanion.insert(
                id: id,
                name: name,
                destination: destination,
                description: description,
                currency: currency,
                currencyExponent: currencyExponent,
                ownerUserId: ownerUserId,
                createdByUserId: createdByUserId,
                myRole: myRole,
                memberId: memberId,
                startDate: startDate,
                endDate: endDate,
                archivedAt: archivedAt,
                serverSyncVersion: serverSyncVersion,
                cachedAt: cachedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalTripsTable, LocalTrip>(table),
                  BaseReferences<_$AppDatabase, $LocalTripsTable, LocalTrip>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTripsTable,
      LocalTrip,
      $$LocalTripsTableFilterComposer,
      $$LocalTripsTableOrderingComposer,
      $$LocalTripsTableAnnotationComposer,
      $$LocalTripsTableCreateCompanionBuilder,
      $$LocalTripsTableUpdateCompanionBuilder,
      (LocalTrip, BaseReferences<_$AppDatabase, $LocalTripsTable, LocalTrip>),
      LocalTrip,
      PrefetchHooks Function()
    >;
typedef $$LocalMembersTableCreateCompanionBuilder =
    LocalMembersCompanion Function({
      required String id,
      required String tripId,
      Value<String?> userId,
      required String displayName,
      Value<String?> emailNormalized,
      required String memberKind,
      required String role,
      required String status,
      Value<String?> joinedAt,
      Value<int> serverVersion,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$LocalMembersTableUpdateCompanionBuilder =
    LocalMembersCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> userId,
      Value<String> displayName,
      Value<String?> emailNormalized,
      Value<String> memberKind,
      Value<String> role,
      Value<String> status,
      Value<String?> joinedAt,
      Value<int> serverVersion,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$LocalMembersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMembersTable> {
  $$LocalMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailNormalized => $composableBuilder(
    column: $table.emailNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberKind => $composableBuilder(
    column: $table.memberKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMembersTable> {
  $$LocalMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailNormalized => $composableBuilder(
    column: $table.emailNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberKind => $composableBuilder(
    column: $table.memberKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMembersTable> {
  $$LocalMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emailNormalized => $composableBuilder(
    column: $table.emailNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memberKind => $composableBuilder(
    column: $table.memberKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMembersTable,
          LocalMember,
          $$LocalMembersTableFilterComposer,
          $$LocalMembersTableOrderingComposer,
          $$LocalMembersTableAnnotationComposer,
          $$LocalMembersTableCreateCompanionBuilder,
          $$LocalMembersTableUpdateCompanionBuilder,
          (
            LocalMember,
            BaseReferences<_$AppDatabase, $LocalMembersTable, LocalMember>,
          ),
          LocalMember,
          PrefetchHooks Function()
        > {
  $$LocalMembersTableTableManager(_$AppDatabase db, $LocalMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> emailNormalized = const Value.absent(),
                Value<String> memberKind = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> joinedAt = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMembersCompanion(
                id: id,
                tripId: tripId,
                userId: userId,
                displayName: displayName,
                emailNormalized: emailNormalized,
                memberKind: memberKind,
                role: role,
                status: status,
                joinedAt: joinedAt,
                serverVersion: serverVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> userId = const Value.absent(),
                required String displayName,
                Value<String?> emailNormalized = const Value.absent(),
                required String memberKind,
                required String role,
                required String status,
                Value<String?> joinedAt = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalMembersCompanion.insert(
                id: id,
                tripId: tripId,
                userId: userId,
                displayName: displayName,
                emailNormalized: emailNormalized,
                memberKind: memberKind,
                role: role,
                status: status,
                joinedAt: joinedAt,
                serverVersion: serverVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalMembersTable, LocalMember>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalMembersTable,
                    LocalMember
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMembersTable,
      LocalMember,
      $$LocalMembersTableFilterComposer,
      $$LocalMembersTableOrderingComposer,
      $$LocalMembersTableAnnotationComposer,
      $$LocalMembersTableCreateCompanionBuilder,
      $$LocalMembersTableUpdateCompanionBuilder,
      (
        LocalMember,
        BaseReferences<_$AppDatabase, $LocalMembersTable, LocalMember>,
      ),
      LocalMember,
      PrefetchHooks Function()
    >;
typedef $$LocalInvitationsTableCreateCompanionBuilder =
    LocalInvitationsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> tripName,
      required String emailNormalized,
      required String role,
      required String status,
      required String expiresAt,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$LocalInvitationsTableUpdateCompanionBuilder =
    LocalInvitationsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> tripName,
      Value<String> emailNormalized,
      Value<String> role,
      Value<String> status,
      Value<String> expiresAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$LocalInvitationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalInvitationsTable> {
  $$LocalInvitationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripName => $composableBuilder(
    column: $table.tripName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailNormalized => $composableBuilder(
    column: $table.emailNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalInvitationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalInvitationsTable> {
  $$LocalInvitationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripName => $composableBuilder(
    column: $table.tripName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailNormalized => $composableBuilder(
    column: $table.emailNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalInvitationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalInvitationsTable> {
  $$LocalInvitationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get tripName =>
      $composableBuilder(column: $table.tripName, builder: (column) => column);

  GeneratedColumn<String> get emailNormalized => $composableBuilder(
    column: $table.emailNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalInvitationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalInvitationsTable,
          LocalInvitation,
          $$LocalInvitationsTableFilterComposer,
          $$LocalInvitationsTableOrderingComposer,
          $$LocalInvitationsTableAnnotationComposer,
          $$LocalInvitationsTableCreateCompanionBuilder,
          $$LocalInvitationsTableUpdateCompanionBuilder,
          (
            LocalInvitation,
            BaseReferences<
              _$AppDatabase,
              $LocalInvitationsTable,
              LocalInvitation
            >,
          ),
          LocalInvitation,
          PrefetchHooks Function()
        > {
  $$LocalInvitationsTableTableManager(
    _$AppDatabase db,
    $LocalInvitationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalInvitationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalInvitationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalInvitationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> tripName = const Value.absent(),
                Value<String> emailNormalized = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> expiresAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalInvitationsCompanion(
                id: id,
                tripId: tripId,
                tripName: tripName,
                emailNormalized: emailNormalized,
                role: role,
                status: status,
                expiresAt: expiresAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> tripName = const Value.absent(),
                required String emailNormalized,
                required String role,
                required String status,
                required String expiresAt,
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalInvitationsCompanion.insert(
                id: id,
                tripId: tripId,
                tripName: tripName,
                emailNormalized: emailNormalized,
                role: role,
                status: status,
                expiresAt: expiresAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalInvitationsTable, LocalInvitation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalInvitationsTable,
                    LocalInvitation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalInvitationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalInvitationsTable,
      LocalInvitation,
      $$LocalInvitationsTableFilterComposer,
      $$LocalInvitationsTableOrderingComposer,
      $$LocalInvitationsTableAnnotationComposer,
      $$LocalInvitationsTableCreateCompanionBuilder,
      $$LocalInvitationsTableUpdateCompanionBuilder,
      (
        LocalInvitation,
        BaseReferences<_$AppDatabase, $LocalInvitationsTable, LocalInvitation>,
      ),
      LocalInvitation,
      PrefetchHooks Function()
    >;
typedef $$LocalExpensesTableCreateCompanionBuilder =
    LocalExpensesCompanion Function({
      required String id,
      required String tripId,
      required String paidByMemberId,
      required String createdByUserId,
      Value<String?> updatedByUserId,
      Value<String?> deletedByUserId,
      required String title,
      required int amountMinor,
      required String currency,
      required String splitType,
      required String category,
      Value<String> description,
      required String expenseDate,
      Value<String> status,
      Value<int> version,
      Value<int?> serverVersion,
      Value<int?> baseVersion,
      Value<bool> hasPendingLocalChange,
      Value<String> syncStatus,
      Value<String?> serverPayload,
      Value<String?> localPatch,
      Value<String?> clientCreatedAt,
      required String createdAt,
      required String updatedAt,
      Value<String?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalExpensesTableUpdateCompanionBuilder =
    LocalExpensesCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> paidByMemberId,
      Value<String> createdByUserId,
      Value<String?> updatedByUserId,
      Value<String?> deletedByUserId,
      Value<String> title,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String> splitType,
      Value<String> category,
      Value<String> description,
      Value<String> expenseDate,
      Value<String> status,
      Value<int> version,
      Value<int?> serverVersion,
      Value<int?> baseVersion,
      Value<bool> hasPendingLocalChange,
      Value<String> syncStatus,
      Value<String?> serverPayload,
      Value<String?> localPatch,
      Value<String?> clientCreatedAt,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> deletedAt,
      Value<int> rowid,
    });

class $$LocalExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByUserId => $composableBuilder(
    column: $table.updatedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedByUserId => $composableBuilder(
    column: $table.deletedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPendingLocalChange => $composableBuilder(
    column: $table.hasPendingLocalChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPatch => $composableBuilder(
    column: $table.localPatch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientCreatedAt => $composableBuilder(
    column: $table.clientCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByUserId => $composableBuilder(
    column: $table.updatedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedByUserId => $composableBuilder(
    column: $table.deletedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPendingLocalChange => $composableBuilder(
    column: $table.hasPendingLocalChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPatch => $composableBuilder(
    column: $table.localPatch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientCreatedAt => $composableBuilder(
    column: $table.clientCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByUserId => $composableBuilder(
    column: $table.updatedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedByUserId => $composableBuilder(
    column: $table.deletedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPendingLocalChange => $composableBuilder(
    column: $table.hasPendingLocalChange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPatch => $composableBuilder(
    column: $table.localPatch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientCreatedAt => $composableBuilder(
    column: $table.clientCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExpensesTable,
          LocalExpense,
          $$LocalExpensesTableFilterComposer,
          $$LocalExpensesTableOrderingComposer,
          $$LocalExpensesTableAnnotationComposer,
          $$LocalExpensesTableCreateCompanionBuilder,
          $$LocalExpensesTableUpdateCompanionBuilder,
          (
            LocalExpense,
            BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
          ),
          LocalExpense,
          PrefetchHooks Function()
        > {
  $$LocalExpensesTableTableManager(_$AppDatabase db, $LocalExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> paidByMemberId = const Value.absent(),
                Value<String> createdByUserId = const Value.absent(),
                Value<String?> updatedByUserId = const Value.absent(),
                Value<String?> deletedByUserId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> splitType = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> expenseDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<bool> hasPendingLocalChange = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> serverPayload = const Value.absent(),
                Value<String?> localPatch = const Value.absent(),
                Value<String?> clientCreatedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion(
                id: id,
                tripId: tripId,
                paidByMemberId: paidByMemberId,
                createdByUserId: createdByUserId,
                updatedByUserId: updatedByUserId,
                deletedByUserId: deletedByUserId,
                title: title,
                amountMinor: amountMinor,
                currency: currency,
                splitType: splitType,
                category: category,
                description: description,
                expenseDate: expenseDate,
                status: status,
                version: version,
                serverVersion: serverVersion,
                baseVersion: baseVersion,
                hasPendingLocalChange: hasPendingLocalChange,
                syncStatus: syncStatus,
                serverPayload: serverPayload,
                localPatch: localPatch,
                clientCreatedAt: clientCreatedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String paidByMemberId,
                required String createdByUserId,
                Value<String?> updatedByUserId = const Value.absent(),
                Value<String?> deletedByUserId = const Value.absent(),
                required String title,
                required int amountMinor,
                required String currency,
                required String splitType,
                required String category,
                Value<String> description = const Value.absent(),
                required String expenseDate,
                Value<String> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<bool> hasPendingLocalChange = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> serverPayload = const Value.absent(),
                Value<String?> localPatch = const Value.absent(),
                Value<String?> clientCreatedAt = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion.insert(
                id: id,
                tripId: tripId,
                paidByMemberId: paidByMemberId,
                createdByUserId: createdByUserId,
                updatedByUserId: updatedByUserId,
                deletedByUserId: deletedByUserId,
                title: title,
                amountMinor: amountMinor,
                currency: currency,
                splitType: splitType,
                category: category,
                description: description,
                expenseDate: expenseDate,
                status: status,
                version: version,
                serverVersion: serverVersion,
                baseVersion: baseVersion,
                hasPendingLocalChange: hasPendingLocalChange,
                syncStatus: syncStatus,
                serverPayload: serverPayload,
                localPatch: localPatch,
                clientCreatedAt: clientCreatedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalExpensesTable, LocalExpense>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalExpensesTable,
                    LocalExpense
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExpensesTable,
      LocalExpense,
      $$LocalExpensesTableFilterComposer,
      $$LocalExpensesTableOrderingComposer,
      $$LocalExpensesTableAnnotationComposer,
      $$LocalExpensesTableCreateCompanionBuilder,
      $$LocalExpensesTableUpdateCompanionBuilder,
      (
        LocalExpense,
        BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
      ),
      LocalExpense,
      PrefetchHooks Function()
    >;
typedef $$LocalExpenseSplitsTableCreateCompanionBuilder =
    LocalExpenseSplitsCompanion Function({
      required String expenseId,
      required String memberId,
      required int amountMinor,
      Value<int> rowid,
    });
typedef $$LocalExpenseSplitsTableUpdateCompanionBuilder =
    LocalExpenseSplitsCompanion Function({
      Value<String> expenseId,
      Value<String> memberId,
      Value<int> amountMinor,
      Value<int> rowid,
    });

class $$LocalExpenseSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExpenseSplitsTable> {
  $$LocalExpenseSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExpenseSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExpenseSplitsTable> {
  $$LocalExpenseSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExpenseSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExpenseSplitsTable> {
  $$LocalExpenseSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );
}

class $$LocalExpenseSplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExpenseSplitsTable,
          LocalExpenseSplit,
          $$LocalExpenseSplitsTableFilterComposer,
          $$LocalExpenseSplitsTableOrderingComposer,
          $$LocalExpenseSplitsTableAnnotationComposer,
          $$LocalExpenseSplitsTableCreateCompanionBuilder,
          $$LocalExpenseSplitsTableUpdateCompanionBuilder,
          (
            LocalExpenseSplit,
            BaseReferences<
              _$AppDatabase,
              $LocalExpenseSplitsTable,
              LocalExpenseSplit
            >,
          ),
          LocalExpenseSplit,
          PrefetchHooks Function()
        > {
  $$LocalExpenseSplitsTableTableManager(
    _$AppDatabase db,
    $LocalExpenseSplitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExpenseSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExpenseSplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExpenseSplitsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> expenseId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpenseSplitsCompanion(
                expenseId: expenseId,
                memberId: memberId,
                amountMinor: amountMinor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String expenseId,
                required String memberId,
                required int amountMinor,
                Value<int> rowid = const Value.absent(),
              }) => LocalExpenseSplitsCompanion.insert(
                expenseId: expenseId,
                memberId: memberId,
                amountMinor: amountMinor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalExpenseSplitsTable, LocalExpenseSplit>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalExpenseSplitsTable,
                    LocalExpenseSplit
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExpenseSplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExpenseSplitsTable,
      LocalExpenseSplit,
      $$LocalExpenseSplitsTableFilterComposer,
      $$LocalExpenseSplitsTableOrderingComposer,
      $$LocalExpenseSplitsTableAnnotationComposer,
      $$LocalExpenseSplitsTableCreateCompanionBuilder,
      $$LocalExpenseSplitsTableUpdateCompanionBuilder,
      (
        LocalExpenseSplit,
        BaseReferences<
          _$AppDatabase,
          $LocalExpenseSplitsTable,
          LocalExpenseSplit
        >,
      ),
      LocalExpenseSplit,
      PrefetchHooks Function()
    >;
typedef $$LocalSettlementsTableCreateCompanionBuilder =
    LocalSettlementsCompanion Function({
      required String id,
      required String tripId,
      required String paidByMemberId,
      required String paidToMemberId,
      required int amountMinor,
      required String paymentDate,
      required String status,
      required String recordedByUserId,
      Value<String?> confirmedByUserId,
      Value<String?> statusChangedByUserId,
      Value<String?> statusChangedAt,
      Value<String?> rejectionReason,
      Value<String> note,
      Value<int> version,
      Value<int?> serverVersion,
      Value<int?> baseVersion,
      Value<bool> hasPendingLocalChange,
      Value<String> syncStatus,
      Value<String?> serverPayload,
      Value<String?> localPatch,
      required String createdAt,
      Value<String?> updatedAt,
      Value<String?> confirmedAt,
      Value<int> rowid,
    });
typedef $$LocalSettlementsTableUpdateCompanionBuilder =
    LocalSettlementsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> paidByMemberId,
      Value<String> paidToMemberId,
      Value<int> amountMinor,
      Value<String> paymentDate,
      Value<String> status,
      Value<String> recordedByUserId,
      Value<String?> confirmedByUserId,
      Value<String?> statusChangedByUserId,
      Value<String?> statusChangedAt,
      Value<String?> rejectionReason,
      Value<String> note,
      Value<int> version,
      Value<int?> serverVersion,
      Value<int?> baseVersion,
      Value<bool> hasPendingLocalChange,
      Value<String> syncStatus,
      Value<String?> serverPayload,
      Value<String?> localPatch,
      Value<String> createdAt,
      Value<String?> updatedAt,
      Value<String?> confirmedAt,
      Value<int> rowid,
    });

class $$LocalSettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettlementsTable> {
  $$LocalSettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidToMemberId => $composableBuilder(
    column: $table.paidToMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedByUserId => $composableBuilder(
    column: $table.recordedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedByUserId => $composableBuilder(
    column: $table.confirmedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusChangedByUserId => $composableBuilder(
    column: $table.statusChangedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusChangedAt => $composableBuilder(
    column: $table.statusChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPendingLocalChange => $composableBuilder(
    column: $table.hasPendingLocalChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPatch => $composableBuilder(
    column: $table.localPatch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettlementsTable> {
  $$LocalSettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidToMemberId => $composableBuilder(
    column: $table.paidToMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedByUserId => $composableBuilder(
    column: $table.recordedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedByUserId => $composableBuilder(
    column: $table.confirmedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusChangedByUserId => $composableBuilder(
    column: $table.statusChangedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusChangedAt => $composableBuilder(
    column: $table.statusChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPendingLocalChange => $composableBuilder(
    column: $table.hasPendingLocalChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPatch => $composableBuilder(
    column: $table.localPatch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettlementsTable> {
  $$LocalSettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paidToMemberId => $composableBuilder(
    column: $table.paidToMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get recordedByUserId => $composableBuilder(
    column: $table.recordedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmedByUserId => $composableBuilder(
    column: $table.confirmedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusChangedByUserId => $composableBuilder(
    column: $table.statusChangedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusChangedAt => $composableBuilder(
    column: $table.statusChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPendingLocalChange => $composableBuilder(
    column: $table.hasPendingLocalChange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPatch => $composableBuilder(
    column: $table.localPatch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );
}

class $$LocalSettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettlementsTable,
          LocalSettlement,
          $$LocalSettlementsTableFilterComposer,
          $$LocalSettlementsTableOrderingComposer,
          $$LocalSettlementsTableAnnotationComposer,
          $$LocalSettlementsTableCreateCompanionBuilder,
          $$LocalSettlementsTableUpdateCompanionBuilder,
          (
            LocalSettlement,
            BaseReferences<
              _$AppDatabase,
              $LocalSettlementsTable,
              LocalSettlement
            >,
          ),
          LocalSettlement,
          PrefetchHooks Function()
        > {
  $$LocalSettlementsTableTableManager(
    _$AppDatabase db,
    $LocalSettlementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> paidByMemberId = const Value.absent(),
                Value<String> paidToMemberId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> paymentDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> recordedByUserId = const Value.absent(),
                Value<String?> confirmedByUserId = const Value.absent(),
                Value<String?> statusChangedByUserId = const Value.absent(),
                Value<String?> statusChangedAt = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<bool> hasPendingLocalChange = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> serverPayload = const Value.absent(),
                Value<String?> localPatch = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<String?> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSettlementsCompanion(
                id: id,
                tripId: tripId,
                paidByMemberId: paidByMemberId,
                paidToMemberId: paidToMemberId,
                amountMinor: amountMinor,
                paymentDate: paymentDate,
                status: status,
                recordedByUserId: recordedByUserId,
                confirmedByUserId: confirmedByUserId,
                statusChangedByUserId: statusChangedByUserId,
                statusChangedAt: statusChangedAt,
                rejectionReason: rejectionReason,
                note: note,
                version: version,
                serverVersion: serverVersion,
                baseVersion: baseVersion,
                hasPendingLocalChange: hasPendingLocalChange,
                syncStatus: syncStatus,
                serverPayload: serverPayload,
                localPatch: localPatch,
                createdAt: createdAt,
                updatedAt: updatedAt,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String paidByMemberId,
                required String paidToMemberId,
                required int amountMinor,
                required String paymentDate,
                required String status,
                required String recordedByUserId,
                Value<String?> confirmedByUserId = const Value.absent(),
                Value<String?> statusChangedByUserId = const Value.absent(),
                Value<String?> statusChangedAt = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<bool> hasPendingLocalChange = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> serverPayload = const Value.absent(),
                Value<String?> localPatch = const Value.absent(),
                required String createdAt,
                Value<String?> updatedAt = const Value.absent(),
                Value<String?> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSettlementsCompanion.insert(
                id: id,
                tripId: tripId,
                paidByMemberId: paidByMemberId,
                paidToMemberId: paidToMemberId,
                amountMinor: amountMinor,
                paymentDate: paymentDate,
                status: status,
                recordedByUserId: recordedByUserId,
                confirmedByUserId: confirmedByUserId,
                statusChangedByUserId: statusChangedByUserId,
                statusChangedAt: statusChangedAt,
                rejectionReason: rejectionReason,
                note: note,
                version: version,
                serverVersion: serverVersion,
                baseVersion: baseVersion,
                hasPendingLocalChange: hasPendingLocalChange,
                syncStatus: syncStatus,
                serverPayload: serverPayload,
                localPatch: localPatch,
                createdAt: createdAt,
                updatedAt: updatedAt,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettlementsTable, LocalSettlement>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSettlementsTable,
                    LocalSettlement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettlementsTable,
      LocalSettlement,
      $$LocalSettlementsTableFilterComposer,
      $$LocalSettlementsTableOrderingComposer,
      $$LocalSettlementsTableAnnotationComposer,
      $$LocalSettlementsTableCreateCompanionBuilder,
      $$LocalSettlementsTableUpdateCompanionBuilder,
      (
        LocalSettlement,
        BaseReferences<_$AppDatabase, $LocalSettlementsTable, LocalSettlement>,
      ),
      LocalSettlement,
      PrefetchHooks Function()
    >;
typedef $$OutboxOperationsTableCreateCompanionBuilder =
    OutboxOperationsCompanion Function({
      required String id,
      required String tripId,
      required String entityType,
      required String entityId,
      required String operationType,
      required String method,
      required String endpoint,
      required String payload,
      required String requestHash,
      Value<int?> baseVersion,
      Value<String> state,
      Value<int> attemptCount,
      Value<String?> nextAttemptAt,
      Value<String?> lockedAt,
      Value<String?> lastError,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$OutboxOperationsTableUpdateCompanionBuilder =
    OutboxOperationsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operationType,
      Value<String> method,
      Value<String> endpoint,
      Value<String> payload,
      Value<String> requestHash,
      Value<int?> baseVersion,
      Value<String> state,
      Value<int> attemptCount,
      Value<String?> nextAttemptAt,
      Value<String?> lockedAt,
      Value<String?> lastError,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$OutboxOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxOperationsTable> {
  $$OutboxOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestHash => $composableBuilder(
    column: $table.requestHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxOperationsTable> {
  $$OutboxOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestHash => $composableBuilder(
    column: $table.requestHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxOperationsTable> {
  $$OutboxOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get requestHash => $composableBuilder(
    column: $table.requestHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lockedAt =>
      $composableBuilder(column: $table.lockedAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OutboxOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxOperationsTable,
          LocalOutboxOperation,
          $$OutboxOperationsTableFilterComposer,
          $$OutboxOperationsTableOrderingComposer,
          $$OutboxOperationsTableAnnotationComposer,
          $$OutboxOperationsTableCreateCompanionBuilder,
          $$OutboxOperationsTableUpdateCompanionBuilder,
          (
            LocalOutboxOperation,
            BaseReferences<
              _$AppDatabase,
              $OutboxOperationsTable,
              LocalOutboxOperation
            >,
          ),
          LocalOutboxOperation,
          PrefetchHooks Function()
        > {
  $$OutboxOperationsTableTableManager(
    _$AppDatabase db,
    $OutboxOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> endpoint = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> requestHash = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> nextAttemptAt = const Value.absent(),
                Value<String?> lockedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxOperationsCompanion(
                id: id,
                tripId: tripId,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                method: method,
                endpoint: endpoint,
                payload: payload,
                requestHash: requestHash,
                baseVersion: baseVersion,
                state: state,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                lockedAt: lockedAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String entityType,
                required String entityId,
                required String operationType,
                required String method,
                required String endpoint,
                required String payload,
                required String requestHash,
                Value<int?> baseVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> nextAttemptAt = const Value.absent(),
                Value<String?> lockedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OutboxOperationsCompanion.insert(
                id: id,
                tripId: tripId,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                method: method,
                endpoint: endpoint,
                payload: payload,
                requestHash: requestHash,
                baseVersion: baseVersion,
                state: state,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                lockedAt: lockedAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxOperationsTable, LocalOutboxOperation>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $OutboxOperationsTable,
                    LocalOutboxOperation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxOperationsTable,
      LocalOutboxOperation,
      $$OutboxOperationsTableFilterComposer,
      $$OutboxOperationsTableOrderingComposer,
      $$OutboxOperationsTableAnnotationComposer,
      $$OutboxOperationsTableCreateCompanionBuilder,
      $$OutboxOperationsTableUpdateCompanionBuilder,
      (
        LocalOutboxOperation,
        BaseReferences<
          _$AppDatabase,
          $OutboxOperationsTable,
          LocalOutboxOperation
        >,
      ),
      LocalOutboxOperation,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String tripId,
      Value<int> lastSequence,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> tripId,
      Value<int> lastSequence,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursor,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tripId = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                tripId: tripId,
                lastSequence: lastSequence,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tripId,
                Value<int> lastSequence = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                tripId: tripId,
                lastSequence: lastSequence,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncCursorsTable, SyncCursor>(table),
                  BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursor,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursor,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
      ),
      SyncCursor,
      PrefetchHooks Function()
    >;
typedef $$UserSyncCursorsTableCreateCompanionBuilder =
    UserSyncCursorsCompanion Function({
      required String userId,
      Value<int> lastSequence,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$UserSyncCursorsTableUpdateCompanionBuilder =
    UserSyncCursorsCompanion Function({
      Value<String> userId,
      Value<int> lastSequence,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$UserSyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSyncCursorsTable> {
  $$UserSyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSyncCursorsTable> {
  $$UserSyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSyncCursorsTable> {
  $$UserSyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get lastSequence => $composableBuilder(
    column: $table.lastSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSyncCursorsTable,
          UserSyncCursor,
          $$UserSyncCursorsTableFilterComposer,
          $$UserSyncCursorsTableOrderingComposer,
          $$UserSyncCursorsTableAnnotationComposer,
          $$UserSyncCursorsTableCreateCompanionBuilder,
          $$UserSyncCursorsTableUpdateCompanionBuilder,
          (
            UserSyncCursor,
            BaseReferences<
              _$AppDatabase,
              $UserSyncCursorsTable,
              UserSyncCursor
            >,
          ),
          UserSyncCursor,
          PrefetchHooks Function()
        > {
  $$UserSyncCursorsTableTableManager(
    _$AppDatabase db,
    $UserSyncCursorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> lastSequence = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSyncCursorsCompanion(
                userId: userId,
                lastSequence: lastSequence,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<int> lastSequence = const Value.absent(),
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserSyncCursorsCompanion.insert(
                userId: userId,
                lastSequence: lastSequence,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserSyncCursorsTable, UserSyncCursor>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserSyncCursorsTable,
                    UserSyncCursor
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSyncCursorsTable,
      UserSyncCursor,
      $$UserSyncCursorsTableFilterComposer,
      $$UserSyncCursorsTableOrderingComposer,
      $$UserSyncCursorsTableAnnotationComposer,
      $$UserSyncCursorsTableCreateCompanionBuilder,
      $$UserSyncCursorsTableUpdateCompanionBuilder,
      (
        UserSyncCursor,
        BaseReferences<_$AppDatabase, $UserSyncCursorsTable, UserSyncCursor>,
      ),
      UserSyncCursor,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      required String id,
      required String tripId,
      required String entityType,
      required String entityId,
      required String localPayload,
      required String serverPayload,
      Value<int?> baseVersion,
      Value<int?> serverVersion,
      required String createdAt,
      Value<String?> resolvedAt,
      Value<String?> resolution,
      Value<int> rowid,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> localPayload,
      Value<String> serverPayload,
      Value<int?> baseVersion,
      Value<int?> serverVersion,
      Value<String> createdAt,
      Value<String?> resolvedAt,
      Value<String?> resolution,
      Value<int> rowid,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPayload => $composableBuilder(
    column: $table.localPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPayload => $composableBuilder(
    column: $table.localPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get localPayload => $composableBuilder(
    column: $table.localPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => column,
  );
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncConflictsTable,
          SyncConflict,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflict,
            BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>,
          ),
          SyncConflict,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(_$AppDatabase db, $SyncConflictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> localPayload = const Value.absent(),
                Value<String> serverPayload = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String?> resolvedAt = const Value.absent(),
                Value<String?> resolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                tripId: tripId,
                entityType: entityType,
                entityId: entityId,
                localPayload: localPayload,
                serverPayload: serverPayload,
                baseVersion: baseVersion,
                serverVersion: serverVersion,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                resolution: resolution,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String entityType,
                required String entityId,
                required String localPayload,
                required String serverPayload,
                Value<int?> baseVersion = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                required String createdAt,
                Value<String?> resolvedAt = const Value.absent(),
                Value<String?> resolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                tripId: tripId,
                entityType: entityType,
                entityId: entityId,
                localPayload: localPayload,
                serverPayload: serverPayload,
                baseVersion: baseVersion,
                serverVersion: serverVersion,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                resolution: resolution,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncConflictsTable, SyncConflict>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncConflictsTable,
                    SyncConflict
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncConflictsTable,
      SyncConflict,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflict,
        BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>,
      ),
      SyncConflict,
      PrefetchHooks Function()
    >;
typedef $$DeviceStateTableCreateCompanionBuilder =
    DeviceStateCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$DeviceStateTableUpdateCompanionBuilder =
    DeviceStateCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$DeviceStateTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceStateTable> {
  $$DeviceStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceStateTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceStateTable> {
  $$DeviceStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceStateTable> {
  $$DeviceStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DeviceStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceStateTable,
          DeviceStateEntry,
          $$DeviceStateTableFilterComposer,
          $$DeviceStateTableOrderingComposer,
          $$DeviceStateTableAnnotationComposer,
          $$DeviceStateTableCreateCompanionBuilder,
          $$DeviceStateTableUpdateCompanionBuilder,
          (
            DeviceStateEntry,
            BaseReferences<_$AppDatabase, $DeviceStateTable, DeviceStateEntry>,
          ),
          DeviceStateEntry,
          PrefetchHooks Function()
        > {
  $$DeviceStateTableTableManager(_$AppDatabase db, $DeviceStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => DeviceStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => DeviceStateCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceStateTable, DeviceStateEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DeviceStateTable,
                    DeviceStateEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceStateTable,
      DeviceStateEntry,
      $$DeviceStateTableFilterComposer,
      $$DeviceStateTableOrderingComposer,
      $$DeviceStateTableAnnotationComposer,
      $$DeviceStateTableCreateCompanionBuilder,
      $$DeviceStateTableUpdateCompanionBuilder,
      (
        DeviceStateEntry,
        BaseReferences<_$AppDatabase, $DeviceStateTable, DeviceStateEntry>,
      ),
      DeviceStateEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalUserProfileTableTableManager get localUserProfile =>
      $$LocalUserProfileTableTableManager(_db, _db.localUserProfile);
  $$LocalTripsTableTableManager get localTrips =>
      $$LocalTripsTableTableManager(_db, _db.localTrips);
  $$LocalMembersTableTableManager get localMembers =>
      $$LocalMembersTableTableManager(_db, _db.localMembers);
  $$LocalInvitationsTableTableManager get localInvitations =>
      $$LocalInvitationsTableTableManager(_db, _db.localInvitations);
  $$LocalExpensesTableTableManager get localExpenses =>
      $$LocalExpensesTableTableManager(_db, _db.localExpenses);
  $$LocalExpenseSplitsTableTableManager get localExpenseSplits =>
      $$LocalExpenseSplitsTableTableManager(_db, _db.localExpenseSplits);
  $$LocalSettlementsTableTableManager get localSettlements =>
      $$LocalSettlementsTableTableManager(_db, _db.localSettlements);
  $$OutboxOperationsTableTableManager get outboxOperations =>
      $$OutboxOperationsTableTableManager(_db, _db.outboxOperations);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
  $$UserSyncCursorsTableTableManager get userSyncCursors =>
      $$UserSyncCursorsTableTableManager(_db, _db.userSyncCursors);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
  $$DeviceStateTableTableManager get deviceState =>
      $$DeviceStateTableTableManager(_db, _db.deviceState);
}
