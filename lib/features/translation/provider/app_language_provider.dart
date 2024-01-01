import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends StateNotifier<Locale> {
  AppLanguageProvider() : super(const Locale('ar'));

  Future<void> initialize() async {
    final savedLocale = await getSavedLanguage();
    if (savedLocale != null) {
      state = savedLocale;
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (S.delegate.supportedLocales.contains(newLocale)) {
      state = newLocale;
      await _saveLanguageToPreferences(newLocale);
    }
  }

  Future<void> _saveLanguageToPreferences(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_locale', locale.languageCode);
  }

  Future<Locale?> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = prefs.getString('selected_locale');
    if (savedLocaleCode != null) {
      return Locale(savedLocaleCode);
    }
    return null;
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLanguageProvider, Locale>((ref) {
  final appLanguageProvider = AppLanguageProvider();
  appLanguageProvider
      .initialize(); // Load the saved language on initialization.
  return appLanguageProvider;
});
