package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.limanex.meowoirs.ui.navigation.BottomNavItem
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * MeowoirsBottomNavigation: Clean, lightweight, warm navigation bar.
 */
@Composable
fun MeowoirsBottomNavigation(
    currentRoute: String?,
    onNavigateToRoute: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    NavigationBar(
        modifier = modifier,
        containerColor = MeowoirsTheme.colors.cardBackground,
        contentColor = MeowoirsTheme.colors.textPrimary,
        tonalElevation = MeowoirsTheme.elevations.level1
    ) {
        BottomNavItem.items.forEach { item ->
            val selected = currentRoute == item.route
            NavigationBarItem(
                selected = selected,
                onClick = { onNavigateToRoute(item.route) },
                icon = {
                    Icon(
                        imageVector = if (selected) item.selectedIcon else item.unselectedIcon,
                        contentDescription = item.title,
                        modifier = Modifier.size(24.dp)
                    )
                },
                label = {
                    Text(
                        text = item.title,
                        style = MeowoirsTheme.typography.labelSmall
                    )
                },
                colors = NavigationBarItemDefaults.colors(
                    selectedIconColor = MeowoirsTheme.colors.orange,
                    selectedTextColor = MeowoirsTheme.colors.orange,
                    unselectedIconColor = MeowoirsTheme.colors.textSecondary,
                    unselectedTextColor = MeowoirsTheme.colors.textSecondary,
                    indicatorColor = MeowoirsTheme.colors.accentOrangeContainer
                )
            )
        }
    }
}
