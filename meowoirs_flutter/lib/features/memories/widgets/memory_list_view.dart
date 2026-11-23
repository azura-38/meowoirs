import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../data/models/memory.dart';
import '../mood_helper.dart';
import 'memory_thumbnail.dart';

/// Liste (List) View:
/// Compact horizontal row layout.
/// Structure:
/// [thumbnail] [title]
///            [cat name • date]
///            [mood sticker + mood]
class MemoryListView extends StatelessWidget {
  const MemoryListView({
    super.key,
    required this.memories,
    required this.onNavigateToMemoryDetail,
  });

  final List<Memory> memories;
  final ValueChanged<String> onNavigateToMemoryDetail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.meowoirsSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final memory in memories)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.small),
            child: _ListRowCard(
              memory: memory,
              onTap: () => onNavigateToMemoryDetail(memory.id),
            ),
          ),
      ],
    );
  }
}

class _ListRowCard extends StatelessWidget {
  const _ListRowCard({
    required this.memory,
    required this.onTap,
  });

  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final elevations = context.meowoirsElevation;
    final l10n = AppLocalizations.of(context);

    final date = DateTime.fromMillisecondsSinceEpoch(memory.createdAt);
    String formattedDate;
    try {
      final locale = Localizations.localeOf(context).languageCode;
      formattedDate = DateFormat('d MMMM yyyy', locale).format(date);
    } catch (_) {
      formattedDate = '${date.day}.${date.month}.${date.year}';
    }

    final sticker = CatMoodStickerMapper.buildSticker(
      mood: memory.catMood,
      size: 18.0,
      isDecorative: true,
    );
    final localizedMood = getLocalizedCatMood(memory.catMood, l10n);

    return Semantics(
      button: true,
      label: l10n.memoriesCardSemantic(memory.catName),
      child: Material(
        color: colors.cardBackground,
        elevation: elevations.level1,
        shape: shapes.mediumShape.copyWith(
          side: BorderSide(color: colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.mediumRadius,
          child: Padding(
            padding: EdgeInsets.all(spacing.mediumSmall),
            child: Row(
              children: [
                // 1. Compact Thumbnail (60x60)
                MemoryThumbnail(
                  photoUri: memory.photoUri,
                  catName: memory.catName,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  borderRadius: shapes.smallRadius,
                  iconSize: 24,
                ),
                SizedBox(width: spacing.mediumSmall),

                // 2. Information Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title / Note
                      Text(
                        memory.note,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing.xxSmall),

                      // Cat name & Date
                      Text(
                        '${memory.catName} • $formattedDate',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Mood indicator
                      if (sticker != null && localizedMood.isNotEmpty) ...[
                        SizedBox(height: spacing.xxSmall),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            sticker,
                            const SizedBox(width: 4),
                            Text(
                              localizedMood,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 3. Trailing Chevron
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
