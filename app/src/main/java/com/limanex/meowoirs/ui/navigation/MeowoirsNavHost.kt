package com.limanex.meowoirs.ui.navigation

import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.limanex.meowoirs.ui.screens.cats.AddCatScreen
import com.limanex.meowoirs.ui.screens.cats.CatDetailScreen
import com.limanex.meowoirs.ui.screens.cats.CatsScreen
import com.limanex.meowoirs.ui.screens.home.HomeScreen
import com.limanex.meowoirs.ui.screens.memories.AddMemoryScreen
import com.limanex.meowoirs.ui.screens.memories.MemoriesScreen
import com.limanex.meowoirs.ui.screens.memories.MemoryDetailScreen
import com.limanex.meowoirs.ui.screens.mystory.MyStoryScreen

/**
 * Main NavHost establishing the application's complete navigation graph.
 */
@Composable
fun MeowoirsNavHost(
    navController: NavHostController,
    startDestination: String = MeowoirsRoutes.HOME,
    modifier: Modifier = Modifier
) {
    NavHost(
        navController = navController,
        startDestination = startDestination,
        modifier = modifier,
        enterTransition = {
            androidx.compose.animation.fadeIn(
                animationSpec = androidx.compose.animation.core.tween(
                    durationMillis = 280,
                    easing = androidx.compose.animation.core.FastOutSlowInEasing
                )
            ) + androidx.compose.animation.slideInVertically(
                animationSpec = androidx.compose.animation.core.tween(
                    durationMillis = 280,
                    easing = androidx.compose.animation.core.FastOutSlowInEasing
                ),
                initialOffsetY = { (it * 0.03f).toInt() }
            )
        },
        exitTransition = {
            androidx.compose.animation.fadeOut(
                animationSpec = androidx.compose.animation.core.tween(durationMillis = 180)
            )
        },
        popEnterTransition = {
            androidx.compose.animation.fadeIn(
                animationSpec = androidx.compose.animation.core.tween(
                    durationMillis = 280,
                    easing = androidx.compose.animation.core.FastOutSlowInEasing
                )
            )
        },
        popExitTransition = {
            androidx.compose.animation.fadeOut(
                animationSpec = androidx.compose.animation.core.tween(durationMillis = 180)
            ) + androidx.compose.animation.slideOutVertically(
                animationSpec = androidx.compose.animation.core.tween(durationMillis = 180),
                targetOffsetY = { (it * 0.03f).toInt() }
            )
        }
    ) {
        composable(MeowoirsRoutes.ONBOARDING) {
            com.limanex.meowoirs.ui.screens.onboarding.OnboardingScreen(
                onOnboardingFinished = {
                    navController.navigate(MeowoirsRoutes.HOME) {
                        popUpTo(MeowoirsRoutes.ONBOARDING) {
                            inclusive = true
                        }
                        launchSingleTop = true
                    }
                }
            )
        }

        composable(MeowoirsRoutes.HOME) {
            HomeScreen(
                onNavigateToCatDetail = { catId ->
                    navController.navigate(MeowoirsRoutes.catDetail(catId))
                },
                onNavigateToMemories = {
                    navController.navigate(MeowoirsRoutes.MEMORIES)
                },
                onNavigateToAddMemory = {
                    navController.navigate(MeowoirsRoutes.ADD_MEMORY)
                },
                onNavigateToAddCat = {
                    navController.navigate(MeowoirsRoutes.ADD_CAT)
                }
            )
        }

        composable(MeowoirsRoutes.CATS) {
            CatsScreen(
                onNavigateToAddCat = {
                    navController.navigate(MeowoirsRoutes.ADD_CAT)
                },
                onNavigateToCatDetail = { catId ->
                    navController.navigate(MeowoirsRoutes.catDetail(catId))
                }
            )
        }

        composable(MeowoirsRoutes.MEMORIES) {
            MemoriesScreen(
                onNavigateToCatDetail = { catId ->
                    navController.navigate(MeowoirsRoutes.catDetail(catId))
                },
                onNavigateToMemoryDetail = { memoryId ->
                    navController.navigate(MeowoirsRoutes.memoryDetail(memoryId))
                },
                onNavigateToAddMemory = { catId ->
                    navController.navigate(MeowoirsRoutes.addMemory(catId))
                }
            )
        }

        composable(MeowoirsRoutes.PROFILE) {
            com.limanex.meowoirs.ui.screens.profile.ProfileScreen(
                onNavigateToSettings = { navController.navigate(MeowoirsRoutes.SETTINGS) },
                onNavigateToMyStory = { navController.navigate(MeowoirsRoutes.MY_STUDY_OR_STORY) },
                onNavigateToAddCat = { navController.navigate(MeowoirsRoutes.ADD_CAT) },
                onNavigateToCatDetail = { catId ->
                    navController.navigate(MeowoirsRoutes.catDetail(catId))
                }
            )
        }

        composable(MeowoirsRoutes.SETTINGS) {
            com.limanex.meowoirs.ui.screens.settings.SettingsScreen(
                onBack = { navController.popBackStack() }
            )
        }

        composable(MeowoirsRoutes.MY_STUDY_OR_STORY) {
            MyStoryScreen(
                onNavigateToCats = { navController.navigate(MeowoirsRoutes.CATS) },
                onNavigateToCatDetail = { catId ->
                    navController.navigate(MeowoirsRoutes.catDetail(catId))
                },
                onNavigateToAddMemory = { navController.navigate(MeowoirsRoutes.ADD_MEMORY) },
                onNavigateToAddCat = { navController.navigate(MeowoirsRoutes.ADD_CAT) }
            )
        }

        composable(
            route = MeowoirsRoutes.ADD_MEMORY_PATTERN,
            arguments = listOf(
                navArgument("catId") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                },
                navArgument("memoryId") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                }
            )
        ) { backStackEntry ->
            val catId = backStackEntry.arguments?.getString("catId")
            val memoryId = backStackEntry.arguments?.getString("memoryId")
            AddMemoryScreen(
                initialCatId = catId,
                memoryId = memoryId,
                onBack = { navController.popBackStack() },
                onNavigateToAddCat = { navController.navigate(MeowoirsRoutes.ADD_CAT) }
            )
        }

        composable(
            route = MeowoirsRoutes.ADD_CAT_PATTERN,
            arguments = listOf(
                navArgument("catId") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                }
            )
        ) { backStackEntry ->
            val catId = backStackEntry.arguments?.getString("catId")
            AddCatScreen(
                catId = catId,
                onBack = { navController.popBackStack() }
            )
        }

        composable(
            route = MeowoirsRoutes.CAT_DETAIL,
            arguments = listOf(
                navArgument("catId") { type = NavType.StringType }
            )
        ) { backStackEntry ->
            val catId = backStackEntry.arguments?.getString("catId") ?: ""
            CatDetailScreen(
                catId = catId,
                onBack = { navController.popBackStack() },
                onNavigateToEditCat = { editCatId ->
                    navController.navigate(MeowoirsRoutes.addCat(editCatId))
                },
                onNavigateToAddMemory = { selectedCatId ->
                    navController.navigate(MeowoirsRoutes.addMemory(selectedCatId))
                },
                onNavigateToMemoryDetail = { memoryId ->
                    navController.navigate(MeowoirsRoutes.memoryDetail(memoryId))
                }
            )
        }

        composable(
            route = MeowoirsRoutes.MEMORY_DETAIL,
            arguments = listOf(
                navArgument("memoryId") { type = NavType.StringType }
            )
        ) { backStackEntry ->
            val memoryId = backStackEntry.arguments?.getString("memoryId") ?: ""
            MemoryDetailScreen(
                memoryId = memoryId,
                onBack = { navController.popBackStack() },
                onNavigateToEditMemory = { id ->
                    navController.navigate(MeowoirsRoutes.addMemory(memoryId = id))
                },
                onNavigateToCatDetail = { catId ->
                    navController.navigate(MeowoirsRoutes.catDetail(catId)) {
                        launchSingleTop = true
                    }
                }
            )
        }
    }
}
