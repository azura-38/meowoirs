/// AdMob configuration constants for Meowoirs.
/// Exact production IDs matching AdConfig.kt.
class AdConfig {
  AdConfig._();

  /// Google AdMob Application ID (configured in AndroidManifest.xml and Info.plist).
  static const String applicationId = 'ca-app-pub-587701117866406~4355156867';

  /// Production Banner Ad Unit ID.
  static const String bannerAdUnitId = 'ca-app-pub-587701117866406/2930394553';

  /// Production Interstitial Ad Unit ID.
  static const String interstitialAdUnitId = 'ca-app-pub-587701117866406/2195897382';

  /// Minimum launch count required before any interstitial can be considered (never on 1-4).
  static const int minLaunchThreshold = 5;

  /// Maximum launch count in an interstitial trigger cycle.
  static const int maxLaunchThreshold = 7;
}
