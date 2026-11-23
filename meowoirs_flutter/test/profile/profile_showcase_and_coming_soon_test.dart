import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/config/app_config.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/routing/route_ui_policy.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/models/user_profile.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/profile/coming_soon_screen.dart';
import 'package:meowoirs/features/profile/limanex_apps_showcase_screen.dart';
import 'package:meowoirs/features/profile/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<PreferencesRepository> createTestPrefs({
    String nickname = 'LunaGuardian',
    String avatarId = '01_cat_happy',
  }) async {
    SharedPreferences.setMockInitialValues({});
    final sp = await SharedPreferences.getInstance();
    final repo = PreferencesRepository(sp);
    await repo.setUserProfile(
      UserProfile(nickname: nickname, avatarId: avatarId),
    );
    return repo;
  }

  Widget buildTestableProfile({
    required PreferencesRepository prefs,
    Locale locale = const Locale('en'),
    VoidCallback? onNavigateToSettings,
    VoidCallback? onNavigateToMyStory,
    VoidCallback? onNavigateToAddCat,
    ValueChanged<String>? onNavigateToCatDetail,
    VoidCallback? onNavigateToOtherApps,
    VoidCallback? onNavigateToComingSoon,
    List<Cat> cats = const [],
    List<Memory> memories = const [],
  }) {
    return ProviderScope(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(prefs),
        catsStreamProvider.overrideWith((_) => Stream.value(cats)),
        allMemoriesStreamProvider.overrideWith((_) => Stream.value(memories)),
      ],
      child: MaterialApp(
        locale: locale,
        theme: MeowoirsTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileScreen(
          onNavigateToSettings: onNavigateToSettings ?? () {},
          onNavigateToMyStory: onNavigateToMyStory ?? () {},
          onNavigateToAddCat: onNavigateToAddCat ?? () {},
          onNavigateToCatDetail: onNavigateToCatDetail ?? (_) {},
          onNavigateToOtherApps: onNavigateToOtherApps,
          onNavigateToComingSoon: onNavigateToComingSoon,
        ),
      ),
    );
  }

  group('1. Profile Screen — Two New Entry Buttons & Ordering', () {
    testWidgets(
      'Renders Try Our Other Apps and Coming Soon in exact order directly below Settings (EN & TR)',
      (tester) async {
        final prefs = await createTestPrefs();

        // English verification
        await tester.pumpWidget(
          buildTestableProfile(prefs: prefs, locale: const Locale('en')),
        );
        await tester.pumpAndSettle();

        final listFinder = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.byKey(const Key('profile_coming_soon_button')),
          200,
          scrollable: listFinder,
        );
        await tester.pumpAndSettle();

        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Try Our Other Apps'), findsOneWidget);
        expect(find.text('Discover more apps from LIMANEX'), findsOneWidget);
        expect(find.text('Coming Soon'), findsOneWidget);
        expect(find.text('See upcoming features'), findsOneWidget);

        final settingsY = tester.getTopLeft(find.text('Settings')).dy;
        final tryOtherAppsY = tester
            .getTopLeft(find.byKey(const Key('profile_try_other_apps_button')))
            .dy;
        final comingSoonY = tester
            .getTopLeft(find.byKey(const Key('profile_coming_soon_button')))
            .dy;

        expect(settingsY, lessThan(tryOtherAppsY));
        expect(tryOtherAppsY, lessThan(comingSoonY));

        // Turkish verification
        await tester.pumpWidget(
          buildTestableProfile(prefs: prefs, locale: const Locale('tr')),
        );
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.byKey(const Key('profile_coming_soon_button')),
          200,
          scrollable: listFinder,
        );
        await tester.pumpAndSettle();

        expect(find.text('Diğer Uygulamalarımızı Deneyin'), findsOneWidget);
        expect(find.text('LIMANEX uygulamalarını keşfedin'), findsOneWidget);
        expect(find.text('Yakında'), findsOneWidget);
        expect(
          find.text('Yakında gelecek özellikleri keşfedin'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Preserves existing Profile sections and Settings navigation callback',
      (tester) async {
        final prefs = await createTestPrefs(nickname: 'MochiOwner');
        int settingsTapCount = 0;
        int storyTapCount = 0;

        await tester.pumpWidget(
          buildTestableProfile(
            prefs: prefs,
            locale: const Locale('en'),
            onNavigateToSettings: () => settingsTapCount++,
            onNavigateToMyStory: () => storyTapCount++,
          ),
        );
        await tester.pumpAndSettle();

        // Profile header nickname is preserved
        expect(find.textContaining('MochiOwner'), findsOneWidget);

        // Scroll to Settings and tap
        final listFinder = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.text('Settings'),
          200,
          scrollable: listFinder,
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();
        expect(settingsTapCount, 1);
      },
    );
  });

  group('2 & 3. Navigation, Duplicate-Tap Guard, & Back Navigation', () {
    testWidgets(
      'Navigating to LIMANEX Showcase and Coming Soon and returning via back button preserves Profile state',
      (tester) async {
        final prefs = await createTestPrefs(nickname: 'PamukCaregiver');

        await tester.pumpWidget(
          buildTestableProfile(prefs: prefs, locale: const Locale('en')),
        );
        await tester.pumpAndSettle();

        final listFinder = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.byKey(const Key('profile_coming_soon_button')),
          200,
          scrollable: listFinder,
        );
        await tester.pumpAndSettle();

        // 1. Open Try Our Other Apps
        await tester.tap(find.byKey(const Key('profile_try_other_apps_button')));
        await tester.pumpAndSettle();

        expect(find.byType(LimanexAppsShowcaseScreen), findsOneWidget);
        expect(
          find.byKey(const Key('limanex_studio_intro_section')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('vitacase_showcase_section')),
          findsOneWidget,
        );

        // Return back to Profile
        await tester.tap(find.byKey(const Key('limanex_showcase_back_button')));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);

        // 2. Open Coming Soon
        await tester.tap(find.byKey(const Key('profile_coming_soon_button')));
        await tester.pumpAndSettle();

        expect(find.byType(ComingSoonScreen), findsOneWidget);
        expect(find.byKey(const Key('coming_soon_header_card')), findsOneWidget);

        // Return back to Profile
        await tester.tap(find.byKey(const Key('coming_soon_back_button')));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);

        // Scroll back to top and confirm profile state is intact
        await tester.drag(listFinder, const Offset(0, 500));
        await tester.pumpAndSettle();
        expect(find.textContaining('PamukCaregiver'), findsOneWidget);
      },
    );

    testWidgets(
      'Prevents duplicate route pushes on rapid repeated taps within the same frame',
      (tester) async {
        final prefs = await createTestPrefs();
        int otherAppsTapCount = 0;
        int comingSoonTapCount = 0;

        await tester.pumpWidget(
          buildTestableProfile(
            prefs: prefs,
            onNavigateToOtherApps: () => otherAppsTapCount++,
            onNavigateToComingSoon: () => comingSoonTapCount++,
          ),
        );
        await tester.pumpAndSettle();

        final listFinder = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.byKey(const Key('profile_coming_soon_button')),
          200,
          scrollable: listFinder,
        );
        await tester.pumpAndSettle();

        // Rapid double tap before next frame completes
        await tester.tap(find.byKey(const Key('profile_try_other_apps_button')));
        await tester.tap(find.byKey(const Key('profile_try_other_apps_button')));
        expect(otherAppsTapCount, 1);

        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('profile_coming_soon_button')));
        await tester.tap(find.byKey(const Key('profile_coming_soon_button')));
        expect(comingSoonTapCount, 1);
      },
    );
  });

  group('4 & 5. Coming Soon — Exact Feature Ordering & Zero Version Numbers', () {
    testWidgets(
      'Displays all 8 upcoming features in exact required order in English and Turkish',
      (tester) async {
        const expectedEnTitles = [
          'Memory Collage',
          'Cat Timeline',
          'On This Day',
          'Our Story',
          'Memory Reminders',
          'Archive Improvements',
          'Shareable Memory Designs',
          'Personal Archive Tools',
        ];

        const expectedTrTitles = [
          'Anı Kolajı',
          'Kedi Hikâyesi',
          'Bu Günün Anısı',
          'Bizim Hikâyemiz',
          'Anı Hatırlatmaları',
          'Anı Arşivi İyileştirmeleri',
          'Paylaşılabilir Anı Tasarımları',
          'Kişisel Arşiv Araçları',
        ];

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                final features = ComingSoonScreen.buildFeatures(l10n);
                expect(
                  features.map((f) => f.title).toList(),
                  expectedEnTitles,
                );
                return const ComingSoonScreen();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Exciting new features are on the way to make Meowoirs even more special!',
          ),
          findsOneWidget,
        );

        // Scroll through the list to verify all 8 cards render in order
        final scrollable = find.byType(Scrollable).first;
        for (int i = 0; i < expectedEnTitles.length; i++) {
          final key = Key('coming_soon_feature_${i + 1}');
          await tester.scrollUntilVisible(
            find.byKey(key),
            180,
            scrollable: scrollable,
          );
          await tester.pumpAndSettle();
          expect(find.byKey(key), findsOneWidget);
          expect(find.text(expectedEnTitles[i]), findsOneWidget);
        }

        // Turkish verification (fresh key so scroll controller starts at top)
        await tester.pumpWidget(
          MaterialApp(
            key: const ValueKey('tr_coming_soon_app'),
            locale: const Locale('tr'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                final features = ComingSoonScreen.buildFeatures(l10n);
                expect(
                  features.map((f) => f.title).toList(),
                  expectedTrTitles,
                );
                return const ComingSoonScreen();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            "Meowoirs'i daha da özel hale getirecek yeni özellikler yolda!",
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Strictly contains zero version badges (v0.2–v0.9) or release dates across all 10 locales',
      (tester) async {
        final forbiddenPatterns = [
          RegExp(r'\bv0\.[1-9]\b', caseSensitive: false),
          RegExp(r'\b0\.[2-9]\b'),
          RegExp(r'\bversion\s*\d', caseSensitive: false),
          RegExp(r'\bsürüm\s*\d', caseSensitive: false),
          RegExp(r'\b202[4-9]\b'),
          RegExp(r'\bQ[1-4]\b'),
        ];

        for (final locale in AppLocalizations.supportedLocales) {
          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              theme: MeowoirsTheme.lightTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  final features = ComingSoonScreen.buildFeatures(l10n);
                  final allTexts = <String>[
                    l10n.comingSoonPageTitle,
                    l10n.comingSoonHeaderIntro,
                    for (final f in features) ...[f.title, f.description],
                  ];

                  for (final text in allTexts) {
                    for (final pattern in forbiddenPatterns) {
                      expect(
                        pattern.hasMatch(text),
                        isFalse,
                        reason:
                            'Locale ${locale.languageCode} text "$text" matched forbidden version/date pattern ${pattern.pattern}',
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
          await tester.pump();
        }
      },
    );
  });

  group('6. Localization Across All 10 Supported Locales', () {
    testWidgets(
      'All 10 supported locales provide non-empty localized strings for Profile buttons, LIMANEX showcase, and Coming Soon',
      (tester) async {
        expect(AppLocalizations.supportedLocales.length, 10);

        for (final locale in AppLocalizations.supportedLocales) {
          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              theme: MeowoirsTheme.lightTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  final values = [
                    l10n.profileTryOtherAppsTitle,
                    l10n.profileTryOtherAppsSubtitle,
                    l10n.profileComingSoonTitle,
                    l10n.profileComingSoonSubtitle,
                    l10n.limanexAppsPageTitle,
                    l10n.limanexStudioBadge,
                    l10n.limanexStudioWelcome,
                    l10n.vitaCaseAppName,
                    l10n.vitaCaseTagline,
                    l10n.vitaCaseDescription,
                    l10n.vitaCaseCtaExplore,
                    l10n.vitaCaseLaunchFallbackMessage,
                    l10n.vitaCasePromoPlaceholderLabel,
                    l10n.comingSoonPageTitle,
                    l10n.comingSoonHeaderIntro,
                    l10n.comingSoonFeature1Title,
                    l10n.comingSoonFeature1Desc,
                    l10n.comingSoonFeature2Title,
                    l10n.comingSoonFeature2Desc,
                    l10n.comingSoonFeature3Title,
                    l10n.comingSoonFeature3Desc,
                    l10n.comingSoonFeature4Title,
                    l10n.comingSoonFeature4Desc,
                    l10n.comingSoonFeature5Title,
                    l10n.comingSoonFeature5Desc,
                    l10n.comingSoonFeature6Title,
                    l10n.comingSoonFeature6Desc,
                    l10n.comingSoonFeature7Title,
                    l10n.comingSoonFeature7Desc,
                    l10n.comingSoonFeature8Title,
                    l10n.comingSoonFeature8Desc,
                  ];

                  for (final v in values) {
                    expect(
                      v.trim(),
                      isNotEmpty,
                      reason:
                          'Empty localization value found for locale ${locale.languageCode}',
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
          await tester.pump();
        }
      },
    );
  });

  group('7. Scroll Behavior & Compact / Scaled Viewport Overflow Checks', () {
    testWidgets(
      'LimanexAppsShowcaseScreen and ComingSoonScreen scroll cleanly without overflow on compact 320x533 screen with 1.3x text scale',
      (tester) async {
        tester.view.physicalSize = const Size(320, 533);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // 1. Test LimanexAppsShowcaseScreen on compact screen + 1.3x text scale
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('de'), // German has longer strings
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.3),
              ),
              child: child!,
            ),
            home: const LimanexAppsShowcaseScreen(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.drag(
          find.byKey(const Key('limanex_showcase_scroll_view')),
          const Offset(0, -400),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // 2. Test ComingSoonScreen on compact screen + 1.3x text scale
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('de'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.3),
              ),
              child: child!,
            ),
            home: const ComingSoonScreen(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        for (int i = 0; i < 5; i++) {
          await tester.drag(
            find.byKey(const Key('coming_soon_scroll_view')),
            const Offset(0, -350),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      },
    );
  });

  group('8. VitaCase Showcase Layout, CTA Destination & Placeholder Handling', () {
    testWidgets(
      'Renders vertical two-section layout (LIMANEX intro above VitaCase card) and launches Play Store URL on CTA tap',
      (tester) async {
        final launchedUris = <Uri>[];

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LimanexAppsShowcaseScreen(
              urlLauncherOverride: (uri) async {
                launchedUris.add(uri);
                return true;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final introFinder =
            find.byKey(const Key('limanex_studio_intro_section'));
        final vitaCaseFinder =
            find.byKey(const Key('vitacase_showcase_section'));

        expect(introFinder, findsOneWidget);
        expect(vitaCaseFinder, findsOneWidget);
        expect(find.byKey(const Key('limanex_intro_down_arrow')), findsOneWidget);
        expect(find.text('VitaCase'), findsOneWidget);
        expect(
          find.text('Your Personal Health & Wellness Companion'),
          findsOneWidget,
        );

        // Verify vertical arrangement: Section 1 is above Section 2
        final introTop = tester.getTopLeft(introFinder).dy;
        final vitaCaseTop = tester.getTopLeft(vitaCaseFinder).dy;
        expect(introTop, lessThan(vitaCaseTop));

        // Scroll to CTA button and tap
        final ctaFinder = find.byKey(const Key('vitacase_cta_button'));
        await tester.scrollUntilVisible(
          ctaFinder,
          150,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        await tester.tap(ctaFinder);
        await tester.pumpAndSettle();

        expect(launchedUris, [Uri.parse(AppConfig.vitaCasePlayStoreUrl)]);
      },
    );

    testWidgets(
      'Shows safe localized SnackBar fallback when neither store URL nor web fallback can be opened',
      (tester) async {
        final attemptedUris = <Uri>[];

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LimanexAppsShowcaseScreen(
              urlLauncherOverride: (uri) async {
                attemptedUris.add(uri);
                return false;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final ctaFinder = find.byKey(const Key('vitacase_cta_button'));
        await tester.scrollUntilVisible(
          ctaFinder,
          150,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        await tester.tap(ctaFinder);
        await tester.pumpAndSettle();

        expect(attemptedUris.length, 2);
        expect(attemptedUris[0].toString(), AppConfig.vitaCasePlayStoreUrl);
        expect(attemptedUris[1].toString(), AppConfig.vitaCaseWebUrl);
        expect(
          find.byKey(const Key('vitacase_fallback_snackbar')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Renders clean structured promotional placeholder when simulateMissingPromoAsset is true',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const LimanexAppsShowcaseScreen(
              simulateMissingPromoAsset: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('vitacase_promo_placeholder')),
          findsOneWidget,
        );
      },
    );
  });

  group('9. RouteUiPolicy Verification for New Subpages', () {
    test('Bottom nav, FAB, and banner ads are hidden on /other_apps and /coming_soon', () {
      expect(RouteUiPolicy.shouldShowBottomNav('/other_apps'), isFalse);
      expect(RouteUiPolicy.shouldShowBottomNav('/coming_soon'), isFalse);
      expect(RouteUiPolicy.shouldShowFab('/other_apps'), isFalse);
      expect(RouteUiPolicy.shouldShowFab('/coming_soon'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/other_apps'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/coming_soon'), isFalse);
    });
  });
}
