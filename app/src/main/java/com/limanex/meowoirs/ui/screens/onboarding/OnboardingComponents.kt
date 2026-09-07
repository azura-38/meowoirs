package com.limanex.meowoirs.ui.screens.onboarding

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.ArrowForward
import androidx.compose.material.icons.outlined.AutoStories
import androidx.compose.material.icons.outlined.Check
import androidx.compose.material.icons.outlined.FilterVintage
import androidx.compose.material.icons.outlined.KeyboardArrowDown
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material.icons.outlined.Shield
import androidx.compose.material.icons.outlined.Smartphone
import androidx.compose.material.icons.outlined.Spa
import androidx.compose.material.icons.outlined.WbSunny
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.limanex.meowoirs.R
import com.limanex.meowoirs.ui.screens.settings.SupportedLanguages
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme

/**
 * Editorial Header for Onboarding:
 * Displays Brand Emblem Logo + Brand Title on the left,
 * and Language Selector Dropdown + "ATLA" (Skip) on the right.
 * Skip is hidden on the final legal screen (step 4).
 */
@Composable
fun OnboardingHeader(
    currentLanguageCode: String,
    onSelectLanguage: (String) -> Unit,
    onSkip: () -> Unit,
    showSkip: Boolean,
    modifier: Modifier = Modifier
) {
    var languageDropdownExpanded by remember { mutableStateOf(false) }

    val displayLangCode = if (currentLanguageCode.isNotBlank()) {
        currentLanguageCode.uppercase()
    } else {
        "TR"
    }

    Row(
        modifier = modifier
            .fillMaxWidth()
            .height(56.dp)
            .padding(horizontal = 20.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Brand Logo & Title
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Image(
                painter = painterResource(R.drawable.onboarding_logo),
                contentDescription = "Meowoirs Emblem",
                modifier = Modifier.size(30.dp),
                contentScale = ContentScale.Fit
            )
            Text(
                text = "MEOWOIRS",
                fontFamily = FontFamily.SansSerif,
                fontWeight = FontWeight.SemiBold,
                fontSize = 18.sp,
                letterSpacing = 3.sp,
                color = MeowoirsTheme.colors.textPrimary
            )
        }

        // Language Selector and Skip CTA
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Language selector button
            Box {
                Row(
                    modifier = Modifier
                        .clip(RoundedCornerShape(8.dp))
                        .clickable { languageDropdownExpanded = true }
                        .padding(horizontal = 8.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(2.dp)
                ) {
                    Text(
                        text = displayLangCode,
                        fontFamily = FontFamily.SansSerif,
                        fontWeight = FontWeight.Medium,
                        fontSize = 12.sp,
                        letterSpacing = 1.sp,
                        color = MeowoirsTheme.colors.textSecondary
                    )
                    Icon(
                        imageVector = Icons.Outlined.KeyboardArrowDown,
                        contentDescription = "Select Language",
                        modifier = Modifier.size(16.dp),
                        tint = MeowoirsTheme.colors.textSecondary
                    )
                }

                DropdownMenu(
                    expanded = languageDropdownExpanded,
                    onDismissRequest = { languageDropdownExpanded = false },
                    modifier = Modifier.background(MeowoirsTheme.colors.cardBackground)
                ) {
                    SupportedLanguages.forEach { lang ->
                        DropdownMenuItem(
                            text = {
                                Text(
                                    text = "${lang.displayName} (${lang.code.uppercase()})",
                                    style = MeowoirsTheme.typography.bodyMedium,
                                    color = if (lang.code.equals(currentLanguageCode, ignoreCase = true)) {
                                        MeowoirsTheme.colors.orange
                                    } else {
                                        MeowoirsTheme.colors.textPrimary
                                    },
                                    fontWeight = if (lang.code.equals(currentLanguageCode, ignoreCase = true)) {
                                        FontWeight.Bold
                                    } else {
                                        FontWeight.Normal
                                    }
                                )
                            },
                            onClick = {
                                languageDropdownExpanded = false
                                onSelectLanguage(lang.code)
                            }
                        )
                    }
                }
            }

            // Skip CTA button (Screen 1-3 only)
            if (showSkip) {
                TextButton(
                    onClick = onSkip,
                    contentPadding = androidx.compose.foundation.layout.PaddingValues(horizontal = 8.dp, vertical = 6.dp)
                ) {
                    Text(
                        text = stringResource(R.string.onboarding_skip),
                        fontFamily = FontFamily.SansSerif,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 12.sp,
                        letterSpacing = 1.5.sp,
                        color = MeowoirsTheme.colors.textSecondary
                    )
                }
            }
        }
    }
}

