package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.layout.RowScope
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * MeowoirsTopBar: Warm, minimalist top app bar with editorial styling.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MeowoirsTopBar(
    title: String,
    modifier: Modifier = Modifier,
    canNavigateBack: Boolean = false,
    onNavigateBack: () -> Unit = {},
    actions: @Composable RowScope.() -> Unit = {}
) {
    TopAppBar(
        title = {
            Text(
                text = title,
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )
        },
        modifier = modifier,
        navigationIcon = {
            if (canNavigateBack) {
                IconButton(onClick = onNavigateBack) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Geri dön",
                        tint = MeowoirsTheme.colors.textPrimary
                    )
                }
            }
        },
        actions = actions,
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = Color.Transparent,
            scrolledContainerColor = MeowoirsTheme.colors.cardBackground,
            navigationIconContentColor = MeowoirsTheme.colors.textPrimary,
            titleContentColor = MeowoirsTheme.colors.textPrimary,
            actionIconContentColor = MeowoirsTheme.colors.textPrimary
        )
    )
}
