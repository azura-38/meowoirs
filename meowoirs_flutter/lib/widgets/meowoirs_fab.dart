import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/meowoirs_theme.dart';

/// Elegant, prominent Floating Action Button for "Anı Ekle" (Add Memory).
/// Direct parity with MeowoirsFab.kt.
class MeowoirsFab extends StatelessWidget {
  const MeowoirsFab({
    super.key,
    required this.onPressed,
    this.text,
    this.expanded = true,
  });

  final VoidCallback onPressed;
  final String? text;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final elevations = context.meowoirsElevation;
    final l10n = AppLocalizations.of(context);
    final label = text ?? l10n.fabAddMemory;

    if (!expanded) {
      return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: colors.orange,
        foregroundColor: Colors.white,
        elevation: elevations.level2,
        focusElevation: elevations.level3,
        hoverElevation: elevations.level3,
        highlightElevation: elevations.level3,
        shape: shapes.fullShape,
        tooltip: label,
        child: const Icon(Icons.add),
      );
    }

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: colors.orange,
      foregroundColor: Colors.white,
      elevation: elevations.level2,
      focusElevation: elevations.level3,
      hoverElevation: elevations.level3,
      highlightElevation: elevations.level3,
      shape: shapes.fullShape,
      icon: const Icon(Icons.add),
      label: Padding(
        padding: EdgeInsets.only(right: spacing.extraSmall),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
