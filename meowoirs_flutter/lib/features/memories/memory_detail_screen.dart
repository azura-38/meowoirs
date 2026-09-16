import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/providers/database_provider.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/meowoirs_chip.dart';
import '../../widgets/subtle_motion.dart';

/// MemoryDetailScreen: Viewing full memory details, personal note, and moods.
/// Direct parity with MemoryDetailScreen.kt.
class MemoryDetailScreen extends ConsumerStatefulWidget {
  const MemoryDetailScreen({
    super.key,
    required this.memoryId,
    required this.onBack,
    required this.onNavigateToEditMemory,
    required this.onNavigateToCatDetail,
  });

  final String memoryId;
  final VoidCallback onBack;
  final ValueChanged<String> onNavigateToEditMemory;
  final ValueChanged<String> onNavigateToCatDetail;

  @override
  ConsumerState<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends ConsumerState<MemoryDetailScreen> {
  bool _isDeleting = false;

  Future<void> _deleteMemory(AppLocalizations l10n) async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteMemoryTitle),
        content: Text(l10n.deleteMemoryMessage),
        actions: [
          TextButton(
            onPressed: () {
              if (!_isDeleting) {
                Navigator.of(dialogContext).pop(false);
              }
            },
            child: Text(l10n.actionCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            onPressed: _isDeleting
                ? null
                : () => Navigator.of(dialogContext).pop(true),
            child: Text(_isDeleting ? l10n.loading : l10n.actionDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      if (_isDeleting) return;
      setState(() => _isDeleting = true);
      try {
        final repo = ref.read(repositoryProvider);
        await repo.deleteMemory(widget.memoryId);
        if (mounted) {
          widget.onBack();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isDeleting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memoryDeleteError)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final memoryAsync = ref.watch(memoryByIdStreamProvider(widget.memoryId));
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final typography = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    if (memoryAsync.isLoading || _isDeleting) {
      return Scaffold(
        backgroundColor: colors.cream,
        body: Center(
          child: CircularProgressIndicator(
            color: colors.orange,
            strokeWidth: 3,
          ),
        ),
      );
    }

    final memory = memoryAsync.value;
    if (memory == null) {
      return Scaffold(
        backgroundColor: colors.cream,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(spacing.small),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    tooltip: l10n.actionBack,
                    onPressed: widget.onBack,
                  ),
                ),
              ),
              Expanded(
                child: _MemoryNotFoundView(
                  onBack: widget.onBack,
                  colors: colors,
                  spacing: spacing,
                  shapes: shapes,
                  typography: typography,
                  l10n: l10n,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final localeStr = Localizations.localeOf(context).toString();
    String formattedDate;
    try {
      formattedDate = DateFormat.yMMMMd(localeStr).format(
        DateTime.fromMillisecondsSinceEpoch(memory.createdAt),
      );
    } catch (_) {
      formattedDate = DateFormat('d MMMM yyyy', 'tr').format(
        DateTime.fromMillisecondsSinceEpoch(memory.createdAt),
      );
    }

    return Scaffold(
      backgroundColor: colors.cream,
      body: SafeArea(
        child: SubtleContentEntrance(
          child: Column(
            children: [
              // Top Navigation & Action Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.small,
                  vertical: spacing.extraSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                      tooltip: l10n.actionBack,
                      onPressed: widget.onBack,
                    ),
                    Text(
                      l10n.memoryDetailTitle,
                      style: typography.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: colors.textPrimary,
                          ),
                          tooltip: l10n.actionEdit,
                          onPressed: () =>
                              widget.onNavigateToEditMemory(memory.id),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFD32F2F),
                          ),
                          tooltip: l10n.actionDelete,
                          onPressed: () => _deleteMemory(l10n),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Details
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(spacing.large),
                  children: [
                    // Memory Photo (if exists)
                    if (memory.photoUri != null &&
                        memory.photoUri!.trim().isNotEmpty) ...[
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            borderRadius: shapes.largeRadius,
                            border: Border.all(color: colors.cardBorder),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Semantics(
                            label: l10n.memoryDetailTitle,
                            child: _buildImage(
                              memory.photoUri!,
                              colors,
                              l10n,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.medium),
                    ],

                    // Cat Badge & Date Meta Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Clickable Cat Badge
                        Material(
                          color: colors.accentOrangeContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: shapes.fullRadius,
                            side: BorderSide(
                              color: colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: InkWell(
                            onTap: () =>
                                widget.onNavigateToCatDetail(memory.catId),
                            borderRadius: shapes.fullRadius,
                            child: Semantics(
                              button: true,
                              label: memory.catName,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing.mediumSmall,
                                  vertical: spacing.extraSmall,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pets_outlined,
                                      size: 16,
                                      color: colors.orange,
                                    ),
                                    SizedBox(width: spacing.extraSmall),
                                    Text(
                                      memory.catName,
                                      style: typography.labelMedium?.copyWith(
                                        color: colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Formatted Date
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: colors.textTertiary,
                            ),
                            SizedBox(width: spacing.extraSmall),
                            Text(
                              formattedDate,
                              style: typography.labelSmall?.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.large),

                    // Note / Story Section
                    if (memory.note.trim().isNotEmpty) ...[
                      MeowoirsCard(
                        shape: shapes.largeShape,
                        padding: EdgeInsets.all(spacing.large),
                        child: Text(
                          memory.note,
                          style: typography.bodyLarge?.copyWith(
                            color: colors.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.large),
                    ],

                    // Mood Badges Section
                    if ((memory.catMood != null &&
                            memory.catMood!.trim().isNotEmpty) ||
                        (memory.userMood != null &&
                            memory.userMood!.trim().isNotEmpty)) ...[
                      Text(
                        l10n.memoryMoodSectionTitle,
                        style: typography.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: spacing.small),

                      Wrap(
                        spacing: spacing.small,
                        runSpacing: spacing.small,
                        children: [
                          if (memory.catMood != null &&
                              memory.catMood!.trim().isNotEmpty)
                            MeowoirsChip(
                              label: l10n.memoryCatMoodFormat(memory.catMood!),
                              icon: const Icon(Icons.pets_outlined, size: 16),
                              isSelected: false,
                            ),
                          if (memory.userMood != null &&
                              memory.userMood!.trim().isNotEmpty)
                            MeowoirsChip(
                              label:
                                  l10n.memoryUserMoodFormat(memory.userMood!),
                              icon: const Icon(
                                Icons.sentiment_satisfied_outlined,
                                size: 16,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildImage(
    String uri,
    MeowoirsColors colors,
    AppLocalizations l10n,
  ) {
    Widget errorFallback = Center(
      child: Icon(
        Icons.pets_outlined,
        size: 40,
        color: colors.orange,
        semanticLabel: l10n.photoLoadFailed,
      ),
    );

    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => errorFallback,
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => errorFallback,
        );
      }
    } catch (_) {
      return errorFallback;
    }
    return errorFallback;
  }
}

class _MemoryNotFoundView extends StatelessWidget {
  const _MemoryNotFoundView({
    required this.onBack,
    required this.colors,
    required this.spacing,
    required this.shapes,
    required this.typography,
    required this.l10n,
  });

  final VoidCallback onBack;
  final MeowoirsColors colors;
  final MeowoirsSpacing spacing;
  final MeowoirsShapes shapes;
  final TextTheme typography;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.accentOrangeContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.pets_outlined,
                  size: 36,
                  color: colors.orange,
                ),
              ),
            ),
            SizedBox(height: spacing.medium),
            Text(
              l10n.memoryNotFoundTitle,
              style: typography.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.extraSmall),
            Text(
              l10n.memoryNotFoundDesc,
              style: typography.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.large),
            ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.mediumRadius,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.large,
                  vertical: spacing.mediumSmall,
                ),
              ),
              child: Text(l10n.actionBack),
            ),
          ],
        ),
      ),
    );
  }
}
