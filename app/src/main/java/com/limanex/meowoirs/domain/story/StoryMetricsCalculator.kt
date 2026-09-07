package com.limanex.meowoirs.domain.story

import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory

/**
 * Shared metrics model representing personal journal statistics and narrative summary.
 */
data class StoryMetrics(
    val totalCats: Int = 0,
    val homeCatsCount: Int = 0,
    val streetCatsCount: Int = 0,
    val totalMemories: Int = 0,
    val mostRememberedCat: Cat? = null,
    val mostRememberedCount: Int = 0,
    val latestMemory: Memory? = null,
    val earliestMemory: Memory? = null,
    val narrativeSummary: String = ""
)

/**
 * Pure calculation helper to eliminate duplicate logic between MyStory and Profile
 * without introducing ViewModel-to-ViewModel coupling.
 */
object StoryMetricsCalculator {

    fun calculate(cats: List<Cat>, memories: List<Memory>): StoryMetrics {
        val totalCats = cats.size
        val homeCats = cats.count { it.type == CatType.HOME }
        val streetCats = cats.count { it.type == CatType.STREET }
        val totalMemories = memories.size

        val latest = memories.maxByOrNull { it.createdAt }
        val earliest = memories.minByOrNull { it.createdAt }

        val memoryCountsByCat = memories.groupBy { it.catId }.mapValues { it.value.size }
        val topEntry = memoryCountsByCat.maxByOrNull { it.value }
        val topCat = cats.firstOrNull { it.id == topEntry?.key }
        val topCount = topEntry?.value ?: 0

        val narrative = when {
            cats.isEmpty() && memories.isEmpty() -> {
                "Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek."
            }
            cats.isNotEmpty() && memories.isEmpty() -> {
                "Kedilerin burada. Onlarla geçirdiğin ilk küçük anı sakla."
            }
            cats.size == 1 -> {
                "${cats.first().name} ile birlikte $totalMemories küçük an burada saklanıyor."
            }
            streetCats > 0 && homeCats > 0 -> {
                "$totalCats dostunla $totalMemories küçük an biriktirdin. Evdeki sıcak anlar ve sokakta karşılaştığın küçük hikâyeler bir arada."
            }
            else -> {
                "$totalCats kedinle $totalMemories küçük an biriktirdin. Zamanla biriken bu anlar senin Meowoirs hikâyeni oluşturuyor."
            }
        }

        return StoryMetrics(
            totalCats = totalCats,
            homeCatsCount = homeCats,
            streetCatsCount = streetCats,
            totalMemories = totalMemories,
            mostRememberedCat = topCat,
            mostRememberedCount = topCount,
            latestMemory = latest,
            earliestMemory = earliest,
            narrativeSummary = narrative
        )
    }
}
