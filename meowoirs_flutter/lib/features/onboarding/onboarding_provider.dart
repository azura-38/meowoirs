import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../data/providers/database_provider.dart';
import '../../data/repositories/preferences_repository.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends StateNotifier<OnboardingUiState> {
  OnboardingNotifier(this._preferencesRepository) : super(const OnboardingUiState());

  final PreferencesRepository _preferencesRepository;

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void skipToLegal() {
    state = state.copyWith(currentStep: 4);
  }

  bool previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      return true;
    }
    return false;
  }

  Future<void> updateLanguage(String languageCode) async {
    await _preferencesRepository.updateLanguageCode(languageCode);
  }

  void setPrivacyAccepted(bool accepted) {
    state = state.copyWith(privacyAccepted: accepted);
  }

  void setTermsAccepted(bool accepted) {
    state = state.copyWith(termsAccepted: accepted);
  }

  Future<void> completeOnboarding() async {
    if (!state.canStart) return;
    await _preferencesRepository.completeOnboarding(AppConfig.currentLegalVersion);
    state = state.copyWith(isCompleted: true);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingUiState>((ref) {
  final prefsRepo = ref.watch(preferencesRepositoryProvider);
  return OnboardingNotifier(prefsRepo);
});
