import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/providers/database_provider.dart';
import '../legal/legal_document_viewer.dart';
import 'onboarding_provider.dart';
import 'pages/onboarding_page_1.dart';
import 'pages/onboarding_page_2.dart';
import 'pages/onboarding_page_3.dart';
import 'pages/onboarding_page_4.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_pagination.dart';

/// Full 4-page Onboarding experience matching OnboardingScreen.kt.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({
    super.key,
    required this.onOnboardingFinished,
  });

  final VoidCallback onOnboardingFinished;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final colors = context.meowoirsColors;
    final currentLanguage = ref.watch(languageCodeStreamProvider).value ??
        ref.watch(preferencesRepositoryProvider).getLanguageCode();

    // Listen for completion
    ref.listen(onboardingProvider, (previous, next) {
      if (next.isCompleted) {
        onOnboardingFinished();
      }
    });

    return PopScope(
      canPop: uiState.currentStep == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && uiState.currentStep > 1) {
          notifier.previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: colors.cream,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              OnboardingHeader(
                currentLanguageCode: currentLanguage,
                onSelectLanguage: (code) => notifier.updateLanguage(code),
                onSkip: () => notifier.skipToLegal(),
                showSkip: uiState.currentStep < 4,
              ),

              // Step Content with smooth AnimatedSwitcher
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastOutSlowIn,
                        )),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(uiState.currentStep),
                    child: switch (uiState.currentStep) {
                      1 => OnboardingPage1(
                          onContinue: () => notifier.nextStep(),
                        ),
                      2 => OnboardingPage2(
                          onContinue: () => notifier.nextStep(),
                        ),
                      3 => OnboardingPage3(
                          onContinue: () => notifier.nextStep(),
                        ),
                      4 => OnboardingPage4(
                          uiState: uiState,
                          onPrivacyToggle: (val) =>
                              notifier.setPrivacyAccepted(val),
                          onTermsToggle: (val) =>
                              notifier.setTermsAccepted(val),
                          onCombinedLegalToggle: (val) =>
                              notifier.setCombinedLegalAccepted(val),
                          onOpenDocument: (doc) {
                            LegalDocumentViewerDialog.show(context, doc);
                          },
                          onStart: () => notifier.completeOnboarding(),
                        ),
                      _ => const SizedBox.shrink(),
                    },
                  ),
                ),
              ),

              // Fixed Pagination at bottom
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: OnboardingPagination(
                  currentStep: uiState.currentStep,
                  totalSteps: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
