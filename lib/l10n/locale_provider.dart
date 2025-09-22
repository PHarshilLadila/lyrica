import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProviderProvider = ChangeNotifierProvider<LocaleProvider>((ref) {
  return LocaleProvider();
});

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    loadSavedLocale();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', locale.languageCode);
  }

  Future<void> loadSavedLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('langCode') ?? "en";
    _locale = Locale(langCode);
    notifyListeners();
  }
}
