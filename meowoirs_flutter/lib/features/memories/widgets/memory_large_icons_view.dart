import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../data/models/memory.dart';
import '../mood_helper.dart';
import 'memory_thumbnail.dart';

/// Büyük Simgeler (Large Icons) View:
/// Photo gallery-first layout where photos and mood stickers dominate.
/// Minimal metadata with short title and cat name.
class MemoryLargeIconsView extends StatelessWidget {
  const MemoryLargeIconsView({
    super.key,
    required this.memories,
    required this.onNavigateToMemoryDetail,
  });

  final List<Memory> memories;
  final ValueChanged<String> onNavigateToMemoryDetail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.meowoirsSpacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int columns = width < 340
            ? 1
            : (width < 640
                ? 2
                : (width < 960
                    ? 3
                    : 4));

        final List<List<Memory>> rows = [];
        for (var i = 0; i < memories.length; i += columns) {
          final end = (i + columns < memories.length) ? i + columns : memories.length;
          rows.add(memories.sublist(i, end));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final row in rows)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < columns; i++) ...[
                      if (i > 0) SizedBox(width: spacing.medium),
                      if (i < row.length)
                        Expanded(
                          child: _LargeIconCard(
                            memory: row[i],
                            onTap: () => onNavigateToMemoryDetail(row[i].id),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox.shrink()),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _LargeIconCard extends StatelessWidget {
  const _LargeIconCard({
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

    final sticker = CatMoodStickerMapper.buildSticker(
      mood: memory.catMood,
      size: 26.0,
      isDecorative: true,
    );

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Dominant Photo with overlaid mood sticker
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: MemoryThumbnail(
                      photoUri: memory.photoUri,
                      catName: memory.catName,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.zero,
                      iconSize: 36,
                    ),
                  ),
                  if (sticker != null)
                    Positioned(
                      top: spacing.extraSmall,
                      right: spacing.extraSmall,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: colors.cardBackground.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: sticker,
                      ),
                    ),
                ],
              ),

              // 2. Minimal Metadata Footer
              Padding(
                padding: EdgeInsets.all(spacing.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Text(
                      memory.catName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
