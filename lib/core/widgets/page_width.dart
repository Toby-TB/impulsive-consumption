import 'package:flutter/material.dart';

/// 桌面浏览器宽度约束：让手机布局在宽屏上居中显示、不拉伸。
class PageWidth extends StatelessWidget {
  const PageWidth({super.key, required this.child, this.maxWidth = 960});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
