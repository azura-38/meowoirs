package com.limanex.meowoirs.domain.model

data class Memory(
    val id: String,
    val catId: String,
    val catName: String,
    val note: String,
    val photoUri: String? = null,
    val catMood: String? = null,
    val userMood: String? = null,
    val createdAt: Long = System.currentTimeMillis()
)
