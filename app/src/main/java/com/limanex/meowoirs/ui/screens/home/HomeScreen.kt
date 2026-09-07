package com.limanex.meowoirs.ui.screens.home

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AutoStories
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.limanex.meowoirs.data.repository.PreviewSampleData
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.ui.components.CatPreviewCard
import com.limanex.meowoirs.ui.components.MemoryCard
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSectionHeader
import com.limanex.meowoirs.ui.components.SubtleContentEntrance
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.HomeUiState
import com.limanex.meowoirs.viewmodel.HomeViewModel

@Composable
fun HomeScreen(
    onNavigateToCatDetail: (String) -> Unit,
    onNavigateToMemories: () -> Unit,
    onNavigateToAddMemory: () -> Unit,
    onNavigateToAddCat: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: HomeViewModel = viewModel(factory = HomeViewModel.Factory)
) {
    val uiState by viewModel.uiState.collectAsState()

    HomeContent(
        uiState = uiState,
        onNavigateToCatDetail = onNavigateToCatDetail,
        onNavigateToMemories = onNavigateToMemories,
        onNavigateToAddMemory = onNavigateToAddMemory,
        onNavigateToAddCat = onNavigateToAddCat,
        modifier = modifier
    )
}

@Composable
fun HomeContent(
    uiState: HomeUiState,
    onNavigateToCatDetail: (String) -> Unit,
    onNavigateToMemories: () -> Unit,
    onNavigateToAddMemory: () -> Unit,
    onNavigateToAddCat: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(MeowoirsTheme.colors.cream)
    ) {
        when {
            uiState.isLoading -> {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator(
                        color = MeowoirsTheme.colors.orange,
                        modifier = Modifier.size(36.dp),
                        strokeWidth = 3.dp
                    )
                }
            }

            uiState.isCompletelyEmpty -> {
                SubtleContentEntrance {
                    LazyColumn(
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(
                            start = MeowoirsTheme.spacing.medium,
                            end = MeowoirsTheme.spacing.medium,
                            top = MeowoirsTheme.spacing.small,
                            bottom = 100.dp
                        )
                    ) {
                        item {
                            HomeGreetingHeader()
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))
                        }
                        item {
                            EmptyHomeStateCard(
                                onAddMemoryClick = onNavigateToAddMemory,
                                onAddCatClick = onNavigateToAddCat
                            )
                        }
                    }
                }
            }

            else -> {
                SubtleContentEntrance {
                    LazyColumn(
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(
                            start = MeowoirsTheme.spacing.medium,
                            end = MeowoirsTheme.spacing.medium,
                            top = MeowoirsTheme.spacing.small,
                            bottom = 100.dp // Generous bottom padding so FAB/Nav don't obscure cards
                        ),
                        verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium)
                    ) {
                    // Header greeting
                    item {
                        HomeGreetingHeader()
                    }

                    // "Kedilerin" Section
                    if (uiState.cats.isNotEmpty()) {
                        item {
                            MeowoirsSectionHeader(
                                title = "Kedilerin",
                                subtitle = "${uiState.cats.size} kedi hikâyesi"
                            )
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
                            LazyRow(
                                horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small),
                                contentPadding = PaddingValues(vertical = MeowoirsTheme.spacing.extraSmall)
                            ) {
                                items(uiState.cats, key = { it.id }) { cat ->
                                    CatPreviewCard(
                                        cat = cat,
                                        onClick = { onNavigateToCatDetail(cat.id) }
                                    )
                                }
                            }
                        }
                    }

                    // "Son Anılar" Section or State B (Cats exist without memories)
                    if (uiState.recentMemories.isNotEmpty()) {
                        item {
                            MeowoirsSectionHeader(
                                title = "Son Anılar",
                                actionText = "Tümünü Gör",
                                onActionClick = onNavigateToMemories
                            )
                        }

                        items(uiState.recentMemories, key = { it.id }) { memory ->
                            MemoryCard(
                                memory = memory,
                                onClick = onNavigateToMemories
                            )
                        }
                    } else if (uiState.hasCatsWithoutMemories) {
                        item {
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                            CatsExistNoMemoriesCard(
                                onAddMemoryClick = onNavigateToAddMemory
                            )
                        }
                    }
                }
            }
        }
    }
}
}

/**
 * Editorial warm greeting header.
 */
@Composable
private fun HomeGreetingHeader(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = MeowoirsTheme.spacing.small)
    ) {
        Text(
            text = "Meowoirs",
            style = MeowoirsTheme.typography.displaySmall,
            fontWeight = FontWeight.Bold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))
        Text(
            text = "Her kedinin bir hikâyesi var.",
            style = MeowoirsTheme.typography.bodyLarge,
            color = MeowoirsTheme.colors.textSecondary
        )
    }
}

