import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/features/legal/legal_document.dart';
import 'package:meowoirs/features/memories/mood_helper.dart';
import 'package:meowoirs/features/memories/widgets/memory_content_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_large_icons_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_list_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_small_icons_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_tiles_view.dart';
import 'package:meowoirs/features/profile/profile_avatars.dart';
import 'package:meowoirs/services/ads/ad_config.dart';
import 'package:meowoirs/widgets/meowoirs_bottom_navigation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 3 — Section 6: Memory Card & Canonical Mood System', () {
    test('1. Six canonical CAT moods are defined correctly', () {
      expect(CatMoodConstants.canonicalCatMoods, [
        'Mutlu',
        'Meraklı',
        'Uykulu',
        'Oyuncu',
        'Sakin',
        'Sevecen',
      ]);
    });

    test('2. Six canonical USER moods are defined correctly', () {
      expect(CatMoodConstants.canonicalUserMoods, [
        'Mutlu',
        'Huzurlu',
        'Özlemli',
        'Neşeli',
        'Sakin',
        'Duygusal',
      ]);
    });

    test('3. Cat mood sticker mapper maps all 6 canonical cat moods to sticker PNGs', () {
      expect(
        CatMoodStickerMapper.assetForMood('Mutlu'),
        'assets/images/moods/cat_mood_happy.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Meraklı'),
        'assets/images/moods/cat_mood_curious.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Uykulu'),
        'assets/images/moods/cat_mood_sleepy.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Oyuncu'),
        'assets/images/moods/cat_mood_playful.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Sakin'),
        'assets/images/moods/cat_mood_calm.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Sevecen'),
        'assets/images/moods/cat_mood_loving.png',
      );
    });

    test('4. User moods do NOT produce cat mood stickers', () {
      expect(CatMoodStickerMapper.assetForMood('Huzurlu'), isNull);
      expect(CatMoodStickerMapper.assetForMood('Özlemli'), isNull);
      expect(CatMoodStickerMapper.assetForMood('Neşeli'), isNull);
      expect(CatMoodStickerMapper.assetForMood('Duygusal'), isNull);
    });

    test('5. Unknown or null moods resolve safely without crashing', () {
      expect(resolveCatMood(null), isNull);
      expect(resolveCatMood(''), isNull);
      expect(resolveCatMood('   '), isNull);
      expect(resolveCatMood('UnknownMoodXYZ'), isNull);

      expect(resolveUserMood(null), isNull);
      expect(resolveUserMood(''), isNull);
      expect(resolveUserMood('   '), isNull);
      expect(resolveUserMood('NonExistentMood'), isNull);

      expect(CatMoodStickerMapper.assetForMood(null), isNull);
      expect(CatMoodStickerMapper.assetForMood(''), isNull);
      expect(CatMoodStickerMapper.assetForMood('Invalid'), isNull);
    });

    test('6. English and legacy aliases resolve safely to canonical moods', () {
      expect(resolveCatMood('happy'), 'Mutlu');
      expect(resolveCatMood('curious'), 'Meraklı');
      expect(resolveCatMood('sleepy'), 'Uykulu');
      expect(resolveCatMood('playful'), 'Oyuncu');
      expect(resolveCatMood('calm'), 'Sakin');
      expect(resolveCatMood('loving'), 'Sevecen');
      expect(resolveCatMood('affectionate'), 'Sevecen');

      expect(resolveUserMood('peaceful'), 'Huzurlu');
      expect(resolveUserMood('nostalgic'), 'Özlemli');
      expect(resolveUserMood('joyful'), 'Neşeli');
      expect(resolveUserMood('emotional'), 'Duygusal');
    });

    testWidgets('7. All 10 locales resolve localized mood strings without error', (tester) async {
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                for (final catMood in CatMoodConstants.canonicalCatMoods) {
                  final text = getLocalizedCatMood(catMood, l10n);
                  expect(text.isNotEmpty, isTrue, reason: 'Empty mood for $catMood in ${locale.languageCode}');
                }
                for (final userMood in CatMoodConstants.canonicalUserMoods) {
                  final text = getLocalizedUserMood(userMood, l10n);
                  expect(text.isNotEmpty, isTrue, reason: 'Empty user mood for $userMood in ${locale.languageCode}');
                }
                return const Placeholder();
              },
            ),
          ),
        );
      }
    });
  });

  group('Phase 3 — Section 3 & 9: Profile Avatar System', () {
    test('8. Exactly 10 profile avatars are registered and available', () {
      expect(ProfileAvatars.all.length, 10);
      final ids = ProfileAvatars.all.map((a) => a.id).toSet();
      expect(ids.length, 10); // All unique IDs
    });

    test('9. Avatar fallback safely returns default avatar on unknown ID', () {
      final fallback = ProfileAvatars.getById('completely_invalid_avatar_id');
      expect(fallback.id, 'avatar_warm_cat');
      expect(fallback.assetPath.isNotEmpty, isTrue);
    });
  });

  group('Phase 3 — Section 9: Navigation & Bottom Navigation Integrity', () {
    testWidgets('10. Bottom navigation contains exactly 4 canonical items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          home: Scaffold(
            bottomNavigationBar: MeowoirsBottomNavigation(
              currentRoute: '/',
              onNavigateToRoute: (_) {},
            ),
          ),
        ),
      );

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations.length, 4);
      // Ensure My Story is NOT a 5th bottom navigation destination
      expect(find.text('Hikayem'), findsNothing);
    });
  });

  group('Phase 3 — Section 10 & 11: Settings & Legal Documents', () {
    test('11. User-facing legal documents are exactly 3', () {
      final userFacing = LegalDocument.userFacing;
      expect(userFacing.length, 3);
      expect(userFacing, contains(LegalDocument.privacyPolicy));
      expect(userFacing, contains(LegalDocument.termsOfService));
      expect(userFacing, contains(LegalDocument.legalDisclaimer));
    });

    test('12. Canonical Legal URLs match exact specification', () {
      expect(LegalDocument.privacyPolicy.webUrl, 'https://limanexstudio.com/privacy/meowoirs');
      expect(LegalDocument.termsOfService.webUrl, 'https://limanexstudio.com/terms/meowoirs');
    });
  });

  group('Phase 3 — Section 5 & 24: Responsive UI for All 5 Memory View Modes', () {
    final sampleMemory = Memory(
      id: 'mem-1',
      catId: 'cat-1',
      catName: 'Pamuk',
      note: 'Güneşin altında mışıl mışıl uyudu ve çok sevimliydi.',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      catMood: 'Mutlu',
      userMood: 'Huzurlu',
    );

    final testWidths = [320.0, 360.0, 390.0, 412.0];
    final testScales = [1.0, 1.15, 1.3, 1.5];

    for (final width in testWidths) {
      testWidgets('13. Tiles view mode renders on width ${width}dp without overflow', (tester) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MemoryTilesView(
                memories: [sampleMemory],
                onNavigateToMemoryDetail: (_) {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('14. Large Icons view renders on width ${width}dp without overflow', (tester) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MemoryLargeIconsView(
                memories: [sampleMemory],
                onNavigateToMemoryDetail: (_) {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('15. Small Icons view renders on width ${width}dp without overflow', (tester) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MemorySmallIconsView(
                memories: [sampleMemory],
                onNavigateToMemoryDetail: (_) {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('16. List view renders on width ${width}dp without overflow', (tester) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MemoryListView(
                memories: [sampleMemory],
                onNavigateToMemoryDetail: (_) {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('17. Content view renders on width ${width}dp without overflow', (tester) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MemoryContentView(
                memories: [sampleMemory],
                onNavigateToMemoryDetail: (_) {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    }

    for (final scale in testScales) {
      testWidgets('18. Tiles view with text scale ${scale}x renders without overflow', (tester) async {
        tester.view.physicalSize = const Size(360 * 2, 800 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: MemoryTilesView(
                  memories: [sampleMemory],
                  onNavigateToMemoryDetail: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Phase 3 — Section 27: Brand Integrity Audit', () {
    test('19. Legal document titles contain no reference to VitaCase', () {
      for (final doc in LegalDocument.values) {
        expect(doc.title.toLowerCase().contains('vitacase'), isFalse);
        expect(doc.assetPath.toLowerCase().contains('vitacase'), isFalse);
      }
    });

    test('20. AppLocalizations contains supported 10 locales', () {
      expect(AppLocalizations.supportedLocales.length, 10);
      final codes = AppLocalizations.supportedLocales.map((l) => l.languageCode).toList();
      expect(codes, containsAll(['tr', 'en', 'de', 'fr', 'es', 'it', 'pt', 'nl', 'pl', 'ja']));
    });
  });

  group('Phase 3 — Section 13, 15, 18: AdMob & Database Release Gate', () {
    test('21. Production release config strictly matches production credentials', () {
      expect(AdConfig.releaseConfig.isTestAds, isFalse);
      expect(AdConfig.releaseConfig.environmentName, 'PRODUCTION');
      expect(AdConfig.releaseConfig.bannerAdUnitId, 'ca-app-pub-5877011177866406/2930394553');
      expect(AdConfig.releaseConfig.interstitialAdUnitId, 'ca-app-pub-5877011177866406/2195897382');
      expect(AdConfig.releaseConfig.appId, 'ca-app-pub-5877011177866406~4355156867');
    });

    test('22. Debug config strictly matches Google official test ad credentials', () {
      expect(AdConfig.debugConfig.isTestAds, isTrue);
      expect(AdConfig.debugConfig.environmentName, 'TEST');
      expect(AdConfig.debugConfig.bannerAdUnitId, 'ca-app-pub-3940256099942544/6300978111');
      expect(AdConfig.debugConfig.interstitialAdUnitId, 'ca-app-pub-3940256099942544/1033173712');
      expect(AdConfig.debugConfig.appId, 'ca-app-pub-5877011177866406~4355156867');
    });

    test('23. Database schema version is strictly 1', () {
      final db = MeowoirsDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());
      expect(db.schemaVersion, 1);
    });
  });
}
