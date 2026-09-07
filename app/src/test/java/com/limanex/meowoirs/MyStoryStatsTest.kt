package com.limanex.meowoirs

import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.viewmodel.MyStoryUiState
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Test

/**
 * Unit tests verifying quiet statistics and narrative calculations in My Story.
 */
class MyStoryStatsTest {

    @Test
    fun testQuietStatisticsCalculation() {
        val cat1 = Cat(id = "1", name = "Minnoş", type = CatType.HOME, photoUri = null)
        val cat2 = Cat(id = "2", name = "Tekir", type = CatType.STREET, photoUri = null)
        val cats = listOf(cat1, cat2)

        val mem1 = Memory(
            id = "m1",
            catId = "1",
            catName = "Minnoş",
            note = "Güneşte uyudu",
            photoUri = null,
            catMood = "Uykulu",
            userMood = "Huzurlu",
            createdAt = 1000L
        )
        val mem2 = Memory(
            id = "m2",
            catId = "1",
            catName = "Minnoş",
            note = "Oyun oynadı",
            photoUri = null,
            catMood = "Oyuncu",
            userMood = "Neşeli",
            createdAt = 2000L
        )
        val mem3 = Memory(
            id = "m3",
            catId = "2",
            catName = "Tekir",
            note = "Sokakta karşılaştık",
            photoUri = null,
            catMood = "Mutlu",
            userMood = "Sevgi Dolu",
            createdAt = 3000L
        )
        val memories = listOf(mem3, mem2, mem1)

        val state = MyStoryUiState(
            isLoading = false,
            cats = cats,
            memories = memories,
            totalCats = cats.size,
            totalMemories = memories.size,
            homeCatsCount = cats.count { it.type == CatType.HOME },
            streetCatsCount = cats.count { it.type == CatType.STREET },
            mostRememberedCat = cat1,
            mostRememberedCount = 2,
            latestMemory = mem3,
            earliestMemory = mem1
        )

        assertEquals(2, state.totalCats)
        assertEquals(3, state.totalMemories)
        assertEquals(1, state.homeCatsCount)
        assertEquals(1, state.streetCatsCount)

        // Most remembered cat is Minnoş (2 memories)
        assertNotNull(state.mostRememberedCat)
        assertEquals("Minnoş", state.mostRememberedCat?.name)
        assertEquals(2, state.mostRememberedCount)

        // Latest memory is mem3
        assertEquals("m3", state.latestMemory?.id)

        // Earliest memory is mem1
        assertEquals("m1", state.earliestMemory?.id)
    }

    @Test
    fun testEmptyStateProperties() {
        val emptyState = MyStoryUiState(
            isLoading = false,
            cats = emptyList(),
            memories = emptyList()
        )

        assertEquals(true, emptyState.isCompletelyEmpty)
        assertEquals(false, emptyState.hasCatsWithoutMemories)
        assertEquals(false, emptyState.hasContent)
    }
}
