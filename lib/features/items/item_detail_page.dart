import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/items_api.dart';

final itemDetailProvider =
    FutureProvider.family<Item, String>((ref, id) => ref.read(itemsApiProvider).get(id));

class ItemDetailPage extends ConsumerWidget {
  final String id;
  const ItemDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(itemDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: const Text('Item')),
      body: item.when(
        data: (it) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(it.name, style: Theme.of(context).textTheme.headlineSmall), Text('qty: ${it.qty}')],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
