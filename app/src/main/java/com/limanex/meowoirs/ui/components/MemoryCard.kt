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
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.CameraAlt
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Editorial MemoryCard: Priority on photo, cat name, personal note, moods, and date.
 */
@Composable
fun MemoryCard(
    memory: Memory,
    modifier: Modifier = Modifier,
    showCatName: Boolean = true,
    onClick: (() -> Unit)? = null
) {
    val formattedDate = remember(memory.createdAt) {
        val sdf = SimpleDateFormat("d MMMM yyyy", Locale("tr", "TR"))
        sdf.format(Date(memory.createdAt))
    }

    val cardModifier = if (onClick != null) {
        modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .semantics {
                role = Role.Button
                contentDescription = "${memory.catName} ile kaydedilmiş anıyı aç"
            }
    } else {
        modifier
            .fillMaxWidth()
            .semantics {
                contentDescription = "${memory.catName} anısı: ${memory.note}"
            }
    }

    Card(
        modifier = cardModifier,
        shape = MeowoirsTheme.shapes.large,
        colors = CardDefaults.cardColors(
            containerColor = MeowoirsTheme.colors.cardBackground
        ),
        border = BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
        elevation = CardDefaults.cardElevation(defaultElevation = MeowoirsTheme.elevations.level1)
    ) {
        Column(modifier = Modifier.fillMaxWidth()) {
            // 1. Photograph area (4:3 editorial ratio)
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(4f / 3f)
                    .clip(MeowoirsTheme.shapes.large)
                    .background(MeowoirsTheme.colors.accentOrangeContainer.copy(alpha = 0.35f)),
                contentAlignment = Alignment.Center
            ) {
                if (!memory.photoUri.isNullOrBlank()) {
                    coil.compose.SubcomposeAsyncImage(
                        model = memory.photoUri,
                        contentDescription = "${memory.catName} ile bir anı",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize(),
                        error = {
                            Column(
                                horizontalAlignment = Alignment.CenterHorizontally,
                                verticalArrangement = Arrangement.Center
                            ) {
                                Icon(
                                    imageVector = Icons.Outlined.CameraAlt,
                                    contentDescription = null,
                                    tint = MeowoirsTheme.colors.orange.copy(alpha = 0.5f),
                                    modifier = Modifier.size(32.dp)
                                )
                                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
                                Text(
                                    text = memory.catName,
                                    style = MeowoirsTheme.typography.labelMedium,
                                    color = MeowoirsTheme.colors.textSecondary
                                )
                            }
                        }
                    )
                } else {
                    // Elegant warm photographic placeholder
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Icon(
                            imageVector = Icons.Outlined.CameraAlt,
                            contentDescription = null,
                            tint = MeowoirsTheme.colors.orange.copy(alpha = 0.5f),
                            modifier = Modifier.size(32.dp)
                        )
                        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
                        Text(
                            text = memory.catName,
                            style = MeowoirsTheme.typography.labelMedium,
                            color = MeowoirsTheme.colors.textSecondary
                        )
                    }
                }
            }

            // 2. Content & Emotional Story area
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(MeowoirsTheme.spacing.medium)
            ) {
                // Cat Name Header (optional, omitted on CatDetailScreen)
                if (showCatName) {
                    Text(
                        text = memory.catName,
                        style = MeowoirsTheme.typography.titleLarge,
                        fontWeight = FontWeight.SemiBold,
                        color = MeowoirsTheme.colors.textPrimary
                    )
                    Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
                }

                // Short Note / Quote
                Text(
                    text = "“${memory.note}”",
                    style = MeowoirsTheme.typography.bodyLarge,
                    fontStyle = FontStyle.Italic,
                    color = MeowoirsTheme.colors.textPrimary,
                    maxLines = 3,
                    overflow = TextOverflow.Ellipsis
                )

                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.mediumSmall))

                // Mood Indicators & Context
                if (!memory.catMood.isNullOrBlank() || !memory.userMood.isNullOrBlank()) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
                    ) {
                        if (!memory.catMood.isNullOrBlank()) {
                            MeowoirsChip(
                                label = memory.catMood,
                                isSelected = true
                            )
                        }
                        if (!memory.userMood.isNullOrBlank()) {
                            MeowoirsChip(
                                label = "♡ ${memory.userMood}",
                                isSelected = false
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                }

                // Date
                Text(
                    text = formattedDate,
                    style = MeowoirsTheme.typography.bodySmall,
                    color = MeowoirsTheme.colors.textTertiary
                )
            }
        }
    }
}
