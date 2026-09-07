package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * CatCard: Visually substantial card for the 2-column Cats collection grid.
 */
@Composable
fun CatCard(
    cat: Cat,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    memoryCount: Int? = null
) {
    val isHomeCat = cat.type == CatType.HOME
    val accentColor = if (isHomeCat) MeowoirsTheme.colors.orange else MeowoirsTheme.colors.sage
    val accentContainerColor = if (isHomeCat) {
        MeowoirsTheme.colors.accentOrangeContainer
    } else {
        MeowoirsTheme.colors.accentSageContainer
    }
    val typeLabel = if (isHomeCat) "Ev Kedisi" else "Sokak Kedisi"
    val semanticsDesc = buildString {
        append("${cat.name}, $typeLabel.")
        if (memoryCount != null && memoryCount > 0) {
            append(" $memoryCount anı.")
        }
    }

    Card(
        modifier = modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .semantics {
                role = Role.Button
                contentDescription = "${cat.name} kedisinin hikâyesini aç"
            },
        shape = MeowoirsTheme.shapes.large,
        colors = CardDefaults.cardColors(
            containerColor = MeowoirsTheme.colors.cardBackground
        ),
        border = BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
        elevation = CardDefaults.cardElevation(defaultElevation = MeowoirsTheme.elevations.level1)
    ) {
        Column(modifier = Modifier.fillMaxWidth()) {
            // 1. Large Photographic / Portrait Area (1:1 or 4:3)
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f)
                    .clip(MeowoirsTheme.shapes.large)
                    .background(accentContainerColor.copy(alpha = 0.45f)),
                contentAlignment = Alignment.Center
            ) {
                if (!cat.photoUri.isNullOrBlank()) {
                    AsyncImage(
                        model = cat.photoUri,
                        contentDescription = "${cat.name} adlı kedinin fotoğrafı",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize()
                    )
                } else {
                    // Warm intentional silhouette placeholder
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Box(
                            modifier = Modifier
                                .size(56.dp)
                                .clip(CircleShape)
                                .background(accentContainerColor),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Outlined.Pets,
                                contentDescription = null,
                                tint = accentColor,
                                modifier = Modifier.size(28.dp)
                            )
                        }
                    }
                }
            }

            // 2. Info area
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(MeowoirsTheme.spacing.medium)
            ) {
                // Cat Name
                Text(
                    text = cat.name,
                    style = MeowoirsTheme.typography.titleLarge,
                    fontWeight = FontWeight.SemiBold,
                    color = MeowoirsTheme.colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )

                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))

                // Subtle Type Indicator & Optional Memory Count
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    // Subtle Type pill / dot
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(6.dp)
                                .clip(CircleShape)
                                .background(accentColor)
                        )
                        Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
                        Text(
                            text = typeLabel,
                            style = MeowoirsTheme.typography.labelSmall,
                            color = MeowoirsTheme.colors.textSecondary
                        )
                    }

                    // Optional Memory count
                    if (memoryCount != null && memoryCount > 0) {
                        Box(
                            modifier = Modifier
                                .clip(FullCornerShape)
                                .background(MeowoirsTheme.colors.cardBorder.copy(alpha = 0.5f))
                                .padding(
                                    horizontal = MeowoirsTheme.spacing.extraSmall + 2.dp,
                                    vertical = 2.dp
                                )
                        ) {
                            Text(
                                text = "$memoryCount anı",
                                style = MeowoirsTheme.typography.labelSmall,
                                color = MeowoirsTheme.colors.textSecondary
                            )
                        }
                    }
                }
            }
        }
    }
}
