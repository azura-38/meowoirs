import 'dart:ui';
import 'package:flutter/material.dart';

/// Meowoirs Spacing Scale.
///
/// Ported directly from the Kotlin reference implementation's Spacing.kt.
@immutable
class MeowoirsSpacing extends ThemeExtension<MeowoirsSpacing> {
  const MeowoirsSpacing({
    this.xxSmall = 2.0,
    this.extraSmall = 4.0,
    this.small = 8.0,
    this.mediumSmall = 12.0,
    this.medium = 16.0,
    this.mediumLarge = 20.0,
    this.large = 24.0,
    this.extraLarge = 32.0,
    this.sectionLarge = 48.0,
    this.sectionExtraLarge = 64.0,
  });

  final double xxSmall;
  final double extraSmall;
  final double small;
  final double mediumSmall;
  final double medium;
  final double mediumLarge;
  final double large;
  final double extraLarge;
  final double sectionLarge;
  final double sectionExtraLarge;

  static const defaultSpacing = MeowoirsSpacing();

  @override
  MeowoirsSpacing copyWith({
    double? xxSmall,
    double? extraSmall,
    double? small,
    double? mediumSmall,
    double? medium,
    double? mediumLarge,
    double? large,
    double? extraLarge,
    double? sectionLarge,
    double? sectionExtraLarge,
  }) {
    return MeowoirsSpacing(
      xxSmall: xxSmall ?? this.xxSmall,
      extraSmall: extraSmall ?? this.extraSmall,
      small: small ?? this.small,
      mediumSmall: mediumSmall ?? this.mediumSmall,
      medium: medium ?? this.medium,
      mediumLarge: mediumLarge ?? this.mediumLarge,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
      sectionLarge: sectionLarge ?? this.sectionLarge,
      sectionExtraLarge: sectionExtraLarge ?? this.sectionExtraLarge,
    );
  }

  @override
  MeowoirsSpacing lerp(MeowoirsSpacing? other, double t) {
    if (other is! MeowoirsSpacing) return this;
    return MeowoirsSpacing(
      xxSmall: lerpDouble(xxSmall, other.xxSmall, t)!,
      extraSmall: lerpDouble(extraSmall, other.extraSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      mediumSmall: lerpDouble(mediumSmall, other.mediumSmall, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      mediumLarge: lerpDouble(mediumLarge, other.mediumLarge, t)!,
      large: lerpDouble(large, other.large, t)!,
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
      sectionLarge: lerpDouble(sectionLarge, other.sectionLarge, t)!,
      sectionExtraLarge: lerpDouble(sectionExtraLarge, other.sectionExtraLarge, t)!,
    );
  }
}
