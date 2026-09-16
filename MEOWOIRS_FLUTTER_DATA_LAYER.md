# Meowoirs Flutter Data Layer Documentation

This document describes the Flutter local storage architecture, Drift SQLite implementation, and strict behavioral parity with the Kotlin Room reference (Meowoirs V0.1).

---

## 1. Architectural Overview & Design Philosophy

The Meowoirs data layer is designed around three core principles:
1. **Zero Cloud / 100% Offline-First**: All cat records, memories, and user preferences exist exclusively on the user's local device. No remote sync, authentication, or external databases are used.
2. **Strict Kotlin Room Parity**: The database schema, table names, data types, timestamp semantics, and relational behaviors match the Android Kotlin Room implementation (`MeowoirsDatabase.kt`, `CatEntity.kt`, `MemoryEntity.kt`) 1:1.
3. **Reactive UI State via Riverpod & Drift Streams**: SQLite mutations trigger reactive Drift queries that seamlessly update Riverpod stream providers without requiring manual refresh logic.

```
┌────────────────────────────────────────────────────────────┐
│                    Flutter Riverpod UI                     │
│  (CatsScreen, CatDetailScreen, MemoriesScreen, HomeScreen) │
└────────────────────────────┬───────────────────────────────┘
                             │ watches StreamProvider
                             ▼
┌────────────────────────────────────────────────────────────┐
│                  Riverpod StreamProviders                  │
│   catsStreamProvider, allMemoriesStreamProvider, etc.      │
└────────────────────────────┬───────────────────────────────┘
                             │ calls repository streams/actions
                             ▼
┌────────────────────────────────────────────────────────────┐
│                 MeowoirsRepository Layer                   │
│   (DriftMeowoirsRepository / InMemoryMeowoirsRepository)   │
└──────────────┬─────────────────────────────┬───────────────┘
               │                             │
               ▼                             ▼
┌──────────────────────────────┐ ┌───────────────────────────┐
│     Drift DAOs & Database    │ │   PreferencesRepository   │
│   (CatDao, MemoryDao,        │ │   (SharedPreferences:     │
│    MeowoirsDatabase)         │ │    nickname, themeMode,   │
│                              │ │    favorite_cat_id, etc.) │
└──────────────┬───────────────┘ └───────────────────────────┘
               │
               ▼
┌──────────────────────────────┐
│        SQLite on Disk        │
│   meowoirs_database.sqlite   │
└──────────────────────────────┘
```

---

## 2. Drift Database Schema

**Database File**: `meowoirs_database.sqlite`  
**Location**: Application Documents Directory (`getApplicationDocumentsDirectory()`)  
**Current Version**: `1` (`schemaVersion => 1`)

### Table: `cats`
Exact parity with Kotlin `@Entity(tableName = "cats")`:

| Column Name | SQLite Type | Nullable | Primary Key | Description |
| :--- | :--- | :---: | :---: | :--- |
| `id` | `TEXT` | No | Yes | UUID v4 string identifier |
| `name` | `TEXT` | No | No | Cat display name |
| `type` | `TEXT` | No | No | Cat category: `'HOME'` or `'STREET'` |
| `photoUri` | `TEXT` | Yes | No | Local file path to cat image |
| `note` | `TEXT` | Yes | No | Optional description or bio note |
| `createdAt` | `INTEGER` | No | No | Milliseconds since epoch (`Long`) |

### Table: `memories`
Exact parity with Kotlin `@Entity(tableName = "memories")`:

| Column Name | SQLite Type | Nullable | Primary Key | Description |
| :--- | :--- | :---: | :---: | :--- |
| `id` | `TEXT` | No | Yes | UUID v4 string identifier |
| `catId` | `TEXT` | No | No | Foreign identifier linking to Cat |
| `catName` | `TEXT` | No | No | Denormalized cat display name |
| `note` | `TEXT` | No | No | Memory text note |
| `photoUri` | `TEXT` | Yes | No | Local file path to memory photo |
| `catMood` | `TEXT` | Yes | No | Optional cat mood (e.g., "Oyuncu", "Uykulu") |
| `userMood` | `TEXT` | Yes | No | Optional user feeling (e.g., "Huzurlu", "Mutlu") |
| `createdAt` | `INTEGER` | No | No | Milliseconds since epoch (`Long`) |

