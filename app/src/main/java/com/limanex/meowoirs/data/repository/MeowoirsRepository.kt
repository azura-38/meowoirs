package com.limanex.meowoirs.data.repository

import android.content.Context
import com.limanex.meowoirs.data.local.MeowoirsDatabase
import com.limanex.meowoirs.data.local.dao.CatDao
import com.limanex.meowoirs.data.local.dao.MemoryDao
import com.limanex.meowoirs.data.local.entity.toEntity
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.update
import com.limanex.meowoirs.data.preferences.UserPreferencesRepository

/**
 * Repository interface for Meowoirs data operations.
 */
interface MeowoirsRepository {
    fun getCats(): Flow<List<Cat>>
    fun getRecentMemories(limit: Int = 10): Flow<List<Memory>>
    fun getAllMemories(): Flow<List<Memory>>
    fun getCatById(catId: String): Flow<Cat?>
    fun getMemoriesForCat(catId: String): Flow<List<Memory>>
    fun getMemoryCountForCat(catId: String): Flow<Int>
    suspend fun addCat(cat: Cat)
    suspend fun updateCat(cat: Cat)
    suspend fun deleteCat(catId: String)
    fun getMemoryById(memoryId: String): Flow<Memory?>
    suspend fun addMemory(memory: Memory)
    suspend fun updateMemory(memory: Memory)
    suspend fun deleteMemory(memoryId: String)

    companion object {
        @Volatile
        private var instance: MeowoirsRepository? = null

        fun getInstance(context: Context): MeowoirsRepository {
            return instance ?: synchronized(this) {
                val db = MeowoirsDatabase.getInstance(context)
                val prefs = UserPreferencesRepository.getInstance(context)
                val repo = RoomMeowoirsRepository(db.catDao(), db.memoryDao(), prefs)
                instance = repo
                repo
            }
        }

        // Fallback in-memory singleton for standalone unit tests or previews
        val inMemory: MeowoirsRepository by lazy { InMemoryMeowoirsRepository() }
    }
}

/**
 * Room-backed persistence repository implementation.
 * Cats and memories persist across application restarts.
 */
