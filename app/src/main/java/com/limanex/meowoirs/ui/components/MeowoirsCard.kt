package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * MeowoirsCard: Central card container for memory entries, cat profiles, and editorial content.
 */
@Composable
fun MeowoirsCard(
    modifier: Modifier = Modifier,
    shape: Shape = MeowoirsTheme.shapes.medium,
    containerColor: Color = MeowoirsTheme.colors.cardBackground,
    border: BorderStroke? = BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
    elevation: Dp = MeowoirsTheme.elevations.level1,
    contentPadding: Dp = MeowoirsTheme.spacing.medium,
    onClick: (() -> Unit)? = null,
    content: @Composable ColumnScope.() -> Unit
) {
    if (onClick != null) {
        Card(
            onClick = onClick,
            modifier = modifier,
            shape = shape,
            colors = CardDefaults.cardColors(
                containerColor = containerColor
            ),
            border = border,
            elevation = CardDefaults.cardElevation(defaultElevation = elevation)
        ) {
            Column(modifier = Modifier.padding(contentPadding)) {
                content()
            }
        }
    } else {
        Card(
            modifier = modifier,
            shape = shape,
            colors = CardDefaults.cardColors(
                containerColor = containerColor
            ),
            border = border,
            elevation = CardDefaults.cardElevation(defaultElevation = elevation)
        ) {
            Column(modifier = Modifier.padding(contentPadding)) {
                content()
            }
        }
    }
}
