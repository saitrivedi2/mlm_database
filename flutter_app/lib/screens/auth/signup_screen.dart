import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_repository.dart';
import '../home/home_screen.dart';

final _authRepoProvider = Provider((ref) => AuthRepository());

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _referral = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _signup() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(_authRepoProvider);
      final resp = await repo.signup(
        username: _username.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text.trim().isEmpty ? null : _password.text.trim(),
        referralCode: _referral.text.trim().isEmpty ? null : _referral.text.trim(),
      );
      if (!mounted) return;
      if (resp['next'] == 'verify_phone') {
        final code = await showDialog<String?>(
          context: context,
          builder: (ctx) {
            final c = TextEditingController();
            return AlertDialog(
              title: const Text('Verify Phone OTP'),
              content: TextField(controller: c, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Code')),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Verify')),
              ],
            );
          },
        );
        if (code != null && code.isNotEmpty) {
          await ref.read(_authRepoProvider).verifyPhoneOtp(phone: _phone.text.trim(), code: code);
          if (!mounted) return;
          final pin = await showDialog<String?>(
            context: context,
            builder: (ctx) {
              final p = TextEditingController();
              return AlertDialog(
                title: const Text('Set 4-digit PIN'),
                content: TextField(controller: p, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN')),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  ElevatedButton(onPressed: () => Navigator.pop(ctx, p.text.trim()), child: const Text('Set')),
                ],
              );
            },
          );
          if (pin != null && pin.length == 4) {
            await ref.read(_authRepoProvider).setTransactionPin(pin);
          }
        }
      }
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
      }
    } catch (e) {
      setState(() => _error = 'Signup failed');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 8),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email (optional)')),
          const SizedBox(height: 8),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone (+country code)')),
          const SizedBox(height: 8),
          TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password (optional)')),
          const SizedBox(height: 8),
          TextField(controller: _referral, decoration: const InputDecoration(labelText: 'Referral Code (optional)')),
          const SizedBox(height: 16),
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _busy ? null : _signup, child: const Text('Create account')),
        ]),
      ),
    );
  }
}
