import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/subtle_motion.dart';

/// Represents a single upcoming feature card on the [ComingSoonScreen].
///
/// Intentionally excludes version numbers, version badges, and release dates.
@immutable
class ComingSoonFeatureItem {
  const ComingSoonFeatureItem({
    required this.index,
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentTone,
  });

  final int index;
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final ComingSoonAccentTone accentTone;
}

enum ComingSoonAccentTone {
  orange,
  lavender,
  sage,
}

/// Dedicated "Coming Soon" screen displaying Meowoirs' upcoming features
/// in a warm, cozy, cat-themed editorial layout.
///
/// Strictly displays no version numbers (`v0.2`–`v0.9`) or release dates.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  static const String headerCatAsset = 'assets/images/avatars/01_cat_happy.png';

  /// Returns the 8 upcoming features in their required product order.
  static List<ComingSoonFeatureItem> buildFeatures(AppLocalizations l10n) {
    return [
      ComingSoonFeatureItem(
        index: 1,
        id: 'memory_collage',
        title: l10n.comingSoonFeature1Title,
        description: l10n.comingSoonFeature1Desc,
        icon: Icons.collections_rounded,
        accentTone: ComingSoonAccentTone.orange,
      ),
      ComingSoonFeatureItem(
        index: 2,
        id: 'cat_timeline',
        title: l10n.comingSoonFeature2Title,
        description: l10n.comingSoonFeature2Desc,
        icon: Icons.timeline_rounded,
        accentTone: ComingSoonAccentTone.lavender,
      ),
      ComingSoonFeatureItem(
        index: 3,
        id: 'on_this_day',
        title: l10n.comingSoonFeature3Title,
        description: l10n.comingSoonFeature3Desc,
        icon: Icons.today_rounded,
        accentTone: ComingSoonAccentTone.sage,
      ),
      ComingSoonFeatureItem(
        index: 4,
        id: 'our_story',
        title: l10n.comingSoonFeature4Title,
        description: l10n.comingSoonFeature4Desc,
        icon: Icons.menu_book_rounded,
        accentTone: ComingSoonAccentTone.orange,
      ),
      ComingSoonFeatureItem(
        index: 5,
        id: 'memory_reminders',
        title: l10n.comingSoonFeature5Title,
        description: l10n.comingSoonFeature5Desc,
        icon: Icons.notifications_none_rounded,
        accentTone: ComingSoonAccentTone.lavender,
      ),
      ComingSoonFeatureItem(
        index: 6,
        id: 'archive_improvements',
        title: l10n.comingSoonFeature6Title,
        description: l10n.comingSoonFeature6Desc,
        icon: Icons.manage_search_rounded,
        accentTone: ComingSoonAccentTone.sage,
      ),
      ComingSoonFeatureItem(
        index: 7,
        id: 'shareable_memory_designs',
        title: l10n.comingSoonFeature7Title,
        description: l10n.comingSoonFeature7Desc,
        icon: Icons.share_rounded,
        accentTone: ComingSoonAccentTone.orange,
      ),
      ComingSoonFeatureItem(
        index: 8,
        id: 'personal_archive_tools',
        title: l10n.comingSoonFeature8Title,
        description: l10n.comingSoonFeature8Desc,
        icon: Icons.folder_special_rounded,
        accentTone: ComingSoonAccentTone.lavender,
      ),
    ];
  }

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final features = buildFeatures(l10n);

    return Scaffold(
      backgroundColor: colors.cream,
      appBar: AppBar(
        backgroundColor: colors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          key: const Key('coming_soon_back_button'),
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          tooltip: l10n.actionBack,
          onPressed: () => _handleBack(context),
        ),
        title: Text(
          l10n.comingSoonPageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SubtleContentEntrance(
          child: ListView.separated(
            key: const Key('coming_soon_scroll_view'),
            padding: EdgeInsets.only(
              left: spacing.medium,
              right: spacing.medium,
              top: spacing.small,
              bottom: spacing.extraLarge,
            ),
            itemCount: features.length + 1,
            separatorBuilder: (_, index) => SizedBox(
              height: index == 0 ? spacing.large : spacing.medium,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _ComingSoonHeaderCard(
                  key: const Key('coming_soon_header_card'),
                  title: l10n.comingSoonPageTitle,
                  introText: l10n.comingSoonHeaderIntro,
                );
              }
              final feature = features[index - 1];
              return _ComingSoonFeatureCard(
                key: Key('coming_soon_feature_${feature.index}'),
                feature: feature,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ComingSoonHeaderCard extends StatelessWidget {
  const _ComingSoonHeaderCard({
    super.key,
    required this.title,
    required this.introText,
  });

  final String title;
  final String introText;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return MeowoirsCard(
      shape: shapes.largeShape,
      backgroundColor: colors.cardBackground,
      borderColor: colors.lavender.withValues(alpha: 0.35),
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Decorative illustration row with stars, paws, and Meowoirs cat avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: colors.lavender,
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.pets_rounded,
                size: 16,
                color: colors.orange.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 14),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colors.accentLavenderContainer,
                      colors.accentOrangeContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: colors.lavender.withValues(alpha: 0.6),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.lavender.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      ComingSoonScreen.headerCatAsset,
                      key: const Key('coming_soon_cat_illustration'),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.pets_rounded,
                        size: 38,
                        color: colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Icon(
                Icons.pets_rounded,
                size: 16,
                color: colors.lavender.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: colors.orange,
              ),
            ],
          ),
          SizedBox(height: spacing.medium),

          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.small),

          Text(
            introText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  height: 1.45,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ComingSoonFeatureCard extends StatelessWidget {
  const _ComingSoonFeatureCard({
    super.key,
    required this.feature,
  });

  final ComingSoonFeatureItem feature;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final (Color iconColor, Color containerColor) =
        switch (feature.accentTone) {
      ComingSoonAccentTone.orange => (
          colors.orange,
          colors.accentOrangeContainer,
        ),
      ComingSoonAccentTone.lavender => (
          colors.lavender,
          colors.accentLavenderContainer,
        ),
      ComingSoonAccentTone.sage => (
          colors.sage,
          colors.accentSageContainer,
        ),
    };

    return MeowoirsCard(
      shape: shapes.largeShape,
      backgroundColor: colors.cardBackground,
      padding: EdgeInsets.all(spacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: shapes.mediumRadius,
            ),
            child: Icon(
              feature.icon,
              size: 24,
              color: iconColor,
            ),
          ),
          SizedBox(width: spacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        feature.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.pets_rounded,
                      size: 13,
                      color: iconColor.withValues(alpha: 0.55),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

