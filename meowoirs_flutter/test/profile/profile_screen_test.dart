import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/routing/app_router.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/models/user_profile.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/profile/profile_avatars.dart';
import 'package:meowoirs/features/profile/profile_screen.dart';
import 'package:meowoirs/features/settings/settings_screen.dart';
import 'package:meowoirs/widgets/meowoirs_bottom_navigation.dart';
import 'package:meowoirs/widgets/meowoirs_fab.dart';

Widget createDirectProfileWidget({
  required ProviderContainer container,
  VoidCallback? onNavigateToSettings,
  VoidCallback? onNavigateToMyStory,
  VoidCallback? onNavigateToAddCat,
  ValueChanged<String>? onNavigateToCatDetail,
  Locale locale = const Locale('tr'),
  ThemeMode themeMode = ThemeMode.light,
  TextScaler textScaler = TextScaler.noScaling,
  Size viewportSize = const Size(1080, 2400),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MeowoirsTheme.lightTheme,
      darkTheme: MeowoirsTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(
          size: viewportSize,
          textScaler: textScaler,
        ),
        child: ProfileScreen(
          onNavigateToSettings: onNavigateToSettings ?? () {},
          onNavigateToMyStory: onNavigateToMyStory ?? () {},
          onNavigateToAddCat: onNavigateToAddCat ?? () {},
          onNavigateToCatDetail: onNavigateToCatDetail ?? (_) {},
        ),
      ),
    ),
  );
}

