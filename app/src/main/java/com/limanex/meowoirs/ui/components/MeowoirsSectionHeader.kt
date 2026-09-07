package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * MeowoirsSectionHeader: Editorial header for memory book sections.
 */
@Composable
fun MeowoirsSectionHeader(
    title: String,
    modifier: Modifier = Modifier,
    subtitle: String? = null,
    actionText: String? = null,
    onActionClick: (() -> Unit)? = null
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = MeowoirsTheme.spacing.small),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                style = MeowoirsTheme.typography.titleLarge,
                color = MeowoirsTheme.colors.textPrimary,
                fontWeight = FontWeight.SemiBold
            )
            if (subtitle != null) {
                Text(
                    text = subtitle,
                    style = MeowoirsTheme.typography.bodySmall,
                    color = MeowoirsTheme.colors.textSecondary,
                    modifier = Modifier.padding(top = MeowoirsTheme.spacing.xxSmall)
                )
            }
        }
        if (actionText != null && onActionClick != null) {
            Text(
                text = actionText,
                style = MeowoirsTheme.typography.labelMedium,
                color = MeowoirsTheme.colors.orange,
                fontWeight = FontWeight.Medium,
                modifier = Modifier
                    .padding(start = MeowoirsTheme.spacing.medium)
                    .clickable(onClick = onActionClick)
                    .padding(
                        horizontal = MeowoirsTheme.spacing.small,
                        vertical = MeowoirsTheme.spacing.extraSmall
                    )
            )
        }
    }
}
