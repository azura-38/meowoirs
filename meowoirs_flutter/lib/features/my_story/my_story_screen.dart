import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/models/cat.dart';
import '../../data/models/memory.dart';
import '../../data/providers/database_provider.dart';
import '../../domain/story/story_metrics.dart';
import '../../domain/story/story_metrics_calculator.dart';
import '../../widgets/cat_preview_card.dart';
import '../../widgets/memory_card.dart';
import '../../widgets/meowoirs_button.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/meowoirs_section_header.dart';
import '../../widgets/subtle_motion.dart';

/// MyStoryScreen: Personal narrative, metrics, and memory timeline.
/// Direct parity with MyStoryScreen.kt.
class MyStoryScreen extends ConsumerWidget {
  const MyStoryScreen({
    super.key,
    required this.onNavigateToCats,
    required this.onNavigateToCatDetail,
    required this.onNavigateToAddMemory,
    required this.onNavigateToAddCat,
  });

  final VoidCallback onNavigateToCats;
  final ValueChanged<String> onNavigateToCatDetail;
  final VoidCallback onNavigateToAddMemory;
  final VoidCallback onNavigateToAddCat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(catsStreamProvider);
    final memoriesAsync = ref.watch(allMemoriesStreamProvider);

    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    if (catsAsync.isLoading || memoriesAsync.isLoading) {
      return Scaffold(
        backgroundColor: colors.cream,
        body: Center(
          child: CircularProgressIndicator(color: colors.orange),
        ),
      );
    }

