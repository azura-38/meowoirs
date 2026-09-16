class OnboardingUiState {
  const OnboardingUiState({
    this.currentStep = 1,
    this.privacyAccepted = false,
    this.termsAccepted = false,
    this.isCompleted = false,
  });

  final int currentStep;
  final bool privacyAccepted;
  final bool termsAccepted;
  final bool isCompleted;

  bool get canStart => privacyAccepted && termsAccepted;

  OnboardingUiState copyWith({
    int? currentStep,
    bool? privacyAccepted,
    bool? termsAccepted,
    bool? isCompleted,
  }) {
    return OnboardingUiState(
      currentStep: currentStep ?? this.currentStep,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
