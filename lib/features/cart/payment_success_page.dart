import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../orders/order_detail_page.dart';
import '../shared/snack.dart';

class PaymentSuccessPage extends ConsumerStatefulWidget {
  const PaymentSuccessPage({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends ConsumerState<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();
    // 支付后补查成就（下单事务内已解锁，这里仅做提示兜底）
    Future.microtask(() async {
      final newly = await ref.read(dbProvider).unlockAchievementsNow();
      if (newly.isNotEmpty && mounted) toastAchievements(context, newly);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    final bundles = ref.watch(ordersProvider).valueOrNull ?? const <OrderBundle>[];
    SuccessData? data;
    for (final b in bundles) {
      if (b.order.id == widget.orderId) {
        data = SuccessData(b.order.totalCents, b.order.orderNo, b.order.surpriseNote);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(painter: _ConfettiPainter(_controller.value)),
              ),
            ),
            if (data != null)
              Center(
                child: _SuccessContent(
                  controller: _controller,
                  data: data,
                  currency: currency,
                  onHome: _goHome,
                  onViewOrder: _viewOrder,
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _viewOrder() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: widget.orderId)),
    );
  }
}

class SuccessData {
  const SuccessData(this.totalCents, this.orderNo, this.surpriseNote);
  final int totalCents;
  final String orderNo;
  final String surpriseNote;
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({
    required this.controller,
    required this.data,
    required this.currency,
    required this.onHome,
    required this.onViewOrder,
  });

  final AnimationController controller;
  final SuccessData data;
  final Currency currency;
  final VoidCallback onHome;
  final VoidCallback onViewOrder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = Curves.easeOut.transform(((controller.value - 0.25) / 0.4).clamp(0.0, 1.0));
        final btnT = ((controller.value - 0.6) / 0.4).clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text(l10n.paymentSuccess, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  formatMoney(data.totalCents, currency),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                  child: Text(
                    '${l10n.orderNoLabel} ${data.orderNo}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                if (data.surpriseNote.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${l10n.surpriseBanner}  ${_surpriseText(l10n, currency, data.surpriseNote)}',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(l10n.paymentSuccessDesc, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 28),
                Opacity(
                  opacity: btnT,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        onPressed: onHome,
                        child: Text(l10n.continueShopping),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE8590C),
                        ),
                        onPressed: onViewOrder,
                        child: Text(l10n.viewOrder),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _surpriseText(AppLocalizations l10n, Currency currency, String note) {
    final parsed = parseSurprise(note);
    if (parsed == null) return '';
    return parsed.kind == 'D'
        ? l10n.paySurpriseDiscount(formatMoney(parsed.cents, currency))
        : l10n.paySurpriseRebate(formatMoney(parsed.cents, currency));
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // 背景圆
    final t = Curves.easeOutBack.transform((progress * 1.15).clamp(0.0, 1.0));
    if (t > 0) {
      canvas.drawCircle(center, size.shortestSide * 0.55 * t, Paint()..color = const Color(0xFFFF8A50));
    }
    // 打勾
    final cp = Curves.easeInOut.transform(((progress - 0.35) / 0.4).clamp(0.0, 1.0));
    if (cp > 0) {
      final path = Path()
        ..moveTo(center.dx - 58, center.dy - 6)
        ..lineTo(center.dx - 16, center.dy + 38)
        ..lineTo(center.dx + 70, center.dy - 48);
      final metric = path.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * cp),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    // 彩带粒子
    if (progress > 0.15) {
      const palette = [
        Color(0xFFFFD54F),
        Color(0xFFFF8A65),
        Color(0xFF4DD0E1),
        Color(0xFF81C784),
        Color(0xFFF48FB1),
      ];
      final rnd = Random(42);
      for (var i = 0; i < 46; i++) {
        final angle = rnd.nextDouble() * 2 * pi;
        final speed = 0.7 + rnd.nextDouble() * 0.6;
        final dist = progress * speed * size.shortestSide * 0.62;
        final pos = Offset(
          center.dx + cos(angle) * dist,
          center.dy + sin(angle) * dist + progress * progress * 70,
        );
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(angle + progress * 6);
        final w = 6.0 + rnd.nextDouble() * 6;
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: w, height: w * 0.6),
          Paint()..color = palette[i % palette.length].withValues(alpha: (1 - progress).clamp(0.0, 0.9)),
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
