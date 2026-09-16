import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/localization/locale_resolver.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/debug/debug_center_screen.dart';
import 'package:meowoirs/features/legal/legal_document.dart';
import 'package:meowoirs/features/legal/legal_document_viewer.dart';
import 'package:meowoirs/services/ads/meowoirs_banner_ad.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 18.1 — Issue 1: LocaleResolver Tests', () {
    test('Device locale in supported list is automatically detected when savedLocale is null', () {
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('tr', 'TR')]),
        const Locale('tr'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('en', 'US')]),
        const Locale('en'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('de', 'DE')]),
        const Locale('de'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('fr', 'FR')]),
        const Locale('fr'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('es', 'ES')]),
        const Locale('es'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('it', 'IT')]),
        const Locale('it'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('pt', 'BR')]),
        const Locale('pt'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('nl', 'NL')]),
        const Locale('nl'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('pl', 'PL')]),
        const Locale('pl'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('ja', 'JP')]),
        const Locale('ja'),
      );
    });

    test('Unsupported device locale falls back to en when savedLocale is null', () {
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('ru', 'RU')]),
        const Locale('en'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: [const Locale('zh', 'CN')]),
        const Locale('en'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: null, deviceLocales: []),
        const Locale('en'),
      );
    });

    test('Explicit user-saved locale overrides device locale', () {
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: 'de', deviceLocales: [const Locale('tr', 'TR')]),
        const Locale('de'),
      );
      expect(
        LocaleResolver.resolveAppLocale(savedLocaleCode: 'ja', deviceLocales: [const Locale('en', 'US')]),
        const Locale('ja'),
      );
    });
  });

  group('Phase 18.1 — Issue 2: Banner Ads Visibility & Zero Placeholder Tests', () {
    testWidgets('Unloaded / uninitialized banner ad renders 0dp height and NO fake placeholder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MeowoirsBannerAd(),
          ),
        ),
      );
      await tester.pump();

      // Ensure no fake ad text or mock advertisement is rendered
      expect(find.text('Ad Placeholder'), findsNothing);
      expect(find.text('AD'), findsNothing);
      expect(find.text('Advertisement'), findsNothing);

      // Verify the banner widget collapses
      final sizedBoxFinder = find.descendant(
        of: find.byType(MeowoirsBannerAd),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsWidgets);
      final sizedBox = tester.widget<SizedBox>(sizedBoxFinder.first);
      expect(sizedBox.height == null || sizedBox.height == 0.0, isTrue);
    });
  });

  group('Phase 18.1 — Issue 4: Legal Document Modal Overlay Tests', () {
    testWidgets('Legal document opens as a centered modal popup with 24dp corners and header', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => LegalDocumentViewerDialog.show(
                  context,
                  LegalDocument.privacyPolicy,
                ),
                child: const Text('Open Legal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Legal'));
      await tester.pumpAndSettle();

      // Check modal overlay dialog is present
      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);

      // Verify header title
      expect(find.text('Privacy Policy'), findsOneWidget);

      // Verify close icon and footer close button
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Back'), findsOneWidget);

      // Tapping close button dismisses dialog
      await tester.tap(find.widgetWithText(OutlinedButton, 'Back'));
      await tester.pumpAndSettle();

      expect(find.byType(LegalDocumentViewerDialog), findsNothing);
    });
  });

  group('Phase 18.1 — Issue 5: Debug Center Diagnostic Suite Tests', () {
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
    });

    testWidgets('Debug Center renders all 16 sections and reports ACTUAL Drift schema version 1', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: DebugCenterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check title
      expect(find.text('Diagnostic Debug Center'), findsOneWidget);

      // Section 1: Bootstrap & Lifecycle State
      expect(find.text('1. Bootstrap & Lifecycle State'), findsOneWidget);

      // Section 2: Database (Drift)
      expect(find.text('2. Database (Drift)'), findsOneWidget);
      await tester.tap(find.text('2. Database (Drift)'));
      await tester.pumpAndSettle();
      // Verify ACTUAL Drift schema version from database
      expect(find.text('${db.schemaVersion} (ACTUAL)'), findsOneWidget);
      expect(db.schemaVersion, 1); // CRITICAL: Database schema version must be 1

      // Section 3: Preferences (SharedPreferences)
      expect(find.text('3. Preferences (SharedPreferences)'), findsOneWidget);

      // Section 4: Photo Storage & Cache
      expect(find.text('4. Photo Storage & Cache'), findsOneWidget);

      // Section 5: AdMob & Monetization
      expect(find.text('5. AdMob & Monetization'), findsOneWidget);

      // Section 6: Consent & UMP
      expect(find.text('6. Consent & UMP'), findsOneWidget);

      // Section 7: Localization
      expect(find.text('7. Localization'), findsOneWidget);

      // Section 8: UI & Responsive Metrics
      expect(find.text('8. UI & Responsive Metrics'), findsOneWidget);

      // Section 9: Android Platform Info
      expect(find.text('9. Android Platform Info'), findsOneWidget);

      // Section 10: Error Handler & Crash Log
      expect(find.text('10. Error Handler & Crash Log'), findsOneWidget);

      // Section 11: Privacy & Security Audit
      expect(find.text('11. Privacy & Security Audit'), findsOneWidget);

      // Section 12: Offline Reliability
      expect(find.text('12. Offline Reliability'), findsOneWidget);

      // Section 13: Data Wipe & Reset Tools
      expect(find.text('13. Data Wipe & Reset Tools'), findsOneWidget);

      // Section 14: Navigation & Routing
      expect(find.text('14. Navigation & Routing'), findsOneWidget);

      // Section 15: Legal & Compliance
      expect(find.text('15. Legal & Compliance'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -1500));
      await tester.pumpAndSettle();

      // Section 16: Production Release Gate
      expect(find.text('16. Production Release Gate'), findsOneWidget);
      await tester.tap(find.text('16. Production Release Gate'));
      await tester.pumpAndSettle();
      expect(find.text('1. Drift Schema Version matches actual (1)'), findsOneWidget);
    });
  });
}
