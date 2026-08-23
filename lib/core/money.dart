/// 金额与货币换算（纯 Dart，可单测）。
/// 全库以「CNY 分」为基准存储整数，显示时按当前货币换算。
enum Currency {
  cny('CNY', '¥', 1.0),
  hkd('HKD', r'HK$', 0.92),
  usd('USD', r'US$', 7.20);

  const Currency(this.code, this.symbol, this.cnyPerUnit);

  /// 显示代码（存库用）
  final String code;

  /// 货币符号
  final String symbol;

  /// 1 单位该货币折合多少 CNY（纯模拟固定汇率）
  final double cnyPerUnit;

  static Currency fromCode(String? code) =>
      values.firstWhere((c) => c.code == code, orElse: () => Currency.cny);
}

/// 把 CNY 分换算为当前货币的显示金额（带符号，两位小数）。
String formatMoney(int cnyCents, Currency currency) {
  final foreignCents = cnyCents / currency.cnyPerUnit;
  final amount = (foreignCents / 100).toStringAsFixed(2);
  return '${currency.symbol}$amount';
}

/// 把用户输入的当前货币金额换算回 CNY 分。
int toCnyCents(double amount, Currency currency) =>
    (amount * 100 * currency.cnyPerUnit).round();

/// 解析订单惊喜备注：'D500' = 立减 ¥5，'R1200' = 返币 ¥12。
/// 返回 (kind: 'D'|'R', cents) 或 null。
({String kind, int cents})? parseSurprise(String note) {
  if (note.isEmpty) return null;
  final kind = note.substring(0, 1);
  final cents = int.tryParse(note.substring(1));
  if (cents == null || (kind != 'D' && kind != 'R')) return null;
  return (kind: kind, cents: cents);
}
