import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/coupon_logic.dart';
import '../../core/money.dart';
import '../../data/catalog/products.dart';
import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../wallet/recharge_page.dart';
import 'payment_success_page.dart';

/// 优惠券本地化标题（数据库存简体快照，按 code 匹配目录拿三语）。
String couponTitleLocalized(Coupon coupon, String localeCode) {
  for (final preset in couponPresets) {
    if (preset.code == coupon.code) return preset.title.resolve(localeCode);
  }
  return coupon.title;
}

String couponDiscountText(Coupon coupon, Currency currency, AppLocalizations l10n) {
  return coupon.kind == CouponKind.fixed.index
      ? l10n.couponDiscountFixed(formatMoney(coupon.value, currency))
      : l10n.couponDiscountPercent('${coupon.value ~/ 10}');
}

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key, this.directItem});

  /// 详情页"立即购买"直达；为 null 时结算购物车勾选项。
  final DirectItem? directItem;

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  Coupon? _selected;

  List<({String productId, int quantity})> _items() {
    final direct = widget.directItem;
    if (direct != null) {
      return [(productId: direct.productId, quantity: direct.quantity)];
    }
    final cart = ref.read(cartProvider).valueOrNull ?? const <dynamic>[];
    return [
      for (final e in cart.where((e) => e.selected))
        (productId: e.productId as String, quantity: e.quantity as int),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    final localeCode = ref.watch(localeCodeProvider);
    final coupons = ref.watch(couponsProvider).valueOrNull ?? const <Coupon>[];
    final items = _items();
    final subtotal = items.fold<int>(0, (sum, e) {
      final p = productById(e.productId);
      return sum + (p == null ? 0 : p.priceCents * e.quantity);
    });
    final available = coupons
        .where((c) => c.usedAt == null && c.thresholdCents <= subtotal)
        .toList();
    final selected = _selected != null && available.any((c) => c.id == _selected!.id)
        ? _selected
        : null;
    final discount = selected == null
        ? 0
        : computeDiscount(
            subtotalCents: subtotal,
            kind: CouponKind.values[selected.kind],
            value: selected.value,
            thresholdCents: selected.thresholdCents,
          );
    final payable = subtotal - discount;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.orderItems, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  for (final item in items)
                    _itemRow(l10n, currency, localeCode, item.productId, item.quantity),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              leading: const Icon(Icons.confirmation_number_outlined, color: Color(0xFFE8590C)),
              title: Text(l10n.couponLabel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              subtitle: selected == null
                  ? Text(l10n.couponNone, style: const TextStyle(fontSize: 12, color: Colors.grey))
                  : Text(couponDiscountText(selected, currency, l10n),
                      style: const TextStyle(fontSize: 12, color: Color(0xFFE8590C), fontWeight: FontWeight.w700)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _pickCoupon(available, currency, localeCode),
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
                  _row(l10n.subtotalLabel, formatMoney(subtotal, currency), Colors.grey, 13),
                  const SizedBox(height: 6),
                  if (discount > 0) ...[
                    _row(l10n.discountLabel, '- ${formatMoney(discount, currency)}', const Color(0xFFE8590C), 13),
                    const SizedBox(height: 6),
                  ],
                  const Divider(height: 14),
                  _row(l10n.payableLabel, formatMoney(payable, currency), const Color(0xFFE8590C), 17),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('🚚 ${l10n.freeShipping}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.payableLabel, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                    formatMoney(payable, currency),
                    style: const TextStyle(color: Color(0xFFE8590C), fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
                onPressed: _pay,
                child: Text(l10n.payNow),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemRow(AppLocalizations l10n, Currency currency, String localeCode, String productId, int quantity) {
    final p = productById(productId);
    if (p == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(p.imagePath, width: 46, height: 46, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name.resolve(localeCode),
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(
                  '${formatMoney(p.priceCents, currency)} × $quantity',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            formatMoney(p.priceCents * quantity, currency),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color color, double size) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: size, color: Colors.grey)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Future<void> _pickCoupon(List<Coupon> available, Currency currency, String localeCode) async {
    final l10n = AppLocalizations.of(context);
    final chosen = await showModalBottomSheet<Object>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(l10n.couponLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            ListTile(
              leading: Icon(
                _selected == null ? Icons.radio_button_checked : Icons.radio_button_off,
                color: _selected == null ? const Color(0xFFE8590C) : Colors.grey,
              ),
              title: Text(l10n.couponNone),
              onTap: () => Navigator.pop(ctx, const _NoCoupon()),
            ),
            for (final c in available)
              ListTile(
                leading: Icon(
                  _selected?.id == c.id ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: _selected?.id == c.id ? const Color(0xFFE8590C) : Colors.grey,
                ),
                title: Text(couponTitleLocalized(c, localeCode), style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(l10n.couponBelowThreshold(formatMoney(c.thresholdCents, currency))),
                trailing: Text(
                  couponDiscountText(c, currency, l10n),
                  style: const TextStyle(color: Color(0xFFE8590C), fontWeight: FontWeight.w700),
                ),
                onTap: () => Navigator.pop(ctx, c),
              ),
          ],
        ),
      ),
    );
    if (chosen is Coupon) setState(() => _selected = chosen);
    if (chosen is _NoCoupon) setState(() => _selected = null);
  }

  Future<void> _pay() async {
    final l10n = AppLocalizations.of(context);
    final db = ref.read(dbProvider);
    final currency = ref.read(currencyProvider);
    final localeCode = ref.read(localeCodeProvider);
    final items = _items();
    final subtotal = items.fold<int>(0, (sum, e) {
      final p = productById(e.productId);
      return sum + (p == null ? 0 : p.priceCents * e.quantity);
    });
    final available = (ref.read(couponsProvider).valueOrNull ?? const <Coupon>[])
        .where((c) => c.usedAt == null && c.thresholdCents <= subtotal)
        .toList();
    final selected = _selected != null && available.any((c) => c.id == _selected!.id) ? _selected : null;
    final discount = selected == null
        ? 0
        : computeDiscount(
            subtotalCents: subtotal,
            kind: CouponKind.values[selected.kind],
            value: selected.value,
            thresholdCents: selected.thresholdCents,
          );
    final cartMode = widget.directItem == null;
    final paidCartIds = cartMode
        ? [
            for (final e in (ref.read(cartProvider).valueOrNull ?? const <dynamic>[]))
              if (e.selected) e.id as int,
          ]
        : const <int>[];
    try {
      final orderId = await db.placeOrder(
        items: items,
        subtotalCents: subtotal,
        couponDiscountCents: discount,
        couponId: selected?.id,
        couponTitle: selected == null ? '' : couponTitleLocalized(selected, localeCode),
      );
      if (cartMode) await db.removeCartByIds(paidCartIds);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PaymentSuccessPage(orderId: orderId)),
      );
    } on InsufficientBalanceException catch (e) {
      if (!mounted) return;
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.insufficientTitle),
          content: Text(l10n.insufficientMsg(formatMoney(e.shortCents, currency))),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.goRecharge)),
          ],
        ),
      );
      if (go == true && mounted) {
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RechargePage()));
        if (mounted) setState(() {});
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.operationFailed)));
      }
    }
  }
}

class _NoCoupon {
  const _NoCoupon();
}
