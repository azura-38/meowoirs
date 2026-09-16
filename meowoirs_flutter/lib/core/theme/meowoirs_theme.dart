import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'meowoirs_colors.dart';
import 'meowoirs_elevation.dart';
import 'meowoirs_shapes.dart';
import 'meowoirs_spacing.dart';
import 'meowoirs_typography.dart';

export 'meowoirs_colors.dart';
export 'meowoirs_elevation.dart';
export 'meowoirs_shapes.dart';
export 'meowoirs_spacing.dart';
export 'meowoirs_typography.dart';

/// Complete Meowoirs ThemeData configuration for Light and Dark modes.
///
/// Direct parity with the Kotlin reference implementation's Theme.kt.
class MeowoirsTheme {
  MeowoirsTheme._();

  // ─── Color Schemes ──────────────────────────────────────────

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: kOrangePrimary,
    onPrimary: Colors.white,
    primaryContainer: kOrangeContainer,
    onPrimaryContainer: kDarkBrown,
    secondary: kSage,
    onSecondary: Colors.white,
    secondaryContainer: kSageContainer,
    onSecondaryContainer: kDarkBrown,
    tertiary: kLavender,
    onTertiary: Colors.white,
    tertiaryContainer: kLavenderContainer,
    onTertiaryContainer: kDarkBrown,
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    surface: kWarmSurface,
    onSurface: kDarkBrown,
    surfaceContainer: kWarmSurfaceContainer,
    surfaceContainerHigh: kWarmSurfaceContainerHigh,
    onSurfaceVariant: kTextSecondary,
    outline: kWarmBorder,
    outlineVariant: kWarmBorderSubtle,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: kDarkOrangePrimary,
    onPrimary: Color(0xFF321408),
    primaryContainer: kDarkOrangeContainer,
    onPrimaryContainer: Color(0xFFFFDBCF),
    secondary: kDarkSage,
    onSecondary: Color(0xFF0F261A),
    secondaryContainer: kDarkSageContainer,
    onSecondaryContainer: Color(0xFFD6EDE0),
    tertiary: kDarkLavender,
    onTertiary: Color(0xFF261D3B),
    tertiaryContainer: kDarkLavenderContainer,
    onTertiaryContainer: Color(0xFFEBE6F8),
    error: Color(0xFFEF5350),
    onError: Color(0xFF370B0B),
    surface: kDarkSurface,
    onSurface: kDarkTextPrimary,
    surfaceContainer: kDarkSurfaceContainer,
    surfaceContainerHigh: kDarkSurfaceContainerHigh,
    onSurfaceVariant: kDarkTextSecondary,
    outline: kDarkBorder,
    outlineVariant: kDarkBorderSubtle,
  );

  // ─── Theme Data ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    final textTheme = MeowoirsTypography.createTextTheme(kDarkBrown);
    const shapes = MeowoirsShapes.defaultShapes;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: kCream,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: kWarmSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shapes.mediumShape.copyWith(
          side: const BorderSide(color: kWarmBorderSubtle, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kCream,
        foregroundColor: kDarkBrown,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: kCream,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: textTheme.headlineMedium?.copyWith(
          color: kDarkBrown,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kOrangePrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 6,
        shape: shapes.fullShape,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kWarmSurface,
        elevation: 0,
        indicatorColor: kOrangeContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: kOrangePrimary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: kTextSecondary,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: kOrangePrimary, size: 24);
          }
          return const IconThemeData(color: kTextSecondary, size: 24);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: kWarmBorderSubtle,
        thickness: 1,
        space: 1,
      ),
      extensions: const [
        MeowoirsColors.light,
        MeowoirsSpacing.defaultSpacing,
        MeowoirsElevation.defaultElevation,
        MeowoirsShapes.defaultShapes,
      ],
    );
  }

  static ThemeData get darkTheme {
    final textTheme = MeowoirsTypography.createTextTheme(kDarkTextPrimary);
    const shapes = MeowoirsShapes.defaultShapes;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: kDarkBg,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: kDarkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shapes.mediumShape.copyWith(
          side: const BorderSide(color: kDarkBorderSubtle, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kDarkBg,
        foregroundColor: kDarkTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: kDarkBg,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: textTheme.headlineMedium?.copyWith(
          color: kDarkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kDarkOrangePrimary,
        foregroundColor: const Color(0xFF321408),
        elevation: 4,
        highlightElevation: 6,
        shape: shapes.fullShape,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kDarkSurface,
        elevation: 0,
        indicatorColor: kDarkOrangeContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: kDarkOrangePrimary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: kDarkTextSecondary,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: kDarkOrangePrimary, size: 24);
          }
          return const IconThemeData(color: kDarkTextSecondary, size: 24);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: kDarkBorderSubtle,
        thickness: 1,
        space: 1,
      ),
      extensions: const [
        MeowoirsColors.dark,
        MeowoirsSpacing.defaultSpacing,
        MeowoirsElevation.defaultElevation,
        MeowoirsShapes.defaultShapes,
      ],
    );
  }
}

/// Helper extension on [BuildContext] for ergonomic token access:
/// `context.meowoirsColors.cream`
/// `context.meowoirsSpacing.medium`
/// `context.meowoirsShapes.mediumShape`
/// `context.meowoirsElevation.level1`
extension MeowoirsThemeContext on BuildContext {
  MeowoirsColors get meowoirsColors =>
      Theme.of(this).extension<MeowoirsColors>() ?? MeowoirsColors.light;

  MeowoirsSpacing get meowoirsSpacing =>
      Theme.of(this).extension<MeowoirsSpacing>() ?? MeowoirsSpacing.defaultSpacing;

  MeowoirsElevation get meowoirsElevation =>
      Theme.of(this).extension<MeowoirsElevation>() ?? MeowoirsElevation.defaultElevation;

  MeowoirsShapes get meowoirsShapes =>
      Theme.of(this).extension<MeowoirsShapes>() ?? MeowoirsShapes.defaultShapes;
}
