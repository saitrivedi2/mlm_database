import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mlm_repository.dart';
import '../../core/models.dart';

final _commissionProvider = FutureProvider<({List<CommissionEntry> items, List<Map<String, dynamic>> summary})>((ref) async => MlmRepository().commissionReport());

class CommissionScreen extends ConsumerWidget {
  const CommissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_commissionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Commission Report')),
      body: state.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...data.summary.map((s) => Text('Level ${s['level']}: paid ${s['paidTotal']} (${s['paidCount']}x), skipped ${s['skippedTotal']} (${s['skippedCount']}x)')),
            const Divider(height: 32),
            const Text('Entries', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...data.items.map((e) => ListTile(
                  leading: CircleAvatar(child: Text('${e.level}')),
                  title: Text('${e.amount} ${e.currency} - ${e.status}'),
                  subtitle: Text(e.reason ?? e.eventRef ?? ''),
                )),
          ],
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, st) => Center(child: Text('Failed: $e')),
      ),
    );
  }
}
