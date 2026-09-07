package com.limanex.meowoirs.data.preferences

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import java.io.IOException

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "meowoirs_user_preferences")

enum class ThemeMode {
    SYSTEM,
    LIGHT,
    DARK
}

data class UserProfile(
    val nickname: String = "",
    val avatarId: String = "avatar_warm_cat",
    val favoriteCatId: String = ""
)

class UserPreferencesRepository private constructor(private val context: Context) {

    private object PreferencesKeys {
        val NICKNAME = stringPreferencesKey("nickname")
        val AVATAR_ID = stringPreferencesKey("avatar_id")
        val FAVORITE_CAT_ID = stringPreferencesKey("favorite_cat_id")
        val THEME_MODE = stringPreferencesKey("theme_mode")
        val LANGUAGE_CODE = stringPreferencesKey("language_code")
        val ONBOARDING_COMPLETED = booleanPreferencesKey("onboarding_completed")
        val ACCEPTED_LEGAL_VERSION = stringPreferencesKey("accepted_legal_version")
    }

    val userProfileFlow: Flow<UserProfile> = context.dataStore.data
        .catch { exception ->
            if (exception is IOException) {
                emit(emptyPreferences())
            } else {
                throw exception
            }
        }
        .map { preferences ->
            UserProfile(
                nickname = preferences[PreferencesKeys.NICKNAME] ?: "",
                avatarId = preferences[PreferencesKeys.AVATAR_ID] ?: "avatar_warm_cat",
                favoriteCatId = preferences[PreferencesKeys.FAVORITE_CAT_ID] ?: ""
            )
        }

    val themeModeFlow: Flow<ThemeMode> = context.dataStore.data
        .catch { exception ->
            if (exception is IOException) {
                emit(emptyPreferences())
            } else {
                throw exception
            }
        }
        .map { preferences ->
            when (preferences[PreferencesKeys.THEME_MODE]) {
                ThemeMode.LIGHT.name -> ThemeMode.LIGHT
                ThemeMode.DARK.name -> ThemeMode.DARK
                else -> ThemeMode.SYSTEM
            }
        }

    val languageCodeFlow: Flow<String> = context.dataStore.data
        .catch { exception ->
            if (exception is IOException) {
                emit(emptyPreferences())
            } else {
                throw exception
            }
        }
        .map { preferences ->
            preferences[PreferencesKeys.LANGUAGE_CODE] ?: ""
        }

    val onboardingCompletedFlow: Flow<Boolean> = context.dataStore.data
        .catch { exception ->
            if (exception is IOException) {
                emit(emptyPreferences())
            } else {
                throw exception
            }
        }
        .map { preferences ->
            preferences[PreferencesKeys.ONBOARDING_COMPLETED] ?: false
        }

    val acceptedLegalVersionFlow: Flow<String> = context.dataStore.data
        .catch { exception ->
            if (exception is IOException) {
                emit(emptyPreferences())
            } else {
                throw exception
            }
        }
        .map { preferences ->
            preferences[PreferencesKeys.ACCEPTED_LEGAL_VERSION] ?: ""
        }

    suspend fun updateNickname(nickname: String) {
        val cleanNickname = nickname.trim().take(30)
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.NICKNAME] = cleanNickname
        }
    }

    suspend fun updateAvatarId(avatarId: String) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.AVATAR_ID] = avatarId
        }
    }

    suspend fun updateFavoriteCatId(catId: String) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.FAVORITE_CAT_ID] = catId
        }
    }

    suspend fun clearFavoriteCatIfMatches(catId: String) {
        context.dataStore.edit { preferences ->
            if (preferences[PreferencesKeys.FAVORITE_CAT_ID] == catId) {
                preferences[PreferencesKeys.FAVORITE_CAT_ID] = ""
            }
        }
    }

    suspend fun updateThemeMode(mode: ThemeMode) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.THEME_MODE] = mode.name
        }
    }

    suspend fun updateLanguageCode(code: String) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.LANGUAGE_CODE] = code
        }
    }

    suspend fun completeOnboarding(legalVersion: String) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.ONBOARDING_COMPLETED] = true
            preferences[PreferencesKeys.ACCEPTED_LEGAL_VERSION] = legalVersion
        }
    }

    suspend fun resetOnboarding() {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.ONBOARDING_COMPLETED] = false
            preferences[PreferencesKeys.ACCEPTED_LEGAL_VERSION] = ""
        }
    }

    companion object {
        @Volatile
        private var INSTANCE: UserPreferencesRepository? = null

        fun getInstance(context: Context): UserPreferencesRepository {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: UserPreferencesRepository(context.applicationContext).also { INSTANCE = it }
            }
        }
    }
}
