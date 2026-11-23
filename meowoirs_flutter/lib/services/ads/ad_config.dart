import 'package:flutter/foundation.dart';

/// Immutable container for environment-specific AdMob configuration.
class AdEnvironmentConfig {
  final String appId;
  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final bool isTestAds;
  final String environmentName;

  const AdEnvironmentConfig({
    required this.appId,
    required this.bannerAdUnitId,
    required this.interstitialAdUnitId,
    required this.isTestAds,
    required this.environmentName,
  });
}

/// Centralized AdMob configuration for Meowoirs.
/// Strictly segregates TEST ad units for DEBUG and PROFILE modes,
/// and PRODUCTION ad units for RELEASE mode.
class AdConfig {
  AdConfig._();

  // ==================================================
  // 1. PRODUCTION ADMOB CREDENTIALS (IMMUTABLE)
  // ==================================================
  static const String productionAppId =
      'ca-app-pub-5877011177866406~4355156867';
  static const String productionBannerId =
      'ca-app-pub-5877011177866406/2930394553';
  static const String productionInterstitialId =
      'ca-app-pub-5877011177866406/2195897382';

  // ==================================================
  // 2. GOOGLE OFFICIAL TEST AD UNITS (DEBUG / PROFILE)
  // ==================================================
  static const String testBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';

  // ==================================================
  // 3. STATIC ENVIRONMENT CONFIGURATIONS
  // ==================================================
  static const AdEnvironmentConfig debugConfig = AdEnvironmentConfig(
    appId: productionAppId,
    bannerAdUnitId: testBannerId,
    interstitialAdUnitId: testInterstitialId,
    isTestAds: true,
    environmentName: 'TEST',
  );

  static const AdEnvironmentConfig profileConfig = AdEnvironmentConfig(
    appId: productionAppId,
    bannerAdUnitId: testBannerId,
    interstitialAdUnitId: testInterstitialId,
    isTestAds: true,
    environmentName: 'TEST',
  );

  static const AdEnvironmentConfig releaseConfig = AdEnvironmentConfig(
    appId: productionAppId,
    bannerAdUnitId: productionBannerId,
    interstitialAdUnitId: productionInterstitialId,
    isTestAds: false,
    environmentName: 'PRODUCTION',
  );

  /// Resolves the environment configuration deterministically based on compile-time flags.
  static AdEnvironmentConfig resolve({
    bool isRelease = kReleaseMode,
    bool isProfile = kProfileMode,
  }) {
    if (isRelease) {
      return releaseConfig;
    } else if (isProfile) {
      return profileConfig;
    } else {
      return debugConfig;
    }
  }

  /// Active environment configuration for current runtime build mode.
  static AdEnvironmentConfig get current => resolve();

  // ==================================================
  // 4. CENTRALIZED GETTERS EXPOSED TO APPLICATION
  // ==================================================

  /// AdMob Application ID (preserved as production App ID across all modes).
  static String get appId => current.appId;
  static const String applicationId = productionAppId;

  /// Active Banner Ad Unit ID based on compile-time build mode.
  static String get bannerAdUnitId => current.bannerAdUnitId;

  /// Active Interstitial Ad Unit ID based on compile-time build mode.
  static String get interstitialAdUnitId => current.interstitialAdUnitId;

  /// True if current build uses Google test ad units.
  static bool get isTestAds => current.isTestAds;

  /// Environment name: 'TEST' for DEBUG & PROFILE, 'PRODUCTION' for RELEASE.
  static String get environmentName => current.environmentName;

  // Platform aliases preserved for backward compatibility
  static const String androidBannerAdUnitId = productionBannerId;
  static const String iosBannerAdUnitId = productionBannerId;
  static const String androidInterstitialAdUnitId = productionInterstitialId;
  static const String iosInterstitialAdUnitId = productionInterstitialId;

  // ==================================================
  // 5. INTERSTITIAL FREQUENCY RULES
  // ==================================================
  /// Minimum launch count required before any interstitial can be considered (never on 1-4).
  static const int minLaunchThreshold = 5;

  /// Maximum launch count in an interstitial trigger cycle.
  static const int maxLaunchThreshold = 7;
}
