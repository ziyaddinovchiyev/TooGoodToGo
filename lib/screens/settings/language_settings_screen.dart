import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLanguage = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.language,
                  size: 32,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select your preferred language for the app',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Language options
          ...AppLanguage.values.map((language) {
            final isSelected = currentLanguage == language;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected 
                      ? const Color(0xFF4CAF50) 
                      : Colors.grey[200],
                  child: Text(
                    _getLanguageFlag(language),
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
                title: Text(
                  languageNotifier.getLanguageName(language),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  _getLanguageDescription(language),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4CAF50),
                      )
                    : null,
                onTap: () {
                  languageNotifier.setLanguage(language);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to ${languageNotifier.getLanguageName(language)}'),
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          
          const SizedBox(height: 24),
          
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Note',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Changing the language will update the app interface immediately. Some content may remain in the original language.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageFlag(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return '🇺🇸';
      case AppLanguage.russian:
        return '🇷🇺';
      case AppLanguage.azerbaijani:
        return '🇦🇿';
    }
  }

  String _getLanguageDescription(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English - Default language';
      case AppLanguage.russian:
        return 'Русский - Русский язык';
      case AppLanguage.azerbaijani:
        return 'Azərbaycan - Azərbaycan dili';
    }
  }
} 