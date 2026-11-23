import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../crashlytics/crashlytics_service.dart';
import 'ad_config.dart';
import 'launch_counter_manager.dart';

enum BannerState { idle, loading, loaded, failed }

/// Explicit SDK initialization states for diagnostics and lifecycle tracking.
enum AdInitializationState {
  notStarted('NOT_STARTED'),
  waitingForConsent('WAITING_FOR_CONSENT'),
  initializing('INITIALIZING'),
  initialized('INITIALIZED'),
  initializationFailed('INITIALIZATION_FAILED');

  const AdInitializationState(this.diagnosticName);
  final String diagnosticName;
}

/// Explicit interstitial loading states for diagnostics.
enum InterstitialLoadState {
  notLoaded('NOT_LOADED'),
  loading('LOADING'),
  loaded('LOADED'),
  failed('FAILED');

  const InterstitialLoadState(this.diagnosticName);
  final String diagnosticName;
}

/// Signature for UMP consent info update execution (injectable for testing).
typedef RequestConsentInfoUpdateRunner =
    void Function(
      ConsentRequestParameters params,
      OnConsentInfoUpdateSuccessListener successListener,
      OnConsentInfoUpdateFailureListener failureListener,
    );

/// Signature for UMP consent form presentation (injectable for testing).
typedef LoadAndShowConsentFormRunner =
    Future<void> Function(
      OnConsentFormDismissedListener onConsentFormDismissed,
    );

/// Central orchestrator for AdMob initialization, UMP consent flow,
/// banner lifecycle, and interstitial ad management in Meowoirs.
/// Direct parity with AdManager.kt with enhanced idempotent initialization
/// and Closed Testing diagnostics.
class AdManager {
  AdManager._();

  static final AdManager instance = AdManager._();

  bool _isMobileAdsInitialized = false;
  AdInitializationState _initializationState = AdInitializationState.notStarted;
  Future<void>? _initializationFuture;
  String? _lastInitializationError;
  int _initRetryAttempt = 0;
  Timer? _initRetryTimer;

  bool _canRequestAds = false;
  ConsentStatus _umpConsentStatus = ConsentStatus.unknown;
  PrivacyOptionsRequirementStatus _privacyOptionsStatus =
      PrivacyOptionsRequirementStatus.unknown;
  String? _lastConsentError;
  bool _isConsentGatheringInProgress = false;
  Future<void>? _consentFuture;

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;
  InterstitialLoadState _interstitialState = InterstitialLoadState.notLoaded;
  String? _lastInterstitialErrorMessage;
  int? _lastInterstitialErrorCode;
  Timer? _interstitialRetryTimer;
  int _interstitialRetryAttempt = 0;
  // Prevents repeated MainScaffold rebuilds from scheduling multiple show() calls.
  bool _isInterstitialShowPending = false;
  LaunchCounterManager? _launchCounterManager;

  // Banner State & Lifecycle
  BannerAd? _activeBannerAd;
  Timer? _retryTimer;
  int _bannerRetryAttempt = 0;
  int? _lastBannerErrorCode;
  String? _lastBannerErrorMessage;
  int _lastBannerFailureTime = 0;
  int _lastBannerLoadedTime = 0;
  bool _bannerRequested = false;
  bool _bannerNetworkRequestSent = false;

  static const List<int> _bannerRetryDelays = [5000, 15000, 30000, 60000];
  static const List<int> _defaultInitRetryDelays = [5000, 15000, 30000];
  static const Duration _defaultInitTimeout = Duration(seconds: 15);
  static const Duration _defaultConsentTimeout = Duration(seconds: 10);

  List<int> _initRetryDelays = _defaultInitRetryDelays;
  Duration _initTimeout = _defaultInitTimeout;
  Duration _consentTimeout = _defaultConsentTimeout;

  final ValueNotifier<BannerState> bannerStateNotifier =
      ValueNotifier<BannerState>(BannerState.idle);

