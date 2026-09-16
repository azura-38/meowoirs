import 'package:flutter/material.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../core/localization/app_localizations.dart';

class MoodConstants {
  static const List<String> catMoods = [
    "Mutlu", "Meraklı", "Uykulu", "Oyuncu", "Sakin", "Sevecen"
  ];
  static const List<String> userMoods = [
    "Mutlu", "Huzurlu", "Özlemli", "Neşeli", "Sakin", "Duygusal"
  ];

  static String localizedMood(String mood, AppLocalizations l10n) {
    switch (mood) {
      case "Mutlu":
        return l10n.moodHappy;
      case "Meraklı":
        return l10n.moodCurious;
      case "Uykulu":
        return l10n.moodSleepy;
      case "Oyuncu":
        return l10n.moodPlayful;
      case "Sakin":
        return l10n.moodCalm;
      case "Sevecen":
        return l10n.moodAffectionate;
      case "Huzurlu":
        return l10n.moodPeaceful;
      case "Özlemli":
        return l10n.moodNostalgic;
      case "Neşeli":
        return l10n.moodJoyful;
      case "Duygusal":
        return l10n.moodEmotional;
      default:
        return mood;
    }
  }
}

class DualMoodSelector extends StatelessWidget {
  final String? selectedCatMood;
  final ValueChanged<String> onSelectCatMood;
  final String? selectedUserMood;
  final ValueChanged<String> onSelectUserMood;

  const DualMoodSelector({
    super.key,
    required this.selectedCatMood,
    required this.onSelectCatMood,
    required this.selectedUserMood,
    required this.onSelectUserMood,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final typography = Theme.of(context).textTheme;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cat Mood Section
        Row(
          children: [
            Icon(Icons.pets_outlined, color: colors.orange, size: 16),
            SizedBox(width: spacing.extraSmall),
            Text(
              l10n.memoryCatMoodSection,
              style: typography.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.small,
          runSpacing: spacing.small,
          children: MoodConstants.catMoods.map((mood) {
            final isSelected = selectedCatMood == mood;
            final displayMood = MoodConstants.localizedMood(mood, l10n);
            return _MoodSelectChip(
              label: displayMood,
              isSelected: isSelected,
              selectedContainerColor: colors.accentOrangeContainer,
              selectedContentColor: colors.orange,
              onClick: () => onSelectCatMood(mood),
            );
          }).toList(),
        ),

        SizedBox(height: spacing.large),

        // User Mood Section
        Row(
          children: [
            Icon(Icons.favorite_outline, color: colors.lavender, size: 16),
            SizedBox(width: spacing.extraSmall),
            Text(
              l10n.memoryUserMoodSection,
              style: typography.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.small,
          runSpacing: spacing.small,
          children: MoodConstants.userMoods.map((mood) {
            final isSelected = selectedUserMood == mood;
            final displayMood = MoodConstants.localizedMood(mood, l10n);
            return _MoodSelectChip(
              label: "♡ $displayMood",
              isSelected: isSelected,
              selectedContainerColor: colors.accentLavenderContainer,
              selectedContentColor: colors.lavender,
              onClick: () => onSelectUserMood(mood),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MoodSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedContainerColor;
  final Color selectedContentColor;
  final VoidCallback onClick;

  const _MoodSelectChip({
    required this.label,
    required this.isSelected,
    required this.selectedContainerColor,
    required this.selectedContentColor,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;
    final spacing = context.meowoirsSpacing;
    final typography = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    final containerColor = isSelected ? selectedContainerColor : colors.cardBackground;
    final contentColor = isSelected ? selectedContentColor : colors.textSecondary;
    final borderColor = isSelected ? selectedContentColor : colors.cardBorder;

    return Semantics(
      button: true,
      selected: isSelected,
      label: "$label, ${isSelected ? l10n.semanticsSelected : l10n.semanticsNotSelected}",
      child: Material(
        color: containerColor,
        shape: shapes.fullShape.copyWith(
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.mediumSmall,
              vertical: spacing.extraSmall + 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: typography.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: contentColor,
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
