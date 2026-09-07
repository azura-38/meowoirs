package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.data.repository.InMemoryMeowoirsRepository
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn

data class HomeUiState(
    val isLoading: Boolean = true,
    val cats: List<Cat> = emptyList(),
    val recentMemories: List<Memory> = emptyList(),
    val errorMessage: String? = null
) {
    val isCompletelyEmpty: Boolean
        get() = !isLoading && cats.isEmpty() && recentMemories.isEmpty()

    val hasCatsWithoutMemories: Boolean
        get() = !isLoading && cats.isNotEmpty() && recentMemories.isEmpty()

    val hasContent: Boolean
        get() = !isLoading && (recentMemories.isNotEmpty() || cats.isNotEmpty())
}

class HomeViewModel(
    private val repository: MeowoirsRepository = MeowoirsRepository.inMemory
) : ViewModel() {

    private val _errorMessage = MutableStateFlow<String?>(null)

    val uiState: StateFlow<HomeUiState> = combine(
        repository.getCats(),
        repository.getRecentMemories(10),
        _errorMessage
    ) { cats, memories, error ->
        HomeUiState(
            isLoading = false,
            cats = cats,
            recentMemories = memories,
            errorMessage = error
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = HomeUiState(isLoading = true)
    )

    companion object {
        val Factory: ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    com.limanex.meowoirs.MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return HomeViewModel(repo) as T
            }
        }
    }
}
