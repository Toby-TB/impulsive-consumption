import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../data/catalog/products.dart';
import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'checkout_page.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key, required this.onGoShopping});

  final VoidCallback onGoShopping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(dbProvider);
    final currency = ref.watch(currencyProvider);
    final cart = ref.watch(cartProvider).valueOrNull ?? const [];
    final stocks = ref.watch(stocksProvider).valueOrNull ?? const <String, int>{};
    final localeCode = ref.watch(localeCodeProvider);

    final allSelected = cart.isNotEmpty && cart.every((e) => e.selected);
    final selectedItems = cart.where((e) => e.selected).toList();
    final subtotal = selectedItems.fold<int>(0, (sum, e) {
      final p = productById(e.productId);
      return sum + (p == null ? 0 : p.priceCents * e.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabCart),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _confirmClear(context, db, l10n),
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text(l10n.cartEmpty, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: onGoShopping, child: Text(l10n.goShopping)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    itemCount: cart.length,
                    itemBuilder: (context, i) {
                      final item = cart[i];
                      final product = productById(item.productId);
                      if (product == null) return const SizedBox.shrink();
                      final stock = stocks[item.productId] ?? 0;
                      return _CartTile(
                        item: item,
                        product: product,
                        stock: stock,
                        currency: currency,
                        localeCode: localeCode,
                      );
                    },
                  ),
                ),
                _BottomBar(
                  allSelected: allSelected,
                  subtotal: subtotal,
                  selectedCount: selectedItems.fold(0, (s, e) => s + e.quantity),
                ),
              ],
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, dynamic db, AppLocalizations l10n) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearCart),
        content: Text(l10n.clearCartConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm)),
        ],
      ),
    );
    if (ok == true) await db.clearCart();
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({
    required this.item,
    required this.product,
    required this.stock,
    required this.currency,
    required this.localeCode,
  });

  final CartItem item;
  final Product product;
  final int stock;
  final Currency currency;
  final String localeCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(
              value: item.selected,
              onChanged: (v) => db.setCartSelected(item.id, v ?? true),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(product.imagePath, width: 62, height: 62, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.resolve(localeCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        formatMoney(product.priceCents, currency),
                        style: const TextStyle(color: Color(0xFFE8590C), fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      Text(
                        formatMoney(product.priceCents * item.quantity, currency),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _step(Icons.remove_circle_outline, item.quantity > 1,
                          () => db.setCartQuantity(item.id, item.quantity - 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${item.quantity}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      _step(Icons.add_circle_outline, item.quantity < stock,
                          () => db.setCartQuantity(item.id, item.quantity + 1)),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => db.removeCartItem(item.id),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(IconData icon, bool enabled, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? onTap : null,
      child: Icon(icon, size: 24, color: enabled ? const Color(0xFFE8590C) : Colors.grey.shade300),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.allSelected, required this.subtotal, required this.selectedCount});

  final bool allSelected;
  final int subtotal;
  final int selectedCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(dbProvider);
    final currency = ref.watch(currencyProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Checkbox(value: allSelected, onChanged: (v) => db.setAllSelected(v ?? true)),
            Text(l10n.selectAll, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoney(subtotal, currency),
                  style: const TextStyle(color: Color(0xFFE8590C), fontSize: 17, fontWeight: FontWeight.w800),
                ),
                Text(l10n.itemsCount(selectedCount), style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                if (selectedCount == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.selectItemsFirst)));
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CheckoutPage()),
                );
              },
              child: Text(l10n.checkoutN(selectedCount)),
            ),
          ],
        ),
      ),
    );
  }
}
