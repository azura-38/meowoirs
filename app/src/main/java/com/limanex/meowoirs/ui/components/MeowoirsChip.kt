package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

enum class MeowoirsMoodType {
    JOYFUL,
    PEACEFUL,
    PLAYFUL,
    STREET_CAT,
    GENTLE
}

/**
 * MeowoirsChip: Generic tag chip for cat traits, categories, or filters.
 */
@Composable
fun MeowoirsChip(
    label: String,
    modifier: Modifier = Modifier,
    isSelected: Boolean = false,
    icon: ImageVector? = null,
    onClick: (() -> Unit)? = null
) {
    val targetContainerColor = if (isSelected) {
        MeowoirsTheme.colors.accentOrangeContainer
    } else {
        MeowoirsTheme.colors.cardBackground
    }
    val targetContentColor = if (isSelected) {
        MeowoirsTheme.colors.orange
    } else {
        MeowoirsTheme.colors.textSecondary
    }
    val targetBorderColor = if (isSelected) {
        MeowoirsTheme.colors.orange
    } else {
        MeowoirsTheme.colors.cardBorder
    }

    val containerColor by androidx.compose.animation.animateColorAsState(
        targetValue = targetContainerColor,
        animationSpec = androidx.compose.animation.core.tween(durationMillis = 200),
        label = "chipContainerColor"
    )
    val contentColor by androidx.compose.animation.animateColorAsState(
        targetValue = targetContentColor,
        animationSpec = androidx.compose.animation.core.tween(durationMillis = 200),
        label = "chipContentColor"
    )
    val borderColor by androidx.compose.animation.animateColorAsState(
        targetValue = targetBorderColor,
        animationSpec = androidx.compose.animation.core.tween(durationMillis = 200),
        label = "chipBorderColor"
    )

    Surface(
        modifier = modifier
            .defaultMinSize(minHeight = 44.dp)
            .clip(FullCornerShape)
            .then(
                if (onClick != null) {
                    Modifier
                        .clickable(onClick = onClick)
                        .semantics {
                            role = Role.Tab
                            selected = isSelected
                        }
                } else Modifier
            ),
        shape = FullCornerShape,
        color = containerColor,
        border = BorderStroke(1.dp, borderColor)
    ) {
        Row(
            modifier = Modifier.padding(
                horizontal = MeowoirsTheme.spacing.mediumSmall,
                vertical = MeowoirsTheme.spacing.extraSmall
            ),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (icon != null) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = contentColor,
                    modifier = Modifier.size(16.dp)
                )
                Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
            }
            Text(
                text = label,
                style = MeowoirsTheme.typography.labelMedium,
                color = contentColor
            )
        }
    }
}

/**
 * MeowoirsMoodChip: Distinct emotional and contextual badge (e.g. Joyful, Peaceful, Street-cat).
 */
@Composable
fun MeowoirsMoodChip(
    mood: MeowoirsMoodType,
    label: String,
    modifier: Modifier = Modifier,
    onClick: (() -> Unit)? = null
) {
    val (bgColor, tintColor) = when (mood) {
        MeowoirsMoodType.JOYFUL -> Pair(
            MeowoirsTheme.colors.accentOrangeContainer,
            MeowoirsTheme.colors.orange
        )
        MeowoirsMoodType.PEACEFUL -> Pair(
            MeowoirsTheme.colors.accentSageContainer,
            MeowoirsTheme.colors.sage
        )
        MeowoirsMoodType.PLAYFUL -> Pair(
            MeowoirsTheme.colors.accentLavenderContainer,
            MeowoirsTheme.colors.lavender
        )
        MeowoirsMoodType.STREET_CAT -> Pair(
            MeowoirsTheme.colors.streetCatBadgeContainer,
            MeowoirsTheme.colors.streetCatBadge
        )
        MeowoirsMoodType.GENTLE -> Pair(
            MeowoirsTheme.colors.cardBackground,
            MeowoirsTheme.colors.textSecondary
        )
    }

    Surface(
        modifier = modifier
            .defaultMinSize(minHeight = 32.dp)
            .clip(FullCornerShape)
            .then(if (onClick != null) Modifier.clickable(onClick = onClick) else Modifier),
        shape = FullCornerShape,
        color = bgColor,
        border = BorderStroke(1.dp, tintColor.copy(alpha = 0.3f))
    ) {
        Row(
            modifier = Modifier.padding(
                horizontal = MeowoirsTheme.spacing.small + 2.dp,
                vertical = MeowoirsTheme.spacing.extraSmall
            ),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(6.dp)
                    .clip(CircleShape)
                    .background(tintColor)
            )
            Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.small))
            Text(
                text = label,
                style = MeowoirsTheme.typography.labelSmall,
                color = tintColor
            )
        }
    }
}
