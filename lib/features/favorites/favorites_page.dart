import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/catalog/products.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../shop/product_card.dart';
import '../shop/product_detail_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favs = ref.watch(favoritesProvider).valueOrNull ?? const <String>{};
    final favorited = products.where((p) => favs.contains(p.id)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: favorited.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💖', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text(l10n.emptyFavorites, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: favorited.length,
              itemBuilder: (context, i) {
                final p = favorited[i];
                return ProductCard(
                  product: p,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProductDetailPage(productId: p.id)),
                  ),
                );
              },
            ),
    );
  }
}
