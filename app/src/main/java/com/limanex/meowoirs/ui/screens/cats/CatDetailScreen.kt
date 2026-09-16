package com.limanex.meowoirs.ui.screens.cats

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.outlined.AutoStories
import androidx.compose.material.icons.outlined.Delete
import androidx.compose.material.icons.outlined.Edit
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import com.limanex.meowoirs.R
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.limanex.meowoirs.data.repository.PreviewSampleData
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.ui.components.MemoryCard
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSecondaryButton
import com.limanex.meowoirs.ui.components.MeowoirsSectionHeader
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.CatDetailUiState
import com.limanex.meowoirs.viewmodel.CatDetailViewModel

@Composable
fun CatDetailScreen(
    catId: String,
    onBack: () -> Unit,
    onNavigateToEditCat: (String) -> Unit,
    onNavigateToAddMemory: (String) -> Unit,
    onNavigateToMemoryDetail: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: CatDetailViewModel = viewModel(factory = CatDetailViewModel.provideFactory(catId))
) {
    val uiState by viewModel.uiState.collectAsState()

    CatDetailContent(
        uiState = uiState,
        onBack = onBack,
        onNavigateToEditCat = onNavigateToEditCat,
        onNavigateToAddMemory = { onNavigateToAddMemory(catId) },
        onNavigateToMemoryDetail = onNavigateToMemoryDetail,
        onDeleteCat = {
            viewModel.deleteCat(onSuccess = onBack)
        },
        modifier = modifier
    )
}

