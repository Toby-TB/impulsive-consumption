import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/catalog/products.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'product_card.dart';
import 'product_detail_page.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  String _query = '';
  String _categoryId = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeCode = ref.watch(localeCodeProvider);
    final q = _query.trim().toLowerCase();
    final filtered = products.where((p) {
      final inCategory = _categoryId == 'all' || p.categoryId == _categoryId;
      final matchesQuery = q.isEmpty ||
          p.name.resolve(localeCode).toLowerCase().contains(q) ||
          p.description.resolve(localeCode).toLowerCase().contains(q) ||
          p.name.zh.toLowerCase().contains(q) ||
          p.name.en.toLowerCase().contains(q);
      return inCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appName),
            Text(l10n.appTagline,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xFFE8590C))),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _query = '')),
              ),
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip(l10n.all, _categoryId == 'all', () => setState(() => _categoryId = 'all')),
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _chip(
                      '${c.emoji} ${c.name.resolve(localeCode)}',
                      _categoryId == c.id,
                      () => setState(() => _categoryId = c.id),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 12),
                        Text(l10n.searchEmpty, style: const TextStyle(color: Colors.grey)),
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
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final p = filtered[i];
                      return ProductCard(
                        product: p,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProductDetailPage(productId: p.id)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}
