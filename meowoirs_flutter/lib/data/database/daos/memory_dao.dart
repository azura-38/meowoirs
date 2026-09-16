import 'package:drift/drift.dart';
import '../meowoirs_database.dart';
import '../tables/memories_table.dart';
import '../../models/memory.dart';

part 'memory_dao.g.dart';

@DriftAccessor(tables: [MemoriesTable])
class MemoryDao extends DatabaseAccessor<MeowoirsDatabase> with _$MemoryDaoMixin {
  MemoryDao(super.db);

  Memory _toDomain(MemoryEntry entry) {
    return Memory(
      id: entry.id,
      catId: entry.catId,
      catName: entry.catName,
      note: entry.note,
      photoUri: entry.photoUri,
      catMood: entry.catMood,
      userMood: entry.userMood,
      createdAt: entry.createdAt,
    );
  }

  MemoriesTableCompanion _toCompanion(Memory memory) {
    return MemoriesTableCompanion(
      id: Value(memory.id),
      catId: Value(memory.catId),
      catName: Value(memory.catName),
      note: Value(memory.note),
      photoUri: Value(memory.photoUri),
      catMood: Value(memory.catMood),
      userMood: Value(memory.userMood),
      createdAt: Value(memory.createdAt),
    );
  }

  /// Recent memories up to [limit], ordered by createdAt DESC.
  Stream<List<Memory>> watchRecentMemories(int limit) {
    final query = select(memoriesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    return query.watch().map((list) => list.map(_toDomain).toList());
  }

  /// All memories ordered by createdAt DESC.
  Stream<List<Memory>> watchAllMemories() {
    final query = select(memoriesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((list) => list.map(_toDomain).toList());
  }

  /// Memories for a specific cat ordered by createdAt DESC.
  Stream<List<Memory>> watchMemoriesForCat(String catId) {
    final query = select(memoriesTable)
      ..where((t) => t.catId.equals(catId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((list) => list.map(_toDomain).toList());
  }

  /// Count of memories for a specific cat.
  Stream<int> watchMemoryCountForCat(String catId) {
    final countExp = memoriesTable.id.count();
    final query = selectOnly(memoriesTable)
      ..where(memoriesTable.catId.equals(catId))
      ..addColumns([countExp]);
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Total count of all memories.
  Stream<int> watchTotalMemoryCount() {
    final countExp = memoriesTable.id.count();
    final query = selectOnly(memoriesTable)..addColumns([countExp]);
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Single memory by ID (reactive stream).
  Stream<Memory?> watchMemoryById(String memoryId) {
    final query = select(memoriesTable)
      ..where((t) => t.id.equals(memoryId))
      ..limit(1);
    return query.watchSingleOrNull().map((entry) => entry != null ? _toDomain(entry) : null);
  }

  /// Single memory by ID (one-shot).
  Future<Memory?> getMemoryById(String memoryId) async {
    final query = select(memoriesTable)
      ..where((t) => t.id.equals(memoryId))
      ..limit(1);
    final entry = await query.getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  /// Insert or replace memory.
  Future<void> insertMemory(Memory memory) {
    return into(memoriesTable).insertOnConflictUpdate(_toCompanion(memory));
  }

  /// Update existing memory.
  Future<bool> updateMemory(Memory memory) {
    return update(memoriesTable).replace(_toCompanion(memory));
  }

  /// Delete memory by entity.
  Future<int> deleteMemory(Memory memory) {
    return (delete(memoriesTable)..where((t) => t.id.equals(memory.id))).go();
  }

  /// Delete memory by ID.
  Future<int> deleteMemoryById(String memoryId) {
    return (delete(memoriesTable)..where((t) => t.id.equals(memoryId))).go();
  }

  /// Critical data synchronization: Updates denormalized catName across all memories of a renamed cat.
  Future<int> updateCatNameForMemories(String catId, String newCatName) {
    return (update(memoriesTable)..where((t) => t.catId.equals(catId)))
        .write(MemoriesTableCompanion(catName: Value(newCatName)));
  }
}
