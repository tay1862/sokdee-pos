import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

const _localeKey = 'app_locale';
const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

/// Supported locales
const supportedLocales = [
  Locale('lo'), // Lao (default)
  Locale('th'), // Thai
  Locale('en'), // English
];

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale> build() async {
    final stored = await _storage.read(key: _localeKey);
    if (stored != null) {
      return Locale(stored);
    }
    return const Locale('lo'); // Default: Lao
  }

  /// Change locale immediately without restart
  Future<void> setLocale(Locale locale) async {
    await _storage.write(key: _localeKey, value: locale.languageCode);
    state = AsyncValue.data(locale);
  }
}
