package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.CreationExtras
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.config.AppConfig
import com.limanex.meowoirs.data.preferences.UserPreferencesRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

data class OnboardingUiState(
    val currentStep: Int = 1,
    val privacyAccepted: Boolean = false,
    val termsAccepted: Boolean = false,
    val isCompleted: Boolean = false
) {
    val canStart: Boolean get() = privacyAccepted && termsAccepted
}

class OnboardingViewModel(
    private val preferencesRepository: UserPreferencesRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(OnboardingUiState())
    val uiState: StateFlow<OnboardingUiState> = _uiState.asStateFlow()

    fun nextStep() {
        _uiState.update { state ->
            if (state.currentStep < 4) {
                state.copy(currentStep = state.currentStep + 1)
            } else {
                state
            }
        }
    }

    fun skipToLegal() {
        _uiState.update { state ->
            state.copy(currentStep = 4)
        }
    }

    fun previousStep(): Boolean {
        var handled = false
        _uiState.update { state ->
            if (state.currentStep > 1) {
                handled = true
                state.copy(currentStep = state.currentStep - 1)
            } else {
                state
            }
        }
        return handled
    }

    fun updateLanguage(languageCode: String) {
        viewModelScope.launch {
            preferencesRepository.updateLanguageCode(languageCode)
        }
    }

    fun setPrivacyAccepted(accepted: Boolean) {
        _uiState.update { it.copy(privacyAccepted = accepted) }
    }

    fun setTermsAccepted(accepted: Boolean) {
        _uiState.update { it.copy(termsAccepted = accepted) }
    }

    fun completeOnboarding() {
        val currentState = _uiState.value
        if (!currentState.canStart) return

        viewModelScope.launch {
            preferencesRepository.completeOnboarding(AppConfig.CURRENT_LEGAL_VERSION)
            _uiState.update { it.copy(isCompleted = true) }
        }
    }

    companion object {
        val Factory: ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>, extras: CreationExtras): T {
                val application = extras[ViewModelProvider.AndroidViewModelFactory.APPLICATION_KEY] as MeowoirsApplication
                val preferencesRepo = UserPreferencesRepository.getInstance(application)
                return OnboardingViewModel(preferencesRepo) as T
            }
        }
    }
}
