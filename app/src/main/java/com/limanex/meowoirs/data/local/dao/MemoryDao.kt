package com.limanex.meowoirs.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.limanex.meowoirs.data.local.entity.MemoryEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface MemoryDao {
    @Query("SELECT * FROM memories ORDER BY createdAt DESC LIMIT :limit")
    fun getRecentMemories(limit: Int): Flow<List<MemoryEntity>>

    @Query("SELECT * FROM memories ORDER BY createdAt DESC")
    fun getAllMemories(): Flow<List<MemoryEntity>>

    @Query("SELECT * FROM memories WHERE catId = :catId ORDER BY createdAt DESC")
    fun getMemoriesForCat(catId: String): Flow<List<MemoryEntity>>

    @Query("SELECT COUNT(*) FROM memories WHERE catId = :catId")
    fun getMemoryCountForCat(catId: String): Flow<Int>

    @Query("SELECT COUNT(*) FROM memories")
    fun getTotalMemoryCount(): Flow<Int>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertMemory(memory: MemoryEntity)

    @Update
    suspend fun updateMemory(memory: MemoryEntity)

    @Delete
    suspend fun deleteMemory(memory: MemoryEntity)

    @Query("SELECT * FROM memories WHERE id = :memoryId LIMIT 1")
    fun getMemoryById(memoryId: String): Flow<MemoryEntity?>

    @Query("DELETE FROM memories WHERE id = :memoryId")
    suspend fun deleteMemoryById(memoryId: String)

    @Query("UPDATE memories SET catName = :newCatName WHERE catId = :catId")
    suspend fun updateCatNameForMemories(catId: String, newCatName: String)
}

