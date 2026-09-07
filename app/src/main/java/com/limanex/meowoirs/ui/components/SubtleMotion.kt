package com.limanex.meowoirs.ui.components

import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.offset
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * SubtleContentEntrance: Provides a calm, page-turn like entrance animation:
 * - Fades from 0f to 1f
 * - Translates vertically from 14dp to 0dp
 * - Runs for 300ms using FastOutSlowInEasing
 * - No bouncing, no particles, perfectly restrained
 */
@Composable
fun SubtleContentEntrance(
    modifier: Modifier = Modifier,
    initialOffsetY: Dp = 14.dp,
    durationMillis: Int = 300,
    content: @Composable () -> Unit
) {
    val context = androidx.compose.ui.platform.LocalContext.current
    val isReducedMotion = remember {
        try {
            android.provider.Settings.Global.getFloat(
                context.contentResolver,
                android.provider.Settings.Global.ANIMATOR_DURATION_SCALE,
                1f
            ) == 0f
        } catch (_: Exception) {
            false
        }
    }

    if (isReducedMotion) {
        Box(modifier = modifier) {
            content()
        }
        return
    }

    var isVisible by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        isVisible = true
    }

    val alpha by animateFloatAsState(
        targetValue = if (isVisible) 1f else 0f,
        animationSpec = tween(
            durationMillis = durationMillis,
            easing = FastOutSlowInEasing
        ),
        label = "contentAlpha"
    )

    val offsetYProgress by animateFloatAsState(
        targetValue = if (isVisible) 0f else 1f,
        animationSpec = tween(
            durationMillis = durationMillis,
            easing = FastOutSlowInEasing
        ),
        label = "contentOffsetY"
    )

    Box(
        modifier = modifier
            .alpha(alpha)
            .offset(y = initialOffsetY * offsetYProgress)
    ) {
        content()
    }
}
