import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../widgets/onboarding_feature_card.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    final chapText = l10n.onboardingStep1Chap;
    final badgeText = l10n.onboardingStep1Badge;
    final quoteText = l10n.onboardingStep1Quote;
    final introText = l10n.onboardingStep1Intro;
    final introSubText = l10n.onboardingStep1IntroSub;
    final titleText = l10n.onboardingStep1Title;
    final descText = l10n.onboardingStep1Desc;
    final featureTitle = l10n.onboardingStep1FeatureTitle;
    final featureDesc = l10n.onboardingStep1FeatureDesc;
    final continueText = l10n.onboardingContinue;
    final footer1 = l10n.onboardingStep1Footer1;
    final footer2 = l10n.onboardingStep1Footer2;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Chapter label
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                chapText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  letterSpacing: 2,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),

          // Hero Photograph Container (serene cat by window)
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: colors.textPrimary.withValues(alpha: 0.85),
                  width: 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/onboarding/onboarding_step1_hero.png',
                      fit: BoxFit.cover,
                    ),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),

                    // Top-right floating badge: "GÜNÜN IŞIĞI"
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: colors.cardBackground.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              size: 13,
                              color: colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              badgeText,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom overlay: Quote bubble & Story icon
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 14,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: colors.cardBackground.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                quoteText,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.cardBackground.withValues(alpha: 0.92),
                            ),
                            child: Icon(
                              Icons.auto_stories_outlined,
                              size: 18,
                              color: colors.textPrimary,
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

          const SizedBox(height: 20),

          // Introductory tags
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  introText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: colors.orange,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 16,
                  height: 1,
                  color: colors.orange.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 6),
                Text(
                  introSubText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: colors.orange,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Headline
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titleText,
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w600,
                fontSize: 28,
                height: 36 / 28,
                color: colors.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            descText,
            style: TextStyle(
              fontSize: 15,
              height: 23 / 15,
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Feature Card
          OnboardingFeatureCard(
            icon: Icons.filter_vintage_outlined,
            title: featureTitle,
            description: featureDesc,
          ),

          const SizedBox(height: 24),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.orange,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    continueText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Editorial Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                footer1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  letterSpacing: 2,
                  color: colors.textTertiary,
                ),
              ),
              Text(
                ' • ',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textTertiary,
                ),
              ),
              Text(
                footer2,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  letterSpacing: 2,
                  color: colors.textTertiary,
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.medium),
        ],
      ),
    );
  }
}


