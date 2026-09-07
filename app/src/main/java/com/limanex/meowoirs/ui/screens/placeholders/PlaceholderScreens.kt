package com.limanex.meowoirs.ui.screens.placeholders

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSecondaryButton
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

@Composable
private fun BasePlaceholder(
    title: String,
    subtitle: String,
    extraContent: (@Composable () -> Unit)? = null
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MeowoirsTheme.colors.cream)
            .padding(MeowoirsTheme.spacing.large),
        contentAlignment = Alignment.Center
    ) {
        MeowoirsCard(modifier = Modifier.padding(MeowoirsTheme.spacing.medium)) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Text(
                    text = title,
                    style = MeowoirsTheme.typography.headlineMedium,
                    color = MeowoirsTheme.colors.textPrimary,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center
                )
                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                Text(
                    text = subtitle,
                    style = MeowoirsTheme.typography.bodyMedium,
                    color = MeowoirsTheme.colors.textSecondary,
                    textAlign = TextAlign.Center
                )
                if (extraContent != null) {
                    Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))
                    extraContent()
                }
            }
        }
    }
}

@Composable
fun HomePlaceholder() {
    BasePlaceholder(
        title = "Home Screen",
        subtitle = "Route: 'home'\nPlaceholder for Meowoirs Home Feed"
    )
}

@Composable
fun CatsPlaceholder(
    onNavigateToAddCat: () -> Unit,
    onNavigateToCatDetail: (String) -> Unit
) {
    BasePlaceholder(
        title = "Cats Screen",
        subtitle = "Route: 'cats'\nPlaceholder for Cat Profiles & Street Cats",
        extraContent = {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
            ) {
                MeowoirsPrimaryButton(
                    text = "Test: Kedi Ekle (add_cat)",
                    onClick = onNavigateToAddCat
                )
                MeowoirsSecondaryButton(
                    text = "Test: Kedi Detayı (cat_detail/1)",
                    onClick = { onNavigateToCatDetail("1") }
                )
            }
        }
    )
}

@Composable
fun MemoriesPlaceholder() {
    BasePlaceholder(
        title = "Memories Screen",
        subtitle = "Route: 'memories'\nPlaceholder for Memory Gallery & Timeline"
    )
}

@Composable
fun MyStoryPlaceholder() {
    BasePlaceholder(
        title = "My Story Screen",
        subtitle = "Route: 'my_story'\nPlaceholder for Personal Memoir & Stats"
    )
}

@Composable
fun AddMemoryPlaceholder(onBack: () -> Unit) {
    BasePlaceholder(
        title = "Add Memory Screen",
        subtitle = "Route: 'add_memory'\nPlaceholder for creating a new cat memory",
        extraContent = {
            MeowoirsSecondaryButton(
                text = "Geri Dön",
                onClick = onBack
            )
        }
    )
}

@Composable
fun AddCatPlaceholder(onBack: () -> Unit) {
    BasePlaceholder(
        title = "Add Cat Screen",
        subtitle = "Route: 'add_cat'\nPlaceholder for onboarding or adding a new cat",
        extraContent = {
            MeowoirsSecondaryButton(
                text = "Geri Dön",
                onClick = onBack
            )
        }
    )
}

@Composable
fun CatDetailPlaceholder(catId: String, onBack: () -> Unit) {
    BasePlaceholder(
        title = "Cat Detail Screen",
        subtitle = "Route: 'cat_detail/$catId'\nPlaceholder for individual cat profile",
        extraContent = {
            MeowoirsSecondaryButton(
                text = "Geri Dön",
                onClick = onBack
            )
        }
    )
}
