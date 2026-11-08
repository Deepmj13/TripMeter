import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_services.dart';
import '../../../shared/widgets/feedback.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _token = TextEditingController();
  final _email = TextEditingController();
  bool _busy = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final state = GoRouterState.of(context);
    final token = state.uri.queryParameters['token'];
    if (token != null && token.isNotEmpty) {
      _token.text = token;
      WidgetsBinding.instance.addPostFrameCallback((_) => _verify());
    }
  }

  @override
  void dispose() {
    _token.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_token.text.trim().isEmpty) {
      showMessage(context, 'Enter the verification token from your email.');
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(appServicesProvider).auth.verifyEmail(_token.text.trim());
      if (mounted) {
        showMessage(context, 'Email verified.');
        context.go('/trips');
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    if (_email.text.trim().isEmpty) {
      showMessage(context, 'Enter your account email to resend the token.');
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(appServicesProvider)
          .auth
          .resendVerification(_email.text.trim());
      if (mounted) showMessage(context, 'A new verification email was sent.');
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Paste the verification token from your email, or resend a new one.',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _token,
                    decoration: const InputDecoration(
                      labelText: 'Verification token',
                      prefixIcon: Icon(Icons.key_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy ? null : _verify,
                    child: const Text('Verify email'),
                  ),
                  const Divider(height: 48),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Account email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _busy ? null : _resend,
                    child: const Text('Resend verification email'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/trips'),
                    child: const Text('Continue to trips'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
