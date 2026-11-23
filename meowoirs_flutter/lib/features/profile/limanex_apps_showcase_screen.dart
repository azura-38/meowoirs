import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/subtle_motion.dart';

/// Data model representing an app in the LIMANEX Studio showcase.
/// Structured so additional LIMANEX apps can be added in the future without
/// redesigning the showcase screen.
@immutable
class LimanexAppShowcaseItem {
  const LimanexAppShowcaseItem({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.iconAssetPath,
    required this.promoAssetPath,
    required this.ctaLabel,
    required this.storeUrl,
    this.webFallbackUrl,
  });

  final String id;
  final String name;
  final String tagline;
  final String description;
  final String iconAssetPath;
  final String promoAssetPath;
  final String ctaLabel;
  final String storeUrl;
  final String? webFallbackUrl;
}

/// Dedicated LIMANEX Studio / "Try Our Other Apps" showcase screen.
///
/// Contains two vertically arranged visual sections on a single scrollable page:
/// 1. LIMANEX Studio introduction header with official logo and downward cue.
/// 2. Prominent VitaCase showcase card (extensible for future studio apps).
class LimanexAppsShowcaseScreen extends StatefulWidget {
  const LimanexAppsShowcaseScreen({
    super.key,
    this.onBack,
    this.appsOverride,
    this.urlLauncherOverride,
    this.simulateMissingPromoAsset = false,
  });

  final VoidCallback? onBack;
  final List<LimanexAppShowcaseItem>? appsOverride;
  final Future<bool> Function(Uri uri)? urlLauncherOverride;
  final bool simulateMissingPromoAsset;

  static const String limanexFullLogoAsset =
      'assets/images/limanex_logo_full.png';
  static const String limanexIconLogoAsset =
      'assets/images/limanex_logo_icon.png';
  static const String vitaCaseIconAsset = 'assets/images/vitacase_icon.png';
  static const String vitaCasePromoAsset = 'assets/images/vitacase_promo.png';

  /// Default list of LIMANEX showcase apps localized for the active context.
  static List<LimanexAppShowcaseItem> defaultApps(AppLocalizations l10n) {
    return [
      LimanexAppShowcaseItem(
        id: 'vitacase',
        name: l10n.vitaCaseAppName,
        tagline: l10n.vitaCaseTagline,
        description: l10n.vitaCaseDescription,
        iconAssetPath: vitaCaseIconAsset,
        promoAssetPath: vitaCasePromoAsset,
        ctaLabel: l10n.vitaCaseCtaExplore,
        storeUrl: AppConfig.vitaCasePlayStoreUrl,
        webFallbackUrl: AppConfig.vitaCaseWebUrl,
      ),
    ];
  }

  @override
  State<LimanexAppsShowcaseScreen> createState() =>
      _LimanexAppsShowcaseScreenState();
}

