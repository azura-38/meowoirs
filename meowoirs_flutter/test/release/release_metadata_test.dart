import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowoirs/core/config/app_config.dart';
import 'package:meowoirs/services/ads/ad_config.dart';

/// Release-preparation guards: version metadata consistency and
/// AdMob manifest configuration (App ID vs. ad unit IDs, no auto-init provider).
void main() {
  group('Release 0.1.4 metadata & AdMob manifest guards', () {
    test('pubspec version matches AppConfig versionName/versionCode', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final match =
          RegExp(r'^version:\s*([0-9.]+)\+([0-9]+)\s*$', multiLine: true)
              .firstMatch(pubspec);
      expect(match, isNotNull, reason: 'pubspec.yaml must declare name+code');
      expect(match!.group(1), AppConfig.versionName);
      expect(int.parse(match.group(2)!), AppConfig.versionCode);
    });

    test('version code is greater than every previously used code (1-5)', () {
      expect(AppConfig.versionName, '0.1.4');
      expect(AppConfig.versionCode, 6);
      expect(AppConfig.versionCode, greaterThan(5));
    });

    test('source AndroidManifest uses App ID (~), not an ad unit ID (/)', () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(manifest, contains(AdConfig.productionAppId));
      expect(AdConfig.productionAppId, contains('~'));
      expect(manifest, isNot(contains(AdConfig.productionBannerId)));
      expect(manifest, isNot(contains(AdConfig.productionInterstitialId)));
      expect(manifest, isNot(contains(AdConfig.testBannerId)));
      expect(manifest, isNot(contains(AdConfig.testInterstitialId)));
    });

    test('MobileAdsInitProvider stays removed (manual init after UMP)', () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      final provider = RegExp(
        r'<provider[^>]*MobileAdsInitProvider[^>]*tools:node="remove"',
        dotAll: true,
      );
      expect(provider.hasMatch(manifest), isTrue);
    });

    test('verified 16-digit AdMob publisher ID is used and old incorrect prefix is absent from active config', () {
      const legacyWrongPrefix = 'ca-app-pub-587701117' '866406';
      expect(
        AdConfig.productionAppId,
        'ca-app-pub-5877011177866406~4355156867',
      );
      expect(
        AdConfig.productionBannerId,
        'ca-app-pub-5877011177866406/2930394553',
      );
      expect(
        AdConfig.productionInterstitialId,
        'ca-app-pub-5877011177866406/2195897382',
      );
      expect(
        RegExp(r'^ca-app-pub-[0-9]{16}~[0-9]{10}$')
            .hasMatch(AdConfig.productionAppId),
        isTrue,
      );

      final activeConfigFiles = [
        'lib/services/ads/ad_config.dart',
        'android/app/src/main/AndroidManifest.xml',
        'ios/Runner/Info.plist',
        'assets/legal/PRIVACY_POLICY.txt',
      ];
      for (final relativePath in activeConfigFiles) {
        final content = File(relativePath).readAsStringSync();
        expect(
          content.contains(legacyWrongPrefix),
          isFalse,
          reason: '$relativePath must not contain $legacyWrongPrefix',
        );
      }
    });
  });
}
