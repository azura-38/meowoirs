package com.limanex.meowoirs.ads

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.LoadAdError
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * Dedicated top Banner Ad component for Meowoirs.
 * Renders an official AdMob 320x50 banner in a visually subordinate container.
 * If the ad fails to load or is not ready, it collapses gracefully to zero height
 * without displaying error states or breaking the editorial design.
 */
@Composable
fun MeowoirsBannerAd(
    modifier: Modifier = Modifier
) {
    var isAdLoaded by remember { mutableStateOf(false) }

    if (isAdLoaded) {
        Box(
            modifier = modifier
                .fillMaxWidth()
                .background(MeowoirsTheme.colors.cream)
                .padding(vertical = 4.dp),
            contentAlignment = Alignment.Center
        ) {
            BannerViewInternal(
                onAdLoaded = { isAdLoaded = true },
                onAdFailedToLoad = { isAdLoaded = false }
            )
        }
    } else {
        // Render invisible/off-screen to allow loading without taking layout space
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(0.dp)
        ) {
            BannerViewInternal(
                onAdLoaded = { isAdLoaded = true },
                onAdFailedToLoad = { isAdLoaded = false }
            )
        }
    }
}

@Composable
private fun BannerViewInternal(
    onAdLoaded: () -> Unit,
    onAdFailedToLoad: () -> Unit
) {
    AndroidView(
        factory = { context ->
            AdView(context).apply {
                setAdSize(AdSize.BANNER)
                adUnitId = AdConfig.BANNER_AD_UNIT_ID
                adListener = object : AdListener() {
                    override fun onAdLoaded() {
                        super.onAdLoaded()
                        onAdLoaded()
                    }

                    override fun onAdFailedToLoad(error: LoadAdError) {
                        super.onAdFailedToLoad(error)
                        onAdFailedToLoad()
                    }
                }
                loadAd(AdRequest.Builder().build())
            }
        },
        update = {
            // Keep existing AdView instance without recreating on recomposition
        }
    )
}
