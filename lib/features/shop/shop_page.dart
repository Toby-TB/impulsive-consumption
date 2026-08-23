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
          const _HeroBanner(),
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

/// 首页多巴胺横幅：暗色渐变 + 大标语 + 悬浮商品图（参考 dopamine 购物站风格）。
class _HeroBanner extends StatefulWidget {
  const _HeroBanner();

  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 148,
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1B3D), Color(0xFF6B2D5C), Color(0xFFC2410C)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -34,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x22FFFFFF)),
            ),
          ),
          Positioned(
            bottom: -46,
            right: 90,
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x1AFFFFFF)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 148, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.heroTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.heroSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0x55FFFFFF)),
                      ),
                      child: Text(
                        '💊 ${l10n.appName}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 2,
            bottom: -4,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                return Transform.translate(
                  offset: Offset(0, -6 * t),
                  child: Transform.rotate(
                    angle: 0.035 * t - 0.018,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/hero/ps5.png',
                width: 152,
                height: 152,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
