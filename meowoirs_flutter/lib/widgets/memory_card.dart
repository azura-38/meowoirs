import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/meowoirs_theme.dart';
import '../data/models/memory.dart';
import '../features/memories/mood_helper.dart';
import 'meowoirs_chip.dart';

/// Editorial MemoryCard: Priority on photo, cat name, personal note, moods, and date.
/// Direct parity with MemoryCard.kt.
class MemoryCard extends StatelessWidget {
  const MemoryCard({
    super.key,
    required this.memory,
    this.showCatName = true,
    this.onTap,
  });

  final Memory memory;
  final bool showCatName;
  final VoidCallback? onTap;

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
      try {
        formattedDate = DateFormat('d MMMM yyyy').format(date);
      } catch (_) {
        formattedDate = '${date.day}.${date.month}.${date.year}';
      }
    }

    final semanticLabel = onTap != null
        ? l10n.memoriesCardSemantic(memory.catName)
        : l10n.memoryCatNoteLabel(memory.catName, memory.note);

    return Semantics(
      button: onTap != null,
      label: semanticLabel,
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
            // 1. Photograph area (4:3 editorial ratio)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.accentOrangeContainer.withValues(alpha: 0.35),
                ),
                child: memory.photoUri != null && memory.photoUri!.isNotEmpty
                    ? _buildMemoryImage(context, memory.photoUri!)
                    : _buildFallback(context),
              ),
            ),

            // 2. Content & Emotional Story area
            Padding(
              padding: EdgeInsets.all(spacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cat Name Header
                  if (showCatName) ...[
                    Text(
                      memory.catName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                    ),
                    SizedBox(height: spacing.extraSmall),
                  ],

                  // Short Note / Quote
                  Text(
                    '“${memory.note}”',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colors.textPrimary,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: spacing.mediumSmall),

                  // Mood Indicators & Context
                  if ((memory.catMood != null && memory.catMood!.trim().isNotEmpty) ||
                      (memory.userMood != null && memory.userMood!.trim().isNotEmpty)) ...[
                    Builder(
                      builder: (context) {
                        final catMoodSticker = CatMoodStickerMapper.buildSticker(
                          mood: memory.catMood,
                          size: 24.0,
                          isDecorative: true,
                        );
                        return Wrap(
                          spacing: spacing.small,
                          runSpacing: spacing.extraSmall,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (memory.catMood != null && memory.catMood!.trim().isNotEmpty) ...[
                              if (catMoodSticker != null) catMoodSticker,
                              MeowoirsChip(
                                label: getLocalizedCatMood(memory.catMood, l10n),
                                isSelected: true,
                              ),
                            ],
                            if (memory.userMood != null && memory.userMood!.trim().isNotEmpty)
                              MeowoirsChip(
                                label: '♡ ${getLocalizedUserMood(memory.userMood, l10n)}',
                                isSelected: false,
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: spacing.small),
                  ],

                  // Date
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textTertiary,
                        ),
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

  Widget _buildFallback(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 32,
            color: colors.orange.withValues(alpha: 0.5),
          ),
          SizedBox(height: spacing.extraSmall),
          Text(
            memory.catName,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryImage(BuildContext context, String uri) {
    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(context),
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(context),
        );
      }
    } catch (_) {
      // Graceful fallback on any filesystem or format error
    }
    return _buildFallback(context);
  }
}
