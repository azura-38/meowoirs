import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/cat.dart';
import '../../data/models/memory.dart';
import '../../data/providers/database_provider.dart';
import '../../data/repositories/meowoirs_repository.dart';

class AddMemoryUiState {
  final List<Cat> availableCats;
  final String? selectedCatId;
  final String? photoUri;
  final String note;
  final String? catMood;
  final String? userMood;
  final int selectedDateMillis;
  final bool isSaving;
  final String? validationError;
  final String? saveError;
  final bool isSaved;
  final bool isEditMode;

  AddMemoryUiState({
    this.availableCats = const [],
    this.selectedCatId,
    this.photoUri,
    this.note = '',
    this.catMood,
    this.userMood,
    required this.selectedDateMillis,
    this.isSaving = false,
    this.validationError,
    this.saveError,
    this.isSaved = false,
    this.isEditMode = false,
  });

  AddMemoryUiState copyWith({
    List<Cat>? availableCats,
    String? selectedCatId,
    String? photoUri,
    String? note,
    String? catMood,
    String? userMood,
    int? selectedDateMillis,
    bool? isSaving,
    String? validationError,
    String? saveError,
    bool? isSaved,
    bool? isEditMode,
  }) {
    return AddMemoryUiState(
      availableCats: availableCats ?? this.availableCats,
      selectedCatId: selectedCatId != null && selectedCatId.isEmpty ? null : (selectedCatId ?? this.selectedCatId),
      photoUri: photoUri != null && photoUri.isEmpty ? null : (photoUri ?? this.photoUri),
      note: note ?? this.note,
      catMood: catMood != null && catMood.isEmpty ? null : (catMood ?? this.catMood),
      userMood: userMood != null && userMood.isEmpty ? null : (userMood ?? this.userMood),
      selectedDateMillis: selectedDateMillis ?? this.selectedDateMillis,
      isSaving: isSaving ?? this.isSaving,
      validationError: validationError != null && validationError.isEmpty ? null : (validationError ?? this.validationError),
      saveError: saveError != null && saveError.isEmpty ? null : (saveError ?? this.saveError),
      isSaved: isSaved ?? this.isSaved,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  Cat? get selectedCat {
    if (selectedCatId == null) return null;
    try {
      return availableCats.firstWhere((c) => c.id == selectedCatId);
    } catch (_) {
      return null;
    }
  }

  bool get hasCats => availableCats.isNotEmpty;
}

class AddMemoryViewModel extends AutoDisposeFamilyNotifier<AddMemoryUiState, ({String? initialCatId, String? memoryId})> {
  late final String? initialCatId;
  late final String? memoryId;

  @override
  AddMemoryUiState build(({String? initialCatId, String? memoryId}) arg) {
    initialCatId = arg.initialCatId;
    memoryId = arg.memoryId;
    final defaultDate = DateTime.now().millisecondsSinceEpoch;
    
    // We start listening to the cats stream immediately
    _init();

    return AddMemoryUiState(
      selectedCatId: initialCatId,
      selectedDateMillis: defaultDate,
      isEditMode: memoryId != null,
    );
  }

  void _init() {
    final repo = ref.read(repositoryProvider);
    
    ref.listen(repositoryProvider, (previous, repoNext) {
      // no-op to just bind the repo if needed, but we can listen to the stream manually
    });
    
    // Better way in riverpod to listen to stream directly inside notifier:
    final subscription = repo.getCats().listen((cats) {
      String? resolvedCatId = state.selectedCatId;
      if (resolvedCatId != null && cats.any((c) => c.id == resolvedCatId)) {
        // Keep currently selected cat if still present in cats
      } else if (state.isEditMode && state.selectedCatId != null && cats.any((c) => c.id == state.selectedCatId)) {
        // Keep loaded memory's cat if still present
      } else if (!state.isEditMode && (initialCatId == null || initialCatId!.isEmpty) && cats.length == 1) {
        // Only auto-select single cat when no initialCatId was explicitly specified
        resolvedCatId = cats.first.id;
      } else {
        // Invalid or deleted catId should not silently select another cat
        resolvedCatId = null;
      }
      
      state = state.copyWith(
        availableCats: cats,
        selectedCatId: resolvedCatId ?? '',
      );
    });
    
    ref.onDispose(() {
      subscription.cancel();
    });

    // If edit mode, load existing memory
    if (memoryId != null) {
      _loadExistingMemory(repo);
    }
  }

  void _loadExistingMemory(MeowoirsRepository repo) {
    final sub = repo.getMemoryById(memoryId!).listen((memory) {
      if (memory != null) {
        state = state.copyWith(
          selectedCatId: memory.catId,
          photoUri: memory.photoUri ?? '',
          note: memory.note,
          catMood: memory.catMood ?? '',
          userMood: memory.userMood ?? '',
          selectedDateMillis: memory.createdAt,
          isEditMode: true,
        );
      }
    });
    
    ref.onDispose(() {
      sub.cancel();
    });
  }

  void selectCat(String catId) {
    state = state.copyWith(selectedCatId: catId, validationError: '', saveError: '');
  }

  void onPhotoSelected(String? uriString) {
    state = state.copyWith(photoUri: uriString ?? '', saveError: '');
  }

  void onNoteChanged(String newNote) {
    state = state.copyWith(note: newNote, saveError: '');
  }

  void onCatMoodSelected(String mood) {
    state = state.copyWith(
      catMood: state.catMood == mood ? '' : mood,
      saveError: '',
    );
  }

  void onUserMoodSelected(String mood) {
    state = state.copyWith(
      userMood: state.userMood == mood ? '' : mood,
      saveError: '',
    );
  }

  void onDateSelected(int dateMillis) {
    state = state.copyWith(selectedDateMillis: dateMillis, saveError: '');
  }

  void clearError() {
    state = state.copyWith(saveError: '', validationError: '');
  }

  Future<void> saveMemory(VoidCallback onSuccess) async {
    if (state.isSaving || state.isSaved) return;

    final cat = state.selectedCat;
    if (cat == null) {
      state = state.copyWith(validationError: "cat_required");
      return;
    }

    state = state.copyWith(isSaving: true, saveError: '');

    try {
      final repo = ref.read(repositoryProvider);
      
      final memory = Memory(
        id: memoryId ?? const Uuid().v4(),
        catId: cat.id,
        catName: cat.name,
        note: state.note.trim(),
        photoUri: state.photoUri,
        catMood: state.catMood,
        userMood: state.userMood,
        createdAt: state.selectedDateMillis,
      );

      if (memoryId != null) {
        await repo.updateMemory(memory);
      } else {
        await repo.addMemory(memory);
      }

      state = state.copyWith(isSaving: false, isSaved: true);
      onSuccess();
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: "save_failed");
    }
  }
}

final addMemoryViewModelProvider = AutoDisposeNotifierProviderFamily<AddMemoryViewModel, AddMemoryUiState, ({String? initialCatId, String? memoryId})>( 
  AddMemoryViewModel.new,
);
