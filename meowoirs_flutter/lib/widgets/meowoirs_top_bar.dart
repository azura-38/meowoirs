import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/meowoirs_theme.dart';

/// Warm, minimalist top app bar with editorial styling.
/// Direct parity with MeowoirsTopBar.kt.
class MeowoirsTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MeowoirsTopBar({
    super.key,
    required this.title,
    this.canNavigateBack = false,
    this.onNavigateBack,
    this.actions,
    this.backgroundColor,
  });

  final String title;
  final bool canNavigateBack;
  final VoidCallback? onNavigateBack;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;

    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: canNavigateBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: AppLocalizations.of(context).actionBack,
              color: colors.textPrimary,
              onPressed: onNavigateBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
    );
  }
}
