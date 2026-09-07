package com.limanex.meowoirs.ads

/**
 * AdMob configuration constants for Meowoirs.
 * Uses exact production IDs provided in PROMPT 11.
 */
object AdConfig {
    /**
     * Google AdMob Application ID (configured in AndroidManifest.xml).
     */
    const val APPLICATION_ID = "ca-app-pub-587701117866406~4355156867"

    /**
     * Production Banner Ad Unit ID.
     */
    const val BANNER_AD_UNIT_ID = "ca-app-pub-587701117866406/2930394553"

    /**
     * Production Interstitial Ad Unit ID.
     */
    const val INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-587701117866406/2195897382"

    /**
     * Minimum launch count required before any interstitial can be considered (never on 1-4).
     */
    const val MIN_LAUNCH_THRESHOLD = 5

    /**
     * Maximum launch count in an interstitial trigger cycle.
     */
    const val MAX_LAUNCH_THRESHOLD = 7
}
