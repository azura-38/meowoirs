package com.limanex.meowoirs

import com.limanex.meowoirs.data.repository.InMemoryMeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import com.limanex.meowoirs.viewmodel.AddCatUiState
import com.limanex.meowoirs.viewmodel.AddMemoryUiState
import com.limanex.meowoirs.viewmodel.CatDetailUiState
import com.limanex.meowoirs.viewmodel.MemoryDetailUiState
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

/**
 * Reliability & Interaction Audit unit tests:
 * - Valid & invalid/deleted ID handling
 * - UI State flags for loading, error, and notFound states
 * - Input validation & duplicate protection state rules
 * - Reactive flow observation & consistency across CRUD operations
 */
class ReliabilityAuditTest {

    private lateinit var repository: InMemoryMeowoirsRepository

    @Before
    fun setUp() {
        repository = InMemoryMeowoirsRepository()
    }

    @Test
    fun testMemoryDetailUiState_notFoundState() {
        val notFoundState = MemoryDetailUiState(
            isLoading = false,
            memory = null,
            isNotFound = true,
            errorMessage = null
        )
        assertFalse(notFoundState.isLoading)
        assertTrue(notFoundState.isNotFound)
        assertNull(notFoundState.memory)
    }

    @Test
    fun testCatDetailUiState_notFoundState() {
        val notFoundState = CatDetailUiState(
            isLoading = false,
            cat = null,
            memories = emptyList(),
            isNotFound = true,
            errorMessage = null
        )
        assertFalse(notFoundState.isLoading)
        assertTrue(notFoundState.isNotFound)
        assertNull(notFoundState.cat)
    }

    @Test
    fun testAddCatUiState_validationAndSavingFlags() {
        val defaultState = AddCatUiState()
        assertFalse(defaultState.isSaving)
        assertFalse(defaultState.isSaved)
        assertNull(defaultState.nameError)
        assertNull(defaultState.saveError)

        val savingState = defaultState.copy(isSaving = true)
        assertTrue(savingState.isSaving)

        val errorState = defaultState.copy(isSaving = false, saveError = "save_failed")
        assertFalse(errorState.isSaving)
        assertEquals("save_failed", errorState.saveError)
    }

    @Test
    fun testAddMemoryUiState_hasCatsAndSelection() {
        val noCatsState = AddMemoryUiState(availableCats = emptyList())
        assertFalse(noCatsState.hasCats)
        assertNull(noCatsState.selectedCat)

        val cat = Cat(id = "cat-1", name = "Minnoş", type = CatType.HOME, photoUri = null)
        val withCatState = AddMemoryUiState(
            availableCats = listOf(cat),
            selectedCatId = "cat-1"
        )
        assertTrue(withCatState.hasCats)
        assertNotNull(withCatState.selectedCat)
        assertEquals("Minnoş", withCatState.selectedCat?.name)
    }

    @Test
    fun testRepository_getMemoryById_returnsNullForInvalidOrDeletedId() = runBlocking {
        val result = repository.getMemoryById("non-existent-memory-id").first()
        assertNull(result)
    }

    @Test
    fun testRepository_getCatById_returnsNullForInvalidOrDeletedId() = runBlocking {
        val result = repository.getCatById("non-existent-cat-id").first()
        assertNull(result)
    }

    @Test
    fun testRepository_reactiveObservation_reflectsUpdatesImmediately() = runBlocking {
        val cat = Cat(id = "cat-1", name = "Pusat", type = CatType.HOME, photoUri = null)
        repository.addCat(cat)

        val initial = repository.getCatById("cat-1").first()
        assertEquals("Pusat", initial?.name)

        repository.updateCat(cat.copy(name = "Pusat the Great"))
        val updated = repository.getCatById("cat-1").first()
        assertEquals("Pusat the Great", updated?.name)
    }

    @Test
    fun testRepository_deleteMemory_removesRecordAndEmitsNull() = runBlocking {
        val mem = Memory(
            id = "mem-1",
            catId = "cat-1",
            catName = "Minnoş",
            photoUri = null,
            note = "Hatıra",
            catMood = null,
            userMood = null,
            createdAt = 1000L
        )
        repository.addMemory(mem)

        val before = repository.getMemoryById("mem-1").first()
        assertNotNull(before)

        repository.deleteMemory("mem-1")
        val after = repository.getMemoryById("mem-1").first()
        assertNull(after)
    }

    @Test
    fun testRepository_deleteCat_preservesMemoriesSafely() = runBlocking {
        val cat = Cat(id = "cat-safe", name = "Maviş", type = CatType.HOME, photoUri = null)
        repository.addCat(cat)

        val mem = Memory(
            id = "mem-safe",
            catId = "cat-safe",
            catName = "Maviş",
            photoUri = null,
            note = "Hatıralar kalıcıdır",
            catMood = "Huzurlu",
            userMood = "Mutlu",
            createdAt = 5000L
        )
        repository.addMemory(mem)

        repository.deleteCat("cat-safe")

        assertNull(repository.getCatById("cat-safe").first())

        val allMemories = repository.getAllMemories().first()
        assertEquals(1, allMemories.size)
        assertEquals("mem-safe", allMemories[0].id)
        assertEquals("Maviş", allMemories[0].catName)
    }

    @Test
    fun testRepository_updateCat_renamesMemoriesConsistently() = runBlocking {
        val cat = Cat(id = "cat-rename", name = "Zeytin", type = CatType.STREET, photoUri = null)
        repository.addCat(cat)

        val mem = Memory(
            id = "mem-rename",
            catId = "cat-rename",
            catName = "Zeytin",
            photoUri = null,
            note = "Sokakta oynadık",
            catMood = "Oyuncu",
            userMood = "Neşeli",
            createdAt = 6000L
        )
        repository.addMemory(mem)

        repository.updateCat(cat.copy(name = "Zeytin Bey"))

        val memories = repository.getMemoriesForCat("cat-rename").first()
        assertEquals("Zeytin Bey", memories[0].catName)

        val allMemories = repository.getAllMemories().first()
        assertEquals("Zeytin Bey", allMemories[0].catName)
    }
}
