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
import 'package:meowoirs/features/memories/add_memory_screen.dart';
import 'package:meowoirs/features/memories/memory_detail_screen.dart';
import 'package:meowoirs/widgets/memory_card.dart';

Widget createCatDetailTestApp({
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
          title: 'Meowoirs Cat Detail Test',
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

  group('Phase 9 — Cat Detail Screen Comprehensive Suite', () {
    // 1. Valid Cat Detail route loads
    testWidgets('1. Valid Cat Detail route /cat_detail/{catId} loads cleanly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-1',
        name: 'Minnoş',
        type: CatType.home,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-1');
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsOneWidget);
      expect(find.text('Minnoş'), findsWidgets);
    });

    // 2. Invalid cat ID does not crash
    testWidgets('2. Invalid cat ID shows friendly not-found UI without crashing', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/non-existent-cat-id');
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsOneWidget);
      expect(find.text('Kedi bulunamadı'), findsOneWidget);
      expect(find.text('Bu hikâye artık mevcut değil veya silinmiş olabilir.'), findsOneWidget);
      expect(find.text('Geri'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // 3. Not-found state Back button
    testWidgets('3. Not-found state Back button navigates back cleanly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/non-existent-cat-id');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Geri'));
      await tester.pumpAndSettle();

      expect(find.text('Kedi bulunamadı'), findsNothing);
    });

    // 4. Cat name renders
    testWidgets('4. Cat name renders in Hero and Story Title', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-duman',
        name: 'Duman',
        type: CatType.home,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-duman');
      await tester.pumpAndSettle();

      expect(find.text('Duman'), findsWidgets);
      expect(find.text("Duman'ın Hikâyesi"), findsOneWidget);
    });

    // 5. Home Cat type renders
    testWidgets('5. Home Cat type renders with Ev Kedisi badge', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-home',
        name: 'Pamuk',
        type: CatType.home,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-home');
      await tester.pumpAndSettle();

      expect(find.text('Ev Kedisi'), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    // 6. Street Cat type renders
    testWidgets('6. Street Cat type renders with Sokak Kedisi badge', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-street',
        name: 'Gölge',
        type: CatType.street,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-street');
      await tester.pumpAndSettle();

      expect(find.text('Sokak Kedisi'), findsOneWidget);
      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
    });

    // 7. Cat photo renders
    testWidgets('7. Cat photo renders when valid photo URI provided', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-photo',
        name: 'Foto Kedi',
        type: CatType.home,
        photoUri: 'https://example.com/cat.jpg',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-photo');
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    // 8. Missing photo fallback
    testWidgets('8. Missing photo fallback displays warm 80dp circular silhouette with pets icon', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-no-photo',
        name: 'Sessiz',
        type: CatType.home,
        photoUri: null,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-no-photo');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
      expect(find.text('Sessiz'), findsWidgets);
    });

    // 9. Invalid photo fallback
    testWidgets('9. Invalid photo URI gracefully falls back to placeholder without crash', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-invalid-photo',
        name: 'Bozuk',
        type: CatType.street,
        photoUri: '/invalid/file/does_not_exist_404.jpg',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-invalid-photo');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pets_outlined), findsWidgets);
      expect(find.text('Bozuk'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    // 10. Cat note renders
    testWidgets('10. Cat note renders in editorial quote card when present', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-with-note',
        name: 'Tarçın',
        type: CatType.home,
        note: 'Güneşi ve uyumayı çok sever.',
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-with-note');
      await tester.pumpAndSettle();

      expect(find.text('Güneşi ve uyumayı çok sever.'), findsOneWidget);
      expect(find.byIcon(Icons.format_quote_rounded), findsOneWidget);
    });

    // 11. Empty note behavior
    testWidgets('11. Empty note behavior omits note quote card', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-without-note',
        name: 'Boncuk',
        type: CatType.home,
        note: null,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-without-note');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.format_quote_rounded), findsNothing);
    });

    // 12. Memory count text renders correctly for 0 memories
    testWidgets('12. Memory count text shows zero state message when no memories exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(
        id: 'cat-zero-mem',
        name: 'Maya',
        type: CatType.home,
        createdAt: 1000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-zero-mem');
      await tester.pumpAndSettle();

      expect(find.text('Birlikte biriktirdiğiniz küçük anlar. Bu hikâye ilk anısıyla başlayacak.'), findsOneWidget);
    });

    // 13. Memory count text for 1 memory
    testWidgets('13. Memory count text displays single memory message when 1 memory exists', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-one-mem', name: 'Zeytin', type: CatType.street, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'mem-1',
        catId: 'cat-one-mem',
        catName: 'Zeytin',
        note: 'Pencere kenarında oturdu',
        createdAt: 2000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-one-mem');
      await tester.pumpAndSettle();

      expect(find.text('Birlikte biriktirdiğiniz küçük anlar. 1 küçük anı burada.'), findsOneWidget);
      expect(find.text('1 anı kaydedildi'), findsOneWidget);
    });

    // 14. Memory count text for multiple memories
    testWidgets('14. Memory count text displays plural message when multiple memories exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-multi', name: 'Fındık', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(id: 'mem-1', catId: 'cat-multi', catName: 'Fındık', note: 'Anı 1', createdAt: 2000));
      await repo.addMemory(const Memory(id: 'mem-2', catId: 'cat-multi', catName: 'Fındık', note: 'Anı 2', createdAt: 3000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-multi');
      await tester.pumpAndSettle();

      expect(find.text('Birlikte biriktirdiğiniz küçük anlar. 2 küçük anı burada.'), findsOneWidget);
      expect(find.text('2 anı kaydedildi'), findsOneWidget);
    });

    // 15. Only selected cat's memories render
    testWidgets('15. Only selected cat memories render, excluding other cats', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-a', name: 'Cat A', type: CatType.home, createdAt: 1000));
      await repo.addCat(const Cat(id: 'cat-b', name: 'Cat B', type: CatType.street, createdAt: 2000));

      await repo.addMemory(const Memory(id: 'mem-a', catId: 'cat-a', catName: 'Cat A', note: 'A unique memory for Cat A', createdAt: 3000));
      await repo.addMemory(const Memory(id: 'mem-b', catId: 'cat-b', catName: 'Cat B', note: 'B unique memory for Cat B', createdAt: 4000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-a');
      await tester.pumpAndSettle();

      expect(find.textContaining('A unique memory for Cat A'), findsOneWidget);
      expect(find.textContaining('B unique memory for Cat B'), findsNothing);
    });

    // 16. Memory loading state
    testWidgets('16. Memory loading state displays CircularProgressIndicator', (tester) async {
      final loadingContainer = ProviderContainer(
        overrides: [
          catByIdStreamProvider('loading-cat').overrideWith((ref) => Stream.value(
                const Cat(id: 'loading-cat', name: 'Loading', type: CatType.home, createdAt: 1000),
              )),
          catMemoriesStreamProvider('loading-cat').overrideWith((ref) => const Stream.empty()),
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
            home: CatDetailScreen(
              catId: 'loading-cat',
              onBack: () {},
              onNavigateToEditCat: (_) {},
              onNavigateToAddMemory: (_) {},
              onNavigateToMemoryDetail: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // 17. Memory empty state
    testWidgets('17. Memory empty state displays warm card when no memories exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-empty', name: 'Boş Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-empty');
      await tester.pumpAndSettle();

      expect(find.text('Hikâye daha yeni başlıyor.'), findsOneWidget);
      expect(find.text('Bu kediyle yaşadığın ilk küçük anı burada saklayabilirsin.'), findsOneWidget);
      expect(find.text('İlk Anıyı Ekle'), findsOneWidget);
    });

    // 18. Empty state CTA navigates to Add Memory with cat ID
    testWidgets('18. Empty state CTA navigates to Add Memory preserving cat ID', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-cta', name: 'CTA Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-cta');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'İlk Anıyı Ekle'));
      await tester.pumpAndSettle();

      expect(find.byType(AddMemoryScreen), findsOneWidget);
    });

    // 19. Contextual header Add Memory button
    testWidgets('19. Contextual header Anı Ekle button navigates to Add Memory preserving cat ID', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-hdr-btn', name: 'Header Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-hdr-btn');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Anı Ekle'));
      await tester.pumpAndSettle();

      expect(find.byType(AddMemoryScreen), findsOneWidget);
    });

    // 20. Memory card renders data
    testWidgets('20. MemoryCard renders note, moods, and details when memories exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-card', name: 'Kart Kedi', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'mem-card-1',
        catId: 'cat-card',
        catName: 'Kart Kedi',
        note: 'Parkta kelebek kovaladı',
        catMood: 'Meraklı',
        userMood: 'Mutlu',
        createdAt: 2000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-card');
      await tester.pumpAndSettle();

      expect(find.byType(MemoryCard), findsOneWidget);
      expect(find.textContaining('Parkta kelebek kovaladı'), findsOneWidget);
      expect(find.text('Meraklı'), findsOneWidget);
      expect(find.textContaining('Mutlu'), findsOneWidget);
    });

    // 21. Memory card without photo
    testWidgets('21. MemoryCard without photo renders cleanly with placeholder', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-no-photo-mem', name: 'Foto Yok', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'mem-no-photo',
        catId: 'cat-no-photo-mem',
        catName: 'Foto Yok',
        note: 'Sessiz sabah anısı',
        photoUri: null,
        createdAt: 2000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-no-photo-mem');
      await tester.pumpAndSettle();

      expect(find.textContaining('Sessiz sabah anısı'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // 22. Tapping MemoryCard navigates to Memory Detail
    testWidgets('22. Tapping MemoryCard navigates to Memory Detail screen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-tap-mem', name: 'Dokun Kedi', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'mem-tap-1',
        catId: 'cat-tap-mem',
        catName: 'Dokun Kedi',
        note: 'Detaya gitme testi',
        createdAt: 2000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-tap-mem');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MemoryCard));
      await tester.pumpAndSettle();

      expect(find.byType(MemoryDetailScreen), findsOneWidget);
    });

    // 23. Top bar Back button
    testWidgets('23. Top bar Back button returns back cleanly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-back', name: 'Geri Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-back');
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsNothing);
    });

    // 24. Top bar Edit button
    testWidgets('24. Top bar Edit button navigates to Edit Cat with cat ID', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-edit', name: 'Düzenle Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-edit');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(AddCatScreen), findsOneWidget);
    });

    // 25. Top bar Delete button opens confirmation dialog
    testWidgets('25. Top bar Delete button opens confirmation dialog', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-del', name: 'Sil Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-del');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Bu kediyi silmek istediğinizden emin misiniz?'), findsOneWidget);
      expect(find.text('Kedi profili silinecektir. Kaydedilmiş anılar korunacaktır.'), findsOneWidget);
      expect(find.text('İptal'), findsOneWidget);
      expect(find.text('Sil'), findsOneWidget);
    });

    // 26. Cancelling delete dialog leaves cat intact
    testWidgets('26. Cancelling delete dialog dismisses dialog and leaves cat intact', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-cancel', name: 'İptal Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-cancel');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('İptal'));
      await tester.pumpAndSettle();

      expect(find.text('Bu kediyi silmek istediğinizden emin misiniz?'), findsNothing);
      expect(find.byType(CatDetailScreen), findsOneWidget);

      final catInDb = await repo.catDao.getCatById('cat-cancel');
      expect(catInDb, isNotNull);
    });

    // 27. Confirming delete removes cat and navigates back
    testWidgets('27. Confirming delete removes cat from database and returns back', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-confirm-del', name: 'Onay Sil', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-confirm-del');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sil'));
      await tester.pumpAndSettle();

      expect(find.byType(CatDetailScreen), findsNothing);

      final catInDb = await repo.catDao.getCatById('cat-confirm-del');
      expect(catInDb, isNull);
    });

    // 28. Delete preserves associated memories
    testWidgets('28. Deleting a cat preserves associated memories in database', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-preserve', name: 'Korunan Kedi', type: CatType.home, createdAt: 1000));
      await repo.addMemory(const Memory(
        id: 'mem-preserved-1',
        catId: 'cat-preserve',
        catName: 'Korunan Kedi',
        note: 'Bu anı silinmemeli',
        createdAt: 2000,
      ));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-preserve');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sil'));
      await tester.pumpAndSettle();

      // Verify memory still exists in database
      final memInDb = await repo.memoryDao.getMemoryById('mem-preserved-1');
      expect(memInDb, isNotNull);
      expect(memInDb!.note, equals('Bu anı silinmemeli'));
    });

    // 29. Reactive cat update
    testWidgets('29. Updating cat details via repository reactively updates screen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-reakt', name: 'Eski Ad', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-reakt');
      await tester.pumpAndSettle();

      expect(find.text('Eski Ad'), findsWidgets);

      // Update cat in repository
      await repo.updateCat(const Cat(id: 'cat-reakt', name: 'Yeni Ad', type: CatType.home, createdAt: 1000));
      await tester.pumpAndSettle();

      expect(find.text('Yeni Ad'), findsWidgets);
      expect(find.text('Eski Ad'), findsNothing);
    });

    // 30. Reactive memory update
    testWidgets('30. Adding a memory reactively updates Cat Detail from empty state to memories list', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-dyn-mem', name: 'Dinamik Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-dyn-mem');
      await tester.pumpAndSettle();

      expect(find.text('Hikâye daha yeni başlıyor.'), findsOneWidget);

      // Add memory dynamically
      await repo.addMemory(const Memory(
        id: 'mem-dyn-1',
        catId: 'cat-dyn-mem',
        catName: 'Dinamik Kedi',
        note: 'Yeni anı eklendi',
        createdAt: 2000,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Hikâye daha yeni başlıyor.'), findsNothing);
      expect(find.textContaining('Yeni anı eklendi'), findsOneWidget);
    });

    // 31. Dark mode compatibility
    testWidgets('31. Cat Detail renders cleanly in dark theme mode', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-dark', name: 'Gece', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(
        container: container,
        themeMode: ThemeMode.dark,
      ));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-dark');
      await tester.pumpAndSettle();

      expect(find.text('Gece'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    // 32. Accessibility semantics
    testWidgets('32. Actions provide accessible localized semantics', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repo.addCat(const Cat(id: 'cat-sem', name: 'Semantik Kedi', type: CatType.home, createdAt: 1000));

      await tester.pumpWidget(createCatDetailTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(routerProvider).push('/cat_detail/cat-sem');
      await tester.pumpAndSettle();

      final backFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.label == 'Kedi detayından geri dön'),
      );
      expect(backFinder, findsOneWidget);

      final editFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.label == 'Kediyi düzenle'),
      );
      expect(editFinder, findsOneWidget);

      final delFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.label == 'Kediyi sil'),
      );
      expect(delFinder, findsOneWidget);
    });
  });
}