class RoomMeowoirsRepository(
    private val catDao: CatDao,
    private val memoryDao: MemoryDao,
    private val preferencesRepository: UserPreferencesRepository? = null
) : MeowoirsRepository {

    override fun getCats(): Flow<List<Cat>> {
        return catDao.getCats().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override fun getRecentMemories(limit: Int): Flow<List<Memory>> {
        return memoryDao.getRecentMemories(limit).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override fun getAllMemories(): Flow<List<Memory>> {
        return memoryDao.getAllMemories().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override fun getCatById(catId: String): Flow<Cat?> {
        return catDao.getCatById(catId).map { it?.toDomain() }
    }

    override fun getMemoriesForCat(catId: String): Flow<List<Memory>> {
        return memoryDao.getMemoriesForCat(catId).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override fun getMemoryCountForCat(catId: String): Flow<Int> {
        return memoryDao.getMemoryCountForCat(catId)
    }

    override suspend fun addCat(cat: Cat) {
        catDao.insertCat(cat.toEntity())
    }

    override suspend fun updateCat(cat: Cat) {
        catDao.updateCat(cat.toEntity())
        memoryDao.updateCatNameForMemories(cat.id, cat.name)
    }

    override suspend fun deleteCat(catId: String) {
        catDao.deleteCatById(catId)
        preferencesRepository?.clearFavoriteCatIfMatches(catId)
    }

    override fun getMemoryById(memoryId: String): Flow<Memory?> {
        return memoryDao.getMemoryById(memoryId).map { it?.toDomain() }
    }

    override suspend fun addMemory(memory: Memory) {
        memoryDao.insertMemory(memory.toEntity())
    }

    override suspend fun updateMemory(memory: Memory) {
        memoryDao.updateMemory(memory.toEntity())
    }

    override suspend fun deleteMemory(memoryId: String) {
        memoryDao.deleteMemoryById(memoryId)
    }
}

/**
 * In-Memory repository fallback for testing.
 */
class InMemoryMeowoirsRepository : MeowoirsRepository {
    private val _cats = MutableStateFlow<List<Cat>>(emptyList())
    private val _memories = MutableStateFlow<List<Memory>>(emptyList())

    override fun getCats(): Flow<List<Cat>> = _cats.asStateFlow()

    override fun getRecentMemories(limit: Int): Flow<List<Memory>> {
        return _memories.map { list ->
            list.sortedByDescending { it.createdAt }.take(limit)
        }
    }

    override fun getAllMemories(): Flow<List<Memory>> {
        return _memories.map { list ->
            list.sortedByDescending { it.createdAt }
        }
    }

    override fun getCatById(catId: String): Flow<Cat?> {
        return _cats.map { list ->
            list.firstOrNull { it.id == catId }
        }
    }

    override fun getMemoriesForCat(catId: String): Flow<List<Memory>> {
        return _memories.map { list ->
            list.filter { it.catId == catId }.sortedByDescending { it.createdAt }
        }
    }

    override fun getMemoryCountForCat(catId: String): Flow<Int> {
        return _memories.map { list ->
            list.count { it.catId == catId }
        }
    }

    override suspend fun addCat(cat: Cat) {
        _cats.update { it + cat }
    }

    override suspend fun updateCat(cat: Cat) {
        _cats.update { list ->
            list.map { if (it.id == cat.id) cat else it }
        }
        _memories.update { list ->
            list.map { if (it.catId == cat.id) it.copy(catName = cat.name) else it }
        }
    }

    override suspend fun deleteCat(catId: String) {
        _cats.update { list ->
            list.filter { it.id != catId }
        }
    }

    override fun getMemoryById(memoryId: String): Flow<Memory?> {
        return _memories.map { list ->
            list.firstOrNull { it.id == memoryId }
        }
    }

    override suspend fun addMemory(memory: Memory) {
        _memories.update { it + memory }
    }

    override suspend fun updateMemory(memory: Memory) {
        _memories.update { list ->
            list.map { if (it.id == memory.id) memory else it }
        }
    }

    override suspend fun deleteMemory(memoryId: String) {
        _memories.update { list ->
            list.filter { it.id != memoryId }
        }
    }
}

/**
 * Realistic Turkish sample data specifically for Compose Previews & UI tests.
 */
object PreviewSampleData {
    val sampleCats = listOf(
        Cat(
            id = "1",
            name = "Minnoş",
            type = CatType.HOME,
            photoUri = null,
            createdAt = System.currentTimeMillis() - 10000000
        ),
        Cat(
            id = "2",
            name = "Tekir",
            type = CatType.STREET,
            photoUri = null,
            createdAt = System.currentTimeMillis() - 5000000
        ),
        Cat(
            id = "3",
            name = "Duman",
            type = CatType.HOME,
            photoUri = null,
            createdAt = System.currentTimeMillis() - 2000000
        )
    )

    val sampleMemories = listOf(
        Memory(
            id = "m1",
            catId = "1",
            catName = "Minnoş",
            note = "Bugün yine güneş alan köşeyi bulup orada uyudu.",
            photoUri = null,
            catMood = "Uykulu",
            userMood = "Huzurlu",
            createdAt = System.currentTimeMillis() - 3600000
        ),
        Memory(
            id = "m2",
            catId = "2",
            catName = "Tekir",
            note = "Mahallenin köşesinde beni görünce yine yanıma geldi.",
            photoUri = null,
            catMood = "Sevecen",
            userMood = "Mutlu",
            createdAt = System.currentTimeMillis() - 86400000
        ),
        Memory(
            id = "m3",
            catId = "1",
            catName = "Minnoş",
            note = "Pencerenin önündeki kuşları seyrederken kuyruğunu sallıyordu.",
            photoUri = null,
            catMood = "Oyuncu",
            userMood = "Mutlu",
            createdAt = System.currentTimeMillis() - 172800000
        )
    )
}
