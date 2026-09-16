import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../widgets/onboarding_feature_card.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    final chapText = l10n.onboardingStep3Chap;
    final titleText = l10n.onboardingStep3Title;
    final descText = l10n.onboardingStep3Desc;
    final homeBadge = l10n.onboardingStep3HomeBadge;
    final homeTitle = l10n.onboardingStep3HomeTitle;
    final streetBadge = l10n.onboardingStep3StreetBadge;
    final streetTitle = l10n.onboardingStep3StreetTitle;
    final streetSubtitle = l10n.onboardingStep3StreetSubtitle;
    final featureTitle = l10n.onboardingStep3FeatureTitle;
    final featureDesc = l10n.onboardingStep3FeatureDesc;
    final continueText = l10n.onboardingContinue;
    final footer1 = l10n.onboardingStep3Footer1;
    final footer2 = l10n.onboardingStep3Footer2;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Chapter Label
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                chapText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  letterSpacing: 2,
                  color: colors.orange,
                ),
              ),
            ),
          ),

          // Title
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

          const SizedBox(height: 6),

          // Supporting text
          Text(
            descText,
            style: TextStyle(
              fontSize: 14,
              height: 21 / 14,
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: 18),

          // Overlapping Dual Photographic Cards
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // Card 1: Home Cat (aligned to right)
                Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.90,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: colors.cardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'assets/onboarding/onboarding_step3_home.png',
                                fit: BoxFit.cover,
                              ),
                              // Gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.65),
                                    ],
                                  ),
                                ),
                              ),
                              // Badge: "EVDE"
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colors.sage,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    homeBadge,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom Title
                              Positioned(
                                left: 14,
                                bottom: 14,
                                child: Text(
                                  homeTitle,
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Card 2: Street Cat (aligned to left, overlapping upwards)
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.76,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: colors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/onboarding/onboarding_step3_street.png',
                                  fit: BoxFit.cover,
                                ),
                                // Gradient
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.70),
                                      ],
                                    ),
                                  ),
                                ),
                                // Badge: "SOKAK HİKÂYESİ"
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colors.orange,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      streetBadge,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                // Bottom Street Title & Subtitle
                                Positioned(
                                  left: 12,
                                  bottom: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        streetTitle,
                                        style: const TextStyle(
                                          fontFamily: 'serif',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        streetSubtitle,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white70,
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
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Feature Card
          Transform.translate(
            offset: const Offset(0, -24),
            child: OnboardingFeatureCard(
              icon: Icons.pets_outlined,
              title: featureTitle,
              description: featureDesc,
            ),
          ),

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
