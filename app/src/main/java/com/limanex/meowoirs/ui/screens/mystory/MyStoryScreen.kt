package com.limanex.meowoirs.ui.screens.mystory

import androidx.compose.foundation.BorderStroke
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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AutoAwesome
import androidx.compose.material.icons.outlined.AutoStories
import androidx.compose.material.icons.outlined.CalendarMonth
import androidx.compose.material.icons.outlined.ChevronRight
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material.icons.outlined.Star
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.limanex.meowoirs.data.repository.PreviewSampleData
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.ui.components.CatPreviewCard
import com.limanex.meowoirs.ui.components.MemoryCard
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSecondaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSectionHeader
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.MyStoryUiState
import com.limanex.meowoirs.viewmodel.MyStoryViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun MyStoryScreen(
    onNavigateToCats: () -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    onNavigateToAddMemory: () -> Unit,
    onNavigateToAddCat: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: MyStoryViewModel = viewModel(factory = MyStoryViewModel.Factory)
) {
    val uiState by viewModel.uiState.collectAsState()

    MyStoryContent(
        uiState = uiState,
        onNavigateToCats = onNavigateToCats,
        onNavigateToCatDetail = onNavigateToCatDetail,
        onNavigateToAddMemory = onNavigateToAddMemory,
        onNavigateToAddCat = onNavigateToAddCat,
        modifier = modifier
    )
}

@Composable
fun MyStoryContent(
    uiState: MyStoryUiState,
    onNavigateToCats: () -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    onNavigateToAddMemory: () -> Unit,
    onNavigateToAddCat: () -> Unit,
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
                    verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.large)
                ) {
                // 1. Editorial Header
                item {
                    Column(modifier = Modifier.fillMaxWidth()) {
                        Text(
                            text = "Hikâyem",
                            style = MeowoirsTheme.typography.displaySmall,
                            fontWeight = FontWeight.Bold,
                            color = MeowoirsTheme.colors.textPrimary
                        )
                        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))
                        Text(
                            text = "Sen ve kedilerin arasında biriken küçük anlar.",
                            style = MeowoirsTheme.typography.bodyLarge,
                            color = MeowoirsTheme.colors.textSecondary
                        )
                    }
                }

                // 2. Empty States
                if (uiState.isCompletelyEmpty) {
                    item {
                        CompletelyEmptyStoryCard(
                            onNavigateToAddMemory = onNavigateToAddMemory,
                            onNavigateToAddCat = onNavigateToAddCat
                        )
                    }
                } else if (uiState.hasCatsWithoutMemories) {
                    // Story Hero Narrative
                    item {
                        StoryHeroCard(summary = uiState.narrativeSummary)
                    }

                    // Quiet Statistics
                    item {
                        StoryStatsRow(uiState = uiState)
                    }

                    // Cats Section
                    item {
                        CatsHorizontalSection(
                            cats = uiState.cats,
                            onNavigateToCats = onNavigateToCats,
                            onNavigateToCatDetail = onNavigateToCatDetail
                        )
                    }

                    // Partial Empty Card (encouraging first memory)
                    item {
                        CatsWithoutMemoriesCard(
                            onAddMemoryClick = onNavigateToAddMemory
                        )
                    }
                } else {
                    // Full Content State
                    // 3. Story Hero Narrative
                    item {
                        StoryHeroCard(summary = uiState.narrativeSummary)
                    }

                    // 4. Quiet Story Statistics
                    item {
                        StoryStatsRow(uiState = uiState)
                    }

                    // 5. "Kedilerin" Section
                    if (uiState.cats.isNotEmpty()) {
                        item {
                            CatsHorizontalSection(
                                cats = uiState.cats,
                                onNavigateToCats = onNavigateToCats,
                                onNavigateToCatDetail = onNavigateToCatDetail
                            )
                        }
                    }

                    // 6. Most Remembered Cat ("En çok anı biriktirdiğin")
                    if (uiState.mostRememberedCat != null && uiState.mostRememberedCount > 0) {
                        item {
                            MostRememberedCatCard(
                                cat = uiState.mostRememberedCat,
                                memoryCount = uiState.mostRememberedCount,
                                onClick = { onNavigateToCatDetail(uiState.mostRememberedCat.id) }
                            )
                        }
                    }

                    // 7. Recent Story Moment ("Son Anın")
                    if (uiState.latestMemory != null) {
                        item {
                            Column(modifier = Modifier.fillMaxWidth()) {
                                MeowoirsSectionHeader(title = "Son Anın")
                                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                                MemoryCard(
                                    memory = uiState.latestMemory,
                                    showCatName = true,
                                    onClick = { onNavigateToCatDetail(uiState.latestMemory.catId) }
                                )
                            }
                        }
                    }

                    // 8. Story Beginning ("Meowoirs'teki ilk anın")
                    if (uiState.earliestMemory != null) {
                        item {
                            StoryBeginningCard(memory = uiState.earliestMemory)
                        }
                    }
                }
            }
        }
    }
}
}

