import 'dart:ui';
import 'package:flutter/material.dart';

/// Meowoirs Shapes and Corner Radius Scale.
///
/// Ported directly from the Kotlin reference implementation's Shape.kt.
@immutable
class MeowoirsShapes extends ThemeExtension<MeowoirsShapes> {
  const MeowoirsShapes({
    this.extraSmall = 6.0,
    this.small = 10.0,
    this.medium = 16.0,
    this.large = 22.0,
    this.extraLarge = 28.0,
    this.full = 999.0,
  });

  final double extraSmall;
  final double small;
  final double medium;
  final double large;
  final double extraLarge;
  final double full;

  static const defaultShapes = MeowoirsShapes();

  // Convenience BorderRadius getters
  BorderRadius get extraSmallRadius => BorderRadius.circular(extraSmall);
  BorderRadius get smallRadius => BorderRadius.circular(small);
  BorderRadius get mediumRadius => BorderRadius.circular(medium);
  BorderRadius get largeRadius => BorderRadius.circular(large);
  BorderRadius get extraLargeRadius => BorderRadius.circular(extraLarge);
  BorderRadius get fullRadius => BorderRadius.circular(full);

  // Convenience ShapeBorder getters
  RoundedRectangleBorder get extraSmallShape => RoundedRectangleBorder(borderRadius: extraSmallRadius);
  RoundedRectangleBorder get smallShape => RoundedRectangleBorder(borderRadius: smallRadius);
  RoundedRectangleBorder get mediumShape => RoundedRectangleBorder(borderRadius: mediumRadius);
  RoundedRectangleBorder get largeShape => RoundedRectangleBorder(borderRadius: largeRadius);
  RoundedRectangleBorder get extraLargeShape => RoundedRectangleBorder(borderRadius: extraLargeRadius);
  RoundedRectangleBorder get fullShape => RoundedRectangleBorder(borderRadius: fullRadius);

  @override
  MeowoirsShapes copyWith({
    double? extraSmall,
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
    double? full,
  }) {
    return MeowoirsShapes(
      extraSmall: extraSmall ?? this.extraSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
      full: full ?? this.full,
    );
  }

  @override
  MeowoirsShapes lerp(MeowoirsShapes? other, double t) {
    if (other is! MeowoirsShapes) return this;
    return MeowoirsShapes(
      extraSmall: lerpDouble(extraSmall, other.extraSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}
