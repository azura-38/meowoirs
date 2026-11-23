import 'package:flutter_test/flutter_test.dart';
import 'package:meowoirs/services/ads/ad_config.dart';

void main() {
  group('Phase 2 — AdMob Build-Mode Separation & AdConfig Suite', () {
    // Exact credentials per specification
    const expectedProductionAppId =
        'ca-app-pub-5877011177866406~4355156867';
    const expectedProductionBannerId =
        'ca-app-pub-5877011177866406/2930394553';
    const expectedProductionInterstitialId =
        'ca-app-pub-5877011177866406/2195897382';

    const expectedTestBannerId =
        'ca-app-pub-3940256099942544/6300978111';
    const expectedTestInterstitialId =
        'ca-app-pub-3940256099942544/1033173712';

    test('10. Production App ID remains unchanged across all configurations', () {
      expect(AdConfig.productionAppId, expectedProductionAppId);
      expect(AdConfig.applicationId, expectedProductionAppId);
      expect(AdConfig.debugConfig.appId, expectedProductionAppId);
      expect(AdConfig.profileConfig.appId, expectedProductionAppId);
      expect(AdConfig.releaseConfig.appId, expectedProductionAppId);
      expect(AdConfig.appId, expectedProductionAppId);
    });

    test('Production ad unit constants match exact credentials', () {
      expect(AdConfig.productionBannerId, expectedProductionBannerId);
      expect(AdConfig.productionInterstitialId, expectedProductionInterstitialId);
    });

    test('Google test ad unit constants match official test IDs', () {
      expect(AdConfig.testBannerId, expectedTestBannerId);
      expect(AdConfig.testInterstitialId, expectedTestInterstitialId);
    });

    // Requirement 15: 1 & 2
    test('1. DEBUG uses test banner & 2. DEBUG uses test interstitial', () {
      expect(AdConfig.debugConfig.bannerAdUnitId, expectedTestBannerId);
      expect(AdConfig.debugConfig.interstitialAdUnitId, expectedTestInterstitialId);
    });

    // Requirement 15: 3 & 4
    test('3. PROFILE uses test banner & 4. PROFILE uses test interstitial', () {
      expect(AdConfig.profileConfig.bannerAdUnitId, expectedTestBannerId);
      expect(AdConfig.profileConfig.interstitialAdUnitId, expectedTestInterstitialId);
    });

    // Requirement 15: 5 & 6
    test('5. RELEASE uses production banner & 6. RELEASE uses production interstitial', () {
      expect(AdConfig.releaseConfig.bannerAdUnitId, expectedProductionBannerId);
      expect(AdConfig.releaseConfig.interstitialAdUnitId, expectedProductionInterstitialId);
    });

    // Requirement 15: 7, 8, 9
    test('7. DEBUG isTestAds = true & 8. PROFILE isTestAds = true & 9. RELEASE isTestAds = false', () {
      expect(AdConfig.debugConfig.isTestAds, isTrue);
      expect(AdConfig.profileConfig.isTestAds, isTrue);
      expect(AdConfig.releaseConfig.isTestAds, isFalse);
    });

    test('Environment names: DEBUG/PROFILE is TEST, RELEASE is PRODUCTION', () {
      expect(AdConfig.debugConfig.environmentName, 'TEST');
      expect(AdConfig.profileConfig.environmentName, 'TEST');
      expect(AdConfig.releaseConfig.environmentName, 'PRODUCTION');
    });

    // Requirement 12 & Requirement 15: 12
    test('12. DEBUG never uses production IDs', () {
      expect(
        AdConfig.debugConfig.bannerAdUnitId,
        isNot(equals(expectedProductionBannerId)),
      );
      expect(
        AdConfig.debugConfig.interstitialAdUnitId,
        isNot(equals(expectedProductionInterstitialId)),
      );
    });

    test('PROFILE never uses production IDs', () {
      expect(
        AdConfig.profileConfig.bannerAdUnitId,
        isNot(equals(expectedProductionBannerId)),
      );
      expect(
        AdConfig.profileConfig.interstitialAdUnitId,
        isNot(equals(expectedProductionInterstitialId)),
      );
    });

    // Requirement 13 & Requirement 15: 11
    test('11. RELEASE never uses test IDs', () {
      expect(
        AdConfig.releaseConfig.bannerAdUnitId,
        isNot(equals(expectedTestBannerId)),
      );
      expect(
        AdConfig.releaseConfig.interstitialAdUnitId,
        isNot(equals(expectedTestInterstitialId)),
      );
    });

    test('Deterministic resolution via AdConfig.resolve', () {
      final debugResolved = AdConfig.resolve(isRelease: false, isProfile: false);
      expect(debugResolved.bannerAdUnitId, expectedTestBannerId);
      expect(debugResolved.isTestAds, isTrue);
      expect(debugResolved.environmentName, 'TEST');

      final profileResolved = AdConfig.resolve(isRelease: false, isProfile: true);
      expect(profileResolved.bannerAdUnitId, expectedTestBannerId);
      expect(profileResolved.isTestAds, isTrue);
      expect(profileResolved.environmentName, 'TEST');

      final releaseResolved = AdConfig.resolve(isRelease: true, isProfile: false);
      expect(releaseResolved.bannerAdUnitId, expectedProductionBannerId);
      expect(releaseResolved.interstitialAdUnitId, expectedProductionInterstitialId);
      expect(releaseResolved.isTestAds, isFalse);
      expect(releaseResolved.environmentName, 'PRODUCTION');
    });

    test('Runtime current in test environment operates as DEBUG TEST mode', () {
      // flutter test executes in debug mode
      expect(AdConfig.isTestAds, isTrue);
      expect(AdConfig.environmentName, 'TEST');
      expect(AdConfig.bannerAdUnitId, expectedTestBannerId);
      expect(AdConfig.interstitialAdUnitId, expectedTestInterstitialId);
      expect(AdConfig.appId, expectedProductionAppId);
    });
  });
}
