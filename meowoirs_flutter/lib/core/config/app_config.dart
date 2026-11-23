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

  /// Configured Google Play listing URL for VitaCase (from LIMANEX website configuration).
  static const String vitaCasePlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.limanex.vitacase';

  /// Fallback public LIMANEX web page for VitaCase when store links are unavailable.
  static const String vitaCaseWebUrl =
      'https://limanexstudio.com/apps/vitacase';

  /// Current version of the legal terms and privacy policy.
  static const String currentLegalVersion = '1';

  /// Application version name.
  static const String versionName = '0.1.4';

  /// Application build number.
  static const int versionCode = 6;

  /// Debug panel enabled flag. Strictly guarded behind kDebugMode in caller sites.
  static const bool meowoirsDebugPanelEnabled = true;
}
