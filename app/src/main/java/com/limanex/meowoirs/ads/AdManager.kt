package com.limanex.meowoirs.ads

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.view.ViewGroup
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.google.android.ump.ConsentInformation
import com.google.android.ump.ConsentRequestParameters
import com.google.android.ump.UserMessagingPlatform
import com.limanex.meowoirs.ui.navigation.MeowoirsRoutes
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.lang.ref.WeakReference
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Central orchestrator for AdMob initialization, UMP consent flow,
 * banner preloading & lifecycle, and interstitial ad management in Meowoirs.
 */
object AdManager {

    enum class BannerState {
        IDLE,
        LOADING,
        LOADED,
        FAILED
    }

    private val isMobileAdsInitialized = AtomicBoolean(false)
    private val isPreloading = AtomicBoolean(false)
    private var interstitialAd: InterstitialAd? = null

    // Banner Lifecycle & State Management
    private var bannerAdView: AdView? = null
    private var bannerState = BannerState.IDLE
    private val _bannerStateFlow = MutableStateFlow(BannerState.IDLE)
    val bannerStateFlow: StateFlow<BannerState> = _bannerStateFlow.asStateFlow()

    private var currentActivityRef: WeakReference<Activity>? = null
    private val adScope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var retryJob: Job? = null
    private var bannerRetryAttempt = 0
    private const val MAX_BANNER_RETRIES = 3
    private val BANNER_RETRY_DELAYS = listOf(15_000L, 30_000L, 60_000L)

    // Diagnostics Telemetry (Technical timing only, zero user data)
    private var bannerRequestStartTime: Long = 0L
    private var bannerLoadedTime: Long = 0L
    private var bannerLoadDurationMs: Long = 0L
    private var lastBannerFailureTime: Long = 0L
    private var lastBannerFailureReason: String? = null

    /**
     * Initializes the Google Mobile Ads SDK once per process lifecycle.
     */
    fun initialize(context: Context, onInitialized: (() -> Unit)? = null) {
        if (isMobileAdsInitialized.getAndSet(true)) {
            onInitialized?.invoke()
            return
        }

        // Initialize Google Mobile Ads SDK on a background thread
        Thread {
            try {
                MobileAds.initialize(context.applicationContext) {
                    onInitialized?.invoke()
                }
            } catch (_: Exception) {
                // Ignore initialization failures gracefully
            }
        }.start()
    }

    /**
     * Gathers consent using Google's User Messaging Platform (UMP).
     * If consent is required (e.g. in the EEA/UK), loads and presents the consent form.
     */
    fun requestConsentAndInitialize(activity: Activity, onComplete: () -> Unit = {}) {
        val consentInformation = UserMessagingPlatform.getConsentInformation(activity)
        val params = ConsentRequestParameters.Builder().build()

        consentInformation.requestConsentInfoUpdate(
            activity,
            params,
            {
                UserMessagingPlatform.loadAndShowConsentFormIfRequired(activity) { _ ->
                    if (consentInformation.canRequestAds()) {
                        initialize(activity) {
                            preloadInterstitial(activity)
                            preloadBanner(activity)
                        }
                    }
                    onComplete()
                }
            },
            { _ ->
                // Consent request failed or network unavailable; initialize safely if permitted
                if (consentInformation.canRequestAds()) {
                    initialize(activity) {
                        preloadInterstitial(activity)
                        preloadBanner(activity)
                    }
                }
                onComplete()
            }
        )
    }

    /**
     * Shows the UMP privacy options form if required in the user's region/session.
     * If not required or unavailable, safely informs the caller without crashing.
     */
    fun showPrivacyOptions(activity: Activity, onComplete: (isAvailable: Boolean, errorMsg: String?) -> Unit) {
        val consentInformation = UserMessagingPlatform.getConsentInformation(activity)
        if (consentInformation.privacyOptionsRequirementStatus == ConsentInformation.PrivacyOptionsRequirementStatus.REQUIRED) {
            UserMessagingPlatform.showPrivacyOptionsForm(activity) { formError ->
                if (consentInformation.canRequestAds()) {
                    preloadBanner(activity)
                    preloadInterstitial(activity)
                } else {
                    // Consent was revoked; immediately destroy active banner to comply with GDPR/ePrivacy
                    destroyBanner(activity)
                }
                onComplete(true, formError?.message)
            }
        } else {
            onComplete(false, null)
        }
    }

