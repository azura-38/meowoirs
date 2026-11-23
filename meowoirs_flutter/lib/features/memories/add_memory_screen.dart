import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../widgets/meowoirs_button.dart';
import 'add_memory_view_model.dart';
import 'widgets/dual_mood_selector.dart';

class AddMemoryScreen extends ConsumerStatefulWidget {
  final String? initialCatId;
  final String? memoryId;
  final VoidCallback onBack;
  final VoidCallback onNavigateToAddCat;
  final ImagePicker? imagePicker;

  const AddMemoryScreen({
    super.key,
    this.initialCatId,
    this.memoryId,
    required this.onBack,
    required this.onNavigateToAddCat,
    this.imagePicker,
  });

  @override
  ConsumerState<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends ConsumerState<AddMemoryScreen> {
  late final ImagePicker _imagePicker;
  late final TextEditingController _noteController;
  bool _isNoteInitialized = false;
  late final provider = addMemoryViewModelProvider((initialCatId: widget.initialCatId, memoryId: widget.memoryId));

  @override
  void initState() {
    super.initState();
    _imagePicker = widget.imagePicker ?? ImagePicker();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        ref.read(provider.notifier).onPhotoSelected(image.path);
      }
    } catch (_) {
      // Ignore picker errors (e.g. permission denied)
    }
  }

  Future<void> _selectDate(BuildContext context, int currentMillis) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(currentMillis),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)), // allow future? Kotlin V0.1 doesn't specify limit, standard is fine
      builder: (context, child) {
        final colors = context.meowoirsColors;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: colors.orange,
              onPrimary: colors.textPrimary, // or white, let's keep it safe
              surface: colors.cardBackground,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      ref.read(provider.notifier).onDateSelected(selectedDate.millisecondsSinceEpoch);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    if (!_isNoteInitialized && uiState.note.isNotEmpty) {
      _noteController.text = uiState.note;
      _isNoteInitialized = true;
    }

    ref.listen<AddMemoryUiState>(provider, (prev, next) {
      if (next.note != _noteController.text) {
        _noteController.text = next.note;
      }
      if (next.isSaved && !(prev?.isSaved ?? false)) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) widget.onBack();
        });
      }
    });

    return _AddMemoryContent(
      uiState: uiState,
      onBack: widget.onBack,
      onSelectCat: viewModel.selectCat,
      onPickPhotoClick: _pickPhoto,
      onRemovePhotoClick: () => viewModel.onPhotoSelected(null),
      noteController: _noteController,
      onNoteChanged: viewModel.onNoteChanged,
      onCatMoodSelected: viewModel.onCatMoodSelected,
      onUserMoodSelected: viewModel.onUserMoodSelected,
      onDateSelectClick: () => _selectDate(context, uiState.selectedDateMillis),
      onSaveClick: () => viewModel.saveMemory(() {}),
      onNavigateToAddCat: widget.onNavigateToAddCat,
    );
  }
}

class _AddMemoryContent extends StatelessWidget {
  final AddMemoryUiState uiState;
  final VoidCallback onBack;
  final ValueChanged<String> onSelectCat;
  final VoidCallback onPickPhotoClick;
  final VoidCallback onRemovePhotoClick;
  final TextEditingController noteController;
  final ValueChanged<String> onNoteChanged;
  final ValueChanged<String> onCatMoodSelected;
  final ValueChanged<String> onUserMoodSelected;
  final VoidCallback onDateSelectClick;
  final VoidCallback onSaveClick;
  final VoidCallback onNavigateToAddCat;

