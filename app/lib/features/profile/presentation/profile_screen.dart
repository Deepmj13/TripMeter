import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_services.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/feedback.dart';
import '../../../shared/widgets/sync_status_bar.dart';

const _notificationLabels = <String, String>{
  'push': 'Push notifications',
  'email': 'Email notifications',
  'invitations': 'Invitations',
  'expenses': 'New and changed expenses',
  'settlements': 'Settlement updates',
};

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _currentPassword = TextEditingController();
  final Map<String, bool> _preferences = {};
  bool _initialized = false;
  bool _saving = false;
  bool _changingPassword = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final user = ref.read(appServicesProvider).session.user;
    if (user != null) _applyUser(user);
  }

  void _applyUser(AppUser user) {
    _name.text = user.name;
    _email.text = user.email;
    _preferences
      ..clear()
      ..addAll({
        for (final key in _notificationLabels.keys)
          key: user.notificationPreferences[key] ?? true,
      });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _currentPassword.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final services = ref.read(appServicesProvider);
    final user = services.session.user;
    if (user == null) return;

    final emailChanged =
        _email.text.trim().toLowerCase() != user.email.toLowerCase();
    if (emailChanged && _currentPassword.text.isEmpty) {
      showMessage(
        context,
        'Enter your current password to change the email address.',
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await services.auth.updateProfile(
        name: _name.text.trim() == user.name ? null : _name.text,
        email: emailChanged ? _email.text : null,
        currentPassword: emailChanged ? _currentPassword.text : null,
        notificationPreferences: Map<String, bool>.from(_preferences),
      );
      _currentPassword.clear();
      if (mounted) {
        showMessage(
          context,
          emailChanged
              ? 'Profile updated. Verify the new email address.'
              : 'Profile updated.',
        );
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePassword() async {
    final current = TextEditingController();
    final next = TextEditingController();
    final confirmation = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: current,
                obscureText: true,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Current password'),
                validator: (value) => (value ?? '').isEmpty
                    ? 'Enter your current password'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: next,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
                validator: (value) => (value ?? '').length < 8
                    ? 'Use at least 8 characters'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmation,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm new password',
                ),
                validator: (value) => value != next.text
                    ? 'Passwords do not match'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Update password'),
          ),
        ],
      ),
    );

    if (submitted == true) {
      setState(() => _changingPassword = true);
      try {
        await ref.read(appServicesProvider).auth.changePassword(
              currentPassword: current.text,
              newPassword: next.text,
            );
        if (mounted) showMessage(context, 'Password changed.');
      } catch (error) {
        if (mounted) showError(context, error);
      } finally {
        if (mounted) setState(() => _changingPassword = false);
      }
    }
    current.dispose();
    next.dispose();
    confirmation.dispose();
  }

  Future<void> _logout() async {
    final confirmed = await confirm(
      context,
      title: 'Sign out?',
      message: 'Queued changes stay on this device until you sign back in.',
      confirmLabel: 'Sign out',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(appServicesProvider).auth.logout();
      if (mounted) context.go('/login');
    } catch (error) {
      if (mounted) showError(context, error);
    }
  }

  Future<void> _deleteAccount() async {
    final password = await _promptPassword(
      title: 'Delete account?',
      message:
          'Your profile is anonymized, sessions are revoked and pending invitations are cancelled. '
          'Financial history stays with your trip members under a neutral name. '
          'Transfer ownership of any shared trip first.',
      confirmLabel: 'Delete account',
    );
    if (password == null || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(appServicesProvider).auth.deleteAccount(password);
      if (mounted) context.go('/login');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<String?> _promptPassword({
    required String title,
    required String message,
    required String confirmLabel,
  }) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Current password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(confirmLabel),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(appServicesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Column(
        children: [
          const SyncStatusBar(),
          Expanded(
            child: ListenableBuilder(
              listenable: services.session,
              builder: (context, _) {
                final user = services.session.user;
                if (user == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    _header(context, user),
                    if (!user.emailVerified)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: ListTile(
                            leading: const Icon(Icons.mark_email_unread_outlined),
                            title: const Text('Email not verified'),
                            subtitle: const Text(
                              'Verify your email to create trips, invite members and write changes.',
                            ),
                            trailing: TextButton(
                              onPressed: () => context.push('/verify-email'),
                              child: const Text('Verify'),
                            ),
                          ),
                        ),
                      ),
                    _section(
                      context,
                      'Account',
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) =>
                                  (value ?? '').trim().isEmpty
                                      ? 'Enter your name'
                                      : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              validator: (value) =>
                                  (value ?? '').contains('@')
                                      ? null
                                      : 'Enter a valid email address',
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _currentPassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Current password (to change email)',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: BusyButton(
                                label: 'Save profile',
                                busy: _saving,
                                onPressed: _saveProfile,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _section(
                      context,
                      'Notifications',
                      Column(
                        children: [
                          for (final entry in _notificationLabels.entries)
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(entry.value),
                              value: _preferences[entry.key] ?? true,
                              onChanged: (value) => setState(
                                () => _preferences[entry.key] = value,
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Saved with your profile.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _section(
                      context,
                      'Security',
                      Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.password),
                            title: const Text('Change password'),
                            trailing: _changingPassword
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: _changingPassword ? null : _changePassword,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.devices_outlined),
                            title: const Text('Signed-in devices'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/profile/sessions'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.mail_outline),
                            title: const Text('Invitations'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/invitations'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.sync_problem),
                            title: const Text('Sync conflicts'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/conflicts'),
                          ),
                        ],
                      ),
                    ),
                    _section(
                      context,
                      'Session',
                      Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.logout),
                            title: const Text('Sign out'),
                            onTap: _logout,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.delete_forever,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            title: Text(
                              'Delete account',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            onTap: _saving ? null : _deleteAccount,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, AppUser user) {
    final initial = user.name.trim().isEmpty
        ? '?'
        : user.name.trim().characters.first.toUpperCase();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          CircleAvatar(radius: 28, child: Text(initial)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.emailVerified)
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
