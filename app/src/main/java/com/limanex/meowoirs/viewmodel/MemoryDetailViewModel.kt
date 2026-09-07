package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

data class MemoryDetailUiState(
    val isLoading: Boolean = true,
    val memory: Memory? = null,
    val isNotFound: Boolean = false,
    val isDeleting: Boolean = false,
    val errorMessage: String? = null
)

class MemoryDetailViewModel(
    private val memoryId: String,
    private val repository: MeowoirsRepository
) : ViewModel() {

    private val _errorMessage = MutableStateFlow<String?>(null)
    private val _isDeleting = MutableStateFlow(false)

    val uiState: StateFlow<MemoryDetailUiState> = combine(
        repository.getMemoryById(memoryId),
        _isDeleting,
        _errorMessage
    ) { memory, isDeleting, error ->
        if (memory == null) {
            MemoryDetailUiState(
                isLoading = false,
                memory = null,
                isNotFound = true,
                isDeleting = isDeleting,
                errorMessage = error
            )
        } else {
            MemoryDetailUiState(
                isLoading = false,
                memory = memory,
                isNotFound = false,
                isDeleting = isDeleting,
                errorMessage = error
            )
        }
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = MemoryDetailUiState(isLoading = true)
    )

    fun clearErrorMessage() {
        _errorMessage.value = null
    }

    fun deleteMemory(onSuccess: () -> Unit) {
        if (_isDeleting.value) return
        viewModelScope.launch {
            _isDeleting.value = true
            _errorMessage.value = null
            try {
                repository.deleteMemory(memoryId)
                _isDeleting.value = false
                onSuccess()
            } catch (e: Exception) {
                _isDeleting.value = false
                _errorMessage.value = "memory_delete_error"
            }
        }
    }

    companion object {
        fun provideFactory(memoryId: String): ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return MemoryDetailViewModel(memoryId, repo) as T
            }
        }
    }
}
