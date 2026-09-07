package com.limanex.meowoirs

import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.domain.story.StoryMetricsCalculator
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class StoryMetricsCalculatorTest {

    @Test
    fun testEmptyDataCalculation() {
        val metrics = StoryMetricsCalculator.calculate(emptyList(), emptyList())
        assertEquals(0, metrics.totalCats)
        assertEquals(0, metrics.totalMemories)
        assertEquals(0, metrics.homeCatsCount)
        assertEquals(0, metrics.streetCatsCount)
        assertNull(metrics.mostRememberedCat)
        assertEquals(0, metrics.mostRememberedCount)
        assertTrue(metrics.narrativeSummary.contains("zamanla kendi hikâyene"))
    }

    @Test
    fun testSingleCatWithMemories() {
        val cat = Cat(id = "c1", name = "Pamuk", type = CatType.HOME, photoUri = null)
        val mem = Memory(
            id = "m1",
            catId = "c1",
            catName = "Pamuk",
            note = "Uyudu",
            photoUri = null,
            catMood = "Uykulu",
            userMood = "Huzurlu",
            createdAt = 5000L
        )

        val metrics = StoryMetricsCalculator.calculate(listOf(cat), listOf(mem))
        assertEquals(1, metrics.totalCats)
        assertEquals(1, metrics.totalMemories)
        assertEquals(1, metrics.homeCatsCount)
        assertEquals(0, metrics.streetCatsCount)
        assertNotNull(metrics.mostRememberedCat)
        assertEquals("Pamuk", metrics.mostRememberedCat?.name)
        assertEquals(1, metrics.mostRememberedCount)
        assertTrue(metrics.narrativeSummary.contains("Pamuk ile birlikte 1 küçük an"))
    }

    @Test
    fun testMixedCatsWithMemories() {
        val homeCat = Cat(id = "c1", name = "Duman", type = CatType.HOME, photoUri = null)
        val streetCat = Cat(id = "c2", name = "Sarman", type = CatType.STREET, photoUri = null)
        val mem1 = Memory("m1", "c1", "Duman", "Evde", null, "Sakin", "Mutlu", 100L)
        val mem2 = Memory("m2", "c2", "Sarman", "Sokakta", null, "Meraklı", "Sevgi Dolu", 200L)
        val mem3 = Memory("m3", "c2", "Sarman", "Mamayı yedi", null, "Mutlu", "Şefkatli", 300L)

        val metrics = StoryMetricsCalculator.calculate(listOf(homeCat, streetCat), listOf(mem1, mem2, mem3))
        assertEquals(2, metrics.totalCats)
        assertEquals(3, metrics.totalMemories)
        assertEquals(1, metrics.homeCatsCount)
        assertEquals(1, metrics.streetCatsCount)
        assertEquals("Sarman", metrics.mostRememberedCat?.name)
        assertEquals(2, metrics.mostRememberedCount)
        assertEquals("m3", metrics.latestMemory?.id)
        assertEquals("m1", metrics.earliestMemory?.id)
    }
}
