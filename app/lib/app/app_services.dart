import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/session_manager.dart';
import '../core/database/database_manager.dart';
import '../core/network/api_client.dart';
import '../core/sync/sync_manager.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/expenses/data/expense_repository.dart';
import '../features/invitations/data/invitation_repository.dart';
import '../features/members/data/member_repository.dart';
import '../features/settlements/data/settlement_repository.dart';
import '../features/trips/data/trip_repository.dart';

/// Process-wide container for long-lived application services. Repositories
/// resolve the current user's database through [DatabaseManager] so they stay
/// valid across sign-in and sign-out.
class AppServices {
  AppServices({
    required this.session,
    required this.databases,
    required this.api,
    required this.sync,
  })  : auth = AuthRepository(
          api: api,
          session: session,
          databases: databases,
        ),
        trips = TripRepository(api: api, databases: databases),
        members = MemberRepository(api: api, databases: databases),
        invitations = InvitationRepository(api: api, databases: databases),
        expenses = ExpenseRepository(
          api: api,
          session: session,
          databases: databases,
        ),
        settlements = SettlementRepository(
          api: api,
          session: session,
          databases: databases,
        );

  final SessionManager session;
  final DatabaseManager databases;
  final ApiClient api;
  final SyncManager sync;
  final AuthRepository auth;
  final TripRepository trips;
  final MemberRepository members;
  final InvitationRepository invitations;
  final ExpenseRepository expenses;
  final SettlementRepository settlements;

  /// Called after login/registration once the user's database is open.
  void startSync() => sync.start();
}

final appServicesProvider = Provider<AppServices>(
  (ref) => throw UnimplementedError('AppServices must be overridden at startup'),
);

final sessionProvider = Provider<SessionManager>(
  (ref) => ref.watch(appServicesProvider).session,
);

final syncManagerProvider = Provider<SyncManager>(
  (ref) => ref.watch(appServicesProvider).sync,
);
