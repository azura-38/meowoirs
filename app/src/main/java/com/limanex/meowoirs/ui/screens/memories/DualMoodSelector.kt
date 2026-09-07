package com.limanex.meowoirs.ui.screens.memories

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Favorite
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

object MoodConstants {
    val catMoods = listOf("Mutlu", "Meraklı", "Uykulu", "Oyuncu", "Sakin", "Sevecen")
    val userMoods = listOf("Mutlu", "Huzurlu", "Özlemli", "Neşeli", "Sakin", "Duygusal")
}

/**
 * DualMoodSelector: Presents two distinct emotional perspectives:
 * 1. Cat's Mood ("Onun ruh hâli")
 * 2. User's Mood ("Sen nasıl hissettin?")
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
fun DualMoodSelector(
    selectedCatMood: String?,
    onSelectCatMood: (String) -> Unit,
    selectedUserMood: String?,
    onSelectUserMood: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        // --- 1. Cat Mood Section ---
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(bottom = MeowoirsTheme.spacing.small)
        ) {
            Icon(
                imageVector = Icons.Outlined.Pets,
                contentDescription = null,
                tint = MeowoirsTheme.colors.orange,
                modifier = Modifier.size(16.dp)
            )
            Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
            Text(
                text = "Onun ruh hâli",
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )
        }

        FlowRow(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small),
            verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
        ) {
            MoodConstants.catMoods.forEach { mood ->
                val isSelected = selectedCatMood == mood
                MoodSelectChip(
                    label = mood,
                    isSelected = isSelected,
                    leadingIcon = null,
                    selectedContainerColor = MeowoirsTheme.colors.accentOrangeContainer,
                    selectedContentColor = MeowoirsTheme.colors.orange,
                    onClick = { onSelectCatMood(mood) }
                )
            }
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // --- 2. User Mood Section ---
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(bottom = MeowoirsTheme.spacing.small)
        ) {
            Icon(
                imageVector = Icons.Outlined.Favorite,
                contentDescription = null,
                tint = MeowoirsTheme.colors.lavender,
                modifier = Modifier.size(16.dp)
            )
            Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
            Text(
                text = "Sen nasıl hissettin?",
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )
        }

        FlowRow(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small),
            verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
        ) {
            MoodConstants.userMoods.forEach { mood ->
                val isSelected = selectedUserMood == mood
                MoodSelectChip(
                    label = "♡ $mood",
                    isSelected = isSelected,
                    leadingIcon = null,
                    selectedContainerColor = MeowoirsTheme.colors.accentLavenderContainer,
                    selectedContentColor = MeowoirsTheme.colors.lavender,
                    onClick = { onSelectUserMood(mood) }
                )
            }
        }
    }
}

@Composable
private fun MoodSelectChip(
    label: String,
    isSelected: Boolean,
    selectedContainerColor: androidx.compose.ui.graphics.Color,
    selectedContentColor: androidx.compose.ui.graphics.Color,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    leadingIcon: (@Composable () -> Unit)? = null
) {
    val containerColor = if (isSelected) selectedContainerColor else MeowoirsTheme.colors.cardBackground
    val contentColor = if (isSelected) selectedContentColor else MeowoirsTheme.colors.textSecondary
    val borderColor = if (isSelected) selectedContentColor else MeowoirsTheme.colors.cardBorder

    Surface(
        modifier = modifier
            .defaultMinSize(minHeight = 44.dp)
            .clip(FullCornerShape)
            .clickable(onClick = onClick)
            .semantics {
                role = Role.Checkbox
                selected = isSelected
                contentDescription = "$label${if (isSelected) ", seçildi" else ", seçilmedi"}"
            },
        shape = FullCornerShape,
        color = containerColor,
        border = BorderStroke(1.dp, borderColor)
    ) {
        Row(
            modifier = Modifier.padding(
                horizontal = MeowoirsTheme.spacing.mediumSmall,
                vertical = MeowoirsTheme.spacing.extraSmall + 2.dp
            ),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (leadingIcon != null) {
                leadingIcon()
                Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
            }
            Text(
                text = label,
                style = MeowoirsTheme.typography.labelMedium,
                fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Normal,
                color = contentColor
            )
        }
    }
}
