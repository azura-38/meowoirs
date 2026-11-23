import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../data/models/memory.dart';
import '../mood_helper.dart';
import 'memory_thumbnail.dart';

/// Küçük Simgeler (Small Icons) View:
/// Compact visual grid designed to show many memories simultaneously.
/// Emphasizes small thumbnail, mini cat mood sticker, and short title or date.
class MemorySmallIconsView extends StatelessWidget {
  const MemorySmallIconsView({
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
        final int columns = width < 380
            ? 3
            : (width < 600
                ? 4
                : (width < 900
                    ? 5
                    : 6));

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
                padding: EdgeInsets.only(bottom: spacing.small),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < columns; i++) ...[
                      if (i > 0) SizedBox(width: spacing.small),
                      if (i < row.length)
                        Expanded(
                          child: _SmallIconCard(
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

class _SmallIconCard extends StatelessWidget {
  const _SmallIconCard({
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
    final l10n = AppLocalizations.of(context);

    final sticker = CatMoodStickerMapper.buildSticker(
      mood: memory.catMood,
      size: 18.0,
      isDecorative: true,
    );

    final date = DateTime.fromMillisecondsSinceEpoch(memory.createdAt);
    String shortDate;
    try {
      final locale = Localizations.localeOf(context).languageCode;
      shortDate = DateFormat('d MMM', locale).format(date);
    } catch (_) {
      shortDate = '${date.day}.${date.month}';
    }

    final displayText = memory.note.isNotEmpty ? memory.note : shortDate;

    return Semantics(
      button: true,
      label: l10n.memoriesCardSemantic(memory.catName),
      child: Material(
        color: colors.cardBackground,
        shape: shapes.mediumShape.copyWith(
          side: BorderSide(color: colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.mediumRadius,
          child: Padding(
            padding: EdgeInsets.all(spacing.extraSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Compact Thumbnail with mini mood sticker overlay
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: MemoryThumbnail(
                        photoUri: memory.photoUri,
                        catName: memory.catName,
                        fit: BoxFit.cover,
                        borderRadius: shapes.smallRadius,
                        iconSize: 22,
                      ),
                    ),
                    if (sticker != null)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: colors.cardBackground.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: sticker,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: spacing.xxSmall),

                // 2. Short title or date
                Text(
                  displayText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
