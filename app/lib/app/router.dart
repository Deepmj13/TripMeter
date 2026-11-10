import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_manager.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/password_reset_screens.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/expenses/presentation/expense_form_screen.dart';
import '../features/invitations/presentation/invitations_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/sessions_screen.dart';
import '../features/sync/presentation/conflicts_screen.dart';
import '../features/trips/presentation/trip_detail_screen.dart';
import '../features/trips/presentation/trip_form_screen.dart';
import '../features/trips/presentation/trips_screen.dart';

const _loginRoutes = {
  '/login',
  '/register',
  '/forgot-password',
  '/reset-password',
};

/// Application routes. The session manager is the redirect source of truth so
/// signing in, signing out and token revocation all navigate consistently.
GoRouter buildRouter(SessionManager session) {
  return GoRouter(
    initialLocation: '/trips',
    refreshListenable: session,
    redirect: (context, state) {
      if (session.status == SessionStatus.restoring) return null;
      final location = state.matchedLocation;
      final authenticated = session.isAuthenticated;
      final onLoginRoute = _loginRoutes.contains(location);

      if (!authenticated && !onLoginRoute) return '/login';
      if (authenticated && location == '/login') return '/trips';
      if (authenticated && location == '/register') return '/trips';
      if (authenticated && location == '/forgot-password') return '/trips';
      if (authenticated && location == '/reset-password') return '/trips';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/trips',
        builder: (context, state) => const TripsScreen(),
      ),
      GoRoute(
        path: '/trips/new',
        builder: (context, state) => const TripFormScreen(),
      ),
      GoRoute(
        path: '/trips/:tripId',
        builder: (context, state) => TripDetailScreen(
          tripId: state.pathParameters['tripId']!,
        ),
      ),
      GoRoute(
        path: '/trips/:tripId/edit',
        builder: (context, state) => TripFormScreen(
          tripId: state.pathParameters['tripId'],
        ),
      ),
      GoRoute(
        path: '/trips/:tripId/expenses/new',
        builder: (context, state) => ExpenseFormScreen(
          tripId: state.pathParameters['tripId']!,
        ),
      ),
      GoRoute(
        path: '/trips/:tripId/expenses/:expenseId',
        builder: (context, state) => ExpenseFormScreen(
          tripId: state.pathParameters['tripId']!,
          expenseId: state.pathParameters['expenseId'],
        ),
      ),
      GoRoute(
        path: '/invitations',
        builder: (context, state) => const InvitationsScreen(),
      ),
      GoRoute(
        path: '/conflicts',
        builder: (context, state) => const ConflictsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/sessions',
        builder: (context, state) => const SessionsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error?.toString() ?? 'The page does not exist.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/trips'),
              child: const Text('Back to trips'),
            ),
          ],
        ),
      ),
    ),
  );
}
