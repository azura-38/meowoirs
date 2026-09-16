import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    final chapText = l10n.onboardingStep2Chap;
    final titleText = l10n.onboardingStep2Title;
    final subtitleText = l10n.onboardingStep2Subtitle;
    final badge1Text = l10n.onboardingStep2Badge1;
    final badge2Text = l10n.onboardingStep2Badge2;
    final dateText = l10n.onboardingStep2Date;
    final moodText = l10n.onboardingStep2Mood;
    final editorialText = l10n.onboardingStep2EditorialText;
    final continueText = l10n.onboardingContinue;
    final footer1 = l10n.onboardingStep2Footer1;
    final footer2 = l10n.onboardingStep2Footer2;

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

          // Subtitle
          Text(
            subtitleText,
            style: TextStyle(
              fontSize: 14,
              height: 22 / 14,
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Journal Card with photo and excerpt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Photo
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/onboarding/onboarding_step2_hero.png',
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
                                Colors.black.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                        ),

                        // Top-left badge: pulsing green dot + "ANNO. 128"
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.cardBackground.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: colors.sage,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  badge1Text,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom-left badge: clock icon + "08:45 Sabah Uykusu"
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.cardBackground.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule_outlined,
                                  size: 13,
                                  color: colors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  badge2Text,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Below photo: Date, Mood Tag, and Journal Excerpt
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.sage.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.sage.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateText,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: colors.orange,
                            ),
                          ),

                          // Mood badge: "Huzurlu"
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.sage,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.spa_outlined, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  moodText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Quote with vertical line
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colors.orange,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '"Koltukta kıvrılmış, güneşin sıcaklığıyla uykuya dalmıştı..."',
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                height: 20 / 14,
                                color: colors.textPrimary,
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

          const SizedBox(height: 16),

          // Editorial Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_stories_outlined,
                  size: 22,
                  color: colors.orange,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    editorialText,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      height: 19 / 13,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
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

