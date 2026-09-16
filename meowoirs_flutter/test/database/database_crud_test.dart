import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';

void main() {
  late MeowoirsDatabase db;
  late PreferencesRepository prefsRepo;
  late DriftMeowoirsRepository repo;

  setUp(() async {
    // In-memory Drift database for fast, isolated tests
    db = MeowoirsDatabase(NativeDatabase.memory());

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefsRepo = PreferencesRepository(prefs);

    repo = DriftMeowoirsRepository(
      catDao: db.catDao,
      memoryDao: db.memoryDao,
      preferencesRepository: prefsRepo,
    );
  });

  tearDown(() async {
    await db.close();
    prefsRepo.dispose();
  });

  group('Drift Meowoirs Database & Repository Parity Tests', () {
    // 1. Insert Cat
    test('1. Insert cat stores exact fields in database', () async {
      final cat = Cat(
        id: const Uuid().v4(),
        name: 'Minnoş',
        type: CatType.home,
        photoUri: '/local/path/minnos.jpg',
        note: 'Tatlı bir kedi',
        createdAt: 1700000000000,
      );

      await repo.addCat(cat);

      final cats = await repo.getCats().first;
      expect(cats.length, 1);
      expect(cats.first.id, cat.id);
      expect(cats.first.name, 'Minnoş');
      expect(cats.first.type, CatType.home);
      expect(cats.first.photoUri, '/local/path/minnos.jpg');
      expect(cats.first.note, 'Tatlı bir kedi');
      expect(cats.first.createdAt, 1700000000000);
    });

    // 2. Read Cat (all cats, single cat by ID, category filtering)
    test('2. Read cats: all, by ID, and category filtering', () async {
      final homeCat = Cat(
        id: 'cat_home_1',
        name: 'Duman',
        type: CatType.home,
        createdAt: 1000,
      );
      final streetCat = Cat(
        id: 'cat_street_1',
        name: 'Tekir',
        type: CatType.street,
        createdAt: 2000,
      );

      await repo.addCat(homeCat);
      await repo.addCat(streetCat);

      final allCats = await repo.getCats().first;
      expect(allCats.length, 2);

      // Single cat by ID
      final fetchedHome = await repo.getCatById('cat_home_1').first;
      expect(fetchedHome?.name, 'Duman');
      expect(fetchedHome?.type, CatType.home);

      final fetchedStreet = await repo.getCatById('cat_street_1').first;
      expect(fetchedStreet?.name, 'Tekir');
      expect(fetchedStreet?.type, CatType.street);

      // Filtering
      final streetCats = allCats.where((c) => c.type == CatType.street).toList();
      expect(streetCats.length, 1);
      expect(streetCats.first.id, 'cat_street_1');
    });

    // 3. Update Cat (name, type, photoUri, note)
    test('3. Update cat: updates all mutable fields', () async {
      final original = Cat(
        id: 'cat_1',
        name: 'Pamuk',
        type: CatType.home,
        photoUri: '/old/pamuk.jpg',
        note: 'Eski not',
        createdAt: 1000,
      );
      await repo.addCat(original);

      final updated = original.copyWith(
        name: 'Pamuk Bey',
        type: CatType.street,
        photoUri: '/new/pamuk_bey.jpg',
        note: 'Yeni güncellenmiş not',
      );
      await repo.updateCat(updated);

      final fetched = await repo.getCatById('cat_1').first;
      expect(fetched?.name, 'Pamuk Bey');
      expect(fetched?.type, CatType.street);
      expect(fetched?.photoUri, '/new/pamuk_bey.jpg');
      expect(fetched?.note, 'Yeni güncellenmiş not');
      expect(fetched?.createdAt, 1000); // CreatedAt preserved
    });

    // 4. Delete Cat
    test('4. Delete cat deletes only the cat record', () async {
      final cat = Cat(
        id: 'cat_to_delete',
        name: 'Gölge',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      var cats = await repo.getCats().first;
      expect(cats.length, 1);

      await repo.deleteCat('cat_to_delete');

      cats = await repo.getCats().first;
      expect(cats.isEmpty, isTrue);
      final singleCat = await repo.getCatById('cat_to_delete').first;
      expect(singleCat, isNull);
    });

    // 5. Insert Memory
    test('5. Insert memory stores exact fields in database', () async {
      final memory = Memory(
        id: const Uuid().v4(),
        catId: 'cat_1',
        catName: 'Minnoş',
        note: 'Koltukta mışıl mışıl uyudu.',
        photoUri: '/memories/sleep.jpg',
        catMood: 'Uykulu',
        userMood: 'Huzurlu',
        createdAt: 1710000000000,
      );

      await repo.addMemory(memory);

      final memories = await repo.getAllMemories().first;
      expect(memories.length, 1);
      expect(memories.first.id, memory.id);
      expect(memories.first.catId, 'cat_1');
      expect(memories.first.catName, 'Minnoş');
      expect(memories.first.note, 'Koltukta mışıl mışıl uyudu.');
      expect(memories.first.photoUri, '/memories/sleep.jpg');
      expect(memories.first.catMood, 'Uykulu');
      expect(memories.first.userMood, 'Huzurlu');
      expect(memories.first.createdAt, 1710000000000);
    });

    // 6. Read Memory (all memories, memory by ID, memories by catId)
    test('6. Read memories: all, by ID, and by catId', () async {
      final mem1 = Memory(
        id: 'm1',
        catId: 'cat_1',
        catName: 'Minnoş',
        note: 'İlk anı',
        createdAt: 1000,
      );
      final mem2 = Memory(
        id: 'm2',
        catId: 'cat_2',
        catName: 'Tekir',
        note: 'İkinci anı',
        createdAt: 2000,
      );
      final mem3 = Memory(
        id: 'm3',
        catId: 'cat_1',
        catName: 'Minnoş',
        note: 'Üçüncü anı',
        createdAt: 3000,
      );

      await repo.addMemory(mem1);
      await repo.addMemory(mem2);
      await repo.addMemory(mem3);

      final all = await repo.getAllMemories().first;
      expect(all.length, 3);

      // By ID
      final single = await repo.getMemoryById('m2').first;
      expect(single?.note, 'İkinci anı');
      expect(single?.catName, 'Tekir');

      // By Cat ID
      final cat1Memories = await repo.getMemoriesForCat('cat_1').first;
      expect(cat1Memories.length, 2);
      expect(cat1Memories.map((m) => m.id), containsAll(['m1', 'm3']));

      final cat2Memories = await repo.getMemoriesForCat('cat_2').first;
      expect(cat2Memories.length, 1);
      expect(cat2Memories.first.id, 'm2');
    });

    // 7. Update Memory
    test('7. Update memory: note, photoUri, moods, catId, catName', () async {
      final memory = Memory(
        id: 'm1',
        catId: 'cat_1',
        catName: 'Minnoş',
        note: 'Eski not',
        photoUri: '/old_photo.jpg',
        catMood: 'Meraklı',
        userMood: 'Heyecanlı',
        createdAt: 1000,
      );
      await repo.addMemory(memory);

      final updated = memory.copyWith(
        note: 'Yeni güncellenen anı notu',
        photoUri: '/new_photo.jpg',
        catMood: 'Oyuncu',
        userMood: 'Mutlu',
      );
      await repo.updateMemory(updated);

      final fetched = await repo.getMemoryById('m1').first;
      expect(fetched?.note, 'Yeni güncellenen anı notu');
      expect(fetched?.photoUri, '/new_photo.jpg');
      expect(fetched?.catMood, 'Oyuncu');
      expect(fetched?.userMood, 'Mutlu');
    });

    // 8. Delete Memory
    test('8. Delete memory deletes only the memory record', () async {
      final memory = Memory(
        id: 'mem_delete',
        catId: 'cat_1',
        catName: 'Minnoş',
        note: 'Silinecek anı',
        createdAt: 1000,
      );
      await repo.addMemory(memory);

      var memories = await repo.getAllMemories().first;
      expect(memories.length, 1);

      await repo.deleteMemory('mem_delete');

      memories = await repo.getAllMemories().first;
      expect(memories.isEmpty, isTrue);

      final fetched = await repo.getMemoryById('mem_delete').first;
      expect(fetched, isNull);
    });

    // 9. CRITICAL BEHAVIOR #1: Cat rename synchronization
    test('9. Critical Parity #1: Renaming cat synchronizes denormalized catName in all existing memories', () async {
      final cat = Cat(
        id: 'cat_rename_test',
        name: 'Minnoş',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      final mem1 = Memory(
        id: 'm_sync_1',
        catId: 'cat_rename_test',
        catName: 'Minnoş',
        note: 'Anı 1',
        createdAt: 1100,
      );
      final mem2 = Memory(
        id: 'm_sync_2',
        catId: 'cat_rename_test',
        catName: 'Minnoş',
        note: 'Anı 2',
        createdAt: 1200,
      );
      final otherCatMem = Memory(
        id: 'm_other',
        catId: 'other_cat',
        catName: 'Tekir',
        note: 'Başka kedi anısı',
        createdAt: 1300,
      );

      await repo.addMemory(mem1);
      await repo.addMemory(mem2);
      await repo.addMemory(otherCatMem);

      // Rename Minnoş to Boncuk
      final renamedCat = cat.copyWith(name: 'Boncuk');
      await repo.updateCat(renamedCat);

      // Verify Cat record
      final fetchedCat = await repo.getCatById('cat_rename_test').first;
      expect(fetchedCat?.name, 'Boncuk');

      // Verify denormalized catName in memories
      final fetchedMem1 = await repo.getMemoryById('m_sync_1').first;
      expect(fetchedMem1?.catName, 'Boncuk');

      final fetchedMem2 = await repo.getMemoryById('m_sync_2').first;
      expect(fetchedMem2?.catName, 'Boncuk');

      // Verify unrelated cat memory is UNCHANGED
      final fetchedOther = await repo.getMemoryById('m_other').first;
      expect(fetchedOther?.catName, 'Tekir');
    });

    // 10. CRITICAL BEHAVIOR #2: Cat deletion preserves memories
    test('10. Critical Parity #2: Deleting cat preserves orphan memories without cascade delete', () async {
      final cat = Cat(
        id: 'cat_orphan_test',
        name: 'Minnoş',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      final mem = Memory(
        id: 'm_orphan_1',
        catId: 'cat_orphan_test',
        catName: 'Minnoş',
        note: 'Minnoş koltukta uyuyor',
        createdAt: 1100,
      );
      await repo.addMemory(mem);

      // Delete the cat
      await repo.deleteCat('cat_orphan_test');

      // Cat is deleted
      final fetchedCat = await repo.getCatById('cat_orphan_test').first;
      expect(fetchedCat, isNull);

      // Memory STILL EXISTS with preserved catId and catName!
      final fetchedMem = await repo.getMemoryById('m_orphan_1').first;
      expect(fetchedMem, isNotNull);
      expect(fetchedMem?.id, 'm_orphan_1');
      expect(fetchedMem?.catId, 'cat_orphan_test');
      expect(fetchedMem?.catName, 'Minnoş');
      expect(fetchedMem?.note, 'Minnoş koltukta uyuyor');

      // Also appears in getAllMemories
      final allMems = await repo.getAllMemories().first;
      expect(allMems.any((m) => m.id == 'm_orphan_1'), isTrue);
    });

    // 11. CRITICAL BEHAVIOR #3: Favorite cat cleanup
    test('11. Critical Parity #3: Deleting favorite cat clears favorite_cat_id; deleting other cat preserves it', () async {
      final catA = Cat(
        id: 'cat_fav_A',
        name: 'Favori Kedi',
        type: CatType.home,
        createdAt: 1000,
      );
      final catB = Cat(
        id: 'cat_fav_B',
        name: 'Diğer Kedi',
        type: CatType.street,
        createdAt: 2000,
      );

      await repo.addCat(catA);
      await repo.addCat(catB);

      // Set Cat A as favorite
      await prefsRepo.updateFavoriteCatId('cat_fav_A');
      expect(prefsRepo.getUserProfile().favoriteCatId, 'cat_fav_A');

      // Delete Cat B (NOT the favorite)
      await repo.deleteCat('cat_fav_B');
      expect(prefsRepo.getUserProfile().favoriteCatId, 'cat_fav_A'); // Unchanged!

      // Delete Cat A (THE favorite)
      await repo.deleteCat('cat_fav_A');
      expect(prefsRepo.getUserProfile().favoriteCatId, ''); // Cleared!
    });

    // 12. Invalid ID handling
    test('12. Invalid ID handling: nonexistent or deleted IDs return null without crashing', () async {
      // Nonexistent cat
      final nonCat = await repo.getCatById('nonexistent_id').first;
      expect(nonCat, isNull);

      // Nonexistent memory
      final nonMem = await repo.getMemoryById('nonexistent_id').first;
      expect(nonMem, isNull);

      // Deleted cat
      final cat = Cat(id: 'temp_cat', name: 'Temp', type: CatType.home, createdAt: 100);
      await repo.addCat(cat);
      await repo.deleteCat('temp_cat');
      final deletedCat = await repo.getCatById('temp_cat').first;
      expect(deletedCat, isNull);

      // Deleted memory
      final mem = Memory(id: 'temp_mem', catId: 'temp_cat', catName: 'Temp', note: 'Temp', createdAt: 100);
      await repo.addMemory(mem);
      await repo.deleteMemory('temp_mem');
      final deletedMem = await repo.getMemoryById('temp_mem').first;
      expect(deletedMem, isNull);
    });

    // 13. Chronological memory ordering (createdAt DESC)
    test('13. Chronological memory ordering: newest createdAt first', () async {
      final mem1 = Memory(id: 'm1', catId: 'c1', catName: 'Kedi', note: 'Eski', createdAt: 1000);
      final mem2 = Memory(id: 'm2', catId: 'c1', catName: 'Kedi', note: 'En yeni', createdAt: 3000);
      final mem3 = Memory(id: 'm3', catId: 'c1', catName: 'Kedi', note: 'Orta', createdAt: 2000);

      await repo.addMemory(mem1);
      await repo.addMemory(mem2);
      await repo.addMemory(mem3);

      final allMemories = await repo.getAllMemories().first;
      expect(allMemories.length, 3);
      expect(allMemories[0].id, 'm2'); // 3000
      expect(allMemories[1].id, 'm3'); // 2000
      expect(allMemories[2].id, 'm1'); // 1000

      // Recent memories with limit
      final recent2 = await repo.getRecentMemories(limit: 2).first;
      expect(recent2.length, 2);
      expect(recent2[0].id, 'm2');
      expect(recent2[1].id, 'm3');
    });

    // 14. Multiple cats and multiple memories
    test('14. Multiple cats and multiple memories with counts', () async {
      for (int i = 1; i <= 5; i++) {
        await repo.addCat(Cat(
          id: 'cat_$i',
          name: 'Cat $i',
          type: i.isEven ? CatType.street : CatType.home,
          createdAt: 1000 * i,
        ));
      }

      // Add 3 memories for cat_1, 2 for cat_2, 0 for others
      for (int j = 1; j <= 3; j++) {
        await repo.addMemory(Memory(
          id: 'mem_1_$j',
          catId: 'cat_1',
          catName: 'Cat 1',
          note: 'Cat 1 Note $j',
          createdAt: 1000 * j,
        ));
      }
      for (int k = 1; k <= 2; k++) {
        await repo.addMemory(Memory(
          id: 'mem_2_$k',
          catId: 'cat_2',
          catName: 'Cat 2',
          note: 'Cat 2 Note $k',
          createdAt: 2000 * k,
        ));
      }

      final cats = await repo.getCats().first;
      expect(cats.length, 5);

      final allMemories = await repo.getAllMemories().first;
      expect(allMemories.length, 5);

      final cat1Count = await repo.getMemoryCountForCat('cat_1').first;
      expect(cat1Count, 3);

      final cat2Count = await repo.getMemoryCountForCat('cat_2').first;
      expect(cat2Count, 2);

      final cat3Count = await repo.getMemoryCountForCat('cat_3').first;
      expect(cat3Count, 0);
    });

    // 15. Photo URI nullable, update, and removal
    test('15. Photo URI: nullable, updateable, removable, only stores local path string', () async {
      // 1. Insert with null photo
      final cat = Cat(
        id: 'cat_photo_test',
        name: 'Gözde',
        type: CatType.home,
        photoUri: null,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      var fetched = await repo.getCatById('cat_photo_test').first;
      expect(fetched?.photoUri, isNull);

      // 2. Update with photo URI
      await repo.updateCat(cat.copyWith(photoUri: '/data/user/0/photos/gozde.jpg'));
      fetched = await repo.getCatById('cat_photo_test').first;
      expect(fetched?.photoUri, '/data/user/0/photos/gozde.jpg');

      // 3. Remove photo URI (set back to null)
      await repo.updateCat(Cat(
        id: 'cat_photo_test',
        name: 'Gözde',
        type: CatType.home,
        photoUri: null,
        createdAt: 1000,
      ));
      fetched = await repo.getCatById('cat_photo_test').first;
      expect(fetched?.photoUri, isNull);

      // Same for Memory photoUri
      final mem = Memory(
        id: 'mem_photo_test',
        catId: 'cat_photo_test',
        catName: 'Gözde',
        note: 'Fotoğraflı anı',
        photoUri: '/photos/memory.png',
        createdAt: 2000,
      );
      await repo.addMemory(mem);

      var fetchedMem = await repo.getMemoryById('mem_photo_test').first;
      expect(fetchedMem?.photoUri, '/photos/memory.png');

      // Remove photo from memory
      await repo.updateMemory(Memory(
        id: 'mem_photo_test',
        catId: 'cat_photo_test',
        catName: 'Gözde',
        note: 'Fotoğraflı anı',
        photoUri: null,
        createdAt: 2000,
      ));
      fetchedMem = await repo.getMemoryById('mem_photo_test').first;
      expect(fetchedMem?.photoUri, isNull);
    });
  });
}
