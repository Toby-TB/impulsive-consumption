/// 轻量成就系统：5 个趣味成就的静态定义。
class AchievementDef {
  const AchievementDef(this.key, this.icon);

  /// 数据库主键
  final String key;

  /// 徽章 emoji
  final String icon;
}

const List<AchievementDef> achievementDefs = [
  AchievementDef('first_order', '🎉'),
  AchievementDef('shopaholic', '🛍️'),
  AchievementDef('week_streak', '🔥'),
  AchievementDef('collector', '⭐'),
  AchievementDef('big_spender', '💰'),
];

/// 「挥金如土」门槛：累计消费 ¥50,000 = 5,000,000 分
const int bigSpenderThresholdCents = 5000000;

/// 成就名（按 l10n key 映射），UI 层使用。
String achievementNameKey(String key) => switch (key) {
      'first_order' => 'achFirstOrder',
      'shopaholic' => 'achShopaholic',
      'week_streak' => 'achWeekStreak',
      'collector' => 'achCollector',
      'big_spender' => 'achBigSpender',
      _ => 'achFirstOrder',
    };

String achievementDescKey(String key) => switch (key) {
      'first_order' => 'achFirstOrderDesc',
      'shopaholic' => 'achShopaholicDesc',
      'week_streak' => 'achWeekStreakDesc',
      'collector' => 'achCollectorDesc',
      'big_spender' => 'achBigSpenderDesc',
      _ => 'achFirstOrderDesc',
    };
