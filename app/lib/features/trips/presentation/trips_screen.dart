import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My trips'),
        actions: [
          IconButton(
            tooltip: 'Invitations',
            onPressed: () => context.push('/invitations'),
            icon: const Icon(Icons.mail_outline),
          ),
          IconButton(
            tooltip: 'Sync conflicts',
            onPressed: () => context.push('/conflicts'),
            icon: const Icon(Icons.sync_problem),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<LocalTrip>>(
              stream: services.trips.watchTrips(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = snapshot.data!;
                if (trips.isEmpty) {
                  return _EmptyTrips(
                    onCreate: () => context.push('/trips/new'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: services.sync.syncNow,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return _TripCard(
                        trip: trip,
                        onTap: () => context.push('/trips/${trip.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/trips/new'),
        icon: const Icon(Icons.add),
        label: const Text('New trip'),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip, required this.onTap});

  final LocalTrip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = [
      if (trip.startDate != null) trip.startDate!,
      if (trip.endDate != null) trip.endDate!,
    ].join(' to ');
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                child: Text(
                  trip.name.isEmpty ? '?' : trip.name.characters.first.toUpperCase(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (trip.archivedAt != null)
                          const Chip(
                            label: Text('Archived'),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    if ((trip.destination ?? '').isNotEmpty)
                      Text(
                        trip.destination!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    if (dates.isNotEmpty)
                      Text(dates, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        _Pill(label: trip.currency),
                        _Pill(label: trip.myRole),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _EmptyTrips extends StatelessWidget {
  const _EmptyTrips({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.luggage_outlined, size: 72),
            const SizedBox(height: 16),
            Text(
              'No trips yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a trip, add your travel companions and start recording shared expenses.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create a trip'),
            ),
          ],
        ),
      ),
    );
  }
}
