import 'dart:io';

/// AdMob configuration constants for Meowoirs.
/// Uses exact production IDs matching the Android Kotlin reference implementation.
class AdConfig {
  AdConfig._();

  /// Google AdMob Application ID
  static const String applicationId = 'ca-app-pub-587701117866406~4355156867';

  /// Production Banner Ad Unit ID
  static const String androidBannerAdUnitId =
      'ca-app-pub-587701117866406/2930394553';
  // Standard test banner ID for iOS/desktop or fallback
  static const String iosBannerAdUnitId =
      'ca-app-pub-587701117866406/2930394553';

  static String get bannerAdUnitId {
    if (Platform.isAndroid) return androidBannerAdUnitId;
    if (Platform.isIOS) return iosBannerAdUnitId;
    return androidBannerAdUnitId;
  }

  /// Production Interstitial Ad Unit ID
  static const String androidInterstitialAdUnitId =
      'ca-app-pub-587701117866406/2195897382';
  static const String iosInterstitialAdUnitId =
      'ca-app-pub-587701117866406/2195897382';

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) return androidInterstitialAdUnitId;
    if (Platform.isIOS) return iosInterstitialAdUnitId;
    return androidInterstitialAdUnitId;
  }

  /// Minimum launch count required before any interstitial can be considered (never on 1-4).
  static const int minLaunchThreshold = 5;

  /// Maximum launch count in an interstitial trigger cycle.
  static const int maxLaunchThreshold = 7;
}
