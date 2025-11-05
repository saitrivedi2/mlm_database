import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/payments_repository.dart';
import '../../core/wallet_repository.dart';
import '../../core/models.dart';
import 'withdraw_screen.dart';
import 'purchases_screen.dart';

final _plansProvider = FutureProvider<List<PlanItem>>((ref) async => PaymentsRepository().getPlans());

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final _amount = TextEditingController(text: '100');
  final _razorpay = Razorpay();
  String? _error;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (_) {});
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (e) => setState(() => _error = 'Payment failed'));
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _createOrderAndCheckout() async {
    setState(() => _error = null);
    try {
      final amt = double.tryParse(_amount.text.trim()) ?? 0;
      final repo = PaymentsRepository();
      final order = await repo.addFundsOrder(amount: amt);
      final cfg = await repo.getPublicConfig();
      // Minimal checkout example - normally pass key from server or env
      final options = {
        'key': cfg['razorpayKeyId'] ?? 'rzp_test_xxxxxxxx',
        'amount': (amt * 100).toInt(),
        'name': 'Wallet Top-up',
        'order_id': order['order']?['id'],
        'description': 'Add funds',
        'timeout': 180,
      };
      if (!kIsWeb) {
        _razorpay.open(options);
      }
      if (mounted) ref.invalidate(_plansProvider);
      if (mounted) ref.invalidate(_walletFutureProvider);
    } catch (e) {
      setState(() => _error = 'Failed to start checkout');
    }
  }

  static final _walletFutureProvider = FutureProvider((ref) => WalletRepository().getWallet());

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(_plansProvider);
    final wallet = ref.watch(_walletFutureProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Wallet top-up', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (INR)'))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _createOrderAndCheckout, child: const Text('Checkout')),
          ]),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red))),
          const Divider(height: 32),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WithdrawScreen())),
                icon: const Icon(Icons.outbox),
                label: const Text('Withdraw'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PurchasesScreen())),
                icon: const Icon(Icons.receipt_long),
                label: const Text('Purchases'),
              ),
              const SizedBox(width: 8),
              if (kIsWeb)
                const Text('(Razorpay checkout disabled on web demo)')
            ],
          ),
          const Divider(height: 32),
          const Text('Plans', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          plans.when(
            data: (items) => Column(
              children: items
                  .map((p) => Card(
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Text('USD ${p.priceUsd.toStringAsFixed(2)} | Tokens ${p.tokens.toStringAsFixed(4)}'),
                          trailing: ElevatedButton(
                            child: const Text('Buy'),
                            onPressed: () async {
                              final order = await PaymentsRepository().createTokenPurchaseOrder(planId: p.id);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order created: ${order['order']?['id'] ?? ''}')));
                            },
                          ),
                        ),
                      ))
                  .toList(),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, st) => Text('Failed to load plans: $e'),
          ),
          const Divider(height: 32),
          const Text('Wallet'),
          const SizedBox(height: 8),
          wallet.when(
            data: (w) => Text('Main: ${w.mainBalance} ${w.currency}'),
            loading: () => const LinearProgressIndicator(),
            error: (e, st) => Text('Failed: $e'),
          ),
        ]),
      ),
    );
  }
}
