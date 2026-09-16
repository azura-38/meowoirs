package com.limanex.meowoirs.ui.screens.memories

import androidx.compose.foundation.background
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
import androidx.compose.material.icons.outlined.Pets
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
import com.limanex.meowoirs.ui.components.MemoryCard
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsChip
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSecondaryButton
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.MemoriesUiState
import com.limanex.meowoirs.viewmodel.MemoriesViewModel

@Composable
fun MemoriesScreen(
    onNavigateToCatDetail: (String) -> Unit,
    onNavigateToMemoryDetail: (String) -> Unit,
    onNavigateToAddMemory: (String?) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: MemoriesViewModel = viewModel(factory = MemoriesViewModel.Factory)
) {
    val uiState by viewModel.uiState.collectAsState()

    MemoriesContent(
        uiState = uiState,
        onSelectFilter = { viewModel.selectFilter(it) },
        onNavigateToCatDetail = onNavigateToCatDetail,
        onNavigateToMemoryDetail = onNavigateToMemoryDetail,
        onNavigateToAddMemory = onNavigateToAddMemory,
        modifier = modifier
    )
}

@Composable
fun MemoriesContent(
    uiState: MemoriesUiState,
    onSelectFilter: (String?) -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    onNavigateToMemoryDetail: (String) -> Unit,
    onNavigateToAddMemory: (String?) -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(MeowoirsTheme.colors.cream)
    ) {
        if (uiState.isLoading) {
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
        } else {
            com.limanex.meowoirs.ui.components.SubtleContentEntrance {
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    contentPadding = PaddingValues(
                        start = MeowoirsTheme.spacing.medium,
                        end = MeowoirsTheme.spacing.medium,
                        top = MeowoirsTheme.spacing.small,
                        bottom = 100.dp
                    ),
                    verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium)
                ) {
                    // 1. Editorial Header
                    item {
                        Column(modifier = Modifier.fillMaxWidth()) {
                            Text(
                                text = "Anılar",
                                style = MeowoirsTheme.typography.displaySmall,
                                fontWeight = FontWeight.Bold,
                                color = MeowoirsTheme.colors.textPrimary
                            )
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))
                            Text(
                                text = "Hayatındaki küçük anların arşivi.",
                                style = MeowoirsTheme.typography.bodyLarge,
                                color = MeowoirsTheme.colors.textSecondary
                            )
                        }
                    }

                    // 2. Dynamic Cat Filter Chips
                    if (uiState.availableCats.isNotEmpty()) {
                        item {
                            LazyRow(
                                horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small),
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                // "Tümü" option
                                item {
                                    MeowoirsChip(
                                        label = "Tümü",
                                        isSelected = uiState.selectedCatFilterId == null,
                                        onClick = { onSelectFilter(null) }
                                    )
                                }

                                // Dynamic options for each cat
                                items(uiState.availableCats, key = { it.id }) { cat ->
                                    val isSelected = uiState.selectedCatFilterId == cat.id
                                    MeowoirsChip(
                                        label = cat.name,
                                        isSelected = isSelected,
                                        onClick = { onSelectFilter(cat.id) }
                                    )
                                }
                            }
                        }
                    }

                    // 3. Content or Empty States
                    when {
                        uiState.isCompletelyEmpty -> {
                            item {
                                GlobalEmptyMemoriesCard(
                                    onAddMemoryClick = { onNavigateToAddMemory(null) }
                                )
                            }
                        }

                        uiState.isFilterEmpty -> {
                            item {
                                FilterEmptyMemoriesCard(
                                    cat = uiState.selectedCat,
                                    onAddMemoryClick = { onNavigateToAddMemory(uiState.selectedCatFilterId) }
                                )
                            }
                        }

                        else -> {
                            items(uiState.filteredMemories, key = { it.id }) { memory ->
                                MemoryCard(
                                    memory = memory,
                                    showCatName = true,
                                    onClick = { onNavigateToMemoryDetail(memory.id) }
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
 * Global empty state when there are no memories at all in the archive.
 */
@Composable
private fun GlobalEmptyMemoriesCard(
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
                    modifier = Modifier.size(28.dp)
                )
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))

            Text(
                text = "Henüz bir anın yok.",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Kedilerinle geçirdiğin küçük anlar burada birikecek.",
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
        }
    }
}

/**
 * Filter empty state when memories exist globally, but the selected cat has no memories yet.
 */
@Composable
private fun FilterEmptyMemoriesCard(
    cat: Cat?,
    onAddMemoryClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val catName = cat?.name ?: "Bu kedi"

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
                    .size(52.dp)
                    .background(
                        color = MeowoirsTheme.colors.accentOrangeContainer,
                        shape = MeowoirsTheme.shapes.medium
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.Pets,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.orange,
                    modifier = Modifier.size(26.dp)
                )
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))

            Text(
                text = "$catName için henüz bir anın yok.",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Onunla geçirdiğin küçük bir anı sakla.",
                style = MeowoirsTheme.typography.bodyMedium,
                color = MeowoirsTheme.colors.textSecondary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

            MeowoirsSecondaryButton(
                text = "Anı Ekle",
                onClick = onAddMemoryClick,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

// ----------------------------------------------------
// Compose Previews
// ----------------------------------------------------

@Preview(name = "Memories - Content", showBackground = true)
@Composable
private fun MemoriesScreenPreview() {
    MeowoirsTheme {
        MemoriesContent(
            uiState = MemoriesUiState(
                isLoading = false,
                allMemories = PreviewSampleData.sampleMemories,
                availableCats = PreviewSampleData.sampleCats,
                selectedCatFilterId = null
            ),
            onSelectFilter = {},
            onNavigateToCatDetail = {},
            onNavigateToMemoryDetail = {},
            onNavigateToAddMemory = {}
        )
    }
}

@Preview(name = "Memories - Filter Empty", showBackground = true)
@Composable
private fun MemoriesFilterEmptyPreview() {
    MeowoirsTheme {
        MemoriesContent(
            uiState = MemoriesUiState(
                isLoading = false,
                allMemories = PreviewSampleData.sampleMemories,
                availableCats = PreviewSampleData.sampleCats,
                selectedCatFilterId = "non_existent_id"
            ),
            onSelectFilter = {},
            onNavigateToCatDetail = {},
            onNavigateToMemoryDetail = {},
            onNavigateToAddMemory = {}
        )
    }
}

@Preview(name = "Memories - Global Empty", showBackground = true)
@Composable
private fun MemoriesGlobalEmptyPreview() {
    MeowoirsTheme {
        MemoriesContent(
            uiState = MemoriesUiState(
                isLoading = false,
                allMemories = emptyList(),
                availableCats = PreviewSampleData.sampleCats,
                selectedCatFilterId = null
            ),
            onSelectFilter = {},
            onNavigateToCatDetail = {},
            onNavigateToMemoryDetail = {},
            onNavigateToAddMemory = {}
        )
    }
}
