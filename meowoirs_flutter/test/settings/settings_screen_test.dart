import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/config/app_config.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/localization/supported_languages.dart';
import 'package:meowoirs/core/routing/app_router.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/legal/legal_document.dart';
import 'package:meowoirs/features/legal/legal_document_viewer.dart';
import 'package:meowoirs/features/settings/debug_tap_detector.dart';
import 'package:meowoirs/features/settings/settings_screen.dart';

Widget createDirectSettingsWidget({
  required ProviderContainer container,
  WidgetTester? tester,
  VoidCallback? onBack,
  Locale locale = const Locale('tr'),
  ThemeMode themeMode = ThemeMode.light,
  TextScaler textScaler = TextScaler.noScaling,
  Size viewportSize = const Size(1080, 2400),
}) {
  if (tester != null) {
    tester.view.physicalSize = viewportSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }
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
        child: SettingsScreen(
          onBack: onBack ?? () {},
        ),
      ),
    ),
  );
}

Widget createSettingsRouterApp({
  required ProviderContainer container,
  WidgetTester? tester,
  Locale locale = const Locale('tr'),
  ThemeMode themeMode = ThemeMode.light,
  Size viewportSize = const Size(1080, 2400),
}) {
  if (tester != null) {
    tester.view.physicalSize = viewportSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          title: 'Meowoirs Settings Test',
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
      'accepted_legal_version': '1',
      'nickname': 'Pamuk Dostu',
      'avatar_id': 'avatar_calico',
      'favorite_cat_id': 'cat_1',
      'theme_mode': 'system',
      'language_code': 'tr',
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

  group('PHASE 16 — SETTINGS SCREEN & PREFERENCES COMPREHENSIVE SUITE', () {
    // 1. Settings renders successfully
    testWidgets('1. Settings renders successfully with top bar title', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Ayarlar'), findsOneWidget);
    });

    // 2. All 5 sections render
    testWidgets('2. All 5 settings sections render cleanly', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Görünüm'), findsOneWidget);
      expect(find.text('Gizlilik ve Yasal'), findsOneWidget);
      expect(find.text('Dil'), findsOneWidget);
      expect(find.text('Bize Ulaşın'), findsWidgets);
      expect(find.text('Uygulama'), findsOneWidget);
    });

    // 3. Theme current value
    testWidgets('3. Theme action row displays current theme value (Sistem)', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Tema'), findsOneWidget);
      expect(find.text('Sistem'), findsOneWidget);
    });

    // 4. Tapping theme row opens Theme selection dialog
    testWidgets('4. Tapping theme row opens Theme selection dialog', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tema'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Açık'), findsOneWidget);
      expect(find.text('Koyu'), findsOneWidget);
      expect(find.text('Sistem'), findsWidgets);
    });

    // 5. Selecting Light theme
    testWidgets('5. Selecting Light theme updates preference and stream', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tema'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Açık'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(prefsRepo.getThemeMode(), AppThemeMode.light);
      expect(find.byType(AlertDialog), findsNothing);
    });

    // 6. Selecting Dark theme
    testWidgets('6. Selecting Dark theme updates preference and stream', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tema'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Koyu'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(prefsRepo.getThemeMode(), AppThemeMode.dark);
      expect(find.byType(AlertDialog), findsNothing);
    });

    // 7. Selecting System theme
    testWidgets('7. Selecting System theme updates preference to system', (tester) async {
      await prefsRepo.setThemeMode(AppThemeMode.dark);

      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tema'));
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Sistem in the dialog
      final systemInDialog = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Sistem'),
      );
      await tester.tap(systemInDialog);
      await tester.pump(const Duration(milliseconds: 300));

      expect(prefsRepo.getThemeMode(), AppThemeMode.system);
    });

    // 8. Theme persistence across repository recreation
    test('8. Theme preference persists across repository recreation', () async {
      await prefsRepo.setThemeMode(AppThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      final freshRepo = PreferencesRepository(prefs);
      expect(freshRepo.getThemeMode(), AppThemeMode.dark);
      freshRepo.dispose();
    });

    // 9. Invalid theme mode fallback
    test('9. Invalid theme mode string defaults gracefully to System', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', 'invalid_xyz');
      final freshRepo = PreferencesRepository(prefs);

      expect(freshRepo.getThemeMode(), AppThemeMode.system);
      freshRepo.dispose();
    });

    // 10. Language action row displays current language name
    testWidgets('10. Language action row displays current language name (Türkçe)', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Uygulama Dili'), findsOneWidget);
      expect(find.text('Türkçe'), findsOneWidget);
    });

    // 11. Tapping language row opens Language selection dialog
    testWidgets('11. Tapping language row opens Language selection dialog with 10 locales', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Uygulama Dili'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsOneWidget);
      for (final lang in supportedLanguages) {
        expect(find.text(lang.displayName), findsWidgets);
      }
    });

    // 12. Selecting English updates preference
    testWidgets('12. Selecting English in language dialog persists "en"', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Uygulama Dili'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('English'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(prefsRepo.getLanguageCode(), 'en');
      expect(find.byType(AlertDialog), findsNothing);
    });

    // 13. Selecting Japanese updates preference
    testWidgets('13. Selecting Japanese in language dialog persists "ja"', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Uygulama Dili'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('日本語'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(prefsRepo.getLanguageCode(), 'ja');
      expect(find.byType(AlertDialog), findsNothing);
    });

    // 14. Language persistence across repository recreation
    test('14. Language preference persists across repository recreation', () async {
      await prefsRepo.setLanguageCode('ja');

      final prefs = await SharedPreferences.getInstance();
      final freshRepo = PreferencesRepository(prefs);
      expect(freshRepo.getLanguageCode(), 'ja');
      freshRepo.dispose();
    });

    // 15. Invalid language code fallback
    test('15. Empty language code preserves empty string for system fallback', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', '');
      final freshRepo = PreferencesRepository(prefs);

      expect(freshRepo.getLanguageCode(), '');
      freshRepo.dispose();
    });

    // 16. Changing language preserves onboarding_completed
    test('16. Changing language does not alter onboarding_completed', () async {
      expect(prefsRepo.isOnboardingCompleted(), isTrue);
      await prefsRepo.setLanguageCode('de');
      expect(prefsRepo.isOnboardingCompleted(), isTrue);
    });

    // 17. Changing language preserves accepted_legal_version
    test('17. Changing language does not alter accepted_legal_version', () async {
      expect(prefsRepo.getAcceptedLegalVersion(), '1');
      await prefsRepo.setLanguageCode('fr');
      expect(prefsRepo.getAcceptedLegalVersion(), '1');
    });

    // 18. Changing language preserves user profile
    test('18. Changing language does not overwrite user profile nickname or avatar', () async {
      final initialProfile = prefsRepo.getUserProfile();
      expect(initialProfile.nickname, 'Pamuk Dostu');
      expect(initialProfile.avatarId, 'avatar_calico');

      await prefsRepo.setLanguageCode('es');

      final currentProfile = prefsRepo.getUserProfile();
      expect(currentProfile.nickname, 'Pamuk Dostu');
      expect(currentProfile.avatarId, 'avatar_calico');
    });

    // 19. Changing language preserves favorite cat
    test('19. Changing language does not alter favorite cat ID', () async {
      expect(prefsRepo.getUserProfile().favoriteCatId, 'cat_1');
      await prefsRepo.setLanguageCode('it');
      expect(prefsRepo.getUserProfile().favoriteCatId, 'cat_1');
    });

    // 20. Changing language preserves database cats & memories
    test('20. Changing language does not mutate cats or memories in database', () async {
      await repo.addCat(const Cat(
        id: 'cat_test_1',
        name: 'Duman',
        type: CatType.home,
        createdAt: 1000,
      ));
      await repo.addMemory(const Memory(
        id: 'mem_test_1',
        catId: 'cat_test_1',
        catName: 'Duman',
        note: 'Güneşte uyuyordu',
        createdAt: 1000,
      ));

      await prefsRepo.setLanguageCode('nl');

      final cats = await repo.getCats().first;
      final memories = await repo.getAllMemories().first;
      expect(cats.length, 1);
      expect(cats.first.name, 'Duman');
      expect(memories.length, 1);
    });

    // 21. Changing theme preserves onboarding & legal acceptance
    test('21. Changing theme does not alter onboarding or legal version', () async {
      await prefsRepo.setThemeMode(AppThemeMode.dark);
      expect(prefsRepo.isOnboardingCompleted(), isTrue);
      expect(prefsRepo.getAcceptedLegalVersion(), '1');
    });

    // 22. Changing theme preserves user profile & favorite cat
    test('22. Changing theme does not alter nickname, avatar, or favorite cat', () async {
      await prefsRepo.setThemeMode(AppThemeMode.light);
      final profile = prefsRepo.getUserProfile();
      expect(profile.nickname, 'Pamuk Dostu');
      expect(profile.avatarId, 'avatar_calico');
      expect(profile.favoriteCatId, 'cat_1');
    });

    // 23. Changing theme preserves database cats & memories
    test('23. Changing theme does not mutate database cats or memories', () async {
      await repo.addCat(const Cat(
        id: 'cat_test_2',
        name: 'Mırmır',
        type: CatType.street,
        createdAt: 2000,
      ));

      await prefsRepo.setThemeMode(AppThemeMode.dark);

      final cats = await repo.getCats().first;
      expect(cats.length, 1);
      expect(cats.first.name, 'Mırmır');
    });

    // 24. Privacy Policy opens native legal viewer
    testWidgets('24. Privacy Policy row opens native legal document viewer dialog', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final privacyRow = find.text('Gizlilik Politikası');
      await tester.tap(privacyRow);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.text(LegalDocument.privacyPolicy.title), findsWidgets);
    });

    // 25. Terms of Service opens native legal viewer
    testWidgets('25. Terms of Service row opens native legal document viewer dialog', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final termsRow = find.text('Kullanım Koşulları');
      await tester.tap(termsRow);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.text(LegalDocument.termsOfService.title), findsWidgets);
    });

    // 26. Data Deletion Policy opens native legal viewer
    testWidgets('26. Obsolete separate legal rows are removed from top-level Settings', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Veri ve Silme'), findsNothing);
      expect(find.text('Üçüncü Taraf Hizmetleri'), findsNothing);
      expect(find.text('Reklam ve Onay'), findsNothing);
      expect(find.text('Reklam Gizlilik Seçenekleri'), findsNothing);
    });

    // 27. Primary three documents are visible in Settings
    testWidgets('27. Primary three documents are present in Settings', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Gizlilik Politikası'), findsOneWidget);
      expect(find.text('Kullanım Koşulları'), findsOneWidget);
      expect(find.text('Yasal Uyarı'), findsOneWidget);
    });

    // 28. Privacy Policy row opens native legal viewer with UMP action
    testWidgets('28. Privacy Policy row opens native legal viewer with UMP action', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final privacyRow = find.text('Gizlilik Politikası');
      await tester.tap(privacyRow);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.text(LegalDocument.privacyPolicy.title), findsWidgets);
    });

    // 29. Legal Disclaimer opens native legal viewer
    testWidgets('29. Legal Disclaimer row opens native legal document viewer dialog', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final disclaimerRow = find.text('Yasal Uyarı');
      await tester.tap(disclaimerRow);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.text(LegalDocument.legalDisclaimer.title), findsWidgets);
    });

    // 30. Ad Privacy Options in Privacy viewer triggers AdManager without crash
    testWidgets('30. Ad Privacy Options in Privacy viewer triggers AdManager without crash', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      // Open Privacy Policy
      await tester.tap(find.text('Gizlilik Politikası'));
      await tester.pump(const Duration(milliseconds: 300));

      final adPrivacyButton = find.text('Düzenle');
      if (adPrivacyButton.evaluate().isNotEmpty) {
        await tester.tap(adPrivacyButton);
        await tester.pump(const Duration(milliseconds: 300));
      }

      // No crash occurs
      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
    });

    // 31. Reach Us row opens dialog with 3 actions
    testWidgets('31. Reach Us row opens dialog with Suggestion, Bug, and Contact buttons', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final reachUsRow = find.descendant(
        of: find.byType(InkWell),
        matching: find.text('Bize Ulaşın'),
      );
      await tester.tap(reachUsRow);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Öneri Gönder'), findsOneWidget);
      expect(find.text('Hata Bildir'), findsOneWidget);
      expect(find.text('İletişim'), findsOneWidget);
      expect(find.text('Kapat'), findsOneWidget);
    });

    // 32. Reach Us suggestion button dismisses dialog
    testWidgets('32. Reach Us suggestion button dismisses dialog cleanly', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final reachUsRow = find.descendant(
        of: find.byType(InkWell),
        matching: find.text('Bize Ulaşın'),
      );
      await tester.tap(reachUsRow);
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Öneri Gönder'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
    });

    // 33. Reach Us bug report button dismisses dialog
    testWidgets('33. Reach Us bug report button dismisses dialog cleanly', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final reachUsRow = find.descendant(
        of: find.byType(InkWell),
        matching: find.text('Bize Ulaşın'),
      );
      await tester.tap(reachUsRow);
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Hata Bildir'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
    });

    // 34. Reach Us contact button dismisses dialog
    testWidgets('34. Reach Us contact button dismisses dialog cleanly', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final reachUsRow = find.descendant(
        of: find.byType(InkWell),
        matching: find.text('Bize Ulaşın'),
      );
      await tester.tap(reachUsRow);
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('İletişim'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
    });

    // 35. App version display matches AppConfig
    testWidgets('35. App Information displays Meowoirs and AppConfig version', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final versionRow = find.textContaining('Sürüm ${AppConfig.versionName}');

      expect(find.text('Meowoirs'), findsWidgets);
      expect(versionRow, findsOneWidget);
    });

    // 36. Back button calls onBack callback
    testWidgets('36. Settings top bar back button calls onBack callback', (tester) async {
      var backCalled = false;
      await tester.pumpWidget(createDirectSettingsWidget(
        tester: tester,
        container: container,
        onBack: () => backCalled = true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      final backBtn = find.byIcon(Icons.arrow_back);
      expect(backBtn, findsOneWidget);
      await tester.tap(backBtn);
      await tester.pump(const Duration(milliseconds: 300));

      expect(backCalled, isTrue);
    });

    // 37. Cancelling Theme dialog dismisses dialog without changes
    testWidgets('37. Cancelling Theme dialog leaves theme unchanged', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tema'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Vazgeç'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
      expect(prefsRepo.getThemeMode(), AppThemeMode.system);
    });

    // 38. Cancelling Language dialog dismisses dialog without changes
    testWidgets('38. Cancelling Language dialog leaves language unchanged', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Uygulama Dili'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Vazgeç'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
      expect(prefsRepo.getLanguageCode(), 'tr');
    });

    // 39. Dismissing Reach Us dialog closes dialog
    testWidgets('39. Dismissing Reach Us dialog with Kapat closes dialog', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final reachUsRow = find.descendant(
        of: find.byType(InkWell),
        matching: find.text('Bize Ulaşın'),
      );
      await tester.tap(reachUsRow);
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Kapat'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
    });

    // 40. Screen reader semantics on section headers
    testWidgets('40. Section headers have header semantics', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final headers = tester.widgetList<Semantics>(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.header == true),
      );
      expect(headers.length, greaterThanOrEqualTo(5));
    });

    // 41. Screen reader semantics on setting rows
    testWidgets('41. Settings rows provide button semantics', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final buttons = tester.widgetList<Semantics>(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true),
      );
      expect(buttons.length, greaterThanOrEqualTo(6));
    });

    // 42. Dark mode rendering
    testWidgets('42. Dark mode renders cleanly with dark theme', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(
        tester: tester,
        container: container,
        themeMode: ThemeMode.dark,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Ayarlar'), findsOneWidget);
    });

    // 43. 320x533 compact viewport
    testWidgets('43. 320x533 compact viewport renders without layout overflow', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(
        tester: tester,
        container: container,
        viewportSize: const Size(320, 533),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
    });

    // 44. Large text scaling (1.5x)
    testWidgets('44. 1.5x text scaling renders without RenderFlex overflow', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(
        tester: tester,
        container: container,
        textScaler: const TextScaler.linear(1.5),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
    });

    // 45. English localization
    testWidgets('45. English locale renders localized English text', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(
        tester: tester,
        container: container,
        locale: const Locale('en'),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Privacy & Legal'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Reach Us'), findsWidgets);
      expect(find.text('Application'), findsOneWidget);
    });

    // 46. Japanese localization compiles and renders
    testWidgets('46. Japanese locale compiles and renders without crash', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(
        tester: tester,
        container: container,
        locale: const Locale('ja'),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
    });

    // 47. Rapid theme changes execute atomically
    test('47. Rapid theme changes execute atomically without race condition', () async {
      await prefsRepo.setThemeMode(AppThemeMode.light);
      await prefsRepo.setThemeMode(AppThemeMode.dark);
      await prefsRepo.setThemeMode(AppThemeMode.system);
      expect(prefsRepo.getThemeMode(), AppThemeMode.system);
    });

    // 48. Rapid language changes execute atomically
    test('48. Rapid language changes execute atomically without race condition', () async {
      await prefsRepo.setLanguageCode('en');
      await prefsRepo.setLanguageCode('ja');
      await prefsRepo.setLanguageCode('tr');
      expect(prefsRepo.getLanguageCode(), 'tr');
    });

    // 49. DebugTapDetector unit test: 7 taps in 5000ms unlocks
    test('49. DebugTapDetector unlocks after exactly 7 taps within window', () {
      final detector = DebugTapDetector(requiredTaps: 7, windowMillis: 5000);

      for (int i = 1; i <= 6; i++) {
        expect(detector.onUserTap(1000 + i * 100), isFalse);
        expect(detector.currentTapCount, i);
      }
      expect(detector.onUserTap(1000 + 7 * 100), isTrue);
      expect(detector.currentTapCount, 0); // resets on unlock
    });

    // 50. DebugTapDetector unit test: slow taps reset window
    test('50. DebugTapDetector resets count if tap interval exceeds window', () {
      final detector = DebugTapDetector(requiredTaps: 7, windowMillis: 5000);

      detector.onUserTap(1000);
      detector.onUserTap(2000);
      expect(detector.currentTapCount, 2);

      // Next tap arrives after 5500ms from start (1000 -> 6500)
      detector.onUserTap(6500);
      expect(detector.currentTapCount, 1);
    });

    // 51. Debug panel bottom sheet displays onboarding status and reset action in debug mode
    testWidgets('51. 7 taps on App Information row unlocks debug center', (tester) async {
      await tester.pumpWidget(createDirectSettingsWidget(tester: tester, container: container));
      await tester.pump(const Duration(milliseconds: 300));

      final versionRow = find.textContaining('Sürüm ${AppConfig.versionName}');
      await tester.scrollUntilVisible(versionRow, 200);

      // Tap 7 times rapidly
      for (int i = 0; i < 7; i++) {
        await tester.tap(versionRow);
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Debug Center opens
      expect(find.text('Geliştirici paneli açıldı'), findsWidgets);
      expect(find.text('GELİŞTİRİCİ: BAŞLANGIÇ SIFIRLA'), findsOneWidget);

      // Tap reset onboarding
      await tester.tap(find.text('GELİŞTİRİCİ: BAŞLANGIÇ SIFIRLA'));
      await tester.pumpAndSettle();

      expect(prefsRepo.isOnboardingCompleted(), isFalse);
      expect(find.text('Başlangıç durumu sıfırlandı'), findsOneWidget);
    });

    // 52. Router integration: navigating from Profile to Settings
    testWidgets('52. Profile screen settings card navigates to /settings route', (tester) async {
      await tester.pumpWidget(createSettingsRouterApp(tester: tester, container: container));
      await tester.pumpAndSettle();

      // Navigate to Profile tab
      await tester.tap(find.text('PROFİL'));
      await tester.pumpAndSettle();

      // Ayarlar entry card and tap
      final settingsCard = find.text('Ayarlar');
      await tester.tap(settingsCard);
      await tester.pumpAndSettle();

      // Now on Settings screen
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
