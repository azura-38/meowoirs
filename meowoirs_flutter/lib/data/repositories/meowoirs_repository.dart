import '../models/cat.dart';
import '../models/memory.dart';

/// Repository interface for Meowoirs data operations.
/// Exact parity with MeowoirsRepository.kt.
abstract class MeowoirsRepository {
  Stream<List<Cat>> getCats();
  Stream<List<Memory>> getRecentMemories({int limit = 10});
  Stream<List<Memory>> getAllMemories();
  Stream<Cat?> getCatById(String catId);
  Stream<List<Memory>> getMemoriesForCat(String catId);
  Stream<int> getMemoryCountForCat(String catId);
  Future<void> addCat(Cat cat);
  Future<void> updateCat(Cat cat);
  Future<void> deleteCat(String catId);
  Stream<Memory?> getMemoryById(String memoryId);
  Future<void> addMemory(Memory memory);
  Future<void> updateMemory(Memory memory);
  Future<void> deleteMemory(String memoryId);
}
