import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logistics.dart';
import '../../core/widgets/page_width.dart';
import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(dbProvider);
    final localeCode = ref.watch(localeCodeProvider);
    final currency = ref.watch(currencyProvider);
    final themeCode = ref.watch(themeCodeProvider);
    final mode = ref.watch(logisticsModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: PageWidth(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        children: [
          _header(l10n.language),
          _tile(Icons.translate, l10n.languageZhHans, localeCode == 'zh', () => db.setSetting('locale', 'zh')),
          _tile(Icons.translate, l10n.languageZhHant, localeCode == 'zhHant', () => db.setSetting('locale', 'zhHant')),
          _tile(Icons.translate, l10n.languageEn, localeCode == 'en', () => db.setSetting('locale', 'en')),
          const SizedBox(height: 12),
          _header(l10n.currency),
          _tile(Icons.payments_outlined, l10n.currencyCny, currency == Currency.cny, () => db.setSetting('currency', 'CNY')),
          _tile(Icons.payments_outlined, l10n.currencyHkd, currency == Currency.hkd, () => db.setSetting('currency', 'HKD')),
          _tile(Icons.payments_outlined, l10n.currencyUsd, currency == Currency.usd, () => db.setSetting('currency', 'USD')),
          const SizedBox(height: 12),
          _header(l10n.theme),
          _tile(Icons.brightness_auto_outlined, l10n.themeSystem, themeCode == 'system', () => db.setSetting('theme', 'system')),
          _tile(Icons.light_mode_outlined, l10n.themeLight, themeCode == 'light', () => db.setSetting('theme', 'light')),
          _tile(Icons.dark_mode_outlined, l10n.themeDark, themeCode == 'dark', () => db.setSetting('theme', 'dark')),
          const SizedBox(height: 12),
          _header(l10n.logisticsSpeed),
          _tile(Icons.local_shipping_outlined, l10n.logisticsFast, mode == LogisticsMode.fast, () => db.setSetting('logistics', 'fast')),
          _tile(Icons.schedule_outlined, l10n.logisticsReal, mode == LogisticsMode.real, () => db.setSetting('logistics', 'real')),
          const SizedBox(height: 12),
          _header(l10n.about),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(l10n.appName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      Text('${l10n.version} 1.0.0', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.aboutContent, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.6)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              leading: const Icon(Icons.restart_alt, color: Color(0xFFE53935)),
              title: Text(l10n.resetData, style: const TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w700)),
              onTap: () => _confirmReset(context, db),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.grey)),
    );
  }

  Widget _tile(IconData icon, String title, bool selected, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(icon, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
        trailing: selected
            ? const Icon(Icons.check_circle, color: Color(0xFFE8590C), size: 20)
            : Icon(Icons.circle_outlined, size: 20, color: Colors.grey.shade300),
        onTap: onTap,
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, dynamic db) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetData),
        content: Text(l10n.resetConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (ok == true) {
      await db.resetAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resetDone)));
      }
    }
  }
}