    if (catsAsync.hasError || memoriesAsync.hasError) {
      return Scaffold(
        backgroundColor: colors.cream,
        appBar: AppBar(
          backgroundColor: colors.cream,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(spacing.large),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: colors.orange),
                SizedBox(height: spacing.medium),
                Text(
                  l10n.myStoryErrorTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.small),
                Text(
                  l10n.myStoryErrorDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.large),
                MeowoirsPrimaryButton(
                  text: l10n.myStoryErrorRetry,
                  onPressed: () {
                    ref.invalidate(catsStreamProvider);
                    ref.invalidate(allMemoriesStreamProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    final cats = catsAsync.value ?? [];
    final memories = memoriesAsync.value ?? [];
    final metrics = StoryMetricsCalculator.calculate(cats, memories);

    final isCompletelyEmpty = cats.isEmpty && memories.isEmpty;
    final hasCatsWithoutMemories = cats.isNotEmpty && memories.isEmpty;

    return Scaffold(
      backgroundColor: colors.cream,
      appBar: AppBar(
        backgroundColor: colors.cream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SubtleContentEntrance(
          child: ListView(
            padding: EdgeInsets.only(
              left: spacing.medium,
              right: spacing.medium,
              top: spacing.extraSmall,
              bottom: 100, // Clearance
            ),
            children: [
              // 1. Editorial Header
              Semantics(
                header: true,
                child: Text(
                  l10n.myStoryTitle,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
              ),
              SizedBox(height: spacing.xxSmall),
              Text(
                l10n.myStorySubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
              ),
              SizedBox(height: spacing.large),

              // 2. Content States
              if (isCompletelyEmpty) ...[
                _CompletelyEmptyStoryCard(
                  onNavigateToAddMemory: onNavigateToAddMemory,
                  onNavigateToAddCat: onNavigateToAddCat,
                ),
              ] else if (hasCatsWithoutMemories) ...[
                // Story Hero Narrative
                _StoryHeroCard(summary: metrics.getLocalizedNarrative(l10n)),
                SizedBox(height: spacing.large),

                // Statistics
                _StoryStatsRow(metrics: metrics),
                SizedBox(height: spacing.large),

                // Cats Section
                _CatsHorizontalSection(
                  cats: cats,
                  onNavigateToCats: onNavigateToCats,
                  onNavigateToCatDetail: onNavigateToCatDetail,
                ),
                SizedBox(height: spacing.large),

                // Partial Empty
                _CatsWithoutMemoriesCard(
                  onAddMemoryClick: onNavigateToAddMemory,
                ),
              ] else ...[
                // Full Populated State
                _StoryHeroCard(summary: metrics.getLocalizedNarrative(l10n)),
                SizedBox(height: spacing.large),

                _StoryStatsRow(metrics: metrics),
                SizedBox(height: spacing.large),

                if (cats.isNotEmpty) ...[
                  _CatsHorizontalSection(
                    cats: cats,
                    onNavigateToCats: onNavigateToCats,
                    onNavigateToCatDetail: onNavigateToCatDetail,
                  ),
                  SizedBox(height: spacing.large),
                ],

                // Most Remembered Cat
                if (metrics.mostRememberedCat != null &&
                    metrics.mostRememberedCount > 0) ...[
                  _MostRememberedCatCard(
                    cat: metrics.mostRememberedCat!,
                    memoryCount: metrics.mostRememberedCount,
                    onTap: () =>
                        onNavigateToCatDetail(metrics.mostRememberedCat!.id),
                  ),
                  SizedBox(height: spacing.large),
                ],

                // Recent Moment (Son Anın)
                if (metrics.latestMemory != null) ...[
                  MeowoirsSectionHeader(title: l10n.myStoryRecentMoment),
                  SizedBox(height: spacing.small),
                  MemoryCard(
                    memory: metrics.latestMemory!,
                    showCatName: true,
                    onTap: () =>
                        onNavigateToCatDetail(metrics.latestMemory!.catId),
                  ),
                  SizedBox(height: spacing.large),
                ],

                // Story Beginning (İlk Anın)
                if (metrics.earliestMemory != null) ...[
                  _StoryBeginningCard(memory: metrics.earliestMemory!),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryHeroCard extends StatelessWidget {
  const _StoryHeroCard({required this.summary});

  final String summary;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_outlined,
                  size: 20, color: colors.orange),
              SizedBox(width: spacing.small),
              Text(
                l10n.myStoryYourStory,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
              ),
            ],
          ),
          SizedBox(height: spacing.small),
          Text(
            summary,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _StoryStatsRow extends StatelessWidget {
  const _StoryStatsRow({required this.metrics});

  final StoryMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _StatPill(count: metrics.totalCats, label: l10n.statCats),
        ),
        SizedBox(width: spacing.small),
        Expanded(
          child: _StatPill(count: metrics.totalMemories, label: l10n.statMemories),
        ),
        SizedBox(width: spacing.small),
        Expanded(
          child: _StatPill(count: metrics.homeCatsCount, label: l10n.statHome),
        ),
        SizedBox(width: spacing.small),
        Expanded(
          child: _StatPill(count: metrics.streetCatsCount, label: l10n.statStreet),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;

    return MeowoirsCard(
      shape: shapes.mediumShape,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _CatsHorizontalSection extends StatelessWidget {
  const _CatsHorizontalSection({
    required this.cats,
    required this.onNavigateToCats,
    required this.onNavigateToCatDetail,
  });

  final List<Cat> cats;
  final VoidCallback onNavigateToCats;
  final ValueChanged<String> onNavigateToCatDetail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MeowoirsSectionHeader(
          title: l10n.myStoryCatsSection,
          actionText: l10n.myStorySeeAll,
          onActionClick: onNavigateToCats,
        ),
        SizedBox(height: spacing.small),
        SizedBox(
          height: 125,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cats.length,
            separatorBuilder: (_, __) => SizedBox(width: spacing.mediumSmall),
            itemBuilder: (context, index) {
              final cat = cats[index];
              return CatPreviewCard(
                cat: cat,
                onTap: () => onNavigateToCatDetail(cat.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MostRememberedCatCard extends StatelessWidget {
  const _MostRememberedCatCard({
    required this.cat,
    required this.memoryCount,
    required this.onTap,
  });

  final Cat cat;
  final int memoryCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    final isHomeCat = cat.type == CatType.home;
    final accentColor = isHomeCat ? colors.orange : colors.sage;
    final accentContainerColor = isHomeCat
        ? colors.accentOrangeContainer
        : colors.accentSageContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star_outline, size: 18, color: colors.orange),
            SizedBox(width: spacing.extraSmall),
            Text(
              l10n.myStoryMostRememberedTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
            ),
          ],
        ),
        SizedBox(height: spacing.small),

        Semantics(
          button: true,
          label: l10n.myStoryMostRememberedSemantic(cat.name, memoryCount),
          child: MeowoirsCard(
            shape: shapes.largeShape,
            padding: EdgeInsets.all(spacing.medium),
            child: InkWell(
              onTap: onTap,
              borderRadius: shapes.largeRadius,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: accentContainerColor,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: cat.photoUri != null && cat.photoUri!.isNotEmpty
                        ? _buildCatImage(cat.photoUri!)
                        : Icon(Icons.pets_outlined,
                            size: 28, color: accentColor),
                  ),
                  SizedBox(width: spacing.medium),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.myStoryMostRememberedSubtitle(memoryCount),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: accentColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.chevron_right,
                      size: 24, color: colors.textTertiary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCatImage(String uri) {
    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.pets_outlined, size: 28),
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.pets_outlined, size: 28),
        );
      }
    } catch (_) {}
    return const Icon(Icons.pets_outlined, size: 28);
  }
}

class _StoryBeginningCard extends StatelessWidget {
  const _StoryBeginningCard({required this.memory});

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
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

    return Semantics(
      label: l10n.myStoryBeginningSemantic(formattedDate),
      child: MeowoirsCard(
        shape: shapes.largeShape,
        padding: EdgeInsets.all(spacing.large),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.accentLavenderContainer,
                borderRadius: shapes.mediumRadius,
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                size: 24,
                color: colors.lavender,
              ),
            ),
            SizedBox(width: spacing.medium),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myStoryBeginningTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletelyEmptyStoryCard extends StatelessWidget {
  const _CompletelyEmptyStoryCard({
    required this.onNavigateToAddMemory,
    required this.onNavigateToAddCat,
  });

  final VoidCallback onNavigateToAddMemory;
  final VoidCallback onNavigateToAddCat;

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
            l10n.myStoryCompletelyEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.myStoryCompletelyEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          SizedBox(
            width: double.infinity,
            child: MeowoirsPrimaryButton(
              text: l10n.myStoryCompletelyEmptyAddMemory,
              onPressed: onNavigateToAddMemory,
            ),
          ),
          SizedBox(height: spacing.small),
          SizedBox(
            width: double.infinity,
            child: MeowoirsSecondaryButton(
              text: l10n.myStoryCompletelyEmptyAddCat,
              onPressed: onNavigateToAddCat,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatsWithoutMemoriesCard extends StatelessWidget {
  const _CatsWithoutMemoriesCard({required this.onAddMemoryClick});

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
          Text(
            l10n.myStoryPartialEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.myStoryPartialEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          SizedBox(
            width: double.infinity,
            child: MeowoirsPrimaryButton(
              text: l10n.myStoryPartialEmptyAddMemory,
              onPressed: onAddMemoryClick,
            ),
          ),
        ],
      ),
    );
  }
}

