package com.limanex.meowoirs.ads

import android.content.Context
import android.content.SharedPreferences
import kotlin.random.Random

/**
 * Manages persistent tracking of genuine application sessions / launches
 * for the 5–7 launch interstitial frequency cycle.
 */
class LaunchCounterManager(context: Context) {

    private val prefs: SharedPreferences = context.applicationContext.getSharedPreferences(
        PREFS_NAME,
        Context.MODE_PRIVATE
    )

    /**
     * Session ID of the currently active app session in memory.
     * Prevents double-counting during Activity recreation (e.g., rotation, theme change).
     */
    private var currentSessionId: String? = null

    companion object {
        private const val PREFS_NAME = "meowoirs_ad_prefs"
        private const val KEY_LAUNCH_COUNT = "key_launch_count"
        private const val KEY_CURRENT_THRESHOLD = "key_current_threshold"
        private const val KEY_TOTAL_LAUNCHES = "key_total_launches"

        @Volatile
        private var instance: LaunchCounterManager? = null

        fun getInstance(context: Context): LaunchCounterManager {
            return instance ?: synchronized(this) {
                instance ?: LaunchCounterManager(context.applicationContext).also { instance = it }
            }
        }
    }

    /**
     * Current launch count in the active cycle.
     */
    val launchCount: Int
        get() = prefs.getInt(KEY_LAUNCH_COUNT, 0)

    /**
     * Total lifetime launches since app install.
     */
    val totalLifetimeLaunches: Int
        get() = prefs.getInt(KEY_TOTAL_LAUNCHES, 0)

    /**
     * Active threshold for the current cycle (5, 6, or 7).
     */
    val currentThreshold: Int
        get() {
            val saved = prefs.getInt(KEY_CURRENT_THRESHOLD, 0)
            return if (saved in AdConfig.MIN_LAUNCH_THRESHOLD..AdConfig.MAX_LAUNCH_THRESHOLD) {
                saved
            } else {
                val newThreshold = pickRandomThreshold()
                prefs.edit().putInt(KEY_CURRENT_THRESHOLD, newThreshold).apply()
                newThreshold
            }
        }

    /**
     * Records a genuine application launch.
     * Safe against Activity recreation: if [sessionId] matches the current active in-memory session,
     * it will not be counted again.
     *
     * @param sessionId unique session token generated when MainActivity is created with savedInstanceState == null.
     * @return true if the threshold has been reached and an interstitial is eligible.
     */
    @Synchronized
    fun recordGenuineLaunch(sessionId: String): Boolean {
        if (currentSessionId == sessionId) {
            // Already counted for this process/activity launch session
            return isEligibleForInterstitial()
        }

        currentSessionId = sessionId
        val newCount = launchCount + 1
        val newTotal = totalLifetimeLaunches + 1

        prefs.edit()
            .putInt(KEY_LAUNCH_COUNT, newCount)
            .putInt(KEY_TOTAL_LAUNCHES, newTotal)
            .apply()

        return isEligibleForInterstitial()
    }

    /**
     * Determines whether an interstitial ad is eligible to be shown.
     * Never eligible on launches 1 through 4.
     */
    fun isEligibleForInterstitial(): Boolean {
        val count = launchCount
        // Never on first launch or below minimum threshold
        if (count < AdConfig.MIN_LAUNCH_THRESHOLD) return false
        return count >= currentThreshold
    }

    /**
     * Called after an interstitial ad has been successfully displayed.
     * Resets the current cycle launch counter and chooses a new threshold between 5 and 7.
     */
    @Synchronized
    fun onInterstitialShown() {
        val nextThreshold = pickRandomThreshold()
        prefs.edit()
            .putInt(KEY_LAUNCH_COUNT, 0)
            .putInt(KEY_CURRENT_THRESHOLD, nextThreshold)
            .apply()
    }

    /**
     * Picks a random threshold between 5 and 7 inclusive.
     */
    fun pickRandomThreshold(): Int {
        return Random.nextInt(AdConfig.MIN_LAUNCH_THRESHOLD, AdConfig.MAX_LAUNCH_THRESHOLD + 1)
    }

    /**
     * For unit test validation only.
     */
    fun resetForTesting() {
        prefs.edit().clear().apply()
        currentSessionId = null
    }
}