    /**
     * Begins preloading the Banner Ad as soon as UMP allows and Mobile Ads is initialized.
     * Guaranteed non-blocking and idempotent (safe to call repeatedly).
     */
    fun preloadBanner(activity: Activity) {
        if (activity.isFinishing || activity.isDestroyed) return
        currentActivityRef = WeakReference(activity)

        val consentInformation = UserMessagingPlatform.getConsentInformation(activity)
        if (!consentInformation.canRequestAds()) return

        // Ensure View instantiation and loadAd occur on the UI thread
        if (Looper.myLooper() != Looper.getMainLooper()) {
            Handler(Looper.getMainLooper()).post {
                preloadBanner(activity)
            }
            return
        }

        // Prevent duplicate load requests if already loaded or actively loading
        if (bannerState == BannerState.LOADED || bannerState == BannerState.LOADING) {
            return
        }

        loadBannerInternal(activity)
    }

    private fun loadBannerInternal(activity: Activity) {
        if (activity.isFinishing || activity.isDestroyed) return
        val consentInformation = UserMessagingPlatform.getConsentInformation(activity)
        if (!consentInformation.canRequestAds()) return

        bannerState = BannerState.LOADING
        _bannerStateFlow.value = BannerState.LOADING
        bannerRequestStartTime = System.currentTimeMillis()

        val adView = bannerAdView ?: AdView(activity).apply {
            setAdSize(AdSize.BANNER)
            adUnitId = AdConfig.BANNER_AD_UNIT_ID
            bannerAdView = this
        }

        adView.adListener = object : AdListener() {
            override fun onAdLoaded() {
                super.onAdLoaded()
                bannerState = BannerState.LOADED
                _bannerStateFlow.value = BannerState.LOADED
                bannerLoadedTime = System.currentTimeMillis()
                bannerLoadDurationMs = bannerLoadedTime - bannerRequestStartTime
                bannerRetryAttempt = 0
                retryJob?.cancel()
                retryJob = null
            }

            override fun onAdFailedToLoad(error: LoadAdError) {
                super.onAdFailedToLoad(error)
                bannerState = BannerState.FAILED
                _bannerStateFlow.value = BannerState.FAILED
                lastBannerFailureTime = System.currentTimeMillis()
                lastBannerFailureReason = "${error.code}: ${error.message}"

                // Controlled exponential backoff retry
                if (bannerRetryAttempt < MAX_BANNER_RETRIES) {
                    val delayMs = BANNER_RETRY_DELAYS.getOrElse(bannerRetryAttempt) { 60_000L }
                    bannerRetryAttempt++
                    retryJob?.cancel()
                    retryJob = adScope.launch {
                        delay(delayMs)
                        val act = currentActivityRef?.get()
                        if (act != null && !act.isFinishing && !act.isDestroyed) {
                            loadBannerInternal(act)
                        }
                    }
                }
            }
        }

        val adRequest = AdRequest.Builder().build()
        adView.loadAd(adRequest)
    }

    /**
     * Returns the active AdView for Compose display, detaching it from any prior parent.
     */
    fun getBannerView(activity: Activity?): AdView? {
        if (bannerAdView == null && activity != null && !activity.isFinishing && !activity.isDestroyed) {
            preloadBanner(activity)
        }
        bannerAdView?.let { view ->
            (view.parent as? ViewGroup)?.removeView(view)
        }
        return bannerAdView
    }

    /**
     * Safely detaches the active AdView from its current ViewGroup parent without destroying it.
     */
    fun detachBannerFromParent() {
        bannerAdView?.let { view ->
            (view.parent as? ViewGroup)?.removeView(view)
        }
    }

    fun pauseBanner() {
        bannerAdView?.pause()
    }

    fun resumeBanner() {
        bannerAdView?.resume()
    }

