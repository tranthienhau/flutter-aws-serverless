import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/items_api.dart';
import '../../core/theme.dart';
import '../../core/widgets/bottom_nav.dart';

final itemsProvider = FutureProvider<List<Item>>((ref) => ref.read(itemsApiProvider).list());

// Per-item icon + tile color, cycled by list position (presentational only).
const _accents = [
  (Icons.router, AppColors.secondaryContainer, AppColors.tertiary),
  (Icons.key, AppColors.tertiaryFixed, AppColors.tertiary),
  (Icons.storage, AppColors.primaryFixed, AppColors.primary),
  (Icons.bolt, AppColors.errorContainer, AppColors.error),
  (Icons.api, AppColors.surfaceHighest, AppColors.onSurfaceVariant),
];

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: items.when(
          data: (list) => _content(context, ref, list),
          error: (e, _) => Center(child: Text('Error: $e', style: AppText.bodySm)),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () async {
              await ref.read(itemsApiProvider).create(
                    Item(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: 'New asset',
                        qty: 1),
                  );
              ref.invalidate(itemsProvider);
            },
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(active: 0),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, List<Item> list) {
    final totalStock = list.fold<int>(0, (s, e) => s + e.qty);
    final featured = list.isNotEmpty ? list.first : null;
    final rest = list.length > 1 ? list.sublist(1) : <Item>[];

    return RefreshIndicator(
      onRefresh: () => ref.refresh(itemsProvider.future),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          // Top app bar
          SizedBox(
            height: 64,
            child: Row(
              children: [
                const Icon(Icons.inventory_2, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text('Inventory',
                    style: AppText.headlineMd.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
                const Spacer(),
                _circleBtn(Icons.search),
              ],
            ),
          ),
          // Search box
          TextField(
            style: AppText.bodySm.copyWith(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Search industrial assets...',
              hintStyle: AppText.bodySm,
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.outline),
              filled: true,
              fillColor: AppColors.surfaceLowest,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _chip('All Items', selected: true),
                _chip('Sensors'),
                _chip('Gateways'),
                _chip('Serverless'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Featured priority card
          if (featured != null) _featuredCard(context, featured),
          const SizedBox(height: 16),
          // Item cards
          ...rest.asMap().entries.map((e) {
            final accent = _accents[e.key % _accents.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _itemCard(context, e.value, accent),
            );
          }),
          const SizedBox(height: 8),
          // Stats grid
          Row(
            children: [
              Expanded(child: _stat('TOTAL STOCK', '$totalStock')),
              const SizedBox(width: 16),
              Expanded(child: _stat('CATEGORIES', '6')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon) => Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.onSurfaceVariant),
      );

  Widget _chip(String label, {bool selected = false}) => Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppText.labelSm(
              color: selected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant),
        ),
      );

  Widget _featuredCard(BuildContext context, Item item) => GestureDetector(
        onTap: () => context.go('/items/${item.id}'),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: kSoftShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PRIORITY ASSET',
                  style: AppText.labelCaps(color: Colors.white).copyWith(
                      color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 4),
              Text(item.name,
                  style: AppText.headlineLgMobile.copyWith(color: Colors.white)),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available Quantity',
                          style: AppText.labelSm(color: Colors.white)
                              .copyWith(color: Colors.white.withOpacity(0.8))),
                      Text('${item.qty}',
                          style: AppText.headlineLg.copyWith(color: Colors.white)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.sensors, color: Colors.white, size: 32),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _itemCard(BuildContext context, Item item, (IconData, Color, Color) accent) =>
      GestureDetector(
        onTap: () => context.go('/items/${item.id}'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceVariant),
            boxShadow: kSoftShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.$2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(accent.$1, color: accent.$3),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: AppText.bodyLgBold, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('Qty: ${item.qty} units', style: AppText.bodySm),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      );

  Widget _stat(String label, String value) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.labelCaps()),
            const SizedBox(height: 4),
            Text(value, style: AppText.headlineMd.copyWith(color: AppColors.primary)),
          ],
        ),
      );
}
