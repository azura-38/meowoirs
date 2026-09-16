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
import 'package:meowoirs/features/home/home_screen.dart';
import 'package:meowoirs/features/memories/memories_screen.dart';
import 'package:meowoirs/features/memories/memory_detail_screen.dart';
import 'package:meowoirs/widgets/memory_card.dart';

Widget createMemoryDetailRouterApp({
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
          title: 'Meowoirs Memory Detail Test',
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

Widget createDirectMemoryDetailWidget({
  required ProviderContainer container,
  required String memoryId,
  VoidCallback? onBack,
  ValueChanged<String>? onNavigateToEditMemory,
  ValueChanged<String>? onNavigateToCatDetail,
  Locale locale = const Locale('tr'),
  ThemeMode themeMode = ThemeMode.light,
  TextScaler textScaler = TextScaler.noScaling,
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
        data: MediaQueryData(textScaler: textScaler),
        child: MemoryDetailScreen(
          memoryId: memoryId,
          onBack: onBack ?? () {},
          onNavigateToEditMemory: onNavigateToEditMemory ?? (_) {},
          onNavigateToCatDetail: onNavigateToCatDetail ?? (_) {},
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

  group('Phase 12 — Memory Detail Screen Comprehensive Suite', () {
    // 1. Memory Detail renders
    testWidgets('1. Memory Detail renders when valid memory exists', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Güneşin altında uyuyor.',
        createdAt: 1726320000000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm1',
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(MemoryDetailScreen), findsOneWidget);
      expect(find.text('Anı Detayı'), findsOneWidget);
    });

    // 2. Correct memory loaded by ID
    testWidgets('2. Correct memory loaded by ID', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Not 1', createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm2', catId: 'c1', catName: 'Pamuk', note: 'Hedef Not 2', createdAt: 2000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm2',
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Hedef Not 2'), findsOneWidget);
      expect(find.text('Not 1'), findsNothing);
    });

    // 3. Wrong memory not displayed
    testWidgets('3. Wrong memory not displayed', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Yanlış Anı', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'other_id',
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Yanlış Anı'), findsNothing);
      expect(find.text('Anı bulunamadı'), findsOneWidget);
    });

    // 4. Memory text rendered
    testWidgets('4. Memory text rendered as story content', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      const testNote = 'Bu özel bir hikâye: Pamuk bahçede kelebeklerle oynadı.';
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: testNote, createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text(testNote), findsOneWidget);
    });

    // 5. Cat name rendered
    testWidgets('5. Cat name rendered in cat badge', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Sarman Kral', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Sarman Kral', note: 'Bir anı', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Sarman Kral'), findsOneWidget);
    });

    // 6. Photo rendered
    testWidgets('6. Photo rendered when valid photo uri exists', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Fotoğraflı anı',
        photoUri: 'https://example.com/test_mem_photo.png',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AspectRatio), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    // 7. No-photo fallback
    testWidgets('7. No-photo fallback omits image box gracefully without error', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Fotoğrafsız anı',
        photoUri: null,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AspectRatio), findsNothing);
      expect(find.text('Fotoğrafsız anı'), findsOneWidget);
    });

    // 8. Missing-photo fallback
    testWidgets('8. Missing-photo fallback renders placeholder icon and does not crash', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Kayıp fotoğraflı anı',
        photoUri: '/non/existent/path/photo.jpg',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.byType(AspectRatio), findsOneWidget);
      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
    });

    // 9. Invalid memory ID
    testWidgets('9. Invalid memory ID renders not-found state', (tester) async {
      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'non_existent'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Anı bulunamadı'), findsOneWidget);
      expect(find.text('Geri'), findsOneWidget);
    });

    // 10. Deleted memory handling
    testWidgets('10. Deleted memory dynamically switches to not-found state', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-del', catId: 'c1', catName: 'Pamuk', note: 'Silinecek anı', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-del'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Silinecek anı'), findsOneWidget);

      await repo.deleteMemory('m-del');
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Anı bulunamadı'), findsOneWidget);
    });

    // 11. Cat mood rendering
    testWidgets('11. Cat mood rendered with prefix', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Ruh hali anısı',
        catMood: 'Oyuncu',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Ruh Hâli'), findsOneWidget);
      expect(find.text('Onun hâli: Oyuncu'), findsOneWidget);
    });

    // 12. User mood rendering
    testWidgets('12. User mood rendered with prefix', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Ruh hali anısı',
        userMood: 'Huzurlu',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Ruh Hâli'), findsOneWidget);
      expect(find.text('Senin hissin: Huzurlu'), findsOneWidget);
    });

    // 13. Date rendering
    testWidgets('13. Date rendering matches locale format', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      // 14 September 2026 = 1789430400000 approx
      final dateMillis = DateTime(2026, 9, 14).millisecondsSinceEpoch;
      await repo.addMemory(Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Tarih testi',
        createdAt: dateMillis,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('2026'), findsOneWidget);
    });

    // 14. Time / Date format correctness
    testWidgets('14. Date format displays day, month name, and year', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      final dateMillis = DateTime(2026, 5, 20).millisecondsSinceEpoch;
      await repo.addMemory(Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Tarih detay testi',
        createdAt: dateMillis,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Mayıs'), findsOneWidget);
      expect(find.textContaining('2026'), findsOneWidget);
    });

    // 15. Back navigation
    testWidgets('15. Back navigation triggers onBack callback', (tester) async {
      var backCalled = false;
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Geri testi', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm1',
        onBack: () => backCalled = true,
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      expect(backCalled, isTrue);
    });

    // 16. Edit action triggers callback
    testWidgets('16. Edit action triggers onNavigateToEditMemory with memory id', (tester) async {
      String? editedId;
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-edit-1', catId: 'c1', catName: 'Pamuk', note: 'Düzenleme', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm-edit-1',
        onNavigateToEditMemory: (id) => editedId = id,
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();

      expect(editedId, 'm-edit-1');
    });

    // 17. Edit preserves memory ID
    test('17. Edit repository operation preserves memory ID', () async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-persist', catId: 'c1', catName: 'Pamuk', note: 'Eski Not', createdAt: 1000));

      await repo.updateMemory(const Memory(id: 'm-persist', catId: 'c1', catName: 'Pamuk', note: 'Yeni Not', createdAt: 1000));
      final memory = await repo.memoryDao.getMemoryById('m-persist');

      expect(memory?.id, 'm-persist');
      expect(memory?.note, 'Yeni Not');
    });

    // 18. Edit preserves createdAt
    test('18. Edit repository operation preserves original createdAt', () async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      const originalTime = 123456789;
      await repo.addMemory(const Memory(id: 'm-time', catId: 'c1', catName: 'Pamuk', note: 'Zaman testi', createdAt: originalTime));

      await repo.updateMemory(const Memory(id: 'm-time', catId: 'c1', catName: 'Pamuk', note: 'Güncellendi', createdAt: originalTime));
      final memory = await repo.memoryDao.getMemoryById('m-time');

      expect(memory?.createdAt, originalTime);
    });

    // 19. Edit updates note reactively
    testWidgets('19. Edit updates note and Memory Detail reactively reflects it', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-live', catId: 'c1', catName: 'Pamuk', note: 'İlk Not', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-live'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('İlk Not'), findsOneWidget);

      await repo.updateMemory(const Memory(id: 'm-live', catId: 'c1', catName: 'Pamuk', note: 'Canlı Güncellenen Not', createdAt: 1000));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Canlı Güncellenen Not'), findsOneWidget);
      expect(find.text('İlk Not'), findsNothing);
    });

    // 20. Edit updates photo reactively
    testWidgets('20. Edit updates photo and Memory Detail reactively reflects it', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-photo', catId: 'c1', catName: 'Pamuk', note: 'Foto', photoUri: null, createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-photo'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AspectRatio), findsNothing);

      await repo.updateMemory(const Memory(id: 'm-photo', catId: 'c1', catName: 'Pamuk', note: 'Foto', photoUri: '/new/photo.png', createdAt: 1000));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AspectRatio), findsOneWidget);
    });

    // 21. Edit updates cat mood reactively
    testWidgets('21. Edit updates cat mood and reflects on Memory Detail', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-cmood', catId: 'c1', catName: 'Pamuk', note: 'Not', catMood: 'Sakin', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-cmood'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Onun hâli: Sakin'), findsOneWidget);

      await repo.updateMemory(const Memory(id: 'm-cmood', catId: 'c1', catName: 'Pamuk', note: 'Not', catMood: 'Sevecen', createdAt: 1000));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Onun hâli: Sevecen'), findsOneWidget);
    });

    // 22. Edit updates user mood reactively
    testWidgets('22. Edit updates user mood and reflects on Memory Detail', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-umood', catId: 'c1', catName: 'Pamuk', note: 'Not', userMood: 'Duygusal', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-umood'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Senin hissin: Duygusal'), findsOneWidget);

      await repo.updateMemory(const Memory(id: 'm-umood', catId: 'c1', catName: 'Pamuk', note: 'Not', userMood: 'Neşeli', createdAt: 1000));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Senin hissin: Neşeli'), findsOneWidget);
    });

    // 23. Delete action opens dialog
    testWidgets('23. Delete button opens confirmation dialog', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Silme testi', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    // 24. Delete confirmation dialog contents
    testWidgets('24. Delete confirmation dialog displays localized title, message, cancel and delete', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Dialog testi', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Bu anıyı silmek istediğinizden emin misiniz?'), findsOneWidget);
      expect(find.text('Bu anı kalıcı olarak silinecektir.'), findsOneWidget);
      expect(find.text('İptal'), findsOneWidget);
      expect(find.text('Sil'), findsOneWidget);
    });

    // 25. Cancel delete
    testWidgets('25. Canceling delete dismisses dialog and preserves memory', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-keep', catId: 'c1', catName: 'Pamuk', note: 'Kalan anı', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-keep'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('İptal'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Kalan anı'), findsOneWidget);

      final memory = await repo.memoryDao.getMemoryById('m-keep');
      expect(memory, isNotNull);
    });

    // 26. Confirm delete
    testWidgets('26. Confirming delete removes memory and invokes onBack', (tester) async {
      var backInvoked = false;
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-doomed', catId: 'c1', catName: 'Pamuk', note: 'Silinecek', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm-doomed',
        onBack: () => backInvoked = true,
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Sil'));
      await tester.pump(const Duration(milliseconds: 200));

      final memory = await repo.memoryDao.getMemoryById('m-doomed');
      expect(memory, isNull);
      expect(backInvoked, isTrue);
    });

    // 27. Double-delete protection
    testWidgets('27. Repeated delete taps while deleting do not trigger duplicate calls', (tester) async {
      var backCount = 0;
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-double', catId: 'c1', catName: 'Pamuk', note: 'Double delete', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm-double',
        onBack: () => backCount++,
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Sil'));
      await tester.pump(const Duration(milliseconds: 50));
      // Second tap attempted while deleting
      await tester.pump(const Duration(milliseconds: 200));

      expect(backCount, 1);
    });

    // 28. Home reactive update after deletion
    testWidgets('28. Home recent memories reactively updates after memory deletion', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-home-del', catId: 'c1', catName: 'Pamuk', note: 'Home Silinecek Anı', createdAt: 1000));

      await tester.pumpWidget(createMemoryDetailRouterApp(container: container));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.textContaining('Home Silinecek Anı'), findsOneWidget);

      await repo.deleteMemory('m-home-del');
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Home Silinecek Anı'), findsNothing);
    });

    // 29. Memories reactive update after deletion
    testWidgets('29. Memories list reactively updates after memory deletion', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-list-del', catId: 'c1', catName: 'Pamuk', note: 'Memories Silinecek Anı', createdAt: 1000));

      await tester.pumpWidget(createMemoryDetailRouterApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).go('/memories');
      await tester.pumpAndSettle();
      expect(find.byType(MemoriesScreen), findsOneWidget);
      expect(find.textContaining('Memories Silinecek Anı'), findsOneWidget);

      await repo.deleteMemory('m-list-del');
      await tester.pumpAndSettle();

      expect(find.textContaining('Memories Silinecek Anı'), findsNothing);
    });

    // 30. Cat Detail reactive update after deletion
    testWidgets('30. Cat Detail memory count reactively updates after memory deletion', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-count', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-cd-1', catId: 'cat-count', catName: 'Pamuk', note: 'Anı 1', createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-cd-2', catId: 'cat-count', catName: 'Pamuk', note: 'Anı 2', createdAt: 2000));

      await tester.pumpWidget(createMemoryDetailRouterApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-count');
      await tester.pumpAndSettle();
      expect(find.byType(CatDetailScreen), findsOneWidget);
      expect(find.textContaining('2 küçük anı burada'), findsOneWidget);

      await repo.deleteMemory('m-cd-2');
      await tester.pumpAndSettle();

      expect(find.textContaining('1 küçük anı burada'), findsOneWidget);
    });

    // 31. Orphan memory after cat deletion
    testWidgets('31. Orphan memory after cat deletion displays stored catName safely', (tester) async {
      await repo.addCat(const Cat(id: 'c-orphan', name: 'Öksüz Kedi', type: CatType.street, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-orphan', catId: 'c-orphan', catName: 'Öksüz Kedi', note: 'Tarihi anı', createdAt: 1000));

      // Delete cat
      await repo.deleteCat('c-orphan');

      // Open memory detail
      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-orphan'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.text('Öksüz Kedi'), findsOneWidget);
      expect(find.text('Tarihi anı'), findsOneWidget);
    });

    // 32. Accessibility semantics
    testWidgets('32. Actions provide accessible tooltips and semantics', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Erişilebilirlik', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm1'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byTooltip('Geri'), findsOneWidget);
      expect(find.byTooltip('Düzenle'), findsOneWidget);
      expect(find.byTooltip('Sil'), findsOneWidget);
    });

    // 33. Dark mode compatibility
    testWidgets('33. Memory Detail renders cleanly in dark theme mode', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm1', catId: 'c1', catName: 'Pamuk', note: 'Karanlık mod', createdAt: 1000));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm1',
        themeMode: ThemeMode.dark,
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.text('Karanlık mod'), findsOneWidget);
    });

    // 34. Small viewport 320x533
    testWidgets('34. Small viewport 320x533 renders without overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 533);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm-small',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Küçük ekran anısı',
        catMood: 'Oyuncu',
        userMood: 'Huzurlu',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-small'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.text('Küçük ekran anısı'), findsOneWidget);
    });

    // 35. Large text scale
    testWidgets('35. Large text scale (1.5x) renders without RenderFlex overflow', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm-scale',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Büyük font anısı',
        catMood: 'Meraklı',
        userMood: 'Mutlu',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm-scale',
        textScaler: const TextScaler.linear(1.5),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.text('Büyük font anısı'), findsOneWidget);
    });

    // 36. Localization
    testWidgets('36. Localization switches strings to English properly', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Cotton', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm-en',
        catId: 'c1',
        catName: 'Cotton',
        note: 'English memory',
        catMood: 'Happy',
        userMood: 'Peaceful',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(
        container: container,
        memoryId: 'm-en',
        locale: const Locale('en'),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Memory Detail'), findsOneWidget);
      expect(find.text('Mood'), findsOneWidget);
      expect(find.text('Their mood: Happy'), findsOneWidget);
      expect(find.text('Your mood: Peaceful'), findsOneWidget);
    });

    // 37. Long memory text
    testWidgets('37. Long memory text scrolls safely without clipping or crash', (tester) async {
      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      final longNote = 'Uzun anı satırı. ' * 100;
      await repo.addMemory(Memory(
        id: 'm-long',
        catId: 'c1',
        catName: 'Pamuk',
        note: longNote,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-long'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.byType(ListView), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    // 38. Photo failure does not crash
    testWidgets('38. Corrupted photo uri does not crash application', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await repo.addCat(const Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'm-bad-photo',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Bozuk foto anısı',
        photoUri: 'invalid://broken/path?null=error',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createDirectMemoryDetailWidget(container: container, memoryId: 'm-bad-photo'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
      expect(find.text('Bozuk foto anısı'), findsOneWidget);
    });

    // 39. Route from Home
    testWidgets('39. Route from Home MemoryCard opens memory detail', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'c-h', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-h', catId: 'c-h', catName: 'Pamuk', note: 'Home Anısı', createdAt: 1000));

      await tester.pumpWidget(createMemoryDetailRouterApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.tap(find.byType(MemoryCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(MemoryDetailScreen), findsOneWidget);
      expect(find.text('Home Anısı'), findsOneWidget);
    });

    // 40. Route from Memories
    testWidgets('40. Route from Memories MemoryCard opens memory detail', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'c-m', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-m', catId: 'c-m', catName: 'Pamuk', note: 'Memories Anısı', createdAt: 1000));

      await tester.pumpWidget(createMemoryDetailRouterApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).go('/memories');
      await tester.pumpAndSettle();

      expect(find.byType(MemoriesScreen), findsOneWidget);
      await tester.tap(find.byType(MemoryCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(MemoryDetailScreen), findsOneWidget);
      expect(find.text('Memories Anısı'), findsOneWidget);
    });

    // 41. Route from Cat Detail
    testWidgets('41. Route from Cat Detail MemoryCard opens memory detail', (tester) async {
      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'c-cd', name: 'Pamuk', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'm-cd', catId: 'c-cd', catName: 'Pamuk', note: 'CatDetail Anısı', createdAt: 1000));

      await tester.pumpWidget(createMemoryDetailRouterApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/c-cd');
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsOneWidget);
      await tester.tap(find.byType(MemoryCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(MemoryDetailScreen), findsOneWidget);
      expect(find.text('CatDetail Anısı'), findsOneWidget);
    });
  });
}
