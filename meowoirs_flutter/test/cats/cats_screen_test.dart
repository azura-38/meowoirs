import 'dart:async';
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
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/cats/add_cat_screen.dart';
import 'package:meowoirs/features/cats/cat_detail_screen.dart';
import 'package:meowoirs/features/cats/cats_screen.dart';
import 'package:meowoirs/widgets/cat_card.dart';
import 'package:meowoirs/widgets/meowoirs_fab.dart';

Widget createCatsTestApp({
  required ProviderContainer container,
  Locale locale = const Locale('tr'),
  ThemeMode themeMode = ThemeMode.light,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);

        return MaterialApp.router(
          title: 'Meowoirs Cats Test',
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

  group('Phase 8 — Cats Screen Comprehensive Suite', () {
    // 1. Cats route loads
    testWidgets('1. /cats route loads cleanly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.byType(CatsScreen), findsOneWidget);
    });

    // 2. Cats tab is second destination
    testWidgets('2. Cats tab is second bottom navigation destination (index 1)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations.length, equals(4));

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      final updatedNavBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(updatedNavBar.selectedIndex, equals(1));
    });

    // 3. Cats tab active state
    testWidgets('3. Cats tab displays visually active state when on /cats', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(1));
    });

    // 4. Bottom navigation labels localized
    testWidgets('4. Bottom navigation displays exact 4 destinations with Turkish labels', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('ANA SAYFA'), findsWidgets);
      expect(find.text('KEDİLER'), findsWidgets);
      expect(find.text('ANILAR'), findsWidgets);
      expect(find.text('PROFİL'), findsWidgets);
    });

    // 5. Loading state
    testWidgets('5. Loading state displays CircularProgressIndicator in orange', (tester) async {
      final loadingContainer = ProviderContainer(
        overrides: [
          catsStreamProvider.overrideWith((ref) => const Stream.empty()),
          allMemoriesStreamProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(loadingContainer.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: loadingContainer,
          child: MaterialApp(
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: CatsScreen(
              onNavigateToAddCat: () {},
              onNavigateToCatDetail: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final indicator = tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator));
      expect(indicator.color, equals(MeowoirsColors.light.orange));
    });

    // 6. Empty state when zero cats
    testWidgets('6. Empty state displays when zero cats exist in archive', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Henüz bir kedin yok.'), findsOneWidget);
      expect(find.text('Hayatındaki bir kediyi ekleyerek hikâyene başla.'), findsOneWidget);
      expect(find.text('İlk Kedini Ekle'), findsOneWidget);
    });

    // 7. Empty state Add Cat CTA
    testWidgets('7. Empty state contains primary CTA İlk Kedini Ekle', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      final ctaFinder = find.widgetWithText(ElevatedButton, 'İlk Kedini Ekle');
      expect(ctaFinder, findsOneWidget);
    });

    // 8. Add Cat CTA navigates to /add_cat
    testWidgets('8. Add Cat CTA in empty state navigates to /add_cat', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'İlk Kedini Ekle'));
      await tester.pumpAndSettle();

      expect(find.byType(AddCatScreen), findsOneWidget);
    });

    // 9. Cat data renders
    testWidgets('9. Cat data renders in 2-column grid when cats exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-1',
        name: 'Minnoş',
        type: CatType.home,
        note: 'Warm friend',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.byType(CatCard), findsOneWidget);
      expect(find.text('Minnoş'), findsOneWidget);
      expect(find.text('Ev Kedisi'), findsOneWidget);
    });

    // 10. Cat name renders
    testWidgets('10. Cat name renders clearly in CatCard', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-duman', name: 'Duman', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Duman'), findsOneWidget);
    });

    // 11. Home Cat type renders
    testWidgets('11. Home Cat type renders with Ev Kedisi label', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-pamuk', name: 'Pamuk', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Ev Kedisi'), findsOneWidget);
    });

    // 12. Street Cat type renders
    testWidgets('12. Street Cat type renders with Sokak Kedisi label', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-golge', name: 'Gölge', type: CatType.street, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Sokak Kedisi'), findsOneWidget);
    });

    // 13. Cat photo renders
    testWidgets('13. Cat photo renders when valid photo URI provided', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-photo',
        name: 'Foto Kedi',
        type: CatType.home,
        photoUri: 'https://example.com/cat.jpg',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.byType(CatCard), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    // 14. Missing photo fallback
    testWidgets('14. Missing photo fallback displays 56dp circle icon container', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-no-photo',
        name: 'Photosuz',
        type: CatType.home,
        photoUri: null,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.byType(CatCard), findsOneWidget);
      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
    });

    // 15. Invalid photo fallback
    testWidgets('15. Invalid photo URI gracefully falls back to placeholder without crash', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-invalid',
        name: 'BozukFoto',
        type: CatType.street,
        photoUri: '/invalid/path/does_not_exist_987654.jpg',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.byType(CatCard), findsOneWidget);
      expect(find.text('BozukFoto'), findsOneWidget);
    });

    // 16. Cat card navigation to /cat_detail/{catId}
    testWidgets('16. Tapping CatCard navigates to /cat_detail/{catId}', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-tekir', name: 'Tekir', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CatCard));
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsOneWidget);
      expect(find.text('Tekir'), findsWidgets);
    });

    // 17. Multiple cats render
    testWidgets('17. Multiple cats render in grid', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Cat 1', type: CatType.home, createdAt: 1000));
      await repo.addCat(Cat(id: 'cat-2', name: 'Cat 2', type: CatType.street, createdAt: 2000));
      await repo.addCat(Cat(id: 'cat-3', name: 'Cat 3', type: CatType.home, createdAt: 3000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.byType(CatCard), findsNWidgets(3));
      expect(find.text('Cat 1'), findsOneWidget);
      expect(find.text('Cat 2'), findsOneWidget);
      expect(find.text('Cat 3'), findsOneWidget);
    });

    // 18. Header "Yeni Kedi" button navigates to /add_cat
    testWidgets('18. Header Yeni Kedi button navigates to /add_cat', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Cat 1', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yeni Kedi'));
      await tester.pumpAndSettle();

      expect(find.byType(AddCatScreen), findsOneWidget);
    });

    // 19. Header summary text displays correctly
    testWidgets('19. Header summary displays home and street count', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Cat 1', type: CatType.home, createdAt: 1000));
      await repo.addCat(Cat(id: 'cat-2', name: 'Cat 2', type: CatType.street, createdAt: 2000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Hayatına dokunan 1 ev · 1 sokak'), findsOneWidget);
    });

    // 20. Memory count badge on CatCard
    testWidgets('20. Memory count badge renders on CatCard when cat has memories', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-anili', name: 'Anılı Kedi', type: CatType.home, createdAt: 1000));
      await repo.addMemory(Memory(
        id: 'mem-1',
        catId: 'cat-anili',
        catName: 'Anılı Kedi',
        note: 'Güzel bir gün',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('1 anı'), findsOneWidget);
    });

    // 21. Filter chip selection filters cats
    testWidgets('21. Filter chips filter cats reactively', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-ev', name: 'Ev Kedisi 1', type: CatType.home, createdAt: 1000));
      await repo.addCat(Cat(id: 'cat-sokak', name: 'Sokak Kedisi 1', type: CatType.street, createdAt: 2000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      // All shows both
      expect(find.byType(CatCard), findsNWidgets(2));

      // Tap "Ev"
      await tester.tap(find.text('Ev'));
      await tester.pumpAndSettle();

      expect(find.text('Ev Kedisi 1'), findsOneWidget);
      expect(find.text('Sokak Kedisi 1'), findsNothing);

      // Tap "Sokak"
      await tester.tap(find.text('Sokak'));
      await tester.pumpAndSettle();

      expect(find.text('Ev Kedisi 1'), findsNothing);
      expect(find.text('Sokak Kedisi 1'), findsOneWidget);

      // Tap "Tümü"
      await tester.tap(find.text('Tümü'));
      await tester.pumpAndSettle();

      expect(find.byType(CatCard), findsNWidgets(2));
    });

    // 22. Filter empty state
    testWidgets('22. Filter empty state displays specific message and CTA', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-ev-only', name: 'Sadece Ev', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      // Tap "Sokak"
      await tester.tap(find.text('Sokak'));
      await tester.pumpAndSettle();

      expect(find.text('Henüz bir sokak kedisi eklemedin.'), findsOneWidget);
      expect(find.text('Sokak Kedisi Ekle'), findsOneWidget);
    });

    // 23. Reactive add behavior
    testWidgets('23. Adding a cat via repository reactively updates Cats screen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Henüz bir kedin yok.'), findsOneWidget);

      // Add a cat to the repo reactively
      await repo.addCat(Cat(id: 'cat-reaktif', name: 'Reaktif Kedi', type: CatType.home, createdAt: 1000));
      await tester.pumpAndSettle();

      expect(find.text('Henüz bir kedin yok.'), findsNothing);
      expect(find.text('Reaktif Kedi'), findsOneWidget);
    });

    // 24. Dark mode compatibility
    testWidgets('24. Cats screen renders cleanly under dark theme', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-gece', name: 'Gece', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(
        container: container,
        themeMode: ThemeMode.dark,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      expect(find.text('Gece'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // 25. Error state and retry
    testWidgets('25. Error state displays retry button and handles retry', (tester) async {
      final catsController = StreamController<List<Cat>>.broadcast();
      final memoriesController = StreamController<List<Memory>>.broadcast();
      addTearDown(() {
        catsController.close();
        memoriesController.close();
      });

      final errorContainer = ProviderContainer(
        overrides: [
          catsStreamProvider.overrideWith((ref) => catsController.stream),
          allMemoriesStreamProvider.overrideWith((ref) => memoriesController.stream),
        ],
      );
      addTearDown(errorContainer.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: errorContainer,
          child: MaterialApp(
            locale: const Locale('tr'),
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: CatsScreen(
              onNavigateToAddCat: () {},
              onNavigateToCatDetail: (_) {},
            ),
          ),
        ),
      );

      // Emit error and empty memories
      catsController.addError(Exception('Database disk error'));
      memoriesController.add([]);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Tekrar Dene'), findsOneWidget);

      // Trigger recovery
      catsController.add([
        Cat(
          id: 'recovered-1',
          name: 'Kurtarılan Kedi',
          type: CatType.home,
          createdAt: 1000,
        ),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Kurtarılan Kedi'), findsOneWidget);
    });

    // 26. Global FAB is present on Cats according to RouteUiPolicy
    testWidgets('26. Global FAB Anı Ekle is present on /cats according to RouteUiPolicy', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      final fab = find.byType(MeowoirsFab);
      expect(fab, findsOneWidget);
      expect(find.text('Anı Ekle'), findsOneWidget);
    });

    // 27. Accessibility semantics present on CatCard
    testWidgets('27. CatCard provides comprehensive accessibility semantics', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-semantik', name: 'Semantik', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatsTestApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('KEDİLER'));
      await tester.pumpAndSettle();

      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.label?.contains('Semantik') ?? false),
      );
      expect(semanticsFinder, findsOneWidget);
    });
  });
}
