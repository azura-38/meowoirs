package com.limanex.meowoirs.ui.screens.cats

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
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.outlined.AddAPhoto
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Pets
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.res.stringResource
import com.limanex.meowoirs.R
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.ui.components.MeowoirsCard
import com.limanex.meowoirs.ui.components.MeowoirsPrimaryButton
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.AddCatUiState
import com.limanex.meowoirs.viewmodel.AddCatViewModel

@Composable
fun AddCatScreen(
    onBack: () -> Unit,
    catId: String? = null,
    modifier: Modifier = Modifier,
    viewModel: AddCatViewModel = viewModel(factory = AddCatViewModel.provideFactory(catId))
) {
    val uiState by viewModel.uiState.collectAsState()

    // Modern Photo Picker contract without broad permissions
    val photoPickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.PickVisualMedia()
    ) { uri: Uri? ->
        if (uri != null) {
            viewModel.onPhotoSelected(uri.toString())
        }
    }

    AddCatContent(
        uiState = uiState,
        onBack = onBack,
        onNameChanged = { viewModel.onNameChanged(it) },
        onTypeChanged = { viewModel.onTypeChanged(it) },
        onPickPhotoClick = {
            photoPickerLauncher.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
            )
        },
        onRemovePhotoClick = { viewModel.onPhotoSelected(null) },
        onSaveClick = {
            viewModel.saveCat(onSuccess = onBack)
        },
        modifier = modifier
    )
}

@Composable
fun AddCatContent(
    uiState: AddCatUiState,
    onBack: () -> Unit,
    onNameChanged: (String) -> Unit,
    onTypeChanged: (CatType) -> Unit,
    onPickPhotoClick: () -> Unit,
    onRemovePhotoClick: () -> Unit,
    onSaveClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val scrollState = rememberScrollState()

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(MeowoirsTheme.colors.cream)
            .imePadding()
            .verticalScroll(scrollState)
            .padding(MeowoirsTheme.spacing.large),
        horizontalAlignment = Alignment.CenterHorizontally
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
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = if (uiState.isEditMode) stringResource(R.string.edit_cat_title) else "Yeni Kedi",
                style = MeowoirsTheme.typography.displaySmall,
                fontWeight = FontWeight.Bold,
                color = MeowoirsTheme.colors.textPrimary
            )
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
            Text(
                text = if (uiState.isEditMode) stringResource(R.string.edit_cat_subtitle) else "Onun hikâyesi burada başlıyor.",
                style = MeowoirsTheme.typography.bodyLarge,
                color = MeowoirsTheme.colors.textSecondary
            )
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.large))

        // Photo Selector Area
        Box(
            modifier = Modifier
                .size(130.dp)
                .clip(CircleShape)
                .background(MeowoirsTheme.colors.cardBackground)
                .border(
                    BorderStroke(2.dp, MeowoirsTheme.colors.cardBorder),
                    CircleShape
                )
                .clickable(
                    onClick = onPickPhotoClick,
                    onClickLabel = "Fotoğraf ekle"
                )
                .semantics {
                    role = Role.Button
                    contentDescription = if (!uiState.photoUri.isNullOrBlank()) "Seçilen kedi fotoğrafı" else "Fotoğraf ekle"
                },
            contentAlignment = Alignment.Center
        ) {
            if (!uiState.photoUri.isNullOrBlank()) {
                coil.compose.SubcomposeAsyncImage(
                    model = uiState.photoUri,
                    contentDescription = stringResource(R.string.edit_cat_title),
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
                        contentDescription = null,
                        tint = MeowoirsTheme.colors.orange,
                        modifier = Modifier.size(36.dp)
                    )
                    Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraSmall))
                    Text(
                        text = "Fotoğraf ekle",
                        style = MeowoirsTheme.typography.labelSmall,
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

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.extraLarge))

        // Name Input Field
        Column(modifier = Modifier.fillMaxWidth()) {
            Text(
                text = "Kedinin Adı",
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))
            OutlinedTextField(
                value = uiState.name,
                onValueChange = onNameChanged,
                placeholder = {
                    Text(
                        text = "Örn. Minnoş",
                        style = MeowoirsTheme.typography.bodyMedium,
                        color = MeowoirsTheme.colors.textTertiary
                    )
                },
                isError = uiState.nameError != null,
                supportingText = {
                    if (uiState.nameError != null) {
                        Text(
                            text = stringResource(R.string.cat_name_required_error),
                            color = MeowoirsTheme.colors.orange,
                            style = MeowoirsTheme.typography.bodySmall
                        )
                    }
                },
                singleLine = true,
                shape = MeowoirsTheme.shapes.medium,
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = MeowoirsTheme.colors.orange,
                    unfocusedBorderColor = MeowoirsTheme.colors.cardBorder,
                    focusedContainerColor = MeowoirsTheme.colors.cardBackground,
                    unfocusedContainerColor = MeowoirsTheme.colors.cardBackground,
                    errorContainerColor = MeowoirsTheme.colors.cardBackground,
                    focusedTextColor = MeowoirsTheme.colors.textPrimary,
                    unfocusedTextColor = MeowoirsTheme.colors.textPrimary
                ),
                modifier = Modifier.fillMaxWidth()
            )
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))

        // Cat Type Selection
        Column(modifier = Modifier.fillMaxWidth()) {
            Text(
                text = "Kedi Türü",
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(MeowoirsTheme.spacing.medium)
            ) {
                CatTypeOption(
                    title = "Ev Kedisi",
                    subtitle = "Birlikte yaşadığın dostun",
                    isSelected = uiState.type == CatType.HOME,
                    accentColor = MeowoirsTheme.colors.orange,
                    accentContainerColor = MeowoirsTheme.colors.accentOrangeContainer,
                    icon = Icons.Outlined.Home,
                    onSelect = { onTypeChanged(CatType.HOME) },
                    modifier = Modifier.weight(1f)
                )

                CatTypeOption(
                    title = "Sokak Kedisi",
                    subtitle = "Sokakta karşılaştığın dostun",
                    isSelected = uiState.type == CatType.STREET,
                    accentColor = MeowoirsTheme.colors.sage,
                    accentContainerColor = MeowoirsTheme.colors.accentSageContainer,
                    icon = Icons.Outlined.Pets,
                    onSelect = { onTypeChanged(CatType.STREET) },
                    modifier = Modifier.weight(1f)
                )
            }
        }

        if (uiState.saveError != null) {
            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.medium))
            Text(
                text = stringResource(R.string.cat_save_error),
                color = Color(0xFFD32F2F),
                style = MeowoirsTheme.typography.bodyMedium,
                textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
        }

        Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.sectionLarge))

        // Primary Save Button
        MeowoirsPrimaryButton(
            text = when {
                uiState.isSaving -> stringResource(R.string.loading)
                uiState.isEditMode -> stringResource(R.string.action_save_changes)
                else -> stringResource(R.string.action_save)
            },
            onClick = onSaveClick,
            enabled = !uiState.isSaving && !uiState.isSaved && uiState.name.isNotBlank(),
            modifier = Modifier.fillMaxWidth()
        )
    }
}

