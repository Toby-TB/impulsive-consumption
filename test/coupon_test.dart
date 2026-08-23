import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/coupon_logic.dart';

void main() {
  group('computeDiscount 满减', () {
    test('未达门槛不优惠', () {
      expect(computeDiscount(subtotalCents: 4000, kind: CouponKind.fixed, value: 1000, thresholdCents: 5000), 0);
    });

    test('达到门槛全额减免', () {
      expect(computeDiscount(subtotalCents: 5000, kind: CouponKind.fixed, value: 1000, thresholdCents: 5000), 1000);
    });

    test('优惠不超过商品总额', () {
      expect(computeDiscount(subtotalCents: 6000, kind: CouponKind.fixed, value: 10000, thresholdCents: 5000), 6000);
    });
  });

  group('computeDiscount 折扣', () {
    test('九折券', () {
      expect(computeDiscount(subtotalCents: 20000, kind: CouponKind.percent, value: 90, thresholdCents: 10000), 2000);
    });

    test('未达门槛折扣券失效', () {
      expect(computeDiscount(subtotalCents: 5000, kind: CouponKind.percent, value: 90, thresholdCents: 10000), 0);
    });
  });
}