    /**
     * Cleanly destroys the AdView and releases references to prevent memory leaks.
     */
    fun destroyBanner(activity: Activity) {
        retryJob?.cancel()
        retryJob = null
        bannerAdView?.let { view ->
            (view.parent as? ViewGroup)?.removeView(view)
            view.destroy()
        }
        bannerAdView = null
        bannerState = BannerState.IDLE
        _bannerStateFlow.value = BannerState.IDLE
        if (currentActivityRef?.get() == activity) {
            currentActivityRef = null
        }
    }

    // Diagnostics Telemetry Methods
    fun getBannerStateName(): String = bannerState.name

    fun canRequestAds(context: Context): Boolean {
        return try {
            UserMessagingPlatform.getConsentInformation(context).canRequestAds()
        } catch (_: Exception) {
            false
        }
    }

    fun getBannerLoadDurationMs(): Long = bannerLoadDurationMs

    fun getBannerLoadDurationText(): String {
        return if (bannerLoadDurationMs > 0) "${bannerLoadDurationMs} ms" else "N/A"
    }

    fun getLastBannerRequestTimeText(): String {
        return if (bannerRequestStartTime > 0) {
            SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date(bannerRequestStartTime))
        } else "None"
    }

    fun getLastBannerLoadedTimeText(): String {
        return if (bannerLoadedTime > 0) {
            SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date(bannerLoadedTime))
        } else "None"
    }

    fun getLastBannerFailureText(): String {
        return if (lastBannerFailureTime > 0) {
            val timeStr = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date(lastBannerFailureTime))
            "$timeStr (${lastBannerFailureReason ?: "Unknown"})"
        } else "None"
    }

    /**
     * Preloads an interstitial ad if not already loaded or loading.
     */
    fun preloadInterstitial(context: Context) {
        if (interstitialAd != null || isPreloading.getAndSet(true)) {
            return
        }

        val adRequest = AdRequest.Builder().build()
        InterstitialAd.load(
            context.applicationContext,
            AdConfig.INTERSTITIAL_AD_UNIT_ID,
            adRequest,
            object : InterstitialAdLoadCallback() {
                override fun onAdLoaded(ad: InterstitialAd) {
                    isPreloading.set(false)
                    interstitialAd = ad
                }

                override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                    isPreloading.set(false)
                    interstitialAd = null
                }
            }
        )
    }

    /**
     * Attempts to show an interstitial ad if the launch threshold has been met
     * and the application is in a completely safe context.
     *
     * @param activity The current foreground Activity.
     * @param currentRoute The active Compose route.
     * @return true if an ad was displayed, false if skipped.
     */
    fun tryShowInterstitial(activity: Activity, currentRoute: String?): Boolean {
        if (activity.isFinishing || activity.isDestroyed) {
            return false
        }

        // Strict Safety Check: Never show during creation flows or non-top-level screens
        if (!isSafeRouteForInterstitial(currentRoute)) {
            return false
        }

        val counter = LaunchCounterManager.getInstance(activity)
        if (!counter.isEligibleForInterstitial()) {
            return false
        }

        val ad = interstitialAd
        if (ad == null) {
            // Not ready; skip ad and never block the user
            preloadInterstitial(activity)
            return false
        }

        ad.fullScreenContentCallback = object : FullScreenContentCallback() {
            override fun onAdDismissedFullScreenContent() {
                interstitialAd = null
                counter.onInterstitialShown()
                preloadInterstitial(activity)
            }

            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                interstitialAd = null
                preloadInterstitial(activity)
            }
        }

        ad.show(activity)
        return true
    }

    /**
     * Returns true ONLY if the current route is a relaxed, primary viewing screen.
     * Never true for Add Cat or Add Memory forms.
     */
    fun isSafeRouteForInterstitial(currentRoute: String?): Boolean {
        if (currentRoute == null) return false
        return when (currentRoute) {
            MeowoirsRoutes.HOME,
            MeowoirsRoutes.CATS,
            MeowoirsRoutes.MEMORIES,
            MeowoirsRoutes.MY_STUDY_OR_STORY -> true
            else -> false // Disallow add_cat, add_memory, etc.
        }
    }
}
