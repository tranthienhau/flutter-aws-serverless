import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/items_api.dart';
import '../../core/theme.dart';

final itemDetailProvider =
    FutureProvider.family<Item, String>((ref, id) => ref.read(itemsApiProvider).get(id));

class ItemDetailPage extends ConsumerWidget {
  final String id;
  const ItemDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(itemDetailProvider(id));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: item.when(
        data: (it) => _content(context, it),
        error: (e, _) => Center(child: Text('Error: $e', style: AppText.bodySm)),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _content(BuildContext context, Item it) {
    return Column(
      children: [
        // Top app bar
        SafeArea(
          bottom: false,
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  ),
                  Text('Item Detail',
                      style: AppText.headlineMd.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const Icon(Icons.edit, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 12),
                  const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Hero banner (offline gradient placeholder + badge)
              Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryContainer, AppColors.primary],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.sensors, color: Colors.white24, size: 96),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 48,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('IN STOCK',
                          style: AppText.labelCaps(color: AppColors.onPrimary)),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Header card
                      _card(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(it.name, style: AppText.headlineLgMobile),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('STOCK LEVEL', style: AppText.labelCaps(color: AppColors.outline)),
                                    Text('${it.qty} Units',
                                        style: AppText.headlineMd
                                            .copyWith(color: AppColors.primary)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'High-precision environmental monitoring assembly designed for large-scale warehouse automation and IoT integration.',
                              style: AppText.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Specs bento grid
                      Row(
                        children: [
                          Expanded(child: _spec(Icons.qr_code_2, 'SKU', 'SN-IND-0422')),
                          const SizedBox(width: 16),
                          Expanded(child: _spec(Icons.category, 'Category', 'Hardware')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _spec(Icons.location_on, 'Warehouse', 'Zone B-14')),
                          const SizedBox(width: 16),
                          Expanded(child: _spec(Icons.calendar_today, 'Last Updated', '2 days ago')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Technical specs
                      _card(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('Technical Specifications',
                                  style: AppText.headlineMd),
                            ),
                            const Divider(height: 1, color: AppColors.surfaceVariant),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _kv('Connectivity', 'LoRaWAN / 5G'),
                                  _kv('Power Supply', 'DC 12V / Battery'),
                                  _kv('Operating Temp', '-20°C to +65°C'),
                                  _kvBadges('Certifications', const ['CE', 'IP67']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Inventory movement bar chart
                      _card(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Inventory Movement', style: AppText.headlineMd),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 128,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  _Bar(0.66, '40'),
                                  _Bar(0.50, '30'),
                                  _Bar(0.75, '45'),
                                  _Bar(1.0, '60', highlight: true),
                                  _Bar(0.40, '24'),
                                  _Bar(0.33, '20'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN']
                                  .map((m) => Text(m,
                                      style: AppText.labelCaps(color: AppColors.outline)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom action bar
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceLowest,
            boxShadow: kSoftShadow,
            border: Border(top: BorderSide(color: AppColors.surfaceVariant)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      label: 'Update Stock',
                      icon: Icons.remove,
                      bg: AppColors.secondaryContainer,
                      fg: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _actionBtn(
                      label: 'Request Reorder',
                      icon: Icons.inventory_2,
                      bg: AppColors.primary,
                      fg: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child, required EdgeInsets padding}) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.5)),
          boxShadow: kSoftShadow,
        ),
        child: child,
      );

  Widget _spec(IconData icon, String label, String value) => _card(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 8),
            Text(label, style: AppText.labelCaps(color: AppColors.outline)),
            const SizedBox(height: 2),
            Text(value, style: AppText.bodySm.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: AppText.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
            Text(v, style: AppText.bodyLg.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _kvBadges(String k, List<String> badges) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: AppText.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
            Row(
              children: badges
                  .map((b) => Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(b,
                            style: AppText.labelSm(color: AppColors.onSecondaryContainer)),
                      ))
                  .toList(),
            ),
          ],
        ),
      );

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
  }) =>
      SizedBox(
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyLgBold.copyWith(color: fg, fontSize: 14)),
              ),
            ],
          ),
        ),
      );
}

class _Bar extends StatelessWidget {
  final double frac;
  final String value;
  final bool highlight;
  const _Bar(this.frac, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (highlight)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.inverseSurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(value, style: AppText.labelSm(color: AppColors.inverseOnSurface)),
              ),
            Container(
              height: frac * 96,
              decoration: BoxDecoration(
                color: highlight ? AppColors.primary : AppColors.primaryFixedDim.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
