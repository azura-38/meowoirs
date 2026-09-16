import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/providers/database_provider.dart';
import '../../widgets/cat_preview_card.dart';
import '../../widgets/memory_card.dart';
import '../../widgets/meowoirs_button.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/meowoirs_section_header.dart';
import '../../widgets/subtle_motion.dart';

/// Editorial Home Screen representing the emotional center of Meowoirs.
/// Exact parity with HomeScreen.kt and HomeViewModel.kt in Kotlin reference.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    this.onNavigateToCatDetail,
    this.onNavigateToMemories,
    this.onNavigateToAddMemory,
    this.onNavigateToAddCat,
    this.onNavigateToMemoryDetail,
  });

  final void Function(String catId)? onNavigateToCatDetail;
  final VoidCallback? onNavigateToMemories;
  final VoidCallback? onNavigateToAddMemory;
  final VoidCallback? onNavigateToAddCat;
  final void Function(String memoryId)? onNavigateToMemoryDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    final catsAsync = ref.watch(catsStreamProvider);
    final memoriesAsync = ref.watch(recentMemoriesStreamProvider);

    // 1. Loading State
    if (catsAsync.isLoading || memoriesAsync.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colors.orange,
          strokeWidth: 3,
        ),
      );
    }

    // 2. Error State (graceful, friendly, with retry)
    if (catsAsync.hasError || memoriesAsync.hasError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.large),
          child: MeowoirsCard(
            padding: EdgeInsets.all(spacing.large),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 48,
                  color: colors.orange,
                ),
                SizedBox(height: spacing.medium),
                Text(
                  l10n.errorGenericOperation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: spacing.large),
                MeowoirsPrimaryButton(
                  text: l10n.actionRetry,
                  onPressed: () {
                    ref.invalidate(catsStreamProvider);
                    ref.invalidate(recentMemoriesStreamProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    final cats = catsAsync.value ?? [];
    final recentMemories = memoriesAsync.value ?? [];

    // Navigation callbacks with fallbacks to authoritative GoRouter routes
    final navigateToCatDetail = onNavigateToCatDetail ??
        (catId) => context.push('/cat_detail/$catId');
    final navigateToMemories =
        onNavigateToMemories ?? () => context.go('/memories');
    final navigateToAddMemory =
        onNavigateToAddMemory ?? () => context.push('/add_memory');
    final navigateToAddCat =
        onNavigateToAddCat ?? () => context.push('/add_cat');
    final navigateToMemoryDetail = onNavigateToMemoryDetail ??
        (memoryId) => context.push('/memory_detail/$memoryId');

    // 3. State A: Completely Empty (No cats and no memories)
    final isCompletelyEmpty = cats.isEmpty && recentMemories.isEmpty;
    if (isCompletelyEmpty) {
      return SubtleContentEntrance(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: EdgeInsets.only(
                left: spacing.medium,
                right: spacing.medium,
                top: spacing.small,
                bottom: 100,
              ),
              children: [
                const HomeGreetingHeader(),
                SizedBox(height: spacing.large),
                EmptyHomeStateCard(
                  onAddMemoryClick: navigateToAddMemory,
                  onAddCatClick: navigateToAddCat,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 4. Content State (State B or C)
    final hasCatsWithoutMemories = cats.isNotEmpty && recentMemories.isEmpty;

    return SubtleContentEntrance(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: EdgeInsets.only(
              left: spacing.medium,
              right: spacing.medium,
              top: spacing.small,
              bottom: 100, // Generous padding so FAB/BottomNav don't obscure content
            ),
            children: [
              // Header Greeting
              const HomeGreetingHeader(),
              SizedBox(height: spacing.medium),

              // "Kedilerin" Section
              if (cats.isNotEmpty) ...[
                MeowoirsSectionHeader(
                  title: l10n.homeCatsSectionTitle,
                  subtitle: l10n.homeCatsSectionSubtitle(cats.length),
                ),
                SizedBox(height: spacing.extraSmall),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: spacing.extraSmall),
                    itemCount: cats.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: spacing.small),
                    itemBuilder: (context, index) {
                      final cat = cats[index];
                      return CatPreviewCard(
                        cat: cat,
                        onTap: () => navigateToCatDetail(cat.id),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing.medium),
              ],

              // "Son Anılar" Section OR State B
              if (recentMemories.isNotEmpty) ...[
                MeowoirsSectionHeader(
                  title: l10n.homeRecentMemoriesTitle,
                  actionText: l10n.homeRecentMemoriesViewAll,
                  onActionPressed: navigateToMemories,
                ),
                SizedBox(height: spacing.extraSmall),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentMemories.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: spacing.medium),
                  itemBuilder: (context, index) {
                    final memory = recentMemories[index];
                    return MemoryCard(
                      memory: memory,
                      onTap: () => navigateToMemoryDetail(memory.id),
                    );
                  },
                ),
              ] else if (hasCatsWithoutMemories) ...[
                SizedBox(height: spacing.small),
                CatsExistNoMemoriesCard(
                  onAddMemoryClick: navigateToAddMemory,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Editorial warm greeting header.
/// Direct parity with HomeGreetingHeader in HomeScreen.kt.
class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
          ),
          SizedBox(height: spacing.xxSmall),
          Text(
            l10n.tagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

/// State A: Emotional warm empty state when there are no cats and no memories yet.
/// Direct parity with EmptyHomeStateCard in HomeScreen.kt.
class EmptyHomeStateCard extends StatelessWidget {
  const EmptyHomeStateCard({
    super.key,
    required this.onAddMemoryClick,
    required this.onAddCatClick,
  });

  final VoidCallback onAddMemoryClick;
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              color: colors.orange,
              size: 32,
            ),
          ),
          SizedBox(height: spacing.medium),
          Text(
            l10n.homeEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.homeEmptyDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.large),
          MeowoirsPrimaryButton(
            text: l10n.homeEmptyAddMemory,
            onPressed: onAddMemoryClick,
            width: double.infinity,
          ),
          SizedBox(height: spacing.mediumSmall),
          InkWell(
            onTap: onAddCatClick,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.all(spacing.small),
              child: Text(
                l10n.homeEmptyAddCat,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// State B: Emotional prompt when cats exist but no memories are recorded yet.
/// Direct parity with CatsExistNoMemoriesCard in HomeScreen.kt.
class CatsExistNoMemoriesCard extends StatelessWidget {
  const CatsExistNoMemoriesCard({
    super.key,
    required this.onAddMemoryClick,
  });

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_outlined,
            color: colors.orange,
            size: 32,
          ),
          SizedBox(height: spacing.small),
          Text(
            l10n.homeCatsNoMemoriesTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.extraSmall),
          Text(
            l10n.homeCatsNoMemoriesDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.medium),
          MeowoirsPrimaryButton(
            text: l10n.homeEmptyAddMemory,
            onPressed: onAddMemoryClick,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
