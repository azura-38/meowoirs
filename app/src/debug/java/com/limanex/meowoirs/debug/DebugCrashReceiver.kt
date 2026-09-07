package com.limanex.meowoirs.debug

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Debug-only BroadcastReceiver to safely trigger a test crash via ADB.
 * Located in src/debug and excluded from release builds.
 */
class DebugCrashReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == ACTION_TEST_CRASH) {
            throw RuntimeException("Meowoirs Debug Verification Test Crash via Broadcast")
        }
    }

    companion object {
        const val ACTION_TEST_CRASH = "com.limanex.meowoirs.ACTION_TEST_CRASH"
    }
}
