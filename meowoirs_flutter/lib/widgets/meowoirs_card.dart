import 'package:flutter/material.dart';
import '../core/theme/meowoirs_theme.dart';

/// Central card container for memory entries, cat profiles, and editorial content.
/// Direct parity with MeowoirsCard.kt.
class MeowoirsCard extends StatelessWidget {
  const MeowoirsCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.shape,
    this.elevation,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final ShapeBorder? shape;
  final double? elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final elevations = context.meowoirsElevation;

    final resolvedRadius = borderRadius ?? shapes.mediumRadius;
    final border = BorderSide(
      color: borderColor ?? colors.cardBorder,
      width: 1.0,
    );

    final cardChild = Padding(
      padding: padding ?? EdgeInsets.all(spacing.medium),
      child: child,
    );

    return Material(
      color: backgroundColor ?? colors.cardBackground,
      elevation: elevation ?? elevations.level1,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: resolvedRadius,
            side: border,
          ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: resolvedRadius as BorderRadius?,
              child: cardChild,
            )
          : cardChild,
    );
  }
}
