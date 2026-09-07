package com.limanex.meowoirs

import com.limanex.meowoirs.ui.screens.settings.DebugTapDetector
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class DebugTapDetectorTest {

    @Test
    fun testSuccessfulTenTapsWithinFourSeconds() {
        val detector = DebugTapDetector(requiredTaps = 10, windowMillis = 4000L)
        val startTime = 10_000L

        // Taps 1 through 9: should return false
        for (i in 1..9) {
            val tapTime = startTime + (i - 1) * 200L // 0, 200, 400, ... 1600ms
            val result = detector.onUserTap(tapTime)
            assertFalse("Tap $i should not unlock", result)
            assertEquals("Tap count should match", i, detector.currentTapCount)
        }

        // 10th tap at 1800ms (well within 4000ms)
        val tenthTapResult = detector.onUserTap(startTime + 1800L)
        assertTrue("10th tap within 4 seconds must unlock", tenthTapResult)
        assertEquals("Counter must reset to 0 after unlock", 0, detector.currentTapCount)
    }

    @Test
    fun testNineTapsDoesNotUnlock() {
        val detector = DebugTapDetector(requiredTaps = 10, windowMillis = 4000L)
        val startTime = 10_000L

        for (i in 1..9) {
            assertFalse(detector.onUserTap(startTime + i * 100L))
        }
        assertEquals(9, detector.currentTapCount)
    }

    @Test
    fun testTimeoutResetsCounter() {
        val detector = DebugTapDetector(requiredTaps = 10, windowMillis = 4000L)
        val startTime = 10_000L

        // Tap 5 times quickly starting at startTime (t = 0, 100, 200, 300, 400)
        for (i in 0 until 5) {
            detector.onUserTap(startTime + i * 100L)
        }
        assertEquals(5, detector.currentTapCount)

        // Wait 4001ms after the first tap (startTime + 4001L)
        val timedOutTap = detector.onUserTap(startTime + 4001L)
        assertFalse("Tap after timeout should not unlock", timedOutTap)
        // This tap starts a new window, so count is 1
        assertEquals("Count should reset to 1 on first tap of new window", 1, detector.currentTapCount)
    }

    @Test
    fun testSlowTapsNeverUnlock() {
        val detector = DebugTapDetector(requiredTaps = 10, windowMillis = 4000L)
        var currentTime = 10_000L

        // Tap 10 times spaced 1 second apart (total 9 seconds)
        for (i in 1..10) {
            val result = detector.onUserTap(currentTime)
            assertFalse("Slow tap $i should not unlock", result)
            currentTime += 1000L
        }
    }

    @Test
    fun testManualReset() {
        val detector = DebugTapDetector(requiredTaps = 10, windowMillis = 4000L)
        detector.onUserTap(1000L)
        detector.onUserTap(1200L)
        assertEquals(2, detector.currentTapCount)

        detector.reset()
        assertEquals(0, detector.currentTapCount)
    }
}
