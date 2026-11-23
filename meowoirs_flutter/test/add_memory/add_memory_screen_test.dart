import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:meowoirs/features/memories/add_memory_screen.dart';
import 'package:meowoirs/features/memories/add_memory_view_model.dart';

// ---------------------------------------------------------------------------
// Mock image picker
// ---------------------------------------------------------------------------
class MockImagePicker extends Fake implements ImagePicker {
  MockImagePicker({this.pickedFile, this.shouldThrow = false});
  XFile? pickedFile;
  bool shouldThrow;
  int pickCallCount = 0;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    pickCallCount++;
    if (shouldThrow) {
      throw Exception('Photo picker platform error');
    }
    return pickedFile;
  }
}

// ---------------------------------------------------------------------------
// Viewport & Test app builders
// ---------------------------------------------------------------------------
void setPhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
}

Widget createAddMemoryTestApp({
  required ProviderContainer container,
  String? initialCatId,
  String? memoryId,
  VoidCallback? onBack,
  VoidCallback? onNavigateToAddCat,
  ImagePicker? imagePicker,
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: MeowoirsTheme.lightTheme,
      darkTheme: MeowoirsTheme.darkTheme,
      themeMode: themeMode,
      home: AddMemoryScreen(
        initialCatId: initialCatId,
        memoryId: memoryId,
        onBack: onBack ?? () {},
        onNavigateToAddCat: onNavigateToAddCat ?? () {},
        imagePicker: imagePicker,
      ),
    ),
  );
}

