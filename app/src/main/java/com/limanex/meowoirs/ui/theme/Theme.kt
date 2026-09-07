package com.limanex.meowoirs.ui.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

// Material 3 Light Color Scheme
private val LightColorScheme = lightColorScheme(
    primary = OrangePrimary,
    onPrimary = Color.White,
    primaryContainer = OrangeContainer,
    onPrimaryContainer = DarkBrown,
    secondary = Sage,
    onSecondary = Color.White,
    secondaryContainer = SageContainer,
    onSecondaryContainer = DarkBrown,
    tertiary = Lavender,
    onTertiary = Color.White,
    tertiaryContainer = LavenderContainer,
    onTertiaryContainer = DarkBrown,
    background = Cream,
    onBackground = DarkBrown,
    surface = WarmSurface,
    onSurface = DarkBrown,
    surfaceVariant = WarmSurfaceContainer,
    onSurfaceVariant = TextSecondary,
    outline = WarmBorder,
    outlineVariant = WarmBorderSubtle
)

// Material 3 Dark Color Scheme (warm espresso, not sterile black)
private val DarkColorScheme = darkColorScheme(
    primary = DarkOrangePrimary,
    onPrimary = Color(0xFF321408),
    primaryContainer = DarkOrangeContainer,
    onPrimaryContainer = Color(0xFFFFDBCF),
    secondary = DarkSage,
    onSecondary = Color(0xFF0F261A),
    secondaryContainer = DarkSageContainer,
    onSecondaryContainer = Color(0xFFD6EDE0),
    tertiary = DarkLavender,
    onTertiary = Color(0xFF261D3B),
    tertiaryContainer = DarkLavenderContainer,
    onTertiaryContainer = Color(0xFFEBE6F8),
    background = DarkBg,
    onBackground = DarkTextPrimary,
    surface = DarkSurface,
    onSurface = DarkTextPrimary,
    surfaceVariant = DarkSurfaceContainer,
    onSurfaceVariant = DarkTextSecondary,
    outline = DarkBorder,
    outlineVariant = DarkBorderSubtle
)

@Composable
fun MeowoirsTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    val customColors = if (darkTheme) DarkCustomColors else LightCustomColors
    val spacing = MeowoirsSpacing()
    val elevation = MeowoirsElevation()

    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as? Activity)?.window
            if (window != null) {
                // Ensure edge to edge status bar icon appearance matches theme
                val insetsController = WindowCompat.getInsetsController(window, view)
                insetsController.isAppearanceLightStatusBars = !darkTheme
                insetsController.isAppearanceLightNavigationBars = !darkTheme
            }
        }
    }

    CompositionLocalProvider(
        LocalMeowoirsColors provides customColors,
        LocalMeowoirsSpacing provides spacing,
        LocalMeowoirsElevation provides elevation
    ) {
        MaterialTheme(
            colorScheme = colorScheme,
            typography = MeowoirsTypography,
            shapes = MeowoirsShapes,
            content = content
        )
    }
}

/**
 * Access object for Meowoirs Design System tokens
 */
object MeowoirsTheme {
    val colors: MeowoirsCustomColors
        @Composable
        @ReadOnlyComposable
        get() = LocalMeowoirsColors.current

    val spacing: MeowoirsSpacing
        @Composable
        @ReadOnlyComposable
        get() = LocalMeowoirsSpacing.current

    val elevations: MeowoirsElevation
        @Composable
        @ReadOnlyComposable
        get() = LocalMeowoirsElevation.current

    val typography: androidx.compose.material3.Typography
        @Composable
        @ReadOnlyComposable
        get() = MaterialTheme.typography

    val shapes: androidx.compose.material3.Shapes
        @Composable
        @ReadOnlyComposable
        get() = MaterialTheme.shapes
}
