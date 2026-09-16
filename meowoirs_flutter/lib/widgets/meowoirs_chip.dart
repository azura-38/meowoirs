import 'package:flutter/material.dart';
import '../core/theme/meowoirs_theme.dart';

enum MeowoirsMoodType {
  joyful,
  peaceful,
  playful,
  streetCat,
  gentle,
}

/// Generic tag chip for cat traits, categories, or filters.
/// Direct parity with MeowoirsChip in MeowoirsChip.kt.
class MeowoirsChip extends StatelessWidget {
  const MeowoirsChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.icon,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final targetContainerColor =
        isSelected ? colors.accentOrangeContainer : colors.cardBackground;
    final targetContentColor =
        isSelected ? colors.orange : colors.textSecondary;
    final targetBorderColor =
        isSelected ? colors.orange : colors.cardBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        color: targetContainerColor,
        borderRadius: shapes.fullRadius,
        border: Border.all(color: targetBorderColor, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.fullRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.mediumSmall,
              vertical: spacing.extraSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: spacing.extraSmall),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: targetContentColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Distinct emotional and contextual badge (e.g. Joyful, Peaceful, Street Cat).
/// Direct parity with MeowoirsMoodChip in MeowoirsChip.kt.
class MeowoirsMoodChip extends StatelessWidget {
  const MeowoirsMoodChip({
    super.key,
    required this.mood,
    required this.label,
    this.onTap,
  });

  final MeowoirsMoodType mood;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final (Color bgColor, Color tintColor) = switch (mood) {
      MeowoirsMoodType.joyful => (
          colors.accentOrangeContainer,
          colors.orange,
        ),
      MeowoirsMoodType.peaceful => (
          colors.accentSageContainer,
          colors.sage,
        ),
      MeowoirsMoodType.playful => (
          colors.accentLavenderContainer,
          colors.lavender,
        ),
      MeowoirsMoodType.streetCat => (
          colors.streetCatBadgeContainer,
          colors.streetCatBadge,
        ),
      MeowoirsMoodType.gentle => (
          colors.cardBackground,
          colors.textSecondary,
        ),
    };

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: shapes.fullRadius,
        side: BorderSide(
          color: tintColor.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: shapes.fullRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.small + 2.0,
            vertical: spacing.extraSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: tintColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing.small),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: tintColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