@Composable
private fun CatTypeOption(
    title: String,
    subtitle: String,
    isSelected: Boolean,
    accentColor: Color,
    accentContainerColor: Color,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    onSelect: () -> Unit,
    modifier: Modifier = Modifier
) {
    val borderColor = if (isSelected) accentColor else MeowoirsTheme.colors.cardBorder
    val bgColor = if (isSelected) accentContainerColor.copy(alpha = 0.5f) else MeowoirsTheme.colors.cardBackground

    Surface(
        modifier = modifier
            .clip(MeowoirsTheme.shapes.medium)
            .clickable(onClick = onSelect)
            .semantics {
                role = Role.RadioButton
                selected = isSelected
            },
        shape = MeowoirsTheme.shapes.medium,
        color = bgColor,
        border = BorderStroke(if (isSelected) 2.dp else 1.dp, borderColor)
    ) {
        Column(
            modifier = Modifier.padding(MeowoirsTheme.spacing.medium),
            horizontalAlignment = Alignment.Start
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = accentColor,
                    modifier = Modifier.size(24.dp)
                )
                if (isSelected) {
                    Box(
                        modifier = Modifier
                            .size(20.dp)
                            .clip(CircleShape)
                            .background(accentColor),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Check,
                            contentDescription = "Seçildi",
                            tint = Color.White,
                            modifier = Modifier.size(14.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.small))

            Text(
                text = title,
                style = MeowoirsTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
                color = MeowoirsTheme.colors.textPrimary
            )

            Spacer(modifier = Modifier.height(MeowoirsTheme.spacing.xxSmall))

            Text(
                text = subtitle,
                style = MeowoirsTheme.typography.bodySmall,
                color = MeowoirsTheme.colors.textSecondary
            )
        }
    }
}

// ----------------------------------------------------
// Compose Preview
// ----------------------------------------------------

@Preview(name = "Add Cat Screen", showBackground = true)
@Composable
private fun AddCatScreenPreview() {
    MeowoirsTheme {
        AddCatContent(
            uiState = AddCatUiState(name = "Minnoş", type = CatType.HOME),
            onBack = {},
            onNameChanged = {},
            onTypeChanged = {},
            onPickPhotoClick = {},
            onRemovePhotoClick = {},
            onSaveClick = {}
        )
    }
}