/**
 * State A: Emotional warm empty state when there are no cats and no memories yet.
 */
@Composable
private fun EmptyHomeStateCard(
    onAddMemoryClick: () -> Unit,
    onAddCatClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    MeowoirsCard(
        modifier = modifier.fillMaxWidth(),
        shape = MeowoirsTheme.shapes.large,
        contentPadding = MeowoirsTheme.spacing.large
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Box(
                modifier = Modifier
                    .size(56.dp)
                    .background(
                        color = MeowoirsTheme.colors.accentOrangeContainer,
                        shape = MeowoirsTheme.shapes.medium
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.AutoStories,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.orange,
                    modifier = Modifier.size(32.dp)
                )
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))

            Text(
                text = "Henüz bir anın yok...",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.",
                style = MeowoirsTheme.typography.bodyMedium,
                color = MeowoirsTheme.colors.textSecondary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

            MeowoirsPrimaryButton(
                text = "İlk Anını Ekle",
                onClick = onAddMemoryClick,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.mediumSmall))

            Text(
                text = "İlk Kedini Ekle",
                style = MeowoirsTheme.typography.labelLarge,
                color = MeowoirsTheme.colors.orange,
                fontWeight = FontWeight.Medium,
                modifier = Modifier
                    .clickable(onClick = onAddCatClick)
                    .padding(MeowoirsTheme.spacing.small)
            )
        }
    }
}

/**
 * State B: Emotional prompt when cats exist but no memories are recorded yet.
 */
@Composable
private fun CatsExistNoMemoriesCard(
    onAddMemoryClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    MeowoirsCard(
        modifier = modifier.fillMaxWidth(),
        shape = MeowoirsTheme.shapes.large,
        contentPadding = MeowoirsTheme.spacing.large
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(
                imageVector = Icons.Outlined.FavoriteBorder,
                contentDescription = null,
                tint = MeowoirsTheme.colors.orange,
                modifier = Modifier.size(32.dp)
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Kedilerin burada.",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))

            Text(
                text = "Onlarla geçirdiğin ilk anıyı sakla.",
                style = MeowoirsTheme.typography.bodyMedium,
                color = MeowoirsTheme.colors.textSecondary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))

            MeowoirsPrimaryButton(
                text = "İlk Anını Ekle",
                onClick = onAddMemoryClick,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

// ----------------------------------------------------
// Compose Previews
// ----------------------------------------------------

@Preview(name = "Content State - Light", showBackground = true)
@Composable
private fun HomeScreenContentPreview() {
    MeowoirsTheme(darkTheme = false) {
        HomeContent(
            uiState = HomeUiState(
                isLoading = false,
                cats = PreviewSampleData.sampleCats,
                recentMemories = PreviewSampleData.sampleMemories
            ),
            onNavigateToCatDetail = {},
            onNavigateToMemories = {},
            onNavigateToAddMemory = {},
            onNavigateToAddCat = {}
        )
    }
}

@Preview(name = "Content State - Dark", showBackground = true)
@Composable
private fun HomeScreenDarkPreview() {
    MeowoirsTheme(darkTheme = true) {
        HomeContent(
            uiState = HomeUiState(
                isLoading = false,
                cats = PreviewSampleData.sampleCats,
                recentMemories = PreviewSampleData.sampleMemories
            ),
            onNavigateToCatDetail = {},
            onNavigateToMemories = {},
            onNavigateToAddMemory = {},
            onNavigateToAddCat = {}
        )
    }
}

@Preview(name = "Empty State A - No Cats No Memories", showBackground = true)
@Composable
private fun HomeScreenEmptyPreview() {
    MeowoirsTheme {
        HomeContent(
            uiState = HomeUiState(
                isLoading = false,
                cats = emptyList(),
                recentMemories = emptyList()
            ),
            onNavigateToCatDetail = {},
            onNavigateToMemories = {},
            onNavigateToAddMemory = {},
            onNavigateToAddCat = {}
        )
    }
}

@Preview(name = "Empty State B - Cats Exist No Memories", showBackground = true)
@Composable
private fun HomeScreenCatsNoMemoriesPreview() {
    MeowoirsTheme {
        HomeContent(
            uiState = HomeUiState(
                isLoading = false,
                cats = PreviewSampleData.sampleCats,
                recentMemories = emptyList()
            ),
            onNavigateToCatDetail = {},
            onNavigateToMemories = {},
            onNavigateToAddMemory = {},
            onNavigateToAddCat = {}
        )
    }
}