  const _AddMemoryContent({
    required this.uiState,
    required this.onBack,
    required this.onSelectCat,
    required this.onPickPhotoClick,
    required this.onRemovePhotoClick,
    required this.noteController,
    required this.onNoteChanged,
    required this.onCatMoodSelected,
    required this.onUserMoodSelected,
    required this.onDateSelectClick,
    required this.onSaveClick,
    required this.onNavigateToAddCat,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.meowoirsColors;
    final typography = Theme.of(context).textTheme;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final dateFormat = DateFormat("d MMMM yyyy", Localizations.localeOf(context).languageCode == 'tr' ? 'tr_TR' : 'en_US');
    final formattedDate = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(uiState.selectedDateMillis));

    return Scaffold(
      backgroundColor: colors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            spacing.large,
            spacing.medium,
            spacing.large,
            spacing.sectionLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Navigation Row
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    tooltip: l10n.actionBack,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
              SizedBox(height: spacing.small),

              // Editorial Header
              Text(
                uiState.isEditMode ? l10n.editMemoryTitle : l10n.addMemoryTitle,
                style: typography.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: spacing.extraSmall),
              Text(
                uiState.isEditMode ? l10n.editMemorySubtitle : l10n.addMemorySubtitle,
                style: typography.bodyLarge?.copyWith(color: colors.textSecondary),
              ),

              SizedBox(height: spacing.large),

              // Step 1: Cat Selection
              Text(
                l10n.memoryWhoWith,
                style: typography.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: spacing.small),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (uiState.availableCats.isEmpty)
                      _AddCatShortcut(onTap: onNavigateToAddCat)
                    else ...[
                      for (final cat in uiState.availableCats)
                        Padding(
                          padding: EdgeInsets.only(right: spacing.small),
                          child: _CatSelectionChip(
                            name: cat.name,
                            isSelected: uiState.selectedCatId == cat.id,
                            onTap: () => onSelectCat(cat.id),
                          ),
                        ),
                    ]
                  ],
                ),
              ),

              if (uiState.validationError == 'cat_required') ...[
                SizedBox(height: spacing.small),
                Text(
                  l10n.memoryCatRequired,
                  style: typography.bodySmall?.copyWith(color: colors.orange),
                ),
              ],

              SizedBox(height: spacing.large),

              // Step 2: Photo Area
              Text(
                l10n.memoryPhotoSectionTitle,
                style: typography.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: spacing.small),

              Semantics(
                button: true,
                label: uiState.photoUri != null ? l10n.selectedPhotoSemantic : l10n.addPhotoSemantic,
                child: GestureDetector(
                  onTap: onPickPhotoClick,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        borderRadius: shapes.largeRadius,
                        border: Border.all(color: colors.cardBorder),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: uiState.photoUri != null
                          ? Image.file(
                              File(uiState.photoUri!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _EmptyPhotoPlaceholder(),
                            )
                          : _EmptyPhotoPlaceholder(),
                    ),
                  ),
                ),
              ),

              if (uiState.photoUri != null) ...[
                SizedBox(height: spacing.small),
                Wrap(
                  spacing: spacing.medium,
                  children: [
                    TextButton(
                      onPressed: onPickPhotoClick,
                      child: Text(
                        l10n.changePhoto,
                        style: typography.labelMedium?.copyWith(color: colors.orange),
                      ),
                    ),
                    TextButton(
                      onPressed: onRemovePhotoClick,
                      child: Text(
                        l10n.removePhoto,
                        style: typography.labelMedium?.copyWith(color: colors.textTertiary),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: spacing.large),

              // Step 3: Note Field
              Text(
                l10n.memoryWhatHappened,
                style: typography.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: spacing.small),
              TextField(
                controller: noteController,
                onChanged: onNoteChanged,
                minLines: 4,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: l10n.memoryNoteHintLong,
                  hintStyle: typography.bodyMedium?.copyWith(color: colors.textTertiary),
                  filled: true,
                  fillColor: colors.cardBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.orange),
                  ),
                ),
                style: typography.bodyMedium?.copyWith(color: colors.textPrimary),
              ),

              SizedBox(height: spacing.large),

              // Step 4 & 5: Dual Mood
              DualMoodSelector(
                selectedCatMood: uiState.catMood,
                onSelectCatMood: onCatMoodSelected,
                selectedUserMood: uiState.userMood,
                onSelectUserMood: onUserMoodSelected,
              ),

              SizedBox(height: spacing.large),

              // Step 6: Date Picker
              Text(
                l10n.memoryWhenSection,
                style: typography.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: spacing.small),

              Semantics(
                button: true,
                label: l10n.addMemorySelectDate(formattedDate),
                child: Material(
                  color: colors.cardBackground,
                  shape: shapes.fullShape.copyWith(
                    side: BorderSide(color: colors.cardBorder),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onDateSelectClick,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.medium,
                        vertical: spacing.mediumSmall,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 20, color: colors.orange),
                          SizedBox(width: spacing.small),
                          Flexible(
                            child: Text(
                              formattedDate,
                              style: typography.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (uiState.saveError != null) ...[
                SizedBox(height: spacing.medium),
                Text(
                  l10n.memorySaveError,
                  style: typography.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: spacing.extraLarge),

              // Step 7: Save Button (Prominent 56dp primary CTA, full width, safe area respected)
              MeowoirsPrimaryButton(
                width: double.infinity,
                height: 56,
                text: uiState.isSaved 
                  ? l10n.memorySaved 
                  : uiState.isSaving 
                    ? l10n.loading 
                    : uiState.isEditMode 
                      ? l10n.actionSaveChanges 
                      : l10n.actionSave,
                leadingIcon: uiState.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : (uiState.isSaved ? const Icon(Icons.check, size: 20, color: Colors.white) : null),
                onPressed: (uiState.isSaving || uiState.isSaved || !uiState.hasCats) 
                  ? null 
                  : onSaveClick,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPhotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final typography = Theme.of(context).textTheme;
    final spacing = context.meowoirsSpacing;
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 36, color: colors.orange),
        SizedBox(height: spacing.extraSmall),
        Text(
          l10n.addPhoto,
          style: typography.labelMedium?.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _AddCatShortcut extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCatShortcut({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final typography = Theme.of(context).textTheme;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final l10n = AppLocalizations.of(context);

    return Material(
      color: colors.accentOrangeContainer,
      shape: shapes.fullShape.copyWith(
        side: BorderSide(color: colors.orange),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.mediumSmall, vertical: spacing.small),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16, color: colors.orange),
              SizedBox(width: spacing.extraSmall),
              Text(
                l10n.addMemoryCatEmptyAction,
                style: typography.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatSelectionChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _CatSelectionChip({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final typography = Theme.of(context).textTheme;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return Semantics(
      button: true,
      selected: isSelected,
      label: name,
      child: Material(
        color: isSelected ? colors.accentOrangeContainer : colors.cardBackground,
        shape: shapes.fullShape.copyWith(
          side: BorderSide(color: isSelected ? colors.orange : colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.mediumSmall, vertical: spacing.small),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.pets : Icons.pets_outlined, 
                  size: 16, 
                  color: isSelected ? colors.orange : colors.textSecondary
                ),
                SizedBox(width: spacing.extraSmall),
                Text(
                  name,
                  style: typography.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? colors.orange : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
