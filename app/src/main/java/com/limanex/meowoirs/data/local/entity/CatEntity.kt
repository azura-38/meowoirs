package com.limanex.meowoirs.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType

@Entity(tableName = "cats")
data class CatEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val type: String, // "HOME" or "STREET"
    val photoUri: String? = null,
    val note: String? = null,
    val createdAt: Long = System.currentTimeMillis()
) {
    fun toDomain(): Cat = Cat(
        id = id,
        name = name,
        type = if (type == "STREET") CatType.STREET else CatType.HOME,
        photoUri = photoUri,
        note = note,
        createdAt = createdAt
    )
}

fun Cat.toEntity(): CatEntity = CatEntity(
    id = id,
    name = name,
    type = type.name,
    photoUri = photoUri,
    note = note,
    createdAt = createdAt
)
