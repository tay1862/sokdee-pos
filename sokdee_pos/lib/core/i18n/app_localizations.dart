import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Supported locales for SOKDEE POS: Lao, Thai, English
class AppLocalizations {
  AppLocalizations._();

  static const List<Locale> supportedLocales = [
    Locale('lo'), // Lao
    Locale('th'), // Thai
    Locale('en'), // English
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
