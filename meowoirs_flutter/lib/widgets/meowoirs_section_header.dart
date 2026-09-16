import 'package:flutter/material.dart';
import '../core/theme/meowoirs_theme.dart';

/// Editorial header for memory book sections.
/// Direct parity with MeowoirsSectionHeader.kt.
class MeowoirsSectionHeader extends StatelessWidget {
  const MeowoirsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.onActionClick,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onActionClick;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: spacing.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: spacing.xxSmall),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (actionText != null &&
              (onActionPressed != null || onActionClick != null)) ...[
            SizedBox(width: spacing.medium),
            InkWell(
              onTap: onActionPressed ?? onActionClick,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.small,
                  vertical: spacing.extraSmall,
                ),
                child: Text(
                  actionText!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
