import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/payments_repository.dart';
import '../../core/models.dart';

final _txProvider = FutureProvider<List<TransactionItem>>((ref) async => PaymentsRepository().paymentTransactions());

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(_txProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: txs.when(
        data: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final t = items[i];
            return ListTile(
              leading: Icon(t.status == 'SUCCESS' ? Icons.check_circle : t.status == 'FAILED' ? Icons.error : Icons.hourglass_top),
              title: Text('${t.type} - ${t.amount.toStringAsFixed(2)} ${t.currency}'),
              subtitle: Text('${t.description ?? ''}\n${t.createdAt}'),
              isThreeLine: true,
            );
          },
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, st) => Center(child: Text('Failed to load transactions: $e')),
      ),
    );
  }
}
