package com.limanex.meowoirs.domain.model

enum class CatType(val label: String) {
    HOME("Ev Kedisi"),
    STREET("Sokak Kedisi")
}

data class Cat(
    val id: String,
    val name: String,
    val type: CatType,
    val photoUri: String? = null,
    val note: String? = null,
    val createdAt: Long = System.currentTimeMillis()
)
