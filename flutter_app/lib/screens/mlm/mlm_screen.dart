import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mlm_repository.dart';
import '../../core/models.dart';
import 'commission_screen.dart';

final _downlineProvider = FutureProvider<List<DownlineMember>>((ref) async => MlmRepository().listDownline(depth: 4));

class MlmScreen extends ConsumerWidget {
  const MlmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downline = ref.watch(_downlineProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('MLM'), actions: [
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommissionScreen())), icon: const Icon(Icons.summarize), tooltip: 'Commission')
      ]), 
      body: downline.when(
        data: (members) => ListView.separated(
          itemCount: members.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final m = members[i];
            return ListTile(
              leading: CircleAvatar(child: Text('${m.level ?? 0}')),
              title: Text(m.username ?? m.email ?? m.phone ?? m.id),
              subtitle: Text('Matrix: ${m.matrixLevel} | Active: ${m.isActive == true ? 'Yes' : 'No'}'),
            );
          },
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, st) => Center(child: Text('Failed: $e')),
      ),
    );
  }
}
