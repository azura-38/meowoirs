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
import kotlinx.coroutines.launch

data class CatDetailUiState(
    val isLoading: Boolean = true,
    val cat: Cat? = null,
    val memories: List<Memory> = emptyList(),
    val isNotFound: Boolean = false,
    val isDeleting: Boolean = false,
    val errorMessage: String? = null
) {
    val storyTitle: String
        get() = cat?.let { getCatStoryTitle(it.name) } ?: "Kedinin Hikâyesi"

    val memoryCountText: String
        get() = when (memories.size) {
            0 -> "Bu hikâye ilk anısıyla başlayacak."
            1 -> "1 küçük anı burada."
            else -> "${memories.size} küçük anı burada."
        }
}

/**
 * Produces grammatically correct Turkish title suffixes:
 * e.g. "Minnoş'un Hikâyesi", "Tekir'in Hikâyesi", "Maya'nın Hikâyesi"
 */
fun getCatStoryTitle(catName: String): String {
    if (catName.isBlank()) return "Kedinin Hikâyesi"
    val trimmed = catName.trim()
    val vowels = "aeıioöuüAEIİOÖUÜ"
    val lastVowel = trimmed.reversed().firstOrNull { it in vowels }?.lowercaseChar() ?: 'i'
    val endsWithVowel = trimmed.last().lowercaseChar() in vowels

    val suffix = when (lastVowel) {
        'a', 'ı' -> if (endsWithVowel) "'nın" else "'ın"
        'e', 'i' -> if (endsWithVowel) "'nin" else "'in"
        'o', 'u' -> if (endsWithVowel) "'nun" else "'un"
        'ö', 'ü' -> if (endsWithVowel) "'nün" else "'ün"
        else -> "'in"
    }
    return "$trimmed$suffix Hikâyesi"
}

class CatDetailViewModel(
    private val catId: String,
    private val repository: MeowoirsRepository
) : ViewModel() {

    private val _errorMessage = MutableStateFlow<String?>(null)
    private val _isDeleting = MutableStateFlow(false)

    val uiState: StateFlow<CatDetailUiState> = combine(
        repository.getCatById(catId),
        repository.getMemoriesForCat(catId),
        _isDeleting,
        _errorMessage
    ) { cat, memories, isDeleting, error ->
        if (cat == null) {
            CatDetailUiState(
                isLoading = false,
                cat = null,
                memories = emptyList(),
                isNotFound = true,
                isDeleting = isDeleting,
                errorMessage = error
            )
        } else {
            CatDetailUiState(
                isLoading = false,
                cat = cat,
                memories = memories,
                isNotFound = false,
                isDeleting = isDeleting,
                errorMessage = error
            )
        }
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = CatDetailUiState(isLoading = true)
    )

    fun clearErrorMessage() {
        _errorMessage.value = null
    }

    fun deleteCat(onSuccess: () -> Unit) {
        if (_isDeleting.value) return
        viewModelScope.launch {
            _isDeleting.value = true
            _errorMessage.value = null
            try {
                repository.deleteCat(catId)
                _isDeleting.value = false
                onSuccess()
            } catch (e: Exception) {
                _isDeleting.value = false
                _errorMessage.value = "cat_delete_error"
            }
        }
    }

    companion object {
        fun provideFactory(catId: String): ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return CatDetailViewModel(catId, repo) as T
            }
        }
    }
}
