import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/i18n/locale_provider.dart';
import 'package:sokdee_pos/core/router/app_router.dart';
import 'package:sokdee_pos/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SokdeePosApp(),
    ),
  );
}

class SokdeePosApp extends ConsumerWidget {
  const SokdeePosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final localeAsync = ref.watch(localeNotifierProvider);
    final locale = localeAsync.valueOrNull ?? const Locale('lo');

    return MaterialApp.router(
      title: 'SOKDEE POS',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
