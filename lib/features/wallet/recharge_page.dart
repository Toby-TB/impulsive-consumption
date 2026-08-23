import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../core/widgets/page_width.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class RechargePage extends ConsumerStatefulWidget {
  const RechargePage({super.key});

  @override
  ConsumerState<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends ConsumerState<RechargePage> {
  static const _presets = [100.0, 500.0, 1000.0, 5000.0, 10000.0];

  double? _selected;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rechargeTitle)),
      body: PageWidth(
        maxWidth: 720,
        child: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('💸', style: TextStyle(fontSize: 56))),
            const SizedBox(height: 8),
            Center(
              child: Text(l10n.rechargeTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 20),
            Text(l10n.rechargeAmount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final amount in _presets)
                  ChoiceChip(
                    label: Text(formatMoney((amount * 100).round(), currency)),
                    selected: _selected == amount,
                    onSelected: (v) => setState(() {
                      _selected = v ? amount : null;
                      if (v) _controller.clear();
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() => _selected = null),
              decoration: InputDecoration(
                hintText: l10n.customAmount,
                prefixIcon: const Icon(Icons.edit_outlined),
                suffixText: currency.symbol,
              ),
            ),
            const Spacer(),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: _confirm,
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context);
    final currency = ref.read(currencyProvider);
    double? value = _selected ?? double.tryParse(_controller.text.trim());
    if (value == null || value <= 0 || value > 100000) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.invalidAmount)));
      return;
    }
    final cnyCents = toCnyCents(value, currency);
    await ref.read(dbProvider).recharge(cnyCents, note: '模拟充值');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.rechargeSuccess)));
      Navigator.of(context).pop();
    }
  }
}
