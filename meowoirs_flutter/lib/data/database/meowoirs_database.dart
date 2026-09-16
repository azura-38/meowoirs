import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/cats_table.dart';
import 'tables/memories_table.dart';
import 'daos/cat_dao.dart';
import 'daos/memory_dao.dart';

part 'meowoirs_database.g.dart';

@DriftDatabase(
  tables: [CatsTable, MemoriesTable],
  daos: [CatDao, MemoryDao],
)
class MeowoirsDatabase extends _$MeowoirsDatabase {
  MeowoirsDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Future schema migrations will be handled here to prevent user data loss.
      },
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'meowoirs_database.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
