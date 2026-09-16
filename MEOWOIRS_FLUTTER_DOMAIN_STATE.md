# Meowoirs Flutter Domain, State & Preferences Architecture

This document specifies the Domain, State Management (Riverpod), and Preferences architecture for Meowoirs Flutter, detailing strict behavioral and structural parity with the Kotlin reference implementation (Meowoirs V0.1).

---

## 1. Domain Models

The domain models are clean Dart classes without any database, ORM, or UI dependencies.

### `Cat`
```dart
class Cat {
  final String id;          // UUID v4 String
  final String name;        // Display name (e.g., "Minnoş")
  final CatType type;       // CatType.home | CatType.street
  final String? photoUri;   // Local filesystem path or null
  final String? note;       // Bio or note
  final int createdAt;      // Epoch millis (Long in Kotlin)
}
```
- **Parity with Kotlin**: Matches `Cat.kt` (`id`, `name`, `type`, `photoUri`, `note`, `createdAt`).
- **Enum `CatType`**:
  - `home` (`'Ev Kedisi'`, storage string: `'HOME'`)
  - `street` (`'Sokak Kedisi'`, storage string: `'STREET'`)
  - Safe conversion via `CatType.fromString(entry.type)` defaulting to `home`.

### `Memory`
```dart
class Memory {
  final String id;          // UUID v4 String
  final String catId;       // Associated Cat UUID
  final String catName;     // Denormalized cat display name
  final String note;        // Memory text
  final String? photoUri;   // Local filesystem path or null
  final String? catMood;    // Cat mood label or null (e.g. "Uykulu")
  final String? userMood;   // User feeling label or null (e.g. "Huzurlu")
  final int createdAt;      // Epoch millis (Long in Kotlin)
}
```
- **Parity with Kotlin**: Matches `Memory.kt`.
- **Denormalized `catName`**: Stored directly on each memory to permit independent list rendering without requiring N+1 SQL joins.

---

## 2. Repository Abstraction Boundary

The UI and Domain layers strictly interact with the domain abstraction `MeowoirsRepository`. The domain layer has **zero** awareness of Drift, SQLite tables, SQL statements, or generated companions.

```
UI Layer (Screens & Widgets)
             │ watches
             ▼
Riverpod Providers / UI State Notifiers
             │ calls
             ▼
MeowoirsRepository (Interface)
      ▲
      │ implements
DriftMeowoirsRepository (Data Layer)
      ├── CatDao
      ├── MemoryDao
      └── PreferencesRepository
             │ executes
             ▼
Drift / SQLite Database
```

---

## 3. Cat State Architecture

- **`catsStreamProvider`**: `StreamProvider<List<Cat>>` connected to `CatDao.watchAllCats()`.
- **`catByIdStreamProvider(catId)`**: `StreamProvider.family<Cat?, String>` for single-cat reactive watching.
- **`catCountProvider`**: `Provider<int>` deriving the total count of cats.
- **`catsUiStateProvider`**: `Provider<CatsUiState>` combining `catsStreamProvider`, `allMemoriesStreamProvider`, and `catFilterProvider`:
  - `allCats`: complete list of cats.
  - `filteredCats`: cats filtered by `CatFilter.all`, `CatFilter.home`, or `CatFilter.street`.
  - `memoryCounts`: map of `catId -> memoryCount` for badge counts.
  - `isCompletelyEmpty`: true when zero cats exist.
  - `isFilterEmpty`: true when the current category filter produces 0 results.

---

## 4. Memory State Architecture

- **`allMemoriesStreamProvider`**: `StreamProvider<List<Memory>>` connected to `MemoryDao.watchAllMemories()`.
- **`recentMemoriesStreamProvider`**: `StreamProvider<List<Memory>>` for recent memories (limit 10).
- **`catMemoriesStreamProvider(catId)`**: `StreamProvider.family<List<Memory>, String>` for cat-specific memories.
- **`memoryByIdStreamProvider(memoryId)`**: `StreamProvider.family<Memory?, String>` for memory detail.
- **`totalMemoryCountProvider`**: `Provider<int>` calculating total memories count.
- **`memoryCountForCatProvider(catId)`**: `StreamProvider.family<int, String>` for single cat memory count.
- **`memoriesUiStateProvider`**: `Provider<MemoriesUiState>` exposing filtered memories and cat selection.

---

## 5. Cat + Memory Relationship & Rename Synchronization

When a cat is renamed:
1. `repo.updateCat(cat)` updates the cat row in `cats`.
2. `memoryDao.updateCatNameForMemories(cat.id, cat.name)` immediately executes `UPDATE memories SET catName = :name WHERE catId = :catId`.
3. Drift query streams detect SQLite table changes and emit updated memory lists.
4. Riverpod stream providers notify all active UI listeners without requiring a manual refresh or duplicated in-memory cache.

---

## 6. Profile & Preferences State

All preferences are managed via `PreferencesRepository` backed by `SharedPreferences`:

| Preference Key | Type | Default Value | Description |
| :--- | :--- | :--- | :--- |
| `nickname` | `String` | `""` | User's chosen display nickname (trimmed, max 30 chars) |
| `avatar_id` | `String` | `"avatar_warm_cat"` | Curated avatar selection |
| `favorite_cat_id` | `String` | `""` | UUID of designated favorite cat |
| `theme_mode` | `String` | `"SYSTEM"` | App theme (`SYSTEM`, `LIGHT`, `DARK`) |
| `language_code` | `String` | `""` | Selected language code (`tr`, `en`, `de`, `fr`, `es`, `it`, `pt`, `nl`, `pl`, `ja`) |
| `onboarding_completed` | `bool` | `false` | First-launch onboarding completion flag |
| `accepted_legal_version` | `String` | `""` | Legal version accepted by user (`"1"`) |

