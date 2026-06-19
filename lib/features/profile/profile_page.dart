import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_controller.dart';
import '../../core/theme.dart';
import '../../core/widgets/bottom_nav.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(authControllerProvider);
    final email = s.email ?? 'hau@example.com';
    final name = _nameFromEmail(email);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top app bar
            SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text('Inventory',
                        style: AppText.headlineMd.copyWith(
                            color: AppColors.primary, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 16),
                    const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  // Profile hero
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primaryContainer, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.surfaceLowest, width: 4),
                              boxShadow: kSoftShadow,
                            ),
                            alignment: Alignment.center,
                            child: Text(_initials(name),
                                style: AppText.headlineLg.copyWith(color: Colors.white)),
                          ),
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: kSoftShadow,
                              ),
                              child: const Icon(Icons.edit, color: AppColors.onPrimary, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(name, style: AppText.headlineLgMobile),
                      const SizedBox(height: 4),
                      Text(email, style: AppText.bodySm),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Account details card
                  _card(
                    child: Column(
                      children: [
                        _detailRow(Icons.mail, AppColors.primaryFixed,
                            AppColors.onPrimaryFixedVariant, 'EMAIL ADDRESS', email),
                        const Divider(height: 32, color: AppColors.surfaceHighest),
                        _detailRow(Icons.shield, AppColors.secondaryFixed,
                            AppColors.onSecondaryFixedVariant, 'ACCOUNT TYPE', 'AWS Admin Tier'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // System settings card
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SYSTEM SETTINGS', style: AppText.labelCaps()),
                        const SizedBox(height: 16),
                        _toggleRow(Icons.notifications_outlined, 'Notifications', true),
                        const SizedBox(height: 16),
                        _toggleRow(Icons.dark_mode_outlined, 'Dark Appearance', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Sign out
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await ref.read(authControllerProvider.notifier).signOut();
                        if (context.mounted) context.go('/sign-in');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text('Sign out',
                              style: AppText.headlineMd.copyWith(color: AppColors.onPrimary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text('App Version 2.4.1 (Build 890)',
                        style: AppText.labelSm(color: AppColors.outline)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(active: 2),
    );
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: kSoftShadow,
        ),
        child: child,
      );

  Widget _detailRow(IconData icon, Color bg, Color fg, String label, String value) => Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: fg, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.labelCaps()),
                const SizedBox(height: 2),
                Text(value, style: AppText.bodyLg, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
        ],
      );

  Widget _toggleRow(IconData icon, String label, bool on) => Row(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppText.bodyLg)),
          Container(
            width: 48,
            height: 24,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: on ? AppColors.primaryContainer : AppColors.surfaceHighest,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Align(
              alignment: on ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: on ? AppColors.onPrimaryContainer : AppColors.outlineVariant,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      );

  String _nameFromEmail(String email) {
    final local = email.split('@').first.replaceAll(RegExp(r'[._]'), ' ').trim();
    if (local.isEmpty) return 'Inventory User';
    final titled = local
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
    return '$titled Example';
  }

  String _initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
