package com.limanex.meowoirs.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.limanex.meowoirs.domain.model.Memory

@Entity(tableName = "memories")
data class MemoryEntity(
    @PrimaryKey
    val id: String,
    val catId: String,
    val catName: String,
    val note: String,
    val photoUri: String? = null,
    val catMood: String? = null,
    val userMood: String? = null,
    val createdAt: Long = System.currentTimeMillis()
) {
    fun toDomain(): Memory = Memory(
        id = id,
        catId = catId,
        catName = catName,
        note = note,
        photoUri = photoUri,
        catMood = catMood,
        userMood = userMood,
        createdAt = createdAt
    )
}

fun Memory.toEntity(): MemoryEntity = MemoryEntity(
    id = id,
    catId = catId,
    catName = catName,
    note = note,
    photoUri = photoUri,
    catMood = catMood,
    userMood = userMood,
    createdAt = createdAt
)
