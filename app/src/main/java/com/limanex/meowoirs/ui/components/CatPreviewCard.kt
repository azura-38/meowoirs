package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
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
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * CatPreviewCard: Compact card for the "Kedilerin" horizontal row on the Home screen.
 */
@Composable
fun CatPreviewCard(
    cat: Cat,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isHomeCat = cat.type == CatType.HOME
    val badgeColor = if (isHomeCat) MeowoirsTheme.colors.orange else MeowoirsTheme.colors.sage
    val badgeBgColor = if (isHomeCat) {
        MeowoirsTheme.colors.accentOrangeContainer
    } else {
        MeowoirsTheme.colors.accentSageContainer
    }
    val typeAccessibilityLabel = if (isHomeCat) "Ev Kedisi" else "Sokak Kedisi"

    Card(
        modifier = modifier
            .width(110.dp)
            .clickable(onClick = onClick)
            .semantics {
                role = Role.Button
                contentDescription = "${cat.name} kedisinin hikâyesini aç"
            },
        shape = MeowoirsTheme.shapes.medium,
        colors = CardDefaults.cardColors(
            containerColor = MeowoirsTheme.colors.cardBackground
        ),
        border = BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
        elevation = CardDefaults.cardElevation(defaultElevation = MeowoirsTheme.elevations.level1)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(MeowoirsTheme.spacing.small),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Cat Photo / Avatar
            Box(
                modifier = Modifier
                    .size(60.dp)
                    .clip(CircleShape)
                    .background(badgeBgColor),
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
                        tint = badgeColor,
                        modifier = Modifier.size(26.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            // Cat Name
            Text(
                text = cat.name,
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))

            // Subtle Type Indicator
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.Center
            ) {
                Box(
                    modifier = Modifier
                        .size(5.dp)
                        .clip(CircleShape)
                        .background(badgeColor)
                )
                Spacer(modifier = Modifier.width(4.dp))
                Text(
                    text = cat.type.label,
                    style = MeowoirsTheme.typography.labelSmall,
                    color = MeowoirsTheme.colors.textSecondary
                )
            }
        }
    }
}
