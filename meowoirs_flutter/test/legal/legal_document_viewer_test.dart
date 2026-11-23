import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/localization/locale_resolver.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/features/legal/legal_document.dart';
import 'package:meowoirs/features/legal/legal_document_viewer.dart';

class FailingAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    throw Exception('Simulated asset failure');
  }
}

class SuccessfulAssetBundle extends Fake implements AssetBundle {
  SuccessfulAssetBundle(this.content);
  final String content;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return content;
  }
}

class RetryableAssetBundle extends Fake implements AssetBundle {
  int attempts = 0;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    attempts++;
    if (attempts == 1) {
      throw Exception('Initial failure');
    }
    return 'RETRY SUCCESSFUL TEXT';
  }
}

Widget createDirectViewerWidget({
  Locale locale = const Locale('tr'),
  required LegalDocument document,
  required AssetBundle bundle,
}) {
  return MaterialApp(
    locale: LocaleResolver.resolveLocale(locale.languageCode),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: MeowoirsTheme.lightTheme,
    home: DefaultAssetBundle(
      bundle: bundle,
      child: LegalDocumentViewerDialog(document: document),
    ),
  );
}

Widget createDialogViewerLauncher({
  Locale locale = const Locale('en'),
  required LegalDocument document,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: MeowoirsTheme.lightTheme,
    home: Builder(
      builder: (context) {
        return Scaffold(
          body: ElevatedButton(
            onPressed: () => LegalDocumentViewerDialog.show(context, document),
            child: const Text('Open Legal'),
          ),
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PHASE 16.5 — LEGAL VIEWER LOCALIZATION COMPREHENSIVE SUITE (TD-01 / TD-02)', () {
    // 1. Legal viewer renders
    testWidgets('1. Legal viewer renders successfully on show', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('tr'),
          document: LegalDocument.privacyPolicy,
          bundle: SuccessfulAssetBundle('SAMPLE PRIVACY POLICY'),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);
      expect(find.text('Gizlilik Politikası'), findsOneWidget);
    });

    // 2. Back tooltip uses localization (TR)
    testWidgets('2. Back button tooltip uses localized actionBack in Turkish ("Geri")', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('tr'),
          document: LegalDocument.privacyPolicy,
          bundle: SuccessfulAssetBundle('SAMPLE PRIVACY POLICY'),
        ),
      );
      await tester.pump();
      await tester.pump();

      final backButton = find.byTooltip('Geri');
      expect(backButton, findsOneWidget);
    });

    // 3. Back tooltip uses localization (EN)
    testWidgets('3. Back button tooltip uses localized actionBack in English ("Back")', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('en'),
          document: LegalDocument.privacyPolicy,
          bundle: SuccessfulAssetBundle('SAMPLE PRIVACY POLICY'),
        ),
      );
      await tester.pump();
      await tester.pump();

      final backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
    });

    // 4. Back button closes dialog
    testWidgets('4. Tapping back button pops and dismisses the dialog', (tester) async {
      await tester.pumpWidget(
        createDialogViewerLauncher(
          locale: const Locale('en'),
          document: LegalDocument.privacyPolicy,
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Open Legal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(LegalDocumentViewerDialog), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(LegalDocumentViewerDialog), findsNothing);
    });

    // 5. Error message uses localization (TR)
    testWidgets('5. Error state in Turkish displays localized legalDocumentLoadError and retry', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('tr'),
          document: LegalDocument.privacyPolicy,
          bundle: FailingAssetBundle(),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Belge yüklenirken bir hata oluştu.'), findsOneWidget);
      expect(find.text('Tekrar Dene'), findsOneWidget);
    });

    // 6. Error message uses localization (EN)
    testWidgets('6. Error state in English displays localized legalDocumentLoadError and retry', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('en'),
          document: LegalDocument.privacyPolicy,
          bundle: FailingAssetBundle(),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Could not load document.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    // 7. Unsupported locale (e.g. Swedish 'sv') falls back gracefully to English
    testWidgets('7. Error state in unsupported locale (sv) falls back gracefully to English bundle', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('sv'),
          document: LegalDocument.privacyPolicy,
          bundle: FailingAssetBundle(),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Could not load document.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
    });

    // 8. Bundled legal content renders via LegalTextRenderer when loaded successfully
    testWidgets('8. Bundled legal content renders via LegalTextRenderer when loaded successfully', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('tr'),
          document: LegalDocument.privacyPolicy,
          bundle: SuccessfulAssetBundle('PRIVACY POLICY LEGAL TEXT CONTENT'),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Content is rendered through LegalTextRenderer (inside SelectionArea)
      expect(find.byType(SelectionArea), findsOneWidget);
      expect(find.text('LIMANEX Studio Legal'), findsOneWidget);
      expect(find.text(LegalDocument.privacyPolicy.webUrl), findsOneWidget);
      // The title from the parser should be the first line
      expect(find.text('PRIVACY POLICY LEGAL TEXT CONTENT'), findsOneWidget);
    });

    // 9. Retry action triggers document reload
    testWidgets('9. Tapping retry button re-triggers document loading', (tester) async {
      final retryBundle = RetryableAssetBundle();

      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('tr'),
          document: LegalDocument.privacyPolicy,
          bundle: retryBundle,
        ),
      );
      await tester.pump();
      await tester.pump();

      // 1st attempt fails
      expect(find.text('Belge yüklenirken bir hata oluştu.'), findsOneWidget);
      expect(find.text('Tekrar Dene'), findsOneWidget);
      expect(retryBundle.attempts, equals(1));

      // Tap retry
      await tester.tap(find.text('Tekrar Dene'));
      await tester.pump();
      await tester.pump();

      // 2nd attempt succeeds
      expect(retryBundle.attempts, equals(2));
      expect(find.text('Belge yüklenirken bir hata oluştu.'), findsNothing);
      expect(find.text('RETRY SUCCESSFUL TEXT'), findsOneWidget);
    });

    // 10. Zero user-visible Turkish UI strings in English locale
    testWidgets('10. In English locale, zero user-visible Turkish UI strings exist in viewer', (tester) async {
      await tester.pumpWidget(
        createDirectViewerWidget(
          locale: const Locale('en'),
          document: LegalDocument.termsOfService,
          bundle: SuccessfulAssetBundle('TERMS OF SERVICE ENGLISH TEXT'),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Verify no hardcoded "Geri" tooltip
      expect(find.byTooltip('Geri'), findsNothing);
      expect(find.byTooltip('Back'), findsOneWidget);

      // Verify brand name remains
      expect(find.text('LIMANEX Studio Legal'), findsOneWidget);
    });
  });
}
