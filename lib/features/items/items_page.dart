import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/items_api.dart';
import '../../core/auth/auth_controller.dart';

final itemsProvider = FutureProvider<List<Item>>((ref) => ref.read(itemsApiProvider).list());

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person)),
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: items.when(
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(itemsProvider.future),
          child: ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, i) {
              final it = list[i];
              return ListTile(
                title: Text(it.name),
                subtitle: Text('qty: ${it.qty}'),
                onTap: () => context.go('/items/${it.id}'),
              );
            },
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(itemsApiProvider).create(
                Item(id: DateTime.now().millisecondsSinceEpoch.toString(), name: 'New item', qty: 1),
              );
          ref.invalidate(itemsProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