class _LimanexAppsShowcaseScreenState extends State<LimanexAppsShowcaseScreen> {
  bool _isLaunching = false;

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleLaunchApp(
    LimanexAppShowcaseItem item,
    AppLocalizations l10n,
  ) async {
    if (_isLaunching) return;
    setState(() => _isLaunching = true);

    try {
      final primaryUri = Uri.tryParse(item.storeUrl.trim());
      bool launched = false;

      if (primaryUri != null && item.storeUrl.trim().isNotEmpty) {
        launched = await _tryLaunchUri(primaryUri);
      }

      if (!launched &&
          item.webFallbackUrl != null &&
          item.webFallbackUrl!.trim().isNotEmpty) {
        final fallbackUri = Uri.tryParse(item.webFallbackUrl!.trim());
        if (fallbackUri != null) {
          launched = await _tryLaunchUri(fallbackUri);
        }
      }

      if (!launched && mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              key: const Key('vitacase_fallback_snackbar'),
              content: Text(l10n.vitaCaseLaunchFallbackMessage),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              key: const Key('vitacase_fallback_snackbar'),
              content: Text(l10n.vitaCaseLaunchFallbackMessage),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    } finally {
      if (mounted) {
        setState(() => _isLaunching = false);
      }
    }
  }

  Future<bool> _tryLaunchUri(Uri uri) async {
    if (widget.urlLauncherOverride != null) {
      return widget.urlLauncherOverride!(uri);
    }
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final apps =
        widget.appsOverride ?? LimanexAppsShowcaseScreen.defaultApps(l10n);

    return Scaffold(
      backgroundColor: colors.cream,
      appBar: AppBar(
        backgroundColor: colors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          key: const Key('limanex_showcase_back_button'),
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          tooltip: l10n.actionBack,
          onPressed: _handleBack,
        ),
        title: Text(
          l10n.limanexAppsPageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SubtleContentEntrance(
          child: ListView(
            key: const Key('limanex_showcase_scroll_view'),
            padding: EdgeInsets.only(
              left: spacing.medium,
              right: spacing.medium,
              top: spacing.small,
              bottom: spacing.extraLarge,
            ),
            children: [
              // Section 1 — LIMANEX Studio Introduction
              _LimanexStudioIntroSection(
                key: const Key('limanex_studio_intro_section'),
                badgeText: l10n.limanexStudioBadge,
                welcomeText: l10n.limanexStudioWelcome,
              ),
              SizedBox(height: spacing.large),

              // Section 2 — VitaCase Showcase (and future LIMANEX apps)
              for (int i = 0; i < apps.length; i++) ...[
                _AppShowcaseCard(
                  key: Key('${apps[i].id}_showcase_section'),
                  item: apps[i],
                  placeholderLabel: l10n.vitaCasePromoPlaceholderLabel,
                  simulateMissingPromoAsset: widget.simulateMissingPromoAsset,
                  isLaunching: _isLaunching,
                  onExploreTap: () => _handleLaunchApp(apps[i], l10n),
                ),
                if (i < apps.length - 1) SizedBox(height: spacing.large),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LimanexStudioIntroSection extends StatelessWidget {
  const _LimanexStudioIntroSection({
    super.key,
    required this.badgeText,
    required this.welcomeText,
  });

  final String badgeText;
  final String welcomeText;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return MeowoirsCard(
      shape: shapes.largeShape,
      backgroundColor: colors.cardBackground,
      borderColor: colors.orange.withValues(alpha: 0.25),
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Decorative studio pill badge with subtle paw & sparkle details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: colors.accentOrangeContainer,
              borderRadius: shapes.fullRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pets, size: 13, color: colors.orange),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    badgeText,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.orange,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.auto_awesome, size: 13, color: colors.orange),
              ],
            ),
          ),
          SizedBox(height: spacing.medium),

          // Official LIMANEX Studio brand banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.large,
              vertical: spacing.medium,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kDarkBrown,
                  Color.lerp(kDarkBrown, kOrangePrimary, 0.18)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: shapes.mediumRadius,
              boxShadow: [
                BoxShadow(
                  color: kDarkBrown.withValues(alpha: 0.14),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 44, maxWidth: 220),
                child: Image.asset(
                  LimanexAppsShowcaseScreen.limanexFullLogoAsset,
                  key: const Key('limanex_official_logo_image'),
                  fit: BoxFit.contain,
                  semanticLabel: 'LIMANEX Studio',
                  errorBuilder: (_, __, ___) => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome_mosaic_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LIMANEX',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing.medium),

          // Welcoming description sentence
          Text(
            welcomeText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  height: 1.45,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.medium),

          // Subtle decorative divider with downward-pointing arrow
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: colors.cardBorder,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colors.accentOrangeContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    key: const Key('limanex_intro_down_arrow'),
                    size: 20,
                    color: colors.orange,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: colors.cardBorder,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppShowcaseCard extends StatelessWidget {
  const _AppShowcaseCard({
    super.key,
    required this.item,
    required this.placeholderLabel,
    required this.simulateMissingPromoAsset,
    required this.isLaunching,
    required this.onExploreTap,
  });

  final LimanexAppShowcaseItem item;
  final String placeholderLabel;
  final bool simulateMissingPromoAsset;
  final bool isLaunching;
  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return MeowoirsCard(
      shape: shapes.largeShape,
      backgroundColor: colors.cardBackground,
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. App Icon + 2. App Name + 3. Short Description (Tagline)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.accentOrangeContainer.withValues(alpha: 0.45),
                  borderRadius: shapes.mediumRadius,
                  border: Border.all(
                    color: colors.cardBorder,
                    width: 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  item.iconAssetPath,
                  key: Key('${item.id}_app_icon'),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.health_and_safety_rounded,
                    size: 34,
                    color: colors.orange,
                  ),
                ),
              ),
              SizedBox(width: spacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.tagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.orange,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.medium),

          // Supporting description
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  height: 1.45,
                ),
          ),
          SizedBox(height: spacing.medium),

          // 4. Large Promotional Image Area (with graceful placeholder fallback)
          Container(
            key: Key('${item.id}_promo_image_area'),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 160),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: shapes.mediumRadius,
              border: Border.all(color: colors.cardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: simulateMissingPromoAsset
                ? _PromoPlaceholder(
                    item: item,
                    placeholderLabel: placeholderLabel,
                  )
                : AspectRatio(
                    aspectRatio: 2.0,
                    child: Image.asset(
                      item.promoAssetPath,
                      key: Key('${item.id}_promo_asset_image'),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PromoPlaceholder(
                        item: item,
                        placeholderLabel: placeholderLabel,
                      ),
                    ),
                  ),
          ),
          SizedBox(height: spacing.large),

          // 5. Clear CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: Key('${item.id}_cta_button'),
              onPressed: isLaunching ? null : onExploreTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: colors.orange.withValues(alpha: 0.6),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.mediumRadius,
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                item.ctaLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoPlaceholder extends StatelessWidget {
  const _PromoPlaceholder({
    required this.item,
    required this.placeholderLabel,
  });

  final LimanexAppShowcaseItem item;
  final String placeholderLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;

    return Container(
      key: Key('${item.id}_promo_placeholder'),
      padding: EdgeInsets.all(spacing.large),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.accentOrangeContainer.withValues(alpha: 0.55),
            colors.accentLavenderContainer.withValues(alpha: 0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 40,
            color: colors.orange,
          ),
          SizedBox(height: spacing.small),
          Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            placeholderLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

