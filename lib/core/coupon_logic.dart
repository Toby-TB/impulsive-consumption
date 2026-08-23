/// 优惠券折扣计算（纯函数，可单测）。
enum CouponKind { fixed, percent }

/// 计算优惠金额（CNY 分）；未达门槛返回 0。
int computeDiscount({
  required int subtotalCents,
  required CouponKind kind,
  required int value,
  required int thresholdCents,
}) {
  if (subtotalCents < thresholdCents) return 0;
  if (kind == CouponKind.fixed) {
    return value > subtotalCents ? subtotalCents : value;
  }
  // percent：value 表示折后支付百分比（90 = 9 折）
  final pay = subtotalCents * value ~/ 100;
  return subtotalCents - pay;
}
