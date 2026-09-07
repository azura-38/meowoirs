package com.limanex.meowoirs.ui.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * MeowoirsPrimaryButton: Warm, elegant primary button with 48dp minimum touch target.
 */
@Composable
fun MeowoirsPrimaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    leadingIcon: (@Composable () -> Unit)? = null
) {
    Button(
        onClick = onClick,
        modifier = modifier
            .defaultMinSize(minHeight = 48.dp)
            .semantics { role = Role.Button },
        enabled = enabled,
        shape = FullCornerShape,
        colors = ButtonDefaults.buttonColors(
            containerColor = MeowoirsTheme.colors.orange,
            contentColor = Color.White,
            disabledContainerColor = MeowoirsTheme.colors.cardBorder,
            disabledContentColor = MeowoirsTheme.colors.textTertiary
        ),
        contentPadding = PaddingValues(
            horizontal = MeowoirsTheme.spacing.large,
            vertical = MeowoirsTheme.spacing.mediumSmall
        )
    ) {
        if (leadingIcon != null) {
            leadingIcon()
            androidx.compose.foundation.layout.Spacer(
                modifier = Modifier.size(MeowoirsTheme.spacing.small)
            )
        }
        Text(
            text = text,
            style = MeowoirsTheme.typography.labelLarge
        )
    }
}

/**
 * MeowoirsSecondaryButton: Subtle warm outlined button.
 */
@Composable
fun MeowoirsSecondaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    leadingIcon: (@Composable () -> Unit)? = null
) {
    OutlinedButton(
        onClick = onClick,
        modifier = modifier
            .defaultMinSize(minHeight = 48.dp)
            .semantics { role = Role.Button },
        enabled = enabled,
        shape = FullCornerShape,
        border = BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
        colors = ButtonDefaults.outlinedButtonColors(
            containerColor = Color.Transparent,
            contentColor = MeowoirsTheme.colors.textPrimary,
            disabledContentColor = MeowoirsTheme.colors.textTertiary
        ),
        contentPadding = PaddingValues(
            horizontal = MeowoirsTheme.spacing.large,
            vertical = MeowoirsTheme.spacing.mediumSmall
        )
    ) {
        if (leadingIcon != null) {
            leadingIcon()
            androidx.compose.foundation.layout.Spacer(
                modifier = Modifier.size(MeowoirsTheme.spacing.small)
            )
        }
        Text(
            text = text,
            style = MeowoirsTheme.typography.labelLarge
        )
    }
}

/**
 * MeowoirsIconButton: Accessible icon button with minimum 48dp touch target.
 */
@Composable
fun MeowoirsIconButton(
    icon: ImageVector,
    contentDescription: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    tint: Color = MeowoirsTheme.colors.textPrimary,
    containerColor: Color = Color.Transparent
) {
    IconButton(
        onClick = onClick,
        modifier = modifier
            .size(48.dp)
            .semantics {
                this.contentDescription = contentDescription
                role = Role.Button
            },
        colors = IconButtonDefaults.iconButtonColors(
            containerColor = containerColor,
            contentColor = tint
        )
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = tint,
            modifier = Modifier.size(24.dp)
        )
    }
}
