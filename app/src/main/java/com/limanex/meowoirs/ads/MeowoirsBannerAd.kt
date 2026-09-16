package com.limanex.meowoirs.ads

import android.app.Activity
import android.content.ContextWrapper
import android.view.View
import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * High-performance, lifecycle-aware Banner Ad component for Meowoirs.
 * Displays a preloaded AdMob 320x50 banner in a visually harmonious container.
 * 
 * Performance & Lifecycle Guarantees:
 * - Employs preloaded AdView from AdManager with zero artificial delay.
 * - Collapses gracefully to 0.dp when unready or on failure (no layout jumps).
 * - Smoothly animates into view upon ad readiness.
 * - Reuses the loaded AdView instance across navigation without duplicate loadAd() calls.
 * - Detaches cleanly on disposal to prevent parent view leaks.
 */
@Composable
fun MeowoirsBannerAd(
    activity: Activity? = null,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val currentActivity = activity ?: (context as? Activity)
        ?: ((context as? ContextWrapper)?.baseContext as? Activity)

    val bannerState by AdManager.bannerStateFlow.collectAsState()
    val isAdLoaded = bannerState == AdManager.BannerState.LOADED

    // Preload banner immediately if not already active or preloaded
    LaunchedEffect(currentActivity) {
        if (currentActivity != null) {
            AdManager.preloadBanner(currentActivity)
        }
    }

    // Safely detach AdView from Compose parent when navigating away to allow seamless reuse
    DisposableEffect(Unit) {
        onDispose {
            AdManager.detachBannerFromParent()
        }
    }

    Box(
        modifier = modifier
            .fillMaxWidth()
            .animateContentSize(
                animationSpec = tween(durationMillis = 200)
            )
            .then(
                if (isAdLoaded) {
                    Modifier
                        .height(58.dp)
                        .background(MeowoirsTheme.colors.cream)
                        .padding(vertical = 4.dp)
                } else {
                    Modifier.height(0.dp)
                }
            ),
        contentAlignment = Alignment.Center
    ) {
        if (isAdLoaded) {
            AndroidView(
                modifier = Modifier.wrapContentSize(),
                factory = { ctx ->
                    val act = currentActivity ?: (ctx as? Activity)
                    val adView = AdManager.getBannerView(act)
                    adView ?: View(ctx)
                },
                update = {
                    // Preloaded AdView instance is maintained and kept alive across compositions
                }
            )
        }
    }
}
