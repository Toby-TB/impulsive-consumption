import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// 成就名本地化。
String achievementTitle(AppLocalizations l10n, String key) => switch (key) {
      'first_order' => l10n.achFirstOrder,
      'shopaholic' => l10n.achShopaholic,
      'week_streak' => l10n.achWeekStreak,
      'collector' => l10n.achCollector,
      'big_spender' => l10n.achBigSpender,
      _ => '',
    };

/// 新解锁成就逐一弹提示。
void toastAchievements(BuildContext context, List<String> keys) {
  final l10n = AppLocalizations.of(context);
  for (final key in keys) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.achievementUnlocked(achievementTitle(l10n, key)))),
    );
  }
}
