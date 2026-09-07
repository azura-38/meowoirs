package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn

data class MyStoryUiState(
    val isLoading: Boolean = true,
    val cats: List<Cat> = emptyList(),
    val memories: List<Memory> = emptyList(),
    val totalCats: Int = 0,
    val homeCatsCount: Int = 0,
    val streetCatsCount: Int = 0,
    val totalMemories: Int = 0,
    val mostRememberedCat: Cat? = null,
    val mostRememberedCount: Int = 0,
    val latestMemory: Memory? = null,
    val earliestMemory: Memory? = null,
    val narrativeSummary: String = "",
    val errorMessage: String? = null
) {
    val isCompletelyEmpty: Boolean
        get() = !isLoading && cats.isEmpty() && memories.isEmpty()

    val hasCatsWithoutMemories: Boolean
        get() = !isLoading && cats.isNotEmpty() && memories.isEmpty()

    val hasContent: Boolean
        get() = !isLoading && (cats.isNotEmpty() || memories.isNotEmpty())
}

class MyStoryViewModel(
    private val repository: MeowoirsRepository
) : ViewModel() {

    val uiState: StateFlow<MyStoryUiState> = combine(
        repository.getCats(),
        repository.getAllMemories()
    ) { cats, memories ->
        val metrics = com.limanex.meowoirs.domain.story.StoryMetricsCalculator.calculate(cats, memories)

        MyStoryUiState(
            isLoading = false,
            cats = cats,
            memories = memories,
            totalCats = metrics.totalCats,
            homeCatsCount = metrics.homeCatsCount,
            streetCatsCount = metrics.streetCatsCount,
            totalMemories = metrics.totalMemories,
            mostRememberedCat = metrics.mostRememberedCat,
            mostRememberedCount = metrics.mostRememberedCount,
            latestMemory = metrics.latestMemory,
            earliestMemory = metrics.earliestMemory,
            narrativeSummary = metrics.narrativeSummary
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = MyStoryUiState(isLoading = true)
    )

    companion object {
        val Factory: ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return MyStoryViewModel(repo) as T
            }
        }
    }
}
