import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../signin/signin_page.dart';
import 'recharge_page.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    final account = ref.watch(walletAccountProvider).valueOrNull;
    final txns = ref.watch(walletTxnsProvider).valueOrNull ?? const <WalletTransaction>[];
    final balance = account?.balanceCents ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A50), Color(0xFFE8590C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.balanceLabel, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                const SizedBox(height: 6),
                Text(
                  formatMoney(balance, currency),
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFE8590C)),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RechargePage()),
                        ),
                        child: Text(l10n.goRecharge),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SigninPage()),
                        ),
                        child: Text(l10n.signinEntry),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.transactionsTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          if (txns.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(child: Text(l10n.emptyTransactions, style: const TextStyle(color: Colors.grey))),
            )
          else
            for (final txn in txns) _TxnTile(txn: txn, currency: currency),
        ],
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.txn, required this.currency});

  final WalletTransaction txn;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color) = switch (txn.type) {
      'recharge' => (Icons.add_card, const Color(0xFFF9A825)),
      'payment' => (Icons.shopping_bag_outlined, const Color(0xFF1E88E5)),
      'signin' => (Icons.event_available, const Color(0xFF43A047)),
      _ => (Icons.celebration, const Color(0xFF8E24AA)),
    };
    final label = switch (txn.type) {
      'recharge' => l10n.txnRecharge,
      'payment' => l10n.txnPayment,
      'signin' => l10n.txnSignin,
      _ => l10n.txnRebate,
    };
    final positive = txn.amountCents > 0;
    final fmt = DateFormat('MM-dd HH:mm');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${fmt.format(txn.createdAt)}${txn.note.isEmpty ? '' : ' · ${txn.note}'}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '${positive ? '+' : '-'}${formatMoney(txn.amountCents.abs(), currency)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: positive ? const Color(0xFFE8590C) : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