/**
 * Warm editorial story narrative card.
 */
@Composable
private fun StoryHeroCard(
    summary: String,
    modifier: Modifier = Modifier
) {
    MeowoirsCard(
        modifier = modifier.fillMaxWidth(),
        shape = MeowoirsTheme.shapes.large,
        contentPadding = MeowoirsTheme.spacing.large
    ) {
        Column(modifier = Modifier.fillMaxWidth()) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
            ) {
                Icon(
                    imageVector = Icons.Outlined.AutoAwesome,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.orange,
                    modifier = Modifier.size(20.dp)
                )
                Text(
                    text = "Senin Meowoirs'in",
                    style = MeowoirsTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MeowoirsTheme.colors.textPrimary
                )
            }
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
            Text(
                text = summary,
                style = MeowoirsTheme.typography.bodyLarge,
                color = MeowoirsTheme.colors.textSecondary,
                lineHeight = MeowoirsTheme.typography.bodyLarge.lineHeight
            )
        }
    }
}

/**
 * 4 quiet statistics supporting the story.
 */
@Composable
private fun StoryStatsRow(
    uiState: MyStoryUiState,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
    ) {
        StatPill(
            count = uiState.totalCats,
            label = "Kediler",
            modifier = Modifier.weight(1f)
        )
        StatPill(
            count = uiState.totalMemories,
            label = "Anılar",
            modifier = Modifier.weight(1f)
        )
        StatPill(
            count = uiState.homeCatsCount,
            label = "Ev",
            modifier = Modifier.weight(1f)
        )
        StatPill(
            count = uiState.streetCatsCount,
            label = "Sokak",
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
private fun StatPill(
    count: Int,
    label: String,
    modifier: Modifier = Modifier
) {
    MeowoirsCard(
        modifier = modifier,
        shape = MeowoirsTheme.shapes.medium,
        contentPadding = MeowoirsTheme.spacing.medium
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = count.toString(),
                style = MeowoirsTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                color = MeowoirsTheme.colors.textPrimary
            )
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                text = label,
                style = MeowoirsTheme.typography.labelSmall,
                color = MeowoirsTheme.colors.textSecondary
            )
        }
    }
}

/**
 * "Kedilerin" horizontal section with "Tümünü Gör" action.
 */
@Composable
private fun CatsHorizontalSection(
    cats: List<Cat>,
    onNavigateToCats: () -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        MeowoirsSectionHeader(
            title = "Kedilerin",
            actionText = "Tümünü Gör",
            onActionClick = onNavigateToCats
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.mediumSmall),
            modifier = Modifier.fillMaxWidth()
        ) {
            items(cats, key = { it.id }) { cat ->
                CatPreviewCard(
                    cat = cat,
                    onClick = { onNavigateToCatDetail(cat.id) }
                )
            }
        }
    }
}

/**
 * Highlight card for the cat with the most memories.
 */
@Composable
private fun MostRememberedCatCard(
    cat: Cat,
    memoryCount: Int,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isHomeCat = cat.type == CatType.HOME
    val accentColor = if (isHomeCat) MeowoirsTheme.colors.orange else MeowoirsTheme.colors.sage
    val accentContainerColor = if (isHomeCat) {
        MeowoirsTheme.colors.accentOrangeContainer
    } else {
        MeowoirsTheme.colors.accentSageContainer
    }

    Column(modifier = modifier.fillMaxWidth()) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.extraSmall)
        ) {
            Icon(
                imageVector = Icons.Outlined.Star,
                contentDescription = null,
                tint = MeowoirsTheme.colors.orange,
                modifier = Modifier.size(18.dp)
            )
            Text(
                text = "En çok anı biriktirdiğin",
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

        MeowoirsCard(
            modifier = Modifier
                .fillMaxWidth()
                .clickable(onClick = onClick)
                .semantics {
                    role = Role.Button
                    contentDescription = "${cat.name}, en çok anı biriktirdiğin kedi. $memoryCount anı."
                },
            shape = MeowoirsTheme.shapes.large,
            contentPadding = MeowoirsTheme.spacing.medium
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Cat Photo / Avatar
                Box(
                    modifier = Modifier
                        .size(60.dp)
                        .clip(CircleShape)
                        .background(accentContainerColor),
                    contentAlignment = Alignment.Center
                ) {
                    if (!cat.photoUri.isNullOrBlank()) {
                        AsyncImage(
                            model = cat.photoUri,
                            contentDescription = "${cat.name} fotoğrafı",
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize()
                        )
                    } else {
                        Icon(
                            imageVector = Icons.Outlined.Pets,
                            contentDescription = null,
                            tint = accentColor,
                            modifier = Modifier.size(28.dp)
                        )
                    }
                }

                Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.medium))

                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = cat.name,
                        style = MeowoirsTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold,
                        color = MeowoirsTheme.colors.textPrimary
                    )
                    Spacer(modifier = Modifier.height(2.dp))
                    Text(
                        text = "$memoryCount anı biriktirildi",
                        style = MeowoirsTheme.typography.bodyMedium,
                        color = accentColor,
                        fontWeight = FontWeight.Medium
                    )
                }

                Icon(
                    imageVector = Icons.Outlined.ChevronRight,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.textTertiary,
                    modifier = Modifier.size(24.dp)
                )
            }
        }
    }
}

