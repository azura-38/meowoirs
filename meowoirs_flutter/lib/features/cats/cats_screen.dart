import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/providers/database_provider.dart';
import '../../widgets/cat_card.dart';
import '../../widgets/meowoirs_button.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/meowoirs_chip.dart';
import '../../widgets/subtle_motion.dart';
import 'cats_provider.dart';
import 'cats_state.dart';

/// CatsScreen: 2-column grid with filter chips, editorial header, and empty states.
/// Exact parity with CatsScreen.kt.
class CatsScreen extends ConsumerWidget {
  const CatsScreen({
    super.key,
    required this.onNavigateToAddCat,
    required this.onNavigateToCatDetail,
  });

  final VoidCallback onNavigateToAddCat;
  final ValueChanged<String> onNavigateToCatDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(catsUiStateProvider);
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    // 1. Loading state
    if (uiState.isLoading) {
      return ColoredBox(
        color: colors.cream,
        child: Center(
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

    // 2. Error state
    if (uiState.errorMessage != null) {
      return ColoredBox(
        color: colors.cream,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(spacing.large),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: colors.orange,
                ),
                SizedBox(height: spacing.medium),
                Text(
                  l10n.errorGenericOperation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                ),
                SizedBox(height: spacing.large),
                MeowoirsPrimaryButton(
                  text: l10n.actionRetry,
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

    // 3. Completely empty state (0 cats in archive)
    if (uiState.isCompletelyEmpty) {
      return ColoredBox(
        color: colors.cream,
        child: SubtleContentEntrance(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: EdgeInsets.all(spacing.medium),
                child: _EmptyCatsCard(onAddCatClick: onNavigateToAddCat),
              ),
            ),
          ),
        ),
      );
    }

    // 4. Archive content with responsive constraints
    final summary = uiState.formatSummaryText(l10n);

    return ColoredBox(
      color: colors.cream,
      child: SubtleContentEntrance(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: spacing.medium,
                    right: spacing.medium,
                    top: spacing.small,
                    bottom: uiState.isFilterEmpty ? 100 : spacing.medium,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Header section
                      _CatsHeaderSection(
                        summaryText: summary,
                        onAddCatClick: onNavigateToAddCat,
                      ),
                      SizedBox(height: spacing.medium),

                      // Filter chips row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: CatFilter.values.map((filter) {
                            final isSelected = uiState.selectedFilter == filter;
                            return Padding(
                              padding: EdgeInsets.only(right: spacing.small),
                              child: MeowoirsChip(
                                label: filter.localizedLabel(l10n),
                                isSelected: isSelected,
                                onTap: () {
                                  ref.read(catFilterProvider.notifier).state =
                                      filter;
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: spacing.medium),

                      // Filter empty card
                      if (uiState.isFilterEmpty)
                        _FilterEmptyCard(
                          filter: uiState.selectedFilter,
                          onAddCatClick: onNavigateToAddCat,
                        ),
                    ]),
                  ),
                ),

                if (!uiState.isFilterEmpty)
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: spacing.medium,
                      right: spacing.medium,
                      bottom: 100, // Avoid FAB / bottom nav overlap
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: spacing.medium,
                        mainAxisSpacing: spacing.medium,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final cat = uiState.filteredCats[index];
                          return CatCard(
                            cat: cat,
                            memoryCount: uiState.memoryCounts[cat.id],
                            onTap: () => onNavigateToCatDetail(cat.id),
                          );
                        },
                        childCount: uiState.filteredCats.length,
                      ),
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

class _CatsHeaderSection extends StatelessWidget {
  const _CatsHeaderSection({
    required this.summaryText,
    required this.onAddCatClick,
  });

  final String summaryText;
  final VoidCallback onAddCatClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.catsTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
              ),
              SizedBox(height: spacing.xxSmall),
              Text(
                summaryText.isNotEmpty
                    ? l10n.catsSubtitleWithSummary(summaryText)
                    : l10n.catsSubtitleDefault,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        MeowoirsSecondaryButton(
          text: l10n.catsActionNewCat,
          onPressed: onAddCatClick,
          icon: Icons.add,
        ),
      ],
    );
  }
}

class _EmptyCatsCard extends StatelessWidget {
  const _EmptyCatsCard({required this.onAddCatClick});

  final VoidCallback onAddCatClick;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.accentOrangeContainer,
              borderRadius: shapes.mediumRadius,
            ),
            child: Icon(
              Icons.pets_outlined,
              size: 32,
              color: colors.orange,
            ),
          ),
          SizedBox(height: spacing.medium),
          Text(
            l10n.catsEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.catsEmptyDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          SizedBox(
            width: double.infinity,
            child: MeowoirsPrimaryButton(
              text: l10n.catsEmptyAddCat,
              onPressed: onAddCatClick,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterEmptyCard extends StatelessWidget {
  const _FilterEmptyCard({
    required this.filter,
    required this.onAddCatClick,
  });

  final CatFilter filter;
  final VoidCallback onAddCatClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    final (message, ctaText) = switch (filter) {
      CatFilter.home => (
          l10n.catsFilterEmptyHome,
          l10n.catsFilterEmptyHomeCta,
        ),
      CatFilter.street => (
          l10n.catsFilterEmptyStreet,
          l10n.catsFilterEmptyStreetCta,
        ),
      CatFilter.all => (
          l10n.catsFilterEmptyAll,
          l10n.catsFilterEmptyAllCta,
        ),
    };

    return MeowoirsCard(
      shape: shapes.largeShape,
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.medium),
          MeowoirsPrimaryButton(
            text: ctaText,
            onPressed: onAddCatClick,
          ),
        ],
      ),
    );
  }
}
