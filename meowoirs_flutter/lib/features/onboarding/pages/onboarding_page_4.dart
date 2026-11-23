import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../legal/legal_document.dart';
import '../onboarding_state.dart';
import '../widgets/onboarding_feature_card.dart';
import '../widgets/privacy_lock_illustration.dart';

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({
    super.key,
    required this.uiState,
    this.onPrivacyToggle,
    this.onTermsToggle,
    this.onCombinedLegalToggle,
    required this.onOpenDocument,
    required this.onStart,
  });

  final OnboardingUiState uiState;
  final ValueChanged<bool>? onPrivacyToggle;
  final ValueChanged<bool>? onTermsToggle;
  final ValueChanged<bool>? onCombinedLegalToggle;
  final ValueChanged<LegalDocument> onOpenDocument;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    final chapText = l10n.onboardingStep4Chap;
    final titleText = l10n.onboardingStep4Title;
    final descText = l10n.onboardingStep4Desc;
    final featureTitle = l10n.onboardingStep4FeatureTitle;
    final featureDesc = l10n.onboardingStep4FeatureDesc;
    final combinedCheckboxText = l10n.onboardingStep4CombinedCheckbox;
    final privacyLinkText = l10n.onboardingStep4PrivacyLink;
    final termsLinkText = l10n.onboardingStep4TermsLink;
    final startText = l10n.onboardingStep4Start;
    final footerText = l10n.onboardingStep4Footer;

    final isChecked = uiState.combinedLegalAccepted ||
        (uiState.privacyAccepted && uiState.termsAccepted);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Chapter Label
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  chapText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 2,
                    color: colors.orange,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Lock & Brand Illustration
          const PrivacyLockIllustration(),

          const SizedBox(height: 8),

          // Title: "Hikâyen senin."
          Text(
            titleText,
            style: TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              fontSize: 28,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              descText,
              style: TextStyle(
                fontSize: 14,
                height: 22 / 14,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Feature Card: "Cihazında Kalır"
          OnboardingFeatureCard(
            icon: Icons.smartphone_outlined,
            title: featureTitle,
            description: featureDesc,
            iconTint: colors.sage,
          ),

          const SizedBox(height: 24),

          // SINGLE Combined Legal Checkbox with Inline Tappable Links
          _buildCombinedLegalCheckbox(
            context: context,
            checked: isChecked,
            onChanged: (val) {
              if (onCombinedLegalToggle != null) {
                onCombinedLegalToggle!(val);
              } else {
                onPrivacyToggle?.call(val);
                onTermsToggle?.call(val);
              }
            },
            fullText: combinedCheckboxText,
            privacyKeyword: privacyLinkText,
            termsKeyword: termsLinkText,
            onPrivacyClicked: () => onOpenDocument(LegalDocument.privacyPolicy),
            onTermsClicked: () => onOpenDocument(LegalDocument.termsOfService),
          ),

          const SizedBox(height: 26),

          // CTA Button: "Meowoirs'e Başla →" (Disabled until combined acceptance checked)
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: uiState.canStart ? onStart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.orange,
                disabledBackgroundColor: colors.cardBorder,
                foregroundColor: Colors.white,
                disabledForegroundColor: colors.textTertiary,
                shape: const StadiumBorder(),
                elevation: uiState.canStart ? 3 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    startText,
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

          const SizedBox(height: 16),

          // Footer with Shield icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 13,
                color: colors.textTertiary,
              ),
              const SizedBox(width: 5),
              Text(
                footerText,
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

  Widget _buildCombinedLegalCheckbox({
    required BuildContext context,
    required bool checked,
    required ValueChanged<bool> onChanged,
    required String fullText,
    required String privacyKeyword,
    required String termsKeyword,
    required VoidCallback onPrivacyClicked,
    required VoidCallback onTermsClicked,
  }) {
    final colors = context.meowoirsColors;

    final spans = <TextSpan>[];
    final privIndex = fullText.indexOf(privacyKeyword);
    final termsIndex = fullText.indexOf(termsKeyword);

    if (privIndex != -1 && termsIndex != -1) {
      if (privIndex < termsIndex) {
        spans.add(TextSpan(text: fullText.substring(0, privIndex)));
        spans.add(TextSpan(
          text: privacyKeyword,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: colors.orange,
          ),
          recognizer: TapGestureRecognizer()..onTap = onPrivacyClicked,
        ));
        spans.add(TextSpan(
          text: fullText.substring(
              privIndex + privacyKeyword.length, termsIndex),
        ));
        spans.add(TextSpan(
          text: termsKeyword,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: colors.orange,
          ),
          recognizer: TapGestureRecognizer()..onTap = onTermsClicked,
        ));
        spans.add(TextSpan(
          text: fullText.substring(termsIndex + termsKeyword.length),
        ));
      } else {
        spans.add(TextSpan(text: fullText.substring(0, termsIndex)));
        spans.add(TextSpan(
          text: termsKeyword,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: colors.orange,
          ),
          recognizer: TapGestureRecognizer()..onTap = onTermsClicked,
        ));
        spans.add(TextSpan(
          text: fullText.substring(
              termsIndex + termsKeyword.length, privIndex),
        ));
        spans.add(TextSpan(
          text: privacyKeyword,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: colors.orange,
          ),
          recognizer: TapGestureRecognizer()..onTap = onPrivacyClicked,
        ));
        spans.add(TextSpan(
          text: fullText.substring(privIndex + privacyKeyword.length),
        ));
      }
    } else {
      spans.add(TextSpan(text: fullText));
    }

    return Semantics(
      label: fullText,
      checked: checked,
      child: InkWell(
        onTap: () => onChanged(!checked),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checked ? colors.orange : colors.cardBackground,
                  border: Border.all(
                    color: checked ? colors.orange : colors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: checked
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      height: 19 / 13,
                      color: colors.textPrimary,
                    ),
                    children: spans,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
