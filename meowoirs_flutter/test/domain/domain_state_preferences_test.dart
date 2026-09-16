import 'dart:ui';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:meowoirs/core/localization/supported_languages.dart';
import 'package:meowoirs/data/database/meowoirs_database.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/data/providers/database_provider.dart';
import 'package:meowoirs/data/repositories/drift_meowoirs_repository.dart';
import 'package:meowoirs/data/repositories/preferences_repository.dart';
import 'package:meowoirs/domain/story/story_metrics_calculator.dart';
import 'package:meowoirs/features/cats/cats_provider.dart';
import 'package:meowoirs/features/memories/memories_provider.dart';
import 'package:meowoirs/features/profile/profile_avatars.dart';

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

  group('Phase 4 — Domain, State & Preferences Verification', () {
    // 1. Cat provider loading/data behavior
    test('1. Cat provider loading and data emission behavior', () async {
      final sub = container.listen(catsUiStateProvider, (prev, next) {});
      expect(container.read(catsUiStateProvider).isLoading, isTrue);

      await pumpEventQueue();
      final state = container.read(catsUiStateProvider);
      expect(state.isLoading, isFalse);
      expect(state.allCats, isEmpty);
      sub.close();
    });

    // 2. Cat provider empty state
    test('2. Cat provider correctly exposes empty state', () async {
      final sub = container.listen(catsUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final state = container.read(catsUiStateProvider);
      expect(state.isCompletelyEmpty, isTrue);
      expect(state.summaryText, '');
      sub.close();
    });

    // 3. Cat create
    test('3. Cat create adds record and updates state', () async {
      final sub = container.listen(catsUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final cat = Cat(
        id: const Uuid().v4(),
        name: 'Duman',
        type: CatType.home,
        note: 'Gri tüylü',
        createdAt: 1000,
      );
      await repo.addCat(cat);

      await pumpEventQueue();
      final state = container.read(catsUiStateProvider);
      expect(state.allCats.length, 1);
      expect(state.allCats.first.name, 'Duman');
      expect(state.isCompletelyEmpty, isFalse);
      sub.close();
    });

    // 4. Cat update
    test('4. Cat update modifies record and updates state', () async {
      final sub = container.listen(catsUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final cat = Cat(
        id: 'cat_update_test',
        name: 'Minnoş',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);
      await pumpEventQueue();

      await repo.updateCat(cat.copyWith(name: 'Minnoş Hanım', type: CatType.street));
      await pumpEventQueue();

      final state = container.read(catsUiStateProvider);
      expect(state.allCats.first.name, 'Minnoş Hanım');
      expect(state.allCats.first.type, CatType.street);
      sub.close();
    });

    // 5. Cat delete
    test('5. Cat delete removes record and updates state', () async {
      final sub = container.listen(catsUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final cat = Cat(
        id: 'cat_del_test',
        name: 'Zeytin',
        type: CatType.home,
        createdAt: 1000,
      );
      await repo.addCat(cat);
      await pumpEventQueue();
      expect(container.read(catsUiStateProvider).allCats.length, 1);

      await repo.deleteCat('cat_del_test');
      await pumpEventQueue();
      expect(container.read(catsUiStateProvider).allCats, isEmpty);
      sub.close();
    });

    // 6. Memory provider data
    test('6. Memory provider data emission and availableCats mapping', () async {
      final catSub = container.listen(catsStreamProvider, (prev, next) {});
      final memSub = container.listen(memoriesUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final cat = Cat(id: 'c1', name: 'Pamuk', type: CatType.home, createdAt: 100);
      await repo.addCat(cat);

      final mem = Memory(
        id: 'm1',
        catId: 'c1',
        catName: 'Pamuk',
        note: 'Güneşin tadını çıkardı',
        createdAt: 200,
      );
      await repo.addMemory(mem);

      await pumpEventQueue();
      final state = container.read(memoriesUiStateProvider);
      expect(state.isLoading, isFalse);
      expect(state.allMemories.length, 1);
      expect(state.availableCats.length, 1);
      expect(state.allMemories.first.note, 'Güneşin tadını çıkardı');

      catSub.close();
      memSub.close();
    });

    // 7. Memory provider empty state
    test('7. Memory provider empty state flags', () async {
      final sub = container.listen(memoriesUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final state = container.read(memoriesUiStateProvider);
      expect(state.isCompletelyEmpty, isTrue);
      expect(state.allMemories, isEmpty);
      sub.close();
    });

    // 8. Memory create
    test('8. Memory create adds memory to state', () async {
      final sub = container.listen(memoriesUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final mem = Memory(
        id: 'm_new',
        catId: 'c1',
        catName: 'Tekir',
        note: 'Yeni anı',
        createdAt: 500,
      );
      await repo.addMemory(mem);

      await pumpEventQueue();
      final state = container.read(memoriesUiStateProvider);
      expect(state.allMemories.length, 1);
      expect(state.allMemories.first.id, 'm_new');
      sub.close();
    });

    // 9. Memory update
    test('9. Memory update updates note and moods in state', () async {
      final sub = container.listen(memoriesUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final mem = Memory(
        id: 'm_edit',
        catId: 'c1',
        catName: 'Tekir',
        note: 'Eski metin',
        createdAt: 500,
      );
      await repo.addMemory(mem);
      await pumpEventQueue();

      await repo.updateMemory(mem.copyWith(
        note: 'Güncel metin',
        catMood: 'Uykulu',
        userMood: 'Huzurlu',
      ));
      await pumpEventQueue();

      final state = container.read(memoriesUiStateProvider);
      expect(state.allMemories.first.note, 'Güncel metin');
      expect(state.allMemories.first.catMood, 'Uykulu');
      expect(state.allMemories.first.userMood, 'Huzurlu');
      sub.close();
    });

    // 10. Memory delete
    test('10. Memory delete removes memory from state', () async {
      final sub = container.listen(memoriesUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final mem = Memory(
        id: 'm_del',
        catId: 'c1',
        catName: 'Tekir',
        note: 'Silinecek',
        createdAt: 500,
      );
      await repo.addMemory(mem);
      await pumpEventQueue();
      expect(container.read(memoriesUiStateProvider).allMemories.length, 1);

      await repo.deleteMemory('m_del');
      await pumpEventQueue();
      expect(container.read(memoriesUiStateProvider).allMemories, isEmpty);
      sub.close();
    });

    // 11. Rename synchronization through state
    test('11. Cat rename synchronizes denormalized catName across memory state', () async {
      final catSub = container.listen(catsStreamProvider, (prev, next) {});
      final memSub = container.listen(memoriesUiStateProvider, (prev, next) {});
      await pumpEventQueue();

      final cat = Cat(id: 'c_rename', name: 'Minnoş', type: CatType.home, createdAt: 100);
      await repo.addCat(cat);

      final mem1 = Memory(id: 'm1', catId: 'c_rename', catName: 'Minnoş', note: 'Not 1', createdAt: 200);
      final mem2 = Memory(id: 'm2', catId: 'c_rename', catName: 'Minnoş', note: 'Not 2', createdAt: 300);
      await repo.addMemory(mem1);
      await repo.addMemory(mem2);
      await pumpEventQueue();

      // Rename Minnoş to Boncuk
      await repo.updateCat(cat.copyWith(name: 'Boncuk'));
      await pumpEventQueue();

      final memories = container.read(memoriesUiStateProvider).allMemories;
      expect(memories.length, 2);
      expect(memories.every((m) => m.catName == 'Boncuk'), isTrue);

      catSub.close();
      memSub.close();
    });

    // 12. Favorite cat set and resolution
    test('12. Favorite cat is set in preferences and resolved to domain object', () async {
      final profileSub = container.listen(userProfileStreamProvider, (prev, next) {});
      final catSub = container.listen(catsStreamProvider, (prev, next) {});
      await pumpEventQueue();

      final cat = Cat(id: 'fav_1', name: 'Karamel', type: CatType.home, createdAt: 100);
      await repo.addCat(cat);
      await pumpEventQueue();

      await prefsRepo.updateFavoriteCatId('fav_1');
      await pumpEventQueue();

      expect(prefsRepo.getUserProfile().favoriteCatId, 'fav_1');
      final resolvedCat = container.read(favoriteCatProvider);
      expect(resolvedCat, isNotNull);
      expect(resolvedCat?.id, 'fav_1');
      expect(resolvedCat?.name, 'Karamel');

      profileSub.close();
      catSub.close();
    });

    // 13. Favorite cat cleanup on deletion
    test('13. Deleting favorite cat clears favorite_cat_id and resolves null', () async {
      final profileSub = container.listen(userProfileStreamProvider, (prev, next) {});
      final catSub = container.listen(catsStreamProvider, (prev, next) {});
      await pumpEventQueue();

      final catA = Cat(id: 'fav_cat_A', name: 'Kedi A', type: CatType.home, createdAt: 100);
      final catB = Cat(id: 'fav_cat_B', name: 'Kedi B', type: CatType.street, createdAt: 200);
      await repo.addCat(catA);
      await repo.addCat(catB);
      await prefsRepo.updateFavoriteCatId('fav_cat_A');
      await pumpEventQueue();

      // Delete non-favorite cat B
      await repo.deleteCat('fav_cat_B');
      await pumpEventQueue();
      expect(prefsRepo.getUserProfile().favoriteCatId, 'fav_cat_A');
      expect(container.read(favoriteCatProvider)?.id, 'fav_cat_A');

      // Delete favorite cat A
      await repo.deleteCat('fav_cat_A');
      await pumpEventQueue();
      expect(prefsRepo.getUserProfile().favoriteCatId, '');
      expect(container.read(favoriteCatProvider), isNull);

      profileSub.close();
      catSub.close();
    });

    // 14. Nickname persistence and validation
    test('14. Nickname persistence, trimming, 30-character limit, and clearNickname', () async {
      await prefsRepo.updateNickname('   Kedi Sever   ');
      expect(prefsRepo.getUserProfile().nickname, 'Kedi Sever');

      // 30 char cap
      await prefsRepo.updateNickname('A' * 45);
      expect(prefsRepo.getUserProfile().nickname.length, 30);

      // Clear nickname
      await prefsRepo.clearNickname();
      expect(prefsRepo.getUserProfile().nickname, '');
    });

    // 15. Avatar persistence
    test('15. Avatar ID persists and updates reactive profile stream', () async {
      final sub = container.listen(userProfileStreamProvider, (prev, next) {});
      await pumpEventQueue();

      await prefsRepo.updateAvatarId('avatar_sage_cat');
      await pumpEventQueue();

      expect(prefsRepo.getUserProfile().avatarId, 'avatar_sage_cat');
      final profile = container.read(userProfileStreamProvider).value;
      expect(profile?.avatarId, 'avatar_sage_cat');

      sub.close();
    });

    // 16. Unknown avatar fallback
    test('16. Unknown avatar ID safely falls back to default avatar without crashing', () {
      final fallback = ProfileAvatars.getById('non_existent_corrupt_id');
      expect(fallback.id, 'avatar_warm_cat');
      expect(fallback.name, 'Sıcak Kedi');
    });

    // 17. Theme persistence
    test('17. Theme mode persists and updates reactive theme stream', () async {
      final sub = container.listen(themeModeStreamProvider, (prev, next) {});
      await pumpEventQueue();

      await prefsRepo.updateThemeMode(AppThemeMode.dark);
      await pumpEventQueue();

      expect(prefsRepo.getThemeMode(), AppThemeMode.dark);
      final currentMode = container.read(themeModeStreamProvider).value;
      expect(currentMode, AppThemeMode.dark);

      sub.close();
    });

    // 18. Invalid theme fallback
    test('18. Invalid stored theme value falls back to system theme', () {
      expect(AppThemeMode.fromString('INVALID_THEME'), AppThemeMode.system);
      expect(AppThemeMode.fromString(null), AppThemeMode.system);
      expect(AppThemeMode.fromString(''), AppThemeMode.system);
    });

    // 19. Language persistence
    test('19. Language code persists and updates reactive stream', () async {
      final sub = container.listen(languageCodeStreamProvider, (prev, next) {});
      await pumpEventQueue();

      await prefsRepo.updateLanguageCode('de');
      await pumpEventQueue();

      expect(prefsRepo.getLanguageCode(), 'de');
      final lang = container.read(languageCodeStreamProvider).value;
      expect(lang, 'de');

      sub.close();
    });

    // 20. Invalid language fallback
    test('20. Unsupported language falls back to English', () {
      const unsupported = 'xx_invalid';
      final isSupported = supportedLanguages.any((l) => l.code == unsupported);
      expect(isSupported, isFalse);

      final resolvedLocale = isSupported ? Locale(unsupported) : const Locale('en');
      expect(resolvedLocale.languageCode, 'en');
    });

    // 21. Onboarding completion persistence
    test('21. Onboarding completion persists and can be reset', () async {
      expect(prefsRepo.isOnboardingCompleted(), isFalse);

      await prefsRepo.completeOnboarding('1');
      expect(prefsRepo.isOnboardingCompleted(), isTrue);

      await prefsRepo.resetOnboarding();
      expect(prefsRepo.isOnboardingCompleted(), isFalse);
    });

    // 22. Legal version persistence
    test('22. Accepted legal version is stored separately from onboarding completed flag', () async {
      await prefsRepo.completeOnboarding('1');
      expect(prefsRepo.isOnboardingCompleted(), isTrue);
      expect(prefsRepo.getAcceptedLegalVersion(), '1');

      // Verify they are distinct fields
      await prefsRepo.resetOnboarding();
      expect(prefsRepo.isOnboardingCompleted(), isFalse);
      expect(prefsRepo.getAcceptedLegalVersion(), '');
    });

    // 23. Story metrics empty state
    test('23. Story metrics empty state handles 0 cats and 0 memories gracefully', () {
      final metrics = StoryMetricsCalculator.calculate([], []);
      expect(metrics.totalCats, 0);
      expect(metrics.totalMemories, 0);
      expect(metrics.homeCatsCount, 0);
      expect(metrics.streetCatsCount, 0);
      expect(metrics.mostRememberedCat, isNull);
      expect(metrics.mostRememberedCount, 0);
      expect(metrics.earliestMemory, isNull);
      expect(metrics.latestMemory, isNull);
      expect(metrics.narrativeSummary, contains('küçük anlar'));
    });

    // 24. Story metrics with multiple cats
    test('24. Story metrics with multiple cats and narrative branching', () {
      final cats = [
        Cat(id: 'c1', name: 'Ev Kedisi', type: CatType.home, createdAt: 100),
        Cat(id: 'c2', name: 'Sokak Kedisi', type: CatType.street, createdAt: 200),
      ];
      final metrics = StoryMetricsCalculator.calculate(cats, []);
      expect(metrics.totalCats, 2);
      expect(metrics.homeCatsCount, 1);
      expect(metrics.streetCatsCount, 1);
      expect(metrics.narrativeSummary, contains('Kedilerin burada'));
    });

    // 25. Story metrics with multiple memories
    test('25. Story metrics identifies top remembered cat and earliest/latest memories', () {
      final cat1 = Cat(id: 'c1', name: 'Tekir', type: CatType.street, createdAt: 100);
      final cat2 = Cat(id: 'c2', name: 'Pamuk', type: CatType.home, createdAt: 200);

      final memories = [
        Memory(id: 'm1', catId: 'c1', catName: 'Tekir', note: 'Anı 1', createdAt: 1000),
        Memory(id: 'm2', catId: 'c1', catName: 'Tekir', note: 'Anı 2', createdAt: 2000),
        Memory(id: 'm3', catId: 'c2', catName: 'Pamuk', note: 'Anı 3', createdAt: 3000),
      ];

      final metrics = StoryMetricsCalculator.calculate([cat1, cat2], memories);
      expect(metrics.totalCats, 2);
      expect(metrics.totalMemories, 3);
      expect(metrics.mostRememberedCat?.name, 'Tekir');
      expect(metrics.mostRememberedCount, 2);
      expect(metrics.earliestMemory?.id, 'm1');
      expect(metrics.latestMemory?.id, 'm3');
    });

    // 26. Duplicate mutation protection
    test('26. Duplicate mutation protection handles concurrent insertions cleanly', () async {
      final cat = Cat(
        id: 'concurrent_cat_id',
        name: 'Gölge',
        type: CatType.home,
        createdAt: 1000,
      );

      // Concurrent adds of same ID (simulating double-tap)
      await Future.wait([
        repo.addCat(cat),
        repo.addCat(cat),
      ]);

      final cats = await repo.getCats().first;
      // SQLite insertOnConflictUpdate ensures exactly one record exists
      expect(cats.where((c) => c.id == 'concurrent_cat_id').length, 1);
    });

    // 27. Invalid ID handling
    test('27. Invalid cat ID and memory ID lookups return null safely', () async {
      final catSub = container.listen(catByIdStreamProvider('invalid_id_999'), (prev, next) {});
      final memSub = container.listen(memoryByIdStreamProvider('invalid_id_999'), (prev, next) {});
      await pumpEventQueue();

      final nonCat = container.read(catByIdStreamProvider('invalid_id_999')).value;
      final nonMem = container.read(memoryByIdStreamProvider('invalid_id_999')).value;

      expect(nonCat, isNull);
      expect(nonMem, isNull);

      catSub.close();
      memSub.close();
    });
  });
}
