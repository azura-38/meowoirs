package com.limanex.meowoirs

import com.limanex.meowoirs.ads.AdConfig
import com.limanex.meowoirs.ads.AdManager
import com.limanex.meowoirs.ui.navigation.MeowoirsRoutes
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import kotlin.random.Random

/**
 * Unit tests verifying AdMob configuration constants, threshold ranges,
 * and route safety logic for interstitials.
 */
class AdSystemTest {

    @Test
    fun testAdConfigConstants() {
        assertEquals("ca-app-pub-587701117866406~4355156867", AdConfig.APPLICATION_ID)
        assertEquals("ca-app-pub-587701117866406/2930394553", AdConfig.BANNER_AD_UNIT_ID)
        assertEquals("ca-app-pub-587701117866406/2195897382", AdConfig.INTERSTITIAL_AD_UNIT_ID)
        assertEquals(5, AdConfig.MIN_LAUNCH_THRESHOLD)
        assertEquals(7, AdConfig.MAX_LAUNCH_THRESHOLD)
    }

    @Test
    fun testThresholdRange() {
        repeat(100) {
            val threshold = Random.nextInt(AdConfig.MIN_LAUNCH_THRESHOLD, AdConfig.MAX_LAUNCH_THRESHOLD + 1)
            assertTrue("Threshold must be >= 5", threshold >= 5)
            assertTrue("Threshold must be <= 7", threshold <= 7)
        }
    }

    @Test
    fun testSafeRoutesForInterstitial() {
        // Safe top-level browsing screens
        assertTrue(AdManager.isSafeRouteForInterstitial(MeowoirsRoutes.HOME))
        assertTrue(AdManager.isSafeRouteForInterstitial(MeowoirsRoutes.CATS))
        assertTrue(AdManager.isSafeRouteForInterstitial(MeowoirsRoutes.MEMORIES))
        assertTrue(AdManager.isSafeRouteForInterstitial(MeowoirsRoutes.MY_STUDY_OR_STORY))

        // Strict exclusion for input / creation forms
        assertFalse(AdManager.isSafeRouteForInterstitial(MeowoirsRoutes.ADD_CAT))
        assertFalse(AdManager.isSafeRouteForInterstitial(MeowoirsRoutes.ADD_MEMORY))
        assertFalse(AdManager.isSafeRouteForInterstitial("add_memory?catId=123"))
        assertFalse(AdManager.isSafeRouteForInterstitial(null))
    }
}
