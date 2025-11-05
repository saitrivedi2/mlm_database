import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications_repository.dart';

class AdminBroadcastScreen extends ConsumerStatefulWidget {
  const AdminBroadcastScreen({super.key});

  @override
  ConsumerState<AdminBroadcastScreen> createState() => _AdminBroadcastScreenState();
}

class _AdminBroadcastScreenState extends ConsumerState<AdminBroadcastScreen> {
  final _title = TextEditingController();
  final _message = TextEditingController();
  String? _result;

  Future<void> _broadcast() async {
    setState(() => _result = null);
    try {
      final count = await NotificationsRepository().adminBroadcast(title: _title.text.trim(), message: _message.text.trim());
      setState(() => _result = 'Sent to $count users');
    } catch (e) {
      setState(() => _result = 'Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Broadcast')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(controller: _message, maxLines: 5, decoration: const InputDecoration(labelText: 'Message')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _broadcast, child: const Text('Send')),
          if (_result != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_result!)),
        ]),
      ),
    );
  }
}
