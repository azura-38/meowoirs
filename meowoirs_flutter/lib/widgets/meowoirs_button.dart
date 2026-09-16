import 'package:flutter/material.dart';
import '../core/theme/meowoirs_theme.dart';

/// Primary Meowoirs Button.
/// Warm, elegant button with 48dp minimum touch target.
class MeowoirsPrimaryButton extends StatelessWidget {
  const MeowoirsPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.leadingIcon,
    this.icon,
    this.width,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? leadingIcon;
  final IconData? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final child = Row(
      mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          SizedBox(width: spacing.small),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          SizedBox(width: spacing.small),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.orange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.cardBorder,
          disabledForegroundColor: colors.textTertiary,
          elevation: 0,
          shape: shapes.fullShape,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.large,
            vertical: spacing.mediumSmall,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Secondary Meowoirs Button.
/// Subtle warm outlined button with 48dp minimum touch target.
class MeowoirsSecondaryButton extends StatelessWidget {
  const MeowoirsSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.leadingIcon,
    this.icon,
    this.width,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? leadingIcon;
  final IconData? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final child = Row(
      mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          SizedBox(width: spacing.small),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          SizedBox(width: spacing.small),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: enabled ? colors.textPrimary : colors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: 48,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          disabledForegroundColor: colors.textTertiary,
          side: BorderSide(color: colors.cardBorder),
          shape: shapes.fullShape,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.large,
            vertical: spacing.mediumSmall,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Accessible Icon Button with minimum 48dp touch target.
class MeowoirsIconButton extends StatelessWidget {
  const MeowoirsIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;

    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        icon: icon,
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: color ?? colors.textPrimary,
        ),
      ),
    );
  }
}
