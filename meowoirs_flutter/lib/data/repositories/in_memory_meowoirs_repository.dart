import 'dart:async';
import '../models/cat.dart';
import '../models/memory.dart';
import 'meowoirs_repository.dart';
import 'preferences_repository.dart';

/// Realistic sample data for previews & UI tests matching Kotlin PreviewSampleData.
class PreviewSampleData {
  PreviewSampleData._();

  static final sampleCats = [
    Cat(
      id: '1',
      name: 'Minnoş',
      type: CatType.home,
      photoUri: null,
      createdAt: DateTime.now().millisecondsSinceEpoch - 10000000,
    ),
    Cat(
      id: '2',
      name: 'Tekir',
      type: CatType.street,
      photoUri: null,
      createdAt: DateTime.now().millisecondsSinceEpoch - 5000000,
    ),
    Cat(
      id: '3',
      name: 'Duman',
      type: CatType.home,
      photoUri: null,
      createdAt: DateTime.now().millisecondsSinceEpoch - 2000000,
    ),
  ];

  static final sampleMemories = [
    Memory(
      id: 'm1',
      catId: '1',
      catName: 'Minnoş',
      note: 'Bugün yine güneş alan köşeyi bulup orada uyudu.',
      photoUri: null,
      catMood: 'Uykulu',
      userMood: 'Huzurlu',
      createdAt: DateTime.now().millisecondsSinceEpoch - 3600000,
    ),
    Memory(
      id: 'm2',
      catId: '2',
      catName: 'Tekir',
      note: 'Mahallenin köşesinde beni görünce yine yanıma geldi.',
      photoUri: null,
      catMood: 'Sevecen',
      userMood: 'Mutlu',
      createdAt: DateTime.now().millisecondsSinceEpoch - 86400000,
    ),
    Memory(
      id: 'm3',
      catId: '1',
      catName: 'Minnoş',
      note: 'Pencerenin önündeki kuşları seyrederken kuyruğunu sallıyordu.',
      photoUri: null,
      catMood: 'Oyuncu',
      userMood: 'Mutlu',
      createdAt: DateTime.now().millisecondsSinceEpoch - 172800000,
    ),
  ];
}

/// In-memory repository fallback for testing and preview.
/// Exact parity with InMemoryMeowoirsRepository in Kotlin MeowoirsRepository.kt.
class InMemoryMeowoirsRepository implements MeowoirsRepository {
  InMemoryMeowoirsRepository({
    List<Cat>? initialCats,
    List<Memory>? initialMemories,
    this.preferencesRepository,
  })  : _cats = initialCats ?? [],
        _memories = initialMemories ?? [] {
    _emitCats();
    _emitMemories();
  }

  final PreferencesRepository? preferencesRepository;
  List<Cat> _cats;
  List<Memory> _memories;

  final _catsController = StreamController<List<Cat>>.broadcast();
  final _memoriesController = StreamController<List<Memory>>.broadcast();

  void _emitCats() => _catsController.add(List.unmodifiable(_cats));
  void _emitMemories() => _memoriesController.add(List.unmodifiable(_memories));

  @override
  Stream<List<Cat>> getCats() => _catsController.stream;

  @override
  Stream<List<Memory>> getRecentMemories({int limit = 10}) {
    return _memoriesController.stream.map((list) {
      final sorted = List<Memory>.from(list)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sorted.take(limit).toList();
    });
  }

  @override
  Stream<List<Memory>> getAllMemories() {
    return _memoriesController.stream.map((list) {
      return List<Memory>.from(list)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  Stream<Cat?> getCatById(String catId) {
    return _catsController.stream.map((list) {
      return list.cast<Cat?>().firstWhere(
            (c) => c?.id == catId,
            orElse: () => null,
          );
    });
  }

  @override
  Stream<List<Memory>> getMemoriesForCat(String catId) {
    return _memoriesController.stream.map((list) {
      final filtered = list.where((m) => m.catId == catId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered;
    });
  }

  @override
  Stream<int> getMemoryCountForCat(String catId) {
    return _memoriesController.stream.map((list) {
      return list.where((m) => m.catId == catId).length;
    });
  }

  @override
  Future<void> addCat(Cat cat) async {
    _cats = [..._cats, cat];
    _emitCats();
  }

  @override
  Future<void> updateCat(Cat cat) async {
    _cats = _cats.map((c) => c.id == cat.id ? cat : c).toList();
    // Denormalized catName synchronization
    _memories = _memories
        .map((m) => m.catId == cat.id ? m.copyWith(catName: cat.name) : m)
        .toList();
    _emitCats();
    _emitMemories();
  }

  @override
  Future<void> deleteCat(String catId) async {
    _cats = _cats.where((c) => c.id != catId).toList();
    _emitCats();
    await preferencesRepository?.clearFavoriteCatIfMatches(catId);
  }

  @override
  Stream<Memory?> getMemoryById(String memoryId) {
    return _memoriesController.stream.map((list) {
      return list.cast<Memory?>().firstWhere(
            (m) => m?.id == memoryId,
            orElse: () => null,
          );
    });
  }

  @override
  Future<void> addMemory(Memory memory) async {
    _memories = [..._memories, memory];
    _emitMemories();
  }

  @override
  Future<void> updateMemory(Memory memory) async {
    _memories = _memories.map((m) => m.id == memory.id ? memory : m).toList();
    _emitMemories();
  }

  @override
  Future<void> deleteMemory(String memoryId) async {
    _memories = _memories.where((m) => m.id != memoryId).toList();
    _emitMemories();
  }

  void dispose() {
    _catsController.close();
    _memoriesController.close();
  }
}
