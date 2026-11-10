import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/feedback.dart';

class MembersTab extends ConsumerWidget {
  const MembersTab({super.key, required this.trip});

  final LocalTrip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return StreamBuilder<List<LocalMember>>(
      stream: services.members.watchMembers(trip.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final members = snapshot.data!;
        final myEmail = services.session.user?.email.toLowerCase();
        return Stack(
          children: [
            if (members.isEmpty)
              const Center(child: Text('No members in this trip.'))
            else
              ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 96),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final canClaim = member.memberKind == 'guest' &&
                      member.status == 'active' &&
                      member.emailNormalized != null &&
                      member.emailNormalized!.toLowerCase() == myEmail;
                  return _MemberTile(
                    member: member,
                    canManage: trip.isAdmin,
                    canClaim: canClaim,
                    onChangeRole: (role) => _changeRole(context, ref, member, role),
                    onRemove: () => _remove(context, ref, member),
                    onClaim: () => _claim(context, ref, member),
                  );
                },
              ),
            if (trip.isAdmin && trip.canWrite)
              Positioned(
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'invite-member',
                      tooltip: 'Invite by email',
                      onPressed: () => _invite(context, ref),
                      child: const Icon(Icons.mail_outline),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton.extended(
                      heroTag: 'add-guest',
                      onPressed: () => _addGuest(context, ref),
                      icon: const Icon(Icons.person_add_alt),
                      label: const Text('Add guest'),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _addGuest(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<(String, String?)>(
      context: context,
      builder: (context) {
        final name = TextEditingController();
        final email = TextEditingController();
        return AlertDialog(
          title: const Text('Add guest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                  helperText: 'An email lets this guest claim the membership later.',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(
                context,
                (name.text, email.text.trim().isEmpty ? null : email.text.trim()),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (result == null || !context.mounted) return;
    if (result.$1.trim().isEmpty) {
      showMessage(context, 'A guest needs a name.');
      return;
    }
    try {
      await ref.read(appServicesProvider).members.addGuest(
            trip.id,
            displayName: result.$1,
            email: result.$2,
          );
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<void> _invite(BuildContext context, WidgetRef ref) async {
    final email = await _textDialog(
      context,
      title: 'Invite by email',
      label: 'Email address',
      keyboardType: TextInputType.emailAddress,
    );
    if (email == null || email.trim().isEmpty || !context.mounted) return;
    try {
      await ref
          .read(appServicesProvider)
          .invitations
          .create(trip.id, email.trim());
      if (context.mounted) {
        showMessage(context, 'Invitation sent. It expires in 7 days.');
      }
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<void> _changeRole(
    BuildContext context,
    WidgetRef ref,
    LocalMember member,
    String role,
  ) async {
    try {
      await ref
          .read(appServicesProvider)
          .members
          .changeRole(trip.id, member.id, role);
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    LocalMember member,
  ) async {
    final confirmed = await confirm(
      context,
      title: 'Remove ${member.displayName}?',
      message:
          'Historical expenses remain. Outstanding balances are kept and shown to the remaining members.',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(appServicesProvider).members.remove(trip.id, member.id);
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<void> _claim(
    BuildContext context,
    WidgetRef ref,
    LocalMember member,
  ) async {
    final confirmed = await confirm(
      context,
      title: 'Claim this membership?',
      message:
          'Your account will replace the guest record and keep all its expenses.',
      confirmLabel: 'Claim',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(appServicesProvider).members.claim(trip.id, member.id);
      if (context.mounted) showMessage(context, 'Membership claimed.');
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<String?> _textDialog(
    BuildContext context, {
    required String title,
    required String label,
    TextInputType? keyboardType,
  }) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.canManage,
    required this.canClaim,
    required this.onChangeRole,
    required this.onRemove,
    required this.onClaim,
  });

  final LocalMember member;
  final bool canManage;
  final bool canClaim;
  final ValueChanged<String> onChangeRole;
  final VoidCallback onRemove;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOwner = member.role == 'owner';
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          member.displayName.isEmpty
              ? '?'
              : member.displayName.substring(0, 1).toUpperCase(),
        ),
      ),
      title: Text(member.displayName),
      subtitle: Wrap(
        spacing: 6,
        children: [
          Text(member.role),
          if (member.memberKind == 'guest') const Text('• guest'),
          if (member.status != 'active') Text('• ${member.status}'),
          if (member.emailNormalized != null) Text('• ${member.emailNormalized}'),
        ],
      ),
      trailing: (canManage && !isOwner) || canClaim
          ? PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'admin':
                  case 'member':
                    onChangeRole(value);
                  case 'remove':
                    onRemove();
                  case 'claim':
                    onClaim();
                }
              },
              itemBuilder: (context) => [
                if (canClaim)
                  const PopupMenuItem(value: 'claim', child: Text('Claim membership')),
                if (canManage && !isOwner) ...[
                  if (member.role != 'admin')
                    const PopupMenuItem(value: 'admin', child: Text('Make admin')),
                  if (member.role != 'member')
                    const PopupMenuItem(value: 'member', child: Text('Make member')),
                  const PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ],
            )
          : isOwner
              ? Chip(
                  label: const Text('Owner'),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: theme.colorScheme.primaryContainer,
                )
              : null,
    );
  }
}
