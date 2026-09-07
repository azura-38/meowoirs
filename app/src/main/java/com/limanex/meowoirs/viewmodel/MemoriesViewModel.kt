package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn

data class MemoriesUiState(
    val isLoading: Boolean = true,
    val allMemories: List<Memory> = emptyList(),
    val availableCats: List<Cat> = emptyList(),
    val selectedCatFilterId: String? = null,
    val errorMessage: String? = null
) {
    val filteredMemories: List<Memory>
        get() = if (selectedCatFilterId == null) {
            allMemories
        } else {
            allMemories.filter { it.catId == selectedCatFilterId }
        }

    val isCompletelyEmpty: Boolean
        get() = !isLoading && allMemories.isEmpty()

    val isFilterEmpty: Boolean
        get() = !isLoading && allMemories.isNotEmpty() && filteredMemories.isEmpty()

    val selectedCat: Cat?
        get() = availableCats.firstOrNull { it.id == selectedCatFilterId }
}

class MemoriesViewModel(
    private val repository: MeowoirsRepository
) : ViewModel() {

    private val _selectedFilterCatId = MutableStateFlow<String?>(null)
    private val _errorMessage = MutableStateFlow<String?>(null)

    val uiState: StateFlow<MemoriesUiState> = combine(
        repository.getAllMemories(),
        repository.getCats(),
        _selectedFilterCatId,
        _errorMessage
    ) { memories, cats, filterId, error ->
        MemoriesUiState(
            isLoading = false,
            allMemories = memories,
            availableCats = cats,
            selectedCatFilterId = filterId,
            errorMessage = error
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = MemoriesUiState(isLoading = true)
    )

    fun selectFilter(catId: String?) {
        _selectedFilterCatId.value = catId
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
                return MemoriesViewModel(repo) as T
            }
        }
    }
}
