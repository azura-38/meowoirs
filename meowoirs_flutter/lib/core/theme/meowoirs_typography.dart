import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Meowoirs Typography System.
///
/// Ported directly from the Kotlin reference implementation's Type.kt.
/// Uses Plus Jakarta Sans with exact weights, sizes, line heights, and letter spacings.
class MeowoirsTypography {
  MeowoirsTypography._();

  static TextStyle _baseStyle({
    required double fontSize,
    required double lineHeight,
    required FontWeight fontWeight,
    required double letterSpacing,
    Color? color,
  }) {
    try {
      return GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        height: lineHeight / fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'sans-serif',
        fontSize: fontSize,
        height: lineHeight / fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color,
      );
    }
  }

  static TextTheme createTextTheme([Color? textColor]) {
    return TextTheme(
      displayLarge: _baseStyle(
        fontSize: 34,
        lineHeight: 42,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: textColor,
      ),
      displayMedium: _baseStyle(
        fontSize: 28,
        lineHeight: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: textColor,
      ),
      displaySmall: _baseStyle(
        fontSize: 24,
        lineHeight: 32,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: textColor,
      ),
      headlineLarge: _baseStyle(
        fontSize: 22,
        lineHeight: 30,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      headlineMedium: _baseStyle(
        fontSize: 20,
        lineHeight: 28,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textColor,
      ),
      headlineSmall: _baseStyle(
        fontSize: 18,
        lineHeight: 26,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleLarge: _baseStyle(
        fontSize: 17,
        lineHeight: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      titleMedium: _baseStyle(
        fontSize: 15,
        lineHeight: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: _baseStyle(
        fontSize: 14,
        lineHeight: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: textColor,
      ),
      bodyLarge: _baseStyle(
        fontSize: 16,
        lineHeight: 25,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      bodyMedium: _baseStyle(
        fontSize: 14,
        lineHeight: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      bodySmall: _baseStyle(
        fontSize: 12,
        lineHeight: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textColor,
      ),
      labelLarge: _baseStyle(
        fontSize: 14,
        lineHeight: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: textColor,
      ),
      labelMedium: _baseStyle(
        fontSize: 12,
        lineHeight: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: textColor,
      ),
      labelSmall: _baseStyle(
        fontSize: 11,
        lineHeight: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
    );
  }
}
