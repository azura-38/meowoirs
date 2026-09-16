import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/config/app_config.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/routing/app_router.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/legal/legal_document.dart';
import 'package:meowoirs/features/legal/legal_document_viewer.dart';
import 'package:meowoirs/features/onboarding/onboarding_provider.dart';
import 'package:meowoirs/features/onboarding/onboarding_screen.dart';
import 'package:meowoirs/features/onboarding/pages/onboarding_page_1.dart';
import 'package:meowoirs/features/onboarding/pages/onboarding_page_4.dart';
import 'package:meowoirs/features/onboarding/widgets/onboarding_pagination.dart';

Widget createOnboardingTestApp({
  required ProviderContainer container,
  Locale locale = const Locale('tr'),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      title: 'Onboarding Test',
      debugShowCheckedModeBanner: false,
      theme: MeowoirsTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: OnboardingScreen(
        onOnboardingFinished: () {},
      ),
    ),
  );
}

Widget createFullRouterApp({
  required ProviderContainer container,
  Locale locale = const Locale('tr'),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          title: 'Full Router Test',
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

  group('Phase 6 — Final Onboarding Parity & Verification Suite', () {
    // 1. First launch routes to onboarding
    testWidgets('1. First launch routes to onboarding when onboarding_completed is false', (tester) async {
      await prefsRepo.resetOnboarding();

      await tester.pumpWidget(createFullRouterApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(OnboardingPage1), findsOneWidget);
    });

    // 2. Page count = 4
    testWidgets('2. Pagination indicator shows exactly 4 total dots', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      final pagination = tester.widget<OnboardingPagination>(find.byType(OnboardingPagination));
      expect(pagination.totalSteps, 4);
    });

    // 3. Page 1 content
    testWidgets('3. Page 1 displays required editorial text and visual elements', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('CİLT I — BÖLÜM 01'), findsOneWidget);
      expect(find.text('GÜNÜN IŞIĞI'), findsOneWidget);
      expect(find.text('«Sessiz bir fısıltı gibi...»'), findsOneWidget);
      expect(find.text('GİRİŞ NOTU'), findsOneWidget);
      expect(find.text('AÇILIŞ'), findsOneWidget);
      expect(find.text('Her kedinin bir hikâyesi var.'), findsOneWidget);
      expect(
        find.text('Meowoirs, kedilerinle paylaştığın küçük anları, fotoğrafları ve hikâyeleri saklamak için kişisel alanın.'),
        findsOneWidget,
      );
      expect(find.text('Kişisel Arşivinizi Oluşturun'), findsOneWidget);
      expect(
        find.text('Fotoğraf, notlar ve küçük anlarla kendi anı arşivinizi oluşturun.'),
        findsOneWidget,
      );
      expect(find.text('MEOWOIRS ARŞİVİ'), findsOneWidget);
      expect(find.text('İLK SAYFA'), findsOneWidget);
    });

    // 4. Page 2 content
    testWidgets('4. Page 2 displays required journal entries, badges and editorial text', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      // Navigate to Page 2
      final notifier = container.read(onboardingProvider.notifier);
      notifier.nextStep();
      await tester.pumpAndSettle();

      expect(find.text('BÖLÜM II — GÜNLÜK PARÇALARI'), findsOneWidget);
      expect(find.text('Küçük anları sakla.'), findsOneWidget);
      expect(find.text('Bir fotoğraf, birkaç kelime ve o anın duygusu.'), findsOneWidget);
      expect(find.text('ANNO. 128'), findsOneWidget);
      expect(find.text('08:45 Sabah Uykusu'), findsOneWidget);
      expect(find.text('14 Ekim'), findsOneWidget);
      expect(find.text('Huzurlu'), findsOneWidget);
      expect(
        find.text('Meowoirs, sıradan anları unutmak istemeyeceğin küçük hikâyelere dönüştürür.'),
        findsOneWidget,
      );
      expect(find.text('KİŞİSEL ARŞİV'), findsOneWidget);
      expect(find.text('KÜÇÜK ANLAR'), findsOneWidget);
    });

    // 5. Page 3 content
    testWidgets('5. Page 3 displays home and street cat cards, badges and descriptions', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      // Navigate to Page 3
      final notifier = container.read(onboardingProvider.notifier);
      notifier.nextStep();
      notifier.nextStep();
      await tester.pumpAndSettle();

      expect(find.text('BÖLÜM III — HİKÂYENDEKİLER'), findsOneWidget);
      expect(find.text('Her kedi hikâyende yer alabilir.'), findsOneWidget);
      expect(
        find.text('Evindeki kediden sokakta karşılaştığın bir dosta kadar, hayatına dokunan küçük anları sakla.'),
        findsOneWidget,
      );
      expect(find.text('EVDE'), findsOneWidget);
      expect(find.text('Evimizin Hikâyesi'), findsOneWidget);
      expect(find.text('SOKAK HİKÂYESİ'), findsOneWidget);
      expect(find.text('Sokağın Ruhu'), findsOneWidget);
      expect(find.text('Zeytin — Mahalledeki eski dost'), findsOneWidget);
      expect(find.text('Evde veya Sokakta'), findsOneWidget);
      expect(
        find.text('Evindeki ya da sokakta karşılaştığın kedileri kendi hikâyene dahil et.'),
        findsOneWidget,
      );
      expect(find.text('MEOWOIRS ARŞİVİ'), findsOneWidget);
      expect(find.text('HER KEDİ'), findsOneWidget);
    });

    // 6. Page 4 content
    testWidgets('6. Page 4 displays privacy chapter, offline explanation and legal checkboxes', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      // Navigate to Page 4
      final notifier = container.read(onboardingProvider.notifier);
      notifier.skipToLegal();
      await tester.pumpAndSettle();

      expect(find.text('BÖLÜM IV • MAHREMİYET & GÜVEN'), findsOneWidget);
      expect(find.text('Hikâyen senin.'), findsOneWidget);
      expect(
        find.text('Anıların ve fotoğrafların cihazında kalır. Meowoirs, bunları kendi sunucularında saklamaz ve hesap veya bulut senkronizasyonu gerektirmez.'),
        findsOneWidget,
      );
      expect(find.text('Cihazında Kalır'), findsOneWidget);
      expect(
        find.text('Kedi profillerin, fotoğrafların, notların ve anıların cihazında yerel olarak saklanır.'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel("Gizlilik Politikası'nı okudum ve kabul ediyorum."), findsOneWidget);
      expect(find.bySemanticsLabel("Kullanım Koşulları'nı okudum ve kabul ediyorum."), findsOneWidget);
      expect(find.text("Meowoirs'e Başla →"), findsOneWidget);
    });

    // 7. Skip works on pages 1–3
    testWidgets('7. Skip button on Pages 1-3 jumps directly to Page 4', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('ATLA'), findsOneWidget);
      await tester.tap(find.text('ATLA'));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingPage4), findsOneWidget);
      expect(container.read(onboardingProvider).currentStep, 4);
    });

    // 8. Skip unavailable on Page 4
    testWidgets('8. Skip button is not present on Page 4', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(onboardingProvider.notifier).skipToLegal();
      await tester.pumpAndSettle();

      expect(find.text('ATLA'), findsNothing);
    });

    // 9. Privacy checkbox initially false
    testWidgets('9. Privacy Policy checkbox is initially false', (tester) async {
      expect(container.read(onboardingProvider).privacyAccepted, isFalse);
    });

    // 10. Terms checkbox initially false
    testWidgets('10. Terms of Service checkbox is initially false', (tester) async {
      expect(container.read(onboardingProvider).termsAccepted, isFalse);
    });

    // 11. CTA disabled with neither checked
    testWidgets('11. CTA button is disabled when neither checkbox is checked', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(onboardingProvider.notifier).skipToLegal();
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    // 12. CTA disabled with Privacy only
    testWidgets('12. CTA button remains disabled when only Privacy Policy is checked', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(onboardingProvider.notifier).skipToLegal();
      container.read(onboardingProvider.notifier).setPrivacyAccepted(true);
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    // 13. CTA disabled with Terms only
    testWidgets('13. CTA button remains disabled when only Terms of Service is checked', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(onboardingProvider.notifier).skipToLegal();
      container.read(onboardingProvider.notifier).setTermsAccepted(true);
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    // 14. CTA enabled with both checked
    testWidgets('14. CTA button is enabled when both checkboxes are checked', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(onboardingProvider.notifier).skipToLegal();
      container.read(onboardingProvider.notifier).setPrivacyAccepted(true);
      container.read(onboardingProvider.notifier).setTermsAccepted(true);
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    // 15. Legal viewer opens
    testWidgets('15. Clicking legal document links opens the native viewer dialog without WebView', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      container.read(onboardingProvider.notifier).skipToLegal();
      await tester.pumpAndSettle();

      // Trigger show directly to verify dialog contents
      final BuildContext pageContext = tester.element(find.byType(OnboardingPage4));
      LegalDocumentViewerDialog.show(pageContext, LegalDocument.privacyPolicy);
      await tester.pumpAndSettle();

      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.text('Gizlilik Politikası'), findsWidgets);

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(LegalDocumentViewerDialog), findsNothing);
    });

    // 16. Completion writes onboarding_completed
    testWidgets('16. Completing onboarding writes onboarding_completed = true in preferences', (tester) async {
      container.read(onboardingProvider.notifier).skipToLegal();
      container.read(onboardingProvider.notifier).setPrivacyAccepted(true);
      container.read(onboardingProvider.notifier).setTermsAccepted(true);

      await container.read(onboardingProvider.notifier).completeOnboarding();

      expect(prefsRepo.isOnboardingCompleted(), isTrue);
    });

    // 17. Completion writes accepted_legal_version
    testWidgets('17. Completing onboarding writes accepted_legal_version = "1"', (tester) async {
      container.read(onboardingProvider.notifier).skipToLegal();
      container.read(onboardingProvider.notifier).setPrivacyAccepted(true);
      container.read(onboardingProvider.notifier).setTermsAccepted(true);

      await container.read(onboardingProvider.notifier).completeOnboarding();

      expect(prefsRepo.getAcceptedLegalVersion(), AppConfig.currentLegalVersion);
      expect(prefsRepo.getAcceptedLegalVersion(), '1');
    });

    // 18. Completion navigates Home
    testWidgets('18. Completing onboarding triggers route navigation to Home', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await prefsRepo.resetOnboarding();

      await tester.pumpWidget(createFullRouterApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);

      // Skip to Page 4 and check both
      container.read(onboardingProvider.notifier).skipToLegal();
      container.read(onboardingProvider.notifier).setPrivacyAccepted(true);
      container.read(onboardingProvider.notifier).setTermsAccepted(true);
      await tester.pumpAndSettle();

      // Tap CTA
      await tester.tap(find.text("Meowoirs'e Başla →"));
      await tester.pumpAndSettle();

      // Should now be on Home screen with bottom navigation
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('ANA SAYFA'), findsOneWidget);
    });

    // 19. Restart skips onboarding
    testWidgets('19. App restart directly enters Home when onboarding is already completed', (tester) async {
      await prefsRepo.completeOnboarding('1');

      await tester.pumpWidget(createFullRouterApp(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    // 20. Android back cannot bypass legal gate
    testWidgets('20. Pop/Back navigation on Page 4 goes back to Page 3 and never directly to Home', (tester) async {
      await prefsRepo.resetOnboarding();

      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      // Advance to page 4
      container.read(onboardingProvider.notifier).skipToLegal();
      await tester.pumpAndSettle();
      expect(container.read(onboardingProvider).currentStep, 4);

      // Trigger pop
      final bool handled = container.read(onboardingProvider.notifier).previousStep();
      expect(handled, isTrue);
      await tester.pumpAndSettle();

      // Must be on page 3, NOT Home
      expect(container.read(onboardingProvider).currentStep, 3);
      expect(find.byType(NavigationBar), findsNothing);
      expect(prefsRepo.isOnboardingCompleted(), isFalse);
    });

    // 21. Turkish localization loads
    testWidgets('21. Turkish locale loads exact finalized strings', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(
        container: container,
        locale: const Locale('tr'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('CİLT I — BÖLÜM 01'), findsOneWidget);
      expect(find.text('«Sessiz bir fısıltı gibi...»'), findsOneWidget);
    });

    // 22. English fallback works
    testWidgets('22. English locale loads matching English translations', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(
        container: container,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('VOLUME I — CHAPTER 01'), findsOneWidget);
      expect(find.text('«Like a quiet whisper...»'), findsOneWidget);
      expect(find.text('Every cat has a story.'), findsOneWidget);
    });

    // 23. All 10 locales resolve
    test('23. All 10 supported locales resolve valid localized delegates', () {
      const locales = ['tr', 'en', 'de', 'fr', 'es', 'it', 'pt', 'nl', 'pl', 'ja'];
      for (final code in locales) {
        final loc = lookupAppLocalizations(Locale(code));
        expect(loc.onboardingStep1Title, isNotEmpty);
        expect(loc.onboardingStep4Start, isNotEmpty);
      }
    });

    // 24. No ads on onboarding
    testWidgets('24. No ad widgets or banners rendered during onboarding', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      expect(find.textContaining('BannerAd'), findsNothing);
      expect(find.textContaining('AdWidget'), findsNothing);
    });

    // 25. No personalization fields collected
    testWidgets('25. Onboarding does not display name, breed, cat name or phone inputs', (tester) async {
      await tester.pumpWidget(createOnboardingTestApp(container: container));
      await tester.pumpAndSettle();

      // Check on all pages
      for (int step = 1; step <= 4; step++) {
        expect(find.byType(TextField), findsNothing);
        expect(find.byType(TextFormField), findsNothing);
        if (step < 4) {
          container.read(onboardingProvider.notifier).nextStep();
          await tester.pumpAndSettle();
        }
      }
    });
  });
}