---

## 3. Domain Models

### `Cat`
```dart
class Cat {
  final String id;
  final String name;
  final CatType type; // CatType.home | CatType.street
  final String? photoUri;
  final String? note;
  final int createdAt;
}
```
- Mapping to storage: `CatType.toStorageString()` maps `home -> "HOME"` and `street -> "STREET"`.
- Mapping from storage: `CatType.fromString(entry.type)` parses `"STREET"` to `street`, defaulting to `home`.

### `Memory`
```dart
class Memory {
  final String id;
  final String catId;
  final String catName;
  final String note;
  final String? photoUri;
  final String? catMood;
  final String? userMood;
  final int createdAt;
}
```

---

## 4. DAO Responsibilities

### `CatDao`
- `watchAllCats()`: Stream of all cats ordered by `createdAt DESC`.
- `watchCatById(catId)`: Reactive stream of single cat by ID or `null`.
- `getCatById(catId)`: One-shot future lookup.
- `watchCatCount()`: Reactive stream of total cat count.
- `insertCat(cat)`: Inserts or replaces on conflict.
- `updateCat(cat)`: Replaces existing cat row.
- `deleteCat(cat)` / `deleteCatById(catId)`: Deletes only the cat record.

### `MemoryDao`
- `watchRecentMemories(limit)`: Stream of recent memories ordered by `createdAt DESC LIMIT limit`.
- `watchAllMemories()`: Stream of all memories ordered by `createdAt DESC`.
- `watchMemoriesForCat(catId)`: Stream of memories for a specific cat ordered by `createdAt DESC`.
- `watchMemoryCountForCat(catId)`: Stream count of memories for a cat.
- `watchTotalMemoryCount()`: Stream count of total memories.
- `watchMemoryById(memoryId)`: Reactive stream of single memory by ID.
- `getMemoryById(memoryId)`: One-shot lookup.
- `insertMemory(memory)`: Inserts or replaces on conflict.
- `updateMemory(memory)`: Replaces existing memory row.
- `deleteMemory(memory)` / `deleteMemoryById(memoryId)`: Deletes only the memory row.
- `updateCatNameForMemories(catId, newCatName)`: Updates denormalized `catName` for all memories where `catId = :catId`.

---

## 5. Repository Layer & Critical Parity Behaviors

### Critical Behavior #1: Cat Rename Synchronization
In Meowoirs, `catName` is denormalized into `memories` for fast list rendering and independent memory display. When a cat is renamed (e.g., from *"Minnoş"* to *"Boncuk"*), all existing memories linked to `catId` must immediately update their `catName`:
```dart
@override
Future<void> updateCat(Cat cat) async {
  try {
    await catDao.updateCat(cat);
    // Denormalized catName synchronization matching Kotlin
    await memoryDao.updateCatNameForMemories(cat.id, cat.name);
  } catch (e, stack) {
    await CrashlyticsService.instance.recordNonFatal(e, stack, reason: 'DriftMeowoirsRepository.updateCat failed');
    rethrow;
  }
}
```

### Critical Behavior #2: Cat Deletion Preserves Memories (No Cascade Delete)
Meowoirs intentionally **preserves memories even if the associated cat is deleted**. Memories remain historical records of feline companions.
- Drift table definitions do **not** specify `onDelete: KeyAction.cascade`.
- `deleteCat` deletes the cat from `cats`, leaving rows in `memories` intact with their original `catId` and `catName`.

