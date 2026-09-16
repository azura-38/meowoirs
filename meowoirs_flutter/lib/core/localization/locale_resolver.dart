import 'package:flutter/widgets.dart';
import 'supported_languages.dart';

/// Central logic for detecting system locale and resolving Meowoirs app language.
/// Strictly follows Phase 18.1 Issue 1 requirements:
/// - First launch: auto-detect system locale.
/// - If system locale is supported (tr, en, de, fr, es, it, pt, nl, pl, ja) -> use it.
/// - If system locale is unsupported (e.g. ar, ru) -> fallback to English ('en').
/// - Explicit user overrides and persistence are strictly preserved.
class LocaleResolver {
  LocaleResolver._();

  static const String fallbackLanguageCode = 'en';

  /// Resolves the effective language code given a list of candidate system locales.
  /// If [deviceLocales] is null or empty, falls back to [fallbackLanguageCode].
  static String resolveDeviceLocale(List<Locale>? deviceLocales) {
    if (deviceLocales == null || deviceLocales.isEmpty) {
      return fallbackLanguageCode;
    }

    for (final locale in deviceLocales) {
      final code = locale.languageCode.toLowerCase();
      if (isSupported(code)) {
        return code;
      }
    }

    return fallbackLanguageCode;
  }

  /// Checks if a language code is in the supported languages list.
  static bool isSupported(String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) return false;
    final normalized = languageCode.toLowerCase();
    return supportedLanguages.any((lang) => lang.code.toLowerCase() == normalized);
  }

  /// Resolves a Locale instance from a stored language code, or falls back to English.
  static Locale resolveLocale(String? languageCode) {
    if (languageCode != null && isSupported(languageCode)) {
      return Locale(languageCode.toLowerCase());
    }
    return const Locale(fallbackLanguageCode);
  }

  /// Resolves the app Locale considering both saved preference and candidate device locales.
  /// If [savedLocaleCode] is provided and valid, it takes precedence.
  /// Otherwise, inspects [deviceLocales] for a supported match, or falls back to 'en'.
  static Locale resolveAppLocale({String? savedLocaleCode, List<Locale>? deviceLocales}) {
    if (savedLocaleCode != null && isSupported(savedLocaleCode)) {
      return Locale(savedLocaleCode.toLowerCase());
    }
    final devCode = resolveDeviceLocale(deviceLocales);
    return Locale(devCode);
  }
}
