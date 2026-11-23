import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/memories/memories_provider.dart';
import 'package:meowoirs/features/memories/memories_screen.dart';
import 'package:meowoirs/features/memories/memories_state.dart';
import 'package:meowoirs/features/memories/models/memories_view_mode.dart';
import 'package:meowoirs/features/memories/widgets/memories_view_menu.dart';
import 'package:meowoirs/features/memories/widgets/memory_content_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_large_icons_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_list_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_small_icons_view.dart';
import 'package:meowoirs/features/memories/widgets/memory_tiles_view.dart';
import 'package:meowoirs/widgets/memory_card.dart';

Widget createMemoriesExplorerWidget({
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

  Memory makeMemory({
    String id = 'mem_1',
    String catId = 'cat_1',
    String catName = 'Mişa',
    String note = 'Güneşte uyukladı.',
    String? photoUri,
    String? catMood = 'Mutlu',
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

  Cat makeCat({
    String id = 'cat_1',
    String name = 'Mişa',
  }) {
    return Cat(
      id: id,
      name: name,
      type: CatType.home,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  group('Memories Explorer View System — Core Requirements', () {
    testWidgets('1. Default mode is tiles (Döşeme)', (tester) async {
      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      expect(find.byType(MemoryTilesView), findsOneWidget);
      expect(find.byType(MemoryCard), findsOneWidget);
      expect(container.read(memoriesViewModeProvider), MemoriesViewMode.tiles);
    });

    testWidgets('2. Menu shows exactly five options with correct icons and labels',
        (tester) async {
      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      // Open View menu
      final menuFinder = find.byType(MemoriesViewMenu);
      expect(menuFinder, findsOneWidget);
      await tester.tap(menuFinder);
      await tester.pumpAndSettle();

      // Check for exactly 5 items
      expect(find.text('Döşeme'), findsWidgets);
      expect(find.text('Büyük Simgeler'), findsOneWidget);
      expect(find.text('Küçük Simgeler'), findsOneWidget);
      expect(find.text('Liste'), findsOneWidget);
      expect(find.text('İçerik'), findsOneWidget);

      final popupItems = tester.widgetList<PopupMenuItem<MemoriesViewMode>>(
        find.byType(PopupMenuItem<MemoriesViewMode>),
      );
      expect(popupItems.length, 5);
    });

    testWidgets('3. Selected mode is visually marked with checkmark',
        (tester) async {
      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      // Open menu in default tiles mode
      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();

      // Exactly one check icon is rendered indicating the active selection
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('4. Each of the five modes can be selected and switches layout',
        (tester) async {
      final mem = makeMemory(note: 'Farklı modlar testi');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      // 1. Initial mode is Tiles
      expect(find.byType(MemoryTilesView), findsOneWidget);

      // 2. Select Büyük Simgeler
      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Büyük Simgeler'));
      await tester.pumpAndSettle();
      expect(find.byType(MemoryLargeIconsView), findsOneWidget);

      // 3. Select Küçük Simgeler
      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Küçük Simgeler'));
      await tester.pumpAndSettle();
      expect(find.byType(MemorySmallIconsView), findsOneWidget);

      // 4. Select Liste
      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Liste'));
      await tester.pumpAndSettle();
      expect(find.byType(MemoryListView), findsOneWidget);

      // 5. Select İçerik
      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('İçerik'));
      await tester.pumpAndSettle();
      expect(find.byType(MemoryContentView), findsOneWidget);
    });

    testWidgets('5. View mode persists across restarts', (tester) async {
      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      // Change to 'list'
      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Liste'));
      await tester.pumpAndSettle();

      // Check repository persistence
      expect(prefsRepo.getMemoriesViewMode(), MemoriesViewMode.list);

      // Simulate app restart with same SharedPreferences
      final newContainer = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          repositoryProvider.overrideWithValue(repo),
          preferencesRepositoryProvider.overrideWithValue(prefsRepo),
        ],
      );
      addTearDown(newContainer.dispose);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: newContainer),
      );

      expect(newContainer.read(memoriesViewModeProvider), MemoriesViewMode.list);
      expect(find.byType(MemoryListView), findsOneWidget);
    });

    testWidgets('6. Invalid stored value falls back safely to tiles',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_completed': true,
        'memories_view_mode': 'corrupted_invalid_mode',
      });
      final corruptedPrefs = await SharedPreferences.getInstance();
      final corruptedRepo = PreferencesRepository(corruptedPrefs);
      addTearDown(corruptedRepo.dispose);

      expect(corruptedRepo.getMemoriesViewMode(), MemoriesViewMode.tiles);

      final testContainer = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          repositoryProvider.overrideWithValue(repo),
          preferencesRepositoryProvider.overrideWithValue(corruptedRepo),
        ],
      );
      addTearDown(testContainer.dispose);

      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: testContainer),
      );

      expect(testContainer.read(memoriesViewModeProvider), MemoriesViewMode.tiles);
      expect(find.byType(MemoryTilesView), findsOneWidget);
    });

    testWidgets('7. English labels render correctly in View menu',
        (tester) async {
      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(
          container: container,
          locale: const Locale('en'),
        ),
      );

      expect(find.text('View'), findsOneWidget);

      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();

      expect(find.text('Tiles'), findsWidgets);
      expect(find.text('Large Icons'), findsOneWidget);
      expect(find.text('Small Icons'), findsOneWidget);
      expect(find.text('List'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('8. Japanese locale renders without crash', (tester) async {
      final mem = makeMemory();
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(
          container: container,
          locale: const Locale('ja'),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('表示'), findsOneWidget);

      await tester.tap(find.byType(MemoriesViewMenu));
      await tester.pumpAndSettle();

      expect(find.text('並べて表示'), findsWidgets);
      expect(find.text('大アイコン'), findsOneWidget);
      expect(find.text('小アイコン'), findsOneWidget);
      expect(find.text('リスト'), findsOneWidget);
      expect(find.text('コンテンツ'), findsOneWidget);
    });

    testWidgets('9. Memory navigation works from all five modes',
        (tester) async {
      final mem = makeMemory(id: 'nav_target_mem', note: 'Detaya git');
      await repo.addMemory(mem);

      String? clickedId;

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(
          container: container,
          onNavigateToMemoryDetail: (id) => clickedId = id,
        ),
      );

      // Mode 1: Tiles
      await tester.tap(find.text('“Detaya git”'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(clickedId, 'nav_target_mem');
      clickedId = null;

      // Mode 2: Large Icons
      await container
          .read(memoriesViewModeProvider.notifier)
          .setViewMode(MemoriesViewMode.largeIcons);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Detaya git'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(clickedId, 'nav_target_mem');
      clickedId = null;

      // Mode 3: Small Icons
      await container
          .read(memoriesViewModeProvider.notifier)
          .setViewMode(MemoriesViewMode.smallIcons);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Detaya git'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(clickedId, 'nav_target_mem');
      clickedId = null;

      // Mode 4: List
      await container
          .read(memoriesViewModeProvider.notifier)
          .setViewMode(MemoriesViewMode.list);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Detaya git'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(clickedId, 'nav_target_mem');
      clickedId = null;

      // Mode 5: Content
      await container
          .read(memoriesViewModeProvider.notifier)
          .setViewMode(MemoriesViewMode.content);
      await tester.pumpAndSettle();
      await tester.tap(find.text('“Detaya git”'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(clickedId, 'nav_target_mem');
    });

    testWidgets('10. Cat mood sticker remains available in all five modes',
        (tester) async {
      final mem = makeMemory(catMood: 'Mutlu', userMood: 'Huzurlu');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      for (final mode in MemoriesViewMode.values) {
        await container
            .read(memoriesViewModeProvider.notifier)
            .setViewMode(mode);
        await tester.pumpAndSettle();

        final moodImages = find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage)
                  .assetName
                  .contains('moods/cat_mood_happy.png'),
        );
        expect(
          moodImages,
          findsWidgets,
          reason: 'Mood sticker should be present in mode: $mode',
        );
      }
    });

    testWidgets('11. Null/unknown cat mood does not crash in any mode',
        (tester) async {
      final mem = makeMemory(catMood: null, userMood: null);
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      for (final mode in MemoriesViewMode.values) {
        await container
            .read(memoriesViewModeProvider.notifier)
            .setViewMode(mode);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        final moodImages = find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is AssetImage &&
              (w.image as AssetImage).assetName.contains('moods/cat_mood_'),
        );
        expect(moodImages, findsNothing);
      }
    });

    testWidgets('12. Viewport 320x533 renders without RenderFlex overflow in all modes',
        (tester) async {
      tester.view.physicalSize = const Size(320, 533);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cat = makeCat(name: 'Minik');
      await repo.addCat(cat);
      final mem = makeMemory(note: 'Kompakt ekran testi');
      await repo.addMemory(mem);

      await tester.pumpWidget(
        createMemoriesExplorerWidget(
          container: container,
          viewportSize: const Size(320, 533),
        ),
      );
      await tester.pumpAndSettle();

      for (final mode in MemoriesViewMode.values) {
        await container
            .read(memoriesViewModeProvider.notifier)
            .setViewMode(mode);
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isNull,
          reason: 'Mode $mode must not overflow on 320x533',
        );
      }
    });

    testWidgets('13. Standard phone viewports (360x800, 390x844, 412x915) render without overflow',
        (tester) async {
      final viewports = [
        const Size(360, 800),
        const Size(390, 844),
        const Size(412, 915),
      ];

      final cat = makeCat(name: 'Susam');
      await repo.addCat(cat);
      final mem = makeMemory(note: 'Standart telefon ekranları testi');
      await repo.addMemory(mem);

      for (final size in viewports) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createMemoriesExplorerWidget(
            container: container,
            viewportSize: size,
          ),
        );
        await tester.pumpAndSettle();

        for (final mode in MemoriesViewMode.values) {
          await container
              .read(memoriesViewModeProvider.notifier)
              .setViewMode(mode);
          await tester.pumpAndSettle();

          expect(
            tester.takeException(),
            isNull,
            reason: 'Mode $mode must not overflow on $size',
          );
        }
      }
    });

    testWidgets('14. 1.5x text scaling does not overflow in all five modes',
        (tester) async {
      final mem = makeMemory(note: 'Büyük font erişilebilirlik testi');
      await repo.addMemory(mem);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(
          container: container,
          textScaler: const TextScaler.linear(1.5),
        ),
      );

      for (final mode in MemoriesViewMode.values) {
        await container
            .read(memoriesViewModeProvider.notifier)
            .setViewMode(mode);
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isNull,
          reason: 'Mode $mode must not overflow on 1.5x text scaling',
        );
      }
    });

    testWidgets('15. Empty state and loading state render correctly in all modes',
        (tester) async {
      // Empty state
      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: container),
      );

      for (final mode in MemoriesViewMode.values) {
        await container
            .read(memoriesViewModeProvider.notifier)
            .setViewMode(mode);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
        expect(find.text('Henüz bir anın yok.'), findsOneWidget);
      }

      // Loading state
      final loadingContainer = ProviderContainer(
        overrides: [
          memoriesUiStateProvider.overrideWithValue(
            const MemoriesUiState(isLoading: true),
          ),
        ],
      );
      addTearDown(loadingContainer.dispose);

      await pumpContainer(
        tester,
        createMemoriesExplorerWidget(container: loadingContainer),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('16. MemoriesViewMode serialization and parsing unit test',
        (tester) async {
      expect(MemoriesViewMode.tiles.toStorageString(), 'tiles');
      expect(MemoriesViewMode.largeIcons.toStorageString(), 'large_icons');
      expect(MemoriesViewMode.smallIcons.toStorageString(), 'small_icons');
      expect(MemoriesViewMode.list.toStorageString(), 'list');
      expect(MemoriesViewMode.content.toStorageString(), 'content');

      expect(MemoriesViewMode.fromString('tiles'), MemoriesViewMode.tiles);
      expect(MemoriesViewMode.fromString('large_icons'), MemoriesViewMode.largeIcons);
      expect(MemoriesViewMode.fromString('small_icons'), MemoriesViewMode.smallIcons);
      expect(MemoriesViewMode.fromString('list'), MemoriesViewMode.list);
      expect(MemoriesViewMode.fromString('content'), MemoriesViewMode.content);

      // Case-insensitive & trim tolerance
      expect(MemoriesViewMode.fromString('  LARGE_ICONS  '), MemoriesViewMode.largeIcons);

      // Safe fallbacks
      expect(MemoriesViewMode.fromString(null), MemoriesViewMode.tiles);
      expect(MemoriesViewMode.fromString(''), MemoriesViewMode.tiles);
      expect(MemoriesViewMode.fromString('unknown_value'), MemoriesViewMode.tiles);
    });
  });
}
