package com.limanex.meowoirs.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.CreationExtras
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.data.preferences.UserPreferencesRepository
import com.limanex.meowoirs.data.preferences.UserProfile
import com.limanex.meowoirs.data.repository.MeowoirsRepository
import com.limanex.meowoirs.domain.model.Cat
import com.limanex.meowoirs.domain.story.StoryMetrics
import com.limanex.meowoirs.domain.story.StoryMetricsCalculator
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

data class ProfileUiState(
    val isLoading: Boolean = true,
    val nickname: String = "",
    val avatarId: String = "avatar_warm_cat",
    val favoriteCatId: String = "",
    val favoriteCat: Cat? = null,
    val allCats: List<Cat> = emptyList(),
    val storyMetrics: StoryMetrics = StoryMetrics()
)

class ProfileViewModel(
    private val preferencesRepository: UserPreferencesRepository,
    private val repository: MeowoirsRepository
) : ViewModel() {

    val uiState: StateFlow<ProfileUiState> = combine(
        preferencesRepository.userProfileFlow,
        repository.getCats(),
        repository.getAllMemories()
    ) { userProfile: UserProfile, cats, memories ->
        val metrics = StoryMetricsCalculator.calculate(cats, memories)
        val favCat = cats.firstOrNull { it.id == userProfile.favoriteCatId }

        ProfileUiState(
            isLoading = false,
            nickname = userProfile.nickname,
            avatarId = userProfile.avatarId,
            favoriteCatId = userProfile.favoriteCatId,
            favoriteCat = favCat,
            allCats = cats,
            storyMetrics = metrics
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = ProfileUiState(isLoading = true)
    )

    fun saveProfile(nickname: String, avatarId: String) {
        viewModelScope.launch {
            preferencesRepository.updateNickname(nickname)
            preferencesRepository.updateAvatarId(avatarId)
        }
    }

    fun setFavoriteCat(catId: String) {
        viewModelScope.launch {
            preferencesRepository.updateFavoriteCatId(catId)
        }
    }

    companion object {
        val Factory: ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>, extras: CreationExtras): T {
                val application = extras[ViewModelProvider.AndroidViewModelFactory.APPLICATION_KEY] as MeowoirsApplication
                val preferencesRepo = UserPreferencesRepository.getInstance(application)
                return ProfileViewModel(preferencesRepo, application.repository) as T
            }
        }
    }
}
