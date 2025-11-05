import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications_repository.dart';
import '../../core/models.dart';

final _notifProvider = FutureProvider<({List<NotificationItem> items, String? nextCursor})>((ref) async => NotificationsRepository().list(limit: 50));

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_notifProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: state.when(
        data: (data) => ListView.separated(
          itemCount: data.items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final n = data.items[i];
            return ListTile(
              leading: Icon(n.read == true ? Icons.mark_email_read : Icons.mark_email_unread),
              title: Text(n.title ?? n.type ?? 'Notification'),
              subtitle: Text(n.message ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await NotificationsRepository().deleteOne(n.id);
                  ref.invalidate(_notifProvider);
                },
              ),
            );
          },
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, st) => Center(child: Text('Failed: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final count = await NotificationsRepository().markRead([]); // empty means mark all read in service implementation
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked read: $count')));
          ref.invalidate(_notifProvider);
        },
        icon: const Icon(Icons.done_all),
        label: const Text('Mark all read'),
      ),
    );
  }
}
