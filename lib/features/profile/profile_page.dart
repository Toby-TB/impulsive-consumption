import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/achievements.dart';
import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../achievements/achievements_page.dart';
import '../favorites/favorites_page.dart';
import '../orders/orders_page.dart';
import '../settings/settings_page.dart';
import '../signin/signin_page.dart';
import '../wallet/wallet_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    final account = ref.watch(walletAccountProvider).valueOrNull;
    final favs = ref.watch(favoritesProvider).valueOrNull ?? const <String>{};
    final orders = ref.watch(ordersProvider).valueOrNull ?? const <OrderBundle>[];
    final achievements = ref.watch(achievementsProvider).valueOrNull ?? const [];
    final summary = ref.watch(signInSummaryProvider);
    final balance = account?.balanceCents ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabProfile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFFF8A50), Color(0xFFE8590C)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Text('🛍️', style: TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.welcome, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(l10n.profileSubtitle, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _entry(Icons.account_balance_wallet_outlined, l10n.walletEntry,
                    formatMoney(balance, currency), () => _push(context, const WalletPage())),
                _entry(Icons.event_available_outlined, l10n.signinEntry,
                    summary.signedToday ? l10n.signedToday : l10n.signinReward(formatMoney(summary.todayRewardCents, currency)),
                    () => _push(context, const SigninPage())),
                _entry(Icons.emoji_events_outlined, l10n.achievementsEntry,
                    '${achievements.length}/${achievementDefs.length}'.toString(),
                    () => _push(context, const AchievementsPage())),
                _entry(Icons.favorite_border, l10n.favoritesEntry, favs.length.toString(),
                    () => _push(context, const FavoritesPage())),
                _entry(Icons.receipt_long_outlined, l10n.ordersEntry, orders.length.toString(),
                    () => _push(context, const OrdersPage())),
                _entry(Icons.settings_outlined, l10n.settingsEntry, '',
                    () => _push(context, const SettingsPage())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _entry(IconData icon, String title, String trailing, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing.isNotEmpty)
            Text(trailing,
                style: const TextStyle(fontSize: 12, color: Color(0xFFE8590C), fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
