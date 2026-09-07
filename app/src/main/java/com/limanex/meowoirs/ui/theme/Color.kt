package com.limanex.meowoirs.ui.theme

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

// Core Meowoirs Palette
val Cream = Color(0xFFFFF9F2)
val OrangePrimary = Color(0xFFE8753D)
val Sage = Color(0xFF79A88B)
val DarkBrown = Color(0xFF594A42)
val Lavender = Color(0xFFA99BCB)

// Supporting Warm Neutrals & Accents (Light)
val WarmSurface = Color(0xFFFFFDFC)
val WarmSurfaceContainer = Color(0xFFF9F3EC)
val WarmSurfaceContainerHigh = Color(0xFFF3ECE4)
val WarmBorder = Color(0xFFEADBCE)
val WarmBorderSubtle = Color(0xFFF3EAE1)
val TextPrimary = Color(0xFF594A42)
val TextSecondary = Color(0xFF86756D)
val TextTertiary = Color(0xFFAFA199)
val OrangeHover = Color(0xFFD6662E)
val OrangeContainer = Color(0xFFFFECE2)
val SageContainer = Color(0xFFE8F2EC)
val LavenderContainer = Color(0xFFF1EEF8)

// Supporting Warm Neutrals & Accents (Dark)
val DarkBg = Color(0xFF1E1714)
val DarkSurface = Color(0xFF28201C)
val DarkSurfaceContainer = Color(0xFF322924)
val DarkSurfaceContainerHigh = Color(0xFF3E332C)
val DarkBorder = Color(0xFF4B3E36)
val DarkBorderSubtle = Color(0xFF3D322B)
val DarkTextPrimary = Color(0xFFF8EFEA)
val DarkTextSecondary = Color(0xFFC7B8B0)
val DarkTextTertiary = Color(0xFF9A8B83)
val DarkOrangePrimary = Color(0xFFF08B57)
val DarkOrangeContainer = Color(0xFF4A2514)
val DarkSage = Color(0xFF8CBDA0)
val DarkSageContainer = Color(0xFF1E3326)
val DarkLavender = Color(0xFFC2B6DF)
val DarkLavenderContainer = Color(0xFF312845)

@Immutable
data class MeowoirsCustomColors(
    val cream: Color,
    val orange: Color,
    val sage: Color,
    val darkBrown: Color,
    val lavender: Color,
    val cardBackground: Color,
    val cardBorder: Color,
    val textPrimary: Color,
    val textSecondary: Color,
    val textTertiary: Color,
    val accentOrangeContainer: Color,
    val accentSageContainer: Color,
    val accentLavenderContainer: Color,
    val streetCatBadge: Color,
    val streetCatBadgeContainer: Color,
    val divider: Color
)

val LightCustomColors = MeowoirsCustomColors(
    cream = Cream,
    orange = OrangePrimary,
    sage = Sage,
    darkBrown = DarkBrown,
    lavender = Lavender,
    cardBackground = WarmSurface,
    cardBorder = WarmBorderSubtle,
    textPrimary = TextPrimary,
    textSecondary = TextSecondary,
    textTertiary = TextTertiary,
    accentOrangeContainer = OrangeContainer,
    accentSageContainer = SageContainer,
    accentLavenderContainer = LavenderContainer,
    streetCatBadge = Sage,
    streetCatBadgeContainer = SageContainer,
    divider = WarmBorderSubtle
)

val DarkCustomColors = MeowoirsCustomColors(
    cream = DarkBg,
    orange = DarkOrangePrimary,
    sage = DarkSage,
    darkBrown = DarkBrown,
    lavender = DarkLavender,
    cardBackground = DarkSurface,
    cardBorder = DarkBorderSubtle,
    textPrimary = DarkTextPrimary,
    textSecondary = DarkTextSecondary,
    textTertiary = DarkTextTertiary,
    accentOrangeContainer = DarkOrangeContainer,
    accentSageContainer = DarkSageContainer,
    accentLavenderContainer = DarkLavenderContainer,
    streetCatBadge = DarkSage,
    streetCatBadgeContainer = DarkSageContainer,
    divider = DarkBorderSubtle
)

val LocalMeowoirsColors = staticCompositionLocalOf { LightCustomColors }
