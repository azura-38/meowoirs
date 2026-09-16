import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../core/utils/turkish_suffix.dart';
import '../../data/models/cat.dart';
import '../../data/providers/database_provider.dart';
import '../../widgets/memory_card.dart';
import '../../widgets/meowoirs_button.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/meowoirs_section_header.dart';
import '../../widgets/subtle_motion.dart';

/// CatDetailScreen: Dedicated editorial memory-book page for an individual cat.
/// Direct parity with CatDetailScreen.kt.
class CatDetailScreen extends ConsumerStatefulWidget {
  const CatDetailScreen({
    super.key,
    required this.catId,
    required this.onBack,
    required this.onNavigateToEditCat,
    required this.onNavigateToAddMemory,
    required this.onNavigateToMemoryDetail,
  });

  final String catId;
  final VoidCallback onBack;
  final ValueChanged<String> onNavigateToEditCat;
  final ValueChanged<String> onNavigateToAddMemory;
  final ValueChanged<String> onNavigateToMemoryDetail;

  @override
  ConsumerState<CatDetailScreen> createState() => _CatDetailScreenState();
}

class _CatDetailScreenState extends ConsumerState<CatDetailScreen> {
  Future<void> _deleteCat(BuildContext context, AppLocalizations l10n) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteCatTitle),
        content: Text(l10n.deleteCatMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final repo = ref.read(repositoryProvider);
        await repo.deleteCat(widget.catId);
        if (mounted) {
          widget.onBack();
        }
      } catch (e) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.catDeleteError)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catAsync = ref.watch(catByIdStreamProvider(widget.catId));
    final memoriesAsync = ref.watch(catMemoriesStreamProvider(widget.catId));
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    // 1. Loading state
    if (catAsync.isLoading || memoriesAsync.isLoading) {
      return Scaffold(
        backgroundColor: colors.cream,
        body: Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: colors.orange,
              strokeWidth: 3,
            ),
          ),
        ),
      );
    }

    // 2. Not found / Invalid cat ID state
    final cat = catAsync.value;
    if (catAsync.hasError || cat == null) {
      return Scaffold(
        backgroundColor: colors.cream,
        appBar: AppBar(
          backgroundColor: colors.cream,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            tooltip: l10n.catDetailBackSemantic,
            onPressed: widget.onBack,
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.all(spacing.large),
              child: MeowoirsCard(
                padding: EdgeInsets.all(spacing.large),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.catNotFoundTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.small),
                    Text(
                      l10n.catNotFoundDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.large),
                    MeowoirsSecondaryButton(
                      text: l10n.actionBack,
                      onPressed: widget.onBack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 3. Cat Detail Content
    final memories = memoriesAsync.value ?? [];

    final isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    final storyTitle = isTurkish
        ? getCatStoryTitle(cat.name)
        : "${cat.name}'s Story";

    final memoryCountText = memories.isEmpty
        ? l10n.catDetailMemoryCountZero
        : memories.length == 1
            ? l10n.catDetailMemoryCountSingle
            : l10n.catDetailMemoryCountMultiple(memories.length);

    return Scaffold(
      backgroundColor: colors.cream,
      body: SafeArea(
        child: SubtleContentEntrance(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: l10n.catDetailBackSemantic,
                          button: true,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                            tooltip: l10n.actionBack,
                            onPressed: widget.onBack,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              label: l10n.catDetailEditSemantic,
                              button: true,
                              child: IconButton(
                                icon: Icon(Icons.edit_outlined, color: colors.textPrimary),
                                tooltip: l10n.actionEdit,
                                onPressed: () => widget.onNavigateToEditCat(cat.id),
                              ),
                            ),
                            Semantics(
                              label: l10n.catDetailDeleteSemantic,
                              button: true,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFD32F2F),
                                ),
                                tooltip: l10n.actionDelete,
                                onPressed: () => _deleteCat(context, l10n),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Scrollable Editorial Content
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(
                        left: spacing.medium,
                        right: spacing.medium,
                        top: spacing.extraSmall,
                        bottom: 100, // Avoid bottom nav / FAB overlap
                      ),
                      children: [
                        // 1. Hero Cat Photo Container (4:3)
                        _CatHeroPhoto(cat: cat),
                        SizedBox(height: spacing.medium),

                        // 2. Cat Identity Section
                        _CatIdentitySection(
                          cat: cat,
                          storyTitle: storyTitle,
                          memoryCountText: memoryCountText,
                          onAddMemoryClick: () =>
                              widget.onNavigateToAddMemory(cat.id),
                        ),
                        SizedBox(height: spacing.medium),

                        // 3. Optional Cat Note (Editorial personal note)
                        if (cat.note != null && cat.note!.trim().isNotEmpty) ...[
                          _CatNoteSection(note: cat.note!.trim()),
                          SizedBox(height: spacing.medium),
                        ],

                        // 4. Memories Section Header & Items
                        if (memories.isNotEmpty) ...[
                          MeowoirsSectionHeader(
                            title: l10n.catDetailMemoriesSectionTitle,
                            subtitle: l10n.catDetailMemoriesSectionSubtitle(memories.length),
                          ),
                          SizedBox(height: spacing.small),

                          ...memories.map((memory) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing.medium),
                              child: MemoryCard(
                                memory: memory,
                                showCatName: false,
                                onTap: () =>
                                    widget.onNavigateToMemoryDetail(memory.id),
                              ),
                            );
                          }),
                        ] else ...[
                          _EmptyMemoriesForCatCard(
                            onAddMemoryClick: () =>
                                widget.onNavigateToAddMemory(cat.id),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatHeroPhoto extends StatelessWidget {
  const _CatHeroPhoto({required this.cat});

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    final isHomeCat = cat.type == CatType.home;
    final accentContainerColor = isHomeCat
        ? colors.accentOrangeContainer
        : colors.accentSageContainer;
    final accentColor = isHomeCat ? colors.orange : colors.sage;

    return Semantics(
      label: l10n.catDetailPhotoSemantic(cat.name),
      image: true,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: accentContainerColor.withValues(alpha: 0.4),
            borderRadius: shapes.extraLargeRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: cat.photoUri != null && cat.photoUri!.isNotEmpty
              ? _buildCatImage(
                  cat.photoUri!,
                  cat.name,
                  accentContainerColor,
                  accentColor,
                  colors,
                )
              : _buildFallback(accentContainerColor, accentColor, cat.name, colors),
        ),
      ),
    );
  }

  Widget _buildCatImage(
    String uri,
    String catName,
    Color accentContainerColor,
    Color accentColor,
    MeowoirsColors colors,
  ) {
    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          semanticLabel: catName,
          errorBuilder: (_, __, ___) => _buildFallback(
            accentContainerColor,
            accentColor,
            catName,
            colors,
          ),
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          semanticLabel: catName,
          errorBuilder: (_, __, ___) => _buildFallback(
            accentContainerColor,
            accentColor,
            catName,
            colors,
          ),
        );
      }
    } catch (_) {
      // Graceful fallback on any file or formatting error
    }
    return _buildFallback(accentContainerColor, accentColor, catName, colors);
  }

  Widget _buildFallback(
    Color accentContainerColor,
    Color accentColor,
    String catName,
    MeowoirsColors colors,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accentContainerColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets_outlined,
              size: 40,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            catName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatIdentitySection extends StatelessWidget {
  const _CatIdentitySection({
    required this.cat,
    required this.storyTitle,
    required this.memoryCountText,
    required this.onAddMemoryClick,
  });

  final Cat cat;
  final String storyTitle;
  final String memoryCountText;
  final VoidCallback onAddMemoryClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    final isHomeCat = cat.type == CatType.home;
    final badgeColor = isHomeCat ? colors.orange : colors.sage;
    final badgeBg = isHomeCat
        ? colors.accentOrangeContainer
        : colors.accentSageContainer;
    final icon = isHomeCat ? Icons.home_outlined : Icons.pets_outlined;
    final typeLabel = isHomeCat ? l10n.catTypeHome : l10n.catTypeStreet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Home / Street Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.mediumSmall,
                vertical: spacing.extraSmall,
              ),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: shapes.fullRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: badgeColor),
                  SizedBox(width: spacing.extraSmall),
                  Text(
                    typeLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            // Contextual "Anı Ekle" button in header
            MeowoirsSecondaryButton(
              text: l10n.catDetailActionAddMemory,
              onPressed: onAddMemoryClick,
              icon: Icons.add,
            ),
          ],
        ),
        SizedBox(height: spacing.mediumSmall),

        // Emotional Story Title
        Text(
          storyTitle,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
        ),
        SizedBox(height: spacing.xxSmall),

        // Supporting line
        Text(
          l10n.catDetailStorySubtitle(memoryCountText),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _CatNoteSection extends StatelessWidget {
  const _CatNoteSection({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return MeowoirsCard(
      shape: shapes.largeShape,
      padding: EdgeInsets.all(spacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 24,
            color: colors.orange.withValues(alpha: 0.7),
          ),
          SizedBox(width: spacing.small),
          Expanded(
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMemoriesForCatCard extends StatelessWidget {
  const _EmptyMemoriesForCatCard({required this.onAddMemoryClick});

  final VoidCallback onAddMemoryClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    return MeowoirsCard(
      shape: shapes.largeShape,
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.accentOrangeContainer,
              borderRadius: shapes.mediumRadius,
            ),
            child: Icon(
              Icons.auto_stories_outlined,
              size: 28,
              color: colors.orange,
            ),
          ),
          SizedBox(height: spacing.medium),
          Text(
            l10n.catDetailEmptyMemoriesTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.catDetailEmptyMemoriesDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          SizedBox(
            width: double.infinity,
            child: MeowoirsPrimaryButton(
              text: l10n.catDetailEmptyMemoriesCta,
              onPressed: onAddMemoryClick,
            ),
          ),
        ],
      ),
    );
  }
}
