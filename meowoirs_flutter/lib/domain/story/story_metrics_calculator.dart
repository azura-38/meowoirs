import 'package:collection/collection.dart';
import '../../data/models/cat.dart';
import '../../data/models/memory.dart';
import 'story_metrics.dart';

/// Pure calculation helper for personal journal statistics.
class StoryMetricsCalculator {
  static StoryMetrics calculate(List<Cat> cats, List<Memory> memories) {
    final totalCats = cats.length;
    final homeCats = cats.where((c) => c.type == CatType.home).length;
    final streetCats = cats.where((c) => c.type == CatType.street).length;
    final totalMemories = memories.length;

    final latest = memories.isEmpty
        ? null
        : memories.reduce((a, b) => a.createdAt > b.createdAt ? a : b);

    final earliest = memories.isEmpty
        ? null
        : memories.reduce((a, b) => a.createdAt < b.createdAt ? a : b);

    // Group memories by catId
    final memoryCountsByCat = <String, int>{};
    for (final m in memories) {
      memoryCountsByCat[m.catId] = (memoryCountsByCat[m.catId] ?? 0) + 1;
    }

    MapEntry<String, int>? topEntry;
    for (final entry in memoryCountsByCat.entries) {
      if (topEntry == null || entry.value > topEntry.value) {
        topEntry = entry;
      }
    }

    final topCat = topEntry != null
        ? cats.firstWhereOrNull((c) => c.id == topEntry!.key)
        : null;
    final topCount = topEntry?.value ?? 0;

    final String narrative;
    if (cats.isEmpty && memories.isEmpty) {
      narrative =
          'Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.';
    } else if (cats.isNotEmpty && memories.isEmpty) {
      narrative = 'Kedilerin burada. Onlarla geçirdiğin ilk küçük anı sakla.';
    } else if (cats.length == 1) {
      narrative =
          '${cats.first.name} ile birlikte $totalMemories küçük an burada saklanıyor.';
    } else if (streetCats > 0 && homeCats > 0) {
      narrative =
          '$totalCats dostunla $totalMemories küçük an biriktirdin. Evdeki sıcak anlar ve sokakta karşılaştığın küçük hikâyeler bir arada.';
    } else {
      narrative =
          '$totalCats kedinle $totalMemories küçük an biriktirdin. Zamanla biriken bu anlar senin Meowoirs hikâyeni oluşturuyor.';
    }

    return StoryMetrics(
      totalCats: totalCats,
      homeCatsCount: homeCats,
      streetCatsCount: streetCats,
      totalMemories: totalMemories,
      mostRememberedCat: topCat,
      mostRememberedCount: topCount,
      latestMemory: latest,
      earliestMemory: earliest,
      narrativeSummary: narrative,
    );
  }
}
