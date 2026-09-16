package com.limanex.meowoirs

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import com.limanex.meowoirs.ads.AdManager
import com.limanex.meowoirs.ads.LaunchCounterManager
import com.limanex.meowoirs.data.preferences.ThemeMode
import com.limanex.meowoirs.data.preferences.UserPreferencesRepository
import com.limanex.meowoirs.ui.navigation.MainScaffold
import com.limanex.meowoirs.ui.navigation.MeowoirsRoutes
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import java.util.Locale
import java.util.UUID

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        // Track genuine application launches (ignoring configuration changes/recreations)
        if (savedInstanceState == null) {
            val sessionId = UUID.randomUUID().toString()
            LaunchCounterManager.getInstance(this).recordGenuineLaunch(sessionId)
        }

        // Initialize UMP consent flow and preload interstitial
        AdManager.requestConsentAndInitialize(this)

        val preferencesRepo = UserPreferencesRepository.getInstance(this)

        setContent {
            val currentLanguage by preferencesRepo.languageCodeFlow.collectAsState(initial = "")
            val currentTheme by preferencesRepo.themeModeFlow.collectAsState(initial = ThemeMode.SYSTEM)

            val isSystemDark = isSystemInDarkTheme()
            val isDark = when (currentTheme) {
                ThemeMode.LIGHT -> false
                ThemeMode.DARK -> true
                ThemeMode.SYSTEM -> isSystemDark
                else -> isSystemDark
            }

            val configuration = LocalConfiguration.current
            val localizedContext = remember(currentLanguage) {
                if (currentLanguage.isNotBlank()) {
                    val locale = Locale(currentLanguage)
                    Locale.setDefault(locale)
                    val config = android.content.res.Configuration(configuration).apply {
                        setLocale(locale)
                        setLayoutDirection(locale)
                    }
                    createConfigurationContext(config)
                } else {
                    this
                }
            }
            val localizedConfiguration = remember(currentLanguage) {
                if (currentLanguage.isNotBlank()) {
                    val locale = Locale(currentLanguage)
                    android.content.res.Configuration(configuration).apply {
                        setLocale(locale)
                        setLayoutDirection(locale)
                    }
                } else {
                    configuration
                }
            }

            val isOnboardingCompleted by preferencesRepo.onboardingCompletedFlow.collectAsState(initial = null)

            CompositionLocalProvider(
                LocalConfiguration provides localizedConfiguration,
                LocalContext provides localizedContext
            ) {
                MeowoirsTheme(darkTheme = isDark) {
                    if (isOnboardingCompleted != null) {
                        val startDestination = if (isOnboardingCompleted == true) {
                            MeowoirsRoutes.HOME
                        } else {
                            MeowoirsRoutes.ONBOARDING
                        }
                        MainScaffold(
                            activity = this@MainActivity,
                            startDestination = startDestination
                        )
                    } else {
                        androidx.compose.material3.Surface(
                            modifier = androidx.compose.ui.Modifier.fillMaxSize(),
                            color = MeowoirsTheme.colors.cream
                        ) {}
                    }
                }
            }
        }
    }

    override fun onPause() {
        super.onPause()
        AdManager.pauseBanner()
    }

    override fun onResume() {
        super.onResume()
        AdManager.resumeBanner()
    }

    override fun onDestroy() {
        super.onDestroy()
        AdManager.destroyBanner(this)
    }
}
