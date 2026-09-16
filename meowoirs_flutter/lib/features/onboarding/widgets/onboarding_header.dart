import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/supported_languages.dart';
import '../../../core/theme/meowoirs_theme.dart';

/// Editorial Header for Onboarding matching OnboardingHeader in OnboardingComponents.kt.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.currentLanguageCode,
    required this.onSelectLanguage,
    required this.onSkip,
    required this.showSkip,
  });

  final String currentLanguageCode;
  final ValueChanged<String> onSelectLanguage;
  final VoidCallback onSkip;
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final effectiveCode = currentLanguageCode.isNotEmpty
        ? currentLanguageCode
        : Localizations.localeOf(context).languageCode;
    final displayLangCode = effectiveCode.toUpperCase();

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand Logo & Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/onboarding_logo.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                'MEOWOIRS',
                style: TextStyle(
                  fontFamily: 'sans-serif',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 3,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),

          // Language Selector and Skip CTA
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<String>(
                onSelected: onSelectLanguage,
                color: colors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colors.cardBorder),
                ),
                itemBuilder: (context) {
                  return supportedLanguages.map((lang) {
                    final isSelected = lang.code.toLowerCase() ==
                        currentLanguageCode.toLowerCase();
                    return PopupMenuItem<String>(
                      value: lang.code,
                      child: Text(
                        '${lang.displayName} (${lang.code.toUpperCase()})',
                        style: TextStyle(
                          color: isSelected ? colors.orange : colors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayLangCode,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 1,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              if (showSkip) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppLocalizations.of(context).onboardingSkip,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