/**
 * 4-Dot Editorial Pagination Indicator.
 * Screen 1: ● ○ ○ ○
 * Screen 2: ○ ● ○ ○
 * Screen 3: ○ ● ○ ○
 * Screen 4: ○ ● ○ ○
 */
@Composable
fun OnboardingPagination(
    currentStep: Int,
    modifier: Modifier = Modifier,
    totalSteps: Int = 4
) {
    Row(
        modifier = modifier,
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        for (step in 1..totalSteps) {
            val isSelected = step == currentStep
            val isPassed = step < currentStep

            val dotWidth by animateDpAsState(
                targetValue = if (isSelected) 24.dp else 8.dp,
                animationSpec = tween(durationMillis = 300),
                label = "dotWidth"
            )

            Box(
                modifier = Modifier
                    .height(8.dp)
                    .width(dotWidth)
                    .clip(CircleShape)
                    .background(
                        when {
                            isSelected -> MeowoirsTheme.colors.orange
                            isPassed -> MeowoirsTheme.colors.orange.copy(alpha = 0.45f)
                            else -> MeowoirsTheme.colors.cardBorder
                        }
                    )
            )
        }
    }
}

/**
 * Feature highlight card with icon, title and description.
 */
@Composable
fun OnboardingFeatureCard(
    icon: ImageVector,
    title: String,
    description: String,
    modifier: Modifier = Modifier,
    iconTint: Color = MeowoirsTheme.colors.orange
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(
            containerColor = MeowoirsTheme.colors.cardBackground
        ),
        border = androidx.compose.foundation.BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(42.dp)
                    .clip(CircleShape)
                    .background(iconTint.copy(alpha = 0.12f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    modifier = Modifier.size(22.dp),
                    tint = iconTint
                )
            }

            Column(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(3.dp)
            ) {
                Text(
                    text = title,
                    fontFamily = FontFamily.SansSerif,
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 15.sp,
                    color = MeowoirsTheme.colors.textPrimary
                )
                Text(
                    text = description,
                    fontFamily = FontFamily.SansSerif,
                    fontSize = 13.sp,
                    lineHeight = 18.sp,
                    color = MeowoirsTheme.colors.textSecondary
                )
            }
        }
    }
}

/**
 * Primary CTA Button with Arrow Forward Icon.
 */
@Composable
fun OnboardingPrimaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true
) {
    Button(
        onClick = onClick,
        modifier = modifier
            .fillMaxWidth()
            .height(54.dp),
        enabled = enabled,
        shape = FullCornerShape,
        colors = ButtonDefaults.buttonColors(
            containerColor = MeowoirsTheme.colors.orange,
            contentColor = Color.White,
            disabledContainerColor = MeowoirsTheme.colors.cardBorder,
            disabledContentColor = MeowoirsTheme.colors.textTertiary
        ),
        elevation = ButtonDefaults.buttonElevation(defaultElevation = 3.dp, pressedElevation = 6.dp)
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            Text(
                text = text,
                fontFamily = FontFamily.SansSerif,
                fontWeight = FontWeight.SemiBold,
                fontSize = 16.sp,
                letterSpacing = 0.5.sp
            )
            Spacer(modifier = Modifier.width(8.dp))
            Icon(
                imageVector = Icons.AutoMirrored.Outlined.ArrowForward,
                contentDescription = null,
                modifier = Modifier.size(18.dp)
            )
        }
    }
}

/**
 * Subtle Editorial Footer text with bullet separator.
 */
@Composable
fun OnboardingEditorialFooter(
    leftText: String,
    rightText: String,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = leftText,
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Medium,
            fontSize = 11.sp,
            letterSpacing = 2.sp,
            color = MeowoirsTheme.colors.textTertiary
        )
        Text(
            text = " • ",
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Medium,
            fontSize = 11.sp,
            color = MeowoirsTheme.colors.textTertiary
        )
        Text(
            text = rightText,
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Medium,
            fontSize = 11.sp,
            letterSpacing = 2.sp,
            color = MeowoirsTheme.colors.textTertiary
        )
    }
}

