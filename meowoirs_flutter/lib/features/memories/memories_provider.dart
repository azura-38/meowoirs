import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/database_provider.dart';
import 'memories_state.dart';

final selectedCatFilterIdProvider = StateProvider<String?>((ref) => null);

final memoriesUiStateProvider = Provider<MemoriesUiState>((ref) {
  final memoriesAsync = ref.watch(allMemoriesStreamProvider);
  final catsAsync = ref.watch(catsStreamProvider);
  final filterCatId = ref.watch(selectedCatFilterIdProvider);

  if (memoriesAsync.isLoading || catsAsync.isLoading) {
    return const MemoriesUiState(isLoading: true);
  }

  if (memoriesAsync.hasError) {
    return MemoriesUiState(
      isLoading: false,
      errorMessage: memoriesAsync.error.toString(),
      allMemories: memoriesAsync.value ?? [],
      availableCats: catsAsync.value ?? [],
      selectedCatFilterId: filterCatId,
    );
  }

  if (catsAsync.hasError) {
    return MemoriesUiState(
      isLoading: false,
      errorMessage: catsAsync.error.toString(),
      allMemories: memoriesAsync.value ?? [],
      availableCats: const [],
      selectedCatFilterId: filterCatId,
    );
  }

  final memories = memoriesAsync.value ?? [];
  final cats = catsAsync.value ?? [];

  return MemoriesUiState(
    isLoading: false,
    allMemories: memories,
    availableCats: cats,
    selectedCatFilterId: filterCatId,
  );
});
