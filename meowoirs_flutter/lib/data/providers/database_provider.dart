import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/story/story_metrics.dart';
import '../../domain/story/story_metrics_calculator.dart';
import '../database/daos/cat_dao.dart';
import '../database/daos/memory_dao.dart';
import '../database/meowoirs_database.dart';
import '../models/cat.dart';
import '../models/memory.dart';
import '../models/theme_mode.dart';
import '../models/user_profile.dart';
import '../repositories/meowoirs_repository.dart';
import '../repositories/preferences_repository.dart';

export '../models/theme_mode.dart';

/// Database instance provider.
final databaseProvider = Provider<MeowoirsDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in ProviderScope');
});

/// Preferences repository provider.
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  throw UnimplementedError('preferencesRepositoryProvider must be overridden in ProviderScope');
});

/// Cat DAO provider.
final catDaoProvider = Provider<CatDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.catDao;
});

/// Memory DAO provider.
final memoryDaoProvider = Provider<MemoryDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.memoryDao;
});

/// Primary repository provider.
final repositoryProvider = Provider<MeowoirsRepository>((ref) {
  throw UnimplementedError('repositoryProvider must be overridden in ProviderScope');
});

// ─── Stream Providers ─────────────────────────────────────────

/// Stream of all cats.
final catsStreamProvider = StreamProvider<List<Cat>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.getCats();
});

/// Stream of recent memories (default 10).
final recentMemoriesStreamProvider = StreamProvider<List<Memory>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.getRecentMemories();
});

/// Stream of all memories.
final allMemoriesStreamProvider = StreamProvider<List<Memory>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.getAllMemories();
});

/// Stream of memories for a specific cat.
final catMemoriesStreamProvider =
    StreamProvider.family<List<Memory>, String>((ref, catId) {
  final repo = ref.watch(repositoryProvider);
  return repo.getMemoriesForCat(catId);
});

/// Stream of single cat by ID.
final catByIdStreamProvider =
    StreamProvider.family<Cat?, String>((ref, catId) {
  final repo = ref.watch(repositoryProvider);
  return repo.getCatById(catId);
});

/// Stream of single memory by ID.
final memoryByIdStreamProvider =
    StreamProvider.family<Memory?, String>((ref, memoryId) {
  final repo = ref.watch(repositoryProvider);
  return repo.getMemoryById(memoryId);
});

/// Stream of memory count for a specific cat.
final memoryCountForCatProvider =
    StreamProvider.family<int, String>((ref, catId) {
  final repo = ref.watch(repositoryProvider);
  return repo.getMemoryCountForCat(catId);
});

/// Derived provider for total count of cats.
final catCountProvider = Provider<int>((ref) {
  final cats = ref.watch(catsStreamProvider).value ?? [];
  return cats.length;
});

/// Derived provider for total count of memories.
final totalMemoryCountProvider = Provider<int>((ref) {
  final memories = ref.watch(allMemoriesStreamProvider).value ?? [];
  return memories.length;
});

/// Stream of user profile preference.
final userProfileStreamProvider = StreamProvider<UserProfile>((ref) async* {
  final prefs = ref.watch(preferencesRepositoryProvider);
  yield prefs.getUserProfile();
  yield* prefs.userProfileStream;
});

/// Stream of current theme mode.
final themeModeStreamProvider = StreamProvider<AppThemeMode>((ref) async* {
  final prefs = ref.watch(preferencesRepositoryProvider);
  yield prefs.getThemeMode();
  yield* prefs.themeModeStream;
});

/// Stream of selected language code preference.
final languageCodeStreamProvider = StreamProvider<String>((ref) async* {
  final prefs = ref.watch(preferencesRepositoryProvider);
  yield prefs.getLanguageCode();
  yield* prefs.languageCodeStream;
});

/// Stream of onboarding completion status.
final onboardingCompletedStreamProvider = StreamProvider<bool>((ref) async* {
  final prefs = ref.watch(preferencesRepositoryProvider);
  yield prefs.isOnboardingCompleted();
  yield* prefs.onboardingCompletedStream;
});

/// Stream of accepted legal version.
final acceptedLegalVersionStreamProvider = StreamProvider<String>((ref) async* {
  final prefs = ref.watch(preferencesRepositoryProvider);
  yield prefs.getAcceptedLegalVersion();
  yield* prefs.acceptedLegalVersionStream;
});

/// Resolves the favorite Cat domain model based on favoriteCatId in profile.
final favoriteCatProvider = Provider<Cat?>((ref) {
  final profile = ref.watch(userProfileStreamProvider).value;
  final favId = profile?.favoriteCatId;
  if (favId == null || favId.isEmpty) return null;
  final cats = ref.watch(catsStreamProvider).value ?? [];
  return cats.firstWhereOrNull((c) => c.id == favId);
});

/// Centralized story metrics provider for MyStory and Profile.
final storyMetricsProvider = Provider<StoryMetrics>((ref) {
  final cats = ref.watch(catsStreamProvider).value ?? [];
  final memories = ref.watch(allMemoriesStreamProvider).value ?? [];
  return StoryMetricsCalculator.calculate(cats, memories);
});
