package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.model.CatType
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.util.UUID

data class AddCatUiState(
    val name: String = "",
    val type: CatType = CatType.HOME,
    val photoUri: String? = null,
    val nameError: String? = null,
    val saveError: String? = null,
    val isSaving: Boolean = false,
    val isSaved: Boolean = false,
    val isEditMode: Boolean = false,
    val existingCreatedAt: Long? = null,
    val existingNote: String? = null
)

class AddCatViewModel(
    private val catId: String?,
    private val repository: MeowoirsRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(AddCatUiState(isEditMode = !catId.isNullOrBlank()))
    val uiState: StateFlow<AddCatUiState> = _uiState.asStateFlow()

    init {
        if (!catId.isNullOrBlank()) {
            viewModelScope.launch {
                repository.getCatById(catId).firstOrNull()?.let { existingCat ->
                    _uiState.update { current ->
                        current.copy(
                            name = existingCat.name,
                            type = existingCat.type,
                            photoUri = existingCat.photoUri,
                            existingCreatedAt = existingCat.createdAt,
                            existingNote = existingCat.note,
                            isEditMode = true
                        )
                    }
                }
            }
        }
    }

    fun onNameChanged(newName: String) {
        _uiState.update {
            it.copy(
                name = newName,
                nameError = if (newName.isNotBlank()) null else it.nameError,
                saveError = null
            )
        }
    }

    fun onTypeChanged(newType: CatType) {
        _uiState.update { it.copy(type = newType, saveError = null) }
    }

    fun onPhotoSelected(uriString: String?) {
        _uiState.update { it.copy(photoUri = uriString, saveError = null) }
    }

    fun clearError() {
        _uiState.update { it.copy(saveError = null, nameError = null) }
    }

    fun saveCat(onSuccess: () -> Unit) {
        val state = _uiState.value
        if (state.isSaving || state.isSaved) return
        val currentName = state.name.trim()
        if (currentName.isEmpty()) {
            _uiState.update {
                it.copy(nameError = "name_required")
            }
            return
        }

        viewModelScope.launch {
            _uiState.update { it.copy(isSaving = true, saveError = null) }
            try {
                if (state.isEditMode && !catId.isNullOrBlank()) {
                    val updatedCat = Cat(
                        id = catId,
                        name = currentName,
                        type = state.type,
                        photoUri = state.photoUri,
                        note = state.existingNote,
                        createdAt = state.existingCreatedAt ?: System.currentTimeMillis()
                    )
                    repository.updateCat(updatedCat)
                } else {
                    val newCat = Cat(
                        id = UUID.randomUUID().toString(),
                        name = currentName,
                        type = state.type,
                        photoUri = state.photoUri,
                        createdAt = System.currentTimeMillis()
                    )
                    repository.addCat(newCat)
                }
                _uiState.update { it.copy(isSaving = false, isSaved = true) }
                onSuccess()
            } catch (e: Exception) {
                _uiState.update { it.copy(isSaving = false, saveError = "save_failed") }
            }
        }
    }

    companion object {
        fun provideFactory(catId: String? = null): ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                val repo = try {
                    MeowoirsApplication.instance.repository
                } catch (e: Exception) {
                    MeowoirsRepository.inMemory
                }
                return AddCatViewModel(catId, repo) as T
            }
        }
    }
}
