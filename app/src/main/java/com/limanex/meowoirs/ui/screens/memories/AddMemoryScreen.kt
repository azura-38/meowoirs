package com.limanex.meowoirs.ui.screens.memories

import android.content.Intent
import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
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
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.outlined.AddAPhoto
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberDatePickerState
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
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.ui.platform.LocalContext
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
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.theme.FullCornerShape
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.AddMemoryUiState
import com.limanex.meowoirs.viewmodel.AddMemoryViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun AddMemoryScreen(
    initialCatId: String? = null,
    memoryId: String? = null,
    onBack: () -> Unit,
    onNavigateToAddCat: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: AddMemoryViewModel = viewModel(
        factory = AddMemoryViewModel.provideFactory(initialCatId, memoryId)
    )
) {
    val uiState by viewModel.uiState.collectAsState()
    val context = LocalContext.current

    // Modern Photo Picker launcher with persistable URI permission
    val photoPickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.PickVisualMedia()
    ) { uri: Uri? ->
        if (uri != null) {
            try {
                context.contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
            } catch (_: Exception) {
                // If persistable permission is not grantable, continue with normal URI
            }
            viewModel.onPhotoSelected(uri.toString())
        }
    }

    androidx.compose.runtime.LaunchedEffect(uiState.isSaved) {
        if (uiState.isSaved) {
            kotlinx.coroutines.delay(350)
            onBack()
        }
    }

    AddMemoryContent(
        uiState = uiState,
        onBack = onBack,
        onSelectCat = { viewModel.selectCat(it) },
        onPickPhotoClick = {
            photoPickerLauncher.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
            )
        },
        onRemovePhotoClick = { viewModel.onPhotoSelected(null) },
        onNoteChanged = { viewModel.onNoteChanged(it) },
        onCatMoodSelected = { viewModel.onCatMoodSelected(it) },
        onUserMoodSelected = { viewModel.onUserMoodSelected(it) },
        onDateSelected = { viewModel.onDateSelected(it) },
        onSaveClick = {
            viewModel.saveMemory(onSuccess = {})
        },
        onNavigateToAddCat = onNavigateToAddCat,
        modifier = modifier
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddMemoryContent(
    uiState: AddMemoryUiState,
    onBack: () -> Unit,
    onSelectCat: (String) -> Unit,
    onPickPhotoClick: () -> Unit,
    onRemovePhotoClick: () -> Unit,
    onNoteChanged: (String) -> Unit,
    onCatMoodSelected: (String) -> Unit,
    onUserMoodSelected: (String) -> Unit,
    onDateSelected: (Long) -> Unit,
    onSaveClick: () -> Unit,
    onNavigateToAddCat: () -> Unit,
    modifier: Modifier = Modifier
) {
    val scrollState = rememberScrollState()
    var showDatePicker by remember { mutableStateOf(false) }

    val formattedDate = remember(uiState.selectedDateMillis) {
        val sdf = SimpleDateFormat("d MMMM yyyy", Locale("tr", "TR"))
        sdf.format(Date(uiState.selectedDateMillis))
    }

    if (showDatePicker) {
        val datePickerState = rememberDatePickerState(
            initialSelectedDateMillis = uiState.selectedDateMillis
        )
        DatePickerDialog(
            onDismissRequest = { showDatePicker = false },
            confirmButton = {
                TextButton(
                    onClick = {
                        val selected = datePickerState.selectedDateMillis
                        if (selected != null) {
                            onDateSelected(selected)
                        }
                        showDatePicker = false
                    }
                ) {
                    Text("Tamam", color = MeowoirsTheme.colors.orange)
                }
            },
            dismissButton = {
                TextButton(onClick = { showDatePicker = false }) {
                    Text("İptal", color = MeowoirsTheme.colors.textSecondary)
                }
            }
        ) {
            DatePicker(state = datePickerState)
        }
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(MeowoirsTheme.colors.cream)
            .imePadding()
            .verticalScroll(scrollState)
            .padding(
                start = MeowoirsTheme.spacing.large,
                end = MeowoirsTheme.spacing.large,
                top = MeowoirsTheme.spacing.medium,
                bottom = MeowoirsTheme.spacing.sectionLarge
            ),
        horizontalAlignment = Alignment.Start
    ) {
        // Back Navigation Row
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.Start,
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
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

        // Editorial Header
        Text(
            text = if (uiState.isEditMode) stringResource(R.string.edit_memory_title) else "Anı Ekle",
            style = MeowoirsTheme.typography.displaySmall,
            fontWeight = FontWeight.Bold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
        Text(
            text = if (uiState.isEditMode) stringResource(R.string.edit_memory_subtitle) else "Bugünden küçük bir anı sakla.",
            style = MeowoirsTheme.typography.bodyLarge,
            color = MeowoirsTheme.colors.textSecondary
        )

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // Step 1: Cat Selection ("Kiminle?")
        Text(
            text = "Kiminle?",
            style = MeowoirsTheme.typography.titleMedium,
            fontWeight = FontWeight.SemiBold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
        CatSelectionRow(
            cats = uiState.availableCats,
            selectedCatId = uiState.selectedCatId,
            onSelectCat = onSelectCat,
            onNavigateToAddCat = onNavigateToAddCat
        )

        // Validation Error if no cat selected
        if (uiState.validationError != null) {
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
            Text(
                text = stringResource(R.string.memory_cat_required_error),
                color = MeowoirsTheme.colors.orange,
                style = MeowoirsTheme.typography.bodySmall
            )
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // Step 2: Photo Area ("Bu anı hatırlatan bir fotoğraf")
        Text(
            text = "Bu anı hatırlatan bir fotoğraf",
            style = MeowoirsTheme.typography.titleMedium,
            fontWeight = FontWeight.SemiBold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(16f / 9f)
                .clip(MeowoirsTheme.shapes.large)
                .background(MeowoirsTheme.colors.cardBackground)
                .border(
                    BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder),
                    MeowoirsTheme.shapes.large
                )
                .clickable(
                    onClick = onPickPhotoClick,
                    onClickLabel = "Fotoğraf ekle"
                )
                .semantics {
                    role = Role.Button
                    contentDescription = if (!uiState.photoUri.isNullOrBlank()) "Seçilen anı fotoğrafı" else "Fotoğraf ekle"
                },
            contentAlignment = Alignment.Center
        ) {
            if (!uiState.photoUri.isNullOrBlank()) {
                coil.compose.SubcomposeAsyncImage(
                    model = uiState.photoUri,
                    contentDescription = stringResource(R.string.memory_detail_title),
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize(),
                    error = {
                        Box(
                            modifier = Modifier.fillMaxSize(),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Outlined.AddAPhoto,
                                contentDescription = stringResource(R.string.photo_load_failed),
                                tint = MeowoirsTheme.colors.orange,
                                modifier = Modifier.size(36.dp)
                            )
                        }
                    }
                )
            } else {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Icon(
                        imageVector = Icons.Outlined.AddAPhoto,
                        contentDescription = "Anı fotoğrafı ekle",
                        tint = MeowoirsTheme.colors.orange,
                        modifier = Modifier.size(36.dp)
                    )
                    Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
                    Text(
                        text = "Fotoğraf ekle",
                        style = MeowoirsTheme.typography.labelMedium,
                        color = MeowoirsTheme.colors.textSecondary
                    )
                }
            }
        }

        if (!uiState.photoUri.isNullOrBlank()) {
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
            Row(
                horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .defaultMinSize(minHeight = 48.dp, minWidth = 48.dp)
                        .clickable(onClick = onPickPhotoClick)
                        .semantics {
                            role = Role.Button
                            contentDescription = "Fotoğrafı değiştir"
                        },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Değiştir",
                        style = MeowoirsTheme.typography.labelMedium,
                        color = MeowoirsTheme.colors.orange
                    )
                }
                Box(
                    modifier = Modifier
                        .defaultMinSize(minHeight = 48.dp, minWidth = 48.dp)
                        .clickable(onClick = onRemovePhotoClick)
                        .semantics {
                            role = Role.Button
                            contentDescription = "Fotoğrafı kaldır"
                        },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Kaldır",
                        style = MeowoirsTheme.typography.labelMedium,
                        color = MeowoirsTheme.colors.textTertiary
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // Step 3: Note Field ("Ne oldu?")
        Text(
            text = "Ne oldu?",
            style = MeowoirsTheme.typography.titleMedium,
            fontWeight = FontWeight.SemiBold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
        OutlinedTextField(
            value = uiState.note,
            onValueChange = onNoteChanged,
            placeholder = {
                Text(
                    text = "Bugün ne oldu? Örneğin: Bugün yine pencerenin önünde uyuyakaldı...",
                    style = MeowoirsTheme.typography.bodyMedium,
                    color = MeowoirsTheme.colors.textTertiary
                )
            },
            minLines = 4,
            shape = MeowoirsTheme.shapes.medium,
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = MeowoirsTheme.colors.orange,
                unfocusedBorderColor = MeowoirsTheme.colors.cardBorder,
                focusedContainerColor = MeowoirsTheme.colors.cardBackground,
                unfocusedContainerColor = MeowoirsTheme.colors.cardBackground,
                focusedTextColor = MeowoirsTheme.colors.textPrimary,
                unfocusedTextColor = MeowoirsTheme.colors.textPrimary
            ),
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // Step 4 & 5: Dual Mood ("Onun ruh hâli" & "Sen nasıl hissettin?")
        DualMoodSelector(
            selectedCatMood = uiState.catMood,
            onSelectCatMood = onCatMoodSelected,
            selectedUserMood = uiState.userMood,
            onSelectUserMood = onUserMoodSelected
        )

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // Step 6: Date Picker ("Ne zaman?")
        Text(
            text = "Ne zaman?",
            style = MeowoirsTheme.typography.titleMedium,
            fontWeight = FontWeight.SemiBold,
            color = MeowoirsTheme.colors.textPrimary
        )
        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .defaultMinSize(minHeight = 48.dp)
                .clip(FullCornerShape)
                .clickable { showDatePicker = true }
                .semantics {
                    role = Role.Button
                    contentDescription = "Tarih seç: $formattedDate"
                },
            shape = FullCornerShape,
            color = MeowoirsTheme.colors.cardBackground,
            border = BorderStroke(1.dp, MeowoirsTheme.colors.cardBorder)
        ) {
            Row(
                modifier = Modifier.padding(
                    horizontal = MeowoirsTheme.spacing.medium,
                    vertical = MeowoirsTheme.spacing.mediumSmall
                ),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Outlined.CalendarToday,
                    contentDescription = null,
                    tint = MeowoirsTheme.colors.orange,
                    modifier = Modifier.size(20.dp)
                )
                Spacer(modifier = Modifier.width(MeowoirsTheme.spacing.small))
                Text(
                    text = formattedDate,
                    style = MeowoirsTheme.typography.bodyMedium,
                    color = MeowoirsTheme.colors.textPrimary,
                    fontWeight = FontWeight.Medium
                )
            }
        }

        if (uiState.saveError != null) {
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))
            Text(
                text = stringResource(R.string.memory_save_error),
                color = Color(0xFFD32F2F),
                style = MeowoirsTheme.typography.bodyMedium,
                textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraLarge))

        // Step 7: Primary Save Button
        val buttonText = when {
            uiState.isSaved -> "Kaydedildi ✓"
            uiState.isSaving -> stringResource(R.string.loading)
            uiState.isEditMode -> stringResource(R.string.action_save_changes)
            else -> stringResource(R.string.action_save)
        }
        MeowoirsPrimaryButton(
            text = buttonText,
            onClick = onSaveClick,
            enabled = !uiState.isSaving && !uiState.isSaved && uiState.hasCats,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

// ----------------------------------------------------
// Compose Previews
// ----------------------------------------------------

@Preview(name = "Add Memory Screen - Content", showBackground = true)
@Composable
private fun AddMemoryScreenPreview() {
    MeowoirsTheme {
        AddMemoryContent(
            uiState = AddMemoryUiState(
                availableCats = PreviewSampleData.sampleCats,
                selectedCatId = "1",
                note = "Bugün yine güneş alan köşeyi bulup orada uyudu.",
                catMood = "Uykulu",
                userMood = "Huzurlu"
            ),
            onBack = {},
            onSelectCat = {},
            onPickPhotoClick = {},
            onRemovePhotoClick = {},
            onNoteChanged = {},
            onCatMoodSelected = {},
            onUserMoodSelected = {},
            onDateSelected = {},
            onSaveClick = {},
            onNavigateToAddCat = {}
        )
    }
}

@Preview(name = "Add Memory Screen - No Cats", showBackground = true)
@Composable
private fun AddMemoryScreenNoCatsPreview() {
    MeowoirsTheme {
        AddMemoryContent(
            uiState = AddMemoryUiState(
                availableCats = emptyList(),
                selectedCatId = null
            ),
            onBack = {},
            onSelectCat = {},
            onPickPhotoClick = {},
            onRemovePhotoClick = {},
            onNoteChanged = {},
            onCatMoodSelected = {},
            onUserMoodSelected = {},
            onDateSelected = {},
            onSaveClick = {},
            onNavigateToAddCat = {}
        )
    }
}
