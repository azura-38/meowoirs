import 'package:flutter/material.dart';

/// Core Meowoirs color palette.
///
/// Ported directly from the Kotlin implementation's Color.kt.
/// All hex values are exact matches of the production reference.

// ─── Brand Colors ────────────────────────────────────────────
const Color kCream = Color(0xFFFFF9F2);
const Color kOrangePrimary = Color(0xFFE8753D);
const Color kSage = Color(0xFF79A88B);
const Color kDarkBrown = Color(0xFF594A42);
const Color kLavender = Color(0xFFA99BCB);

// ─── Light Theme Supporting Colors ───────────────────────────
const Color kWarmSurface = Color(0xFFFFFDFC);
const Color kWarmSurfaceContainer = Color(0xFFF9F3EC);
const Color kWarmSurfaceContainerHigh = Color(0xFFF3ECE4);
const Color kWarmBorder = Color(0xFFEADBCE);
const Color kWarmBorderSubtle = Color(0xFFF3EAE1);
const Color kTextPrimary = Color(0xFF594A42);
const Color kTextSecondary = Color(0xFF86756D);
const Color kTextTertiary = Color(0xFFAFA199);
const Color kOrangeHover = Color(0xFFD6662E);
const Color kOrangeContainer = Color(0xFFFFECE2);
const Color kSageContainer = Color(0xFFE8F2EC);
const Color kLavenderContainer = Color(0xFFF1EEF8);

// ─── Dark Theme Supporting Colors ────────────────────────────
const Color kDarkBg = Color(0xFF1E1714);
const Color kDarkSurface = Color(0xFF28201C);
const Color kDarkSurfaceContainer = Color(0xFF322924);
const Color kDarkSurfaceContainerHigh = Color(0xFF3E332C);
const Color kDarkBorder = Color(0xFF4B3E36);
const Color kDarkBorderSubtle = Color(0xFF3D322B);
const Color kDarkTextPrimary = Color(0xFFF8EFEA);
const Color kDarkTextSecondary = Color(0xFFC7B8B0);
const Color kDarkTextTertiary = Color(0xFF9A8B83);
const Color kDarkOrangePrimary = Color(0xFFF08B57);
const Color kDarkOrangeContainer = Color(0xFF4A2514);
const Color kDarkSage = Color(0xFF8CBDA0);
const Color kDarkSageContainer = Color(0xFF1E3326);
const Color kDarkLavender = Color(0xFFC2B6DF);
const Color kDarkLavenderContainer = Color(0xFF312845);

/// Custom Meowoirs color tokens, accessible via [Theme.of(context).extension<MeowoirsColors>()].
@immutable
class MeowoirsColors extends ThemeExtension<MeowoirsColors> {
  const MeowoirsColors({
    required this.cream,
    required this.orange,
    required this.orangeHover,
    required this.sage,
    required this.darkBrown,
    required this.lavender,
    required this.cardBackground,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accentOrangeContainer,
    required this.accentSageContainer,
    required this.accentLavenderContainer,
    required this.streetCatBadge,
    required this.streetCatBadgeContainer,
    required this.divider,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.error,
    required this.success,
    required this.disabled,
    required this.overlay,
  });

  final Color cream;
  final Color orange;
  final Color orangeHover;
  final Color sage;
  final Color darkBrown;
  final Color lavender;
  final Color cardBackground;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accentOrangeContainer;
  final Color accentSageContainer;
  final Color accentLavenderContainer;
  final Color streetCatBadge;
  final Color streetCatBadgeContainer;
  final Color divider;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color error;
  final Color success;
  final Color disabled;
  final Color overlay;

