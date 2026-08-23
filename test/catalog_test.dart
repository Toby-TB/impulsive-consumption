import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/achievements.dart';
import 'package:impulsive_consumption/data/catalog/products.dart';

void main() {
  test('商品 id 唯一且字段合法', () {
    final ids = <String>{};
    for (final p in products) {
      expect(ids.contains(p.id), false, reason: '重复 id: ${p.id}');
      ids.add(p.id);
      expect(p.priceCents > 0, true, reason: '${p.id} 价格非法');
      expect(p.stock > 0, true, reason: '${p.id} 库存非法');
      expect(p.monthlySales >= 0, true);
      expect(p.rating >= 0 && p.rating <= 5, true);
      expect(p.imagePath.isNotEmpty, true);
      expect(productById(p.id), isNotNull);
    }
    expect(products.length, greaterThanOrEqualTo(28));
  });

  test('每个分类至少一个商品且商品分类合法', () {
    final categoryIds = categories.map((c) => c.id).toSet();
    for (final p in products) {
      expect(categoryIds.contains(p.categoryId), true, reason: '${p.id} 分类非法');
    }
    for (final c in categories) {
      expect(products.any((p) => p.categoryId == c.id), true, reason: '分类 ${c.id} 为空');
    }
  });

  test('优惠券预设合法', () {
    final codes = couponPresets.map((c) => c.code).toSet();
    expect(codes.length, couponPresets.length, reason: '优惠券 code 重复');
    for (final c in couponPresets) {
      expect(c.value > 0, true);
      expect(c.thresholdCents > 0, true);
    }
  });

  test('签到奖励 7 天循环', () {
    expect(signinRewards.length, 7);
    for (final r in signinRewards) {
      expect(r > 0, true);
    }
  });

  test('成就定义完整', () {
    expect(achievementDefs.length, 5);
    final keys = achievementDefs.map((a) => a.key).toSet();
    expect(keys.length, 5);
  });
}