### Critical Behavior #3: Favorite Cat Preference Cleanup
When a cat is deleted:
- If `favorite_cat_id == deletedCatId`, `favorite_cat_id` is automatically cleared to empty string `""`.
- If another cat is deleted, `favorite_cat_id` remains unchanged.
```dart
@override
Future<void> deleteCat(String catId) async {
  try {
    await catDao.deleteCatById(catId);
    // Clear favorite cat preference if it matches deleted cat
    await preferencesRepository?.clearFavoriteCatIfMatches(catId);
  } catch (e, stack) {
    await CrashlyticsService.instance.recordNonFatal(e, stack, reason: 'DriftMeowoirsRepository.deleteCat failed');
    rethrow;
  }
}
```

---

## 6. Photo URI Strategy & Platform Safety

- **Local Path Storage Only**: Images are NEVER stored as BLOBs or binary data inside SQLite. Only the local filesystem path string is recorded in `photoUri`.
- **Nullable & Mutating**: `photoUri` is fully nullable. Cats and memories can be created without photos, updated with new photos, or have photos removed (set back to `null`).
- **Platform-Safe Paths**: Paths are obtained via Flutter's `ImagePicker` (`XFile.path`) and `path_provider` APIs. No hardcoded `/data/data/...` or OS-specific prefix assumptions exist.
- **Privacy & Permissions**: The application strictly uses photo gallery picking (`ImageSource.gallery`). The camera permission (`NSCameraUsageDescription`) is excluded from iOS `Info.plist` to minimize permission footprint.

---

## 7. Error Boundaries & Diagnostics

- Database errors are caught and surfaced through repository boundaries using `rethrow`.
- If an unhandled database exception occurs, technical diagnostics are forwarded to `CrashlyticsService.recordNonFatal` with generic action identifiers (e.g. `'DriftMeowoirsRepository.addCat failed'`).
- **Strict User Privacy Guarantee**: No user personal data (cat names, notes, memory texts, photos) is ever sent to Crashlytics, Firebase, or any analytics/external system.
- The UI catches repository exceptions and displays friendly, localized Turkish error messages without exposing raw database stack traces.

---

## 8. Migration Strategy

- **Current Version**: `schemaVersion = 1`
- **Migration Strategy Implementation**:
```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Future migrations will be explicitly handled here to prevent user data loss.
    },
  );
}
```
- Destructive migration (`fallbackToDestructiveMigration`) is strictly prohibited in production to prevent accidental loss of user memories and cats.

---

## 9. Automated Test Suite

A comprehensive test suite validates all database features and Kotlin parity points across 3 test files:

1. **`test/database/database_crud_test.dart`**:
   - `1. Insert cat stores exact fields in database`
   - `2. Read cats: all, by ID, and category filtering`
   - `3. Update cat: updates all mutable fields`
   - `4. Delete cat deletes only the cat record`
   - `5. Insert memory stores exact fields in database`
   - `6. Read memories: all, by ID, and by catId`
   - `7. Update memory: note, photoUri, moods, catId, catName`
   - `8. Delete memory deletes only the memory record`
   - `9. Critical Parity #1: Renaming cat synchronizes denormalized catName in memories`
   - `10. Critical Parity #2: Deleting cat preserves orphan memories without cascade delete`
   - `11. Critical Parity #3: Deleting favorite cat clears favorite_cat_id; deleting other cat preserves it`
   - `12. Invalid ID handling: nonexistent or deleted IDs return null without crashing`
   - `13. Chronological memory ordering: newest createdAt first`
   - `14. Multiple cats and multiple memories with counts`
   - `15. Photo URI: nullable, updateable, removable, only stores local path string`

2. **`test/database/database_persistence_test.dart`**:
   - Validates file-backed SQLite database persistence across connection close and reopen.

3. **`test/database/reactive_providers_test.dart`**:
   - Validates that Drift streams automatically update Riverpod stream providers (`catsStreamProvider`, `catByIdStreamProvider`, `catMemoriesStreamProvider`, `allMemoriesStreamProvider`).
