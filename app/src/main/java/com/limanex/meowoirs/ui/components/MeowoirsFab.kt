package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.FloatingActionButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * MeowoirsFab: Elegant, prominent Floating Action Button for "Anı Ekle" (Add Memory).
 */
@Composable
fun MeowoirsFab(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    text: String = "Anı Ekle",
    expanded: Boolean = true
) {
    ExtendedFloatingActionButton(
        onClick = onClick,
        modifier = modifier.semantics {
            contentDescription = text
            role = Role.Button
        },
        shape = FullCornerShape,
        containerColor = MeowoirsTheme.colors.orange,
        contentColor = Color.White,
        elevation = FloatingActionButtonDefaults.elevation(
            defaultElevation = MeowoirsTheme.elevations.level2,
            pressedElevation = MeowoirsTheme.elevations.level3
        )
    ) {
        Icon(
            imageVector = Icons.Default.Add,
            contentDescription = null
        )
        if (expanded) {
            Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.small))
            Text(
                text = text,
                style = MeowoirsTheme.typography.labelLarge,
                fontWeight = FontWeight.SemiBold
            )
        }
    }
}
