import 'dart:io';
import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/meowoirs_theme.dart';
import '../data/models/cat.dart';

/// Visually substantial card for the 2-column Cats collection grid.
/// Direct parity with CatCard.kt.
class CatCard extends StatelessWidget {
  const CatCard({
    super.key,
    required this.cat,
    required this.onTap,
    this.memoryCount,
  });

  final Cat cat;
  final VoidCallback onTap;
  final int? memoryCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final elevations = context.meowoirsElevation;
    final l10n = AppLocalizations.of(context);

    final isHomeCat = cat.type == CatType.home;
    final accentColor = isHomeCat ? colors.orange : colors.sage;
    final accentContainerColor = isHomeCat
        ? colors.accentOrangeContainer
        : colors.accentSageContainer;
    final typeLabel = isHomeCat ? l10n.catTypeHome : l10n.catTypeStreet;

    final semanticsDesc = StringBuffer('${cat.name}, $typeLabel.');
    if (memoryCount != null && memoryCount! > 0) {
      semanticsDesc.write(' ${l10n.catCardMemoryCount(memoryCount!)}.');
    }

    return Semantics(
      button: true,
      label: semanticsDesc.toString(),
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
              // 1. Large Photographic / Portrait Area (1:1)
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: accentContainerColor.withValues(alpha: 0.45),
                  ),
                  child: cat.photoUri != null && cat.photoUri!.isNotEmpty
                      ? _buildCatImage(
                          cat.photoUri!,
                          cat.name,
                          accentColor,
                          accentContainerColor,
                        )
                      : _buildFallbackIcon(accentColor, accentContainerColor),
                ),
              ),

              // 2. Info area
              Padding(
                padding: EdgeInsets.all(spacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cat Name
                    Text(
                      cat.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: spacing.extraSmall),

                    // Subtle Type Indicator & Optional Memory Count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: spacing.extraSmall),
                            Text(
                              typeLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                  ),
                            ),
                          ],
                        ),

                        if (memoryCount != null && memoryCount! > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.extraSmall + 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.cardBorder.withValues(alpha: 0.5),
                              borderRadius: shapes.fullRadius,
                            ),
                            child: Text(
                              l10n.catCardMemoryCount(memoryCount!),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
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

  Widget _buildCatImage(
    String uri,
    String catName,
    Color accentColor,
    Color accentContainerColor,
  ) {
    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          semanticLabel: catName,
          errorBuilder: (_, __, ___) =>
              _buildFallbackIcon(accentColor, accentContainerColor),
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          semanticLabel: catName,
          errorBuilder: (_, __, ___) =>
              _buildFallbackIcon(accentColor, accentContainerColor),
        );
      }
    } catch (_) {
      // Graceful fallback on any filesystem or format error
    }
    return _buildFallbackIcon(accentColor, accentContainerColor);
  }

  Widget _buildFallbackIcon(Color accentColor, Color accentContainerColor) {
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: accentContainerColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.pets_outlined,
          size: 28,
          color: accentColor,
        ),
      ),
    );
  }
}
