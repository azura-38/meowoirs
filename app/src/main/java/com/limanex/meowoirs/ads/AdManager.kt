package com.limanex.meowoirs.ads

import android.app.Activity
import android.content.Context
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.google.android.ump.ConsentInformation
import com.google.android.ump.ConsentRequestParameters
import com.google.android.ump.UserMessagingPlatform
import com.limanex.meowoirs.ui.navigation.MeowoirsRoutes
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Central orchestrator for AdMob initialization, UMP consent flow,
 * and interstitial ad lifecycle management in Meowoirs.
 */
object AdManager {

    private val isMobileAdsInitialized = AtomicBoolean(false)
    private val isPreloading = AtomicBoolean(false)
    private var interstitialAd: InterstitialAd? = null

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
                onComplete(true, formError?.message)
            }
        } else {
            onComplete(false, null)
        }
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
