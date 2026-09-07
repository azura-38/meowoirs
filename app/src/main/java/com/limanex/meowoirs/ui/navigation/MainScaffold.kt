package com.limanex.meowoirs.ui.navigation

import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavHostController
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.limanex.meowoirs.ui.components.MeowoirsBottomNavigation
import com.limanex.meowoirs.ui.components.MeowoirsFab
import com.limanex.meowoirs.ui.components.MeowoirsTopBar
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * Main application screen scaffolding top bar, bottom navigation, FAB, and content host.
 */
@Composable
fun MainScaffold(
    activity: android.app.Activity? = null,
    startDestination: String = MeowoirsRoutes.HOME,
    navController: NavHostController = rememberNavController()
) {
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination?.route ?: startDestination
    val isOnboarding = currentRoute == MeowoirsRoutes.ONBOARDING

    // Check if the current destination is one of the 4 bottom nav items
    val isTopLevelDestination by remember(currentRoute) {
        derivedStateOf {
            !isOnboarding && BottomNavItem.items.any { it.route == currentRoute }
        }
    }

    // TopBar title mapping
    val currentTitle = when {
        currentRoute == MeowoirsRoutes.HOME -> "Meowoirs"
        currentRoute == MeowoirsRoutes.CATS -> "Kedilerim"
        currentRoute == MeowoirsRoutes.MEMORIES -> "Anılar"
        currentRoute == MeowoirsRoutes.PROFILE -> "Profil"
        currentRoute == MeowoirsRoutes.SETTINGS -> "Ayarlar"
        currentRoute == MeowoirsRoutes.MY_STUDY_OR_STORY -> "Hikâyem"
        currentRoute?.startsWith("add_memory") == true -> "Anı Ekle"
        currentRoute == MeowoirsRoutes.ADD_CAT -> "Kedi Ekle"
        currentRoute == MeowoirsRoutes.CAT_DETAIL || currentRoute?.startsWith("cat_detail") == true -> "Kedi Hikâyesi"
        else -> "Meowoirs"
    }

    val shouldShowBanner = !isOnboarding && (isTopLevelDestination ||
            currentRoute == MeowoirsRoutes.CAT_DETAIL ||
            currentRoute?.startsWith("cat_detail") == true)

    // Safe interstitial presentation check after initial screen composition settles (never during onboarding)
    androidx.compose.runtime.LaunchedEffect(currentRoute) {
        if (activity != null && !isOnboarding) {
            kotlinx.coroutines.delay(1200)
            com.limanex.meowoirs.ads.AdManager.tryShowInterstitial(activity, currentRoute)
        }
    }

    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.statusBars),
        containerColor = MeowoirsTheme.colors.cream,
        topBar = {
            if (!isOnboarding) {
                androidx.compose.foundation.layout.Column {
                    MeowoirsTopBar(
                        title = currentTitle,
                        canNavigateBack = !isTopLevelDestination,
                        onNavigateBack = { navController.popBackStack() }
                    )
                    if (shouldShowBanner) {
                        com.limanex.meowoirs.ads.MeowoirsBannerAd(
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }
        },
        bottomBar = {
            if (isTopLevelDestination && !isOnboarding) {
                MeowoirsBottomNavigation(
                    currentRoute = currentRoute,
                    onNavigateToRoute = { route ->
                        navController.navigate(route) {
                            popUpTo(navController.graph.findStartDestination().id) {
                                saveState = true
                            }
                            launchSingleTop = true
                            restoreState = true
                        }
                    },
                    modifier = Modifier.windowInsetsPadding(WindowInsets.navigationBars)
                )
            }
        },
        floatingActionButton = {
            androidx.compose.animation.AnimatedVisibility(
                visible = isTopLevelDestination && !isOnboarding,
                enter = androidx.compose.animation.fadeIn(androidx.compose.animation.core.tween(240)) +
                        androidx.compose.animation.scaleIn(
                            initialScale = 0.95f,
                            animationSpec = androidx.compose.animation.core.tween(240)
                        ),
                exit = androidx.compose.animation.fadeOut(androidx.compose.animation.core.tween(150)) +
                        androidx.compose.animation.scaleOut(
                            targetScale = 0.95f,
                            animationSpec = androidx.compose.animation.core.tween(150)
                        )
            ) {
                MeowoirsFab(
                    onClick = {
                        navController.navigate(MeowoirsRoutes.ADD_MEMORY)
                    },
                    modifier = Modifier.windowInsetsPadding(WindowInsets.navigationBars)
                )
            }
        }
    ) { innerPadding ->
        MeowoirsNavHost(
            navController = navController,
            startDestination = startDestination,
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        )
    }
}
