import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_repository.dart';
import '../../core/wallet_repository.dart';
import '../../core/models.dart';
import '../payments/payments_screen.dart';
import '../wallet/transactions_screen.dart';
import '../wallet/wallet_screen.dart';
import '../notifications/notifications_screen.dart';
import '../mlm/mlm_screen.dart';
import '../admin/admin_broadcast_screen.dart';

final _walletProvider = FutureProvider<WalletData>((ref) async => WalletRepository().getWallet());

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(_walletProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MLM Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthRepository().logout();
              if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            wallet.when(
              data: (w) => Card(
                child: ListTile(
                  title: Text('Main: ${w.mainBalance.toStringAsFixed(2)} ${w.currency}'),
                  subtitle: Text('Referral: ${w.referralBalance.toStringAsFixed(2)} | Tokens: ${w.tokenBalance.toStringAsFixed(4)}'),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, st) => Text('Failed to load wallet: $e'),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: const [
              _HomeNavButton(label: 'Wallet', icon: Icons.account_balance_wallet, builder: WalletScreen.new),
              _HomeNavButton(label: 'Payments', icon: Icons.payments, builder: PaymentsScreen.new),
              _HomeNavButton(label: 'Transactions', icon: Icons.list, builder: TransactionsScreen.new),
              _HomeNavButton(label: 'Notifications', icon: Icons.notifications, builder: NotificationsScreen.new),
              _HomeNavButton(label: 'MLM', icon: Icons.device_hub, builder: MlmScreen.new),
              _HomeNavButton(label: 'Admin Broadcast', icon: Icons.campaign, builder: AdminBroadcastScreen.new),
            ]),
          ],
        ),
      ),
    );
  }
}

class _HomeNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget Function() builder;
  const _HomeNavButton({required this.label, required this.icon, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => builder())),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
