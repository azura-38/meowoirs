package com.limanex.meowoirs.ui.screens.onboarding

import android.content.Context
import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
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
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AutoStories
import androidx.compose.material.icons.outlined.Check
import androidx.compose.material.icons.outlined.FilterVintage
import androidx.compose.material.icons.outlined.Info
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material.icons.outlined.Shield
import androidx.compose.material.icons.outlined.Smartphone
import androidx.compose.material.icons.outlined.Spa
import androidx.compose.material.icons.outlined.WbSunny
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
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
import androidx.lifecycle.viewmodel.compose.viewModel
import com.limanex.meowoirs.R
import com.limanex.meowoirs.config.AppConfig
import com.limanex.meowoirs.data.preferences.UserPreferencesRepository
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.OnboardingUiState
import com.limanex.meowoirs.viewmodel.OnboardingViewModel

/**
 * Native Jetpack Compose Onboarding experience for Meowoirs.
 * Faithfully recreates the editorial, photographic, magazine-like aesthetic
 * from the reference design across 4 sequential screens:
 *
 * Screen 1 — Introduction (Cilt I: Her kedinin bir hikâyesi var)
 * Screen 2 — Memories (Bölüm II: Küçük anları sakla)
 * Screen 3 — Cats & Stories (Bölüm III: Her kedi hikâyende yer alabilir)
 * Screen 4 — Privacy & Legal (Bölüm IV: Hikâyen senin)
 */
@Composable
fun OnboardingScreen(
    onOnboardingFinished: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: OnboardingViewModel = viewModel(factory = OnboardingViewModel.Factory)
) {
    val uiState by viewModel.uiState.collectAsState()
    val context = LocalContext.current
    val preferencesRepo = remember { UserPreferencesRepository.getInstance(context) }
    val currentLanguageCode by preferencesRepo.languageCodeFlow.collectAsState(initial = "tr")

    var showPendingLegalDialog by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(uiState.isCompleted) {
        if (uiState.isCompleted) {
            onOnboardingFinished()
        }
    }

    // Hardware and gesture Back press navigation between onboarding steps
    BackHandler(enabled = uiState.currentStep > 1) {
        viewModel.previousStep()
    }

    // Informational dialog when legal URL is blank or pending publication
    if (showPendingLegalDialog != null) {
        AlertDialog(
            onDismissRequest = { showPendingLegalDialog = null },
            icon = {
                Icon(
                    imageVector = Icons.Outlined.Info,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.orange
                )
            },
            title = {
                Text(
                    text = showPendingLegalDialog ?: "",
                    style = MeowoirsTheme.typography.titleLarge,
                    color = MeowoirsTheme.colors.textPrimary
                )
            },
            text = {
                Text(
                    text = stringResource(R.string.privacy_pending_desc),
                    style = MeowoirsTheme.typography.bodyMedium,
                    color = MeowoirsTheme.colors.textSecondary
                )
            },
            confirmButton = {
                Button(
                    onClick = { showPendingLegalDialog = null },
                    colors = androidx.compose.material3.ButtonDefaults.buttonColors(
                        containerColor = MeowoirsTheme.colors.orange
                    )
                ) {
                    Text(stringResource(R.string.onboarding_legal_ok))
                }
            },
            containerColor = MeowoirsTheme.colors.cardBackground
        )
    }

    Surface(
        modifier = modifier.fillMaxSize(),
        color = MeowoirsTheme.colors.cream
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .windowInsetsPadding(WindowInsets.statusBars)
        ) {
            // Header with Brand Logo + Title, Language selector, and Skip CTA
            OnboardingHeader(
                currentLanguageCode = currentLanguageCode,
                onSelectLanguage = { code -> viewModel.updateLanguage(code) },
                onSkip = { viewModel.skipToLegal() },
                showSkip = uiState.currentStep < 4
            )

            // Step Content animated with smooth horizontal slide and fade
            Box(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
            ) {
                AnimatedContent(
                    targetState = uiState.currentStep,
                    transitionSpec = {
                        val duration = 300
                        val easing = FastOutSlowInEasing
                        if (targetState > initialState) {
                            (slideInHorizontally(
                                animationSpec = tween(duration, easing = easing)
                            ) { it / 3 } + fadeIn(animationSpec = tween(duration)))
                                .togetherWith(
                                    slideOutHorizontally(
                                        animationSpec = tween(duration, easing = easing)
                                    ) { -it / 3 } + fadeOut(animationSpec = tween(duration))
                                )
                        } else {
                            (slideInHorizontally(
                                animationSpec = tween(duration, easing = easing)
                            ) { -it / 3 } + fadeIn(animationSpec = tween(duration)))
                                .togetherWith(
                                    slideOutHorizontally(
                                        animationSpec = tween(duration, easing = easing)
                                    ) { it / 3 } + fadeOut(animationSpec = tween(duration))
                                )
                        }
                    },
                    label = "OnboardingStepTransition"
                ) { step ->
                    when (step) {
                        1 -> OnboardingStepOne(
                            onContinue = { viewModel.nextStep() }
                        )
                        2 -> OnboardingStepTwo(
                            onContinue = { viewModel.nextStep() }
                        )
                        3 -> OnboardingStepThree(
                            onContinue = { viewModel.nextStep() }
                        )
                        4 -> OnboardingStepFour(
                            uiState = uiState,
                            onPrivacyToggle = { viewModel.setPrivacyAccepted(it) },
                            onTermsToggle = { viewModel.setTermsAccepted(it) },
                            onOpenLegal = { title, url ->
                                if (url.isBlank()) {
                                    showPendingLegalDialog = title
                                } else {
                                    openUrlSafely(context, url)
                                }
                            },
                            onStart = { viewModel.completeOnboarding() }
                        )
                    }
                }
            }

            // Fixed Pagination Dots at bottom
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .windowInsetsPadding(WindowInsets.navigationBars)
                    .padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                OnboardingPagination(
                    currentStep = uiState.currentStep,
                    totalSteps = 4
                )
            }
        }
    }
}

