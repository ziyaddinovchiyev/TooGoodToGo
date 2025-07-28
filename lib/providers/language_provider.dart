import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english,
  russian,
  azerbaijani,
}

class LanguageProvider extends StateNotifier<AppLanguage> {
  LanguageProvider() : super(AppLanguage.english) {
    _loadLanguage();
  }

  static const String _languageKey = 'selected_language';

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageIndex = prefs.getInt(_languageKey) ?? 0;
      state = AppLanguage.values[languageIndex];
    } catch (e) {
      // Default to English if there's an error
      state = AppLanguage.english;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_languageKey, language.index);
      state = language;
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }

  Locale getLocale() {
    switch (state) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.russian:
        return const Locale('ru');
      case AppLanguage.azerbaijani:
        return const Locale('az');
    }
  }

  String getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.russian:
        return 'Русский';
      case AppLanguage.azerbaijani:
        return 'Azərbaycan';
    }
  }
}

final languageProvider = StateNotifierProvider<LanguageProvider, AppLanguage>((ref) {
  return LanguageProvider();
});

final localeProvider = Provider<Locale>((ref) {
  final language = ref.watch(languageProvider);
  final languageNotifier = ref.read(languageProvider.notifier);
  return languageNotifier.getLocale();
}); 