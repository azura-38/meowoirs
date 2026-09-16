import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cat.dart';
import '../../data/providers/database_provider.dart';
import 'cats_state.dart';

final catFilterProvider = StateProvider<CatFilter>((ref) => CatFilter.all);

final catsUiStateProvider = Provider<CatsUiState>((ref) {
  final catsAsync = ref.watch(catsStreamProvider);
  final memoriesAsync = ref.watch(allMemoriesStreamProvider);
  final filter = ref.watch(catFilterProvider);

  if (catsAsync.hasError || memoriesAsync.hasError) {
    return CatsUiState(
      isLoading: false,
      errorMessage:
          catsAsync.error?.toString() ?? memoriesAsync.error?.toString(),
    );
  }

  if (catsAsync.isLoading || memoriesAsync.isLoading) {
    return const CatsUiState(isLoading: true);
  }

  final cats = catsAsync.value ?? [];
  final memories = memoriesAsync.value ?? [];

  final List<Cat> filtered;
  switch (filter) {
    case CatFilter.all:
      filtered = cats;
      break;
    case CatFilter.home:
      filtered = cats.where((c) => c.type == CatType.home).toList();
      break;
    case CatFilter.street:
      filtered = cats.where((c) => c.type == CatType.street).toList();
      break;
  }

  final memoryCounts = <String, int>{};
  for (final m in memories) {
    memoryCounts[m.catId] = (memoryCounts[m.catId] ?? 0) + 1;
  }

  return CatsUiState(
    isLoading: false,
    allCats: cats,
    filteredCats: filtered,
    selectedFilter: filter,
    memoryCounts: memoryCounts,
  );
});
