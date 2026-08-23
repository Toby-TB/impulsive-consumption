import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../core/achievements.dart';
import '../../core/dates.dart';
import '../catalog/products.dart';
import 'tables.dart';

part 'database.g.dart';

/// 余额不足（差额以 CNY 分计）。
class InsufficientBalanceException implements Exception {
  InsufficientBalanceException(this.shortCents);
  final int shortCents;
}

/// 签到结果。
class SignInResult {
  const SignInResult({
    required this.alreadySigned,
    required this.streak,
    required this.rewardCents,
    required this.newlyUnlocked,
  });

  final bool alreadySigned;
  final int streak;
  final int rewardCents;
  final List<String> newlyUnlocked;
}

@DriftDatabase(tables: [
  CartItems,
  Favorites,
  WalletAccount,
  WalletTransactions,
  Orders,
  OrderItems,
  Coupons,
  SignIns,
  ProductStocks,
  Achievements,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(driftDatabase(
          name: 'impulsive_consumption',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
            onResult: (result) => debugPrint(
              'drift-web: implementation=${result.chosenImplementation} '
              'missingFeatures=${result.missingFeatures}',
            ),
          ),
        ));

  @override
  int get schemaVersion => 1;

  // ---------------- 种子与维护 ----------------

  /// 每次启动调用：建钱包/发券/补建与每日重置库存。
  Future<void> seedIfNeeded() async {
    await transaction(() async {
      final account = await (select(walletAccount)..limit(1)).getSingleOrNull();
      if (account == null) {
        await into(walletAccount).insert(WalletAccountCompanion.insert(
          balanceCents: initialBalanceCents,
        ));
      }
      final existingCoupons = await select(coupons).get();
      if (existingCoupons.isEmpty) {
        for (final c in couponPresets) {
          await into(coupons).insert(CouponsCompanion.insert(
            code: c.code,
            title: Value(c.title.zh),
            kind: c.kind.index,
            value: c.value,
            thresholdCents: c.thresholdCents,
          ));
        }
      }
      final today = ymd(DateTime.now());
      for (final p in products) {
        final row = await (select(productStocks)
              ..where((t) => t.productId.equals(p.id)))
            .getSingleOrNull();
        if (row == null) {
          await into(productStocks).insert(ProductStocksCompanion.insert(
            productId: p.id,
            stock: p.stock,
            restockDate: today,
          ));
        } else if (row.restockDate != today) {
          await (update(productStocks)..where((t) => t.productId.equals(p.id)))
              .write(ProductStocksCompanion(
            stock: Value(p.stock),
            restockDate: Value(today),
          ));
        }
      }
    });
  }

  /// 一键重置演示数据：清空业务表并重新种子。
  Future<void> resetAll() async {
    await transaction(() async {
      await delete(cartItems).go();
      await delete(favorites).go();
      await delete(walletTransactions).go();
      await delete(walletAccount).go();
      await delete(orderItems).go();
      await delete(orders).go();
      await delete(coupons).go();
      await delete(signIns).go();
      await delete(productStocks).go();
      await delete(achievements).go();
    });
    await seedIfNeeded();
  }

  // ---------------- 购物车 ----------------

  Stream<List<CartItem>> watchCart() =>
      (select(cartItems)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<void> addToCart(String productId, int quantity) async {
    final existing = await (select(cartItems)
          ..where((t) => t.productId.equals(productId)))
        .getSingleOrNull();
    if (existing == null) {
      await into(cartItems).insert(CartItemsCompanion.insert(
        productId: productId,
        quantity: Value(quantity),
        selected: const Value(true),
        createdAt: DateTime.now(),
      ));
    } else {
      await (update(cartItems)..where((t) => t.id.equals(existing.id)))
          .write(CartItemsCompanion(
        quantity: Value(existing.quantity + quantity),
        selected: const Value(true),
      ));
    }
  }

  Future<void> setCartSelected(int id, bool selected) =>
      (update(cartItems)..where((t) => t.id.equals(id)))
          .write(CartItemsCompanion(selected: Value(selected)));

  Future<void> setCartQuantity(int id, int quantity) =>
      (update(cartItems)..where((t) => t.id.equals(id)))
          .write(CartItemsCompanion(quantity: Value(quantity)));

  Future<void> removeCartItem(int id) =>
      (delete(cartItems)..where((t) => t.id.equals(id))).go();

  Future<void> setAllSelected(bool selected) =>
      (update(cartItems)).write(CartItemsCompanion(selected: Value(selected)));

  Future<void> removeCartByIds(List<int> ids) async {
    for (final id in ids) {
      await (delete(cartItems)..where((t) => t.id.equals(id))).go();
    }
  }

  Future<void> clearCart() => delete(cartItems).go();

  // ---------------- 收藏 ----------------

  Stream<Set<String>> watchFavoriteIds() =>
      select(favorites).watch().map((rows) => rows.map((r) => r.productId).toSet());

  Future<bool> toggleFavorite(String productId) async {
    final existing = await (select(favorites)
          ..where((t) => t.productId.equals(productId)))
        .getSingleOrNull();
    if (existing == null) {
      await into(favorites).insert(FavoritesCompanion.insert(
        productId: productId,
        createdAt: DateTime.now(),
      ));
      return true;
    }
    await (delete(favorites)..where((t) => t.productId.equals(productId))).go();
    return false;
  }

  // ---------------- 钱包 ----------------

  Stream<WalletAccountData?> watchAccount() =>
      (select(walletAccount)..limit(1)).watchSingleOrNull();

  Stream<List<WalletTransaction>> watchTransactions() =>
      (select(walletTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(100))
          .watch();

  Future<void> recharge(int cnyCents, {String note = ''}) async {
    await transaction(() async {
      final acc = await (select(walletAccount)..limit(1)).getSingleOrNull();
      if (acc == null) throw StateError('wallet missing');
      final after = acc.balanceCents + cnyCents;
      await (update(walletAccount)..where((t) => t.id.equals(acc.id)))
          .write(WalletAccountCompanion(balanceCents: Value(after)));
      await into(walletTransactions).insert(WalletTransactionsCompanion.insert(
        type: 'recharge',
        amountCents: cnyCents,
        balanceAfterCents: after,
        note: Value(note),
        createdAt: DateTime.now(),
      ));
    });
  }

  // ---------------- 订单 ----------------

  Stream<List<Order>> watchOrders() =>
      (select(orders)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Stream<List<OrderItem>> watchOrderItems(int orderId) =>
      (select(orderItems)..where((t) => t.orderId.equals(orderId))).watch();

  Future<List<OrderItem>> orderItemsOf(int orderId) =>
      (select(orderItems)..where((t) => t.orderId.equals(orderId))).get();

  Future<Order?> orderById(int id) =>
      (select(orders)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// 下单支付：单事务原子完成（校验余额→彩蛋→扣款→订单→扣库存→核销券→流水→成就）。
  Future<int> placeOrder({
    required List<({String productId, int quantity})> items,
    required int subtotalCents,
    required int couponDiscountCents,
    int? couponId,
    String couponTitle = '',
  }) async {
    return transaction(() async {
      final acc = await (select(walletAccount)..limit(1)).getSingleOrNull();
      if (acc == null) throw StateError('wallet missing');

      // 支付彩蛋：约 30% 概率触发惊喜立减/返币（纯本地随机）
      var surpriseDiscount = 0;
      var rebate = 0;
      var surpriseNote = '';
      final beforeSurprise = subtotalCents - couponDiscountCents;
      if (beforeSurprise > 100 && Random().nextInt(100) < 30) {
        final kind = Random().nextInt(3);
        if (kind == 0) {
          surpriseDiscount = 500;
          surpriseNote = 'D500';
        } else if (kind == 1) {
          surpriseDiscount = 1000;
          surpriseNote = 'D1000';
        } else {
          rebate = min(2000, max(0, beforeSurprise * 8 ~/ 100));
          surpriseNote = 'R${rebate.toString()}';
        }
      }
      var discount = couponDiscountCents + surpriseDiscount;
      var total = subtotalCents - discount;
      if (total < 1) {
        discount = subtotalCents - 1;
        total = 1;
      }
      if (acc.balanceCents < total) {
        throw InsufficientBalanceException(total - acc.balanceCents);
      }

      final now = DateTime.now();
      final rnd = Random();
      final orderNo = 'IC${now.year}${_two(now.month)}${_two(now.day)}'
          '${_two(now.hour)}${_two(now.minute)}${_two(now.second)}'
          '${rnd.nextInt(9000) + 1000}';
      final orderId = await into(orders).insert(OrdersCompanion.insert(
        orderNo: orderNo,
        totalCents: total,
        discountCents: Value(discount),
        couponTitle: Value(couponTitle),
        surpriseNote: Value(surpriseNote),
        createdAt: now,
        paidAt: now,
      ));
      for (final item in items) {
        final p = productById(item.productId);
        if (p != null) {
          await into(orderItems).insert(OrderItemsCompanion.insert(
            orderId: orderId,
            productId: p.id,
            name: Value(p.name.zh),
            imagePath: Value(p.imagePath),
            unitPriceCents: p.priceCents,
            quantity: item.quantity,
          ));
          final stockRow = await (select(productStocks)
                ..where((t) => t.productId.equals(p.id)))
              .getSingleOrNull();
          if (stockRow != null) {
            await (update(productStocks)
                  ..where((t) => t.productId.equals(p.id)))
                .write(ProductStocksCompanion(
              stock: Value(max(0, stockRow.stock - item.quantity)),
            ));
          }
        }
      }
      final after = acc.balanceCents - total;
      await (update(walletAccount)..where((t) => t.id.equals(acc.id)))
          .write(WalletAccountCompanion(balanceCents: Value(after)));
      await into(walletTransactions).insert(WalletTransactionsCompanion.insert(
        type: 'payment',
        amountCents: -total,
        balanceAfterCents: after,
        note: Value(orderNo),
        createdAt: now,
      ));
      if (rebate > 0) {
        final afterRebate = after + rebate;
        await (update(walletAccount)..where((t) => t.id.equals(acc.id)))
            .write(WalletAccountCompanion(balanceCents: Value(afterRebate)));
        await into(walletTransactions)
            .insert(WalletTransactionsCompanion.insert(
          type: 'rebate',
          amountCents: rebate,
          balanceAfterCents: afterRebate,
          note: Value(orderNo),
          createdAt: now,
        ));
      }
      if (couponId != null) {
        await (update(coupons)..where((t) => t.id.equals(couponId)))
            .write(CouponsCompanion(usedAt: Value(now)));
      }
      await unlockAchievementsNow();
      return orderId;
    });
  }

  /// 再次购买：按当前库存把订单商品加回购物车，返回实际加入数量。
  Future<int> buyAgain(int orderId) async {
    final items = await orderItemsOf(orderId);
    var added = 0;
    for (final item in items) {
      final stockRow = await (select(productStocks)
            ..where((t) => t.productId.equals(item.productId)))
          .getSingleOrNull();
      final stock = stockRow?.stock ?? 0;
      if (stock > 0) {
        final qty = min(stock, item.quantity);
        await addToCart(item.productId, qty);
        added += qty;
      }
    }
    return added;
  }

  // ---------------- 优惠券 ----------------

  Stream<List<Coupon>> watchCoupons() => select(coupons).watch();

  // ---------------- 库存 ----------------

  Stream<Map<String, int>> watchStocks() =>
      select(productStocks).watch().map((rows) {
        return {for (final r in rows) r.productId: r.stock};
      });

  // ---------------- 签到 ----------------

  Stream<List<SignIn>> watchSignIns() => select(signIns).watch();

  Future<SignInResult> signInToday() async {
    return transaction(() async {
      final today = ymd(DateTime.now());
      final existing = await (select(signIns)..where((t) => t.date.equals(today)))
          .getSingleOrNull();
      if (existing != null) {
        return SignInResult(
          alreadySigned: true,
          streak: existing.streak,
          rewardCents: 0,
          newlyUnlocked: const [],
        );
      }
      final yesterday = ymdYesterday(DateTime.now());
      final last = await (select(signIns)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();
      final streak = (last != null && last.date == yesterday) ? last.streak + 1 : 1;
      final reward = signinRewards[(streak - 1) % signinRewards.length];
      await into(signIns).insert(SignInsCompanion.insert(
        date: today,
        streak: streak,
        rewardCents: reward,
        createdAt: DateTime.now(),
      ));
      final acc = await (select(walletAccount)..limit(1)).getSingleOrNull();
      if (acc == null) throw StateError('wallet missing');
      final after = acc.balanceCents + reward;
      await (update(walletAccount)..where((t) => t.id.equals(acc.id)))
          .write(WalletAccountCompanion(balanceCents: Value(after)));
      await into(walletTransactions).insert(WalletTransactionsCompanion.insert(
        type: 'signin',
        amountCents: reward,
        balanceAfterCents: after,
        note: Value('签到第$streak 天'),
        createdAt: DateTime.now(),
      ));
      final newly = await unlockAchievementsNow();
      return SignInResult(
        alreadySigned: false,
        streak: streak,
        rewardCents: reward,
        newlyUnlocked: newly,
      );
    });
  }

  // ---------------- 成就 ----------------

  Stream<List<Achievement>> watchAchievements() => select(achievements).watch();

  /// 按当前统计解锁满足条件的成就，返回新解锁的 key 列表。
  Future<List<String>> unlockAchievementsNow() async {
    final orderRows = await select(orders).get();
    final orderCount = orderRows.length;
    final totalSpent =
        orderRows.fold<int>(0, (sum, o) => sum + o.totalCents);
    final favCount = (await select(favorites).get()).length;
    final signRows = await select(signIns).get();
    var maxStreak = 0;
    for (final r in signRows) {
      if (r.streak > maxStreak) maxStreak = r.streak;
    }
    final unlocked =
        (await select(achievements).get()).map((a) => a.key).toSet();
    final newly = <String>[];
    void check(String key, bool condition) {
      if (condition && !unlocked.contains(key)) newly.add(key);
    }

    check('first_order', orderCount >= 1);
    check('shopaholic', orderCount >= 10);
    check('week_streak', maxStreak >= 7);
    check('collector', favCount >= 10);
    check('big_spender', totalSpent >= bigSpenderThresholdCents);
    for (final key in newly) {
      await into(achievements).insert(AchievementsCompanion.insert(
        key: key,
        unlockedAt: DateTime.now(),
      ));
    }
    return newly;
  }

  // ---------------- 设置 ----------------

  Stream<Map<String, String>> watchSettings() =>
      select(settings).watch().map((rows) => {for (final r in rows) r.key: r.value});

  Future<void> setSetting(String key, String value) =>
      into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: value),
      );

  static String _two(int n) => n.toString().padLeft(2, '0');
}
