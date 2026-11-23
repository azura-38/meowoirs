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
import 'package:meowoirs/features/cats/cat_detail_screen.dart';
import 'package:meowoirs/features/memories/memories_provider.dart';
import 'package:meowoirs/features/memories/memories_screen.dart';
import 'package:meowoirs/features/memories/memories_state.dart';
import 'package:meowoirs/widgets/memory_card.dart';
import 'package:meowoirs/widgets/meowoirs_chip.dart';

Widget createDirectMemoriesWidget({
  required ProviderContainer container,
  ValueChanged<String>? onNavigateToCatDetail,
  ValueChanged<String>? onNavigateToMemoryDetail,
  ValueChanged<String?>? onNavigateToAddMemory,
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
        child: Scaffold(
          body: MemoriesScreen(
            onNavigateToCatDetail: onNavigateToCatDetail ?? (_) {},
            onNavigateToMemoryDetail: onNavigateToMemoryDetail ?? (_) {},
            onNavigateToAddMemory: onNavigateToAddMemory ?? (_) {},
          ),
        ),
      ),
    ),
  );
}

Widget createMemoriesRouterApp({
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
          title: 'Meowoirs Memories Test',
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
  }) {
    return Cat(
      id: id,
      name: name,
      type: type,
      photoUri: photoUri,
      note: note,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Memory makeMemory({
    String id = 'mem_1',
    String catId = 'cat_1',
    String catName = 'Mişa',
    String note = 'Bugün pencereden kuşları izledi.',
    String? photoUri,
    String? catMood = 'Meraklı',
    String? userMood = 'Huzurlu',
    int? createdAt,
  }) {
    return Memory(
      id: id,
      catId: catId,
      catName: catName,
      note: note,
      photoUri: photoUri,
      catMood: catMood,
      userMood: userMood,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  group('Memories Screen Parity & Core Rendering', () {
    testWidgets('1. Screen renders with editorial header title and subtitle',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Anılar'), findsOneWidget);
      expect(find.text('Hayatındaki küçük anların arşivi.'), findsOneWidget);
    });

    testWidgets(
        '2. Loading state renders centered CircularProgressIndicator with orange color',
        (tester) async {
      final loadingContainer = ProviderContainer(
        overrides: [
          memoriesUiStateProvider.overrideWithValue(
            const MemoriesUiState(isLoading: true),
          ),
        ],
      );
      addTearDown(loadingContainer.dispose);

      await tester.pumpWidget(
        createDirectMemoriesWidget(container: loadingContainer),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, const Color(0xFFE8753D));
    });

    testWidgets('3. Error state renders friendly error card without crash',
        (tester) async {
      final errorContainer = ProviderContainer(
        overrides: [
          memoriesUiStateProvider.overrideWithValue(
            const MemoriesUiState(
              isLoading: false,
              errorMessage: 'Database connection failed',
              allMemories: [],
            ),
          ),
        ],
      );
      addTearDown(errorContainer.dispose);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: errorContainer),
      );

      expect(find.text('Anılar yüklenemedi'), findsOneWidget);
      expect(
        find.text(
            'Anılar yüklenirken bir sorun oluştu. Lütfen tekrar deneyin.'),
        findsOneWidget,
      );
      expect(find.text('Tekrar Dene'), findsOneWidget);
    });

    testWidgets(
        '4. Global empty state renders with AutoStories icon and text when archive is empty',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
      expect(find.text('Henüz bir anın yok.'), findsOneWidget);
      expect(
        find.text('Kedilerinle geçirdiğin küçük anlar burada birikecek.'),
        findsOneWidget,
      );
      expect(find.text('İlk Anını Ekle'), findsOneWidget);
    });

    testWidgets(
        '5. Global empty state button invokes onNavigateToAddMemory with null',
        (tester) async {
      String? navigatedCatId = 'not_null';
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          onNavigateToAddMemory: (catId) => navigatedCatId = catId,
        ),
      );

      await tester.tap(find.text('İlk Anını Ekle'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(navigatedCatId, isNull);
    });

    testWidgets(
        '6. Filter empty state renders when selected cat has 0 memories',
        (tester) async {
      final cat = makeCat(id: 'c1', name: 'Pamuk');
      final otherMem = makeMemory(
        id: 'm1',
        catId: 'c2',
        catName: 'Duman',
        note: 'Duman uyuyor',
      );
      await repo.addCat(cat);
      await repo.addMemory(otherMem);

      container.read(selectedCatFilterIdProvider.notifier).state = 'c1';

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byIcon(Icons.pets_outlined), findsOneWidget);
      expect(find.text('Pamuk için henüz bir anın yok.'), findsOneWidget);
      expect(
        find.text('Onunla geçirdiğin küçük bir anı sakla.'),
        findsOneWidget,
      );
      expect(find.text('Anı Ekle'), findsOneWidget);
    });

    testWidgets(
        '7. Filter empty state button invokes onNavigateToAddMemory with selected catId',
        (tester) async {
      final cat = makeCat(id: 'c_pamuk', name: 'Pamuk');
      final otherMem = makeMemory(id: 'm_duman', catId: 'c_other', note: 'Not');
      await repo.addCat(cat);
      await repo.addMemory(otherMem);

      container.read(selectedCatFilterIdProvider.notifier).state = 'c_pamuk';

      String? navigatedCatId;
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          onNavigateToAddMemory: (catId) => navigatedCatId = catId,
        ),
      );

      await tester.tap(find.text('Anı Ekle'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(navigatedCatId, 'c_pamuk');
    });
  });

  group('Memory Cards & Archive Content', () {
    testWidgets('8. One memory renders correctly in archive', (tester) async {
      final mem = makeMemory(
        id: 'mem_single',
        catName: 'Zeytin',
        note: 'Güneşin altında uyuyakaldı.',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byType(MemoryCard), findsOneWidget);
      expect(find.text('Zeytin'), findsWidgets);
      expect(find.text('“Güneşin altında uyuyakaldı.”'), findsOneWidget);
    });

    testWidgets('9. Multiple memories render in correct newest-first order',
        (tester) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final mOld = makeMemory(
        id: 'm_old',
        note: 'Eski anı',
        createdAt: now - 100000,
      );
      final mMid = makeMemory(
        id: 'm_mid',
        note: 'Orta anı',
        createdAt: now - 50000,
      );
      final mNew = makeMemory(
        id: 'm_new',
        note: 'Yeni anı',
        createdAt: now,
      );

      await repo.addMemory(mOld);
      await repo.addMemory(mNew);
      await repo.addMemory(mMid);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      final cards = tester.widgetList<MemoryCard>(find.byType(MemoryCard)).toList();
      expect(cards.length, 3);
      expect(cards[0].memory.id, 'm_new');
      expect(cards[1].memory.id, 'm_mid');
      expect(cards[2].memory.id, 'm_old');
    });

    testWidgets('10. Memory card displays cat name', (tester) async {
      final mem = makeMemory(catName: 'Tarçın');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Tarçın'), findsWidgets);
    });

    testWidgets('11. Memory card displays personal note in quotation marks',
        (tester) async {
      final mem = makeMemory(note: 'Sarı iplik yumağıyla oynadı.');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('“Sarı iplik yumağıyla oynadı.”'), findsOneWidget);
    });

    testWidgets('12. Memory card displays cat mood chip', (tester) async {
      final mem = makeMemory(catMood: 'Oyuncu');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Oyuncu'), findsOneWidget);
    });

    testWidgets('13. Memory card displays user mood chip with heart symbol',
        (tester) async {
      final mem = makeMemory(userMood: 'Neşeli');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('♡ Neşeli'), findsOneWidget);
    });

    testWidgets('14. Memory card displays formatted date', (tester) async {
      final mem = makeMemory(
        createdAt: DateTime(2025, 4, 15).millisecondsSinceEpoch,
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.textContaining('2025'), findsOneWidget);
    });

    testWidgets('15. Memory card photo fallback renders when photoUri is null',
        (tester) async {
      final mem = makeMemory(photoUri: null);
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets('16. Memory card photo fallback renders when photoUri is empty',
        (tester) async {
      final mem = makeMemory(photoUri: '');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets(
        '17. Memory card photo fallback renders safely when photo file is missing',
        (tester) async {
      final mem = makeMemory(photoUri: '/path/does/not/exist/cat.jpg');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets(
        '18. Memory card photo fallback renders safely on invalid photo URI',
        (tester) async {
      final mem = makeMemory(photoUri: 'invalid://broken?uri');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets(
        '19. Tapping memory card invokes onNavigateToMemoryDetail with memoryId',
        (tester) async {
      final mem = makeMemory(id: 'target_mem_id', note: 'Tıklanacak anı');
      await repo.addMemory(mem);

      String? selectedId;
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          onNavigateToMemoryDetail: (id) => selectedId = id,
        ),
      );

      await tester.tap(find.byType(MemoryCard));
      await tester.pump(const Duration(milliseconds: 50));

      expect(selectedId, 'target_mem_id');
    });
  });

  group('Cat Filtering Parity', () {
    testWidgets('20. Cat filter chips are hidden when there are no cats',
        (tester) async {
      final mem = makeMemory(note: 'Kedi olmadan anı');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Tümü'), findsNothing);
    });

    testWidgets(
        '21. Cat filter chips render "Tümü" and available cats when cats exist',
        (tester) async {
      final cat1 = makeCat(id: 'c1', name: 'Limon');
      final cat2 = makeCat(id: 'c2', name: 'Duman');
      await repo.addCat(cat1);
      await repo.addCat(cat2);

      final mem = makeMemory(catId: 'c1', catName: 'Limon');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Tümü'), findsOneWidget);
      expect(find.text('Limon'), findsWidgets);
      expect(find.text('Duman'), findsOneWidget);
    });

    testWidgets('22. "Tümü" chip is selected by default', (tester) async {
      final cat = makeCat(id: 'c1', name: 'Limon');
      await repo.addCat(cat);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      final tumuChip = tester.widget<MeowoirsChip>(
        find.widgetWithText(MeowoirsChip, 'Tümü'),
      );
      expect(tumuChip.isSelected, isTrue);

      final limonChip = tester.widget<MeowoirsChip>(
        find.widgetWithText(MeowoirsChip, 'Limon'),
      );
      expect(limonChip.isSelected, isFalse);
    });

    testWidgets('23. Selecting cat chip filters memories to only that cat',
        (tester) async {
      final cat1 = makeCat(id: 'c1', name: 'Limon');
      final cat2 = makeCat(id: 'c2', name: 'Duman');
      await repo.addCat(cat1);
      await repo.addCat(cat2);

      final mem1 = makeMemory(id: 'm1', catId: 'c1', note: 'Limon anısı');
      final mem2 = makeMemory(id: 'm2', catId: 'c2', note: 'Duman anısı');
      await repo.addMemory(mem1);
      await repo.addMemory(mem2);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('“Limon anısı”'), findsOneWidget);
      expect(find.text('“Duman anısı”'), findsOneWidget);

      await tester.tap(find.widgetWithText(MeowoirsChip, 'Limon'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('“Limon anısı”'), findsOneWidget);
      expect(find.text('“Duman anısı”'), findsNothing);
    });

    testWidgets('24. Selecting "Tümü" restores all memories after filtering',
        (tester) async {
      final cat1 = makeCat(id: 'c1', name: 'Limon');
      final cat2 = makeCat(id: 'c2', name: 'Duman');
      await repo.addCat(cat1);
      await repo.addCat(cat2);

      final mem1 = makeMemory(id: 'm1', catId: 'c1', note: 'Limon anısı');
      final mem2 = makeMemory(id: 'm2', catId: 'c2', note: 'Duman anısı');
      await repo.addMemory(mem1);
      await repo.addMemory(mem2);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      // Filter to Limon
      await tester.tap(find.widgetWithText(MeowoirsChip, 'Limon'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('“Duman anısı”'), findsNothing);

      // Restore to Tümü
      await tester.tap(find.widgetWithText(MeowoirsChip, 'Tümü'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('“Limon anısı”'), findsOneWidget);
      expect(find.text('“Duman anısı”'), findsOneWidget);
    });

    testWidgets('25. Switching between different cat filter chips works cleanly',
        (tester) async {
      final cat1 = makeCat(id: 'c1', name: 'Limon');
      final cat2 = makeCat(id: 'c2', name: 'Duman');
      await repo.addCat(cat1);
      await repo.addCat(cat2);

      final mem1 = makeMemory(id: 'm1', catId: 'c1', note: 'Limon anısı');
      final mem2 = makeMemory(id: 'm2', catId: 'c2', note: 'Duman anısı');
      await repo.addMemory(mem1);
      await repo.addMemory(mem2);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      await tester.tap(find.widgetWithText(MeowoirsChip, 'Limon'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('“Limon anısı”'), findsOneWidget);
      expect(find.text('“Duman anısı”'), findsNothing);

      await tester.tap(find.widgetWithText(MeowoirsChip, 'Duman'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('“Limon anısı”'), findsNothing);
      expect(find.text('“Duman anısı”'), findsOneWidget);
    });
  });

  group('Reactive Updates & Lifecycle', () {
    testWidgets('26. Reactive create: inserted memory appears automatically',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Henüz bir anın yok.'), findsOneWidget);

      final newMem = makeMemory(id: 'm_react', note: 'Yeni anı otomatik geldi');
      await repo.addMemory(newMem);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Henüz bir anın yok.'), findsNothing);
      expect(find.text('“Yeni anı otomatik geldi”'), findsOneWidget);
    });

    testWidgets('27. Reactive edit: updated memory updates card automatically',
        (tester) async {
      final mem = makeMemory(id: 'm_edit', note: 'İlk versiyon notu');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('“İlk versiyon notu”'), findsOneWidget);

      final updated = mem.copyWith(note: 'İkinci versiyon güncellendi');
      await repo.updateMemory(updated);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('“İkinci versiyon güncellendi”'), findsOneWidget);
      expect(find.text('“İlk versiyon notu”'), findsNothing);
    });

    testWidgets('28. Reactive delete: deleted memory disappears automatically',
        (tester) async {
      final mem = makeMemory(id: 'm_del', note: 'Silinecek anı');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('“Silinecek anı”'), findsOneWidget);

      await repo.deleteMemory(mem.id);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('“Silinecek anı”'), findsNothing);
      expect(find.text('Henüz bir anın yok.'), findsOneWidget);
    });

    testWidgets('29. Cat deletion preserves orphan memories in archive',
        (tester) async {
      final cat = makeCat(id: 'cat_bye', name: 'Pamuk');
      await repo.addCat(cat);

      final mem = makeMemory(
        id: 'mem_orphan',
        catId: 'cat_bye',
        catName: 'Pamuk',
        note: 'Pamuk gitti ama anısı kaldı',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('“Pamuk gitti ama anısı kaldı”'), findsOneWidget);

      // Delete cat only
      await repo.deleteCat(cat.id);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Memory still exists with preserved catName!
      expect(find.text('“Pamuk gitti ama anısı kaldı”'), findsOneWidget);
      expect(find.text('Pamuk'), findsWidgets);
    });

    testWidgets('30. Cat renaming updates denormalized catName across memory cards',
        (tester) async {
      final cat = makeCat(id: 'c_rename', name: 'Eski İsim');
      await repo.addCat(cat);

      final mem = makeMemory(
        id: 'm_rename',
        catId: 'c_rename',
        catName: 'Eski İsim',
        note: 'Adı değişecek kedi anısı',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(find.text('Eski İsim'), findsWidgets);

      // Rename cat and sync memories
      final renamedCat = cat.copyWith(name: 'Yeni İsim');
      await repo.updateCat(renamedCat);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Yeni İsim'), findsWidgets);
    });
  });

  group('Cross-Screen Navigation & Integration', () {
    testWidgets('31. Global FAB routes to add memory', (tester) async {
      await pumpContainer(
        tester,
        createMemoriesRouterApp(container: container),
      );

      // Navigate to /memories
      container.read(routerProvider).go('/memories');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Anılar'), findsWidgets);

      // The global FAB should be visible per RouteUiPolicy
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      await tester.tap(fabFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Should have navigated to Add Memory screen
      expect(find.text('Anı Ekle'), findsWidgets);
    });

    testWidgets('32. Memory card click in Memories routes to Memory Detail',
        (tester) async {
      final mem = makeMemory(id: 'mem_nav_test', note: 'Detaya gidilecek anı');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesRouterApp(container: container),
      );

      container.read(routerProvider).go('/memories');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('“Detaya gidilecek anı”'), findsOneWidget);

      await tester.tap(find.byType(MemoryCard));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Should be on Memory Detail Screen
      expect(find.text('Anı Detayı'), findsOneWidget);
    });

    testWidgets('33. Home screen MemoryCard routes to Memory Detail',
        (tester) async {
      final cat = makeCat(id: 'cat_h', name: 'Minnoş');
      await repo.addCat(cat);
      final mem = makeMemory(
        id: 'mem_h',
        catId: 'cat_h',
        catName: 'Minnoş',
        note: 'Ana sayfadan detaya',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesRouterApp(container: container),
      );

      container.read(routerProvider).go('/home');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('“Ana sayfadan detaya”'), findsOneWidget);

      await tester.tap(find.byType(MemoryCard));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Anı Detayı'), findsOneWidget);
    });

    testWidgets('34. Cat Detail screen MemoryCard routes to Memory Detail',
        (tester) async {
      final cat = makeCat(id: 'cat_cd', name: 'Duman');
      await repo.addCat(cat);
      final mem = makeMemory(
        id: 'mem_cd',
        catId: 'cat_cd',
        catName: 'Duman',
        note: 'Kedi detayından anı detayına',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesRouterApp(container: container),
      );

      container.read(routerProvider).go('/cat_detail/cat_cd');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      final catDetailList = find.descendant(
        of: find.byType(CatDetailScreen),
        matching: find.byType(ListView),
      );
      await tester.drag(catDetailList, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('“Kedi detayından anı detayına”'), findsWidgets);

      await tester.tap(find.text('“Kedi detayından anı detayına”').last);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Anı Detayı'), findsOneWidget);
    });
  });

  group('Accessibility, Theming & Responsiveness', () {
    testWidgets('35. Header has header semantics', (tester) async {
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.header == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('36. MemoryCard has button and label semantics when clickable',
        (tester) async {
      final mem = makeMemory(catName: 'Mişa', note: 'Özel an');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.button == true &&
              (w.properties.label?.contains('Mişa ile kaydedilmiş anıyı aç') ??
                  false),
        ),
        findsOneWidget,
      );
    });

    testWidgets('37. Dark mode renders correctly without contrast or theme error',
        (tester) async {
      final mem = makeMemory(note: 'Gece modu testi');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          themeMode: ThemeMode.dark,
        ),
      );

      expect(find.text('“Gece modu testi”'), findsOneWidget);
    });

    testWidgets('38. Small viewport (320x533) renders without RenderFlex overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 533);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cat = makeCat(name: 'Minik');
      await repo.addCat(cat);
      final mem = makeMemory(note: 'Küçük ekran testi');
      await repo.addMemory(mem);

      await tester.pumpWidget(
        createDirectMemoriesWidget(
          container: container,
          viewportSize: const Size(320, 533),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('“Küçük ekran testi”'), findsOneWidget);
    });

    testWidgets('39. Large text scaling (1.5x) renders without overflow',
        (tester) async {
      final mem = makeMemory(note: 'Büyük font testi');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          textScaler: const TextScaler.linear(1.5),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('“Büyük font testi”'), findsOneWidget);
    });

    testWidgets('40. English localization renders correct strings',
        (tester) async {
      final cat = makeCat(name: 'Luna');
      await repo.addCat(cat);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          locale: const Locale('en'),
        ),
      );

      expect(find.text('Memories'), findsOneWidget);
      expect(
        find.text('Archive of little moments in your life.'),
        findsOneWidget,
      );
      expect(find.text('All'), findsOneWidget);
      expect(find.text("You don't have any memories yet."), findsOneWidget);
      expect(find.text('Add Your First Memory'), findsOneWidget);
    });

    testWidgets('41. Long memory text is capped at 3 lines with ellipsis',
        (tester) async {
      final longNote = 'A' * 500;
      final mem = makeMemory(note: longNote);
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      final textWidget = tester.widget<Text>(find.text('“$longNote”'));
      expect(textWidget.maxLines, 3);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('42. Bottom padding of ListView guarantees 100dp clearance for FAB',
        (tester) async {
      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      final padding = listView.padding as EdgeInsets;
      expect(padding.bottom, 100);
    });

    testWidgets('43. Memory card renders cat mood sticker beside localized mood label',
        (tester) async {
      final mem = makeMemory(
        catMood: 'Mutlu',
        userMood: 'Huzurlu',
        note: 'Sticker test memory',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(
          container: container,
          locale: const Locale('en'),
        ),
      );

      // Verify localized label in English
      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('♡ Peaceful'), findsOneWidget);

      // Verify sticker image is rendered
      final imageFinders = find.byWidgetPredicate(
        (w) => w is Image && w.image is AssetImage && (w.image as AssetImage).assetName == 'assets/images/moods/cat_mood_happy.png',
      );
      expect(imageFinders, findsOneWidget);
    });

    testWidgets('44. Memory card with null or unsupported mood renders without sticker and without crash',
        (tester) async {
      final mem = makeMemory(
        catMood: null,
        userMood: null,
        note: 'No mood memory',
      );
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createDirectMemoriesWidget(container: container),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('“No mood memory”'), findsOneWidget);
      final moodImageFinders = find.byWidgetPredicate(
        (w) => w is Image && w.image is AssetImage && (w.image as AssetImage).assetName.contains('moods/cat_mood_'),
      );
      expect(moodImageFinders, findsNothing);
    });
  });
}
