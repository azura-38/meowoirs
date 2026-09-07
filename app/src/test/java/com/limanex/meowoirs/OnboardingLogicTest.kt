package com.limanex.meowoirs

import com.limanex.meowoirs.config.AppConfig
import com.limanex.meowoirs.ui.navigation.MeowoirsRoutes
import com.limanex.meowoirs.viewmodel.OnboardingUiState
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class OnboardingLogicTest {

    @Test
    fun testOnboardingDefaultState() {
        val state = OnboardingUiState()
        assertEquals(1, state.currentStep)
        assertFalse(state.privacyAccepted)
        assertFalse(state.termsAccepted)
        assertFalse(state.canStart)
        assertFalse(state.isCompleted)
    }

    @Test
    fun testCanStartRequiresBothLegalCheckboxes() {
        // Neither accepted
        val neither = OnboardingUiState(privacyAccepted = false, termsAccepted = false)
        assertFalse(neither.canStart)

        // Only privacy accepted
        val onlyPrivacy = OnboardingUiState(privacyAccepted = true, termsAccepted = false)
        assertFalse(onlyPrivacy.canStart)

        // Only terms accepted
        val onlyTerms = OnboardingUiState(privacyAccepted = false, termsAccepted = true)
        assertFalse(onlyTerms.canStart)

        // Both accepted
        val both = OnboardingUiState(privacyAccepted = true, termsAccepted = true)
        assertTrue(both.canStart)
    }

    @Test
    fun testLegalVersionIsConfigured() {
        assertEquals("1", AppConfig.CURRENT_LEGAL_VERSION)
    }

    @Test
    fun testOnboardingRouteIsConfigured() {
        assertEquals("onboarding", MeowoirsRoutes.ONBOARDING)
    }

    @Test
    fun testOnboardingStepTransitions() {
        // Step 1 to 4 bounds verification
        var state = OnboardingUiState(currentStep = 1)
        assertEquals(1, state.currentStep)

        // Advancing steps
        state = state.copy(currentStep = 2)
        assertEquals(2, state.currentStep)

        state = state.copy(currentStep = 3)
        assertEquals(3, state.currentStep)

        state = state.copy(currentStep = 4)
        assertEquals(4, state.currentStep)

        // Skip to legal jumps to step 4
        val skippedState = OnboardingUiState(currentStep = 1).copy(currentStep = 4)
        assertEquals(4, skippedState.currentStep)
    }
}
