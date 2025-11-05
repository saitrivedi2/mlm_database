import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/payments_repository.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _amount = TextEditingController();
  final _pin = TextEditingController();
  final _vpa = TextEditingController();
  String _method = 'UPI';
  String? _msg;

  Future<void> _withdraw() async {
    setState(() => _msg = null);
    try {
      final amount = double.tryParse(_amount.text) ?? 0;
      final Map<String, dynamic> details = _method == 'UPI' ? <String, dynamic>{'vpa': _vpa.text.trim()} : <String, dynamic>{};
      final resp = await PaymentsRepository().withdraw(amount: amount, method: _method, details: details, pin: _pin.text.trim());
      setState(() => _msg = 'Submitted: ${resp['transaction']?['id'] ?? ''}');
    } catch (e) {
      setState(() => _msg = 'Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')), 
          const SizedBox(height: 8),
          DropdownButton<String>(value: _method, items: const [DropdownMenuItem(value: 'UPI', child: Text('UPI')), DropdownMenuItem(value: 'BANK', child: Text('Bank'))], onChanged: (v) => setState(() => _method = v ?? 'UPI')),
          if (_method == 'UPI') TextField(controller: _vpa, decoration: const InputDecoration(labelText: 'UPI VPA')),
          const SizedBox(height: 8),
          TextField(controller: _pin, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN')), 
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _withdraw, child: const Text('Submit')),
          if (_msg != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_msg!)),
        ]),
      ),
    );
  }
}
