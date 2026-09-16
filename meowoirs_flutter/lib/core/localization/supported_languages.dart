/// Supported languages configuration matching SettingsScreen.kt.
class SupportedLanguage {
  const SupportedLanguage({
    required this.code,
    required this.displayName,
  });

  final String code;
  final String displayName;
}

const List<SupportedLanguage> supportedLanguages = [
  SupportedLanguage(code: 'tr', displayName: 'Türkçe'),
  SupportedLanguage(code: 'en', displayName: 'English'),
  SupportedLanguage(code: 'de', displayName: 'Deutsch'),
  SupportedLanguage(code: 'fr', displayName: 'Français'),
  SupportedLanguage(code: 'es', displayName: 'Español'),
  SupportedLanguage(code: 'it', displayName: 'Italiano'),
  SupportedLanguage(code: 'pt', displayName: 'Português'),
  SupportedLanguage(code: 'nl', displayName: 'Nederlands'),
  SupportedLanguage(code: 'pl', displayName: 'Polski'),
  SupportedLanguage(code: 'ja', displayName: '日本語'),
];
