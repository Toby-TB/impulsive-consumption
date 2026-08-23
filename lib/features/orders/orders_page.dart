import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logistics.dart';
import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'order_detail_page.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bundles = ref.watch(ordersProvider).valueOrNull ?? const <OrderBundle>[];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabOrders)),
      body: bundles.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📦', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text(l10n.emptyOrders, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              itemCount: bundles.length,
              itemBuilder: (context, i) => _OrderCard(bundle: bundles[i]),
            ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  const _OrderCard({required this.bundle});

  final OrderBundle bundle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(dbProvider);
    final currency = ref.watch(currencyProvider);
    final mode = ref.watch(logisticsModeProvider);
    final o = bundle.order;
    final stage = reachedStage(o.paidAt, DateTime.now(), mode);
    final itemCount = bundle.items.fold<int>(0, (s, e) => s + e.quantity);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(o.orderNo, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                const Spacer(),
                StatusChip(stage: stage),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final item in bundle.items.take(4))
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item.imagePath, width: 46, height: 46, fit: BoxFit.cover),
                    ),
                  ),
                if (bundle.items.length > 4)
                  Text('+', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(l10n.itemsCount(itemCount), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const Spacer(),
                Text('${l10n.paidAmountLabel} ',
                    style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                Text(
                  formatMoney(o.totalCents, currency),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFE8590C)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final added = await db.buyAgain(o.id);
                    if (context.mounted && added > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addedAgain)));
                    }
                  },
                  child: Text(l10n.buyAgain),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: o.id)),
                  ),
                  child: Text(l10n.viewOrder),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.stage});

  final int stage;

  static const _labels = ['stPaid', 'stProcessing', 'stShipped', 'stTransit', 'stDelivered'];
  static const _colors = [
    Color(0xFF1E88E5),
    Color(0xFFF9A825),
    Color(0xFFF4511E),
    Color(0xFF8E24AA),
    Color(0xFF43A047),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _colors[stage.clamp(0, 4)];
    String label(String key) => switch (key) {
          'stPaid' => l10n.stPaid,
          'stProcessing' => l10n.stProcessing,
          'stShipped' => l10n.stShipped,
          'stTransit' => l10n.stTransit,
          _ => l10n.stDelivered,
        };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label(_labels[stage.clamp(0, 4)]),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}
