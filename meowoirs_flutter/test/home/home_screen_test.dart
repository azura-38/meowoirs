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
import 'package:meowoirs/features/home/home_screen.dart';
import 'package:meowoirs/features/memories/add_memory_screen.dart';
import 'package:meowoirs/features/memories/memory_detail_screen.dart';
import 'package:meowoirs/widgets/cat_preview_card.dart';
import 'package:meowoirs/widgets/memory_card.dart';
import 'package:meowoirs/widgets/meowoirs_bottom_navigation.dart';
import 'package:meowoirs/widgets/meowoirs_fab.dart';

Widget createHomeTestApp({
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
          title: 'Meowoirs Home Test',
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

  group('Phase 7 — Home Screen Comprehensive Suite', () {
    // 1. Home route loads
    testWidgets('1. Home route loads cleanly at /', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Meowoirs'), findsWidgets);
      expect(find.text('Her kedinin bir hikâyesi var.'), findsOneWidget);
    });

    // 2. Home is first navigation destination
    testWidgets('2. Home is first navigation destination in bottom navigation', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final nav = find.byType(MeowoirsBottomNavigation);
      expect(nav, findsOneWidget);

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(0));
    });

    // 3. Bottom navigation labels
    testWidgets('3. Bottom navigation displays exact 4 destinations with Turkish labels', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('ANA SAYFA'), findsWidgets);
      expect(find.text('KEDİLER'), findsWidgets);
      expect(find.text('ANILAR'), findsWidgets);
      expect(find.text('PROFİL'), findsWidgets);
    });

    // 4. Home active state
    testWidgets('4. Home tab displays active state indicator', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(0));
    });

    // 5. Cat loading state
    testWidgets('5. Loading state displays CircularProgressIndicator', (tester) async {
      final loadingContainer = ProviderContainer(
        overrides: [
          catsStreamProvider.overrideWith((ref) => const Stream.empty()),
          recentMemoriesStreamProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(loadingContainer.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: loadingContainer,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: HomeScreen()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // 6. Cat empty state (State A: completely empty)
    testWidgets('6. Empty state A renders when zero cats and zero memories', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyHomeStateCard), findsOneWidget);
      expect(find.text('Henüz bir anın yok...'), findsOneWidget);
      expect(find.text('Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.'), findsOneWidget);
      expect(find.text('İlk Anını Ekle'), findsOneWidget);
      expect(find.text('İlk Kedini Ekle'), findsOneWidget);
    });

    // 7. Cat data rendering
    testWidgets('7. Cat data renders in horizontal strip when cats exist', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-1',
        name: 'Duman',
        type: CatType.home,
        photoUri: null,
        note: 'Sessiz dost',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Kedilerin'), findsOneWidget);
      expect(find.text('1 kedi hikâyesi'), findsOneWidget);
      expect(find.byType(CatPreviewCard), findsOneWidget);
      expect(find.text('Duman'), findsOneWidget);
      expect(find.text('Ev Kedisi'), findsOneWidget);
    });

    // 8. Cat photo rendering
    testWidgets('8. Cat photo rendering uses photoUri when provided', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-photo',
        name: 'Boncuk',
        type: CatType.street,
        photoUri: 'https://example.com/boncuk.jpg',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Boncuk'), findsOneWidget);
      expect(find.byType(CatPreviewCard), findsOneWidget);
    });

    // 9. Cat fallback
    testWidgets('9. Cat photo falls back to pets icon when photoUri is null or empty', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-no-photo',
        name: 'Tarçın',
        type: CatType.home,
        photoUri: null,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(CatPreviewCard),
          matching: find.byIcon(Icons.pets_outlined),
        ),
        findsOneWidget,
      );
      expect(find.text('Tarçın'), findsOneWidget);
    });

    // 10. Add Cat navigation
    testWidgets('10. Add Cat text in Empty State A navigates to /add_cat', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final addCatButton = find.text('İlk Kedini Ekle');
      expect(addCatButton, findsOneWidget);
      await tester.tap(addCatButton);
      await tester.pumpAndSettle();

      expect(find.byType(AddCatScreen), findsOneWidget);
    });

    // 11. Memory loading state
    testWidgets('11. Memory loading handles asynchronously without crash', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    // 12. Memory empty state (State B: cats exist, no memories)
    testWidgets('12. State B renders when cats exist without memories', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(
        id: 'cat-b',
        name: 'Mırmır',
        type: CatType.home,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(CatsExistNoMemoriesCard), findsOneWidget);
      expect(find.text('Kedilerin burada.'), findsOneWidget);
      expect(find.text('Onlarla geçirdiğin ilk anıyı sakla.'), findsOneWidget);
      expect(find.text('İlk Anını Ekle'), findsOneWidget);
    });

    // 13. Memory data rendering
    testWidgets('13. Memory data renders in vertical list when memories exist', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Tekir', type: CatType.street, createdAt: 1000));
      await repo.addMemory(Memory(
        id: 'mem-1',
        catId: 'cat-1',
        catName: 'Tekir',
        note: 'Balkonda uyudu',
        photoUri: null,
        catMood: 'Uykulu',
        userMood: 'Huzurlu',
        createdAt: 1700000000000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Son Anılar'), findsOneWidget);
      expect(find.text('Tümünü Gör'), findsOneWidget);
      expect(find.byType(MemoryCard), findsOneWidget);
      expect(find.text('“Balkonda uyudu”'), findsOneWidget);
      expect(find.text('Uykulu'), findsOneWidget);
      expect(find.text('♡ Huzurlu'), findsOneWidget);
    });

    // 14. Memory photo rendering
    testWidgets('14. Memory photo rendering handles photoUri', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Zeytin', type: CatType.home, createdAt: 1000));
      await repo.addMemory(Memory(
        id: 'mem-photo',
        catId: 'cat-1',
        catName: 'Zeytin',
        note: 'Ağaca tırmandı',
        photoUri: 'https://example.com/zeytin.jpg',
        createdAt: 1700000000000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(MemoryCard), findsOneWidget);
    });

    // 15. Memory fallback
    testWidgets('15. Memory fallback renders camera icon and cat name when photo is absent', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Lokum', type: CatType.home, createdAt: 1000));
      await repo.addMemory(Memory(
        id: 'mem-no-photo',
        catId: 'cat-1',
        catName: 'Lokum',
        note: 'Kutunun içine girdi',
        photoUri: null,
        createdAt: 1700000000000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    // 16. Memory detail navigation
    testWidgets('16. Tapping memory card navigates to /memory_detail/{id}', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Pati', type: CatType.home, createdAt: 1000));
      await repo.addMemory(Memory(
        id: 'mem-detail',
        catId: 'cat-1',
        catName: 'Pati',
        note: 'Sabah kahvaltısı',
        createdAt: 1700000000000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final memoryCard = find.byType(MemoryCard);
      expect(memoryCard, findsOneWidget);
      await tester.tap(memoryCard);
      await tester.pumpAndSettle();

      expect(find.byType(MemoryDetailScreen), findsOneWidget);
    });

    // 17. View-all memories navigation
    testWidgets('17. Tapping Tümünü Gör navigates to /memories tab', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Minnoş', type: CatType.home, createdAt: 1000));
      await repo.addMemory(Memory(
        id: 'mem-all',
        catId: 'cat-1',
        catName: 'Minnoş',
        note: 'İplik yumağıyla oynadı',
        createdAt: 1700000000000,
      ));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final viewAll = find.text('Tümünü Gör');
      expect(viewAll, findsOneWidget);
      await tester.tap(viewAll);
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(2)); // Memories tab
    });

    // 18. Add Memory navigation
    testWidgets('18. Tapping İlk Anını Ekle navigates to /add_memory', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final addMemoryButton = find.widgetWithText(ElevatedButton, 'İlk Anını Ekle');
      expect(addMemoryButton, findsOneWidget);
      await tester.tap(addMemoryButton);
      await tester.pumpAndSettle();

      expect(find.byType(AddMemoryScreen), findsOneWidget);
    });

    // 19. Reactive cat update
    testWidgets('19. Adding a cat reactively updates Home screen without full reload', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyHomeStateCard), findsOneWidget);

      await repo.addCat(Cat(
        id: 'cat-reactive',
        name: 'Gölge',
        type: CatType.home,
        createdAt: 1000,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyHomeStateCard), findsNothing);
      expect(find.byType(CatsExistNoMemoriesCard), findsOneWidget);
      expect(find.text('Gölge'), findsOneWidget);
    });

    // 20. Reactive memory update
    testWidgets('20. Adding a memory reactively transitions Home from State B to Recent Memories', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-1', name: 'Şeker', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(CatsExistNoMemoriesCard), findsOneWidget);

      await repo.addMemory(Memory(
        id: 'mem-reactive',
        catId: 'cat-1',
        catName: 'Şeker',
        note: 'Kucağımda mırıldadı',
        createdAt: 1700000000000,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CatsExistNoMemoriesCard), findsNothing);
      expect(find.text('Son Anılar'), findsOneWidget);
      expect(find.text('“Kucağımda mırıldadı”'), findsOneWidget);
    });

    // 21. Cat Detail navigation from preview card
    testWidgets('21. Tapping CatPreviewCard navigates to /cat_detail/{id}', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-detail-test', name: 'Köpük', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      final catCard = find.byType(CatPreviewCard);
      expect(catCard, findsOneWidget);
      await tester.tap(catCard);
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsOneWidget);
    });

    // 22. English localization test
    testWidgets('22. Home screen displays English copy when locale is English', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(
        container: container,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Meowoirs'), findsWidgets);
      expect(find.text('Every cat has a story.'), findsOneWidget);
      expect(find.text('You don\'t have any memories yet...'), findsOneWidget);
      expect(find.text('Add Your First Memory'), findsOneWidget);
      expect(find.text('Add Your First Cat'), findsOneWidget);
    });

    // 23. Dark theme test
    testWidgets('23. Home screen renders cleanly under dark theme', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createHomeTestApp(
        container: container,
        themeMode: ThemeMode.dark,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Meowoirs'), findsWidgets);
    });

    // 24. Responsive constraints and FAB coexistence
    testWidgets('24. Home screen maintains tablet constraints and FAB without clipping', (tester) async {
      tester.view.physicalSize = const Size(1600, 2400); // Tablet size
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(Cat(id: 'cat-tab', name: 'Atlas', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createHomeTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(MeowoirsFab), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
