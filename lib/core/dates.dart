/// 日期小工具（纯 Dart）。
String ymd(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String ymdYesterday(DateTime now) => ymd(now.subtract(const Duration(days: 1)));
