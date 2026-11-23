import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/core/theme/meowoirs_theme.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/features/debug/debug_center_screen.dart';
import 'package:meowoirs/services/ads/ad_config.dart';
import 'package:meowoirs/services/ads/ad_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeInitializationStatus implements InitializationStatus {
  @override
  Map<String, AdapterStatus> get adapterStatuses => const {};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final adManager = AdManager.instance;

  setUp(() {
    adManager.resetForTesting();
  });

  tearDown(() {
    adManager.resetForTesting();
  });

  group('Closed Testing AdMob Initialization & Diagnostics Suite', () {
    // 1. canRequestAds == true with UMP status unknown
    test('1. Initializes Mobile Ads SDK when canRequestAds == true even if UMP status is unknown', () async {
      int initCallCount = 0;
      int bannerLoadCount = 0;
      int interstitialLoadCount = 0;

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        consentStatusFetcher: () async => ConsentStatus.unknown,
        privacyOptionsStatusFetcher: () async =>
            PrivacyOptionsRequirementStatus.unknown,
        requestConsentInfoUpdateRunner: (params, onSuccess, onFailure) {
          // Simulate UMP update failure or unknown status in Closed Testing
          onFailure(
            FormError(
              errorCode: 1,
              message: 'No UMP form configured for Closed Testing',
            ),
          );
        },
        mobileAdsInitializer: () async {
          initCallCount++;
          return _FakeInitializationStatus();
        },
        bannerLoadExecutor: () {
          bannerLoadCount++;
          adManager.completeBannerLoadForTesting(success: true);
        },
        interstitialLoadExecutor: () {
          interstitialLoadCount++;
          adManager.completeInterstitialLoadForTesting(success: true);
        },
      );

      // UI requests banner before consent/init completes
      adManager.preloadBanner();
      expect(adManager.bannerRequested, isTrue);
      expect(adManager.bannerNetworkRequestSent, isFalse);
      expect(adManager.bannerState, BannerState.idle);

      await adManager.requestConsentAndInitialize();

      expect(adManager.umpConsentStatus, ConsentStatus.unknown);
      expect(adManager.canRequestAds, isTrue);
      expect(adManager.isMobileAdsInitialized, isTrue);
      expect(adManager.initializationState, AdInitializationState.initialized);
      expect(initCallCount, 1);
      expect(bannerLoadCount, 1);
      expect(adManager.bannerNetworkRequestSent, isTrue);
      expect(adManager.bannerState, BannerState.loaded);
      expect(interstitialLoadCount, 1);
      expect(adManager.interstitialState, InterstitialLoadState.loaded);
    });

    // 2. canRequestAds == false
    test('2. Does NOT initialize SDK or request ads when canRequestAds == false', () async {
      int initCallCount = 0;
      int bannerLoadCount = 0;
      int interstitialLoadCount = 0;

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => false,
        consentStatusFetcher: () async => ConsentStatus.required,
        privacyOptionsStatusFetcher: () async =>
            PrivacyOptionsRequirementStatus.required,
        requestConsentInfoUpdateRunner: (params, onSuccess, onFailure) {
          onSuccess();
        },
        loadAndShowConsentFormRunner: (onDismissed) async {
          onDismissed(null);
        },
        mobileAdsInitializer: () async {
          initCallCount++;
          return _FakeInitializationStatus();
        },
        bannerLoadExecutor: () {
          bannerLoadCount++;
        },
        interstitialLoadExecutor: () {
          interstitialLoadCount++;
        },
      );

      adManager.preloadBanner();
      await adManager.requestConsentAndInitialize();

      expect(adManager.canRequestAds, isFalse);
      expect(adManager.isMobileAdsInitialized, isFalse);
      expect(
        adManager.initializationState,
        AdInitializationState.waitingForConsent,
      );
      expect(initCallCount, 0);
      expect(bannerLoadCount, 0);
      expect(adManager.bannerRequested, isTrue);
      expect(adManager.bannerNetworkRequestSent, isFalse);
      expect(interstitialLoadCount, 0);
    });

    // 3. Successful SDK initialization state transitions
    test('3. Successful SDK initialization transitions NOT_STARTED -> INITIALIZING -> INITIALIZED', () async {
      final observedStates = <AdInitializationState>[
        adManager.initializationState,
      ];
      void listener() {
        final s = adManager.initializationStateNotifier.value;
        if (observedStates.isEmpty || observedStates.last != s) {
          observedStates.add(s);
        }
      }

      adManager.initializationStateNotifier.addListener(listener);
      addTearDown(
        () => adManager.initializationStateNotifier.removeListener(listener),
      );

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        mobileAdsInitializer: () async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return _FakeInitializationStatus();
        },
        interstitialLoadExecutor: () {},
      );

      await adManager.initialize();

      expect(
        observedStates,
        equals([
          AdInitializationState.notStarted,
          AdInitializationState.initializing,
          AdInitializationState.initialized,
        ]),
      );
      expect(adManager.isMobileAdsInitialized, isTrue);
      expect(adManager.lastInitializationError, isNull);
    });

    // 4. SDK initialization failure
    test('4. SDK initialization failure captures technical error and sets INITIALIZATION_FAILED', () async {
      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        initRetryDelays: const [], // disable retry for isolated failure test
        mobileAdsInitializer: () async {
          throw StateError('GMS Ads module failed to bind');
        },
      );

      await adManager.initialize();

      expect(adManager.isMobileAdsInitialized, isFalse);
      expect(
        adManager.initializationState,
        AdInitializationState.initializationFailed,
      );
      expect(adManager.lastInitializationError, isNotNull);
      expect(
        adManager.lastInitializationError,
        contains('GMS Ads module failed to bind'),
      );
    });

    // 5. Controlled retry
    test('5. Controlled retry automatically recovers from initialization failure', () async {
      int attempts = 0;
      int bannerLoads = 0;

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        initRetryDelays: const [30, 60],
        mobileAdsInitializer: () async {
          attempts++;
          if (attempts == 1) {
            throw Exception('Transient native initialization timeout');
          }
          return _FakeInitializationStatus();
        },
        bannerLoadExecutor: () {
          bannerLoads++;
          adManager.completeBannerLoadForTesting(success: true);
        },
        interstitialLoadExecutor: () {
          adManager.completeInterstitialLoadForTesting(success: true);
        },
      );

      adManager.preloadBanner();
      await adManager.initialize();

      // Immediately after first attempt fails:
      expect(attempts, 1);
      expect(adManager.isMobileAdsInitialized, isFalse);
      expect(
        adManager.initializationState,
        AdInitializationState.initializationFailed,
      );
      expect(adManager.initRetryAttempt, 1);
      expect(adManager.lastInitializationError, contains('Transient native'));

      // Wait for controlled retry timer (30ms) to execute and complete:
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(attempts, 2);
      expect(adManager.isMobileAdsInitialized, isTrue);
      expect(adManager.initializationState, AdInitializationState.initialized);
      expect(adManager.lastInitializationError, isNull);
      expect(adManager.initRetryAttempt, 0);
      expect(bannerLoads, 1);
      expect(adManager.bannerState, BannerState.loaded);
    });

    // 6. Multiple initialization calls without duplicate initialization
    test('6. Multiple concurrent and sequential initialize() calls invoke MobileAds.initialize only once', () async {
      int sdkInitCalls = 0;
      final initCompleter = Completer<InitializationStatus>();

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        mobileAdsInitializer: () {
          sdkInitCalls++;
          return initCompleter.future;
        },
        interstitialLoadExecutor: () {},
      );

      // Fire 3 concurrent calls while initialization is in-flight
      final f1 = adManager.initialize();
      final f2 = adManager.initialize();
      final f3 = adManager.initialize();

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(sdkInitCalls, 1);
      expect(adManager.initializationState, AdInitializationState.initializing);

      initCompleter.complete(_FakeInitializationStatus());
      await Future.wait([f1, f2, f3]);

      // Fire another call after initialization is already complete
      await adManager.initialize();

      expect(sdkInitCalls, 1);
      expect(adManager.isMobileAdsInitialized, isTrue);
      expect(adManager.initializationState, AdInitializationState.initialized);
    });

    // 7. Banner loading after successful SDK initialization
    test('7. Pending banner request deferred before init is automatically loaded once SDK initializes', () async {
      int bannerLoads = 0;

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => false,
        mobileAdsInitializer: () async => _FakeInitializationStatus(),
        bannerLoadExecutor: () {
          bannerLoads++;
          adManager.completeBannerLoadForTesting(success: true);
        },
        interstitialLoadExecutor: () {},
      );

      // Step A: UI requests banner before consent/init
      adManager.preloadBanner();
      expect(adManager.bannerRequested, isTrue);
      expect(adManager.bannerNetworkRequestSent, isFalse);
      expect(adManager.bannerState, BannerState.idle);
      expect(bannerLoads, 0);

      // Step B: Consent granted & SDK initializes
      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        mobileAdsInitializer: () async => _FakeInitializationStatus(),
        bannerLoadExecutor: () {
          bannerLoads++;
          adManager.completeBannerLoadForTesting(success: true);
        },
        interstitialLoadExecutor: () {},
      );

      await adManager.initialize();

      expect(adManager.isMobileAdsInitialized, isTrue);
      expect(bannerLoads, 1);
      expect(adManager.bannerNetworkRequestSent, isTrue);
      expect(adManager.bannerState, BannerState.loaded);
    });

    // 8. Interstitial loading after successful SDK initialization
    test('8. Interstitial is automatically preloaded after successful SDK initialization', () async {
      int interstitialLoads = 0;

      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        mobileAdsInitializer: () async => _FakeInitializationStatus(),
        interstitialLoadExecutor: () {
          interstitialLoads++;
          adManager.completeInterstitialLoadForTesting(success: true);
        },
      );

      expect(adManager.interstitialState, InterstitialLoadState.notLoaded);
      await adManager.initialize();

      expect(interstitialLoads, 1);
      expect(adManager.interstitialState, InterstitialLoadState.loaded);
      expect(adManager.isInterstitialLoaded, isTrue);
    });

    // 9. Correct Debug/Profile test IDs
    test('9. Debug and Profile configurations use official Google test ad unit IDs', () {
      expect(
        AdConfig.debugConfig.bannerAdUnitId,
        'ca-app-pub-3940256099942544/6300978111',
      );
      expect(
        AdConfig.debugConfig.interstitialAdUnitId,
        'ca-app-pub-3940256099942544/1033173712',
      );
      expect(AdConfig.debugConfig.isTestAds, isTrue);

      expect(
        AdConfig.profileConfig.bannerAdUnitId,
        'ca-app-pub-3940256099942544/6300978111',
      );
      expect(
        AdConfig.profileConfig.interstitialAdUnitId,
        'ca-app-pub-3940256099942544/1033173712',
      );
      expect(AdConfig.profileConfig.isTestAds, isTrue);
    });

    // 10. Correct Release production IDs
    test('10. Release configuration uses exact production AdMob IDs', () {
      expect(
        AdConfig.releaseConfig.appId,
        'ca-app-pub-5877011177866406~4355156867',
      );
      expect(
        AdConfig.releaseConfig.bannerAdUnitId,
        'ca-app-pub-5877011177866406/2930394553',
      );
      expect(
        AdConfig.releaseConfig.interstitialAdUnitId,
        'ca-app-pub-5877011177866406/2195897382',
      );
      expect(AdConfig.releaseConfig.isTestAds, isFalse);
      expect(AdConfig.releaseConfig.environmentName, 'PRODUCTION');
    });

    // 11. Debug Center diagnostics reflect actual initialization state & live updates
    testWidgets('11. Debug Center diagnostics display live initialization states, technical errors, and separate banner/interstitial statuses', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final prefsRepo = PreferencesRepository(prefs);
      final db = MeowoirsDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());
      final repo = DriftMeowoirsRepository(
        catDao: db.catDao,
        memoryDao: db.memoryDao,
        preferencesRepository: prefsRepo,
      );

      // Start in INITIALIZATION_FAILED with a pending UI banner request
      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        consentStatusFetcher: () async => ConsentStatus.unknown,
        privacyOptionsStatusFetcher: () async =>
            PrivacyOptionsRequirementStatus.unknown,
        initRetryDelays: const [],
        mobileAdsInitializer: () async {
          throw Exception('PlayServicesNotAvailableException: code 9');
        },
      );
      adManager.preloadBanner();
      await adManager.initialize();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            preferencesRepositoryProvider.overrideWithValue(prefsRepo),
            repositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp(
            theme: MeowoirsTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const DebugCenterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expand Section 5: AdMob & Monetization
      await tester.tap(find.text('5. AdMob & Monetization'));
      await tester.pumpAndSettle();

      expect(find.text('SDK Initialization State'), findsOneWidget);
      expect(find.text('INITIALIZATION_FAILED'), findsOneWidget);
      expect(
        find.textContaining('PlayServicesNotAvailableException: code 9'),
        findsOneWidget,
      );
      expect(find.text('Banner Network Request'), findsOneWidget);
      expect(
        find.text('NOT_SENT (Waiting for SDK/Consent)'),
        findsOneWidget,
      );
      expect(find.text('NOT_LOADED'), findsOneWidget);

      // Now simulate successful recovery and verify Debug Center updates LIVE without re-opening
      adManager.configureForTesting(
        isSupportedPlatform: true,
        canRequestAdsFetcher: () async => true,
        mobileAdsInitializer: () async => _FakeInitializationStatus(),
        bannerLoadExecutor: () {
          adManager.completeBannerLoadForTesting(success: true);
        },
        interstitialLoadExecutor: () {
          adManager.completeInterstitialLoadForTesting(success: true);
        },
      );
      await adManager.initialize();
      await tester.pumpAndSettle();

      expect(find.text('INITIALIZED'), findsOneWidget);
      expect(find.text('SENT'), findsOneWidget);
      expect(find.text('loaded'), findsOneWidget);
      expect(find.text('LOADED'), findsOneWidget);
    });
  });
}

