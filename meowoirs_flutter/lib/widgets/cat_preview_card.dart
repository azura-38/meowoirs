import 'dart:io';
import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/meowoirs_theme.dart';
import '../data/models/cat.dart';

/// Compact card for the "Kedilerin" horizontal row on the Home screen.
/// Direct parity with CatPreviewCard.kt.
class CatPreviewCard extends StatelessWidget {
  const CatPreviewCard({
    super.key,
    required this.cat,
    required this.onTap,
  });

  final Cat cat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final elevations = context.meowoirsElevation;

    final isHomeCat = cat.type == CatType.home;
    final badgeColor = isHomeCat ? colors.orange : colors.sage;
    final badgeBgColor = isHomeCat
        ? colors.accentOrangeContainer
        : colors.accentSageContainer;

    return SizedBox(
      width: 110,
      child: Material(
        color: colors.cardBackground,
        elevation: elevations.level1,
        shape: shapes.mediumShape.copyWith(
          side: BorderSide(color: colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.mediumRadius,
          child: Padding(
            padding: EdgeInsets.all(spacing.small),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cat Photo / Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: cat.photoUri != null && cat.photoUri!.isNotEmpty
                      ? _buildCatImage(cat.photoUri!, badgeColor)
                      : Icon(
                          Icons.pets_outlined,
                          size: 26,
                          color: badgeColor,
                        ),
                ),

                SizedBox(height: spacing.small),

                // Cat Name
                Text(
                  cat.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: spacing.xxSmall),

                // Subtle Type Indicator
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          cat.type.localizedLabel(AppLocalizations.of(context)),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: colors.textSecondary,
                                fontSize: 10,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCatImage(String uri, Color fallbackColor) {
    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.pets_outlined, size: 26, color: fallbackColor),
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.pets_outlined, size: 26, color: fallbackColor),
        );
      }
    } catch (_) {
      // Graceful fallback on any filesystem or format error
    }
    return Icon(Icons.pets_outlined, size: 26, color: fallbackColor);
  }
}