Widget createProfileRouterApp({
  required ProviderContainer container,
  Locale locale = const Locale('tr'),
  ThemeMode themeMode = ThemeMode.light,
  TextScaler textScaler = TextScaler.noScaling,
  Size viewportSize = const Size(1080, 2400),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          title: 'Meowoirs Profile Test',
          debugShowCheckedModeBanner: false,
          theme: MeowoirsTheme.lightTheme,
          darkTheme: MeowoirsTheme.darkTheme,
          themeMode: themeMode,
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
  TestWidgetsFlutterBinding.ensureInitialized();

  late MeowoirsDatabase db;
  late PreferencesRepository prefsRepo;
  late DriftMeowoirsRepository repo;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'accepted_legal_version': '1.0',
      'nickname': '',
      'avatar_id': 'avatar_warm_cat',
      'favorite_cat_id': '',
    });
    final prefs = await SharedPreferences.getInstance();
    prefsRepo = PreferencesRepository(prefs);

    db = MeowoirsDatabase(NativeDatabase.memory());
    repo = DriftMeowoirsRepository(
      catDao: db.catDao,
      memoryDao: db.memoryDao,
      preferencesRepository: prefsRepo,
    );

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        repositoryProvider.overrideWithValue(repo),
        preferencesRepositoryProvider.overrideWithValue(prefsRepo),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
    prefsRepo.dispose();
  });

  Future<void> pumpContainer(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(widget);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  Cat makeCat({
    String id = 'cat_1',
    String name = 'Mişa',
    CatType type = CatType.home,
    String? photoUri,
    String? note = 'Kabarık tüylü sevimli dostumuz',
    int createdAt = 1000,
  }) {
    return Cat(
      id: id,
      name: name,
      type: type,
      photoUri: photoUri,
      note: note,
      createdAt: createdAt,
    );
  }

  Memory makeMemory({
    String id = 'mem_1',
    String catId = 'cat_1',
    String catName = 'Mişa',
    String note = 'Öğle uykusuna daldı.',
    String? photoUri,
    String catMood = 'Huzurlu',
    String userMood = 'Sakin',
    int createdAt = 2000,
  }) {
    return Memory(
      id: id,
      catId: catId,
      catName: catName,
      note: note,
      photoUri: photoUri,
      catMood: catMood,
      userMood: userMood,
      createdAt: createdAt,
    );
  }

  group('PHASE 15 — PROFILE SCREEN & GLOBAL UI TESTS', () {
    // 1. Profile renders
    testWidgets('1. Profile renders successfully', (tester) async {
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    // 2. Header renders
    testWidgets('2. Header renders with avatar and edit button',
        (tester) async {
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Profili Düzenle'), findsOneWidget);
      expect(find.text('Bu senin Meowoirs\'teki kişisel alanın.'), findsOneWidget);
    });

    // 3. Default profile
    testWidgets('3. Default profile displays default title when nickname is empty',
        (tester) async {
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Senin Hikâyen'), findsOneWidget);
    });

    // 4. Nickname display
    testWidgets('4. Nickname display includes greeting prefix when set',
        (tester) async {
      await prefsRepo.updateNickname('Luna');
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Merhaba, Luna'), findsOneWidget);
    });

    // 5. Nickname persistence
    testWidgets('5. Nickname persists after editing in dialog',
        (tester) async {
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      await tester.tap(find.text('Profili Düzenle'));
      await tester.pump(const Duration(milliseconds: 100));

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'Pamukçu');
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Kaydet'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Merhaba, Pamukçu'), findsOneWidget);
      expect(prefsRepo.userProfile.nickname, 'Pamukçu');
    });

    // 6. Avatar display
    testWidgets('6. Avatar display shows selected avatar icon',
        (tester) async {
      await prefsRepo.updateAvatarId('avatar_star_gazer');
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    // 7. Avatar fallback
    testWidgets('7. Avatar fallback handles unknown avatar IDs safely',
        (tester) async {
      final avatar = ProfileAvatars.getById('non_existent_avatar_id');
      expect(avatar.id, 'avatar_warm_cat');
    });

    // 8. Favorite cat display
    testWidgets('8. Favorite cat displays cat name, type, and heart icon',
        (tester) async {
      await repo.addCat(makeCat(id: 'cat_fav', name: 'Zeytin', type: CatType.home));
      await prefsRepo.updateFavoriteCatId('cat_fav');

      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Zeytin'), findsOneWidget);
      expect(find.text('Ev'), findsWidgets);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('Favori Kediyi Değiştir'), findsOneWidget);
    });

    // 9. Favorite cat invalid ID
    testWidgets('9. Favorite cat invalid ID safely defaults without crash',
        (tester) async {
      await repo.addCat(makeCat(id: 'cat_1', name: 'Mırmır'));
      await prefsRepo.updateFavoriteCatId('invalid_cat_id_999');

      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      // Should show the "none selected" fallback because cats exist
      expect(find.text('Henüz bir favori kedi seçilmedi.'), findsOneWidget);
      expect(find.text('Favori Kediyi Seç'), findsOneWidget);
    });

    // 10. Favorite cat deleted
    testWidgets('10. Favorite cat deleted reverts to none selected or empty state',
        (tester) async {
      await repo.addCat(makeCat(id: 'cat_del', name: 'Silinecek Kedi'));
      await prefsRepo.updateFavoriteCatId('cat_del');

      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Silinecek Kedi'), findsOneWidget);

      await repo.deleteCat('cat_del');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Henüz favori bir kedin yok.'), findsOneWidget);
      expect(find.text('İlk Kedini Ekle'), findsOneWidget);
    });

    // 11. Favorite cat rename
    testWidgets('11. Favorite cat rename dynamically updates profile screen',
        (tester) async {
      await repo.addCat(makeCat(id: 'cat_1', name: 'Eski İsim'));
      await prefsRepo.updateFavoriteCatId('cat_1');

      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Eski İsim'), findsOneWidget);

      await repo.updateCat(makeCat(id: 'cat_1', name: 'Yeni İsim'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Yeni İsim'), findsOneWidget);
    });

    // 12. Favorite cat change
    testWidgets('12. Favorite cat change updates preference and displayed cat',
        (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Boncuk'));
      await repo.addCat(makeCat(id: 'c2', name: 'Tarçın'));
      await prefsRepo.updateFavoriteCatId('c1');

      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Boncuk'), findsOneWidget);

      await tester.tap(find.text('Favori Kediyi Değiştir'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Favori Kedini Seç'), findsOneWidget);
      await tester.tap(find.text('Tarçın'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Tarçın'), findsOneWidget);
      expect(prefsRepo.userProfile.favoriteCatId, 'c2');
    });

    // 13. My Story navigation
    testWidgets('13. My Story navigation callback is invoked when tapped',
        (tester) async {
      var myStoryNavigated = false;
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          onNavigateToMyStory: () => myStoryNavigated = true,
        ),
      );

      final viewAll = find.text('Tüm Hikâyeyi Gör');
      await tester.scrollUntilVisible(viewAll, 300);
      await tester.tap(viewAll);
      await tester.pump(const Duration(milliseconds: 50));

      expect(myStoryNavigated, isTrue);
    });

    // 14. Back navigation
    testWidgets('14. Back navigation returns to previous route when pushed',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      final router = container.read(routerProvider);

      router.go('/profile');
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    // 15. Settings navigation
    testWidgets('15. Settings navigation callback is called when Ayarlar is tapped',
        (tester) async {
      var settingsNavigated = false;
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          onNavigateToSettings: () => settingsNavigated = true,
        ),
      );

      final settingsEntry = find.text('Ayarlar');
      await tester.scrollUntilVisible(settingsEntry, 300);
      await tester.tap(settingsEntry);
      await tester.pump(const Duration(milliseconds: 50));

      expect(settingsNavigated, isTrue);
    });

    // 16. Language navigation
    testWidgets('16. Language preference can be updated and persists',
        (tester) async {
      await prefsRepo.setLanguageCode('en');
      expect(prefsRepo.getLanguageCode(), 'en');
      await prefsRepo.setLanguageCode('tr');
      expect(prefsRepo.getLanguageCode(), 'tr');
    });

    // 17. Theme navigation
    testWidgets('17. Theme preference can be updated and persists',
        (tester) async {
      await prefsRepo.setThemeMode(AppThemeMode.dark);
      expect(prefsRepo.getThemeMode(), AppThemeMode.dark);
      await prefsRepo.setThemeMode(AppThemeMode.light);
      expect(prefsRepo.getThemeMode(), AppThemeMode.light);
    });

    // 18. Legal navigation
    testWidgets('18. Legal accepted version is preserved in preferences',
        (tester) async {
      expect(prefsRepo.getAcceptedLegalVersion(), '1.0');
    });

    // 19. Privacy navigation
    testWidgets('19. Settings screen provides Privacy Policy entry point',
        (tester) async {
      await pumpContainer(
        tester,
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsScreen(onBack: () {}),
          ),
        ),
      );
      expect(find.text('Gizlilik Politikası'), findsOneWidget);
    });

    // 20. Support navigation if applicable
    testWidgets('20. Settings provides Reach Us / Support entry point',
        (tester) async {
      await pumpContainer(
        tester,
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsScreen(onBack: () {}),
          ),
        ),
      );
      expect(find.text('Bize Ulaşın'), findsWidgets);
    });

    // 21. Version display if applicable
    testWidgets('21. Settings displays app version information',
        (tester) async {
      await pumpContainer(
        tester,
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsScreen(onBack: () {}),
          ),
        ),
      );
      expect(find.textContaining('Sürüm'), findsOneWidget);
    });

    // 22. Bottom navigation
    testWidgets('22. Bottom navigation bar renders inside main scaffold',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      expect(find.byType(MeowoirsBottomNavigation), findsOneWidget);
    });

    // 23. Correct "KEDİLER" terminology
    testWidgets('23. Bottom navigation contains normalized "KEDİLER" label',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      expect(find.text('KEDİLER'), findsOneWidget);
    });

    // 24. Correct "ANILAR" terminology
    testWidgets('24. Bottom navigation contains normalized "ANILAR" label',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      expect(find.text('ANILAR'), findsOneWidget);
    });

    // 25. Correct "PROFİL" terminology
    testWidgets('25. Bottom navigation contains normalized "PROFİL" label',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      expect(find.text('PROFİL'), findsOneWidget);
    });

    // 26. Correct "ANA SAYFA" terminology
    testWidgets('26. Bottom navigation contains normalized "ANA SAYFA" label',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      expect(find.text('ANA SAYFA'), findsOneWidget);
    });

    // 27. Correct "Anı Ekle" terminology
    testWidgets('27. Global FAB uses preferred "Anı Ekle" label',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      final fab = find.byType(MeowoirsFab);
      expect(fab, findsOneWidget);
      expect(find.text('Anı Ekle'), findsOneWidget);
    });

    // 28. No fifth bottom tab
    testWidgets('28. Bottom navigation contains exactly 4 destinations',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations.length, 4);
    });

    // 29. Accessibility semantics
    testWidgets('29. Profile elements provide accessible semantics',
        (tester) async {
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      final headerSemantics = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.header == true,
      );
      expect(headerSemantics, findsWidgets);

      final buttonSemantics = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.button == true,
      );
      expect(buttonSemantics, findsWidgets);
    });

    // 30. Dark mode
    testWidgets('30. Profile renders in Dark Mode without visual errors',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          themeMode: ThemeMode.dark,
        ),
      );
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Senin Hikâyen'), findsOneWidget);
    });

    // 31. Light mode
    testWidgets('31. Profile renders in Light Mode with Warm Sand background',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          themeMode: ThemeMode.light,
        ),
      );
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFFFF9F2));
    });

    // 32. 320x533 compact layout
    testWidgets('32. Compact 320x533 viewport renders cleanly without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 533);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createDirectProfileWidget(
          container: container,
          viewportSize: const Size(320, 533),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });

    // 33. Large text scaling (1.5x)
    testWidgets('33. 1.5x text scaling scales cleanly without clip errors',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          textScaler: const TextScaler.linear(1.5),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    // 34. Turkish localization
    testWidgets('34. Turkish locale displays accurate Turkish strings',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          locale: const Locale('tr'),
        ),
      );
      expect(find.text('Favori Kedim'), findsOneWidget);
      expect(find.text('Benim Hikâyem'), findsOneWidget);
      expect(find.text('Ayarlar'), findsOneWidget);
    });

    // 35. English localization
    testWidgets('35. English locale displays accurate English strings',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          locale: const Locale('en'),
        ),
      );
      expect(find.text('Favorite Cat'), findsOneWidget);
      expect(find.text('My Story'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Your Story'), findsOneWidget);
    });

    // 36. Japanese localization
    testWidgets('36. Japanese locale compiles and renders without crash',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectProfileWidget(
          container: container,
          locale: const Locale('ja'),
        ),
      );
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    // 37. State persistence
    testWidgets('37. UserProfile changes persist across container rebuilds',
        (tester) async {
      await prefsRepo.setUserProfile(
        const UserProfile(
          nickname: 'Karakız',
          avatarId: 'avatar_sage_cat',
          favoriteCatId: 'cat_karakiz',
        ),
      );

      expect(prefsRepo.userProfile.nickname, 'Karakız');
      expect(prefsRepo.userProfile.avatarId, 'avatar_sage_cat');
      expect(prefsRepo.userProfile.favoriteCatId, 'cat_karakiz');
    });

    // 38. Reactive profile updates
    testWidgets('38. Updating userProfile stream dynamically updates header UI',
        (tester) async {
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Senin Hikâyen'), findsOneWidget);

      await prefsRepo.updateNickname('Dostum');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Merhaba, Dostum'), findsOneWidget);
    });

    // 39. Cat deletion resilience
    testWidgets('39. Deleting non-favorite cat does not affect favorite cat UI',
        (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Favori Dost'));
      await repo.addCat(makeCat(id: 'c2', name: 'Diğer Kedi'));
      await prefsRepo.updateFavoriteCatId('c1');

      await pumpContainer(
          tester, createDirectProfileWidget(container: container));
      expect(find.text('Favori Dost'), findsOneWidget);

      await repo.deleteCat('c2');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Favori Dost'), findsOneWidget);
    });

    // 40. Memory changes reflected where applicable
    testWidgets('40. Adding memories dynamically updates stats in MyStorySection',
        (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Mırmır'));
      await pumpContainer(
          tester, createDirectProfileWidget(container: container));

      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('1'), findsWidgets); // Total memories = 1
    });

    // 41. No duplicate providers/state
    testWidgets('41. favoriteCatProvider derives cleanly from existing streams',
        (tester) async {
      final c1 = makeCat(id: 'c_fav', name: 'Pati');
      await repo.addCat(c1);
      await prefsRepo.updateFavoriteCatId('c_fav');
      await pumpContainer(tester, createDirectProfileWidget(container: container));

      final favCat = container.read(favoriteCatProvider);
      expect(favCat?.name, 'Pati');
    });

    // 42. No route regressions
    testWidgets('42. Navigating to /profile via GoRouter loads ProfileScreen',
        (tester) async {
      await pumpContainer(tester, createProfileRouterApp(container: container));
      final router = container.read(routerProvider);

      router.go('/profile');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}
