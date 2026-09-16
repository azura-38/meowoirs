package com.limanex.meowoirs.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AutoStories
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Pets
import androidx.compose.material.icons.outlined.AutoStories
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.ui.graphics.vector.ImageVector

/**
 * Route constants for all Meowoirs destinations.
 */
object MeowoirsRoutes {
    const val ONBOARDING = "onboarding"
    const val HOME = "home"
    const val CATS = "cats"
    const val MEMORIES = "memories"
    const val MY_STUDY_OR_STORY = "my_story"
    const val PROFILE = "profile"
    const val SETTINGS = "settings"
    const val ADD_MEMORY = "add_memory"
    const val ADD_MEMORY_PATTERN = "add_memory?catId={catId}&memoryId={memoryId}"
    const val ADD_CAT = "add_cat"
    const val ADD_CAT_PATTERN = "add_cat?catId={catId}"
    const val CAT_DETAIL = "cat_detail/{catId}"
    const val MEMORY_DETAIL = "memory_detail/{memoryId}"

    fun catDetail(catId: String): String = "cat_detail/$catId"
    fun addCat(catId: String? = null): String = if (catId != null) "add_cat?catId=$catId" else "add_cat"
    fun addMemory(catId: String? = null, memoryId: String? = null): String {
        return when {
            catId != null && memoryId != null -> "add_memory?catId=$catId&memoryId=$memoryId"
            catId != null -> "add_memory?catId=$catId"
            memoryId != null -> "add_memory?memoryId=$memoryId"
            else -> "add_memory"
        }
    }
    fun memoryDetail(memoryId: String): String = "memory_detail/$memoryId"
}

/**
 * Items displayed on the bottom navigation bar.
 */
sealed class BottomNavItem(
    val route: String,
    val title: String,
    val selectedIcon: ImageVector,
    val unselectedIcon: ImageVector
) {
    data object Home : BottomNavItem(
        route = MeowoirsRoutes.HOME,
        title = "Ana Sayfa",
        selectedIcon = Icons.Filled.Home,
        unselectedIcon = Icons.Outlined.Home
    )

    data object Cats : BottomNavItem(
        route = MeowoirsRoutes.CATS,
        title = "Kedilerim",
        selectedIcon = Icons.Filled.Pets,
        unselectedIcon = Icons.Outlined.Pets
    )

    data object Memories : BottomNavItem(
        route = MeowoirsRoutes.MEMORIES,
        title = "Anılar",
        selectedIcon = Icons.Filled.AutoStories,
        unselectedIcon = Icons.Outlined.AutoStories
    )

    data object Profile : BottomNavItem(
        route = MeowoirsRoutes.PROFILE,
        title = "Profil",
        selectedIcon = Icons.Filled.Person,
        unselectedIcon = Icons.Outlined.Person
    )

    companion object {
        val items = listOf(Home, Cats, Memories, Profile)
    }
}
