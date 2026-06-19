import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

/// Bottom navigation matching the "Modern Ethos" design: active tab is a
/// pill-shaped primary-container chip, inactive tabs are plain.
class AppBottomNav extends StatelessWidget {
  final int active; // 0 = Items, 1 = Categories, 2 = Profile
  const AppBottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: kSoftShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tab(context, 0, Icons.list_alt, 'Items', '/'),
              _tab(context, 1, Icons.category_outlined, 'Categories', null),
              _tab(context, 2, Icons.person_outline, 'Profile', '/profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int i, IconData icon, String label, String? route) {
    final isActive = i == active;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: isActive ? AppColors.onPrimaryContainer : AppColors.onSecondaryContainer),
        const SizedBox(height: 2),
        Text(label,
            style: AppText.labelSm(
                color: isActive ? AppColors.onPrimaryContainer : AppColors.onSecondaryContainer)),
      ],
    );
    return GestureDetector(
      onTap: () {
        if (route != null && !isActive) context.go(route);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      ),
    );
  }
}
