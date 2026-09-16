import 'package:drift/drift.dart';
import '../meowoirs_database.dart';
import '../tables/cats_table.dart';
import '../../models/cat.dart';

part 'cat_dao.g.dart';

@DriftAccessor(tables: [CatsTable])
class CatDao extends DatabaseAccessor<MeowoirsDatabase> with _$CatDaoMixin {
  CatDao(super.db);

  Cat _toDomain(CatEntry entry) {
    return Cat(
      id: entry.id,
      name: entry.name,
      type: CatType.fromString(entry.type),
      photoUri: entry.photoUri,
      note: entry.note,
      createdAt: entry.createdAt,
    );
  }

  CatsTableCompanion _toCompanion(Cat cat) {
    return CatsTableCompanion(
      id: Value(cat.id),
      name: Value(cat.name),
      type: Value(cat.type.toStorageString()),
      photoUri: Value(cat.photoUri),
      note: Value(cat.note),
      createdAt: Value(cat.createdAt),
    );
  }

  /// Stream of all cats ordered by createdAt DESC.
  Stream<List<Cat>> watchAllCats() {
    final query = select(catsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((list) => list.map(_toDomain).toList());
  }

  /// Stream of single cat by ID.
  Stream<Cat?> watchCatById(String catId) {
    final query = select(catsTable)
      ..where((t) => t.id.equals(catId))
      ..limit(1);
    return query.watchSingleOrNull().map((entry) => entry != null ? _toDomain(entry) : null);
  }

  /// Single cat lookup by ID.
  Future<Cat?> getCatById(String catId) async {
    final query = select(catsTable)
      ..where((t) => t.id.equals(catId))
      ..limit(1);
    final entry = await query.getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  /// Total count of cats.
  Stream<int> watchCatCount() {
    final countExp = catsTable.id.count();
    final query = selectOnly(catsTable)..addColumns([countExp]);
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Insert or replace cat.
  Future<void> insertCat(Cat cat) {
    return into(catsTable).insertOnConflictUpdate(_toCompanion(cat));
  }

  /// Update existing cat.
  Future<bool> updateCat(Cat cat) {
    return update(catsTable).replace(_toCompanion(cat));
  }

  /// Delete cat by entity.
  Future<int> deleteCat(Cat cat) {
    return (delete(catsTable)..where((t) => t.id.equals(cat.id))).go();
  }

  /// Delete cat by ID.
  Future<int> deleteCatById(String catId) {
    return (delete(catsTable)..where((t) => t.id.equals(catId))).go();
  }
}
