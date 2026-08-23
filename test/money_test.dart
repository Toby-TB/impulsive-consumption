import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/money.dart';

void main() {
  group('formatMoney', () {
    test('CNY 保留两位小数', () {
      expect(formatMoney(123456, Currency.cny), '¥1234.56');
      expect(formatMoney(0, Currency.cny), '¥0.00');
      expect(formatMoney(5, Currency.cny), '¥0.05');
    });

    test('HKD 按固定汇率换算', () {
      expect(formatMoney(123456, Currency.hkd), r'HK$1341.91');
    });

    test('USD 按固定汇率换算', () {
      expect(formatMoney(123456, Currency.usd), r'US$171.47');
    });
  });

  group('toCnyCents', () {
    test('反向换算回 CNY 分', () {
      expect(toCnyCents(100, Currency.cny), 10000);
      expect(toCnyCents(100, Currency.usd), 72000);
      expect(toCnyCents(1.5, Currency.cny), 150);
    });
  });

  group('parseSurprise', () {
    test('解析立减与返币备注', () {
      expect(parseSurprise('D500'), (kind: 'D', cents: 500));
      expect(parseSurprise('R1200'), (kind: 'R', cents: 1200));
      expect(parseSurprise(''), null);
      expect(parseSurprise('X100'), null);
    });
  });
}