@Composable
fun CatDetailContent(
    uiState: CatDetailUiState,
    onBack: () -> Unit,
    onNavigateToEditCat: (String) -> Unit,
    onNavigateToAddMemory: () -> Unit,
    onNavigateToMemoryDetail: (String) -> Unit,
    onDeleteCat: () -> Unit,
    modifier: Modifier = Modifier
) {
    var showDeleteDialog by remember { mutableStateOf(false) }
    val snackbarHostState = remember { androidx.compose.material3.SnackbarHostState() }
    val errorString = stringResource(R.string.cat_delete_error)

    androidx.compose.runtime.LaunchedEffect(uiState.errorMessage) {
        if (uiState.errorMessage != null) {
            snackbarHostState.showSnackbar(errorString)
        }
    }

    if (showDeleteDialog) {
        AlertDialog(
            onDismissRequest = {
                if (!uiState.isDeleting) showDeleteDialog = false
            },
            title = { Text(stringResource(R.string.delete_cat_title)) },
            text = { Text(stringResource(R.string.delete_cat_message)) },
            confirmButton = {
                Button(
                    onClick = {
                        showDeleteDialog = false
                        onDeleteCat()
                    },
                    enabled = !uiState.isDeleting,
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFD32F2F))
                ) {
                    Text(
                        if (uiState.isDeleting) stringResource(R.string.loading)
                        else stringResource(R.string.action_delete)
                    )
                }
            },
            dismissButton = {
                TextButton(
                    onClick = { showDeleteDialog = false },
                    enabled = !uiState.isDeleting
                ) {
                    Text(stringResource(R.string.action_cancel))
                }
            }
        )
    }

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

            uiState.isNotFound || uiState.cat == null -> {
                CatNotFoundView(onBack = onBack)
            }

            else -> {
                val cat = uiState.cat
                com.limanex.meowoirs.ui.components.SubtleContentEntrance {
                    Column(modifier = Modifier.fillMaxSize()) {
                        // Top Navigation & Action Bar
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(
                                    start = MeowoirsTheme.spacing.small,
                                    end = MeowoirsTheme.spacing.small,
                                    top = MeowoirsTheme.spacing.small
                                ),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            IconButton(
                                onClick = onBack,
                                modifier = Modifier.size(40.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                                    contentDescription = stringResource(R.string.action_back),
                                    tint = MeowoirsTheme.colors.textPrimary
                                )
                            }

                            Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                                IconButton(
                                    onClick = { onNavigateToEditCat(cat.id) },
                                    modifier = Modifier.size(40.dp)
                                ) {
                                    Icon(
                                        imageVector = Icons.Outlined.Edit,
                                        contentDescription = stringResource(R.string.action_edit),
                                        tint = MeowoirsTheme.colors.textPrimary
                                    )
                                }

                                IconButton(
                                    onClick = { showDeleteDialog = true },
                                    modifier = Modifier.size(40.dp)
                                ) {
                                    Icon(
                                        imageVector = Icons.Outlined.Delete,
                                        contentDescription = stringResource(R.string.action_delete),
                                        tint = Color(0xFFD32F2F)
                                    )
                                }
                            }
                        }

                        LazyColumn(
                            modifier = Modifier.fillMaxSize(),
                            contentPadding = PaddingValues(
                                start = MeowoirsTheme.spacing.medium,
                                end = MeowoirsTheme.spacing.medium,
                                top = MeowoirsTheme.spacing.extraSmall,
                                bottom = 100.dp
                            ),
                            verticalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium)
                        ) {
                            // 1. Hero Cat Photo Container (4:3 editorial aspect ratio)
                            item {
                                CatHeroPhoto(cat = cat)
                            }

                            // 2. Cat Identity & Title Section
                            item {
                                CatIdentitySection(
                                    cat = cat,
                                    storyTitle = uiState.storyTitle,
                                    memoryCount = uiState.memories.size,
                                    memoryCountText = uiState.memoryCountText,
                                    onAddMemoryClick = onNavigateToAddMemory
                                )
                            }

                            // 3. Memories Section Header
                            if (uiState.memories.isNotEmpty()) {
                                item {
                                    MeowoirsSectionHeader(
                                        title = "Anılar",
                                        subtitle = "${uiState.memories.size} anı kaydedildi"
                                    )
                                }

                                // Chronological memory collection (newest first)
                                items(uiState.memories, key = { it.id }) { memory ->
                                    MemoryCard(
                                        memory = memory,
                                        showCatName = false, // Omit cat name since screen belongs to this cat
                                        onClick = { onNavigateToMemoryDetail(memory.id) }
                                    )
                                }
                            } else {
                                // Empty memory state
                                item {
                                    EmptyMemoriesForCatCard(
                                        onAddMemoryClick = onNavigateToAddMemory
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        androidx.compose.material3.SnackbarHost(
            hostState = snackbarHostState,
            modifier = Modifier.align(Alignment.BottomCenter)
        )
    }
}

/**
 * Editorial Hero image for the cat story.
 */
@Composable
private fun CatHeroPhoto(
    cat: Cat,
    modifier: Modifier = Modifier
) {
    val isHomeCat = cat.type == CatType.HOME
    val accentContainerColor = if (isHomeCat) {
        MeowoirsTheme.colors.accentOrangeContainer
    } else {
        MeowoirsTheme.colors.accentSageContainer
    }
    val accentColor = if (isHomeCat) MeowoirsTheme.colors.orange else MeowoirsTheme.colors.sage

    Box(
        modifier = modifier
            .fillMaxWidth()
            .aspectRatio(4f / 3f)
            .clip(MeowoirsTheme.shapes.extraLarge)
            .background(accentContainerColor.copy(alpha = 0.4f)),
        contentAlignment = Alignment.Center
    ) {
        if (!cat.photoUri.isNullOrBlank()) {
            coil.compose.SubcomposeAsyncImage(
                model = cat.photoUri,
                contentDescription = "${cat.name} fotoğrafı",
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize(),
                error = {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Box(
                            modifier = Modifier
                                .size(80.dp)
                                .clip(CircleShape)
                                .background(accentContainerColor),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Outlined.Pets,
                                contentDescription = stringResource(R.string.photo_load_failed),
                                tint = accentColor,
                                modifier = Modifier.size(40.dp)
                            )
                        }
                        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                        Text(
                            text = cat.name,
                            style = MeowoirsTheme.typography.titleMedium,
                            fontWeight = FontWeight.SemiBold,
                            color = MeowoirsTheme.colors.textPrimary
                        )
                    }
                }
            )
        } else {
            // Warm intentional silhouette placeholder
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .clip(CircleShape)
                        .background(accentContainerColor),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Outlined.Pets,
                        contentDescription = null,
                        tint = accentColor,
                        modifier = Modifier.size(40.dp)
                    )
                }
                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
                Text(
                    text = cat.name,
                    style = MeowoirsTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    color = MeowoirsTheme.colors.textPrimary
                )
            }
        }
    }
}

/**
 * Identity header establishing "[Cat Name]'in Hikâyesi" and context.
 */
