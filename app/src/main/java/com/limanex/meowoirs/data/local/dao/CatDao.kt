package com.limanex.meowoirs.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.limanex.meowoirs.data.local.entity.CatEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface CatDao {
    @Query("SELECT * FROM cats ORDER BY createdAt DESC")
    fun getCats(): Flow<List<CatEntity>>

    @Query("SELECT * FROM cats WHERE id = :catId LIMIT 1")
    fun getCatById(catId: String): Flow<CatEntity?>

    @Query("SELECT COUNT(*) FROM cats")
    fun getCatCount(): Flow<Int>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCat(cat: CatEntity)

    @Update
    suspend fun updateCat(cat: CatEntity)

    @Delete
    suspend fun deleteCat(cat: CatEntity)

    @Query("DELETE FROM cats WHERE id = :catId")
    suspend fun deleteCatById(catId: String)
}

