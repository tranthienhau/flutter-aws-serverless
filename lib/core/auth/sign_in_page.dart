import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import 'auth_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _State();
}

class _State extends ConsumerState<SignInPage> {
  final _email = TextEditingController(text: 'hau@example.com');
  final _pwd = TextEditingController();
  String? _err;
  bool _busy = false;
  bool _obscure = true;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).signIn(_email.text.trim(), _pwd.text);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient background glow
          Positioned(
            top: -120,
            left: -120,
            child: _blob(280, AppColors.primary.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -140,
            right: -140,
            child: _blob(340, AppColors.primary.withOpacity(0.10)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brand mark
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: kSoftShadow,
                        ),
                        child: const Icon(Icons.inventory_2,
                            color: AppColors.onPrimaryContainer, size: 32),
                      ),
                      const SizedBox(height: 20),
                      Text('Sign in', style: AppText.headlineLgMobile),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 280,
                        child: Text(
                          'Access your AWS-powered inventory management dashboard.',
                          textAlign: TextAlign.center,
                          style: AppText.bodySm,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Form card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLowest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: kSoftShadow,
                          border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('EMAIL'),
                            const SizedBox(height: 8),
                            _field(
                              controller: _email,
                              hint: 'hau@example.com',
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _label('PASSWORD'),
                                Text('Forgot?',
                                    style: AppText.labelSm(color: AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _field(
                              controller: _pwd,
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                              obscure: _obscure,
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure ? Icons.visibility : Icons.visibility_off,
                                  size: 20,
                                  color: AppColors.outline,
                                ),
                              ),
                            ),
                            if (_err != null) ...[
                              const SizedBox(height: 12),
                              Text(_err!,
                                  style: AppText.bodySm.copyWith(color: AppColors.error)),
                            ],
                            const SizedBox(height: 24),
                            // Primary action
                            SizedBox(
                              height: 56,
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _busy ? null : _submit,
                                child: _busy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2, color: Colors.white),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Sign in',
                                              style: AppText.headlineMd
                                                  .copyWith(color: AppColors.onPrimary)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.arrow_forward, size: 20),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // OR divider
                            Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: AppColors.outlineVariant)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('OR',
                                      style: AppText.labelCaps(
                                          color: AppColors.outlineVariant)),
                                ),
                                const Expanded(
                                    child: Divider(color: AppColors.outlineVariant)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.secondaryContainer,
                                  foregroundColor: AppColors.onSecondaryContainer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.shield_outlined, size: 18),
                                    const SizedBox(width: 12),
                                    Text('Continue with SSO', style: AppText.bodyLg),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: AppText.bodySm,
                          children: [
                            TextSpan(
                              text: 'Request access',
                              style: AppText.bodySm.copyWith(
                                  color: AppColors.primary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Opacity(
                        opacity: 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.verified_user, size: 14),
                            const SizedBox(width: 4),
                            Text('AWS Cognito Secured', style: AppText.labelSm()),
                            const SizedBox(width: 16),
                            Text('v2.4.0', style: AppText.labelSm()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String s) => Text(s, style: AppText.labelCaps());

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppText.bodyLg,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.bodyLg.copyWith(color: AppColors.outline.withOpacity(0.5)),
        prefixIcon: Icon(icon, size: 20, color: AppColors.outline),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surfaceLowest,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
