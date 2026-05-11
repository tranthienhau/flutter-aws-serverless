import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _State();
}

class _State extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _pwd = TextEditingController();
  String? _err;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _pwd, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            if (_err != null) Text(_err!, style: const TextStyle(color: Colors.red)),
            FilledButton(
              onPressed: _busy ? null : () async {
                setState(() { _busy = true; _err = null; });
                try {
                  await ref.read(authControllerProvider.notifier).signIn(_email.text.trim(), _pwd.text);
                  if (mounted) context.go('/');
                } catch (e) {
                  setState(() => _err = e.toString());
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
              child: Text(_busy ? '...' : 'Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
