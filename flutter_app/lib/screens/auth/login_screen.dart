import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_repository.dart';
import '../../core/api_client.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

final _authRepoProvider = Provider((ref) => AuthRepository());

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(_authRepoProvider);
      await repo.login(identifier: _identifier.text.trim(), password: _password.text);
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      setState(() => _error = 'Login failed');
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _loginOtp() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(_authRepoProvider);
      await repo.loginRequestOtp(_identifier.text.trim());
      if (!mounted) return;
      final code = await showDialog<String?>(
        context: context,
        builder: (ctx) {
          final c = TextEditingController();
          return AlertDialog(
            title: const Text('Enter OTP'),
            content: TextField(controller: c, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Code')),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Verify')),
            ],
          );
        },
      );
      if (code != null && code.isNotEmpty) {
        await repo.login(identifier: _identifier.text.trim(), code: code);
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      }
    } catch (e) {
      setState(() => _error = 'OTP login failed');
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _logoutAll() async {
    await ApiClient.I.clearToken();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _identifier, decoration: const InputDecoration(labelText: 'Email or Phone')),
            const SizedBox(height: 8),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            Row(children: [
              ElevatedButton(onPressed: _busy ? null : _login, child: const Text('Login')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _busy ? null : _loginOtp, child: const Text('Login via OTP')),
              const SizedBox(width: 8),
              TextButton(onPressed: _busy ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), child: const Text('Sign up')),
            ]),
            const Spacer(),
            TextButton(onPressed: _logoutAll, child: const Text('Clear token (dev)')),
          ],
        ),
      ),
    );
  }
}
