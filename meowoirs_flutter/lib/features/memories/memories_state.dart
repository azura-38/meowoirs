import 'package:collection/collection.dart';
import '../../data/models/cat.dart';
import '../../data/models/memory.dart';

class MemoriesUiState {
  const MemoriesUiState({
    this.isLoading = true,
    this.allMemories = const [],
    this.availableCats = const [],
    this.selectedCatFilterId,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Memory> allMemories;
  final List<Cat> availableCats;
  final String? selectedCatFilterId;
  final String? errorMessage;

  bool get isCompletelyEmpty => !isLoading && allMemories.isEmpty;

  List<Memory> get filteredMemories {
    if (selectedCatFilterId == null) {
      return allMemories;
    }
    return allMemories.where((m) => m.catId == selectedCatFilterId).toList();
  }

  bool get isFilterEmpty =>
      !isLoading && allMemories.isNotEmpty && filteredMemories.isEmpty;

  Cat? get selectedCat =>
      availableCats.firstWhereOrNull((c) => c.id == selectedCatFilterId);

  MemoriesUiState copyWith({
    bool? isLoading,
    List<Memory>? allMemories,
    List<Cat>? availableCats,
    String? selectedCatFilterId,
    String? errorMessage,
  }) {
    return MemoriesUiState(
      isLoading: isLoading ?? this.isLoading,
      allMemories: allMemories ?? this.allMemories,
      availableCats: availableCats ?? this.availableCats,
      selectedCatFilterId: selectedCatFilterId ?? this.selectedCatFilterId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
