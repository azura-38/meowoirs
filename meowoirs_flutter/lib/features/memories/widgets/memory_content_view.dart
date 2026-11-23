import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../data/models/memory.dart';
import '../../../widgets/meowoirs_chip.dart';
import '../mood_helper.dart';
import 'memory_thumbnail.dart';

/// İçerik (Content) View:
/// Rich, information-dense horizontal content rows.
/// Emphasizes: medium thumbnail, cat name, date, title/excerpt (2-3 lines),
/// and cat mood sticker + localized mood chip.
class MemoryContentView extends StatelessWidget {
  const MemoryContentView({
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
            padding: EdgeInsets.only(bottom: spacing.medium),
            child: _ContentRowCard(
              memory: memory,
              onTap: () => onNavigateToMemoryDetail(memory.id),
            ),
          ),
      ],
    );
  }
}

class _ContentRowCard extends StatelessWidget {
  const _ContentRowCard({
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
      size: 22.0,
      isDecorative: true,
    );
    final localizedCatMood = getLocalizedCatMood(memory.catMood, l10n);

    return Semantics(
      button: true,
      label: l10n.memoriesCardSemantic(memory.catName),
      child: Material(
        color: colors.cardBackground,
        elevation: elevations.level1,
        shape: shapes.largeShape.copyWith(
          side: BorderSide(color: colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.largeRadius,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 320;
              final thumbSize = isCompact ? 76.0 : 96.0;

              return Padding(
                padding: EdgeInsets.all(isCompact ? spacing.small : spacing.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Medium Thumbnail
                    MemoryThumbnail(
                      photoUri: memory.photoUri,
                      catName: memory.catName,
                      width: thumbSize,
                      height: thumbSize,
                      fit: BoxFit.cover,
                      borderRadius: shapes.mediumRadius,
                      iconSize: isCompact ? 26 : 32,
                    ),
                    SizedBox(width: isCompact ? spacing.small : spacing.medium),

                    // 2. Rich Content Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header line: Cat name & Date (Wrap prevents horizontal overflow)
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              Text(
                                memory.catName,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colors.orange,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                formattedDate,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colors.textTertiary,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                      SizedBox(height: spacing.extraSmall),

                      // Memory Note / Excerpt (allowed 2-3 lines)
                      Text(
                        '“${memory.note}”',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing.small),

                      // Mood Indicators
                      if ((memory.catMood != null && memory.catMood!.trim().isNotEmpty) ||
                          (memory.userMood != null && memory.userMood!.trim().isNotEmpty)) ...[
                        Wrap(
                          spacing: spacing.small,
                          runSpacing: spacing.xxSmall,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (memory.catMood != null &&
                                memory.catMood!.trim().isNotEmpty) ...[
                              if (sticker != null) sticker,
                              MeowoirsChip(
                                label: localizedCatMood,
                                isSelected: true,
                              ),
                            ],
                            if (memory.userMood != null &&
                                memory.userMood!.trim().isNotEmpty)
                              MeowoirsChip(
                                label: '♡ ${getLocalizedUserMood(memory.userMood, l10n)}',
                                isSelected: false,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
        ),
      ),
    );
  }
}