  final ValueNotifier<AdInitializationState> initializationStateNotifier =
      ValueNotifier<AdInitializationState>(AdInitializationState.notStarted);

  final ValueNotifier<bool> isInitializedNotifier = ValueNotifier<bool>(false);

  /// Emits an incrementing counter whenever any diagnostic state changes so
  /// DebugCenterScreen can display live state without stale cached values.
  final ValueNotifier<int> diagnosticsRevisionNotifier = ValueNotifier<int>(0);

  // Injectable platform overrides for deterministic testing
  bool? _isSupportedPlatformOverride;
  Future<bool> Function()? _canRequestAdsFetcherOverride;
  Future<ConsentStatus> Function()? _consentStatusFetcherOverride;
  Future<PrivacyOptionsRequirementStatus> Function()?
  _privacyOptionsStatusFetcherOverride;
  RequestConsentInfoUpdateRunner? _requestConsentInfoUpdateOverride;
  LoadAndShowConsentFormRunner? _loadAndShowConsentFormOverride;
  Future<InitializationStatus> Function()? _mobileAdsInitializerOverride;
  void Function()? _bannerLoadExecutorOverride;
  void Function()? _interstitialLoadExecutorOverride;

  bool get _isSupportedMobilePlatform {
    if (_isSupportedPlatformOverride != null) {
      return _isSupportedPlatformOverride!;
    }
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  bool get isMobileAdsInitialized => _isMobileAdsInitialized;
  AdInitializationState get initializationState => _initializationState;
  String? get lastInitializationError => _lastInitializationError;
  int get initRetryAttempt => _initRetryAttempt;

  bool get canRequestAds => _canRequestAds;
  bool get canRequestAdsValue => _canRequestAds;
  ConsentStatus get umpConsentStatus => _umpConsentStatus;
  PrivacyOptionsRequirementStatus get privacyOptionsStatus =>
      _privacyOptionsStatus;
  String? get lastConsentError => _lastConsentError;

  BannerAd? get activeBannerAd => _activeBannerAd;
  BannerState get bannerState => bannerStateNotifier.value;
  bool get bannerRequested => _bannerRequested;
  bool get bannerNetworkRequestSent => _bannerNetworkRequestSent;
  int get bannerRetryAttempt => _bannerRetryAttempt;
  int? get lastBannerErrorCode => _lastBannerErrorCode;
  String? get lastBannerErrorMessage => _lastBannerErrorMessage;
  int get lastBannerFailureTime => _lastBannerFailureTime;
  int get lastBannerLoadedTime => _lastBannerLoadedTime;

  bool get isInterstitialLoaded =>
      _interstitialAd != null ||
      _interstitialState == InterstitialLoadState.loaded;
  bool get isLoadingInterstitial => _isLoadingInterstitial;
  InterstitialLoadState get interstitialState => _interstitialState;
  int get interstitialRetryAttempt => _interstitialRetryAttempt;
  int? get lastInterstitialErrorCode => _lastInterstitialErrorCode;
  String? get lastInterstitialErrorMessage => _lastInterstitialErrorMessage;

  /// Waits for any in-flight initialization or consent flow to complete.
  Future<void> waitUntilInitialized() async {
    if (_isMobileAdsInitialized) return;
    if (_consentFuture != null) {
      await _consentFuture;
    }
    if (_initializationFuture != null) {
      await _initializationFuture;
    }
  }

  void _setInitializationState(AdInitializationState newState) {
    _initializationState = newState;
    initializationStateNotifier.value = newState;
    isInitializedNotifier.value = _isMobileAdsInitialized;
    _notifyDiagnosticsChanged();
  }

  void _notifyDiagnosticsChanged() {
    diagnosticsRevisionNotifier.value = diagnosticsRevisionNotifier.value + 1;
  }

  /// Safe route check for interstitial presentation: only top-level browsing screens,
  /// strictly excluding form inputs, creation flows, settings, and onboarding.
  static bool isSafeRouteForInterstitial(String? route) {
    if (route == null) return false;
    if (route == '/' ||
        route == '/home' ||
        route == '/cats' ||
        route == '/memories' ||
        route == '/story' ||
        route == '/my_story') {
      return true;
    }
    return false;
  }

  void setLaunchCounterManager(LaunchCounterManager manager) {
    _launchCounterManager = manager;
  }

  Future<bool> _fetchCanRequestAds() async {
    if (_canRequestAdsFetcherOverride != null) {
      return _canRequestAdsFetcherOverride!();
    }
    return ConsentInformation.instance.canRequestAds();
  }

  Future<ConsentStatus> _fetchConsentStatus() async {
    if (_consentStatusFetcherOverride != null) {
      return _consentStatusFetcherOverride!();
    }
    return ConsentInformation.instance.getConsentStatus();
  }

  Future<PrivacyOptionsRequirementStatus> _fetchPrivacyOptionsStatus() async {
    if (_privacyOptionsStatusFetcherOverride != null) {
      return _privacyOptionsStatusFetcherOverride!();
    }
    return ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
  }

  Future<InitializationStatus> _runMobileAdsInitialize() {
    if (_mobileAdsInitializerOverride != null) {
      return _mobileAdsInitializerOverride!();
    }
    return MobileAds.instance.initialize();
  }

  /// Refreshes cached UMP consent status, privacy options requirement status,
  /// and `canRequestAds` from the UMP SDK for live diagnostics.
  Future<void> refreshConsentDiagnostics() async {
    if (!_isSupportedMobilePlatform) return;
    try {
      _umpConsentStatus = await _fetchConsentStatus();
    } catch (e) {
      debugPrint('AdManager: Failed to read UMP consent status: $e');
    }
    try {
      _privacyOptionsStatus = await _fetchPrivacyOptionsStatus();
    } catch (e) {
      debugPrint('AdManager: Failed to read UMP privacy options status: $e');
    }
    try {
      _canRequestAds = await _fetchCanRequestAds();
    } catch (e) {
      debugPrint('AdManager: Failed to read UMP canRequestAds: $e');
    }
    _notifyDiagnosticsChanged();
  }

  /// Initializes the Google Mobile Ads SDK idempotently once per app lifecycle.
  ///
  /// - Proceeds whenever UMP reports `canRequestAds == true`, regardless of
  ///   whether `umpConsentStatus` is `obtained`, `notRequired`, or `unknown`.
  /// - Never forces `canRequestAds = true` and never bypasses UMP consent.
  /// - Deduplicates concurrent initialization calls via `_initializationFuture`.
  /// - Captures technical errors and schedules controlled exponential-backoff
  ///   retries if initialization fails.
  Future<void> initialize() async {
    if (!_isSupportedMobilePlatform) return;

    // Already initialized: ensure any pending ad requests are triggered.
    if (_isMobileAdsInitialized) {
      if (_initializationState != AdInitializationState.initialized) {
        _setInitializationState(AdInitializationState.initialized);
      }
      _triggerPostInitAdLoads();
      return;
    }

    // Deduplicate concurrent initialization calls before any async gap.
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    final completer = Completer<void>();
    _initializationFuture = completer.future;

    try {
      // Verify UMP permission if _canRequestAds is not yet true.
      // Never force _canRequestAds = true and never bypass UMP.
      if (!_canRequestAds) {
        try {
          _canRequestAds = await _fetchCanRequestAds();
          _notifyDiagnosticsChanged();
        } catch (e) {
          debugPrint('AdManager: Unable to query canRequestAds before init: $e');
        }
      }

      if (!_canRequestAds) {
        debugPrint(
          'AdManager: initialize() skipped because UMP canRequestAds is false '
          '(consentStatus: ${_umpConsentStatus.name}).',
        );
        if (_initializationState == AdInitializationState.notStarted) {
          _setInitializationState(AdInitializationState.waitingForConsent);
        }
        return;
      }

      _initRetryTimer?.cancel();
      _initRetryTimer = null;
      _setInitializationState(AdInitializationState.initializing);

      await _runMobileAdsInitialize().timeout(_initTimeout);
      _isMobileAdsInitialized = true;
      _lastInitializationError = null;
      _initRetryAttempt = 0;
      _setInitializationState(AdInitializationState.initialized);
      _triggerPostInitAdLoads();
    } catch (e, stackTrace) {
      _isMobileAdsInitialized = false;
      _lastInitializationError = _formatTechnicalError(e);
      _setInitializationState(AdInitializationState.initializationFailed);
      debugPrint(
        'AdManager: Failed to initialize MobileAds '
        '(attempt $_initRetryAttempt): $_lastInitializationError',
      );
      CrashlyticsService.instance.recordNonFatal(
        e,
        stackTrace,
        reason: 'AdMob SDK Initialization Failed',
      );
      _scheduleInitializationRetry();
    } finally {
      _initializationFuture = null;
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
  }

  void _triggerPostInitAdLoads() {
    if (!_canRequestAds || !_isMobileAdsInitialized) return;
    if (_bannerRequested) {
      preloadBanner();
    }
    preloadInterstitial();
  }

  void _scheduleInitializationRetry() {
    if (_isMobileAdsInitialized || !_canRequestAds) return;
    if (_initRetryAttempt >= _initRetryDelays.length) return;

    final delayMs = _initRetryDelays[_initRetryAttempt++];
    _notifyDiagnosticsChanged();
    _initRetryTimer?.cancel();
    _initRetryTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!_isMobileAdsInitialized && _canRequestAds) {
        initialize();
      }
    });
  }

  String _formatTechnicalError(Object error) {
    final raw = error.toString().trim();
    if (raw.isEmpty) return error.runtimeType.toString();
    return raw;
  }

  /// Gathers consent using Google's User Messaging Platform (UMP).
  /// If consent is required (e.g., EEA/UK), loads and presents the consent form.
  /// Whenever UMP reports `canRequestAds == true` (including when UMP status is
  /// `unknown` or `notRequired`), proceeds with Mobile Ads SDK initialization.
  Future<void> requestConsentAndInitialize({VoidCallback? onComplete}) async {
    if (!_isSupportedMobilePlatform) {
      onComplete?.call();
      return;
    }

    // Deduplicate concurrent consent+init requests before any async gap.
    if (_isConsentGatheringInProgress && _consentFuture != null) {
      await _consentFuture;
      onComplete?.call();
      return;
    }

    _isConsentGatheringInProgress = true;
    final completer = Completer<void>();
    _consentFuture = completer.future;

    if (!_isMobileAdsInitialized &&
        _initializationState != AdInitializationState.initializing) {
      _setInitializationState(AdInitializationState.waitingForConsent);
    }

    // Check if UMP already permits requesting ads from a previous session
    // so SDK initialization is not blocked while UMP refreshes in parallel,
    // without bypassing UMP or forcing consent.
    try {
      final initialCanRequest = await _fetchCanRequestAds();
      _canRequestAds = initialCanRequest;
      _umpConsentStatus = await _fetchConsentStatus();
      _privacyOptionsStatus = await _fetchPrivacyOptionsStatus();
      _notifyDiagnosticsChanged();
      if (initialCanRequest && !_isMobileAdsInitialized) {
        unawaited(initialize());
      }
    } catch (e) {
      debugPrint('AdManager: Pre-update UMP status check failed: $e');
    }

    final params = ConsentRequestParameters();
    bool resolved = false;
    Timer? consentTimeoutTimer;

    Future<void> handleConsentResolved({FormError? consentError}) async {
      if (resolved) return;
      resolved = true;
      consentTimeoutTimer?.cancel();
      consentTimeoutTimer = null;

      try {
        if (consentError != null) {
          _lastConsentError =
              '[${consentError.errorCode}] ${consentError.message}';
          debugPrint('AdManager: UMP consent error: $_lastConsentError');
        } else {
          _lastConsentError = null;
        }

        await refreshConsentDiagnostics();

        if (_canRequestAds) {
          await initialize();
        } else {
          if (!_isMobileAdsInitialized) {
            _setInitializationState(AdInitializationState.waitingForConsent);
          }
        }
      } catch (e, stackTrace) {
        debugPrint('AdManager: Error in UMP resolution handler: $e');
        CrashlyticsService.instance.recordError(
          e,
          stackTrace,
          reason: 'UMP Consent Resolution Handler Error',
        );
      } finally {
        _isConsentGatheringInProgress = false;
        _consentFuture = null;
        onComplete?.call();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    }

    consentTimeoutTimer = Timer(_consentTimeout, () {
      if (!resolved) {
        unawaited(
          handleConsentResolved(
            consentError: FormError(
              errorCode: -2,
              message:
                  'UMP requestConsentInfoUpdate timed out after ${_consentTimeout.inSeconds}s',
            ),
          ),
        );
      }
    });

    try {
      final requestUpdate =
          _requestConsentInfoUpdateOverride ??
          ConsentInformation.instance.requestConsentInfoUpdate;
      final loadAndShowForm =
          _loadAndShowConsentFormOverride ??
          ConsentForm.loadAndShowConsentFormIfRequired;

      requestUpdate(
        params,
        () async {
          try {
            await loadAndShowForm((formError) async {
              await handleConsentResolved(consentError: formError);
            });
          } catch (e) {
            await handleConsentResolved(
              consentError: FormError(errorCode: -1, message: e.toString()),
            );
          }
        },
        (formError) async {
          await handleConsentResolved(consentError: formError);
        },
      );
    } catch (e) {
      await handleConsentResolved(
        consentError: FormError(errorCode: -1, message: e.toString()),
      );
    }

    return completer.future;
  }

  /// Shows the UMP privacy options form if required in the user's region/session.
  Future<void> showPrivacyOptions({
    required void Function(bool isAvailable, String? error) onComplete,
  }) async {
    if (!_isSupportedMobilePlatform) {
      onComplete(false, null);
      return;
    }

    try {
      final status = await _fetchPrivacyOptionsStatus();
      _privacyOptionsStatus = status;
      _notifyDiagnosticsChanged();
      if (status == PrivacyOptionsRequirementStatus.required) {
        ConsentForm.showPrivacyOptionsForm((formError) async {
          await refreshConsentDiagnostics();
          if (_canRequestAds && !_isMobileAdsInitialized) {
            await initialize();
          }
          onComplete(true, formError?.message);
        });
      } else {
        onComplete(false, null);
      }
    } catch (e) {
      onComplete(false, e.toString());
    }
  }

  /// Preloads a banner ad with automatic retry and lifecycle safety.
  ///
  /// Marks `_bannerRequested = true` when the UI requests a banner, but only
  /// sends an actual ad network load request (`_bannerNetworkRequestSent = true`)
  /// after UMP permits ads (`_canRequestAds == true`) and Mobile Ads SDK
  /// initialization has succeeded (`_isMobileAdsInitialized == true`).
  void preloadBanner() {
    if (!_isSupportedMobilePlatform) return;

    _bannerRequested = true;
    _notifyDiagnosticsChanged();

    // Do not load BannerAd before advertising requests are permitted and SDK is initialized.
    if (!_canRequestAds || !_isMobileAdsInitialized) {
      debugPrint(
        'AdManager: preloadBanner deferred '
        '(canRequestAds: $_canRequestAds, init: $_isMobileAdsInitialized, '
        'initState: ${_initializationState.diagnosticName})',
      );
      if (_canRequestAds &&
          !_isMobileAdsInitialized &&
          _initializationState != AdInitializationState.initializing &&
          _initializationFuture == null &&
          _initRetryTimer == null) {
        unawaited(initialize());
      }
      return;
    }

    if (bannerStateNotifier.value == BannerState.loaded &&
        (_activeBannerAd != null || _bannerLoadExecutorOverride != null)) {
      return;
    }
    if (bannerStateNotifier.value == BannerState.loading) {
      return;
    }

    bannerStateNotifier.value = BannerState.loading;
    _bannerNetworkRequestSent = true;
    _notifyDiagnosticsChanged();

    if (_bannerLoadExecutorOverride != null) {
      _bannerLoadExecutorOverride!();
      return;
    }

    // Always dispose previous banner instance before creating a new one to prevent leaks
    final oldAd = _activeBannerAd;
    _activeBannerAd = null;
    oldAd?.dispose();

    _activeBannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _activeBannerAd = ad as BannerAd;
          _bannerRetryAttempt = 0;
          _retryTimer?.cancel();
          _retryTimer = null;
          _lastBannerErrorCode = null;
          _lastBannerErrorMessage = null;
          _lastBannerLoadedTime = DateTime.now().millisecondsSinceEpoch;
          bannerStateNotifier.value = BannerState.loaded;
          _notifyDiagnosticsChanged();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _activeBannerAd = null;
          _lastBannerErrorCode = error.code;
          _lastBannerErrorMessage = error.message;
          _lastBannerFailureTime = DateTime.now().millisecondsSinceEpoch;
          bannerStateNotifier.value = BannerState.failed;
          _notifyDiagnosticsChanged();
          debugPrint(
            'AdManager: Banner failed to load: [${error.code}] ${error.message}',
          );

          // Controlled exponential backoff retry matching Kotlin AdManager.kt
          if (_bannerRetryAttempt < _bannerRetryDelays.length) {
            final delayMs = _bannerRetryDelays[_bannerRetryAttempt++];
            _notifyDiagnosticsChanged();
            _retryTimer?.cancel();
            _retryTimer = Timer(Duration(milliseconds: delayMs), () {
              preloadBanner();
            });
          }
        },
      ),
    );

    _activeBannerAd!.load();
  }

  /// Destroys active banner ad and resets retry timer.
  void destroyBanner() {
    _retryTimer?.cancel();
    _retryTimer = null;
    final oldAd = _activeBannerAd;
    _activeBannerAd = null;
    oldAd?.dispose();
    _bannerRequested = false;
    _bannerNetworkRequestSent = false;
    bannerStateNotifier.value = BannerState.idle;
    _notifyDiagnosticsChanged();
  }

  /// Preloads an interstitial ad in memory for the 5-7 launch cycle.
  void preloadInterstitial() {
    if (!_isSupportedMobilePlatform) return;
    if (!_canRequestAds || !_isMobileAdsInitialized) return;
    if (_interstitialAd != null ||
        _isLoadingInterstitial ||
        _interstitialState == InterstitialLoadState.loaded) {
      return;
    }

    _isLoadingInterstitial = true;
    _interstitialState = InterstitialLoadState.loading;
    _notifyDiagnosticsChanged();

    if (_interstitialLoadExecutorOverride != null) {
      _interstitialLoadExecutorOverride!();
      return;
    }

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          _interstitialRetryAttempt = 0;
          _interstitialRetryTimer?.cancel();
          _interstitialRetryTimer = null;
          _interstitialState = InterstitialLoadState.loaded;
          _lastInterstitialErrorCode = null;
          _lastInterstitialErrorMessage = null;
          _notifyDiagnosticsChanged();
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  _interstitialAd = null;
                  _interstitialState = InterstitialLoadState.notLoaded;
                  _isInterstitialShowPending = false;
                  _launchCounterManager?.onInterstitialShown();
                  _notifyDiagnosticsChanged();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _interstitialAd = null;
                  _interstitialState = InterstitialLoadState.notLoaded;
                  _isInterstitialShowPending = false;
                  _notifyDiagnosticsChanged();
                },
              );
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitial = false;
          _interstitialAd = null;
          _interstitialState = InterstitialLoadState.failed;
          _lastInterstitialErrorCode = error.code;
          _lastInterstitialErrorMessage = error.message;
          _notifyDiagnosticsChanged();
          debugPrint('AdManager: Interstitial failed to load: $error');

          if (_interstitialRetryAttempt < _bannerRetryDelays.length) {
            final delayMs = _bannerRetryDelays[_interstitialRetryAttempt++];
            _notifyDiagnosticsChanged();
            _interstitialRetryTimer?.cancel();
            _interstitialRetryTimer = Timer(
              Duration(milliseconds: delayMs),
              () {
                preloadInterstitial();
              },
            );
          }
        },
      ),
    );
  }

  /// Checks if interstitial is eligible on launch, waits 1200ms delay (matching Kotlin reference),
  /// and presents the ad.
  void checkAndShowLaunchInterstitial() {
    if (_launchCounterManager == null) return;
    if (_isInterstitialShowPending) return;

    if (_launchCounterManager!.isEligibleForInterstitial()) {
      if (_interstitialAd != null) {
        _isInterstitialShowPending = true;
        Future.delayed(const Duration(milliseconds: 1200), () {
          final ad = _interstitialAd;
          if (ad != null) {
            ad.show();
          } else {
            _isInterstitialShowPending = false;
          }
        });
      } else {
        preloadInterstitial();
      }
    }
  }

  /// Helper to create and load a standard BannerAd.
  BannerAd createBannerAd({
    required VoidCallback onLoaded,
    required void Function(LoadAdError error) onFailed,
  }) {
    return BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerStateNotifier.value = BannerState.loaded;
          _notifyDiagnosticsChanged();
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          bannerStateNotifier.value = BannerState.failed;
          _notifyDiagnosticsChanged();
          onFailed(error);
        },
      ),
    );
  }

  /// Configures test overrides and resets internal state for unit/widget tests.
  @visibleForTesting
  void configureForTesting({
    bool? isSupportedPlatform,
    Future<bool> Function()? canRequestAdsFetcher,
    Future<ConsentStatus> Function()? consentStatusFetcher,
    Future<PrivacyOptionsRequirementStatus> Function()?
    privacyOptionsStatusFetcher,
    RequestConsentInfoUpdateRunner? requestConsentInfoUpdateRunner,
    LoadAndShowConsentFormRunner? loadAndShowConsentFormRunner,
    Future<InitializationStatus> Function()? mobileAdsInitializer,
    void Function()? bannerLoadExecutor,
    void Function()? interstitialLoadExecutor,
    List<int>? initRetryDelays,
    Duration? initTimeout,
    Duration? consentTimeout,
  }) {
    _isSupportedPlatformOverride = isSupportedPlatform;
    _canRequestAdsFetcherOverride = canRequestAdsFetcher;
    _consentStatusFetcherOverride = consentStatusFetcher;
    _privacyOptionsStatusFetcherOverride = privacyOptionsStatusFetcher;
    _requestConsentInfoUpdateOverride = requestConsentInfoUpdateRunner;
    _loadAndShowConsentFormOverride = loadAndShowConsentFormRunner;
    _mobileAdsInitializerOverride = mobileAdsInitializer;
    _bannerLoadExecutorOverride = bannerLoadExecutor;
    _interstitialLoadExecutorOverride = interstitialLoadExecutor;
    if (initRetryDelays != null) {
      _initRetryDelays = initRetryDelays;
    }
    if (initTimeout != null) {
      _initTimeout = initTimeout;
    }
    if (consentTimeout != null) {
      _consentTimeout = consentTimeout;
    }
  }

  /// Marks banner load outcome in unit tests when using `bannerLoadExecutor`.
  @visibleForTesting
  void completeBannerLoadForTesting({
    required bool success,
    int? errorCode,
    String? errorMessage,
  }) {
    if (success) {
      _bannerRetryAttempt = 0;
      _retryTimer?.cancel();
      _retryTimer = null;
      _lastBannerErrorCode = null;
      _lastBannerErrorMessage = null;
      _lastBannerLoadedTime = DateTime.now().millisecondsSinceEpoch;
      bannerStateNotifier.value = BannerState.loaded;
    } else {
      _lastBannerErrorCode = errorCode ?? -1;
      _lastBannerErrorMessage = errorMessage ?? 'Test banner load failure';
      _lastBannerFailureTime = DateTime.now().millisecondsSinceEpoch;
      bannerStateNotifier.value = BannerState.failed;
    }
    _notifyDiagnosticsChanged();
  }

  /// Marks interstitial load outcome in unit tests when using `interstitialLoadExecutor`.
  @visibleForTesting
  void completeInterstitialLoadForTesting({
    required bool success,
    int? errorCode,
    String? errorMessage,
  }) {
    _isLoadingInterstitial = false;
    if (success) {
      _interstitialState = InterstitialLoadState.loaded;
      _lastInterstitialErrorCode = null;
      _lastInterstitialErrorMessage = null;
    } else {
      _interstitialState = InterstitialLoadState.failed;
      _lastInterstitialErrorCode = errorCode ?? -1;
      _lastInterstitialErrorMessage =
          errorMessage ?? 'Test interstitial load failure';
    }
    _notifyDiagnosticsChanged();
  }

  /// Resets all singleton state and timers between tests.
  @visibleForTesting
  void resetForTesting() {
    _initRetryTimer?.cancel();
    _initRetryTimer = null;
    _retryTimer?.cancel();
    _retryTimer = null;
    _interstitialRetryTimer?.cancel();
    _interstitialRetryTimer = null;
    _activeBannerAd?.dispose();
    _activeBannerAd = null;
    _interstitialAd?.dispose();
    _interstitialAd = null;

    _isMobileAdsInitialized = false;
    _initializationState = AdInitializationState.notStarted;
    initializationStateNotifier.value = AdInitializationState.notStarted;
    isInitializedNotifier.value = false;
    _initializationFuture = null;
    _lastInitializationError = null;
    _initRetryAttempt = 0;

    _canRequestAds = false;
    _umpConsentStatus = ConsentStatus.unknown;
    _privacyOptionsStatus = PrivacyOptionsRequirementStatus.unknown;
    _lastConsentError = null;
    _isConsentGatheringInProgress = false;
    _consentFuture = null;

    _isLoadingInterstitial = false;
    _interstitialState = InterstitialLoadState.notLoaded;
    _interstitialRetryAttempt = 0;
    _lastInterstitialErrorCode = null;
    _lastInterstitialErrorMessage = null;
    _isInterstitialShowPending = false;

    _bannerRetryAttempt = 0;
    _lastBannerErrorCode = null;
    _lastBannerErrorMessage = null;
    _lastBannerFailureTime = 0;
    _lastBannerLoadedTime = 0;
    _bannerRequested = false;
    _bannerNetworkRequestSent = false;
    bannerStateNotifier.value = BannerState.idle;

    _isSupportedPlatformOverride = null;
    _canRequestAdsFetcherOverride = null;
    _consentStatusFetcherOverride = null;
    _privacyOptionsStatusFetcherOverride = null;
    _requestConsentInfoUpdateOverride = null;
    _loadAndShowConsentFormOverride = null;
    _mobileAdsInitializerOverride = null;
    _bannerLoadExecutorOverride = null;
    _interstitialLoadExecutorOverride = null;
    _initRetryDelays = _defaultInitRetryDelays;
    _initTimeout = _defaultInitTimeout;
    _consentTimeout = _defaultConsentTimeout;

    _notifyDiagnosticsChanged();
  }
}
