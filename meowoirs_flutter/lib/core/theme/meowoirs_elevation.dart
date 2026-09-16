import 'dart:ui';
import 'package:flutter/material.dart';

/// Meowoirs Elevation Scale.
///
/// Ported directly from the Kotlin reference implementation's Elevation.kt.
@immutable
class MeowoirsElevation extends ThemeExtension<MeowoirsElevation> {
  const MeowoirsElevation({
    this.level0 = 0.0,
    this.level1 = 2.0,
    this.level2 = 4.0,
    this.level3 = 8.0,
    this.level4 = 12.0,
  });

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;

  static const defaultElevation = MeowoirsElevation();

  @override
  MeowoirsElevation copyWith({
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
  }) {
    return MeowoirsElevation(
      level0: level0 ?? this.level0,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      level4: level4 ?? this.level4,
    );
  }

  @override
  MeowoirsElevation lerp(MeowoirsElevation? other, double t) {
    if (other is! MeowoirsElevation) return this;
    return MeowoirsElevation(
      level0: lerpDouble(level0, other.level0, t)!,
      level1: lerpDouble(level1, other.level1, t)!,
      level2: lerpDouble(level2, other.level2, t)!,
      level3: lerpDouble(level3, other.level3, t)!,
      level4: lerpDouble(level4, other.level4, t)!,
    );
  }
}