// =========================================================================
// SCREEN 1: INTRODUCTION
// =========================================================================

@Composable
private fun OnboardingStepOne(
    onContinue: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 20.dp, vertical = 8.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Chapter / Volume label
        Text(
            text = stringResource(R.string.onboarding_step1_chap),
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 11.sp,
            letterSpacing = 2.sp,
            color = MeowoirsTheme.colors.textSecondary,
            modifier = Modifier
                .align(Alignment.Start)
                .padding(bottom = 12.dp)
        )

        // Hero Photograph Container (serene cat by window in morning light)
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(4f / 5f)
                .shadow(12.dp, RoundedCornerShape(36.dp))
                .clip(RoundedCornerShape(36.dp))
                .background(MeowoirsTheme.colors.cardBackground)
                .border(6.dp, MeowoirsTheme.colors.textPrimary.copy(alpha = 0.85f), RoundedCornerShape(36.dp))
        ) {
            Image(
                painter = painterResource(R.drawable.onboarding_step1_hero),
                contentDescription = null,
                modifier = Modifier.fillMaxSize(),
                contentScale = ContentScale.Crop
            )

            // Gradient overlay
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(
                        Brush.verticalGradient(
                            colors = listOf(
                                Color.Transparent,
                                Color.Transparent,
                                Color.Black.copy(alpha = 0.55f)
                            )
                        )
                    )
            )

            // Top-right floating badge: "GÜNÜN IŞIĞI"
            Row(
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(14.dp)
                    .clip(FullCornerShape)
                    .background(MeowoirsTheme.colors.cardBackground.copy(alpha = 0.88f))
                    .padding(horizontal = 10.dp, vertical = 5.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Icon(
                    imageVector = Icons.Outlined.WbSunny,
                    contentDescription = null,
                    modifier = Modifier.size(13.dp),
                    tint = MeowoirsTheme.colors.orange
                )
                Text(
                    text = stringResource(R.string.onboarding_step1_badge),
                    fontFamily = FontFamily.SansSerif,
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 10.sp,
                    letterSpacing = 1.2.sp,
                    color = MeowoirsTheme.colors.textPrimary
                )
            }

            // Bottom overlay: Quote bubble & Story icon
            Row(
                modifier = Modifier
                    .align(Alignment.BottomStart)
                    .fillMaxWidth()
                    .padding(14.dp),
                verticalAlignment = Alignment.Bottom,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Box(
                    modifier = Modifier
                        .weight(1f, fill = false)
                        .clip(RoundedCornerShape(14.dp))
                        .background(MeowoirsTheme.colors.cardBackground.copy(alpha = 0.92f))
                        .padding(horizontal = 14.dp, vertical = 8.dp)
                ) {
                    Text(
                        text = stringResource(R.string.onboarding_step1_quote),
                        fontFamily = FontFamily.Serif,
                        fontStyle = FontStyle.Italic,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Normal,
                        color = MeowoirsTheme.colors.textPrimary
                    )
                }

                Spacer(modifier = Modifier.width(8.dp))

                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .clip(CircleShape)
                        .background(MeowoirsTheme.colors.cardBackground.copy(alpha = 0.92f)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Outlined.AutoStories,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                        tint = MeowoirsTheme.colors.textPrimary
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Introductory tags
        Row(
            modifier = Modifier.align(Alignment.Start),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Text(
                text = stringResource(R.string.onboarding_step1_intro),
                fontFamily = FontFamily.SansSerif,
                fontWeight = FontWeight.SemiBold,
                fontSize = 11.sp,
                letterSpacing = 1.5.sp,
                color = MeowoirsTheme.colors.orange
            )
            Box(
                modifier = Modifier
                    .width(16.dp)
                    .height(1.dp)
                    .background(MeowoirsTheme.colors.orange.copy(alpha = 0.4f))
            )
            Text(
                text = stringResource(R.string.onboarding_step1_intro_sub),
                fontFamily = FontFamily.SansSerif,
                fontWeight = FontWeight.SemiBold,
                fontSize = 11.sp,
                letterSpacing = 1.5.sp,
                color = MeowoirsTheme.colors.orange
            )
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Headline with italic emphasized keyword: "Her kedinin bir hikâyesi var."
        val titlePart1 = stringResource(R.string.onboarding_step1_title_part1)
        val titleHighlight = stringResource(R.string.onboarding_step1_title_highlight)
        val titlePart2 = stringResource(R.string.onboarding_step1_title_part2)
        val orangeColor = MeowoirsTheme.colors.orange

        val titleText = remember(titlePart1, titleHighlight, titlePart2, orangeColor) {
            buildAnnotatedString {
                append(titlePart1)
                withStyle(
                    style = SpanStyle(
                        fontFamily = FontFamily.Serif,
                        fontStyle = FontStyle.Italic,
                        fontWeight = FontWeight.Normal,
                        color = orangeColor
                    )
                ) {
                    append(titleHighlight)
                }
                append(titlePart2)
            }
        }

        Text(
            text = titleText,
            fontFamily = FontFamily.Serif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 28.sp,
            lineHeight = 36.sp,
            color = MeowoirsTheme.colors.textPrimary,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(10.dp))

        // Description
        Text(
            text = stringResource(R.string.onboarding_step1_desc),
            fontFamily = FontFamily.SansSerif,
            fontSize = 15.sp,
            lineHeight = 23.sp,
            color = MeowoirsTheme.colors.textSecondary,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(20.dp))

        // Feature Card: Personal Archive
        OnboardingFeatureCard(
            icon = Icons.Outlined.FilterVintage,
            title = stringResource(R.string.onboarding_step1_feature_title),
            description = stringResource(R.string.onboarding_step1_feature_desc)
        )

        Spacer(modifier = Modifier.height(24.dp))

        // CTA Button
        OnboardingPrimaryButton(
            text = stringResource(R.string.onboarding_btn_continue),
            onClick = onContinue
        )

        Spacer(modifier = Modifier.height(14.dp))

        // Editorial Footer
        OnboardingEditorialFooter(
            leftText = stringResource(R.string.onboarding_step1_footer1),
            rightText = stringResource(R.string.onboarding_step1_footer2)
        )

        Spacer(modifier = Modifier.height(16.dp))
    }
}

// =========================================================================
// SCREEN 2: MEMORIES & DIARY FRAGMENTS
// =========================================================================

@Composable
private fun OnboardingStepTwo(
    onContinue: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 20.dp, vertical = 8.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Chapter Label
        Text(
            text = stringResource(R.string.onboarding_step2_chap),
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 11.sp,
            letterSpacing = 2.sp,
            color = MeowoirsTheme.colors.orange,
            modifier = Modifier
                .align(Alignment.Start)
                .padding(bottom = 6.dp)
        )

        // Title
        Text(
            text = stringResource(R.string.onboarding_step2_title),
            fontFamily = FontFamily.Serif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 28.sp,
            lineHeight = 36.sp,
            color = MeowoirsTheme.colors.textPrimary,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(6.dp))

        // Subtitle
        Text(
            text = stringResource(R.string.onboarding_step2_subtitle),
            fontFamily = FontFamily.SansSerif,
            fontSize = 14.sp,
            lineHeight = 22.sp,
            color = MeowoirsTheme.colors.textSecondary,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(20.dp))

        // Journal Card with sleeping cat photo and excerpt
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(28.dp),
            colors = CardDefaults.cardColors(containerColor = MeowoirsTheme.colors.cardBackground),
            border = androidx.compose.foundation.BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
        ) {
            Column(modifier = Modifier.padding(10.dp)) {
                // Photo: Sleeping cat on knitted blanket
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .aspectRatio(4f / 3f)
                        .clip(RoundedCornerShape(20.dp))
                        .background(MeowoirsTheme.colors.cream)
                ) {
                    Image(
                        painter = painterResource(R.drawable.onboarding_step2_hero),
                        contentDescription = null,
                        modifier = Modifier.fillMaxSize(),
                        contentScale = ContentScale.Crop
                    )

                    // Gradient overlay
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(
                                Brush.verticalGradient(
                                    colors = listOf(
                                        Color.Transparent,
                                        Color.Transparent,
                                        Color.Black.copy(alpha = 0.4f)
                                    )
                                )
                            )
                    )

                    // Top-left badge: pulsing green dot + "ANNO. 128"
                    Row(
                        modifier = Modifier
                            .align(Alignment.TopStart)
                            .padding(10.dp)
                            .clip(FullCornerShape)
                            .background(MeowoirsTheme.colors.cardBackground.copy(alpha = 0.90f))
                            .padding(horizontal = 9.dp, vertical = 4.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(5.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(6.dp)
                                .clip(CircleShape)
                                .background(MeowoirsTheme.colors.sage)
                        )
                        Text(
                            text = stringResource(R.string.onboarding_step2_badge1),
                            fontFamily = FontFamily.SansSerif,
                            fontWeight = FontWeight.SemiBold,
                            fontSize = 10.sp,
                            letterSpacing = 1.sp,
                            color = MeowoirsTheme.colors.textPrimary
                        )
                    }

                    // Bottom-left badge: clock icon + "08:45 Sabah Uykusu"
                    Row(
                        modifier = Modifier
                            .align(Alignment.BottomStart)
                            .padding(10.dp)
                            .clip(FullCornerShape)
                            .background(MeowoirsTheme.colors.cardBackground.copy(alpha = 0.90f))
                            .padding(horizontal = 9.dp, vertical = 4.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Outlined.Schedule,
                            contentDescription = null,
                            modifier = Modifier.size(13.dp),
                            tint = MeowoirsTheme.colors.textSecondary
                        )
                        Text(
                            text = stringResource(R.string.onboarding_step2_badge2),
                            fontFamily = FontFamily.SansSerif,
                            fontWeight = FontWeight.Medium,
                            fontSize = 11.sp,
                            color = MeowoirsTheme.colors.textPrimary
                        )
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Below photo: Date, Mood Tag, and Journal Excerpt
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(20.dp))
                        .background(MeowoirsTheme.colors.sage.copy(alpha = 0.12f))
                        .border(1.dp, MeowoirsTheme.colors.sage.copy(alpha = 0.25f), RoundedCornerShape(20.dp))
                        .padding(14.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = stringResource(R.string.onboarding_step2_date),
                            fontFamily = FontFamily.Serif,
                            fontStyle = FontStyle.Italic,
                            fontWeight = FontWeight.SemiBold,
                            fontSize = 18.sp,
                            color = MeowoirsTheme.colors.orange
                        )

                        // Mood badge: "Huzurlu"
                        Row(
                            modifier = Modifier
                                .clip(FullCornerShape)
                                .background(MeowoirsTheme.colors.sage)
                                .padding(horizontal = 8.dp, vertical = 3.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(4.dp)
                        ) {
                            Icon(
                                imageVector = Icons.Outlined.Spa,
                                contentDescription = null,
                                modifier = Modifier.size(12.dp),
                                tint = Color.White
                            )
                            Text(
                                text = stringResource(R.string.onboarding_step2_mood),
                                fontFamily = FontFamily.SansSerif,
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 11.sp,
                                color = Color.White
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(10.dp))

                    // Quote with vertical line
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .width(3.dp)
                                .height(38.dp)
                                .clip(RoundedCornerShape(1.5.dp))
                                .background(MeowoirsTheme.colors.orange)
                        )
                        Spacer(modifier = Modifier.width(10.dp))
                        Text(
                            text = stringResource(R.string.onboarding_step2_quote),
                            fontFamily = FontFamily.Serif,
                            fontStyle = FontStyle.Italic,
                            fontSize = 14.sp,
                            lineHeight = 20.sp,
                            color = MeowoirsTheme.colors.textPrimary
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Editorial Card: "Meowoirs, sıradan anları unutmak istemeyeceğin küçük hikâyelere dönüştürür."
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(22.dp),
            colors = CardDefaults.cardColors(containerColor = MeowoirsTheme.colors.cardBackground),
            border = androidx.compose.foundation.BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(14.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Icon(
                    imageVector = Icons.Outlined.AutoStories,
                    contentDescription = null,
                    modifier = Modifier.size(22.dp),
                    tint = MeowoirsTheme.colors.orange
                )
                Text(
                    text = stringResource(R.string.onboarding_step2_editorial_text),
                    fontFamily = FontFamily.Serif,
                    fontStyle = FontStyle.Italic,
                    fontSize = 13.sp,
                    lineHeight = 19.sp,
                    color = MeowoirsTheme.colors.textSecondary
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        // CTA Button
        OnboardingPrimaryButton(
            text = stringResource(R.string.onboarding_btn_continue),
            onClick = onContinue
        )

        Spacer(modifier = Modifier.height(14.dp))

        // Editorial Footer
        OnboardingEditorialFooter(
            leftText = stringResource(R.string.onboarding_step2_footer1),
            rightText = stringResource(R.string.onboarding_step2_footer2)
        )

        Spacer(modifier = Modifier.height(16.dp))
    }
}

// =========================================================================
// SCREEN 3: CATS & STORIES (HOME & STREET CATS)
// =========================================================================

@Composable
private fun OnboardingStepThree(
    onContinue: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 20.dp, vertical = 8.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Chapter Label
        Text(
            text = stringResource(R.string.onboarding_step3_chap),
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 11.sp,
            letterSpacing = 2.sp,
            color = MeowoirsTheme.colors.orange,
            modifier = Modifier
                .align(Alignment.Start)
                .padding(bottom = 6.dp)
        )

        // Title: Must naturally wrap on small screens, never clipped horizontally
        Text(
            text = stringResource(R.string.onboarding_step3_title),
            fontFamily = FontFamily.Serif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 28.sp,
            lineHeight = 36.sp,
            color = MeowoirsTheme.colors.textPrimary,
            softWrap = true,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(6.dp))

        // Supporting text
        Text(
            text = stringResource(R.string.onboarding_step3_desc),
            fontFamily = FontFamily.SansSerif,
            fontSize = 14.sp,
            lineHeight = 21.sp,
            color = MeowoirsTheme.colors.textSecondary,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(18.dp))

        // Overlapping Dual Photographic Cards
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 12.dp)
        ) {
            Column(modifier = Modifier.fillMaxWidth()) {
                // Card 1: Home Cat (aligned to end / right)
                Box(
                    modifier = Modifier
                        .fillMaxWidth(0.90f)
                        .align(Alignment.End)
                        .shadow(8.dp, RoundedCornerShape(26.dp))
                        .clip(RoundedCornerShape(26.dp))
                        .background(MeowoirsTheme.colors.cardBackground)
                        .border(1.dp, MeowoirsTheme.colors.cardBorder, RoundedCornerShape(26.dp))
                        .padding(6.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(4f / 5f)
                            .clip(RoundedCornerShape(22.dp))
                    ) {
                        Image(
                            painter = painterResource(R.drawable.onboarding_step3_home),
                            contentDescription = null,
                            modifier = Modifier.fillMaxSize(),
                            contentScale = ContentScale.Crop
                        )

                        // Gradient
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .background(
                                    Brush.verticalGradient(
                                        colors = listOf(
                                            Color.Transparent,
                                            Color.Transparent,
                                            Color.Black.copy(alpha = 0.65f)
                                        )
                                    )
                                )
                        )

                        // Badge: "EVDE"
                        Box(
                            modifier = Modifier
                                .align(Alignment.TopEnd)
                                .padding(10.dp)
                                .clip(FullCornerShape)
                                .background(MeowoirsTheme.colors.sage)
                                .padding(horizontal = 9.dp, vertical = 4.dp)
                        ) {
                            Text(
                                text = stringResource(R.string.onboarding_step3_home_badge),
                                fontFamily = FontFamily.SansSerif,
                                fontWeight = FontWeight.Bold,
                                fontSize = 10.sp,
                                letterSpacing = 1.sp,
                                color = Color.White
                            )
                        }

                        // Bottom Title
                        Text(
                            text = stringResource(R.string.onboarding_step3_home_title),
                            fontFamily = FontFamily.Serif,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Medium,
                            color = Color.White,
                            modifier = Modifier
                                .align(Alignment.BottomStart)
                                .padding(14.dp)
                        )
                    }
                }

                // Card 2: Street Cat (aligned to start / left, overlapping upwards)
                Box(
                    modifier = Modifier
                        .offset(y = (-40).dp)
                        .fillMaxWidth(0.76f)
                        .align(Alignment.Start)
                        .shadow(14.dp, RoundedCornerShape(26.dp))
                        .clip(RoundedCornerShape(26.dp))
                        .background(MeowoirsTheme.colors.cardBackground)
                        .border(1.dp, MeowoirsTheme.colors.cardBorder, RoundedCornerShape(26.dp))
                        .padding(6.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(1f)
                            .clip(RoundedCornerShape(22.dp))
                    ) {
                        Image(
                            painter = painterResource(R.drawable.onboarding_step3_street),
                            contentDescription = null,
                            modifier = Modifier.fillMaxSize(),
                            contentScale = ContentScale.Crop
                        )

                        // Gradient
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .background(
                                    Brush.verticalGradient(
                                        colors = listOf(
                                            Color.Transparent,
                                            Color.Transparent,
                                            Color.Black.copy(alpha = 0.70f)
                                        )
                                    )
                                )
                        )

                        // Badge: "SOKAK HİKÂYESİ"
                        Box(
                            modifier = Modifier
                                .align(Alignment.TopStart)
                                .padding(10.dp)
                                .clip(FullCornerShape)
                                .background(MeowoirsTheme.colors.orange)
                                .padding(horizontal = 9.dp, vertical = 4.dp)
                        ) {
                            Text(
                                text = stringResource(R.string.onboarding_step3_street_badge),
                                fontFamily = FontFamily.SansSerif,
                                fontWeight = FontWeight.Bold,
                                fontSize = 10.sp,
                                letterSpacing = 1.sp,
                                color = Color.White
                            )
                        }

                        // Bottom Street Title & Subtitle
                        Column(
                            modifier = Modifier
                                .align(Alignment.BottomStart)
                                .padding(12.dp)
                        ) {
                            Text(
                                text = stringResource(R.string.onboarding_step3_street_title),
                                fontFamily = FontFamily.Serif,
                                fontSize = 17.sp,
                                fontWeight = FontWeight.Medium,
                                color = Color.White
                            )
                            Text(
                                text = stringResource(R.string.onboarding_step3_street_subtitle),
                                fontFamily = FontFamily.SansSerif,
                                fontSize = 11.sp,
                                color = Color.White.copy(alpha = 0.85f)
                            )
                        }
                    }
                }
            }
        }

        // Feature Card: "Evde veya Sokakta"
        OnboardingFeatureCard(
            icon = Icons.Outlined.Pets,
            title = stringResource(R.string.onboarding_step3_feature_title),
            description = stringResource(R.string.onboarding_step3_feature_desc),
            modifier = Modifier.offset(y = (-24).dp)
        )

        Spacer(modifier = Modifier.height(4.dp))

        // CTA Button
        OnboardingPrimaryButton(
            text = stringResource(R.string.onboarding_btn_continue),
            onClick = onContinue
        )

        Spacer(modifier = Modifier.height(14.dp))

        // Editorial Footer
        OnboardingEditorialFooter(
            leftText = stringResource(R.string.onboarding_step3_footer1),
            rightText = stringResource(R.string.onboarding_step3_footer2)
        )

        Spacer(modifier = Modifier.height(16.dp))
    }
}

// =========================================================================
// SCREEN 4: PRIVACY & LEGAL ACCEPTANCE (STRICT GATE)
// =========================================================================

@Composable
private fun OnboardingStepFour(
    uiState: OnboardingUiState,
    onPrivacyToggle: (Boolean) -> Unit,
    onTermsToggle: (Boolean) -> Unit,
    onOpenLegal: (title: String, url: String) -> Unit,
    onStart: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 20.dp, vertical = 8.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Chapter Label
        Row(
            modifier = Modifier
                .align(Alignment.Start)
                .padding(bottom = 12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(6.dp)
                    .clip(CircleShape)
                    .background(MeowoirsTheme.colors.orange)
            )
            Text(
                text = stringResource(R.string.onboarding_step4_chap),
                fontFamily = FontFamily.SansSerif,
                fontWeight = FontWeight.Bold,
                fontSize = 11.sp,
                letterSpacing = 2.sp,
                color = MeowoirsTheme.colors.orange
            )
        }

        // Lock & Brand Illustration
        PrivacyLockIllustration(
            modifier = Modifier.padding(vertical = 12.dp)
        )

        Spacer(modifier = Modifier.height(8.dp))

        // Title: "Hikâyen senin."
        Text(
            text = stringResource(R.string.onboarding_step4_title),
            fontFamily = FontFamily.Serif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 28.sp,
            color = MeowoirsTheme.colors.textPrimary,
            textAlign = TextAlign.Center
        )

        Spacer(modifier = Modifier.height(8.dp))

        // Description: Stays safely on device, no account or cloud required
        Text(
            text = stringResource(R.string.onboarding_step4_desc),
            fontFamily = FontFamily.SansSerif,
            fontSize = 14.sp,
            lineHeight = 22.sp,
            color = MeowoirsTheme.colors.textSecondary,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(horizontal = 8.dp)
        )

        Spacer(modifier = Modifier.height(20.dp))

        // Feature Card: "Cihazında Kalır"
        OnboardingFeatureCard(
            icon = Icons.Outlined.Smartphone,
            title = stringResource(R.string.onboarding_step4_feature_title),
            description = stringResource(R.string.onboarding_step4_feature_desc),
            iconTint = MeowoirsTheme.colors.sage
        )

        Spacer(modifier = Modifier.height(24.dp))

        // Checkbox 1: Privacy Policy
        LegalCheckboxRow(
            checked = uiState.privacyAccepted,
            onCheckedChange = onPrivacyToggle,
            fullText = stringResource(R.string.onboarding_step4_privacy_checkbox),
            linkKeyword = stringResource(R.string.onboarding_step4_privacy_link_text),
            onLinkClicked = {
                onOpenLegal(
                    "Gizlilik Politikası",
                    AppConfig.PRIVACY_POLICY_URL
                )
            }
        )

        Spacer(modifier = Modifier.height(14.dp))

        // Checkbox 2: Terms of Service
        LegalCheckboxRow(
            checked = uiState.termsAccepted,
            onCheckedChange = onTermsToggle,
            fullText = stringResource(R.string.onboarding_step4_terms_checkbox),
            linkKeyword = stringResource(R.string.onboarding_step4_terms_link_text),
            onLinkClicked = {
                onOpenLegal(
                    "Kullanım Koşulları",
                    AppConfig.TERMS_OF_SERVICE_URL
                )
            }
        )

        Spacer(modifier = Modifier.height(26.dp))

        // CTA Button: "Meowoirs'e Başla →" (Disabled until both checked)
        OnboardingPrimaryButton(
            text = stringResource(R.string.onboarding_step4_btn_start),
            onClick = onStart,
            enabled = uiState.canStart
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Footer with Shield icon: "MEOWOIRS • KİŞİSEL ARŞİV"
        Row(
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(
                imageVector = Icons.Outlined.Shield,
                contentDescription = null,
                modifier = Modifier.size(13.dp),
                tint = MeowoirsTheme.colors.textTertiary
            )
            Spacer(modifier = Modifier.width(5.dp))
            Text(
                text = stringResource(R.string.onboarding_step4_footer),
                fontFamily = FontFamily.SansSerif,
                fontWeight = FontWeight.Medium,
                fontSize = 11.sp,
                letterSpacing = 2.sp,
                color = MeowoirsTheme.colors.textTertiary
            )
        }

        Spacer(modifier = Modifier.height(16.dp))
    }
}

/**
 * Custom styled Legal Checkbox Row with clickable legal document link.
 */
@Composable
private fun LegalCheckboxRow(
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
    fullText: String,
    linkKeyword: String,
    onLinkClicked: () -> Unit,
    modifier: Modifier = Modifier
) {
    val startIndex = fullText.indexOf(linkKeyword)
    val endIndex = if (startIndex != -1) startIndex + linkKeyword.length else -1

    val primaryTextColor = MeowoirsTheme.colors.textPrimary
    val annotatedText = remember(fullText, linkKeyword, primaryTextColor) {
        buildAnnotatedString {
            if (startIndex != -1) {
                append(fullText.substring(0, startIndex))
                pushStringAnnotation(tag = "LEGAL_LINK", annotation = "open")
                withStyle(
                    SpanStyle(
                        color = primaryTextColor,
                        fontWeight = FontWeight.SemiBold,
                        textDecoration = TextDecoration.Underline
                    )
                ) {
                    append(linkKeyword)
                }
                pop()
                append(fullText.substring(endIndex))
            } else {
                append(fullText)
            }
        }
    }

    Row(
        modifier = modifier
            .fillMaxWidth()
            .clickable(
                interactionSource = remember { MutableInteractionSource() },
                indication = null
            ) { onCheckedChange(!checked) }
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.Top,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        // Custom Circular Checkbox
        Box(
            modifier = Modifier
                .padding(top = 2.dp)
                .size(22.dp)
                .clip(CircleShape)
                .background(
                    if (checked) primaryTextColor else MeowoirsTheme.colors.cardBackground
                )
                .border(
                    width = 1.5.dp,
                    color = if (checked) primaryTextColor else MeowoirsTheme.colors.cardBorder,
                    shape = CircleShape
                ),
            contentAlignment = Alignment.Center
        ) {
            if (checked) {
                Icon(
                    imageVector = Icons.Outlined.Check,
                    contentDescription = null,
                    modifier = Modifier.size(14.dp),
                    tint = Color.White
                )
            }
        }

        // Text with clickable link
        @Suppress("DEPRECATION")
        androidx.compose.foundation.text.ClickableText(
            text = annotatedText,
            style = androidx.compose.ui.text.TextStyle(
                fontFamily = FontFamily.SansSerif,
                fontSize = 13.sp,
                lineHeight = 19.sp,
                color = primaryTextColor
            ),
            onClick = { offset ->
                val annotations = annotatedText.getStringAnnotations(
                    tag = "LEGAL_LINK",
                    start = offset,
                    end = offset
                )
                if (annotations.isNotEmpty()) {
                    onLinkClicked()
                } else {
                    onCheckedChange(!checked)
                }
            },
            modifier = Modifier.weight(1f)
        )
    }
}
