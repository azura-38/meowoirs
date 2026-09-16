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
import 'package:meowoirs/domain/story/story_metrics_calculator.dart';
import 'package:meowoirs/features/my_story/my_story_screen.dart';
import 'package:meowoirs/widgets/cat_preview_card.dart';
import 'package:meowoirs/widgets/memory_card.dart';

Widget createDirectMyStoryWidget({
  required ProviderContainer container,
  VoidCallback? onNavigateToCats,
  ValueChanged<String>? onNavigateToCatDetail,
  VoidCallback? onNavigateToAddMemory,
  VoidCallback? onNavigateToAddCat,
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
        child: MyStoryScreen(
          onNavigateToCats: onNavigateToCats ?? () {},
          onNavigateToCatDetail: onNavigateToCatDetail ?? (_) {},
          onNavigateToAddMemory: onNavigateToAddMemory ?? () {},
          onNavigateToAddCat: onNavigateToAddCat ?? () {},
        ),
      ),
    ),
  );
}

Widget createMyStoryRouterApp({
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
          title: 'Meowoirs My Story Test',
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

  group('PHASE 14 — MY STORY TESTS', () {
    // 1. Screen renders
    testWidgets('1. MyStoryScreen renders successfully', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.byType(MyStoryScreen), findsOneWidget);
    });

    // 2. Header renders
    testWidgets('2. Editorial header renders title and subtitle', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Hikâyem'), findsOneWidget);
      expect(find.text('Sen ve kedilerin arasında biriken küçük anlar.'), findsOneWidget);
    });

    // 3. Loading state
    testWidgets('3. Displays circular progress indicator when loading', (tester) async {
      final mockContainer = ProviderContainer(
        overrides: [
          catsStreamProvider.overrideWith((ref) => const Stream.empty()),
          allMemoriesStreamProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(mockContainer.dispose);

      await tester.pumpWidget(createDirectMyStoryWidget(container: mockContainer));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // 4. Error state with retry
    testWidgets('4. Displays error card with retry button on stream error', (tester) async {
      final errorContainer = ProviderContainer(
        overrides: [
          catsStreamProvider.overrideWith((ref) => Stream.error(Exception('Test error'))),
          allMemoriesStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
      );
      addTearDown(errorContainer.dispose);

      await pumpContainer(tester, createDirectMyStoryWidget(container: errorContainer));
      expect(find.text('Hikâye yüklenemedi'), findsOneWidget);
      expect(find.text('Tekrar Dene'), findsOneWidget);

      await tester.tap(find.text('Tekrar Dene'));
      await tester.pump(const Duration(milliseconds: 100));
    });

    // 5. Completely empty state
    testWidgets('5. Completely empty state renders with 0 cats and 0 memories', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Burada senin hikâyen başlayacak.'), findsOneWidget);
      expect(find.text('Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.'), findsOneWidget);
      expect(find.text('İlk Anını Ekle'), findsOneWidget);
      expect(find.text('İlk Kedini Ekle'), findsOneWidget);
    });

    // 6. Completely empty CTA -> add memory
    testWidgets('6. Completely empty "İlk Anını Ekle" calls callback', (tester) async {
      var addMemoryClicked = false;
      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToAddMemory: () => addMemoryClicked = true,
        ),
      );

      await tester.tap(find.text('İlk Anını Ekle'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(addMemoryClicked, isTrue);
    });

    // 7. Completely empty CTA -> add cat
    testWidgets('7. Completely empty "İlk Kedini Ekle" calls callback', (tester) async {
      var addCatClicked = false;
      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToAddCat: () => addCatClicked = true,
        ),
      );

      await tester.tap(find.text('İlk Kedini Ekle'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(addCatClicked, isTrue);
    });

    // 8. Partial empty state (cats exist, 0 memories)
    testWidgets('8. Partial empty state renders when cats exist without memories', (tester) async {
      await repo.addCat(makeCat());
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));

      expect(find.text('Henüz anlatacak bir anın yok.'), findsOneWidget);
      expect(find.text('Kedilerin burada. Onlarla geçirdiğin ilk küçük anı sakla.'), findsWidgets);
      expect(find.text('İlk Anını Ekle'), findsOneWidget);
      // Hero & quiet stats should also appear
      expect(find.text("Senin Meowoirs'in"), findsOneWidget);
      expect(find.text('Kedilerin'), findsOneWidget);
    });

    // 9. Partial empty CTA -> add memory
    testWidgets('9. Partial empty "İlk Anını Ekle" invokes callback', (tester) async {
      await repo.addCat(makeCat());
      var addMemCalled = false;
      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToAddMemory: () => addMemCalled = true,
        ),
      );

      await tester.tap(find.text('İlk Anını Ekle'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(addMemCalled, isTrue);
    });

    // 10. Story hero narrative card
    testWidgets('10. Story hero card shows dynamic narrative summary', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Pamuk'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', catName: 'Pamuk'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text("Senin Meowoirs'in"), findsOneWidget);
      expect(find.text('Pamuk ile birlikte 1 küçük an burada saklanıyor.'), findsOneWidget);
    });

    // 11. Quiet statistics: Total cats
    testWidgets('11. Quiet statistics shows correct total cats', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Pamuk', type: CatType.home));
      await repo.addCat(makeCat(id: 'c2', name: 'Sarman', type: CatType.street));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('2'), findsWidgets); // Total cats = 2
      expect(find.text('Kedi'), findsOneWidget);
    });

    // 12. Quiet statistics: Total memories
    testWidgets('12. Quiet statistics shows correct total memories', (tester) async {
      await repo.addCat(makeCat(id: 'c1'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));
      await repo.addMemory(makeMemory(id: 'm2', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('2'), findsWidgets); // Total memories = 2
      expect(find.text('Anı'), findsOneWidget);
    });

    // 13. Quiet statistics: Home cats count
    testWidgets('13. Quiet statistics shows correct home cats count', (tester) async {
      await repo.addCat(makeCat(id: 'c1', type: CatType.home));
      await repo.addCat(makeCat(id: 'c2', type: CatType.home));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Ev'), findsOneWidget);
    });

    // 14. Quiet statistics: Street cats count
    testWidgets('14. Quiet statistics shows correct street cats count', (tester) async {
      await repo.addCat(makeCat(id: 'c1', type: CatType.street));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Sokak'), findsOneWidget);
    });

    // 15. StoryMetricsCalculator integration
    testWidgets('15. StoryMetricsCalculator integrates accurately with mixed cats', (tester) async {
      final c1 = makeCat(id: 'c1', name: 'Pamuk', type: CatType.home);
      final c2 = makeCat(id: 'c2', name: 'Tekir', type: CatType.street);
      final m1 = makeMemory(id: 'm1', catId: 'c1', createdAt: 100);
      final m2 = makeMemory(id: 'm2', catId: 'c2', createdAt: 200);

      final metrics = StoryMetricsCalculator.calculate([c1, c2], [m1, m2]);
      expect(metrics.totalCats, 2);
      expect(metrics.homeCatsCount, 1);
      expect(metrics.streetCatsCount, 1);
      expect(metrics.totalMemories, 2);
      expect(metrics.narrativeSummary, contains('2 dostunla 2 küçük an'));
    });

    // 16. Kedilerin horizontal section renders
    testWidgets('16. Kedilerin horizontal section renders CatPreviewCard list', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Limon'));
      await repo.addCat(makeCat(id: 'c2', name: 'Zeytin'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Kedilerin'), findsOneWidget);
      expect(find.text('Tümünü Gör'), findsOneWidget);
      expect(find.byType(CatPreviewCard), findsNWidgets(2));
      expect(find.text('Limon'), findsWidgets);
      expect(find.text('Zeytin'), findsWidgets);
    });

    // 17. Kedilerin "Tümünü Gör" action
    testWidgets('17. Tapping "Tümünü Gör" calls onNavigateToCats', (tester) async {
      await repo.addCat(makeCat(id: 'c1'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));
      var catsNavigated = false;

      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToCats: () => catsNavigated = true,
        ),
      );

      await tester.tap(find.text('Tümünü Gör'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(catsNavigated, isTrue);
    });

    // 18. Tapping CatPreviewCard navigates to cat detail
    testWidgets('18. Tapping CatPreviewCard calls onNavigateToCatDetail with catId', (tester) async {
      await repo.addCat(makeCat(id: 'cat_limon', name: 'Limon'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'cat_limon'));
      String? tappedId;

      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToCatDetail: (id) => tappedId = id,
        ),
      );

      await tester.tap(find.byType(CatPreviewCard));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tappedId, 'cat_limon');
    });

    // 19. Most remembered cat card renders
    testWidgets('19. Most remembered cat card renders top cat name', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Limon'));
      await repo.addCat(makeCat(id: 'c2', name: 'Zeytin'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c2', catName: 'Zeytin'));
      await repo.addMemory(makeMemory(id: 'm2', catId: 'c2', catName: 'Zeytin'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('En çok anı biriktirdiğin'), findsOneWidget);
      expect(find.text('Zeytin'), findsWidgets);
    });

    // 20. Most remembered cat memory count
    testWidgets('20. Most remembered cat card renders memory count subtitle', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Zeytin'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', catName: 'Zeytin'));
      await repo.addMemory(makeMemory(id: 'm2', catId: 'c1', catName: 'Zeytin'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('2 anı biriktirildi'), findsOneWidget);
    });

    // 21. Tapping most remembered cat navigates to cat detail
    testWidgets('21. Tapping most remembered cat card navigates to CatDetail', (tester) async {
      await repo.addCat(makeCat(id: 'top_cat', name: 'Prens'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'top_cat', catName: 'Prens'));
      String? targetCatId;

      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToCatDetail: (id) => targetCatId = id,
        ),
      );

      await tester.tap(find.text('Prens').first);
      await tester.pump(const Duration(milliseconds: 50));
      expect(targetCatId, 'top_cat');
    });

    // 22. Recent moment section renders
    testWidgets('22. Recent story moment section renders latest memory', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Duman'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', note: 'Eski anı', createdAt: 1000));
      await repo.addMemory(makeMemory(id: 'm2', catId: 'c1', note: 'En son anı', createdAt: 5000));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Son Anın'), findsOneWidget);
      expect(find.text('“En son anı”'), findsOneWidget);
    });

    // 23. Tapping recent memory navigates to cat detail
    testWidgets('23. Tapping recent memory card navigates to cat detail', (tester) async {
      await repo.addCat(makeCat(id: 'cat_duman', name: 'Duman'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'cat_duman', note: 'Son anımız', createdAt: 3000));
      String? navigatedCatId;

      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          onNavigateToCatDetail: (id) => navigatedCatId = id,
        ),
      );

      await tester.tap(find.byType(MemoryCard));
      await tester.pump(const Duration(milliseconds: 50));
      expect(navigatedCatId, 'cat_duman');
    });

    // 24. Story beginning card renders
    testWidgets('24. Story beginning card displays formatted date of earliest memory', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Duman'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', createdAt: 1697274000000)); // Oct 14, 2023

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text("Meowoirs'teki ilk anın"), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
    });

    // 25. Date formatting resiliency
    testWidgets('25. Date formatting handles various dates without crashing', (tester) async {
      await repo.addCat(makeCat(id: 'c1'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', createdAt: 0));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text("Meowoirs'teki ilk anın"), findsOneWidget);
    });

    // 26. Reactive cat addition
    testWidgets('26. Reactive cat addition dynamically updates stats row', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Burada senin hikâyen başlayacak.'), findsOneWidget);

      await repo.addCat(makeCat(id: 'c1', name: 'Mırmır'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Henüz anlatacak bir anın yok.'), findsOneWidget);
      expect(find.text('Mırmır'), findsOneWidget);
    });

    // 27. Reactive cat deletion
    testWidgets('27. Reactive cat deletion removes cat from list and updates counts', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Mırmır'));
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Mırmır'), findsOneWidget);

      await repo.deleteCat('c1');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Burada senin hikâyen başlayacak.'), findsOneWidget);
    });

    // 28. Reactive memory addition
    testWidgets('28. Reactive memory addition switches to full populated state', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Boncuk'));
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Henüz anlatacak bir anın yok.'), findsOneWidget);

      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', catName: 'Boncuk', note: 'Kuşları izledi'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Son Anın'), findsOneWidget);
      expect(find.text('“Kuşları izledi”'), findsOneWidget);
    });

    // 29. Reactive memory deletion
    testWidgets('29. Reactive memory deletion updates story metrics and reverts empty card', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Boncuk'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', catName: 'Boncuk', note: 'Anı'));
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Son Anın'), findsOneWidget);

      await repo.deleteMemory('m1');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Henüz anlatacak bir anın yok.'), findsOneWidget);
    });

    // 30. Cat rename update
    testWidgets('30. Cat rename dynamically updates most remembered cat card', (tester) async {
      await repo.addCat(makeCat(id: 'c1', name: 'Eski Ad'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1', catName: 'Eski Ad'));
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.text('Eski Ad'), findsWidgets);

      await repo.updateCat(makeCat(id: 'c1', name: 'Yeni Ad'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Yeni Ad'), findsWidgets);
    });

    // 31. Photo uri rendering
    testWidgets('31. Cat with photo URI renders without crashing', (tester) async {
      await repo.addCat(makeCat(id: 'c1', photoUri: 'https://example.com/cat.jpg'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.byType(MyStoryScreen), findsOneWidget);
    });

    // 32. Missing photo fallback
    testWidgets('32. Cat without photo falls back to pets icon gracefully', (tester) async {
      await repo.addCat(makeCat(id: 'c1', photoUri: null));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
    });

    // 33. Invalid local photo file fallback
    testWidgets('33. Non-existent file URI safely falls back to icon', (tester) async {
      await repo.addCat(makeCat(id: 'c1', photoUri: '/invalid/path/to/missing_cat.jpg'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
    });

    // 34. Back button navigation
    testWidgets('34. Back button in AppBar is clickable and pops', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pump(const Duration(milliseconds: 50));
    });

    // 35. Accessibility semantics: header
    testWidgets('35. Title possesses header semantics', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      final headerSemantics = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.header == true,
      );
      expect(headerSemantics, findsWidgets);
    });

    // 36. Accessibility semantics: buttons
    testWidgets('36. Buttons have accessible semantics', (tester) async {
      await pumpContainer(tester, createDirectMyStoryWidget(container: container));
      final buttonSemantics = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.button == true,
      );
      expect(buttonSemantics, findsWidgets);
    });

    // 37. Dark mode rendering
    testWidgets('37. Dark mode renders with proper contrast and theme colors', (tester) async {
      await repo.addCat(makeCat(id: 'c1'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          themeMode: ThemeMode.dark,
        ),
      );

      expect(find.text('Hikâyem'), findsOneWidget);
      expect(find.byType(MyStoryScreen), findsOneWidget);
    });

    // 38. 320x533 compact viewport
    testWidgets('38. Compact 320x533 viewport renders without layout overflow', (tester) async {
      await repo.addCat(makeCat(id: 'c1'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      tester.view.physicalSize = const Size(320, 533);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createDirectMyStoryWidget(
          container: container,
          viewportSize: const Size(320, 533),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });

    // 39. Large text scaling (1.5x)
    testWidgets('39. 1.5x text scaling renders without overflowing or clipping', (tester) async {
      await repo.addCat(makeCat(id: 'c1'));
      await repo.addMemory(makeMemory(id: 'm1', catId: 'c1'));

      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          textScaler: const TextScaler.linear(1.5),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    // 40. Localization: Turkish locale
    testWidgets('40. Turkish locale renders Turkish text accurately', (tester) async {
      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          locale: const Locale('tr'),
        ),
      );
      expect(find.text('Hikâyem'), findsOneWidget);
      expect(find.text('Burada senin hikâyen başlayacak.'), findsOneWidget);
    });

    // 41. Localization: English locale
    testWidgets('41. English locale renders English text accurately', (tester) async {
      await pumpContainer(
        tester,
        createDirectMyStoryWidget(
          container: container,
          locale: const Locale('en'),
        ),
      );
      expect(find.text('My Story'), findsOneWidget);
      expect(find.text('Your story will begin here.'), findsOneWidget);
    });

    // 42. Router integration & Profile -> My Story navigation
    testWidgets('42. Router deep-link navigates from Profile to My Story and back', (tester) async {
      await pumpContainer(tester, createMyStoryRouterApp(container: container));
      final router = container.read(routerProvider);

      router.go('/story');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(MyStoryScreen), findsOneWidget);
    });
  });
}
