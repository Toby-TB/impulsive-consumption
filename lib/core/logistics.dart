/// 模拟物流：订单状态由「支付后经过时长」推导，重启后按真实时间正确推进。
enum LogisticsMode { fast, real }

/// 极速演示：约 3 分钟送达
const List<Duration> fastStages = [
  Duration.zero, // 已支付
  Duration(seconds: 15), // 商家备货
  Duration(seconds: 40), // 已发货
  Duration(seconds: 90), // 运输中
  Duration(seconds: 180), // 已送达
];

/// 拟真模式：1–3 天送达
const List<Duration> realStages = [
  Duration.zero,
  Duration(hours: 3),
  Duration(hours: 12),
  Duration(hours: 32),
  Duration(hours: 66),
];

List<Duration> stagesFor(LogisticsMode mode) =>
    mode == LogisticsMode.fast ? fastStages : realStages;

/// 已到达的阶段下标（0..4）。
int reachedStage(DateTime paidAt, DateTime now, LogisticsMode mode) {
  final stages = stagesFor(mode);
  final elapsed = now.difference(paidAt);
  var reached = 0;
  for (var i = 0; i < stages.length; i++) {
    if (elapsed >= stages[i]) reached = i;
  }
  return reached;
}
