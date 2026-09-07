package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.Memory
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.util.UUID

data class AddMemoryUiState(
    val availableCats: List<Cat> = emptyList(),
    val selectedCatId: String? = null,
    val photoUri: String? = null,
    val note: String = "",
    val catMood: String? = null,
    val userMood: String? = null,
    val selectedDateMillis: Long = System.currentTimeMillis(),
    val isSaving: Boolean = false,
    val validationError: String? = null,
    val saveError: String? = null,
    val isSaved: Boolean = false,
    val isEditMode: Boolean = false
) {
    val selectedCat: Cat?
        get() = availableCats.firstOrNull { it.id == selectedCatId }

    val hasCats: Boolean
        get() = availableCats.isNotEmpty()
}

class AddMemoryViewModel(
    initialCatId: String?,
    private val memoryId: String? = null,
    private val repository: MeowoirsRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(
        AddMemoryUiState(selectedCatId = initialCatId)
    )
    val uiState: StateFlow<AddMemoryUiState> = _uiState.asStateFlow()

    init {
        if (memoryId != null) {
            viewModelScope.launch {
                val existing = repository.getMemoryById(memoryId).firstOrNull()
                if (existing != null) {
                    _uiState.update { current ->
                        current.copy(
                            selectedCatId = existing.catId,
                            photoUri = existing.photoUri,
                            note = existing.note,
                            catMood = existing.catMood,
                            userMood = existing.userMood,
                            selectedDateMillis = existing.createdAt,
                            isEditMode = true
                        )
                    }
                }
            }
        }

        viewModelScope.launch {
            repository.getCats().collect { cats ->
                _uiState.update { current ->
                    val resolvedCatId = when {
                        // Preselected or loaded memory cat ID exists in cats list
                        current.selectedCatId != null && cats.any { it.id == current.selectedCatId } -> current.selectedCatId
                        // In edit mode, keep selectedCatId
                        current.isEditMode && current.selectedCatId != null -> current.selectedCatId
                        // Exactly one cat available, auto-select it for low friction (only if not edit mode)
                        !current.isEditMode && cats.size == 1 -> cats.first().id
                        // Keep current if still valid or null
                        else -> current.selectedCatId
                    }
                    current.copy(
                        availableCats = cats,
                        selectedCatId = resolvedCatId
                    )
                }
            }
        }
    }

    fun selectCat(catId: String) {
        _uiState.update {
            it.copy(
                selectedCatId = catId,
                validationError = null,
                saveError = null
            )
        }
    }

    fun onPhotoSelected(uriString: String?) {
        _uiState.update { it.copy(photoUri = uriString, saveError = null) }
    }

    fun onNoteChanged(newNote: String) {
        _uiState.update { it.copy(note = newNote, saveError = null) }
    }

    fun onCatMoodSelected(mood: String) {
        _uiState.update {
            it.copy(catMood = if (it.catMood == mood) null else mood, saveError = null)
        }
    }

    fun onUserMoodSelected(mood: String) {
        _uiState.update {
            it.copy(userMood = if (it.userMood == mood) null else mood, saveError = null)
        }
    }

    fun onDateSelected(dateMillis: Long) {
        _uiState.update { it.copy(selectedDateMillis = dateMillis, saveError = null) }
    }

    fun clearError() {
        _uiState.update { it.copy(saveError = null, validationError = null) }
    }

    fun saveMemory(onSuccess: () -> Unit) {
        val state = _uiState.value
        if (state.isSaving || state.isSaved) return
        val cat = state.selectedCat

        if (cat == null) {
            _uiState.update { it.copy(validationError = "cat_required") }
            return
        }

        viewModelScope.launch {
            _uiState.update { it.copy(isSaving = true, saveError = null) }
            try {
                val memory = Memory(
                    id = memoryId ?: UUID.randomUUID().toString(),
                    catId = cat.id,
                    catName = cat.name,
                    note = state.note.trim(),
                    photoUri = state.photoUri,
                    catMood = state.catMood,
                    userMood = state.userMood,
                    createdAt = state.selectedDateMillis
                )
                if (memoryId != null) {
                    repository.updateMemory(memory)
                } else {
                    repository.addMemory(memory)
                }
                _uiState.update { it.copy(isSaving = false, isSaved = true) }
                onSuccess()
            } catch (e: Exception) {
                _uiState.update { it.copy(isSaving = false, saveError = "save_failed") }
            }
        }
    }

    companion object {
        fun provideFactory(
            initialCatId: String?,
            memoryId: String? = null
        ): ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return AddMemoryViewModel(initialCatId, memoryId, repo) as T
            }
        }
    }
}
