import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../data/models/cat.dart';
import '../../../widgets/meowoirs_button.dart';
import '../../../widgets/meowoirs_card.dart';

/// CatSelectionRow: Horizontal selector for choosing which cat this memory belongs to.
/// Direct parity with CatSelectionRow.kt.
class CatSelectionRow extends StatelessWidget {
  const CatSelectionRow({
    super.key,
    required this.cats,
    required this.selectedCatId,
    required this.onSelectCat,
    required this.onNavigateToAddCat,
  });

  final List<Cat> cats;
  final String? selectedCatId;
  final ValueChanged<String> onSelectCat;
  final VoidCallback onNavigateToAddCat;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final l10n = AppLocalizations.of(context);

    if (cats.isEmpty) {
      return MeowoirsCard(
        shape: shapes.largeShape,
        padding: EdgeInsets.all(spacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 32,
              color: colors.orange,
            ),
            SizedBox(height: spacing.small),
            Text(
              l10n.catsEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xxSmall),
            Text(
              l10n.catsEmptyDesc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.medium),
            MeowoirsPrimaryButton(
              text: l10n.catsEmptyAddCat,
              onPressed: onNavigateToAddCat,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing.small),
        itemBuilder: (context, index) {
          final cat = cats[index];
          final isSelected = cat.id == selectedCatId;

          final isHomeCat = cat.type == CatType.home;
          final accentColor = isHomeCat ? colors.orange : colors.sage;
          final accentContainerColor = isHomeCat
              ? colors.accentOrangeContainer
              : colors.accentSageContainer;
          final borderColor = isSelected ? accentColor : colors.cardBorder;
          final bgColor = isSelected
              ? accentContainerColor.withValues(alpha: 0.4)
              : colors.cardBackground;

          return SizedBox(
            width: 105,
            child: Material(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: shapes.mediumRadius,
                side: BorderSide(
                  color: borderColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                onTap: () => onSelectCat(cat.id),
                borderRadius: shapes.mediumRadius,
                child: Padding(
                  padding: EdgeInsets.all(spacing.small),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar with Checkmark
                      SizedBox(
                        width: 54,
                        height: 54,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: accentContainerColor,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: cat.photoUri != null &&
                                      cat.photoUri!.isNotEmpty
                                  ? _buildCatImage(cat.photoUri!)
                                  : Icon(
                                      Icons.pets_outlined,
                                      size: 24,
                                      color: accentColor,
                                    ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing.extraSmall),

                      // Name
                      Text(
                        cat.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: colors.textPrimary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Type Label
                      Text(
                        cat.type.localizedLabel(l10n),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? accentColor
                                  : colors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCatImage(String uri) {
    if (uri.startsWith('http://') || uri.startsWith('https://')) {
      return Image.network(uri, fit: BoxFit.cover);
    }
    final file = File(uri);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return const Icon(Icons.pets_outlined, size: 24);
  }
}
