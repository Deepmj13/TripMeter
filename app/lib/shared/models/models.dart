int asMinor(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.parse(value.toString());
}

String? asString(dynamic value) => value?.toString();

DateTime? asDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

String? asIso(dynamic value) => asDate(value)?.toUtc().toIso8601String();

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
    this.notificationPreferences = const {},
  });

  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final Map<String, bool> notificationPreferences;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'].toString(),
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        emailVerified: json['emailVerified'] == true,
        notificationPreferences: (json['notificationPreferences'] as Map?)
                ?.map((key, value) => MapEntry(key.toString(), value == true)) ??
            const {},
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'emailVerified': emailVerified,
        'notificationPreferences': notificationPreferences,
      };
}

class Trip {
  const Trip({
    required this.id,
    required this.name,
    required this.currency,
    required this.currencyExponent,
    required this.ownerUserId,
    required this.createdByUserId,
    this.destination,
    this.description,
    this.startDate,
    this.endDate,
    this.archivedAt,
    this.myRole = 'member',
    this.memberId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? destination;
  final String? description;
  final String currency;
  final int currencyExponent;
  final String? startDate;
  final String? endDate;
  final String? archivedAt;
  final String ownerUserId;
  final String createdByUserId;
  final String myRole;
  final String? memberId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isArchived => archivedAt != null;
  bool get canWrite => !isArchived;
  bool get isAdmin => myRole == 'owner' || myRole == 'admin';

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'].toString(),
        name: json['name']?.toString() ?? '',
        destination: asString(json['destination']),
        description: asString(json['description']),
        currency: json['currency']?.toString() ?? 'INR',
        currencyExponent: asMinor(json['currencyExponent'] ?? 2),
        startDate: asString(json['startDate']),
        endDate: asString(json['endDate']),
        archivedAt: asString(json['archivedAt']),
        ownerUserId: json['ownerUserId']?.toString() ?? '',
        createdByUserId: json['createdByUserId']?.toString() ?? '',
        myRole: json['myRole']?.toString() ?? 'member',
        memberId: asString(json['memberId']),
        createdAt: asDate(json['createdAt']),
        updatedAt: asDate(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'destination': destination,
        'description': description,
        'currency': currency,
        'currencyExponent': currencyExponent,
        'startDate': startDate,
        'endDate': endDate,
        'archivedAt': archivedAt,
        'ownerUserId': ownerUserId,
        'createdByUserId': createdByUserId,
        'myRole': myRole,
        'memberId': memberId,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}

class TripMember {
  const TripMember({
    required this.id,
    required this.tripId,
    required this.displayName,
    required this.memberKind,
    required this.role,
    required this.status,
    this.userId,
    this.email,
    this.joinedAt,
    this.serverVersion = 0,
    this.updatedAt,
  });

  final String id;
  final String tripId;
  final String? userId;
  final String displayName;
  final String? email;
  final String memberKind;
  final String role;
  final String status;
  final String? joinedAt;
  final int serverVersion;
  final DateTime? updatedAt;

  bool get isActive => status == 'active';
  bool get isGuest => memberKind == 'guest';

  factory TripMember.fromJson(Map<String, dynamic> json) => TripMember(
        id: json['id'].toString(),
        tripId: json['tripId']?.toString() ?? '',
        userId: asString(json['userId']),
        displayName: json['displayName']?.toString() ?? '',
        email: asString(json['email']),
        memberKind: json['memberKind']?.toString() ?? 'account',
        role: json['role']?.toString() ?? 'member',
        status: json['status']?.toString() ?? 'active',
        joinedAt: asString(json['joinedAt']),
        serverVersion: asMinor(json['version'] ?? 0),
        updatedAt: asDate(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'userId': userId,
        'displayName': displayName,
        'email': email,
        'memberKind': memberKind,
        'role': role,
        'status': status,
        'joinedAt': joinedAt,
        'version': serverVersion,
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}

class ExpenseSplit {
  const ExpenseSplit({required this.memberId, required this.amountMinor});

  final String memberId;
  final int amountMinor;

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) => ExpenseSplit(
        memberId: json['memberId'].toString(),
        amountMinor: asMinor(json['amountMinor']),
      );

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'amountMinor': amountMinor,
      };
}

class Expense {
  const Expense({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amountMinor,
    required this.currency,
    required this.paidByMemberId,
    required this.createdByUserId,
    required this.splitType,
    required this.splits,
    required this.expenseDate,
    required this.category,
    required this.status,
    required this.version,
    this.updatedByUserId,
    this.deletedByUserId,
    this.description = '',
    this.clientCreatedAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.hasPendingLocalChange = false,
    this.syncStatus = 'synced',
  });

  final String id;
  final String tripId;
  final String title;
  final int amountMinor;
  final String currency;
  final String paidByMemberId;
  final String createdByUserId;
  final String? updatedByUserId;
  final String? deletedByUserId;
  final String splitType;
  final List<ExpenseSplit> splits;
  final String category;
  final String expenseDate;
  final String description;
  final String status;
  final int version;
  final String? clientCreatedAt;
  final String? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool hasPendingLocalChange;
  final String syncStatus;

  bool get isDeleted => status == 'deleted';

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'].toString(),
        tripId: json['tripId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        amountMinor: asMinor(json['amountMinor'] ?? 0),
        currency: json['currency']?.toString() ?? 'INR',
        paidByMemberId: json['paidByMemberId']?.toString() ?? '',
        createdByUserId: json['createdByUserId']?.toString() ?? '',
        updatedByUserId: asString(json['updatedByUserId']),
        deletedByUserId: asString(json['deletedByUserId']),
        splitType: json['splitType']?.toString() ?? 'equal',
        splits: (json['splits'] as List? ?? const [])
            .whereType<Map>()
            .map((split) => ExpenseSplit.fromJson(split.cast<String, dynamic>()))
            .toList(),
        category: json['category']?.toString() ?? 'other',
        expenseDate: json['expenseDate']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        status: json['status']?.toString() ?? 'active',
        version: asMinor(json['version'] ?? 1),
        clientCreatedAt: asString(json['clientCreatedAt']),
        deletedAt: asString(json['deletedAt']),
        createdAt: asDate(json['createdAt']),
        updatedAt: asDate(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'title': title,
        'amountMinor': amountMinor,
        'currency': currency,
        'paidByMemberId': paidByMemberId,
        'createdByUserId': createdByUserId,
        'updatedByUserId': updatedByUserId,
        'deletedByUserId': deletedByUserId,
        'splitType': splitType,
        'splits': splits.map((split) => split.toJson()).toList(),
        'category': category,
        'expenseDate': expenseDate,
        'description': description,
        'status': status,
        'version': version,
        'clientCreatedAt': clientCreatedAt,
        'deletedAt': deletedAt,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}

class Settlement {
  const Settlement({
    required this.id,
    required this.tripId,
    required this.paidByMemberId,
    required this.paidToMemberId,
    required this.amountMinor,
    required this.paymentDate,
    required this.status,
    required this.recordedByUserId,
    required this.version,
    this.confirmedByUserId,
    this.statusChangedByUserId,
    this.statusChangedAt,
    this.rejectionReason,
    this.note = '',
    this.confirmedAt,
    this.createdAt,
    this.updatedAt,
    this.hasPendingLocalChange = false,
    this.syncStatus = 'synced',
  });

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
  final String? confirmedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool hasPendingLocalChange;
  final String syncStatus;

  bool get isConfirmed => status == 'confirmed';
  bool get isPending => status == 'pending';

  factory Settlement.fromJson(Map<String, dynamic> json) => Settlement(
        id: json['id'].toString(),
        tripId: json['tripId']?.toString() ?? '',
        paidByMemberId: json['paidByMemberId']?.toString() ?? '',
        paidToMemberId: json['paidToMemberId']?.toString() ?? '',
        amountMinor: asMinor(json['amountMinor'] ?? 0),
        paymentDate: json['paymentDate']?.toString() ?? '',
        status: json['status']?.toString() ?? 'pending',
        recordedByUserId: json['recordedByUserId']?.toString() ?? '',
        confirmedByUserId: asString(json['confirmedByUserId']),
        statusChangedByUserId: asString(json['statusChangedByUserId']),
        statusChangedAt: asString(json['statusChangedAt']),
        rejectionReason: asString(json['rejectionReason']),
        note: json['note']?.toString() ?? '',
        version: asMinor(json['version'] ?? 1),
        confirmedAt: asString(json['confirmedAt']),
        createdAt: asDate(json['createdAt']),
        updatedAt: asDate(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'paidByMemberId': paidByMemberId,
        'paidToMemberId': paidToMemberId,
        'amountMinor': amountMinor,
        'paymentDate': paymentDate,
        'status': status,
        'recordedByUserId': recordedByUserId,
        'confirmedByUserId': confirmedByUserId,
        'statusChangedByUserId': statusChangedByUserId,
        'statusChangedAt': statusChangedAt,
        'rejectionReason': rejectionReason,
        'note': note,
        'version': version,
        'confirmedAt': confirmedAt,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}

class Invitation {
  const Invitation({
    required this.id,
    required this.tripId,
    required this.email,
    required this.status,
    required this.role,
    required this.expiresAt,
    this.tripName,
    this.memberId,
    this.acceptedAt,
    this.respondedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String tripId;
  final String? tripName;
  final String? memberId;
  final String email;
  final String status;
  final String role;
  final String expiresAt;
  final String? acceptedAt;
  final String? respondedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isPending => status == 'pending';
  bool get isExpired => DateTime.tryParse(expiresAt)?.isBefore(DateTime.now()) ?? false;

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        id: json['id'].toString(),
        tripId: json['tripId']?.toString() ?? '',
        tripName: asString(json['tripName']),
        memberId: asString(json['memberId']),
        email: json['email']?.toString() ?? '',
        status: json['status']?.toString() ?? 'pending',
        role: json['role']?.toString() ?? 'member',
        expiresAt: json['expiresAt']?.toString() ?? '',
        acceptedAt: asString(json['acceptedAt']),
        respondedAt: asString(json['respondedAt']),
        createdAt: asDate(json['createdAt']),
        updatedAt: asDate(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'tripName': tripName,
        'memberId': memberId,
        'email': email,
        'status': status,
        'role': role,
        'expiresAt': expiresAt,
        'acceptedAt': acceptedAt,
        'respondedAt': respondedAt,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}

class BalanceEntry {
  const BalanceEntry({
    required this.memberId,
    required this.displayName,
    required this.netMinor,
  });

  final String memberId;
  final String displayName;
  final int netMinor;
}

class SettlementSuggestion {
  const SettlementSuggestion({
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountMinor,
  });

  final String fromMemberId;
  final String toMemberId;
  final int amountMinor;
}

class PendingReservation {
  const PendingReservation({
    required this.settlementId,
    required this.paidByMemberId,
    required this.paidToMemberId,
    required this.amountMinor,
    required this.appliedMinor,
  });

  final String? settlementId;
  final String paidByMemberId;
  final String paidToMemberId;
  final int amountMinor;
  final int appliedMinor;
}

class TripSnapshot {
  const TripSnapshot({
    required this.trip,
    required this.members,
    required this.expenses,
    required this.settlements,
    required this.sequence,
  });

  final Trip trip;
  final List<TripMember> members;
  final List<Expense> expenses;
  final List<Settlement> settlements;
  final int sequence;

  factory TripSnapshot.fromJson(Map<String, dynamic> json) => TripSnapshot(
        trip: Trip.fromJson((json['trip'] as Map).cast<String, dynamic>()),
        members: (json['members'] as List? ?? const [])
            .whereType<Map>()
            .map((item) => TripMember.fromJson(item.cast<String, dynamic>()))
            .toList(),
        expenses: (json['expenses'] as List? ?? const [])
            .whereType<Map>()
            .map((item) => Expense.fromJson(item.cast<String, dynamic>()))
            .toList(),
        settlements: (json['settlements'] as List? ?? const [])
            .whereType<Map>()
            .map((item) => Settlement.fromJson(item.cast<String, dynamic>()))
            .toList(),
        sequence: asMinor(json['sequence'] ?? 0),
      );
}

class UserSnapshot {
  const UserSnapshot({
    required this.profile,
    required this.trips,
    required this.invitations,
    required this.sequence,
  });

  final AppUser profile;
  final List<Trip> trips;
  final List<Invitation> invitations;
  final int sequence;

  factory UserSnapshot.fromJson(Map<String, dynamic> json) => UserSnapshot(
        profile: AppUser.fromJson((json['profile'] as Map).cast<String, dynamic>()),
        trips: (json['trips'] as List? ?? const [])
            .whereType<Map>()
            .map((item) => Trip.fromJson(item.cast<String, dynamic>()))
            .toList(),
        invitations: (json['invitations'] as List? ?? const [])
            .whereType<Map>()
            .map((item) => Invitation.fromJson(item.cast<String, dynamic>()))
            .toList(),
        sequence: asMinor(json['sequence'] ?? 0),
      );
}
