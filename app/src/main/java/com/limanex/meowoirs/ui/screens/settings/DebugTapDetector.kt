package com.limanex.meowoirs.ui.screens.settings

/**
 * Detects a sequence of rapid taps within a defined time window.
 *
 * Rules:
 * - Exactly [requiredTaps] (default 10) taps within approximately [windowMillis] (default 4000ms).
 * - The time window starts on the first tap of a sequence.
 * - If the elapsed time between the current tap and the first tap exceeds [windowMillis],
 *   the counter resets and the current tap counts as the first tap of a new attempt.
 * - When [requiredTaps] is reached within the window, it returns true and immediately resets.
 * - Accidental taps or slow taps never unlock the panel.
 */
class DebugTapDetector(
    private val requiredTaps: Int = 10,
    private val windowMillis: Long = 4000L
) {
    private var tapCount: Int = 0
    private var firstTapTimestamp: Long = 0L

    val currentTapCount: Int
        get() = tapCount

    /**
     * Registers a tap.
     * @param nowMillis The timestamp of the tap (defaults to system time).
     * @return true if the required number of taps was achieved within the time window.
     */
    fun onUserTap(nowMillis: Long = System.currentTimeMillis()): Boolean {
        if (firstTapTimestamp == 0L || (nowMillis - firstTapTimestamp) > windowMillis) {
            firstTapTimestamp = nowMillis
            tapCount = 1
            return false
        }

        tapCount++
        if (tapCount >= requiredTaps) {
            reset()
            return true
        }

        return false
    }

    /**
     * Resets the tap state.
     */
    fun reset() {
        tapCount = 0
        firstTapTimestamp = 0L
    }
}
