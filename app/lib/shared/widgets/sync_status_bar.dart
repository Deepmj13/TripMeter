import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_services.dart';
import '../../core/sync/sync_manager.dart';

class SyncStatusBar extends ConsumerWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return ListenableBuilder(
      listenable: services.sync,
      builder: (context, _) {
        final sync = services.sync;
        return StreamBuilder<int>(
          stream: services.databases.database.watchPendingOperationCount(),
          builder: (context, snapshot) {
            final pending = snapshot.data ?? 0;
            final theme = Theme.of(context);
            final (icon, text, color) = _state(
              context,
              sync,
              pending,
              services.session.isOffline,
            );
            if (icon == null) return const SizedBox.shrink();
            return Material(
              color: color.withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        style: theme.textTheme.bodySmall?.copyWith(color: color),
                      ),
                    ),
                    TextButton(
                      onPressed: sync.isSyncing ? null : sync.syncNow,
                      child: const Text('Sync'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  (IconData?, String, Color) _state(
    BuildContext context,
    SyncManager sync,
    int pending,
    bool offline,
  ) {
    final scheme = Theme.of(context).colorScheme;
    if (sync.isSyncing) {
      return (Icons.sync, 'Syncing changes...', scheme.primary);
    }
    if (offline) {
      return (
        Icons.cloud_off,
        pending == 0
            ? 'Offline. Cached data is available.'
            : 'Offline. $pending change${pending == 1 ? '' : 's'} queued.',
        scheme.error,
      );
    }
    if (pending > 0) {
      return (
        Icons.cloud_upload,
        '$pending change${pending == 1 ? '' : 's'} waiting to sync.',
        scheme.tertiary,
      );
    }
    if (sync.lastError != null) {
      return (Icons.error_outline, sync.lastError!, scheme.error);
    }
    return (null, '', scheme.primary);
  }
}
