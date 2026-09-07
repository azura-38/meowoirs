package com.limanex.meowoirs.ui.screens.memories

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * CatSelectionRow: Horizontal selector for choosing which cat this memory belongs to.
 */
@Composable
fun CatSelectionRow(
    cats: List<Cat>,
    selectedCatId: String?,
    onSelectCat: (String) -> Unit,
    onNavigateToAddCat: () -> Unit,
    modifier: Modifier = Modifier
) {
    if (cats.isEmpty()) {
        // Empty cats state
        MeowoirsCard(
            modifier = modifier.fillMaxWidth(),
            shape = MeowoirsTheme.shapes.large,
            contentPadding = MeowoirsTheme.spacing.large
        ) {
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.Pets,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.orange,
                    modifier = Modifier.size(32.dp)
                )
                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                Text(
                    text = "Henüz bir kedin yok.",
                    style = MeowoirsTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    color = MeowoirsTheme.colors.textPrimary,
                    textAlign = TextAlign.Center
                )
                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))
                Text(
                    text = "Anılarını saklamak için önce bir kedi ekle.",
                    style = MeowoirsTheme.typography.bodySmall,
                    color = MeowoirsTheme.colors.textSecondary,
                    textAlign = TextAlign.Center
                )
                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))
                MeowoirsPrimaryButton(
                    text = "İlk Kedini Ekle",
                    onClick = onNavigateToAddCat
                )
            }
        }
    } else {
        LazyRow(
            modifier = modifier.fillMaxWidth(),
            contentPadding = PaddingValues(vertical = MeowoirsTheme.spacing.extraSmall),
            horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
        ) {
            items(cats, key = { it.id }) { cat ->
                val isSelected = cat.id == selectedCatId
                CatSelectableCard(
                    cat = cat,
                    isSelected = isSelected,
                    onClick = { onSelectCat(cat.id) }
                )
            }
        }
    }
}

@Composable
private fun CatSelectableCard(
    cat: Cat,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isHomeCat = cat.type == CatType.HOME
    val accentColor = if (isHomeCat) MeowoirsTheme.colors.orange else MeowoirsTheme.colors.sage
    val accentContainerColor = if (isHomeCat) {
        MeowoirsTheme.colors.accentOrangeContainer
    } else {
        MeowoirsTheme.colors.accentSageContainer
    }
    val borderColor = if (isSelected) accentColor else MeowoirsTheme.colors.cardBorder
    val borderWidth = if (isSelected) 2.dp else 1.dp
    val bgColor = if (isSelected) accentContainerColor.copy(alpha = 0.4f) else MeowoirsTheme.colors.cardBackground

    Card(
        modifier = modifier
            .width(105.dp)
            .clip(MeowoirsTheme.shapes.medium)
            .clickable(onClick = onClick)
            .semantics {
                role = Role.RadioButton
                selected = isSelected
                contentDescription = "${cat.name}, ${cat.type.label}${if (isSelected) ", seçili" else ", seçilmedi"}"
            },
        shape = MeowoirsTheme.shapes.medium,
        colors = CardDefaults.cardColors(containerColor = bgColor),
        border = BorderStroke(borderWidth, borderColor),
        elevation = CardDefaults.cardElevation(
            defaultElevation = if (isSelected) MeowoirsTheme.elevations.level2 else MeowoirsTheme.elevations.level0
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(MeowoirsTheme.spacing.small),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Cat Avatar with Selection Checkmark
            Box(
                modifier = Modifier.size(54.dp),
                contentAlignment = Alignment.Center
            ) {
                Box(
                    modifier = Modifier
                        .size(50.dp)
                        .clip(CircleShape)
                        .background(accentContainerColor),
                    contentAlignment = Alignment.Center
                ) {
                    if (!cat.photoUri.isNullOrBlank()) {
                        AsyncImage(
                            model = cat.photoUri,
                            contentDescription = null,
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize()
                        )
                    } else {
                        Icon(
                            imageVector = Icons.Outlined.Pets,
                            contentDescription = null,
                            tint = accentColor,
                            modifier = Modifier.size(24.dp)
                        )
                    }
                }

                // Selection checkmark badge
                if (isSelected) {
                    Box(
                        modifier = Modifier
                            .align(Alignment.BottomEnd)
                            .size(18.dp)
                            .clip(CircleShape)
                            .background(accentColor),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Check,
                            contentDescription = "Seçildi",
                            tint = Color.White,
                            modifier = Modifier.size(12.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))

            // Cat Name
            Text(
                text = cat.name,
                style = MeowoirsTheme.typography.titleSmall,
                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                color = MeowoirsTheme.colors.textPrimary,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )

            Spacer(modifier = Modifier.height(2.dp))

            // Type Label
            Text(
                text = cat.type.label,
                style = MeowoirsTheme.typography.labelSmall,
                color = if (isSelected) accentColor else MeowoirsTheme.colors.textSecondary
            )
        }
    }
}
