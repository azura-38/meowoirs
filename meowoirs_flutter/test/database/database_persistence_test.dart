import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';

void main() {
  late Directory tempDir;
  late File dbFile;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('meowoirs_persist_test_');
    dbFile = File(p.join(tempDir.path, 'meowoirs_database.sqlite'));
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('9. Persistence: Records persist across database connection close and reopen (file-backed SQLite)', () async {
    final catId = const Uuid().v4();
    final memId = const Uuid().v4();
    const catName = 'Karamel';
    const memoryNote = 'Pencere kenarında güvercinleri izlerken mırıldadı.';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // ─── SESSION 1: Create and insert records into file-backed DB ────
    {
      final db1 = MeowoirsDatabase(NativeDatabase(dbFile));
      final repo1 = DriftMeowoirsRepository(
        catDao: db1.catDao,
        memoryDao: db1.memoryDao,
      );

      final cat = Cat(
        id: catId,
        name: catName,
        type: CatType.home,
        photoUri: '/local/karamel.png',
        note: 'Sarı-beyaz tekir',
        createdAt: timestamp,
      );
      await repo1.addCat(cat);

      final memory = Memory(
        id: memId,
        catId: catId,
        catName: catName,
        note: memoryNote,
        photoUri: '/local/memory_pencere.png',
        catMood: 'Meraklı',
        userMood: 'Huzurlu',
        createdAt: timestamp,
      );
      await repo1.addMemory(memory);

      // Verify before close
      final catsBeforeClose = await repo1.getCats().first;
      expect(catsBeforeClose.length, 1);
      final memoriesBeforeClose = await repo1.getAllMemories().first;
      expect(memoriesBeforeClose.length, 1);

      // Explicitly close DB connection (simulating app shutdown)
      await db1.close();
    }

    // Verify database file exists on disk
    expect(dbFile.existsSync(), isTrue);
    expect(dbFile.lengthSync(), greaterThan(0));

    // ─── SESSION 2: Reopen file-backed DB (simulating app relaunch) ──
    {
      final db2 = MeowoirsDatabase(NativeDatabase(dbFile));
      final repo2 = DriftMeowoirsRepository(
        catDao: db2.catDao,
        memoryDao: db2.memoryDao,
      );

      // Verify records survived restart intact
      final catsAfterReopen = await repo2.getCats().first;
      expect(catsAfterReopen.length, 1);
      final persistedCat = catsAfterReopen.first;
      expect(persistedCat.id, catId);
      expect(persistedCat.name, catName);
      expect(persistedCat.type, CatType.home);
      expect(persistedCat.photoUri, '/local/karamel.png');
      expect(persistedCat.note, 'Sarı-beyaz tekir');
      expect(persistedCat.createdAt, timestamp);

      final memoriesAfterReopen = await repo2.getAllMemories().first;
      expect(memoriesAfterReopen.length, 1);
      final persistedMem = memoriesAfterReopen.first;
      expect(persistedMem.id, memId);
      expect(persistedMem.catId, catId);
      expect(persistedMem.catName, catName);
      expect(persistedMem.note, memoryNote);
      expect(persistedMem.photoUri, '/local/memory_pencere.png');
      expect(persistedMem.catMood, 'Meraklı');
      expect(persistedMem.userMood, 'Huzurlu');
      expect(persistedMem.createdAt, timestamp);

      await db2.close();
    }
  });
}
