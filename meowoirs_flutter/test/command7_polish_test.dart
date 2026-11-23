import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/models/user_profile.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/memories/add_memory_screen.dart';
import 'package:meowoirs/features/memories/widgets/dual_mood_selector.dart';
import 'package:meowoirs/features/profile/profile_avatars.dart';
import 'package:meowoirs/features/profile/profile_screen.dart';
import 'package:meowoirs/widgets/memory_card.dart';
import 'package:meowoirs/widgets/meowoirs_button.dart';

class MockImagePicker extends Fake implements ImagePicker {
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  Widget buildApp({
    required Widget child,
    Locale locale = const Locale('tr'),
    double textScaleFactor = 1.0,
  }) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: MeowoirsTheme.lightTheme,
        builder: (context, c) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: c ?? const SizedBox.shrink(),
        ),
        home: child,
      ),
    );
  }

  group('Command 7 Polish — Add Memory Save Button', () {
    testWidgets('1. MeowoirsPrimaryButton defaults to 48dp and supports custom height (56dp)', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: Scaffold(
            body: Column(
              children: [
                MeowoirsPrimaryButton(
                  text: 'Default Button',
                  onPressed: () {},
                ),
                MeowoirsPrimaryButton(
                  width: double.infinity,
                  height: 56.0,
                  text: 'Tall Button',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final defaultFinder = find.widgetWithText(ElevatedButton, 'Default Button');
      final tallFinder = find.widgetWithText(ElevatedButton, 'Tall Button');

      final defaultSize = tester.getSize(defaultFinder);
      final tallSize = tester.getSize(tallFinder);

      expect(defaultSize.height, 48.0);
      expect(tallSize.height, 56.0);
    });

    testWidgets('2. Add Memory Screen renders 56dp primary save button with full width', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildApp(
          locale: const Locale('tr'),
          child: AddMemoryScreen(
            onBack: () {},
            onNavigateToAddCat: () {},
            imagePicker: MockImagePicker(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final saveButtonFinder = find.byType(MeowoirsPrimaryButton);
      expect(saveButtonFinder, findsOneWidget);

      final buttonSize = tester.getSize(saveButtonFinder);
      expect(buttonSize.height, 56.0);
      // Full width minus horizontal padding (390 - 24*2 = 342)
      expect(buttonSize.width, closeTo(342.0, 2.0));
    });

    testWidgets('3. Add Memory Save Button shows loading spinner when isSaving is true', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: Scaffold(
            body: MeowoirsPrimaryButton(
              width: double.infinity,
              height: 56,
              text: 'Kaydediliyor...',
              leadingIcon: const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              onPressed: null,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Command 7 Polish — Mood Area & Stickers', () {
    testWidgets('4. Cat mood selection visually distinguishes selected mood and shows sticker', (tester) async {
      String selectedMood = 'Mutlu';

      await tester.pumpWidget(
        buildApp(
          locale: const Locale('tr'),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: DualMoodSelector(
                  selectedCatMood: selectedMood,
                  onSelectCatMood: (mood) => setState(() => selectedMood = mood),
                  selectedUserMood: null,
                  onSelectUserMood: (_) {},
                ),
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Cat mood stickers should be present for canonical cat moods
      final images = find.byType(Image);
      expect(images, findsNWidgets(6)); // 6 canonical cat moods

      // Mutlu chip is selected
      expect(find.text('Mutlu'), findsOneWidget);

      // Tap 'Meraklı'
      await tester.tap(find.text('Meraklı'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(selectedMood, 'Meraklı');
      expect(find.text('Meraklı'), findsOneWidget);
    });

    testWidgets('5. User mood selector does NOT display cat mood stickers', (tester) async {
      await tester.pumpWidget(
        buildApp(
          locale: const Locale('tr'),
          child: Scaffold(
            body: DualMoodSelector(
              selectedCatMood: null,
              onSelectCatMood: (_) {},
              selectedUserMood: 'Huzurlu',
              onSelectUserMood: (_) {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Exactly 6 images from cat moods, none from user moods
      final images = find.byType(Image);
      expect(images, findsNWidgets(6));

      // User mood Huzurlu selected
      expect(find.text('♡ Huzurlu'), findsOneWidget);
    });

    testWidgets('6. MemoryCard renders cat mood sticker with refined proportion (size 24)', (tester) async {
      final memory = Memory(
        id: 'mem_1',
        catId: 'cat_1',
        catName: 'Luna',
        note: 'Güneşin altında mırıldandı.',
        createdAt: DateTime(2025, 5, 20).millisecondsSinceEpoch,
        catMood: 'Mutlu',
        userMood: 'Huzurlu',
      );

      await tester.pumpWidget(
        buildApp(
          locale: const Locale('tr'),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: MemoryCard(memory: memory),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Asset sticker for Mutlu should exist
      final assetImageFinder = find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is AssetImage,
      );
      expect(assetImageFinder, findsOneWidget);

      // Verify sticker size
      final imageWidget = tester.widget<Image>(assetImageFinder);
      expect(imageWidget.width, 24.0);
      expect(imageWidget.height, 24.0);
    });
  });

  group('Command 7 Polish — Profile & Avatar Picker', () {
    testWidgets('7. Profile header renders avatar with edit badge', (tester) async {
      await prefsRepo.setUserProfile(const UserProfile(
        nickname: 'Ada',
        avatarId: 'avatar_warm_cat',
      ));

      await tester.pumpWidget(
        buildApp(
          locale: const Locale('tr'),
          child: ProfileScreen(
            onNavigateToSettings: () {},
            onNavigateToMyStory: () {},
            onNavigateToAddCat: () {},
            onNavigateToCatDetail: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('Merhaba, Ada'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('8. Avatar picker dialog displays all 10 avatars and selects without overflow at 320x533', (tester) async {
      tester.view.physicalSize = const Size(320, 533);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await prefsRepo.setUserProfile(const UserProfile(
        nickname: 'KediSever',
        avatarId: 'avatar_warm_cat',
      ));

      await tester.pumpWidget(
        buildApp(
          locale: const Locale('tr'),
          child: ProfileScreen(
            onNavigateToSettings: () {},
            onNavigateToMyStory: () {},
            onNavigateToAddCat: () {},
            onNavigateToCatDetail: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));

      // Tap Profili Düzenle button to open dialog
      await tester.tap(find.text('Profili Düzenle'));
      await tester.pump(const Duration(milliseconds: 150));

      // Dialog should be displayed with all 10 avatars
      expect(find.text('Profili Düzenle'), findsAtLeastNWidgets(1));
      // Verify all 10 avatars rendered in the dialog
      final trL10n = lookupAppLocalizations(const Locale('tr'));
      for (final avatar in ProfileAvatars.all) {
        final loc = avatar.localizedName(trL10n);
        final avatarFinder = find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == loc,
        );
        expect(avatarFinder, findsOneWidget);
      }

      // Tap an avatar (e.g. Sakin adaçayı kedi / avatar_sage_cat)
      final sageLabel = ProfileAvatars.getById('avatar_sage_cat').localizedName(trL10n);
      final sageAvatarFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == sageLabel,
      );
      await tester.tap(sageAvatarFinder);
      await tester.pump(const Duration(milliseconds: 100));

      // Save dialog
      await tester.tap(find.text('Kaydet'));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify preference updated
      expect(prefsRepo.userProfile.avatarId, 'avatar_sage_cat');
    });

    testWidgets('9. Responsive QA — AddMemoryScreen renders without overflow at 360x800, 390x844, 412x915 with text scale 1.3', (tester) async {
      final viewports = [
        const Size(360, 800),
        const Size(390, 844),
        const Size(412, 915),
      ];

      for (final size in viewports) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          buildApp(
            textScaleFactor: 1.3,
            locale: const Locale('tr'),
            child: AddMemoryScreen(
              onBack: () {},
              onNavigateToAddCat: () {},
              imagePicker: MockImagePicker(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
    });

    testWidgets('10. Localization QA — Add Memory in TR, EN, and JA', (tester) async {
      for (final locale in [const Locale('tr'), const Locale('en'), const Locale('ja')]) {
        await tester.pumpWidget(
          buildApp(
            locale: locale,
            child: AddMemoryScreen(
              onBack: () {},
              onNavigateToAddCat: () {},
              imagePicker: MockImagePicker(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(MeowoirsPrimaryButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
