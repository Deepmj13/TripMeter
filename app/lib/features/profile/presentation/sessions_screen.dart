import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_services.dart';
import '../../../shared/widgets/feedback.dart';
import '../../auth/data/auth_repository.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  List<AuthSession>? _sessions;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final sessions = await ref.read(appServicesProvider).auth.sessions();
      if (mounted) setState(() => _sessions = sessions);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  Future<void> _revoke(AuthSession session) async {
    final services = ref.read(appServicesProvider);
    final isCurrent = session.sessionId == services.session.currentFamilyId;
    final confirmed = await confirm(
      context,
      title: isCurrent ? 'Sign out this device?' : 'Revoke session?',
      message: isCurrent
          ? 'You will be signed out on this device.'
          : 'That device will need to sign in again.',
      confirmLabel: isCurrent ? 'Sign out' : 'Revoke',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    try {
      if (isCurrent) {
        await services.auth.logout();
        if (mounted) context.go('/login');
        return;
      }
      await services.auth.revokeSession(session.sessionId);
      if (mounted) showMessage(context, 'Session revoked.');
      await _load();
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFamilyId =
        ref.watch(appServicesProvider).session.currentFamilyId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signed-in devices'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _busy ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _load,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }
          final sessions = _sessions;
          if (sessions == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (sessions.isEmpty) {
            return const Center(child: Text('No active sessions.'));
          }
          final dateFormat = DateFormat('d MMM yyyy, HH:mm');
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final isCurrent = session.sessionId == currentFamilyId;
              final device = session.deviceId?.isNotEmpty == true
                  ? session.deviceId!
                  : (session.userAgent?.isNotEmpty == true
                      ? session.userAgent!
                      : 'Unknown device');
              final lastUsed = session.lastUsedAt ?? session.issuedAt;
              return Card(
                child: ListTile(
                  leading: Icon(
                    isCurrent ? Icons.phone_iphone : Icons.devices_other,
                  ),
                  title: Text(
                    isCurrent ? '$device (this device)' : device,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    [
                      if (lastUsed != null)
                        'Last active ${dateFormat.format(lastUsed.toLocal())}',
                      if (session.expiresAt != null)
                        'Expires ${dateFormat.format(session.expiresAt!.toLocal())}',
                    ].join('\n'),
                  ),
                  isThreeLine: session.expiresAt != null,
                  trailing: IconButton(
                    tooltip: isCurrent ? 'Sign out' : 'Revoke',
                    onPressed: _busy ? null : () => _revoke(session),
                    icon: Icon(isCurrent ? Icons.logout : Icons.delete_outline),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
