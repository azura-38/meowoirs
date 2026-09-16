import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'launch_counter_manager.dart';

enum BannerState { idle, loading, loaded, failed }

/// Central orchestrator for AdMob initialization, UMP consent flow,
/// banner lifecycle, and interstitial ad management in Meowoirs.
/// Direct parity with AdManager.kt.
class AdManager {
  AdManager._();

  static final AdManager instance = AdManager._();

  bool _isMobileAdsInitialized = false;
  bool _canRequestAds = false;
  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;
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

  static const List<int> _bannerRetryDelays = [5000, 15000, 30000, 60000];

  final ValueNotifier<BannerState> bannerStateNotifier =
      ValueNotifier<BannerState>(BannerState.idle);

  bool get isMobileAdsInitialized => _isMobileAdsInitialized;
  bool get canRequestAdsValue => _canRequestAds;
  BannerAd? get activeBannerAd => _activeBannerAd;
  BannerState get bannerState => bannerStateNotifier.value;
  int get bannerRetryAttempt => _bannerRetryAttempt;
  int? get lastBannerErrorCode => _lastBannerErrorCode;
  String? get lastBannerErrorMessage => _lastBannerErrorMessage;
  int get lastBannerFailureTime => _lastBannerFailureTime;
  int get lastBannerLoadedTime => _lastBannerLoadedTime;

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

  /// Initializes the Google Mobile Ads SDK once per app lifecycle.
  Future<void> initialize() async {
    if (_isMobileAdsInitialized) return;

    // Mobile ads only support Android and iOS platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        await MobileAds.instance.initialize();
        _isMobileAdsInitialized = true;
        if (_bannerRequested) {
          preloadBanner();
        }
      } catch (e) {
        debugPrint('AdManager: Failed to initialize MobileAds: $e');
      }
    }
  }

  /// Gathers consent using Google's User Messaging Platform (UMP).
  /// If consent is required (e.g., EEA/UK), loads and presents the consent form.
  Future<void> requestConsentAndInitialize({
    VoidCallback? onComplete,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      onComplete?.call();
      return;
    }

    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((formError) async {
          final canRequest = await ConsentInformation.instance.canRequestAds();
          _canRequestAds = canRequest;
          if (canRequest) {
            await initialize();
            preloadInterstitial();
          }
          onComplete?.call();
        });
      },
      (formError) async {
        debugPrint('AdManager: Consent request failed: ${formError.message}');
        final canRequest = await ConsentInformation.instance.canRequestAds();
        _canRequestAds = canRequest;
        if (canRequest) {
          await initialize();
          preloadInterstitial();
        }
        onComplete?.call();
      },
    );
  }

  /// Shows the UMP privacy options form if required in the user's region/session.
  Future<void> showPrivacyOptions({
    required void Function(bool isAvailable, String? error) onComplete,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      onComplete(false, null);
      return;
    }

    try {
      final status =
          await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
      if (status == PrivacyOptionsRequirementStatus.required) {
        ConsentForm.showPrivacyOptionsForm((formError) {
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
  void preloadBanner() {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    _bannerRequested = true;

    // If SDK is not yet initialized, wait until initialize() calls preloadBanner()
    if (!_isMobileAdsInitialized) return;

    if (bannerStateNotifier.value == BannerState.loaded && _activeBannerAd != null) {
      return;
    }
    if (bannerStateNotifier.value == BannerState.loading) {
      return;
    }

    bannerStateNotifier.value = BannerState.loading;

    _activeBannerAd?.dispose();
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
          _lastBannerLoadedTime = DateTime.now().millisecondsSinceEpoch;
          bannerStateNotifier.value = BannerState.loaded;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _activeBannerAd = null;
          _lastBannerErrorCode = error.code;
          _lastBannerErrorMessage = error.message;
          _lastBannerFailureTime = DateTime.now().millisecondsSinceEpoch;
          bannerStateNotifier.value = BannerState.failed;

          // Controlled exponential backoff retry matching Kotlin AdManager.kt
          if (_bannerRetryAttempt < _bannerRetryDelays.length) {
            final delayMs = _bannerRetryDelays[_bannerRetryAttempt++];
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
    _activeBannerAd?.dispose();
    _activeBannerAd = null;
    _bannerRequested = false;
    bannerStateNotifier.value = BannerState.idle;
  }

  /// Preloads an interstitial ad in memory for the 5-7 launch cycle.
  void preloadInterstitial() {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    if (_interstitialAd != null || _isLoadingInterstitial) return;

    _isLoadingInterstitial = true;

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _launchCounterManager?.onInterstitialShown();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitial = false;
          _interstitialAd = null;
          debugPrint('AdManager: Interstitial failed to load: $error');
        },
      ),
    );
  }

  /// Checks if interstitial is eligible on launch, waits 1200ms delay (matching Kotlin reference),
  /// and presents the ad.
  void checkAndShowLaunchInterstitial() {
    if (_launchCounterManager == null) return;

    if (_launchCounterManager!.isEligibleForInterstitial()) {
      if (_interstitialAd != null) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (_interstitialAd != null) {
            _interstitialAd!.show();
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
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          bannerStateNotifier.value = BannerState.failed;
          onFailed(error);
        },
      ),
    );
  }
}