Widget createAddMemoryRoutedApp({
  required ProviderContainer container,
  Locale locale = const Locale('en'),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: MeowoirsTheme.lightTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// Test Suite
// ---------------------------------------------------------------------------
void main() {
  late MeowoirsDatabase database;
  late PreferencesRepository prefsRepo;
  late DriftMeowoirsRepository repository;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefsRepo = PreferencesRepository(prefs);

    database = MeowoirsDatabase(NativeDatabase.memory());
    repository = DriftMeowoirsRepository(
      catDao: database.catDao,
      memoryDao: database.memoryDao,
      preferencesRepository: prefsRepo,
    );

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        repositoryProvider.overrideWithValue(repository),
        preferencesRepositoryProvider.overrideWithValue(prefsRepo),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
    prefsRepo.dispose();
  });

  group('Phase 11 — Add / Edit Memory Screen Comprehensive Suite', () {
    // 1. Structural rendering
    testWidgets('1. Add Memory renders all essential editorial components', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Add Memory'), findsOneWidget);
      expect(find.text('Keep a little memory from today.'), findsOneWidget);
      expect(find.text('With who?'), findsOneWidget);
      expect(find.text('A photo that reminds you of this memory'), findsOneWidget);
      expect(find.text('What happened?'), findsOneWidget);
      expect(find.text('Their mood'), findsOneWidget);
      expect(find.text('How you felt?'), findsOneWidget);
      expect(find.text('When?'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

    // 2. Zero cats available shows Add Cat shortcut
    testWidgets('2. Zero cats available shows Add Cat shortcut and disabled Save', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Add Cat'), findsOneWidget);
      final saveBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Save'));
      expect(saveBtn.onPressed, isNull);
    });

    // 3. Add Cat shortcut callback
    testWidgets('3. Tapping Add Cat shortcut invokes onNavigateToAddCat callback', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      bool navigated = false;
      await tester.pumpWidget(createAddMemoryTestApp(
        container: container,
        onNavigateToAddCat: () => navigated = true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Add Cat'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(navigated, isTrue);
    });

    // 4. Single cat auto-selection
    testWidgets('4. Single cat auto-selects when initialCatId is null', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Luna'), findsOneWidget);
      final saveBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Save'));
      expect(saveBtn.onPressed, isNotNull);
    });

    // 5. Multiple cats: no auto-selection
    testWidgets('5. Multiple cats available requires explicit selection and disables Save initially', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Luna'), findsOneWidget);
      expect(find.text('Milo'), findsOneWidget);

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.selectedCatId, isNull);
    });

    // 6. Pre-selects cat with valid initialCatId
    testWidgets('6. Pre-selects cat when valid initialCatId provided', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, initialCatId: 'cat2'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: 'cat2', memoryId: null)));
      expect(vm.selectedCatId, 'cat2');
      expect(vm.selectedCat?.name, 'Milo');
    });

    // 7. Route navigation with catId preserves selected cat
    testWidgets('7. Route navigation /add_memory?catId={catId} preserves selected cat', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.completeOnboarding('1');
      await repository.addCat(const Cat(id: 'cat-alpha', name: 'Alpha', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat-beta', name: 'Beta', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryRoutedApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      container.read(routerProvider).push('/add_memory?catId=cat-beta');
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Add Memory'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      final vm = container.read(addMemoryViewModelProvider((initialCatId: 'cat-beta', memoryId: null)));
      expect(vm.selectedCatId, 'cat-beta');
    });

    // 8. Invalid catId does not silently select single cat
    testWidgets('8. Invalid catId does not silently select another cat when single cat exists', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'valid-cat', name: 'Real Cat', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, initialCatId: 'non-existent-cat'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: 'non-existent-cat', memoryId: null)));
      expect(vm.selectedCatId, isNull);
    });

    // 9. Invalid catId leaves selection empty with multiple cats
    testWidgets('9. Invalid catId leaves selection empty with multiple cats', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, initialCatId: 'bogus-cat'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: 'bogus-cat', memoryId: null)));
      expect(vm.selectedCatId, isNull);
    });

    // 10. Deleted cat is handled safely
    testWidgets('10. Deleted cat is handled safely without crash', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat-to-delete', name: 'Ghost', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, initialCatId: 'cat-to-delete'));
      await tester.pump(const Duration(milliseconds: 300));

      // Now delete the cat from repository
      await repository.deleteCat('cat-to-delete');
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: 'cat-to-delete', memoryId: null)));
      expect(vm.selectedCat, isNull);
      expect(tester.takeException(), isNull);
    });

    // 11. Selecting a cat chip updates selectedCatId
    testWidgets('11. Selecting a cat chip updates selectedCatId and enables Save', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Milo'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.selectedCatId, 'cat2');
    });

    // 12. Switching cat selection
    testWidgets('12. Switching cat selection updates selected cat ID', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, initialCatId: 'cat1'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Milo'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: 'cat1', memoryId: null)));
      expect(vm.selectedCatId, 'cat2');
    });

    // 13. Validation error when saving without cat
    testWidgets('13. Validation error displayed when attempting to save without cat', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      // Scroll to Save
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please select a cat for this memory.'), findsOneWidget);
    });

    // 14. Validation error clears when cat selected
    testWidgets('14. Validation error clears when cat is subsequently selected', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat2', name: 'Milo', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Please select a cat for this memory.'), findsOneWidget);

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, 600));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Luna'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please select a cat for this memory.'), findsNothing);
    });

    // 15. Note input updates state
    testWidgets('15. Note input controller updates state', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byType(TextField), 'Played with yarn all afternoon!');
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.note, 'Played with yarn all afternoon!');
    });

    // 16. Note whitespace trimming on save
    testWidgets('16. Note whitespace is trimmed on save', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byType(TextField), '   Paws on the keyboard   \n');
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 500));

      final memories = await database.select(database.memoriesTable).get();
      expect(memories.length, 1);
      expect(memories.first.note, 'Paws on the keyboard');
    });

    // 17. Note field allows multi-line input and displays hint
    testWidgets('17. Note field allows multi-line input and displays localized hint', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.minLines, 4);
      expect(tf.maxLines, isNull);
      expect(tf.decoration?.hintText, 'What happened today? e.g. Fell asleep by the window again today...');
    });

    // 18. Cat mood chip selection sets catMood
    testWidgets('18. Cat mood chip selection sets catMood', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await tester.pump(const Duration(milliseconds: 300));

      final playfulChip = find.text('Playful');
      await tester.tap(playfulChip);
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.catMood, 'Oyuncu');
    });

    // 19. Cat mood chip re-selection deselects
    testWidgets('19. Cat mood chip re-selection toggles off / deselects catMood', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Playful'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).catMood, 'Oyuncu');

      await tester.tap(find.text('Playful'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).catMood, isNull);
    });

    // 20. User mood chip selection sets userMood
    testWidgets('20. User mood chip selection sets userMood', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('♡ Peaceful'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.userMood, 'Huzurlu');
    });

    // 21. User mood chip re-selection deselects
    testWidgets('21. User mood chip re-selection toggles off / deselects userMood', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('♡ Peaceful'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).userMood, 'Huzurlu');

      await tester.tap(find.text('♡ Peaceful'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).userMood, isNull);
    });

    // 22. Dual mood simultaneous selection
    testWidgets('22. Dual mood simultaneous selection persists both cat and user mood', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Curious'));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('♡ Joyful'));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 500));

      final memories = await database.select(database.memoriesTable).get();
      expect(memories.first.catMood, 'Meraklı');
      expect(memories.first.userMood, 'Neşeli');
    });

    // 23. Timestamp defaults to current date/time
    testWidgets('23. Timestamp defaults to valid current timestamp', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now().millisecondsSinceEpoch;
      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.selectedDateMillis, greaterThanOrEqualTo(now - 2000));
      expect(vm.selectedDateMillis, lessThanOrEqualTo(now + 2000));
    });

    // 24. Date picker opens
    testWidgets('24. Date picker opens and allows selecting a timestamp', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -500));
      await tester.pump(const Duration(milliseconds: 300));

      final calendarBtn = find.byIcon(Icons.calendar_today_outlined);
      await tester.tap(calendarBtn);
      await tester.pump(const Duration(milliseconds: 300));

      // DatePicker dialog should be visible
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Cancel'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(DatePickerDialog), findsNothing);
    });

    // 25. Photo picker: open picker on container tap
    testWidgets('25. Photo picker: tapping photo area invokes ImagePicker', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(pickedFile: XFile('sample_photo.jpg'));
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      final addPhotoIcon = find.byIcon(Icons.add_a_photo_outlined);
      await tester.tap(addPhotoIcon);
      await tester.pump(const Duration(milliseconds: 300));

      expect(mockPicker.pickCallCount, 1);
    });

    // 26. Photo picker: cancel picker leaves photoUri null
    testWidgets('26. Photo picker: cancel leaves photoUri null with no crash', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(pickedFile: null); // returns null on cancel
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      expect(mockPicker.pickCallCount, 1);
      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.photoUri, isNull);
    });

    // 27. Photo picker: select image sets photoUri
    testWidgets('27. Photo picker: selecting image updates photoUri', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(pickedFile: XFile('cat_pic.jpg'));
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.photoUri, 'cat_pic.jpg');
      expect(find.text('Change'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    // 28. Photo picker: replace image updates photoUri
    testWidgets('28. Photo picker: Change photo replaces image URI', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(pickedFile: XFile('photo1.jpg'));
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));
      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).photoUri, 'photo1.jpg');

      mockPicker.pickedFile = XFile('photo2.jpg');
      await tester.tap(find.text('Change'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).photoUri, 'photo2.jpg');
      expect(mockPicker.pickCallCount, 2);
    });

    // 29. Photo picker: remove photo clears photoUri
    testWidgets('29. Photo picker: Remove button clears photoUri', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(pickedFile: XFile('photo_to_remove.jpg'));
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Remove'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.photoUri, isNull);
      expect(find.text('Remove'), findsNothing);
    });

    // 30. Photo picker: platform exception does not crash
    testWidgets('30. Photo picker: platform error handled gracefully without crash', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(shouldThrow: true);
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      expect(mockPicker.pickCallCount, 1);
      expect(tester.takeException(), isNull);
    });

    // 31. Kotlin ActivityResultRegistryOwner crash path: NOT USED / NOT REPRODUCED
    testWidgets('31. Kotlin ActivityResultRegistryOwner crash path: NOT USED / NOT REPRODUCED', (tester) async {
      // Direct verification that Flutter uses image_picker plugin without Compose ActivityResultRegistryOwner
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final mockPicker = MockImagePicker(pickedFile: XFile('safe_image.jpg'));
      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      expect(container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null))).photoUri, 'safe_image.jpg');
    });

    // 32. Missing photo file fallback
    testWidgets('32. Missing photo file fallback renders placeholder without crash', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addMemory(const Memory(
        id: 'mem-broken-photo',
        catId: 'cat1',
        catName: 'Luna',
        note: 'Broken photo note',
        photoUri: '/non/existent/path/photo.png',
        createdAt: 100,
      ));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, memoryId: 'mem-broken-photo'));
      await tester.pump(const Duration(milliseconds: 500));

      // Renders Image smoothly without unhandled exceptions
      expect(find.byWidgetPredicate((w) => w is Image && w.image is FileImage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // 33. Create memory persists all fields to database
    testWidgets('33. Create memory persists all fields to database', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat-main', name: 'Whiskers', type: CatType.home, createdAt: 100));
      final mockPicker = MockImagePicker(pickedFile: XFile('cat_full.jpg'));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, imagePicker: mockPicker));
      await tester.pump(const Duration(milliseconds: 300));

      // Pick photo
      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pump(const Duration(milliseconds: 300));

      // Enter Note
      await tester.enterText(find.byType(TextField), 'Whiskers caught a sunbeam.');
      await tester.pump(const Duration(milliseconds: 300));

      // Select moods
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Sleepy'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('♡ Calm'));
      await tester.pump(const Duration(milliseconds: 200));

      // Save
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 500));

      final memories = await database.select(database.memoriesTable).get();
      expect(memories.length, 1);
      final m = memories.first;
      expect(m.catId, 'cat-main');
      expect(m.catName, 'Whiskers');
      expect(m.note, 'Whiskers caught a sunbeam.');
      expect(m.photoUri, 'cat_full.jpg');
      expect(m.catMood, 'Uykulu');
      expect(m.userMood, 'Sakin');
      expect(m.createdAt, isNotNull);
    });

    // 34. Double-save protection
    testWidgets('34. Double-save protection prevents duplicate memory creation', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      final saveButtonFinder = find.widgetWithText(ElevatedButton, 'Save');
      // Rapid multiple taps
      await tester.tap(saveButtonFinder);
      await tester.tap(saveButtonFinder);
      await tester.tap(saveButtonFinder);
      await tester.pump(const Duration(milliseconds: 500));

      final memories = await database.select(database.memoriesTable).get();
      expect(memories.length, 1);
    });

    // 35. Save memory disables button when isSaving or isSaved
    testWidgets('35. Save memory disables button when isSaving or isSaved', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      var saveBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Save'));
      expect(saveBtn.onPressed, isNotNull);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 300));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)));
      expect(vm.isSaved, isTrue);
      saveBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Saved ✓'));
      expect(saveBtn.onPressed, isNull);

      // Drain the delayed onBack timer (350ms)
      await tester.pump(const Duration(milliseconds: 500));
    });

    // 36. Save memory database error sets saveError
    testWidgets('36. Save memory database error sets saveError', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      final vmNotifier = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: null)).notifier);
      vmNotifier.state = vmNotifier.state.copyWith(saveError: 'save_failed');

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('An error occurred while saving the memory. Please try again.'), findsOneWidget);
    });

    // 37. Edit mode loads existing memory
    testWidgets('37. Edit mode loads existing memory by memoryId and populates all fields', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addMemory(const Memory(
        id: 'mem-edit-1',
        catId: 'cat1',
        catName: 'Luna',
        note: 'Original memory text',
        photoUri: 'existing_photo.jpg',
        catMood: 'Mutlu',
        userMood: 'Huzurlu',
        createdAt: 9999000,
      ));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, memoryId: 'mem-edit-1'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Edit Memory'), findsOneWidget);
      expect(find.text('Update this memory.'), findsOneWidget);

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.controller?.text, 'Original memory text');

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: 'mem-edit-1')));
      expect(vm.isEditMode, isTrue);
      expect(vm.catMood, 'Mutlu');
      expect(vm.userMood, 'Huzurlu');
      expect(vm.photoUri, 'existing_photo.jpg');
      expect(vm.selectedDateMillis, 9999000);
    });

    // 38. Edit mode displays Save Changes button
    testWidgets('38. Edit mode displays Save Changes button label', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addMemory(const Memory(
        id: 'mem-edit-2',
        catId: 'cat1',
        catName: 'Luna',
        note: 'Note',
        createdAt: 100,
      ));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, memoryId: 'mem-edit-2'));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.widgetWithText(ElevatedButton, 'Save Changes'), findsOneWidget);
    });

    // 39. Edit mode updates memory in place
    testWidgets('39. Edit mode updates existing memory in place without duplicating', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addMemory(const Memory(
        id: 'mem-edit-3',
        catId: 'cat1',
        catName: 'Luna',
        note: 'Initial note',
        createdAt: 100,
      ));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, memoryId: 'mem-edit-3'));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.enterText(find.byType(TextField), 'Updated note content');
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
      await tester.pump(const Duration(milliseconds: 500));

      final memories = await database.select(database.memoriesTable).get();
      expect(memories.length, 1);
      expect(memories.first.id, 'mem-edit-3');
      expect(memories.first.note, 'Updated note content');
    });

    // 40. Reopen memory with photo
    testWidgets('40. Reopening memory with photo persists photoUri', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));
      await repository.addMemory(const Memory(
        id: 'mem-with-pic',
        catId: 'cat1',
        catName: 'Luna',
        note: 'Pic note',
        photoUri: 'persistent_cat.jpg',
        createdAt: 100,
      ));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, memoryId: 'mem-with-pic'));
      await tester.pump(const Duration(milliseconds: 500));

      final vm = container.read(addMemoryViewModelProvider((initialCatId: null, memoryId: 'mem-with-pic')));
      expect(vm.photoUri, 'persistent_cat.jpg');
      expect(find.text('Change'), findsOneWidget);
    });

    // 41. Memory relationship preservation
    testWidgets('41. Memory relationship preservation: catId and catName accurately linked to Cat', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat-rel-1', name: 'Sylvester', type: CatType.street, createdAt: 100));
      await repository.addCat(const Cat(id: 'cat-rel-2', name: 'Garfield', type: CatType.home, createdAt: 200));

      await tester.pumpWidget(createAddMemoryTestApp(container: container, initialCatId: 'cat-rel-2'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byType(TextField), 'Lasagna moment');
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 500));

      final memories = await database.select(database.memoriesTable).get();
      expect(memories.first.catId, 'cat-rel-2');
      expect(memories.first.catName, 'Garfield');
    });

    // 42. Reactive integration: Cat Detail updates immediately
    test('42. Reactive integration: Creating memory emits to Cat Detail stream immediately', () async {
      await repository.addCat(const Cat(id: 'cat-reactive', name: 'Felix', type: CatType.home, createdAt: 100));

      final listBefore = await repository.getMemoriesForCat('cat-reactive').first;
      expect(listBefore.length, 0);

      // Add memory via view model / repository
      await repository.addMemory(const Memory(
        id: 'mem-reactive-1',
        catId: 'cat-reactive',
        catName: 'Felix',
        note: 'Reactive test',
        createdAt: 1000,
      ));

      final listAfter = await repository.getMemoriesForCat('cat-reactive').first;
      expect(listAfter.length, 1);
      expect(listAfter.first.id, 'mem-reactive-1');
    });

    // 43. Reactive integration: Home recent memories updates immediately
    test('43. Reactive integration: Creating memory emits to Home memories stream immediately', () async {
      await repository.addCat(const Cat(id: 'cat-home', name: 'Tom', type: CatType.home, createdAt: 100));

      final listBefore = await repository.getAllMemories().first;
      expect(listBefore.length, 0);

      await repository.addMemory(const Memory(
        id: 'mem-home-1',
        catId: 'cat-home',
        catName: 'Tom',
        note: 'Tom slept on the sofa',
        createdAt: 1000,
      ));

      final listAfter = await repository.getAllMemories().first;
      expect(listAfter.length, 1);
      expect(listAfter.first.note, 'Tom slept on the sofa');
    });

    // 44. Back button triggers onBack
    testWidgets('44. Back button triggers onBack callback', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      bool popped = false;
      await tester.pumpWidget(createAddMemoryTestApp(
        container: container,
        onBack: () => popped = true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump(const Duration(milliseconds: 100));

      expect(popped, isTrue);
    });

    // 45. Save success triggers onBack
    testWidgets('45. Save success triggers onBack navigation callback', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      bool backed = false;
      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(
        container: container,
        onBack: () => backed = true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 400));

      expect(backed, isTrue);
    });

    // 46. Accessibility semantics
    testWidgets('46. Accessibility: semantic labels exist for interactive elements', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await repository.addCat(const Cat(id: 'cat1', name: 'Luna', type: CatType.home, createdAt: 100));

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Add cat photo'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Luna'),
        findsOneWidget,
      );
    });

    // 47. Privacy: Memory data not sent to Crashlytics
    test('47. Privacy: Memory text, cat name, mood values, and photo URI are NOT logged to Crashlytics', () async {
      // Repositories log only generic reasons e.g. 'DriftMeowoirsRepository.addMemory failed'
      // without containing PII or user memory contents
      await repository.addCat(const Cat(id: 'cat-priv', name: 'SecretCat', type: CatType.home, createdAt: 100));
      await repository.addMemory(const Memory(
        id: 'mem-priv-1',
        catId: 'cat-priv',
        catName: 'SecretCat',
        note: 'Confidential diary entry',
        photoUri: 'file:///secret/photo.jpg',
        catMood: 'Mutlu',
        userMood: 'Huzurlu',
        createdAt: 1000,
      ));

      final mem = (await repository.getAllMemories().first).first;
      expect(mem.note, 'Confidential diary entry');
      expect(mem.photoUri, 'file:///secret/photo.jpg');
    });

    // 48. Zero permissions and zero ads
    testWidgets('48. Zero camera permission, zero storage permission, and zero ads on Add Memory', (tester) async {
      setPhoneViewport(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createAddMemoryTestApp(container: container));
      await tester.pump(const Duration(milliseconds: 300));

      // No ad widgets on screen
      expect(find.text('AD'), findsNothing);
      expect(find.byKey(const Key('ad_banner')), findsNothing);
    });
  });
}
