package com.limanex.meowoirs.ui.screens.memories

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.Delete
import androidx.compose.material.icons.outlined.Edit
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material.icons.outlined.SentimentSatisfied
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.limanex.meowoirs.R
import com.limanex.meowoirs.data.repository.PreviewSampleData
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsChip
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.MemoryDetailUiState
import com.limanex.meowoirs.viewmodel.MemoryDetailViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun MemoryDetailScreen(
    memoryId: String,
    onBack: () -> Unit,
    onNavigateToEditMemory: (String) -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: MemoryDetailViewModel = viewModel(
        factory = MemoryDetailViewModel.provideFactory(memoryId)
    )
) {
    val uiState by viewModel.uiState.collectAsState()

    MemoryDetailContent(
        uiState = uiState,
        onBack = onBack,
        onNavigateToEditMemory = onNavigateToEditMemory,
        onNavigateToCatDetail = onNavigateToCatDetail,
        onDeleteMemory = {
            viewModel.deleteMemory(onSuccess = onBack)
        },
        modifier = modifier
    )
}

@Composable
fun MemoryDetailContent(
    uiState: MemoryDetailUiState,
    onBack: () -> Unit,
    onNavigateToEditMemory: (String) -> Unit,
    onNavigateToCatDetail: (String) -> Unit,
    onDeleteMemory: () -> Unit,
    modifier: Modifier = Modifier
) {
    var showDeleteDialog by remember { mutableStateOf(false) }
    val snackbarHostState = remember { androidx.compose.material3.SnackbarHostState() }
    val errorString = stringResource(R.string.memory_delete_error)

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
            title = { Text(stringResource(R.string.delete_memory_title)) },
            text = { Text(stringResource(R.string.delete_memory_message)) },
            confirmButton = {
                Button(
                    onClick = {
                        showDeleteDialog = false
                        onDeleteMemory()
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

            uiState.isNotFound || uiState.memory == null -> {
                MemoryNotFoundView(onBack = onBack)
            }

            else -> {
                val memory = uiState.memory
                val scrollState = rememberScrollState()

                val formattedDate = remember(memory.createdAt) {
                    val sdf = SimpleDateFormat("d MMMM yyyy", Locale("tr", "TR"))
                    sdf.format(Date(memory.createdAt))
                }

                Column(
                    modifier = Modifier
                        .fillMaxSize()
                ) {
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

                        Text(
                            text = stringResource(R.string.memory_detail_title),
                            style = MeowoirsTheme.typography.titleMedium,
                            fontWeight = FontWeight.SemiBold,
                            color = MeowoirsTheme.colors.textPrimary
                        )

                        Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                            IconButton(
                                onClick = { onNavigateToEditMemory(memory.id) },
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

                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .verticalScroll(scrollState)
                            .padding(MeowoirsTheme.spacing.large)
                    ) {
                        // Memory Photo
                        if (!memory.photoUri.isNullOrBlank()) {
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .aspectRatio(4f / 3f)
                                    .clip(MeowoirsTheme.shapes.large)
                                    .background(MeowoirsTheme.colors.cardBackground)
                                    .border(
                                        BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
                                        MeowoirsTheme.shapes.large
                                    )
                            ) {
                                coil.compose.SubcomposeAsyncImage(
                                    model = memory.photoUri,
                                    contentDescription = stringResource(R.string.memory_detail_title),
                                    contentScale = ContentScale.Crop,
                                    modifier = Modifier.fillMaxSize(),
                                    error = {
                                        Box(
                                            modifier = Modifier.fillMaxSize(),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            Icon(
                                                imageVector = Icons.Outlined.Pets,
                                                contentDescription = stringResource(R.string.photo_load_failed),
                                                tint = MeowoirsTheme.colors.orange,
                                                modifier = Modifier.size(40.dp)
                                            )
                                        }
                                    }
                                )
                            }
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))
                        }

                        // Cat Badge & Date Meta Row
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            // Clickable Cat Badge
                            Surface(
                                modifier = Modifier
                                    .defaultMinSize(minHeight = 44.dp)
                                    .clip(FullCornerShape)
                                    .clickable { onNavigateToCatDetail(memory.catId) }
                                    .semantics {
                                        role = Role.Button
                                        contentDescription = memory.catName
                                    },
                                shape = FullCornerShape,
                                color = MeowoirsTheme.colors.accentOrangeContainer,
                                border = BorderStroke(1.dp, MeowoirsTheme.colors.orange.copy(alpha = 0.3f))
                            ) {
                                Row(
                                    modifier = Modifier.padding(
                                        horizontal = MeowoirsTheme.spacing.mediumSmall,
                                        vertical = MeowoirsTheme.spacing.extraSmall
                                    ),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(
                                        imageVector = Icons.Outlined.Pets,
                                        contentDescription = null,
                                        tint = MeowoirsTheme.colors.orange,
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
                                    Text(
                                        text = memory.catName,
                                        style = MeowoirsTheme.typography.labelMedium,
                                        color = MeowoirsTheme.colors.orange,
                                        fontWeight = FontWeight.SemiBold
                                    )
                                }
                            }

                            // Formatted Date
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    imageVector = Icons.Outlined.CalendarToday,
                                    contentDescription = null,
                                    tint = MeowoirsTheme.colors.textTertiary,
                                    modifier = Modifier.size(14.dp)
                                )
                                Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.extraSmall))
                                Text(
                                    text = formattedDate,
                                    style = MeowoirsTheme.typography.labelSmall,
                                    color = MeowoirsTheme.colors.textTertiary
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

                        // Note / Story Section
                        if (memory.note.isNotBlank()) {
                            MeowoirsCard(
                                modifier = Modifier.fillMaxWidth(),
                                shape = MeowoirsTheme.shapes.large,
                                contentPadding = MeowoirsTheme.spacing.large
                            ) {
                                Text(
                                    text = memory.note,
                                    style = MeowoirsTheme.typography.bodyLarge,
                                    color = MeowoirsTheme.colors.textPrimary,
                                    lineHeight = MeowoirsTheme.typography.bodyLarge.lineHeight
                                )
                            }
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))
                        }

                        // Mood Badges Section
                        if (!memory.catMood.isNullOrBlank() || !memory.userMood.isNullOrBlank()) {
                            Text(
                                text = "Ruh Hâli",
                                style = MeowoirsTheme.typography.titleSmall,
                                fontWeight = FontWeight.SemiBold,
                                color = MeowoirsTheme.colors.textPrimary
                            )
                            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.small)
                            ) {
                                if (!memory.catMood.isNullOrBlank()) {
                                    MeowoirsChip(
                                        label = "Onun hâli: ${memory.catMood}",
                                        icon = Icons.Outlined.Pets,
                                        isSelected = false
                                    )
                                }
                                if (!memory.userMood.isNullOrBlank()) {
                                    MeowoirsChip(
                                        label = "Senin hissin: ${memory.userMood}",
                                        icon = Icons.Outlined.SentimentSatisfied,
                                        isSelected = false
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

@Composable
private fun MemoryNotFoundView(
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
        Box(
            modifier = Modifier
                .size(72.dp)
                .clip(CircleShape)
                .background(MeowoirsTheme.colors.accentOrangeContainer),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Outlined.Pets,
                contentDescription = null,
                tint = MeowoirsTheme.colors.orange,
                modifier = Modifier.size(36.dp)
            )
        }
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))
        Text(
            text = stringResource(R.string.memory_not_found_title),
            style = MeowoirsTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
        Text(
            text = stringResource(R.string.memory_not_found_desc),
            style = MeowoirsTheme.typography.bodyMedium,
            color = MeowoirsTheme.colors.textSecondary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))
        Button(
            onClick = onBack,
            colors = ButtonDefaults.buttonColors(containerColor = MeowoirsTheme.colors.orange)
        ) {
            Text(stringResource(R.string.action_back), color = Color.White)
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun MemoryDetailPreview() {
    MeowoirsTheme {
        MemoryDetailContent(
            uiState = MemoryDetailUiState(
                isLoading = false,
                memory = PreviewSampleData.sampleMemories.firstOrNull() ?: Memory(
                    id = "preview_1",
                    catId = "cat_1",
                    catName = "Minnoş",
                    note = "Bugün pencerenin önünde güneşlenirken uyuyakaldı.",
                    catMood = "Uykulu",
                    userMood = "Huzurlu",
                    createdAt = System.currentTimeMillis()
                )
            ),
            onBack = {},
            onNavigateToEditMemory = {},
            onNavigateToCatDetail = {},
            onDeleteMemory = {}
        )
    }
}
