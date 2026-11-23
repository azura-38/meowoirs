import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/database_provider.dart';
import '../../data/repositories/preferences_repository.dart';
import 'memories_state.dart';
import 'models/memories_view_mode.dart';

final selectedCatFilterIdProvider = StateProvider<String?>((ref) => null);

class MemoriesViewModeNotifier extends StateNotifier<MemoriesViewMode> {
  MemoriesViewModeNotifier(this._prefsRepo)
      : super(_prefsRepo.getMemoriesViewMode());

  final PreferencesRepository _prefsRepo;

  Future<void> setViewMode(MemoriesViewMode mode) async {
    state = mode;
    await _prefsRepo.updateMemoriesViewMode(mode);
  }
}

final memoriesViewModeProvider =
    StateNotifierProvider<MemoriesViewModeNotifier, MemoriesViewMode>((ref) {
  final prefsRepo = ref.watch(preferencesRepositoryProvider);
  return MemoriesViewModeNotifier(prefsRepo);
});

final memoriesUiStateProvider = Provider<MemoriesUiState>((ref) {
  final memoriesAsync = ref.watch(allMemoriesStreamProvider);
  final catsAsync = ref.watch(catsStreamProvider);
  final filterCatId = ref.watch(selectedCatFilterIdProvider);
  final viewMode = ref.watch(memoriesViewModeProvider);

  if (memoriesAsync.isLoading || catsAsync.isLoading) {
    return MemoriesUiState(isLoading: true, viewMode: viewMode);
  }

  if (memoriesAsync.hasError) {
    return MemoriesUiState(
      isLoading: false,
      errorMessage: memoriesAsync.error.toString(),
      allMemories: memoriesAsync.value ?? [],
      availableCats: catsAsync.value ?? [],
      selectedCatFilterId: filterCatId,
      viewMode: viewMode,
    );
  }

  if (catsAsync.hasError) {
    return MemoriesUiState(
      isLoading: false,
      errorMessage: catsAsync.error.toString(),
      allMemories: memoriesAsync.value ?? [],
      availableCats: const [],
      selectedCatFilterId: filterCatId,
      viewMode: viewMode,
    );
  }

  final memories = memoriesAsync.value ?? [];
  final cats = catsAsync.value ?? [];

  return MemoriesUiState(
    isLoading: false,
    allMemories: memories,
    availableCats: cats,
    selectedCatFilterId: filterCatId,
    viewMode: viewMode,
  );
});
