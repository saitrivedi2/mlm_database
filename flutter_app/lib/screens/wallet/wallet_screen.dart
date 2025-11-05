import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/wallet_repository.dart';
import '../../core/models.dart';

final _walletProvider = FutureProvider<WalletData>((ref) async => WalletRepository().getWallet());

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final _amount = TextEditingController();
  final _pin = TextEditingController();
  String? _error;

  Future<void> _transfer() async {
    setState(() => _error = null);
    try {
      final amt = double.tryParse(_amount.text.trim()) ?? 0;
      await WalletRepository().transferReferralToMain(amount: amt, pin: _pin.text.trim());
      ref.invalidate(_walletProvider);
    } catch (e) {
      setState(() => _error = 'Transfer failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(_walletProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          wallet.when(
            data: (w) => Card(
              child: ListTile(
                title: Text('Main: ${w.mainBalance.toStringAsFixed(2)} ${w.currency}'),
                subtitle: Text('Referral: ${w.referralBalance.toStringAsFixed(2)} | Tokens: ${w.tokenBalance.toStringAsFixed(4)}'),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, st) => Text('Failed to load: $e'),
          ),
          const SizedBox(height: 12),
          const Text('Referral → Main transfer'),
          Row(children: [
            Expanded(child: TextField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount'))),
            const SizedBox(width: 8),
            SizedBox(width: 120, child: TextField(controller: _pin, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN'))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _transfer, child: const Text('Transfer')),
          ]),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red))),
        ]),
      ),
    );
  }
}