  static const light = MeowoirsColors(
    cream: kCream,
    orange: kOrangePrimary,
    orangeHover: kOrangeHover,
    sage: kSage,
    darkBrown: kDarkBrown,
    lavender: kLavender,
    cardBackground: kWarmSurface,
    cardBorder: kWarmBorderSubtle,
    textPrimary: kTextPrimary,
    textSecondary: kTextSecondary,
    textTertiary: kTextTertiary,
    accentOrangeContainer: kOrangeContainer,
    accentSageContainer: kSageContainer,
    accentLavenderContainer: kLavenderContainer,
    streetCatBadge: kSage,
    streetCatBadgeContainer: kSageContainer,
    divider: kWarmBorderSubtle,
    surfaceContainer: kWarmSurfaceContainer,
    surfaceContainerHigh: kWarmSurfaceContainerHigh,
    error: Color(0xFFD32F2F),
    success: kSage,
    disabled: kTextTertiary,
    overlay: Color(0x40000000),
  );

  static const dark = MeowoirsColors(
    cream: kDarkBg,
    orange: kDarkOrangePrimary,
    orangeHover: Color(0xFFE07840),
    sage: kDarkSage,
    darkBrown: kDarkBrown,
    lavender: kDarkLavender,
    cardBackground: kDarkSurface,
    cardBorder: kDarkBorderSubtle,
    textPrimary: kDarkTextPrimary,
    textSecondary: kDarkTextSecondary,
    textTertiary: kDarkTextTertiary,
    accentOrangeContainer: kDarkOrangeContainer,
    accentSageContainer: kDarkSageContainer,
    accentLavenderContainer: kDarkLavenderContainer,
    streetCatBadge: kDarkSage,
    streetCatBadgeContainer: kDarkSageContainer,
    divider: kDarkBorderSubtle,
    surfaceContainer: kDarkSurfaceContainer,
    surfaceContainerHigh: kDarkSurfaceContainerHigh,
    error: Color(0xFFEF5350),
    success: kDarkSage,
    disabled: kDarkTextTertiary,
    overlay: Color(0x60000000),
  );

  @override
  MeowoirsColors copyWith({
    Color? cream,
    Color? orange,
    Color? orangeHover,
    Color? sage,
    Color? darkBrown,
    Color? lavender,
    Color? cardBackground,
    Color? cardBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accentOrangeContainer,
    Color? accentSageContainer,
    Color? accentLavenderContainer,
    Color? streetCatBadge,
    Color? streetCatBadgeContainer,
    Color? divider,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? error,
    Color? success,
    Color? disabled,
    Color? overlay,
  }) {
    return MeowoirsColors(
      cream: cream ?? this.cream,
      orange: orange ?? this.orange,
      orangeHover: orangeHover ?? this.orangeHover,
      sage: sage ?? this.sage,
      darkBrown: darkBrown ?? this.darkBrown,
      lavender: lavender ?? this.lavender,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accentOrangeContainer: accentOrangeContainer ?? this.accentOrangeContainer,
      accentSageContainer: accentSageContainer ?? this.accentSageContainer,
      accentLavenderContainer: accentLavenderContainer ?? this.accentLavenderContainer,
      streetCatBadge: streetCatBadge ?? this.streetCatBadge,
      streetCatBadgeContainer: streetCatBadgeContainer ?? this.streetCatBadgeContainer,
      divider: divider ?? this.divider,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      error: error ?? this.error,
      success: success ?? this.success,
      disabled: disabled ?? this.disabled,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  MeowoirsColors lerp(MeowoirsColors? other, double t) {
    if (other is! MeowoirsColors) return this;
    return MeowoirsColors(
      cream: Color.lerp(cream, other.cream, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      orangeHover: Color.lerp(orangeHover, other.orangeHover, t)!,
      sage: Color.lerp(sage, other.sage, t)!,
      darkBrown: Color.lerp(darkBrown, other.darkBrown, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accentOrangeContainer: Color.lerp(accentOrangeContainer, other.accentOrangeContainer, t)!,
      accentSageContainer: Color.lerp(accentSageContainer, other.accentSageContainer, t)!,
      accentLavenderContainer: Color.lerp(accentLavenderContainer, other.accentLavenderContainer, t)!,
      streetCatBadge: Color.lerp(streetCatBadge, other.streetCatBadge, t)!,
      streetCatBadgeContainer: Color.lerp(streetCatBadgeContainer, other.streetCatBadgeContainer, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}
