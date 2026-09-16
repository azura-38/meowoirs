import 'package:drift/drift.dart';

/// Memories table in SQLite.
/// Exact schema parity with MemoryEntity.kt (@Entity(tableName = "memories")).
@DataClassName('MemoryEntry')
class MemoriesTable extends Table {
  @override
  String get tableName => 'memories';

  TextColumn get id => text()();
  TextColumn get catId => text()();
  TextColumn get catName => text()();
  TextColumn get note => text()();
  TextColumn get photoUri => text().nullable()();
  TextColumn get catMood => text().nullable()();
  TextColumn get userMood => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
