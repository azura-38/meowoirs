/// Central configuration constants for Meowoirs.
/// Direct parity with AppConfig.kt.
class AppConfig {
  AppConfig._();

  /// Primary support and privacy contact email.
  static const String supportEmail = 'limanexsoftware@outlook.com';

  /// Hosted public URL for the Privacy Policy.
  static const String privacyPolicyUrl = 'https://limanexstudio.com/privacy/meowoirs';

  /// Hosted public URL for the Terms of Service.
  static const String termsOfServiceUrl = 'https://limanexstudio.com/terms/meowoirs';

  /// Current version of the legal terms and privacy policy.
  static const String currentLegalVersion = '1';

  /// Application version name.
  static const String versionName = '0.1.0';

  /// Application build number.
  static const int versionCode = 1;

  /// Debug panel enabled flag. Strictly guarded behind kDebugMode in caller sites.
  static const bool meowoirsDebugPanelEnabled = true;
}
