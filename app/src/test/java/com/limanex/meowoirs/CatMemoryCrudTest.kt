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
 * Unit tests verifying Cat and Memory CRUD operations:
 * - Cat editing updates attributes and synchronizes denormalized catName in memories.
 * - Cat deletion removes the cat profile while safely preserving existing journal memories.
 * - Memory editing updates content in place without duplicating records.
 * - Memory deletion removes the targeted record from collections and queries.
 */
class CatMemoryCrudTest {

    private lateinit var repository: InMemoryMeowoirsRepository

    @Before
    fun setUp() {
        repository = InMemoryMeowoirsRepository()
    }

    @Test
    fun testUpdateCat_updatesNameAndPreservesId() = runBlocking {
        val cat = Cat(id = "cat-1", name = "Minnoş", type = CatType.HOME, photoUri = null)
        repository.addCat(cat)

        val updatedCat = cat.copy(name = "Pamuk", photoUri = "content://cat/photo_new.jpg")
        repository.updateCat(updatedCat)

        val cats = repository.getCats().first()
        assertEquals(1, cats.size)
        assertEquals("Pamuk", cats[0].name)
        assertEquals("content://cat/photo_new.jpg", cats[0].photoUri)

        val fetched = repository.getCatById("cat-1").first()
        assertNotNull(fetched)
        assertEquals("Pamuk", fetched?.name)
    }

    @Test
    fun testUpdateCat_synchronizesCatNameInMemories() = runBlocking {
        val cat = Cat(id = "cat-1", name = "Minnoş", type = CatType.HOME, photoUri = null)
        repository.addCat(cat)

        val mem = Memory(
            id = "mem-1",
            catId = "cat-1",
            catName = "Minnoş",
            photoUri = null,
            note = "Güneşleniyor",
            catMood = "Uykulu",
            userMood = "Huzurlu",
            createdAt = 1000L
        )
        repository.addMemory(mem)

        // Update cat's name
        repository.updateCat(cat.copy(name = "Karamel"))

        val memories = repository.getMemoriesForCat("cat-1").first()
        assertEquals(1, memories.size)
        assertEquals("Karamel", memories[0].catName)

        val allMemories = repository.getAllMemories().first()
        assertEquals("Karamel", allMemories[0].catName)
    }

    @Test
    fun testDeleteCat_removesCatAndPreservesMemories() = runBlocking {
        val cat = Cat(id = "cat-1", name = "Tekir", type = CatType.STREET, photoUri = null)
        repository.addCat(cat)

        val mem = Memory(
            id = "mem-1",
            catId = "cat-1",
            catName = "Tekir",
            photoUri = null,
            note = "Sokakta karşılaştık",
            catMood = "Meraklı",
            userMood = "Neşeli",
            createdAt = 2000L
        )
        repository.addMemory(mem)

        // Delete the cat
        repository.deleteCat("cat-1")

        val cats = repository.getCats().first()
        assertEquals(0, cats.size)

        val fetchedCat = repository.getCatById("cat-1").first()
        assertNull(fetchedCat)

        // Journal memories are preserved safely
        val allMemories = repository.getAllMemories().first()
        assertEquals(1, allMemories.size)
        assertEquals("mem-1", allMemories[0].id)
        assertEquals("Tekir", allMemories[0].catName)
    }

    @Test
    fun testUpdateMemory_updatesFieldsAndPreservesId() = runBlocking {
        val mem = Memory(
            id = "mem-100",
            catId = "cat-1",
            catName = "Duman",
            photoUri = null,
            note = "Eski not",
            catMood = "Sakin",
            userMood = "Mutlu",
            createdAt = 5000L
        )
        repository.addMemory(mem)

        val updated = mem.copy(
            note = "Güncellenmiş yeni not",
            photoUri = "content://memory/pic.jpg",
            catMood = "Oyuncu"
        )
        repository.updateMemory(updated)

        val fetched = repository.getMemoryById("mem-100").first()
        assertNotNull(fetched)
        assertEquals("Güncellenmiş yeni not", fetched?.note)
        assertEquals("content://memory/pic.jpg", fetched?.photoUri)
        assertEquals("Oyuncu", fetched?.catMood)

        val all = repository.getAllMemories().first()
        assertEquals(1, all.size)
    }

    @Test
    fun testDeleteMemory_removesMemory() = runBlocking {
        val mem1 = Memory(
            id = "mem-1",
            catId = "cat-1",
            catName = "Duman",
            photoUri = null,
            note = "Anı 1",
            catMood = null,
            userMood = null,
            createdAt = 1000L
        )
        val mem2 = Memory(
            id = "mem-2",
            catId = "cat-1",
            catName = "Duman",
            photoUri = null,
            note = "Anı 2",
            catMood = null,
            userMood = null,
            createdAt = 2000L
        )
        repository.addMemory(mem1)
        repository.addMemory(mem2)

        assertEquals(2, repository.getAllMemories().first().size)

        // Delete mem1
        repository.deleteMemory("mem-1")

        val remaining = repository.getAllMemories().first()
        assertEquals(1, remaining.size)
        assertEquals("mem-2", remaining[0].id)

        val deletedFetch = repository.getMemoryById("mem-1").first()
        assertNull(deletedFetch)
    }
}
