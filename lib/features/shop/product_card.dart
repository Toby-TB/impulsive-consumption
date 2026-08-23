import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../data/catalog/products.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final localeCode = ref.watch(localeCodeProvider);
    final currency = ref.watch(currencyProvider);
    final stocks = ref.watch(stocksProvider).valueOrNull ?? const <String, int>{};
    final favs = ref.watch(favoritesProvider).valueOrNull ?? const <String>{};
    final stock = stocks[product.id] ?? product.stock;
    final isFav = favs.contains(product.id);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: Image.asset(product.imagePath, fit: BoxFit.cover),
                  ),
                  if (stock == 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(l10n.outOfStock,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _FavButton(productId: product.id, isFav: isFav),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
                  Text(
                    formatMoney(product.priceCents, currency),
                    style: const TextStyle(
                      color: Color(0xFFE8590C),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        l10n.monthlySales(product.monthlySales),
                        style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB300)),
                      Text(
                        l10n.ratingStar(product.rating),
                        style: const TextStyle(fontSize: 10.5, color: Colors.grey),
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
}

class _FavButton extends ConsumerWidget {
  const _FavButton({required this.productId, required this.isFav});

  final String productId;
  final bool isFav;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final db = ref.read(dbProvider);
        final added = await db.toggleFavorite(productId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(added ? l10n.addedToFavorites : l10n.removedFromFavorites)),
          );
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: isFav ? const Color(0xFFFF5252) : Colors.grey,
        ),
      ),
    );
  }
}
