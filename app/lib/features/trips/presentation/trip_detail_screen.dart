import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/feedback.dart';
import '../../balances/presentation/balances_tab.dart';
import '../../expenses/presentation/expenses_tab.dart';
import '../../members/presentation/members_tab.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return DefaultTabController(
      length: 3,
      child: StreamBuilder<List<LocalTrip>>(
        stream: services.trips.watchTrips(),
        builder: (context, snapshot) {
          final trips = snapshot.data ?? const <LocalTrip>[];
          LocalTrip? trip;
          for (final item in trips) {
            if (item.id == tripId) {
              trip = item;
              break;
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting && trip == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (trip == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Trip')),
              body: const Center(
                child: Text('This trip is no longer available on this device.'),
              ),
            );
          }
          return _TripScaffold(trip: trip);
        },
      ),
    );
  }
}

class _TripScaffold extends ConsumerWidget {
  const _TripScaffold({required this.trip});

  final LocalTrip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trip.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            if ((trip.destination ?? '').isNotEmpty)
              Text(
                trip.destination!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sync now',
            onPressed: services.sync.isSyncing ? null : services.sync.syncNow,
            icon: Icon(services.sync.isSyncing ? Icons.sync : Icons.cloud_sync_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (action) => _onAction(context, ref, action),
            itemBuilder: (context) => [
              if (trip.isAdmin)
                const PopupMenuItem(value: 'edit', child: Text('Edit trip')),
              PopupMenuItem(
                value: trip.archivedAt == null ? 'archive' : 'unarchive',
                child: Text(
                  trip.archivedAt == null ? 'Archive trip' : 'Restore trip',
                ),
              ),
              if (trip.isAdmin && trip.myRole == 'owner')
                const PopupMenuItem(
                  value: 'transfer',
                  child: Text('Transfer ownership'),
                ),
              if (trip.myRole != 'owner')
                const PopupMenuItem(value: 'leave', child: Text('Leave trip')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (trip.archivedAt != null)
            MaterialBanner(
              content: const Text('This trip is archived. Changes are locked.'),
              leading: const Icon(Icons.archive_outlined),
              actions: [
                TextButton(
                  onPressed: () => _onAction(context, ref, 'unarchive'),
                  child: const Text('Restore'),
                ),
              ],
            ),
          const TabBar(
            tabs: [
              Tab(text: 'Expenses'),
              Tab(text: 'Balances'),
              Tab(text: 'Members'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ExpensesTab(trip: trip),
                BalancesTab(trip: trip),
                MembersTab(trip: trip),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final services = ref.read(appServicesProvider);
    try {
      switch (action) {
        case 'edit':
          await context.push('/trips/${trip.id}/edit');
        case 'archive':
          if (await confirm(
            context,
            title: 'Archive trip?',
            message: 'New expenses, settlements and member changes are locked.',
            confirmLabel: 'Archive',
          )) {
            await services.trips.archive(trip.id);
          }
        case 'unarchive':
          await services.trips.archive(trip.id, archived: false);
        case 'transfer':
          final memberId = await _pickOwner(context, ref);
          if (memberId != null) {
            await services.trips.transferOwnership(trip.id, memberId);
            if (context.mounted) showMessage(context, 'Ownership transferred.');
          }
        case 'leave':
          if (await confirm(
            context,
            title: 'Leave trip?',
            message:
                'Outstanding balances remain in the trip history for the other members.',
            confirmLabel: 'Leave',
            destructive: true,
          )) {
            await services.trips.leave(trip.id);
            if (context.mounted) context.go('/trips');
          }
      }
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<String?> _pickOwner(BuildContext context, WidgetRef ref) async {
    final services = ref.read(appServicesProvider);
    final members = await services.members.members(trip.id);
    final userId = services.session.user?.id;
    final candidates = members
        .where((member) =>
            member.status == 'active' &&
            member.userId != null &&
            member.userId != userId)
        .toList();
    if (candidates.isEmpty) {
      if (context.mounted) {
        showMessage(context, 'There is no other active account member.');
      }
      return null;
    }
    if (!context.mounted) return null;
    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Transfer ownership'),
        children: [
          for (final member in candidates)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, member.id),
              child: Text(member.displayName),
            ),
        ],
      ),
    );
  }
}
