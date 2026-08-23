import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../data/catalog/products.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../shared/snack.dart';

class SigninPage extends ConsumerWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(dbProvider);
    final currency = ref.watch(currencyProvider);
    final summary = ref.watch(signInSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.signinTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: Text('🪙', style: TextStyle(fontSize: 64))),
            const SizedBox(height: 8),
            Center(
              child: Text(
                summary.signedToday
                    ? '${l10n.signedToday} · ${l10n.streakDays(summary.streak)}'
                    : l10n.signinTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !summary.signedToday && summary.nextStreak == i + 1
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !summary.signedToday && summary.nextStreak == i + 1
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(l10n.dayN(i + 1), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            (signinRewards[i] / 100).toStringAsFixed(0),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            summary.streak > i ? Icons.check_circle : Icons.circle_outlined,
                            size: 14,
                            color: summary.streak > i ? const Color(0xFF43A047) : Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      summary.signedToday
                          ? l10n.streakDays(summary.streak)
                          : '${l10n.signinReward(formatMoney(summary.todayRewardCents, currency))} 🎁',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.signinHint, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: summary.signedToday ? null : () => _signIn(context, ref, db),
              child: Text(summary.signedToday ? l10n.signedToday : l10n.signinNow),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context, WidgetRef ref, dynamic db) async {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencyProvider);
    final result = await db.signInToday();
    if (!context.mounted) return;
    if (result.alreadySigned) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.signedToday)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${l10n.signinReward(formatMoney(result.rewardCents, currency))} · ${l10n.streakDays(result.streak)}')),
    );
    if (result.newlyUnlocked.isNotEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (context.mounted) toastAchievements(context, result.newlyUnlocked);
    }
  }
}
