package com.limanex.meowoirs

import com.limanex.meowoirs.data.repository.InMemoryMeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test

/**
 * Unit tests verifying repository operations, data relationships, and filtering.
 */
class RepositoryTest {

    private lateinit var repository: InMemoryMeowoirsRepository

    @Before
    fun setUp() {
        repository = InMemoryMeowoirsRepository()
    }

    @Test
    fun testAddAndRetrieveCats() = runBlocking {
        val cat1 = Cat(id = "cat-1", name = "Minnoş", type = CatType.HOME, photoUri = null)
        val cat2 = Cat(id = "cat-2", name = "Tekir", type = CatType.STREET, photoUri = null)

        repository.addCat(cat1)
        repository.addCat(cat2)

        val cats = repository.getCats().first()
        assertEquals(2, cats.size)
        assertEquals("Minnoş", cats[0].name)
        assertEquals("Tekir", cats[1].name)

        val foundCat = repository.getCatById("cat-1").first()
        assertNotNull(foundCat)
        assertEquals("Minnoş", foundCat?.name)

        val notFound = repository.getCatById("nonexistent").first()
        assertNull(notFound)
    }

    @Test
    fun testAddAndRetrieveMemoriesForCat() = runBlocking {
        val cat = Cat(id = "cat-1", name = "Minnoş", type = CatType.HOME, photoUri = null)
        repository.addCat(cat)

        val mem1 = Memory(
            id = "mem-1",
            catId = "cat-1",
            catName = "Minnoş",
            photoUri = null,
            note = "İlk anı",
            catMood = "Mutlu",
            userMood = "Huzurlu",
            createdAt = 1000L
        )
        val mem2 = Memory(
            id = "mem-2",
            catId = "cat-1",
            catName = "Minnoş",
            photoUri = null,
            note = "İkinci anı",
            catMood = "Oyuncu",
            userMood = "Neşeli",
            createdAt = 2000L
        )

        repository.addMemory(mem1)
        repository.addMemory(mem2)

        val memories = repository.getMemoriesForCat("cat-1").first()
        assertEquals(2, memories.size)
        // Newest first
        assertEquals("İkinci anı", memories[0].note)
        assertEquals("İlk anı", memories[1].note)

        val count = repository.getMemoryCountForCat("cat-1").first()
        assertEquals(2, count)

        val allMemories = repository.getAllMemories().first()
        assertEquals(2, allMemories.size)
    }
}
