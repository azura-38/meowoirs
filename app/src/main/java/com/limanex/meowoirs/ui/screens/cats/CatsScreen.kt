package com.limanex.meowoirs.ui.screens.cats

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
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
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
import com.limanex.meowoirs.ui.components.CatCard
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsChip
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSecondaryButton
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.CatFilter
import com.limanex.meowoirs.viewmodel.CatsUiState
import com.limanex.meowoirs.viewmodel.CatsViewModel

@Composable
fun CatsScreen(
    onNavigateToAddCat: () -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: CatsViewModel = viewModel(factory = CatsViewModel.Factory)
) {
    val uiState by viewModel.uiState.collectAsState()

    CatsContent(
        uiState = uiState,
        onFilterSelected = { viewModel.setFilter(it) },
        onNavigateToAddCat = onNavigateToAddCat,
        onNavigateToCatDetail = onNavigateToCatDetail,
        modifier = modifier
    )
}

@Composable
fun CatsContent(
    uiState: CatsUiState,
    onFilterSelected: (CatFilter) -> Unit,
    onNavigateToAddCat: () -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
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
                com.limanex.meowoirs.ui.components.SubtleContentEntrance {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(MeowoirsTheme.spacing.medium),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        EmptyCatsCard(onAddCatClick = onNavigateToAddCat)
                    }
                }
            }

            else -> {
                com.limanex.meowoirs.ui.components.SubtleContentEntrance {
                    LazyVerticalGrid(
                        columns = GridCells.Fixed(2),
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(
                            start = MeowoirsTheme.spacing.medium,
                            end = MeowoirsTheme.spacing.medium,
                            top = MeowoirsTheme.spacing.small,
                            bottom = 100.dp // Avoid FAB / bottom nav overlap
                        ),
                        horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium),
                        verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium)
                    ) {
                    // Header row spanning both columns
                    item(span = { GridItemSpan(2) }) {
                        CatsHeaderSection(
                            summaryText = uiState.summaryText,
                            onAddCatClick = onNavigateToAddCat
                        )
                    }

                    // Filter chips row
                    item(span = { GridItemSpan(2) }) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
                        ) {
                            CatFilter.entries.forEach { filter ->
                                val isSelected = uiState.selectedFilter == filter
                                MeowoirsChip(
                                    label = filter.label,
                                    isSelected = isSelected,
                                    onClick = { onFilterSelected(filter) }
                                )
                            }
                        }
                    }

                    // Filter empty state vs Grid items
                    if (uiState.isFilterEmpty) {
                        item(span = { GridItemSpan(2) }) {
                            FilterEmptyCard(
                                filter = uiState.selectedFilter,
                                onAddCatClick = onNavigateToAddCat
                            )
                        }
                    } else {
                        items(uiState.filteredCats, key = { it.id }) { cat ->
                            CatCard(
                                cat = cat,
                                memoryCount = uiState.memoryCounts[cat.id],
                                onClick = { onNavigateToCatDetail(cat.id) }
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
 * Editorial header for the Cats screen with "Yeni Kedi" secondary action.
 */
@Composable
private fun CatsHeaderSection(
    summaryText: String,
    onAddCatClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = MeowoirsTheme.spacing.extraSmall),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = "Kedilerim",
                style = MeowoirsTheme.typography.displaySmall,
                fontWeight = FontWeight.Bold,
                color = MeowoirsTheme.colors.textPrimary
            )
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))
            Text(
                text = if (summaryText.isNotBlank()) "Hayatına dokunan $summaryText" else "Hayatına dokunan küçük hikâyeler.",
                style = MeowoirsTheme.typography.bodyMedium,
                color = MeowoirsTheme.colors.textSecondary
            )
        }

        // Secondary "Yeni Kedi" action (does not compete with global FAB)
        MeowoirsSecondaryButton(
            text = "Yeni Kedi",
            onClick = onAddCatClick,
            leadingIcon = {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.textPrimary,
                    modifier = Modifier.size(16.dp)
                )
            }
        )
    }
}

/**
 * Empty state when no cats exist at all.
 */
@Composable
private fun EmptyCatsCard(
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
                    .size(64.dp)
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
                    modifier = Modifier.size(32.dp)
                )
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))

            Text(
                text = "Henüz bir kedin yok.",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Hayatındaki bir kediyi ekleyerek hikâyene başla.",
                style = MeowoirsTheme.typography.bodyMedium,
                color = MeowoirsTheme.colors.textSecondary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

            MeowoirsPrimaryButton(
                text = "İlk Kedini Ekle",
                onClick = onAddCatClick,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

/**
 * Empty state when a specific category/filter returns 0 results.
 */
@Composable
private fun FilterEmptyCard(
    filter: CatFilter,
    onAddCatClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val (message, ctaText) = when (filter) {
        CatFilter.HOME -> Pair("Henüz bir ev kedisi eklemedin.", "Ev Kedisi Ekle")
        CatFilter.STREET -> Pair("Henüz bir sokak kedisi eklemedin.", "Sokak Kedisi Ekle")
        CatFilter.ALL -> Pair("Henüz kedi bulunmuyor.", "Kedi Ekle")
    }

    MeowoirsCard(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = MeowoirsTheme.spacing.large),
        shape = MeowoirsTheme.shapes.large,
        contentPadding = MeowoirsTheme.spacing.large
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = message,
                style = MeowoirsTheme.typography.titleMedium,
                color = MeowoirsTheme.colors.textSecondary,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))
            MeowoirsPrimaryButton(
                text = ctaText,
                onClick = onAddCatClick
            )
        }
    }
}

// ----------------------------------------------------
// Compose Previews
// ----------------------------------------------------

@Preview(name = "Cats Screen - Content", showBackground = true)
@Composable
private fun CatsScreenPreview() {
    MeowoirsTheme {
        CatsContent(
            uiState = CatsUiState(
                isLoading = false,
                allCats = PreviewSampleData.sampleCats,
                filteredCats = PreviewSampleData.sampleCats,
                selectedFilter = CatFilter.ALL,
                memoryCounts = mapOf("1" to 5, "2" to 2)
            ),
            onFilterSelected = {},
            onNavigateToAddCat = {},
            onNavigateToCatDetail = {}
        )
    }
}

@Preview(name = "Cats Screen - Empty", showBackground = true)
@Composable
private fun CatsScreenEmptyPreview() {
    MeowoirsTheme {
        CatsContent(
            uiState = CatsUiState(
                isLoading = false,
                allCats = emptyList(),
                filteredCats = emptyList()
            ),
            onFilterSelected = {},
            onNavigateToAddCat = {},
            onNavigateToCatDetail = {}
        )
    }
}
