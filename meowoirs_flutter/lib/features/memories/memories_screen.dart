import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/models/cat.dart';
import '../../data/providers/database_provider.dart';
import '../../widgets/meowoirs_button.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/meowoirs_chip.dart';
import '../../widgets/subtle_motion.dart';
import 'memories_provider.dart';
import 'widgets/memories_view_menu.dart';
import 'widgets/memories_view_switcher.dart';

/// MemoriesScreen: Chronological archive of memories with cat filter chips.
/// Direct parity with MemoriesScreen.kt.
class MemoriesScreen extends ConsumerWidget {
  const MemoriesScreen({
    super.key,
    required this.onNavigateToCatDetail,
    required this.onNavigateToMemoryDetail,
    required this.onNavigateToAddMemory,
  });

  final ValueChanged<String> onNavigateToCatDetail;
  final ValueChanged<String> onNavigateToMemoryDetail;
  final ValueChanged<String?> onNavigateToAddMemory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(memoriesUiStateProvider);
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

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

    if (uiState.errorMessage != null && uiState.allMemories.isEmpty) {
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
                  l10n.memoriesErrorTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.small),
                Text(
                  l10n.memoriesErrorDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.large),
                MeowoirsPrimaryButton(
                  text: l10n.memoriesErrorRetry,
                  onPressed: () {
                    ref.invalidate(allMemoriesStreamProvider);
                    ref.invalidate(catsStreamProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: colors.cream,
      child: SubtleContentEntrance(
        child: ListView(
          padding: EdgeInsets.only(
            left: spacing.medium,
            right: spacing.medium,
            top: spacing.small,
            bottom: 100, // FAB clearance
          ),
          children: [
            // 1. Editorial Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          l10n.memoriesTitle,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                        ),
                      ),
                      SizedBox(height: spacing.xxSmall),
                      Text(
                        l10n.memoriesSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.small),
                MemoriesViewMenu(
                  currentMode: uiState.viewMode,
                  onModeSelected: (mode) {
                    ref
                        .read(memoriesViewModeProvider.notifier)
                        .setViewMode(mode);
                  },
                ),
              ],
            ),
            SizedBox(height: spacing.medium),

            // 2. Cat Filter Chips
            if (uiState.availableCats.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MeowoirsChip(
                      label: l10n.memoriesFilterAll,
                      isSelected: uiState.selectedCatFilterId == null,
                      onTap: () {
                        ref.read(selectedCatFilterIdProvider.notifier).state =
                            null;
                      },
                    ),
                    ...uiState.availableCats.map((cat) {
                      final isSelected = uiState.selectedCatFilterId == cat.id;
                      return Padding(
                        padding: EdgeInsets.only(left: spacing.small),
                        child: MeowoirsChip(
                          label: cat.name,
                          isSelected: isSelected,
                          onTap: () {
                            ref
                                .read(selectedCatFilterIdProvider.notifier)
                                .state = cat.id;
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: spacing.medium),
            ],

            // 3. Content States
            if (uiState.isCompletelyEmpty)
              _GlobalEmptyMemoriesCard(
                onAddMemoryClick: () => onNavigateToAddMemory(null),
              )
            else if (uiState.isFilterEmpty)
              _FilterEmptyMemoriesCard(
                cat: uiState.selectedCat,
                onAddMemoryClick: () =>
                    onNavigateToAddMemory(uiState.selectedCatFilterId),
              )
            else
              MemoriesViewSwitcher(
                viewMode: uiState.viewMode,
                memories: uiState.filteredMemories,
                onNavigateToMemoryDetail: onNavigateToMemoryDetail,
              ),
          ],
        ),
      ),
    );
  }
}

class _GlobalEmptyMemoriesCard extends StatelessWidget {
  const _GlobalEmptyMemoriesCard({required this.onAddMemoryClick});

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
            l10n.memoriesGlobalEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.memoriesGlobalEmptyDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          SizedBox(
            width: double.infinity,
            child: MeowoirsPrimaryButton(
              text: l10n.memoriesGlobalEmptyCta,
              onPressed: onAddMemoryClick,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterEmptyMemoriesCard extends StatelessWidget {
  const _FilterEmptyMemoriesCard({
    required this.cat,
    required this.onAddMemoryClick,
  });

  final Cat? cat;
  final VoidCallback onAddMemoryClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);
    final catName = cat?.name ?? 'Bu kedi';

    return MeowoirsCard(
      shape: shapes.largeShape,
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.accentOrangeContainer,
              borderRadius: shapes.mediumRadius,
            ),
            child: Icon(
              Icons.pets_outlined,
              size: 26,
              color: colors.orange,
            ),
          ),
          SizedBox(height: spacing.medium),
          Text(
            l10n.memoriesFilterEmptyTitle(catName),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.memoriesFilterEmptyDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          SizedBox(
            width: double.infinity,
            child: MeowoirsSecondaryButton(
              text: l10n.memoriesFilterEmptyCta,
              onPressed: onAddMemoryClick,
            ),
          ),
        ],
      ),
    );
  }
}