@Composable
private fun CatIdentitySection(
    cat: Cat,
    storyTitle: String,
    memoryCount: Int,
    memoryCountText: String,
    onAddMemoryClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isHomeCat = cat.type == CatType.HOME
    val badgeColor = if (isHomeCat) MeowoirsTheme.colors.orange else MeowoirsTheme.colors.sage
    val badgeBg = if (isHomeCat) MeowoirsTheme.colors.accentOrangeContainer else MeowoirsTheme.colors.accentSageContainer
    val icon = if (isHomeCat) Icons.Outlined.Home else Icons.Outlined.Pets

    Column(modifier = modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Subtle Home / Street Badge with icon and text
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier
                    .clip(FullCornerShape)
                    .background(badgeBg)
                    .padding(
                        horizontal = MeowoirsTheme.spacing.mediumSmall,
                        vertical = MeowoirsTheme.spacing.extraSmall
                    )
                    .semantics {
                        contentDescription = cat.type.label
                    }
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = badgeColor,
                    modifier = Modifier.size(16.dp)
                )
                Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
                Text(
                    text = cat.type.label,
                    style = MeowoirsTheme.typography.labelSmall,
                    color = badgeColor,
                    fontWeight = FontWeight.SemiBold
                )
            }

            // Contextual "Anı Ekle" button in header
            MeowoirsSecondaryButton(
                text = "Anı Ekle",
                onClick = onAddMemoryClick,
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

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.mediumSmall))

        // Emotional Story Title
        Text(
            text = storyTitle,
            style = MeowoirsTheme.typography.headlineLarge,
            fontWeight = FontWeight.Bold,
            color = MeowoirsTheme.colors.textPrimary
        )

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))

        // Supporting line & subtle memory count
        Text(
            text = "Birlikte biriktirdiğiniz küçük anlar. $memoryCountText",
            style = MeowoirsTheme.typography.bodyMedium,
            color = MeowoirsTheme.colors.textSecondary
        )
    }
}

/**
 * Empty memory state when this specific cat has no memories yet.
 */
@Composable
private fun EmptyMemoriesForCatCard(
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
                text = "Hikâye daha yeni başlıyor.",
                style = MeowoirsTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = "Bu kediyle yaşadığın ilk küçük anı burada saklayabilirsin.",
                style = MeowoirsTheme.typography.bodyMedium,
                color = MeowoirsTheme.colors.textSecondary,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

            MeowoirsPrimaryButton(
                text = "İlk Anıyı Ekle",
                onClick = onAddMemoryClick,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

/**
 * Graceful not-found view when catId is invalid or deleted.
 */
@Composable
private fun CatNotFoundView(
    onBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(MeowoirsTheme.spacing.large),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        MeowoirsCard(
            modifier = Modifier.fillMaxWidth(),
            shape = MeowoirsTheme.shapes.large,
            contentPadding = MeowoirsTheme.spacing.large
        ) {
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = stringResource(R.string.cat_not_found_title),
                    style = MeowoirsTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = MeowoirsTheme.colors.textPrimary,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

                Text(
                    text = stringResource(R.string.cat_not_found_desc),
                    style = MeowoirsTheme.typography.bodyMedium,
                    color = MeowoirsTheme.colors.textSecondary,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

                MeowoirsSecondaryButton(
                    text = stringResource(R.string.action_back),
                    onClick = onBack,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }
    }
}

// ----------------------------------------------------
// Compose Previews
// ----------------------------------------------------

@Preview(name = "Cat Detail - Content", showBackground = true)
@Composable
private fun CatDetailScreenPreview() {
    MeowoirsTheme {
        CatDetailContent(
            uiState = CatDetailUiState(
                isLoading = false,
                cat = PreviewSampleData.sampleCats.first(),
                memories = PreviewSampleData.sampleMemories
            ),
            onBack = {},
            onNavigateToEditCat = {},
            onNavigateToAddMemory = {},
            onNavigateToMemoryDetail = {},
            onDeleteCat = {}
        )
    }
}

@Preview(name = "Cat Detail - Empty Memories", showBackground = true)
@Composable
private fun CatDetailEmptyPreview() {
    MeowoirsTheme {
        CatDetailContent(
            uiState = CatDetailUiState(
                isLoading = false,
                cat = PreviewSampleData.sampleCats.first(),
                memories = emptyList()
            ),
            onBack = {},
            onNavigateToEditCat = {},
            onNavigateToAddMemory = {},
            onNavigateToMemoryDetail = {},
            onDeleteCat = {}
        )
    }
}

@Preview(name = "Cat Detail - Not Found", showBackground = true)
@Composable
private fun CatDetailNotFoundPreview() {
    MeowoirsTheme {
        CatDetailContent(
            uiState = CatDetailUiState(
                isLoading = false,
                cat = null,
                isNotFound = true
            ),
            onBack = {},
            onNavigateToEditCat = {},
            onNavigateToAddMemory = {},
            onNavigateToMemoryDetail = {},
            onDeleteCat = {}
        )
    }
}
