import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../models/memories_view_mode.dart';

/// Toolbar control and popup menu for selecting the active Memories view mode.
/// Follows Windows File Explorer view concept tailored for Meowoirs.
class MemoriesViewMenu extends StatelessWidget {
  const MemoriesViewMenu({
    super.key,
    required this.currentMode,
    required this.onModeSelected,
  });

  final MemoriesViewMode currentMode;
  final ValueChanged<MemoriesViewMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: l10n.memoriesViewMenuSemantic,
      child: PopupMenuButton<MemoriesViewMode>(
        tooltip: l10n.memoriesViewMenuLabel,
        initialValue: currentMode,
        onSelected: onModeSelected,
        color: colors.cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: shapes.mediumShape.copyWith(
          side: BorderSide(color: colors.cardBorder),
        ),
        position: PopupMenuPosition.under,
        itemBuilder: (context) => [
          _buildPopupItem(
            context,
            mode: MemoriesViewMode.tiles,
            label: l10n.memoriesViewModeTiles,
            icon: Icons.grid_view_rounded,
          ),
          _buildPopupItem(
            context,
            mode: MemoriesViewMode.largeIcons,
            label: l10n.memoriesViewModeLargeIcons,
            icon: Icons.photo_size_select_actual_outlined,
          ),
          _buildPopupItem(
            context,
            mode: MemoriesViewMode.smallIcons,
            label: l10n.memoriesViewModeSmallIcons,
            icon: Icons.apps_rounded,
          ),
          _buildPopupItem(
            context,
            mode: MemoriesViewMode.list,
            label: l10n.memoriesViewModeList,
            icon: Icons.view_list_rounded,
          ),
          _buildPopupItem(
            context,
            mode: MemoriesViewMode.content,
            label: l10n.memoriesViewModeContent,
            icon: Icons.view_agenda_outlined,
          ),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.small,
            vertical: spacing.extraSmall,
          ),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: shapes.fullRadius,
            border: Border.all(color: colors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForMode(currentMode),
                size: 16,
                color: colors.orange,
              ),
              SizedBox(width: spacing.extraSmall),
              Text(
                l10n.memoriesViewMenuLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<MemoriesViewMode> _buildPopupItem(
    BuildContext context, {
    required MemoriesViewMode mode,
    required String label,
    required IconData icon,
  }) {
    final colors = context.meowoirsColors;
    final isSelected = mode == currentMode;

    return PopupMenuItem<MemoriesViewMode>(
      value: mode,
      child: Semantics(
        selected: isSelected,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? colors.orange : colors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? colors.orange : colors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.normal,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: 18,
                color: colors.orange,
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconForMode(MemoriesViewMode mode) {
    switch (mode) {
      case MemoriesViewMode.tiles:
        return Icons.grid_view_rounded;
      case MemoriesViewMode.largeIcons:
        return Icons.photo_size_select_actual_outlined;
      case MemoriesViewMode.smallIcons:
        return Icons.apps_rounded;
      case MemoriesViewMode.list:
        return Icons.view_list_rounded;
      case MemoriesViewMode.content:
        return Icons.view_agenda_outlined;
    }
  }
}
