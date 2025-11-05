import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/payments_repository.dart';
import '../../core/models.dart';

final _purchasesProvider = FutureProvider<List<TokenPurchaseItem>>((ref) async => PaymentsRepository().listTokenPurchases());

class PurchasesScreen extends ConsumerWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_purchasesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Token Purchases')),
      body: state.when(
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final p = list[i];
            return ListTile(
              title: Text('${p.tokens} tokens - ${p.status}'),
              subtitle: Text('${p.priceInr} INR (${p.priceUsd} USD)\n${p.createdAt}'),
              isThreeLine: true,
            );
          },
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, st) => Center(child: Text('Failed: $e')),
      ),
    );
  }
}
