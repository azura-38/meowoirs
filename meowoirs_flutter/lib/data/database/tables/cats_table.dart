import 'package:drift/drift.dart';

/// Cats table in SQLite.
/// Exact schema parity with CatEntity.kt (@Entity(tableName = "cats")).
@DataClassName('CatEntry')
class CatsTable extends Table {
  @override
  String get tableName => 'cats';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // "HOME" or "STREET"
  TextColumn get photoUri => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