/**
 * Screen 4: Luxury Padlock and Cat Silhouette Illustration with Emblem Badge.
 */
@Composable
fun PrivacyLockIllustration(
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier.size(112.dp),
        contentAlignment = Alignment.Center
    ) {
        // Glow backdrop
        Box(
            modifier = Modifier
                .size(96.dp)
                .clip(CircleShape)
                .background(
                    Brush.radialGradient(
                        colors = listOf(
                            MeowoirsTheme.colors.orange.copy(alpha = 0.18f),
                            Color.Transparent
                        )
                    )
                )
        )

        // Main circular badge
        Box(
            modifier = Modifier
                .size(86.dp)
                .shadow(6.dp, CircleShape)
                .clip(CircleShape)
                .background(MeowoirsTheme.colors.cardBackground)
                .border(1.5.dp, MeowoirsTheme.colors.cardBorder, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            val primaryColor = MeowoirsTheme.colors.textPrimary
            val accentColor = MeowoirsTheme.colors.orange
            val bgInnerColor = MeowoirsTheme.colors.cream

            Canvas(modifier = Modifier.size(46.dp)) {
                val w = size.width
                val h = size.height

                // Shackle (arc with cat ears)
                val shacklePath = Path().apply {
                    moveTo(w * 0.30f, h * 0.44f)
                    lineTo(w * 0.30f, h * 0.30f)
                    // Cat ear left
                    lineTo(w * 0.38f, h * 0.16f)
                    lineTo(w * 0.44f, h * 0.22f)
                    // Top curve
                    cubicTo(w * 0.46f, h * 0.19f, w * 0.54f, h * 0.19f, w * 0.56f, h * 0.22f)
                    // Cat ear right
                    lineTo(w * 0.62f, h * 0.16f)
                    lineTo(w * 0.70f, h * 0.30f)
                    lineTo(w * 0.70f, h * 0.44f)
                }
                drawPath(
                    path = shacklePath,
                    color = primaryColor,
                    style = Stroke(width = 3.5f, cap = StrokeCap.Round)
                )

                // Lock Body
                val bodyRect = androidx.compose.ui.geometry.Rect(
                    offset = Offset(w * 0.20f, h * 0.42f),
                    size = Size(w * 0.60f, h * 0.46f)
                )
                drawRoundRect(
                    color = bgInnerColor,
                    topLeft = bodyRect.topLeft,
                    size = bodyRect.size,
                    cornerRadius = CornerRadius(10f, 10f)
                )
                drawRoundRect(
                    color = primaryColor,
                    topLeft = bodyRect.topLeft,
                    size = bodyRect.size,
                    cornerRadius = CornerRadius(10f, 10f),
                    style = Stroke(width = 3.2f)
                )

                // Keyhole (circle + slot)
                drawCircle(
                    color = accentColor,
                    radius = 4f,
                    center = Offset(w * 0.50f, h * 0.60f)
                )
                val keyholeSlot = Path().apply {
                    moveTo(w * 0.48f, h * 0.62f)
                    lineTo(w * 0.46f, h * 0.72f)
                    lineTo(w * 0.54f, h * 0.72f)
                    lineTo(w * 0.52f, h * 0.62f)
                    close()
                }
                drawPath(path = keyholeSlot, color = accentColor)
            }
        }

        // Secondary emblem badge on bottom right
        Box(
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .offset(x = 2.dp, y = 2.dp)
                .size(32.dp)
                .shadow(4.dp, CircleShape)
                .clip(CircleShape)
                .background(MeowoirsTheme.colors.orange)
                .padding(6.dp),
            contentAlignment = Alignment.Center
        ) {
            Image(
                painter = painterResource(R.drawable.onboarding_logo),
                contentDescription = null,
                modifier = Modifier.fillMaxSize(),
                contentScale = ContentScale.Fit
            )
        }
    }
}

/**
 * Safely opens a web URL in an external browser, guarding against crashes.
 */
fun openUrlSafely(context: Context, url: String) {
    try {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    } catch (e: Exception) {
        Toast.makeText(context, "Could not open browser", Toast.LENGTH_SHORT).show()
    }
}