### Favorite Cat Management & Resolution
- **`favoriteCatProvider`**: Resolves `Cat?` by finding the cat in `catsStreamProvider` where `cat.id == favoriteCatId`.
- If `favorite_cat_id` is empty or invalid, resolves to `null`.
- When the designated favorite cat is deleted, `clearFavoriteCatIfMatches(catId)` resets `favorite_cat_id` to `""`.
- If a non-favorite cat is deleted, `favorite_cat_id` remains unchanged.

### Avatar Management
- 10 curated local avatars in `ProfileAvatars`:
  `avatar_warm_cat`, `avatar_sage_cat`, `avatar_lavender_cat`, `avatar_curious_cat`, `avatar_cozy_cat`, `avatar_gentle_paw`, `avatar_star_gazer`, `avatar_book_cat`, `avatar_sunlit_cat`, `avatar_whisker_heart`.
- Safe fallback: Any unknown avatar ID defaults to `avatar_warm_cat` (`ProfileAvatars.all.first`) without crashing.

### Theme State
- Modes: `AppThemeMode.system`, `AppThemeMode.light`, `AppThemeMode.dark`.
- Invalid or corrupt stored values safely fall back to `AppThemeMode.system`.
- Reactively changes `MaterialApp.router` theme mode via `themeModeStreamProvider`.

### Language & Localization State
- Supported: `tr`, `en`, `de`, `fr`, `es`, `it`, `pt`, `nl`, `pl`, `ja` (10 languages).
- Language code updates immediately propagate to `MaterialApp.router`'s `locale`.
- Unsupported or unknown language codes fall back safely to English (`Locale('en')`).
- If no language preference is set, uses default device locale.

### Onboarding & Legal Acceptance
- `onboarding_completed` and `accepted_legal_version` are preserved as distinct fields.
- `CURRENT_LEGAL_VERSION = "1"`.
- Distinguishing legal version enables future legal updates without forcing full onboarding re-runs.

---

## 7. Story Metrics Domain Calculator

A centralized, pure utility `StoryMetricsCalculator.calculate(cats, memories)` powers both `MyStoryScreen` and `ProfileScreen`:
- `totalCats`: Count of all cats.
- `homeCatsCount`: Count of `CatType.home`.
- `streetCatsCount`: Count of `CatType.street`.
- `totalMemories`: Count of all memories.
- `mostRememberedCat`: Cat with the highest count of associated memories.
- `mostRememberedCount`: Number of memories for `mostRememberedCat`.
- `earliestMemory`: Memory with minimum `createdAt`.
- `latestMemory`: Memory with maximum `createdAt`.
- `narrativeSummary`: Humanized summary string reflecting journal progress.

**Edge cases handled safely**:
- 0 cats, 0 memories: Returns fallback narrative, null top cat/earliest/latest.
- Cats with 0 memories: Returns "Kedilerin burada..." narrative.
- Single cat: Returns single-cat personalized narrative.
- Mixed home and street cats: Returns mixed-environment summary.
- Deleted cats with memories: Memories calculate accurately even if cat record is deleted.

---

## 8. Error Boundaries & Mutation Guards

### User-Safe Error Handling
- Errors are caught at the repository boundary and technical stack traces logged to `CrashlyticsService.recordNonFatal`.
- Sensitive personal data (cat names, notes, memory text, photo paths) is **never** attached to crash reports.
- Repository errors are rethrown to the UI layer, which displays localized, friendly Turkish error banners (`'Kedi kaydedilirken bir sorun oluştu.'`, `'Anı silinirken bir sorun oluştu.'`).

### Concurrency & Mutation Guards
- **Double Tap Save**: Screen states maintain `_isSaving` boolean flags, disabling buttons and preventing duplicate insertions.
- **Database Conflict Handling**: `insertOnConflictUpdate` prevents duplicate primary key crashes.
- **Double Tap Delete**: `_isDeleting` boolean flags and confirmation modal dialogs protect against race conditions.

---

## 9. Lifecycle & Resource Management

- **Singletons**: `MeowoirsDatabase`, `PreferencesRepository`, and `DriftMeowoirsRepository` are initialized once in `main()` and injected via top-level `ProviderScope.overrides`.
- **No Database Recreation**: SQLite connection is never recreated during widget rebuilds.
- **Stream Subscriptions**: Riverpod automatically manages stream lifecycle, canceling Drift subscriptions when UI components unmount.

---

## 10. Automated Testing Strategy

57 automated tests across 4 test suites validate all Phase 4 behaviors:
1. `test/domain/domain_state_preferences_test.dart` (27 tests):
   - Cat & Memory loading, empty, create, update, delete states
   - Rename synchronization
   - Favorite cat setting and cleanup
   - Nickname, avatar, theme, language persistence & fallbacks
   - Onboarding & legal version separation
   - Story metrics calculation & edge cases
   - Mutation concurrency protection
   - Invalid ID safe handling
2. `test/database/database_crud_test.dart` (15 tests):
   - Drift DAO & repository CRUD operations
3. `test/database/database_persistence_test.dart` (1 test):
   - Real disk-backed SQLite close/reopen persistence
4. `test/database/reactive_providers_test.dart` (5 tests):
   - Riverpod stream provider reactivity
5. `test/widget_test.dart` (9 tests):
   - Story metrics, suffixes, ads, avatars
