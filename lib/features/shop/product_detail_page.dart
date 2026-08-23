import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../core/widgets/page_width.dart';
import '../../data/catalog/products.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../cart/checkout_page.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = productById(widget.productId)!;
    final localeCode = ref.watch(localeCodeProvider);
    final currency = ref.watch(currencyProvider);
    final stocks = ref.watch(stocksProvider).valueOrNull ?? const <String, int>{};
    final favs = ref.watch(favoritesProvider).valueOrNull ?? const <String>{};
    final stock = stocks[product.id] ?? product.stock;
    final isFav = favs.contains(product.id);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final db = ref.read(dbProvider);
              final added = await db.toggleFavorite(product.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(added ? l10n.addedToFavorites : l10n.removedFromFavorites)),
                );
              }
            },
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? const Color(0xFFFF5252) : null),
          ),
        ],
      ),
      body: PageWidth(
        maxWidth: 720,
        child: ListView(
          children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'product-${product.id}',
              child: Image.asset(product.imagePath, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name.resolve(localeCode),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatMoney(product.priceCents, currency),
                      style: const TextStyle(color: Color(0xFFE8590C), fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: stock > 0
                          ? Text(l10n.stockLeft(stock), style: const TextStyle(fontSize: 12, color: Colors.grey))
                          : Text(l10n.outOfStock,
                              style: const TextStyle(fontSize: 12, color: Color(0xFFE8590C), fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB300)),
                    Text(l10n.ratingStar(product.rating), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 14),
                    Text(l10n.monthlySales(product.monthlySales), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🚚', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(l10n.freeShipping,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB45309))),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(l10n.quantity, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _stepIcon(Icons.remove_circle_outline, _qty > 1, () => setState(() => _qty--)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text('$_qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    _stepIcon(Icons.add_circle_outline, _qty < max(1, stock), () => setState(() => _qty++)),
                  ],
                ),
                const SizedBox(height: 18),
                Text(product.description.resolve(localeCode),
                    style: const TextStyle(fontSize: 13.5, color: Colors.grey, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: stock > 0 ? _addToCart : null,
                  child: Text(l10n.addToCart),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: stock > 0 ? _buyNow : null,
                  child: Text(l10n.buyNow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepIcon(IconData icon, bool enabled, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? onTap : null,
      child: Icon(icon, size: 28, color: enabled ? const Color(0xFFE8590C) : Colors.grey.shade300),
    );
  }

  void _addToCart() async {
    final l10n = AppLocalizations.of(context);
    final stocks = ref.read(stocksProvider).valueOrNull ?? const <String, int>{};
    final stock = stocks[widget.productId] ?? 0;
    if (_qty > stock) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.insufficientStock)));
      return;
    }
    await ref.read(dbProvider).addToCart(widget.productId, _qty);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addedToCart)));
    }
  }

  void _buyNow() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutPage(directItem: DirectItem(widget.productId, _qty)),
      ),
    );
  }
}
