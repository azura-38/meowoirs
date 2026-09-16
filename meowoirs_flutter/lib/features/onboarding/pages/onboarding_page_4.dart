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
    required this.onPrivacyToggle,
    required this.onTermsToggle,
    required this.onOpenDocument,
    required this.onStart,
  });

  final OnboardingUiState uiState;
  final ValueChanged<bool> onPrivacyToggle;
  final ValueChanged<bool> onTermsToggle;
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
    final privacyCheckboxText = l10n.onboardingStep4PrivacyCheckbox;
    final privacyLinkText = l10n.onboardingStep4PrivacyLink;
    final termsCheckboxText = l10n.onboardingStep4TermsCheckbox;
    final termsLinkText = l10n.onboardingStep4TermsLink;
    final startText = l10n.onboardingStep4Start;
    final footerText = l10n.onboardingStep4Footer;

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

          // Checkbox 1: Privacy Policy
          _buildLegalCheckbox(
            context: context,
            checked: uiState.privacyAccepted,
            onChanged: onPrivacyToggle,
            fullText: privacyCheckboxText,
            linkKeyword: privacyLinkText,
            onLinkClicked: () => onOpenDocument(LegalDocument.privacyPolicy),
          ),

          const SizedBox(height: 14),

          // Checkbox 2: Terms of Service
          _buildLegalCheckbox(
            context: context,
            checked: uiState.termsAccepted,
            onChanged: onTermsToggle,
            fullText: termsCheckboxText,
            linkKeyword: termsLinkText,
            onLinkClicked: () => onOpenDocument(LegalDocument.termsOfService),
          ),

          const SizedBox(height: 26),

          // CTA Button: "Meowoirs'e Başla →" (Disabled until both checked)
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

  Widget _buildLegalCheckbox({
    required BuildContext context,
    required bool checked,
    required ValueChanged<bool> onChanged,
    required String fullText,
    required String linkKeyword,
    required VoidCallback onLinkClicked,
  }) {
    final colors = context.meowoirsColors;
    final startIndex = fullText.indexOf(linkKeyword);
    final endIndex = startIndex != -1 ? startIndex + linkKeyword.length : -1;

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
              // Custom Circular Checkbox
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checked ? colors.textPrimary : colors.cardBackground,
                  border: Border.all(
                    color: checked ? colors.textPrimary : colors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: checked
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),

              // Text with clickable link
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      height: 19 / 13,
                      color: colors.textPrimary,
                    ),
                    children: [
                      if (startIndex != -1) ...[
                        TextSpan(text: fullText.substring(0, startIndex)),
                        TextSpan(
                          text: linkKeyword,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: colors.textPrimary,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = onLinkClicked,
                        ),
                        TextSpan(text: fullText.substring(endIndex)),
                      ] else
                        TextSpan(text: fullText),
                    ],
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


