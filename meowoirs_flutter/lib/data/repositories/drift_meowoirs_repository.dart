import '../../services/crashlytics/crashlytics_service.dart';
import '../database/daos/cat_dao.dart';
import '../database/daos/memory_dao.dart';
import '../models/cat.dart';
import '../models/memory.dart';
import 'meowoirs_repository.dart';
import 'preferences_repository.dart';

/// Drift-backed persistent implementation of MeowoirsRepository.
/// Exact parity with RoomMeowoirsRepository in MeowoirsRepository.kt.
class DriftMeowoirsRepository implements MeowoirsRepository {
  DriftMeowoirsRepository({
    required this.catDao,
    required this.memoryDao,
    this.preferencesRepository,
  });

  final CatDao catDao;
  final MemoryDao memoryDao;
  final PreferencesRepository? preferencesRepository;

  @override
  Stream<List<Cat>> getCats() {
    return catDao.watchAllCats();
  }

  @override
  Stream<List<Memory>> getRecentMemories({int limit = 10}) {
    return memoryDao.watchRecentMemories(limit);
  }

  @override
  Stream<List<Memory>> getAllMemories() {
    return memoryDao.watchAllMemories();
  }

  @override
  Stream<Cat?> getCatById(String catId) {
    return catDao.watchCatById(catId);
  }

  @override
  Stream<List<Memory>> getMemoriesForCat(String catId) {
    return memoryDao.watchMemoriesForCat(catId);
  }

  @override
  Stream<int> getMemoryCountForCat(String catId) {
    return memoryDao.watchMemoryCountForCat(catId);
  }

  @override
  Future<void> addCat(Cat cat) async {
    try {
      await catDao.insertCat(cat);
    } catch (e, stack) {
      await CrashlyticsService.instance.recordNonFatal(
        e,
        stack,
        reason: 'DriftMeowoirsRepository.addCat failed',
      );
      rethrow;
    }
  }

  @override
  Future<void> updateCat(Cat cat) async {
    try {
      await catDao.updateCat(cat);
      // Denormalized catName synchronization matching Kotlin
      await memoryDao.updateCatNameForMemories(cat.id, cat.name);
    } catch (e, stack) {
      await CrashlyticsService.instance.recordNonFatal(
        e,
        stack,
        reason: 'DriftMeowoirsRepository.updateCat failed',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteCat(String catId) async {
    try {
      await catDao.deleteCatById(catId);
      // Clear favorite cat preference if it matches deleted cat
      await preferencesRepository?.clearFavoriteCatIfMatches(catId);
    } catch (e, stack) {
      await CrashlyticsService.instance.recordNonFatal(
        e,
        stack,
        reason: 'DriftMeowoirsRepository.deleteCat failed',
      );
      rethrow;
    }
  }

  @override
  Stream<Memory?> getMemoryById(String memoryId) {
    return memoryDao.watchMemoryById(memoryId);
  }

  @override
  Future<void> addMemory(Memory memory) async {
    try {
      await memoryDao.insertMemory(memory);
    } catch (e, stack) {
      await CrashlyticsService.instance.recordNonFatal(
        e,
        stack,
        reason: 'DriftMeowoirsRepository.addMemory failed',
      );
      rethrow;
    }
  }

  @override
  Future<void> updateMemory(Memory memory) async {
    try {
      await memoryDao.updateMemory(memory);
    } catch (e, stack) {
      await CrashlyticsService.instance.recordNonFatal(
        e,
        stack,
        reason: 'DriftMeowoirsRepository.updateMemory failed',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteMemory(String memoryId) async {
    try {
      await memoryDao.deleteMemoryById(memoryId);
    } catch (e, stack) {
      await CrashlyticsService.instance.recordNonFatal(
        e,
        stack,
        reason: 'DriftMeowoirsRepository.deleteMemory failed',
      );
      rethrow;
    }
  }
}
