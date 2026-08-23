import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/logistics.dart';

void main() {
  final paidAt = DateTime(2026, 8, 23, 12, 0, 0);

  group('极速演示档', () {
    test('阶段随经过时长推进', () {
      expect(reachedStage(paidAt, paidAt, LogisticsMode.fast), 0);
      expect(reachedStage(paidAt, paidAt.add(const Duration(seconds: 10)), LogisticsMode.fast), 0);
      expect(reachedStage(paidAt, paidAt.add(const Duration(seconds: 20)), LogisticsMode.fast), 1);
      expect(reachedStage(paidAt, paidAt.add(const Duration(seconds: 50)), LogisticsMode.fast), 2);
      expect(reachedStage(paidAt, paidAt.add(const Duration(seconds: 120)), LogisticsMode.fast), 3);
      expect(reachedStage(paidAt, paidAt.add(const Duration(seconds: 200)), LogisticsMode.fast), 4);
    });
  });

  group('拟真档', () {
    test('阶段按小时/天推进', () {
      expect(reachedStage(paidAt, paidAt.add(const Duration(hours: 2)), LogisticsMode.real), 0);
      expect(reachedStage(paidAt, paidAt.add(const Duration(hours: 4)), LogisticsMode.real), 1);
      expect(reachedStage(paidAt, paidAt.add(const Duration(hours: 20)), LogisticsMode.real), 2);
      expect(reachedStage(paidAt, paidAt.add(const Duration(hours: 40)), LogisticsMode.real), 3);
      expect(reachedStage(paidAt, paidAt.add(const Duration(hours: 70)), LogisticsMode.real), 4);
    });
  });

  test('重启后按真实时间推进（未来时刻回查）', () {
    // 支付后 5 分钟再打开 App（模拟重启），极速档应已送达
    expect(reachedStage(paidAt, paidAt.add(const Duration(minutes: 5)), LogisticsMode.fast), 4);
  });
}
