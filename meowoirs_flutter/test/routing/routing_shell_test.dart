import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/localization/supported_languages.dart';
import 'package:meowoirs/core/routing/app_router.dart';
import 'package:meowoirs/core/routing/route_ui_policy.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/widgets/meowoirs_fab.dart';

Widget createTestApp({
  required ProviderContainer container,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        final themeMode = ref.watch(themeModeStreamProvider).value;
        final languageCode = ref.watch(languageCodeStreamProvider).value;

        Locale? locale;
        if (languageCode != null && languageCode.isNotEmpty) {
          final isSupported = supportedLanguages.any((l) => l.code == languageCode);
          locale = isSupported ? Locale(languageCode) : const Locale('tr');
        } else {
          locale = const Locale('tr');
        }

        return MaterialApp.router(
          title: 'Meowoirs Test',
          debugShowCheckedModeBanner: false,
          theme: MeowoirsTheme.lightTheme,
          darkTheme: MeowoirsTheme.darkTheme,
          themeMode: switch (themeMode) {
            null => ThemeMode.system,
            _ => switch (themeMode) {
                AppThemeMode.light => ThemeMode.light,
                AppThemeMode.dark => ThemeMode.dark,
                AppThemeMode.system => ThemeMode.system,
              },
          },
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      },
    ),
  );
}

