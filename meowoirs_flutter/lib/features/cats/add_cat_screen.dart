import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/models/cat.dart';
import '../../data/providers/database_provider.dart';
import '../../widgets/meowoirs_button.dart';
import '../../widgets/meowoirs_card.dart';

/// Add or Edit Cat screen.
/// 100% behavioral and visual parity with Kotlin V0.1 AddCatScreen.kt.
class AddCatScreen extends ConsumerStatefulWidget {
  const AddCatScreen({
    super.key,
    this.catId,
    required this.onBack,
    this.imagePicker,
  });

  final String? catId;
  final VoidCallback onBack;
  final ImagePicker? imagePicker;

  @override
  ConsumerState<AddCatScreen> createState() => _AddCatScreenState();
}

class _AddCatScreenState extends ConsumerState<AddCatScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  late final ImagePicker _imagePicker;

  CatType _type = CatType.home;
  String? _photoUri;
  String? _nameError;
  String? _saveError;
  bool _isSaving = false;
  bool _isSaved = false;
  bool _isEditMode = false;
  int? _existingCreatedAt;
  bool _hasLoadedExisting = false;

  @override
  void initState() {
    super.initState();
    _imagePicker = widget.imagePicker ?? ImagePicker();
    _isEditMode = widget.catId != null && widget.catId!.isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final xfile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xfile != null && mounted) {
        setState(() {
          _photoUri = xfile.path;
          _saveError = null;
        });
      }
    } catch (_) {
      // Gracefully ignore picker cancellations or failures
    }
  }

  Future<void> _saveCat() async {
    if (_isSaving || _isSaved) return;

    final trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty) {
      setState(() {
        _nameError = AppLocalizations.of(context).catNameRequired;
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      final repo = ref.read(repositoryProvider);
      final rawNote = _noteController.text.trim();
      final note = rawNote.isEmpty ? null : rawNote;

      if (_isEditMode && widget.catId != null) {
        final updatedCat = Cat(
          id: widget.catId!,
          name: trimmedName,
          type: _type,
          photoUri: _photoUri,
          note: note,
          createdAt: _existingCreatedAt ?? DateTime.now().millisecondsSinceEpoch,
        );
        await repo.updateCat(updatedCat);
      } else {
        final newCat = Cat(
          id: const Uuid().v4(),
          name: trimmedName,
          type: _type,
          photoUri: _photoUri,
          note: note,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        await repo.addCat(newCat);
      }

      _isSaved = true;
      if (mounted) {
        widget.onBack();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _saveError = AppLocalizations.of(context).catSaveError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    // Edit mode: watch existing cat
    if (_isEditMode) {
      final catAsync = ref.watch(catByIdStreamProvider(widget.catId!));

      // Loading state
      if (catAsync.isLoading && !_hasLoadedExisting) {
        return Scaffold(
          backgroundColor: colors.cream,
          appBar: AppBar(
            backgroundColor: colors.cream,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              tooltip: l10n.actionBack,
              onPressed: widget.onBack,
            ),
          ),
          body: Center(
            child: CircularProgressIndicator(color: colors.orange),
          ),
        );
      }

      // Not found or deleted state
      if (catAsync.hasError || (!catAsync.isLoading && catAsync.value == null && !_hasLoadedExisting)) {
        return Scaffold(
          backgroundColor: colors.cream,
          appBar: AppBar(
            backgroundColor: colors.cream,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              tooltip: l10n.actionBack,
              onPressed: widget.onBack,
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: EdgeInsets.all(spacing.large),
                child: MeowoirsCard(
                  padding: EdgeInsets.all(spacing.large),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.catNotFoundTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.small),
                      Text(
                        l10n.catNotFoundDesc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.large),
                      MeowoirsSecondaryButton(
                        text: l10n.actionBack,
                        onPressed: widget.onBack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      // Populate form once when data resolves
      if (!_hasLoadedExisting && catAsync.value != null) {
        _hasLoadedExisting = true;
        final cat = catAsync.value!;
        _nameController.text = cat.name;
        _type = cat.type;
        _photoUri = cat.photoUri;
        _existingCreatedAt = cat.createdAt;
        if (cat.note != null) {
          _noteController.text = cat.note!;
        }
      }
    }

    return Scaffold(
      backgroundColor: colors.cream,
      appBar: AppBar(
        backgroundColor: colors.cream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          tooltip: l10n.actionBack,
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.all(spacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Editorial Header
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditMode ? l10n.editCatTitle : l10n.addCatTitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                    ),
                    SizedBox(height: spacing.extraSmall),
                    Text(
                      _isEditMode
                          ? l10n.editCatSubtitle
                          : l10n.addCatSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.large),

              // Photo Selector Area (130x130 Circular)
              Semantics(
                button: true,
                label: _photoUri != null && _photoUri!.isNotEmpty
                    ? l10n.selectedPhotoSemantic
                    : l10n.addPhotoSemantic,
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.cardBorder, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _photoUri != null && _photoUri!.isNotEmpty
                        ? _buildCatImage(context, _photoUri!)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 36,
                                color: colors.orange,
                              ),
                              SizedBox(height: spacing.extraSmall),
                              Text(
                                l10n.addPhoto,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              // Photo Action Buttons (Değiştir / Kaldır)
              if (_photoUri != null && _photoUri!.isNotEmpty) ...[
                SizedBox(height: spacing.small),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _pickPhoto,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      child: Text(
                        l10n.changePhoto,
                        style: TextStyle(
                          color: colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.medium),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _photoUri = null;
                        });
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      child: Text(
                        l10n.removePhoto,
                        style: TextStyle(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: spacing.extraLarge),

              // Name Input Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.catNameLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                ),
              ),
              SizedBox(height: spacing.small),
              TextField(
                controller: _nameController,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: l10n.catNameHint,
                  hintStyle: TextStyle(color: colors.textTertiary),
                  errorText: _nameError,
                  filled: true,
                  fillColor: colors.cardBackground,
                  contentPadding: EdgeInsets.all(spacing.medium),
                  border: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.orange, width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (_nameError != null && value.trim().isNotEmpty) {
                    setState(() {
                      _nameError = null;
                    });
                  }
                },
              ),

              SizedBox(height: spacing.medium),

              // Cat Type Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.catTypeLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                ),
              ),
              SizedBox(height: spacing.small),

              Row(
                children: [
                  Expanded(
                    child: _CatTypeOption(
                      title: l10n.catTypeHome,
                      subtitle: l10n.catTypeHomeDesc,
                      isSelected: _type == CatType.home,
                      accentColor: colors.orange,
                      accentContainerColor: colors.accentOrangeContainer,
                      icon: Icons.home_outlined,
                      onTap: () {
                        setState(() {
                          _type = CatType.home;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: spacing.medium),
                  Expanded(
                    child: _CatTypeOption(
                      title: l10n.catTypeStreet,
                      subtitle: l10n.catTypeStreetDesc,
                      isSelected: _type == CatType.street,
                      accentColor: colors.sage,
                      accentContainerColor: colors.accentSageContainer,
                      icon: Icons.pets_outlined,
                      onTap: () {
                        setState(() {
                          _type = CatType.street;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.medium),

              // Personal Note Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.catNoteLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                ),
              ),
              SizedBox(height: spacing.small),
              TextField(
                controller: _noteController,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: l10n.catNoteHint,
                  hintStyle: TextStyle(color: colors.textTertiary),
                  filled: true,
                  fillColor: colors.cardBackground,
                  contentPadding: EdgeInsets.all(spacing.medium),
                  border: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: shapes.mediumRadius,
                    borderSide: BorderSide(color: colors.orange, width: 2),
                  ),
                ),
              ),

              if (_saveError != null) ...[
                SizedBox(height: spacing.medium),
                Text(
                  _saveError!,
                  style: const TextStyle(color: Color(0xFFD32F2F)),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: spacing.sectionLarge),

              // Primary Save Button
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, _) {
                  final isBlank = value.text.trim().isEmpty;
                  final isEnabled = !_isSaving && !_isSaved && !isBlank;

                  return SizedBox(
                    width: double.infinity,
                    child: MeowoirsPrimaryButton(
                      text: _isSaving
                          ? l10n.loading
                          : _isEditMode
                              ? l10n.actionSaveChanges
                              : l10n.actionSave,
                      enabled: isEnabled,
                      onPressed: isEnabled ? _saveCat : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatImage(BuildContext context, String uri) {
    final colors = context.meowoirsColors;

    if (uri.startsWith('http://') || uri.startsWith('https://')) {
      return Image.network(
        uri,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackPhoto(colors),
      );
    }
    final file = File(uri);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackPhoto(colors),
      );
    }
    return _buildFallbackPhoto(colors);
  }

  Widget _buildFallbackPhoto(MeowoirsColors colors) {
    return Center(
      child: Icon(
        Icons.pets_outlined,
        size: 36,
        color: colors.orange,
      ),
    );
  }
}

class _CatTypeOption extends StatelessWidget {
  const _CatTypeOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.accentColor,
    required this.accentContainerColor,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final Color accentColor;
  final Color accentContainerColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final borderColor = isSelected ? accentColor : colors.cardBorder;
    final bgColor = isSelected
        ? accentContainerColor.withValues(alpha: 0.5)
        : colors.cardBackground;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title: $subtitle',
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: shapes.mediumRadius,
          side: BorderSide(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.mediumRadius,
          child: Padding(
            padding: EdgeInsets.all(spacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: 24, color: accentColor),
                    if (isSelected)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: spacing.small),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                ),
                SizedBox(height: spacing.xxSmall),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
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
