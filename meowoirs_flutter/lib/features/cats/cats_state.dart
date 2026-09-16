import '../../core/localization/app_localizations.dart';
import '../../data/models/cat.dart';

enum CatFilter {
  all('Tümü'),
  home('Ev'),
  street('Sokak');

  const CatFilter(this.label);
  final String label;

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case CatFilter.all:
        return l10n.catsFilterAll;
      case CatFilter.home:
        return l10n.catsFilterHome;
      case CatFilter.street:
        return l10n.catsFilterStreet;
    }
  }
}

class CatsUiState {
  const CatsUiState({
    this.isLoading = true,
    this.allCats = const [],
    this.filteredCats = const [],
    this.selectedFilter = CatFilter.all,
    this.memoryCounts = const {},
    this.errorMessage,
  });

  final bool isLoading;
  final List<Cat> allCats;
  final List<Cat> filteredCats;
  final CatFilter selectedFilter;
  final Map<String, int> memoryCounts;
  final String? errorMessage;

  bool get isCompletelyEmpty => !isLoading && allCats.isEmpty;
  bool get isFilterEmpty => !isLoading && allCats.isNotEmpty && filteredCats.isEmpty;

  int get homeCount => allCats.where((c) => c.type == CatType.home).length;
  int get streetCount => allCats.where((c) => c.type == CatType.street).length;

  String get summaryText {
    if (allCats.isEmpty) return '';
    if (homeCount > 0 && streetCount > 0) {
      return '$homeCount ev · $streetCount sokak';
    }
    return '${allCats.length} kedi';
  }

  String formatSummaryText(AppLocalizations l10n) {
    if (allCats.isEmpty) return '';
    if (homeCount > 0 && streetCount > 0) {
      return l10n.catSummaryHomeAndStreet(homeCount, streetCount);
    }
    return l10n.catSummaryTotalOnly(allCats.length);
  }

  CatsUiState copyWith({
    bool? isLoading,
    List<Cat>? allCats,
    List<Cat>? filteredCats,
    CatFilter? selectedFilter,
    Map<String, int>? memoryCounts,
    String? errorMessage,
  }) {
    return CatsUiState(
      isLoading: isLoading ?? this.isLoading,
      allCats: allCats ?? this.allCats,
      filteredCats: filteredCats ?? this.filteredCats,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      memoryCounts: memoryCounts ?? this.memoryCounts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