void main() {
  late MeowoirsDatabase db;
  late PreferencesRepository prefsRepo;
  late DriftMeowoirsRepository repo;
  late ProviderContainer container;

  setUp(() async {
    db = MeowoirsDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefsRepo = PreferencesRepository(prefs);

    repo = DriftMeowoirsRepository(
      catDao: db.catDao,
      memoryDao: db.memoryDao,
      preferencesRepository: prefsRepo,
    );

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        preferencesRepositoryProvider.overrideWithValue(prefsRepo),
        repositoryProvider.overrideWithValue(repo),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
    prefsRepo.dispose();
  });

  group('Phase 5 — Routing & Main Scaffold Verification', () {
    // 1. Onboarding false redirects to /onboarding
    testWidgets('1. When onboarding is false, router redirects to /onboarding', (tester) async {
      await prefsRepo.resetOnboarding();

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Devam Et →'), findsOneWidget); // Onboarding Page 1 CTA button
      expect(find.text('CİLT I — BÖLÜM 01'), findsOneWidget);
    });

    // 2. Onboarding true redirects to / (Home)
    testWidgets('2. When onboarding is true, router lands on Home screen', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Meowoirs'), findsWidgets);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    // 3. Exactly 4 bottom navigation destinations
    testWidgets('3. Bottom navigation contains exactly 4 destinations with Turkish labels', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations.length, 4);

      expect(find.text('ANA SAYFA'), findsOneWidget);
      expect(find.text('KEDİLER'), findsOneWidget);
      expect(find.text('ANILAR'), findsOneWidget);
      expect(find.text('PROFİL'), findsOneWidget);
    });

    // 4. Correct tab navigation across the 4 tabs
    testWidgets('4. Switching tabs updates navigation shell branch and preserved state', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      // Tap KEDİLER tab
      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();
      expect(find.text('Kedilerim'), findsWidgets);

      // Tap ANILAR tab
      await tester.tap(find.text('ANILAR'));
      await tester.pumpAndSettle();
      expect(find.text('Anılar'), findsWidgets);

      // Tap PROFİL tab
      await tester.tap(find.text('PROFİL'));
      await tester.pumpAndSettle();
      expect(find.text('PROFİL'), findsWidgets);

      // Tap ANA SAYFA tab
      await tester.tap(find.text('ANA SAYFA'));
      await tester.pumpAndSettle();
      expect(find.text('Meowoirs'), findsWidgets);
    });

    // 5. Profile -> My Story
    testWidgets('5. Navigating from Profile to My Story and back', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      // Navigate to Profile
      await tester.tap(find.text('PROFİL'));
      await tester.pumpAndSettle();

      // Scroll to find Tüm Hikâyeyi Gör if needed
      final myStoryCard = find.text('Tüm Hikâyeyi Gör');
      await tester.scrollUntilVisible(myStoryCard, 300);
      expect(myStoryCard, findsOneWidget);
      await tester.tap(myStoryCard);
      await tester.pumpAndSettle();

      // Now on My Story screen
      expect(find.text('Hikâyem'), findsWidgets);
      expect(find.text('Sen ve kedilerin arasında biriken küçük anlar.'), findsOneWidget);

      // Back navigation returns to Profile
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
      } else {
        final backIcon = find.byIcon(Icons.arrow_back);
        expect(backIcon, findsOneWidget);
        await tester.tap(backIcon);
      }
      await tester.pumpAndSettle();
      expect(find.text('PROFİL'), findsWidgets);
    });

    // 6. FAB -> Add Memory
    testWidgets('6. Tapping global FAB navigates to Add Memory', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      final fab = find.byType(MeowoirsFab);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('Anı Ekle'), findsWidgets);
    });

    // 7. Add Memory does NOT show FAB
    testWidgets('7. Add Memory screen does not show FAB or Bottom Navigation', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      // Tap FAB to open Add Memory
      await tester.tap(find.byType(MeowoirsFab));
      await tester.pumpAndSettle();

      expect(find.byType(MeowoirsFab), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    });

    // 8. Settings does NOT show FAB
    testWidgets('8. Settings screen does not show FAB or Bottom Navigation', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      // Navigate to Profile
      await tester.tap(find.text('PROFİL'));
      await tester.pumpAndSettle();

      // Scroll and Tap Ayarlar entry card
      final settingsCard = find.text('Ayarlar');
      await tester.scrollUntilVisible(settingsCard, 300);
      expect(settingsCard, findsOneWidget);
      await tester.tap(settingsCard);
      await tester.pumpAndSettle();

      expect(find.text('Ayarlar'), findsWidgets);
      expect(find.byType(MeowoirsFab), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    });

    // 9. RouteUiPolicy centralization tests
    test('9. RouteUiPolicy centralization verifies FAB and bottom nav policies', () {
      expect(RouteUiPolicy.isTopLevel('/'), isTrue);
      expect(RouteUiPolicy.isTopLevel('/cats'), isTrue);
      expect(RouteUiPolicy.isTopLevel('/memories'), isTrue);
      expect(RouteUiPolicy.isTopLevel('/profile'), isTrue);

      expect(RouteUiPolicy.shouldShowBottomNav('/cats/add'), isFalse);
      expect(RouteUiPolicy.shouldShowBottomNav('/memories/add'), isFalse);
      expect(RouteUiPolicy.shouldShowBottomNav('/settings'), isFalse);
      expect(RouteUiPolicy.shouldShowBottomNav('/story'), isFalse);

      expect(RouteUiPolicy.shouldShowFab('/'), isTrue);
      expect(RouteUiPolicy.shouldShowFab('/cats'), isTrue);
      expect(RouteUiPolicy.shouldShowFab('/memories'), isTrue);
      expect(RouteUiPolicy.shouldShowFab('/settings'), isFalse);
      expect(RouteUiPolicy.shouldShowFab('/memories/add'), isFalse);
      expect(RouteUiPolicy.shouldShowFab('/cats/add'), isFalse);
      expect(RouteUiPolicy.shouldShowFab('/onboarding'), isFalse);
    });

    // 10. Valid cat route
    testWidgets('10. Valid cat detail route displays cat information', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat_valid_1',
        name: 'Süslü',
        type: CatType.home,
        note: 'Çok oyuncu',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cats/cat_valid_1');
      await tester.pumpAndSettle();

      expect(find.text('Süslü'), findsWidgets);
      expect(find.text('Ev Kedisi'), findsOneWidget);
      expect(find.text("Süslü'nün Hikâyesi"), findsOneWidget);
    });

    // 11. Invalid cat route shows friendly not-found UI without crashing
    testWidgets('11. Invalid cat ID shows friendly not-found UI', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cats/nonexistent_cat_999');
      await tester.pumpAndSettle();

      expect(find.text('Kedi bulunamadı'), findsOneWidget);
      expect(find.text('Geri'), findsOneWidget);
    });

    // 12. Valid memory route
    testWidgets('12. Valid memory detail route displays memory details', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 100));
      await repo.addMemory(const Memory(
        id: 'mem_valid_1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Kutuda uyudu',
        createdAt: 200,
      ));

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/memories/mem_valid_1');
      await tester.pumpAndSettle();

      expect(find.text('Kutuda uyudu'), findsOneWidget);
      expect(find.text('Pamuk'), findsWidgets);
    });

    // 13. Invalid memory route shows friendly not-found UI without crashing
    testWidgets('13. Invalid memory ID shows friendly not-found UI', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/memories/nonexistent_memory_999');
      await tester.pumpAndSettle();

      expect(find.text('Anı bulunamadı'), findsOneWidget);
      expect(find.text('Geri'), findsOneWidget);
    });

    // 14. Theme integration updates MaterialApp.router
    testWidgets('14. Changing theme mode persists and updates MaterialApp.router themeMode', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode, ThemeMode.system);

      // Change to dark mode
      await prefsRepo.updateThemeMode(AppThemeMode.dark);
      await tester.pumpAndSettle();

      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode, ThemeMode.dark);
    });

    // 15. Language integration
    testWidgets('15. Changing language persists and updates app locale', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      // Update to German ('de')
      await prefsRepo.updateLanguageCode('de');
      await tester.pumpAndSettle();

      expect(prefsRepo.getLanguageCode(), 'de');
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.locale?.languageCode, 'de');
    });

    // 16. Route aliases
    testWidgets('16. Compatibility route aliases redirect cleanly', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      final router = container.read(routerProvider);

      // /my_story alias
      router.go('/my_story');
      await tester.pumpAndSettle();
      expect(find.text('Hikâyem'), findsWidgets);

      // /add_cat alias
      router.go('/add_cat');
      await tester.pumpAndSettle();
      expect(find.text('Yeni Kedi'), findsWidgets);

      // /add_memory alias
      router.go('/add_memory');
      await tester.pumpAndSettle();
      expect(find.text('Anı Ekle'), findsWidgets);
    });

    // 17. Back navigation logic
    testWidgets('17. Popping returns back to previous screen in stack', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createTestApp(container: container));
      await tester.pumpAndSettle();

      final router = container.read(routerProvider);

      // Push settings from home
      router.push('/settings');
      await tester.pumpAndSettle();
      expect(find.text('Ayarlar'), findsWidgets);

      // Pop
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('Ayarlar'), findsNothing);
      expect(find.text('Meowoirs'), findsWidgets);
    });
  });
}
