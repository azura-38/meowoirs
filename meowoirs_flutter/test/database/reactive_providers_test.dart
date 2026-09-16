import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';

void main() {
  late MeowoirsDatabase db;
  late PreferencesRepository prefsRepo;
  late DriftMeowoirsRepository repo;
  late ProviderContainer container;

  setUp(() async {
    db = MeowoirsDatabase(NativeDatabase.memory());

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefsRepo = PreferencesRepository(prefs);

    repo = DriftMeowoirsRepository(
      catDao: db.catDao,
      memoryDao: db.memoryDao,
      preferencesRepository: prefsRepo,
    );

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        preferencesRepositoryProvider.overrideWithValue(prefsRepo),
        repositoryProvider.overrideWithValue(repo),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
    prefsRepo.dispose();
  });

  group('Reactive Riverpod & Drift Stream Tests', () {
    test('12.1 Add Cat triggers reactive update in catsStreamProvider', () async {
      final emitted = <List<Cat>>[];
      final sub = container.listen<AsyncValue<List<Cat>>>(
        catsStreamProvider,
        (prev, next) {
          next.whenData((data) => emitted.add(data));
        },
        fireImmediately: true,
      );

      await pumpEventQueue();
      expect(emitted.isNotEmpty, isTrue);
      expect(emitted.last.isEmpty, isTrue);

      // Add a cat
      final cat = Cat(
        id: 'cat_react_1',
        name: 'Zeytin',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      await pumpEventQueue();
      expect(emitted.last.length, 1);
      expect(emitted.last.first.name, 'Zeytin');

      sub.close();
    });

    test('12.2 Edit Cat triggers reactive update in catByIdStreamProvider', () async {
      final cat = Cat(
        id: 'cat_react_detail',
        name: 'Maviş',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      final emitted = <Cat?>[];
      final sub = container.listen<AsyncValue<Cat?>>(
        catByIdStreamProvider('cat_react_detail'),
        (prev, next) {
          next.whenData((data) => emitted.add(data));
        },
        fireImmediately: true,
      );

      await pumpEventQueue();
      expect(emitted.last?.name, 'Maviş');

      // Edit cat note and name
      await repo.updateCat(cat.copyWith(name: 'Maviş Hanım', note: 'Gözleri mavi'));

      await pumpEventQueue();
      expect(emitted.last?.name, 'Maviş Hanım');
      expect(emitted.last?.note, 'Gözleri mavi');

      sub.close();
    });

    test('12.3 Rename Cat triggers reactive update in catMemoriesStreamProvider', () async {
      final cat = Cat(
        id: 'cat_rename_react',
        name: 'Minnoş',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      final mem = Memory(
        id: 'mem_react_1',
        catId: 'cat_rename_react',
        catName: 'Minnoş',
        note: 'Güneşlendi',
        createdAt: 1100,
      );
      await repo.addMemory(mem);

      final emitted = <List<Memory>>[];
      final sub = container.listen<AsyncValue<List<Memory>>>(
        catMemoriesStreamProvider('cat_rename_react'),
        (prev, next) {
          next.whenData((data) => emitted.add(data));
        },
        fireImmediately: true,
      );

      await pumpEventQueue();
      expect(emitted.last.first.catName, 'Minnoş');

      // Rename cat to Boncuk
      await repo.updateCat(cat.copyWith(name: 'Boncuk'));

      await pumpEventQueue();
      expect(emitted.last.first.catName, 'Boncuk');

      sub.close();
    });

    test('12.4 Delete Cat removes cat from catsStreamProvider but preserves memories in allMemoriesStreamProvider', () async {
      final cat = Cat(
        id: 'cat_del_react',
        name: 'Gece',
        type: CatType.street,
        createdAt: 1000,
      );
      await repo.addCat(cat);

      final mem = Memory(
        id: 'mem_del_react',
        catId: 'cat_del_react',
        catName: 'Gece',
        note: 'Sokakta mama yedi',
        createdAt: 1100,
      );
      await repo.addMemory(mem);

      final catEmitted = <List<Cat>>[];
      final memEmitted = <List<Memory>>[];

      final catSub = container.listen<AsyncValue<List<Cat>>>(
        catsStreamProvider,
        (prev, next) => next.whenData((d) => catEmitted.add(d)),
        fireImmediately: true,
      );
      final memSub = container.listen<AsyncValue<List<Memory>>>(
        allMemoriesStreamProvider,
        (prev, next) => next.whenData((d) => memEmitted.add(d)),
        fireImmediately: true,
      );

      await pumpEventQueue();
      expect(catEmitted.last.length, 1);
      expect(memEmitted.last.length, 1);

      // Delete cat
      await repo.deleteCat('cat_del_react');

      await pumpEventQueue();
      // Cat is deleted
      expect(catEmitted.last.isEmpty, isTrue);
      // Memory is preserved!
      expect(memEmitted.last.length, 1);
      expect(memEmitted.last.first.id, 'mem_del_react');
      expect(memEmitted.last.first.catName, 'Gece');

      catSub.close();
      memSub.close();
    });

    test('12.5 Add and Delete Memory reactively updates allMemoriesStreamProvider and catMemoriesStreamProvider', () async {
      final allMemEmitted = <List<Memory>>[];
      final catMemEmitted = <List<Memory>>[];

      final allSub = container.listen<AsyncValue<List<Memory>>>(
        allMemoriesStreamProvider,
        (prev, next) => next.whenData((d) => allMemEmitted.add(d)),
        fireImmediately: true,
      );
      final catSub = container.listen<AsyncValue<List<Memory>>>(
        catMemoriesStreamProvider('cat_x'),
        (prev, next) => next.whenData((d) => catMemEmitted.add(d)),
        fireImmediately: true,
      );

      await pumpEventQueue();
      expect(allMemEmitted.last.isEmpty, isTrue);
      expect(catMemEmitted.last.isEmpty, isTrue);

      final mem = Memory(
        id: 'mem_lifecycle',
        catId: 'cat_x',
        catName: 'Kedi X',
        note: 'İlk not',
        createdAt: 1000,
      );

      // Add memory
      await repo.addMemory(mem);

      await pumpEventQueue();
      expect(allMemEmitted.last.length, 1);
      expect(catMemEmitted.last.length, 1);

      // Delete memory
      await repo.deleteMemory('mem_lifecycle');

      await pumpEventQueue();
      expect(allMemEmitted.last.isEmpty, isTrue);
      expect(catMemEmitted.last.isEmpty, isTrue);

      allSub.close();
      catSub.close();
    });
  });
}
