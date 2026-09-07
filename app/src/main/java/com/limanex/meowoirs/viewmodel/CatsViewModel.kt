package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn

enum class CatFilter(val label: String) {
    ALL("Tümü"),
    HOME("Ev"),
    STREET("Sokak")
}

data class CatsUiState(
    val isLoading: Boolean = true,
    val allCats: List<Cat> = emptyList(),
    val filteredCats: List<Cat> = emptyList(),
    val selectedFilter: CatFilter = CatFilter.ALL,
    val memoryCounts: Map<String, Int> = emptyMap(),
    val errorMessage: String? = null
) {
    val isCompletelyEmpty: Boolean
        get() = !isLoading && allCats.isEmpty()

    val isFilterEmpty: Boolean
        get() = !isLoading && allCats.isNotEmpty() && filteredCats.isEmpty()

    val homeCount: Int
        get() = allCats.count { it.type == CatType.HOME }

    val streetCount: Int
        get() = allCats.count { it.type == CatType.STREET }

    val summaryText: String
        get() = when {
            allCats.isEmpty() -> ""
            homeCount > 0 && streetCount > 0 -> "$homeCount ev · $streetCount sokak"
            else -> "${allCats.size} kedi"
        }
}

class CatsViewModel(
    private val repository: MeowoirsRepository
) : ViewModel() {

    private val _selectedFilter = MutableStateFlow(CatFilter.ALL)
    private val _errorMessage = MutableStateFlow<String?>(null)

    val uiState: StateFlow<CatsUiState> = combine(
        repository.getCats(),
        repository.getAllMemories(),
        _selectedFilter,
        _errorMessage
    ) { cats, memories, filter, error ->
        val filtered = when (filter) {
            CatFilter.ALL -> cats
            CatFilter.HOME -> cats.filter { it.type == CatType.HOME }
            CatFilter.STREET -> cats.filter { it.type == CatType.STREET }
        }

        val counts = memories.groupingBy { it.catId }.eachCount()

        CatsUiState(
            isLoading = false,
            allCats = cats,
            filteredCats = filtered,
            selectedFilter = filter,
            memoryCounts = counts,
            errorMessage = error
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = CatsUiState(isLoading = true)
    )

    fun setFilter(filter: CatFilter) {
        _selectedFilter.value = filter
    }

    companion object {
        val Factory: ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return CatsViewModel(repo) as T
            }
        }
    }
}