/**
 * Story beginning card showing earliest memory date.
 */
@Composable
private fun StoryBeginningCard(
    memory: Memory,
    modifier: Modifier = Modifier
) {
    val formattedDate = remember(memory.createdAt) {
        val sdf = SimpleDateFormat("d MMMM yyyy", Locale("tr", "TR"))
        sdf.format(Date(memory.createdAt))
    }

    MeowoirsCard(
        modifier = modifier.fillMaxWidth(),
        shape = MeowoirsTheme.shapes.large,
        contentPadding = MeowoirsTheme.spacing.large
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(MeowoirsTheme.shapes.medium)
                    .background(MeowoirsTheme.colors.accentLavenderContainer),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.CalendarMonth,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.lavender,
                    modifier = Modifier.size(24.dp)
                )
            }

            Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.medium))

            Column {
                Text(
                    text = "Meowoirs'teki ilk anın",
                    style = MeowoirsTheme.typography.labelMedium,
                    color = MeowoirsTheme.colors.textSecondary
                )
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = formattedDate,
                    style = MeowoirsTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MeowoirsTheme.colors.textPrimary
                )
            }
        }
    }
}

/**
 * Completely empty state (0 cats and 0 memories).
 */
@Composable
private fun CompletelyEmptyStoryCard(
    onNavigateToAddMemory: () -> Unit,
    onNavigateToAddCat: () -> Unit,
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
                text = "Burada senin hikâyen başlayacak.",
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
                onClick = onNavigateToAddMemory,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            MeowoirsSecondaryButton(
                text = "İlk Kedini Ekle",
                onClick = onNavigateToAddCat,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

/**
 * Partial empty state: cats exist, but no memories recorded yet.
 */
@Composable
private fun CatsWithoutMemoriesCard(
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
            Text(
                text = "Henüz anlatacak bir anın yok.",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Kedilerin burada. Onlarla geçirdiğin ilk küçük anı sakla.",
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

// ----------------------------------------------------
// Compose Previews
// ----------------------------------------------------

@Preview(name = "My Story - Content", showBackground = true)
@Composable
private fun MyStoryScreenPreview() {
    MeowoirsTheme {
        MyStoryContent(
            uiState = MyStoryUiState(
                isLoading = false,
                cats = PreviewSampleData.sampleCats,
                memories = PreviewSampleData.sampleMemories,
                totalCats = 2,
                homeCatsCount = 1,
                streetCatsCount = 1,
                totalMemories = 2,
                mostRememberedCat = PreviewSampleData.sampleCats.first(),
                mostRememberedCount = 2,
                latestMemory = PreviewSampleData.sampleMemories.first(),
                earliestMemory = PreviewSampleData.sampleMemories.last(),
                narrativeSummary = "2 dostunla 2 küçük an biriktirdin. Evdeki sıcak anlar ve sokakta karşılaştığın küçük hikâyeler bir arada."
            ),
            onNavigateToCats = {},
            onNavigateToCatDetail = {},
            onNavigateToAddMemory = {},
            onNavigateToAddCat = {}
        )
    }
}

@Preview(name = "My Story - Completely Empty", showBackground = true)
@Composable
private fun MyStoryCompletelyEmptyPreview() {
    MeowoirsTheme {
        MyStoryContent(
            uiState = MyStoryUiState(
                isLoading = false,
                cats = emptyList(),
                memories = emptyList()
            ),
            onNavigateToCats = {},
            onNavigateToCatDetail = {},
            onNavigateToAddMemory = {},
            onNavigateToAddCat = {}
        )
    }
}
