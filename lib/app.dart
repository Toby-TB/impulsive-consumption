import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'core/theme.dart';
import 'features/home/home_shell.dart';
import 'state/providers.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(appInitProvider);
    final settings = ref.watch(settingsStreamProvider);
    final localeCode = ref.watch(localeCodeProvider);
    final themeCode = ref.watch(themeCodeProvider);

    if (init.isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _SplashPage(),
      );
    }
    if (init.hasError) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _InitErrorPage(error: init.error),
      );
    }
    if (!settings.hasValue) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _SplashPage(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '冲动消费',
      locale: _localeFromCode(localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeModeFromCode(themeCode),
      home: const HomeShell(),
    );
  }

  static Locale _localeFromCode(String code) => switch (code) {
        'en' => const Locale('en'),
        'zhHant' => const Locale('zh', 'Hant'),
        _ => const Locale('zh'),
      };

  static ThemeMode _themeModeFromCode(String code) => switch (code) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFF8F2),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🛍️', style: TextStyle(fontSize: 72)),
            SizedBox(height: 16),
            Text(
              '冲动消费',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFFE8590C)),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _InitErrorPage extends ConsumerWidget {
  const _InitErrorPage({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😵‍💫', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                '本地数据初始化失败',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text('${error ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => ref.invalidate(appInitProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
