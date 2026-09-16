import '../../core/localization/app_localizations.dart';
import '../../data/models/cat.dart';
import '../../data/models/memory.dart';

/// Personal journal statistics and narrative summary.
class StoryMetrics {
  const StoryMetrics({
    this.totalCats = 0,
    this.homeCatsCount = 0,
    this.streetCatsCount = 0,
    this.totalMemories = 0,
    this.mostRememberedCat,
    this.mostRememberedCount = 0,
    this.latestMemory,
    this.earliestMemory,
    this.narrativeSummary = '',
  });

  final int totalCats;
  final int homeCatsCount;
  final int streetCatsCount;
  final int totalMemories;
  final Cat? mostRememberedCat;
  final int mostRememberedCount;
  final Memory? latestMemory;
  final Memory? earliestMemory;
  final String narrativeSummary;

  String getLocalizedNarrative(AppLocalizations l10n) {
    if (totalCats == 0 && totalMemories == 0) {
      return l10n.storyNarrativeEmpty;
    } else if (totalCats > 0 && totalMemories == 0) {
      return l10n.storyNarrativeCatsNoMemories;
    } else if (totalCats == 1 && mostRememberedCat != null) {
      return l10n.storyNarrativeSingleCat(mostRememberedCat!.name, totalMemories);
    } else if (streetCatsCount > 0 && homeCatsCount > 0) {
      return l10n.storyNarrativeHomeAndStreet(totalMemories, totalCats);
    } else {
      return l10n.storyNarrativeGeneral(totalMemories, totalCats);
    }
  }
}
