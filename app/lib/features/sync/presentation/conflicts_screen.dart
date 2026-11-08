import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';

class ConflictsScreen extends ConsumerWidget {
  const ConflictsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sync conflicts')),
      body: StreamBuilder<List<SyncConflict>>(
        stream: services.databases.database.watchConflicts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final conflicts = snapshot.data!;
          if (conflicts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No open conflicts. Local changes that could not be applied are listed here.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: conflicts.length,
            itemBuilder: (context, index) {
              final conflict = conflicts[index];
              return Card(
                child: ExpansionTile(
                  title: Text('${conflict.entityType} • ${conflict.entityId}'),
                  subtitle: Text(
                    'Local v${conflict.baseVersion ?? '?'} vs server v${conflict.serverVersion ?? '?'}',
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    _Payload(
                      label: 'Your change',
                      json: conflict.localPayload,
                    ),
                    const SizedBox(height: 8),
                    _Payload(
                      label: 'Server version',
                      json: conflict.serverPayload,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await services.databases.database.resolveConflict(
                              conflict.id,
                              resolution: 'dismissed',
                            );
                          },
                          child: const Text('Dismiss'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () async {
                            await services.databases.database.resolveConflict(
                              conflict.id,
                              resolution: 'server',
                            );
                            await services.sync.syncNow();
                          },
                          child: const Text('Keep server version'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Payload extends StatelessWidget {
  const _Payload({required this.label, required this.json});

  final String label;
  final String json;

  @override
  Widget build(BuildContext context) {
    final pretty = _pretty(json);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 180),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: SelectableText(
              pretty,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
        ),
      ],
    );
  }

  String _pretty(String raw) {
    try {
      return const JsonEncoder.withIndent('  ').convert(jsonDecode(raw));
    } catch (_) {
      return raw;
    }
  }
}
