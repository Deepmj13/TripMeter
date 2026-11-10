import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/feedback.dart';

class InvitationsScreen extends ConsumerStatefulWidget {
  const InvitationsScreen({super.key});

  @override
  ConsumerState<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends ConsumerState<InvitationsScreen> {
  bool _accepting = false;
  bool _linkHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(appServicesProvider).invitations.list();
      } catch (_) {
        // The local list remains usable offline.
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_linkHandled) return;
    _linkHandled = true;
    final token = GoRouterState.of(context).uri.queryParameters['token'];
    if (token != null && token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _acceptTokenValue(token));
    }
  }

  Future<void> _acceptTokenValue(String token) async {
    setState(() => _accepting = true);
    try {
      final trip = await ref
          .read(appServicesProvider)
          .invitations
          .acceptByToken(token);
      if (mounted) {
        showMessage(context, 'Invitation accepted.');
        context.go('/trips/${trip.id}');
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  Future<void> _accept(LocalInvitation invitation) async {
    setState(() => _accepting = true);
    try {
      final trip = await ref
          .read(appServicesProvider)
          .invitations
          .acceptById(invitation.id);
      if (mounted) {
        showMessage(context, 'Invitation accepted.');
        context.go('/trips/${trip.id}');
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  Future<void> _decline(LocalInvitation invitation) async {
    try {
      await ref
          .read(appServicesProvider)
          .invitations
          .decline(invitationId: invitation.id);
      if (mounted) showMessage(context, 'Invitation declined.');
    } catch (error) {
      if (mounted) showError(context, error);
    }
  }

  Future<void> _acceptToken() async {
    final token = await _tokenDialog(context);
    if (token == null || token.trim().isEmpty || !mounted) return;
    await _acceptTokenValue(token.trim());
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(appServicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitations'),
        actions: [
          IconButton(
            tooltip: 'Accept by token',
            onPressed: _accepting ? null : _acceptToken,
            icon: const Icon(Icons.key_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<LocalInvitation>>(
              stream: services.invitations.watchInvitations(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final invitations = snapshot.data!;
                if (invitations.isEmpty) {
                  return const Center(
                    child: Text('You have no invitations.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    try {
                      await services.invitations.list();
                    } catch (error) {
                      if (context.mounted) showError(context, error);
                    }
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: invitations.length,
                    itemBuilder: (context, index) {
                      final invitation = invitations[index];
                      final expires = DateTime.tryParse(invitation.expiresAt);
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.mail_outline),
                          title: Text(invitation.tripName ?? invitation.tripId),
                          subtitle: Text(
                            '${invitation.status} as ${invitation.role}'
                            '${expires == null ? '' : ' • expires ${DateFormat('d MMM yyyy').format(expires)}'}',
                          ),
                          trailing: invitation.status == 'pending'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: _accepting
                                          ? null
                                          : () => _decline(invitation),
                                      child: const Text('Decline'),
                                    ),
                                    FilledButton(
                                      onPressed: _accepting
                                          ? null
                                          : () => _accept(invitation),
                                      child: const Text('Accept'),
                                    ),
                                  ],
                                )
                              : Chip(label: Text(invitation.status)),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _tokenDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept with token'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Invitation token'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}
