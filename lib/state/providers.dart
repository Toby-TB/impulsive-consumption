import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../core/logistics.dart';
import '../core/money.dart';
import '../data/catalog/products.dart';
import '../data/db/database.dart';

/// 数据库单例。
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// 启动初始化：种子/补货。
final appInitProvider = FutureProvider<void>(
  (ref) => ref.watch(dbProvider).seedIfNeeded(),
);

/// 设置流（key -> value）。
final settingsStreamProvider = StreamProvider<Map<String, String>>(
  (ref) => ref.watch(dbProvider).watchSettings(),
);

/// 当前货币。
final currencyProvider = Provider<Currency>((ref) {
  final settings = ref.watch(settingsStreamProvider).valueOrNull;
  return Currency.fromCode(settings?['currency']);
});

/// 当前语言代码：zh / zhHant / en。
final localeCodeProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsStreamProvider).valueOrNull;
  return settings?['locale'] ?? 'zh';
});

/// 主题代码：system / light / dark。
final themeCodeProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsStreamProvider).valueOrNull;
  return settings?['theme'] ?? 'system';
});

/// 物流档位。
final logisticsModeProvider = Provider<LogisticsMode>((ref) {
  final settings = ref.watch(settingsStreamProvider).valueOrNull;
  return (settings?['logistics'] ?? 'fast') == 'real'
      ? LogisticsMode.real
      : LogisticsMode.fast;
});

/// 购物车。
final cartProvider = StreamProvider<List<CartItem>>(
  (ref) => ref.watch(dbProvider).watchCart(),
);

final cartCountProvider = StreamProvider<int>(
  (ref) => ref
      .watch(dbProvider)
      .watchCart()
      .map((l) => l.fold(0, (sum, e) => sum + e.quantity)),
);

final cartSelectedCountProvider = StreamProvider<int>(
  (ref) => ref
      .watch(dbProvider)
      .watchCart()
      .map((l) => l.where((e) => e.selected).fold(0, (sum, e) => sum + e.quantity)),
);

/// 收藏商品 id 集合。
final favoritesProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(dbProvider).watchFavoriteIds(),
);

/// 库存映射。
final stocksProvider = StreamProvider<Map<String, int>>(
  (ref) => ref.watch(dbProvider).watchStocks(),
);

/// 钱包余额。
final walletAccountProvider = StreamProvider<WalletAccountData?>(
  (ref) => ref.watch(dbProvider).watchAccount(),
);

/// 钱包流水。
final walletTxnsProvider = StreamProvider<List<WalletTransaction>>(
  (ref) => ref.watch(dbProvider).watchTransactions(),
);

/// 优惠券。
final couponsProvider = StreamProvider<List<Coupon>>(
  (ref) => ref.watch(dbProvider).watchCoupons(),
);

/// 签到记录。
final signInsProvider = StreamProvider<List<SignIn>>(
  (ref) => ref.watch(dbProvider).watchSignIns(),
);

/// 签到摘要。
class SignInSummary {
  const SignInSummary({
    required this.signedToday,
    required this.streak,
    required this.nextStreak,
    required this.todayRewardCents,
  });

  final bool signedToday;
  final int streak; // 当前连续天数
  final int nextStreak; // 下次签到会达到的天数
  final int todayRewardCents; // 下次签到奖励
}

final signInSummaryProvider = Provider<SignInSummary>((ref) {
  final rows = ref.watch(signInsProvider).valueOrNull ?? const <SignIn>[];
  final now = DateTime.now();
  final today = ymd(now);
  final yesterday = ymdYesterday(now);
  SignIn? last;
  for (final r in rows) {
    if (last == null || r.createdAt.isAfter(last.createdAt)) last = r;
  }
  final signedToday = last?.date == today;
  final streak = signedToday
      ? (last?.streak ?? 0)
      : (last != null && last.date == yesterday ? last.streak : 0);
  final nextStreak = signedToday ? streak : (streak + 1);
  final reward = signinRewards[(nextStreak - 1) % signinRewards.length];
  return SignInSummary(
    signedToday: signedToday,
    streak: streak,
    nextStreak: nextStreak,
    todayRewardCents: signedToday ? 0 : reward,
  );
});

/// 成就。
final achievementsProvider = StreamProvider<List<Achievement>>(
  (ref) => ref.watch(dbProvider).watchAchievements(),
);

/// 订单 + 明细组合。
class OrderBundle {
  const OrderBundle(this.order, this.items);
  final Order order;
  final List<OrderItem> items;
}

final ordersProvider = StreamProvider<List<OrderBundle>>((ref) {
  final db = ref.watch(dbProvider);
  return db.watchOrders().asyncMap((orders) async {
    final bundles = <OrderBundle>[];
    for (final o in orders) {
      final items = await db.orderItemsOf(o.id);
      bundles.add(OrderBundle(o, items));
    }
    return bundles;
  });
});

/// 结算页直购项（详情页"立即购买"）。
class DirectItem {
  const DirectItem(this.productId, this.quantity);
  final String productId;
  final int quantity;
}
