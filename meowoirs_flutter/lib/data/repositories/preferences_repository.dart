import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_mode.dart';
import '../models/user_profile.dart';
import '../../features/memories/models/memories_view_mode.dart';

/// SharedPreferences-backed repository for user settings and preferences.
/// Exact parity with UserPreferencesRepository.kt.
class PreferencesRepository {
  PreferencesRepository(this._prefs) {
    _initStreams();
  }

  final SharedPreferences _prefs;

  static const String _keyNickname = 'nickname';
  static const String _keyAvatarId = 'avatar_id';
  static const String _keyFavoriteCatId = 'favorite_cat_id';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguageCode = 'language_code';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyAcceptedLegalVersion = 'accepted_legal_version';
  static const String _keyMemoriesViewMode = 'memories_view_mode';

  final _userProfileController = StreamController<UserProfile>.broadcast();
  final _themeModeController = StreamController<AppThemeMode>.broadcast();
  final _languageCodeController = StreamController<String>.broadcast();
  final _onboardingCompletedController = StreamController<bool>.broadcast();
  final _acceptedLegalVersionController = StreamController<String>.broadcast();
  final _memoriesViewModeController = StreamController<MemoriesViewMode>.broadcast();

  void _initStreams() {
    _userProfileController.add(getUserProfile());
    _themeModeController.add(getThemeMode());
    _languageCodeController.add(getLanguageCode());
    _onboardingCompletedController.add(isOnboardingCompleted());
    _acceptedLegalVersionController.add(getAcceptedLegalVersion());
    _memoriesViewModeController.add(getMemoriesViewMode());
  }

  // ─── Getters ────────────────────────────────────────────────

  UserProfile getUserProfile() {
    return UserProfile(
      nickname: _prefs.getString(_keyNickname) ?? '',
      avatarId: _prefs.getString(_keyAvatarId) ?? 'avatar_warm_cat',
      favoriteCatId: _prefs.getString(_keyFavoriteCatId) ?? '',
    );
  }

  AppThemeMode getThemeMode() {
    final raw = _prefs.getString(_keyThemeMode);
    return AppThemeMode.fromString(raw);
  }

  String getLanguageCode() {
    return _prefs.getString(_keyLanguageCode) ?? '';
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  bool get isOnboardingCompletedValue => isOnboardingCompleted();

  String getAcceptedLegalVersion() {
    return _prefs.getString(_keyAcceptedLegalVersion) ?? '';
  }

  MemoriesViewMode getMemoriesViewMode() {
    final raw = _prefs.getString(_keyMemoriesViewMode);
    return MemoriesViewMode.fromString(raw);
  }

  UserProfile get userProfile => getUserProfile();
  AppThemeMode get themeMode => getThemeMode();
  String get languageCode => getLanguageCode();
  String get acceptedLegalVersion => getAcceptedLegalVersion();
  MemoriesViewMode get memoriesViewMode => getMemoriesViewMode();

  Future<void> setThemeMode(AppThemeMode mode) => updateThemeMode(mode);
  Future<void> setLanguageCode(String code) => updateLanguageCode(code);
  Future<void> setMemoriesViewMode(MemoriesViewMode mode) => updateMemoriesViewMode(mode);
  Future<void> setUserProfile(UserProfile profile) async {
    await updateNickname(profile.nickname);
    await updateAvatarId(profile.avatarId);
    await updateFavoriteCatId(profile.favoriteCatId);
  }

  // ─── Streams ────────────────────────────────────────────────

  Stream<UserProfile> get userProfileStream => _userProfileController.stream;
  Stream<AppThemeMode> get themeModeStream => _themeModeController.stream;
  Stream<String> get languageCodeStream => _languageCodeController.stream;
  Stream<bool> get onboardingCompletedStream => _onboardingCompletedController.stream;
  Stream<String> get acceptedLegalVersionStream => _acceptedLegalVersionController.stream;
  Stream<MemoriesViewMode> get memoriesViewModeStream => _memoriesViewModeController.stream;

  // ─── Mutations ──────────────────────────────────────────────

  Future<void> updateNickname(String nickname) async {
    final trimmed = nickname.trim();
    final clean = trimmed.length > 30 ? trimmed.substring(0, 30) : trimmed;
    await _prefs.setString(_keyNickname, clean);
    _userProfileController.add(getUserProfile());
  }

  Future<void> clearNickname() => updateNickname('');

  Future<void> updateAvatarId(String avatarId) async {
    await _prefs.setString(_keyAvatarId, avatarId);
    _userProfileController.add(getUserProfile());
  }

  Future<void> updateFavoriteCatId(String catId) async {
    await _prefs.setString(_keyFavoriteCatId, catId);
    _userProfileController.add(getUserProfile());
  }

  Future<void> clearFavoriteCat() => updateFavoriteCatId('');

  Future<void> clearFavoriteCatIfMatches(String catId) async {
    if (getUserProfile().favoriteCatId == catId) {
      await _prefs.setString(_keyFavoriteCatId, '');
      _userProfileController.add(getUserProfile());
    }
  }

  Future<void> updateThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, mode.toStorageString());
    _themeModeController.add(mode);
  }

  Future<void> updateLanguageCode(String code) async {
    await _prefs.setString(_keyLanguageCode, code);
    _languageCodeController.add(code);
  }

  Future<void> updateMemoriesViewMode(MemoriesViewMode mode) async {
    await _prefs.setString(_keyMemoriesViewMode, mode.toStorageString());
    _memoriesViewModeController.add(mode);
  }

  Future<void> completeOnboarding(String legalVersion) async {
    await _prefs.setBool(_keyOnboardingCompleted, true);
    await _prefs.setString(_keyAcceptedLegalVersion, legalVersion);
    _onboardingCompletedController.add(true);
    _acceptedLegalVersionController.add(legalVersion);
  }

  Future<void> resetOnboarding() async {
    await _prefs.setBool(_keyOnboardingCompleted, false);
    await _prefs.setString(_keyAcceptedLegalVersion, '');
    _onboardingCompletedController.add(false);
    _acceptedLegalVersionController.add('');
  }

  void dispose() {
    _userProfileController.close();
    _themeModeController.close();
    _languageCodeController.close();
    _onboardingCompletedController.close();
    _acceptedLegalVersionController.close();
    _memoriesViewModeController.close();
  }
}
