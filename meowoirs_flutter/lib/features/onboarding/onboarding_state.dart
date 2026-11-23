class OnboardingUiState {
  const OnboardingUiState({
    this.currentStep = 1,
    this.privacyAccepted = false,
    this.termsAccepted = false,
    this.combinedLegalAccepted = false,
    this.isCompleted = false,
  });

  final int currentStep;
  final bool privacyAccepted;
  final bool termsAccepted;
  final bool combinedLegalAccepted;
  final bool isCompleted;

  bool get canStart => combinedLegalAccepted || (privacyAccepted && termsAccepted);

  OnboardingUiState copyWith({
    int? currentStep,
    bool? privacyAccepted,
    bool? termsAccepted,
    bool? combinedLegalAccepted,
    bool? isCompleted,
  }) {
    return OnboardingUiState(
      currentStep: currentStep ?? this.currentStep,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      combinedLegalAccepted:
          combinedLegalAccepted ?? this.combinedLegalAccepted,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
