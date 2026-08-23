import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/achievements.dart';
import '../../core/widgets/page_width.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../shared/snack.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unlocked = ref.watch(achievementsProvider).valueOrNull ?? const [];
    final unlockedKeys = unlocked.map((a) => a.key).toSet();
    final unlockedAt = {for (final a in unlocked) a.key: a.unlockedAt};
    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsTitle)),
      body: PageWidth(
        maxWidth: 720,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
        itemCount: achievementDefs.length,
        itemBuilder: (context, i) {
          final def = achievementDefs[i];
          final done = unlockedKeys.contains(def.key);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: done ? const Color(0xFFFFF0E4) : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        done ? def.icon : '🔒',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievementTitle(l10n, def.key),
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: done ? null : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _desc(l10n, def.key),
                          style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                        ),
                        if (done) ...[
                          const SizedBox(height: 3),
                          Text(
                            DateFormat('yyyy-MM-dd').format(unlockedAt[def.key]!),
                            style: const TextStyle(fontSize: 10, color: Color(0xFFE8590C)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (done)
                    const Icon(Icons.check_circle, color: Color(0xFF43A047))
                  else
                    Text(l10n.locked, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  String _desc(AppLocalizations l10n, String key) => switch (key) {
        'first_order' => l10n.achFirstOrderDesc,
        'shopaholic' => l10n.achShopaholicDesc,
        'week_streak' => l10n.achWeekStreakDesc,
        'collector' => l10n.achCollectorDesc,
        'big_spender' => l10n.achBigSpenderDesc,
        _ => '',
      };
}
