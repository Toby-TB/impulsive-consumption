import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/logistics.dart';
import '../../core/widgets/page_width.dart';
import '../../core/money.dart';
import '../../data/catalog/products.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'orders_page.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
    final localeCode = ref.watch(localeCodeProvider);
    final currency = ref.watch(currencyProvider);
    final mode = ref.watch(logisticsModeProvider);
    final bundles = ref.watch(ordersProvider).valueOrNull ?? const <OrderBundle>[];
    OrderBundle? bundle;
    for (final b in bundles) {
      if (b.order.id == widget.orderId) bundle = b;
    }
    if (bundle == null) {
      return Scaffold(appBar: AppBar(title: Text(l10n.orderDetailTitle)), body: const Center(child: CircularProgressIndicator()));
    }
    final o = bundle.order;
    final stage = reachedStage(o.paidAt, DateTime.now(), mode);
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderDetailTitle)),
      body: PageWidth(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Text('📦', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusChip(stage: stage),
                        const SizedBox(height: 6),
                        Text(l10n.logisticsDemoHint, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.logisticsTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  _Timeline(paidAt: o.paidAt, stage: stage, mode: mode),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.orderItems, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  for (final item in bundle.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(item.imagePath, width: 46, height: 46, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productById(item.productId)?.name.resolve(localeCode) ?? item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${formatMoney(item.unitPriceCents, currency)} × ${item.quantity}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatMoney(item.unitPriceCents * item.quantity, currency),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text(l10n.priceBreakdown, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text(l10n.subtotalLabel, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    const Spacer(),
                    Text(formatMoney(o.totalCents + o.discountCents, currency),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                  if (o.discountCents > 0) ...[
                    const SizedBox(height: 6),
                    Row(children: [
                      Text('${l10n.discountLabel}${o.couponTitle.isNotEmpty ? '（${o.couponTitle}）' : ''}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const Spacer(),
                      Text('- ${formatMoney(o.discountCents, currency)}',
                          style: const TextStyle(fontSize: 13, color: Color(0xFFE8590C), fontWeight: FontWeight.w700)),
                    ]),
                  ],
                  const Divider(height: 16),
                  Row(children: [
                    Text(l10n.paidAmountLabel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text(formatMoney(o.totalCents, currency),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFFE8590C))),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(children: [
                    Text(l10n.orderNoLabel, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    const Spacer(),
                    Text(o.orderNo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text(l10n.orderTime, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    const Spacer(),
                    Text(fmt.format(o.createdAt), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text(l10n.trackNoLabel, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    const Spacer(),
                    Text('SF${o.orderNo}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () async {
              final db = ref.read(dbProvider);
              final added = await db.buyAgain(widget.orderId);
              if (context.mounted && added > 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addedAgain)));
              }
            },
            child: Text(l10n.buyAgain),
          ),
        ],
      ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.paidAt, required this.stage, required this.mode});

  final DateTime paidAt;
  final int stage;
  final LogisticsMode mode;

  static const _labelKeys = ['stPaid', 'stProcessing', 'stShipped', 'stTransit', 'stDelivered'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stages = stagesFor(mode);
    final color = Theme.of(context).colorScheme.primary;
    final fmt = DateFormat('HH:mm:ss');
    String label(String key) => switch (key) {
          'stPaid' => l10n.stPaid,
          'stProcessing' => l10n.stProcessing,
          'stShipped' => l10n.stShipped,
          'stTransit' => l10n.stTransit,
          _ => l10n.stDelivered,
        };
    return Column(
      children: [
        for (var i = 0; i < stages.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= stage ? color : Colors.grey.shade300,
                    ),
                    child: i < stage
                        ? const Icon(Icons.check, size: 15, color: Colors.white)
                        : i == stage
                            ? const Padding(
                                padding: EdgeInsets.all(6),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                ),
                              )
                            : null,
                  ),
                  if (i < stages.length - 1)
                    Container(width: 3, height: 34, color: i < stage ? color : Colors.grey.shade200),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label(_labelKeys[i]),
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: i <= stage ? FontWeight.w700 : FontWeight.w500,
                          color: i <= stage ? null : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        i <= stage ? fmt.format(paidAt.add(stages[i])) : '--:--:--',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
