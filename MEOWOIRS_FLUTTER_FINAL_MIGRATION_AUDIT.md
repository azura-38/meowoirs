# MEOWOIRS — FLUTTER FINAL MIGRATION & KOTLIN DECOMMISSION AUDIT
**Canonical Implementation**: `meowoirs_flutter/`  
**Legacy Reference Implementation**: `app/` (Kotlin / Jetpack Compose)  
**Date**: September 17, 2026  
**Status**: Phase 0 Read-Only Audit (Kotlin Retained)

---

## 1. Executive Summary

Meowoirs is transitioning to a single, cross-platform codebase built with Flutter (`meowoirs_flutter/`), targeting Android and iOS. The legacy Android-only Kotlin/Jetpack Compose codebase (`app/`) has served as the baseline reference and is slated for total decommissioning once Flutter's production configuration is hardened and verified at the release artifact level.

This audit establishes:
1. Flutter has already achieved full functional and design parity across all 9 application modules with 511 passing automated tests and zero static analysis warnings.
2. Two critical Android-specific configuration gaps in `meowoirs_flutter/android/` must be resolved before Kotlin is removed:
   - **AdMob ContentProvider Startup Crash**: Flutter's `AndroidManifest.xml` currently lacks the `tools:node="remove"` rule for `MobileAdsInitProvider`, leaving the active provider in Flutter release builds.
   - **Release Signing Configuration**: `meowoirs_flutter/android/app/build.gradle.kts` currently falls back to `signingConfigs.getByName("debug")` for release builds rather than using the production keystore (`meowoirs-release-key`).
3. Decommissioning plan for removing the legacy `app/` directory and re-anchoring the root project without breaking Flutter's Android host infrastructure.

---

## 2. Flutter Architecture & Technical Stack

```
meowoirs_flutter/
├── lib/
│   ├── core/              # Theme, config, routing, constants, localization
│   ├── data/              # Drift database (AppDatabase), DAOs, SharedPreferences
│   ├── domain/            # Models (Cat, Memory, Profile, LegalStatus)
│   ├── features/          # UI Feature Modules
│   │   ├── cats/          # Cat List, Add/Edit Cat, Cat Detail
│   │   ├── debug/         # Technical Diagnostics Sheet (hidden debug trigger)
│   │   ├── home/          # Dashboard, summaries, recent memories, FAB
│   │   ├── legal/         # Offline Legal Document Viewer (6 bundled policies)
│   │   ├── memories/      # Memory List, Add/Edit Memory, Memory Detail
│   │   ├── my_story/      # Timeline chronicle of memories
│   │   ├── onboarding/    # 4-screen onboarding with mandatory legal consent
│   │   ├── profile/       # Profile metrics, avatar, favorite cat, settings link
│   │   └── settings/      # Theme, language, privacy, reach us, UMP trigger
│   ├── services/          # AdManager, Crashlytics, LaunchCounter
│   └── widgets/           # Design System buttons, cards, empty states, inputs
```

- **Framework**: Flutter 3.41.0 / Dart 3.11.0
- **State Management**: `flutter_riverpod: ^2.6.1` with code generation (`riverpod_generator: ^2.6.3`)
- **Routing**: `go_router: ^14.8.1` with deep link support and compatibility redirects
- **Local Persistence**: `drift: ^2.25.0` (SQLite abstraction) + `shared_preferences: ^2.5.3`
- **AdMob**: `google_mobile_ads: ^5.3.0` with manual UMP consent gate
- **Crash Reporting**: `firebase_crashlytics: ^4.3.3` with zero personal data transmission
- **Design System**: Warm photographic aesthetic (Cream, Orange, Sage, Dark Brown, Lavender) with `google_fonts` (Plus Jakarta Sans)

---

## 3. Flutter Routes & Screens

| Route Path | Screen / Widget | Description |
|---|---|---|
| `/` | `InitialRouteResolver` | Determines whether to show Onboarding or Home based on legal/onboarding completion |
| `/onboarding` | `OnboardingScreen` | 4-page introduction with mandatory Privacy & Terms checkboxes |
| `/home` | `HomeScreen` | Dashboard with cat/memory counts, quick memories, global FAB |
| `/cats` | `CatsScreen` | Filterable list of cats (all, home, street), empty states |
| `/cats/add` | `AddEditCatScreen` | Cat creation with photo picker, type, birth/rescue date |
| `/cats/edit/:catId` | `AddEditCatScreen` | Cat update with photo change/remove, name change propagation |
| `/cats/detail/:catId` | `CatDetailScreen` | Detailed view, cat statistics, memories associated with cat |
| `/memories` | `MemoriesScreen` | Reverse-chronological timeline of memories, filter by cat |
| `/memories/add` | `AddEditMemoryScreen` | Memory creation with photo picker, cat picker, mood selection |
| `/memories/edit/:memoryId` | `AddEditMemoryScreen` | In-place memory update without duplicating records |
| `/memories/detail/:memoryId` | `MemoryDetailScreen` | Full memory card, notes, mood display, delete confirmation |
| `/story` | `MyStoryScreen` | Chronicle view of all cat stories |
| `/profile` | `ProfileScreen` | User nickname, avatar picker, story metrics, favorite cat |
| `/settings` | `SettingsScreen` | Theme selector, language selector, legal viewer dialogs, UMP options |

---

## 4. Flutter Local Data Architecture

### Drift SQLite Database (`AppDatabase`)
- **`CatsTable`**: `id` (UUID string), `name`, `type` (home/street enum), `photoUri`, `notes`, `createdAt`, `updatedAt`
- **`MemoriesTable`**: `id` (UUID string), `catId` (nullable UUID string), `catName` (denormalized string), `photoUri`, `story` (notes text), `catMood` (enum), `userMood` (enum), `date` (DateTime), `createdAt`, `updatedAt`

### Cat/Memory Data Relationship Parity
- **Independent Lifecycles**: Deleting a cat does **NOT** cascade delete memories. The memory retains its historical record with the denormalized `catName`.
- **Name Propagation**: Updating a cat's name updates all denormalized `catName` references in memories.
- **Favorite Cat Integrity**: If a cat marked as favorite in user preferences is deleted, the favorite cat preference is safely cleared.
- **No Remote Backend**: 100% offline-first. Zero accounts, zero cloud storage, zero tracking identifiers.

---

## 5. Legal & Consent Subsystem

### Bundled Legal Documents (`assets/legal/`)
1. `PRIVACY_POLICY.txt` (Public URL: `https://limanexstudio.com/privacy/meowoirs`)
2. `TERMS_OF_SERVICE.txt` (Public URL: `https://limanexstudio.com/terms/meowoirs`)
3. `DATA_DELETION_POLICY.txt`
4. `THIRD_PARTY_SERVICES.txt`
5. `ADVERTISING_AND_CONSENT.txt`
6. `LEGAL_DISCLAIMER.txt`

### Legal Enforcement
- **Onboarding Page 4**: Both Privacy Policy and Terms of Service checkboxes must be explicitly checked. Neither checkbox is checked by default. The Continue CTA remains strictly disabled until both are checked.
- **Settings Screen**: Exposes all 6 legal documents via offline modal viewer + external browser launcher fallback.
- **UMP Privacy Options**: Accessible at any time from Settings (`UserMessagingPlatform.showPrivacyOptionsForm()`).

---

## 6. AdMob & UMP Advertising Subsystem

### Authoritative Production Identifiers
- **Application ID**: `ca-app-pub-587701117866406~4355156867` (uses `~`)
- **Banner Ad Unit ID**: `ca-app-pub-587701117866406/2930394553` (uses `/`)
- **Interstitial Ad Unit ID**: `ca-app-pub-587701117866406/2195897382` (uses `/`)

### Initialization & Lifecycle Policy
- **Gated Initialization**: `MobileAds.instance.initialize()` is called **only after** UMP consent check confirms `canRequestAds() == true`.
- **Ad Frequency & Rules**:
  - Interstitial: Never on launches 1–4. Allowed only on launches 5–7.
  - Stabilization: 1200ms delay before interstitial display.
  - Safe Route Restriction: Interstitials only presented on top-level browsing routes (`/`, `/home`, `/cats`, `/memories`, `/story`). Strictly forbidden during typing, form entry, photo picking, saving, or deleting.
  - Banners: Never shown on onboarding, legal views, forms, or settings. Retry backoff at 5s, 15s, 30s, 60s.

---

## 7. Crashlytics & Privacy Hygiene

- **Firebase Project**: `meowoirs` (configuration: `google-services.json`).
- **Telemetry Boundary**: Only uncaught technical exceptions and stack traces are captured.
- **Strict Privacy**: Zero transmission of cat names, memory notes, journal text, photos, user names, or device identifiers.

---

## 8. Localization Matrix (10 Supported Languages)

All 10 languages are implemented in `.arb` files and compiled into generated localizations:
- `tr` (Turkish — primary reference)
- `en` (English)
- `de` (German)
- `fr` (French)
- `es` (Spanish)
- `it` (Italian)
- `pt` (Portuguese)
- `nl` (Dutch)
- `pl` (Polish)
- `ja` (Japanese)

---

## 9. Kotlin vs Flutter Parity Matrix

| Feature / Behavior | Kotlin Baseline (`app/`) | Flutter Implementation (`meowoirs_flutter/`) | Parity Status |
|---|---|---|---|
| **Onboarding** (4 screens, legal check) | Jetpack Compose pager | Flutter `PageView` | **PARITY (100%)** |
| **Home Dashboard** (counts, recents, FAB) | Compose Column + Room Flow | Flutter Riverpod + Drift Watch | **PARITY (100%)** |
| **Cat Management** (CRUD, home/street) | Room DAO + ViewModel | Drift DAO + Riverpod Notifier | **PARITY (100%)** |
| **Memory Management** (CRUD, moods) | Room DAO + ViewModel | Drift DAO + Riverpod Notifier | **PARITY (100%)** |
| **Cat Deletion Memory Preservation** | Preserved with catName | Preserved with catName | **PARITY (100%)** |
| **Cat Name Propagation** | Updates memories table | Updates memories table | **PARITY (100%)** |
| **My Story Timeline** | Grouped date list | Grouped chronicle cards | **PARITY (100%)** |
| **Profile & Avatar Picker** | DataStore + local assets | SharedPreferences + local assets | **PARITY (100%)** |
| **Settings** (Theme, Language, Legal) | Material 3 Scaffold | Material 3 Scaffold | **PARITY (100%)** |
| **Legal Viewer** (6 documents offline) | Android string resource / assets | Bundled text assets in dialog | **PARITY (100%)** |
| **Support Email** | `limanexsoftware@outlook.com` | `limanexsoftware@outlook.com` | **PARITY (100%)** |
| **Photo Picking** | Android Photo Picker contract | `image_picker: ^1.1.2` | **PARITY (100%)** |
| **Permissions** | Zero dangerous permissions | Zero dangerous permissions | **PARITY (100%)** |
| **AdMob UMP & Manual Init** | `AdManager.kt` | `ad_manager.dart` | **PARITY (100%)** |
| **MobileAdsInitProvider Removal** | Removed via `tools:node="remove"` | **PENDING** (to fix in Phase 1) | **GAP IDENTIFIED** |
| **Release Signing Configuration** | Configured with `meowoirs-release-key` | **PENDING** (to fix in Phase 12) | **GAP IDENTIFIED** |

---

## 10. Identified Gaps & Release Risks

### Gap 1: Flutter Android Manifest Missing `MobileAdsInitProvider` Removal
- **Risk**: Release AAB produced by Flutter crashes immediately on startup on Google Play with `IllegalStateException: Invalid application ID`.
- **Solution**: Add `xmlns:tools="http://schemas.android.com/tools"` and `<provider android:name="com.google.android.gms.ads.MobileAdsInitProvider" android:authorities="${applicationId}.mobileadsinitprovider" tools:node="remove" />` to `meowoirs_flutter/android/app/src/main/AndroidManifest.xml`.

### Gap 2: Flutter Android Release Signing Uses Debug Config
- **Risk**: Flutter release AAB signed with debug key, causing rejection by Google Play console or signature mismatch with production key (`D1:7F:35:...:C1`).
- **Solution**: Configure `meowoirs_flutter/android/app/build.gradle.kts` with `signingConfigs.create("release")` loading `keystore.properties` / `meowoirs-release-key`.

---

## 11. Legacy Decommissioning Inventory (Files to Delete Post-Verification)

The following components belong exclusively to the legacy Kotlin application and will be removed once Flutter's production AAB is verified:

1. **`app/` Module** (entire directory):
   - `app/src/main/java/com/limanex/meowoirs/*` (All Kotlin source: Compose UI, ViewModels, Room, DataStore, AdManager)
   - `app/src/main/res/*` (Legacy XML resources, drawables, themes)
   - `app/src/main/AndroidManifest.xml`
   - `app/src/debug/*` (Kotlin debug panel, crash activity)
   - `app/src/test/*` (Legacy Kotlin unit tests)
   - `app/src/androidTest/*`
   - `app/build.gradle.kts`
   - `app/proguard-rules.pro`
2. **Root Gradle Build Scripts**:
   - Clean `settings.gradle.kts` (remove `include(":app")`)
   - Clean root `build.gradle.kts`
3. **Legacy Documentation & Temporary Artifacts**:
   - Update `README.md` to establish `meowoirs_flutter/` as canonical.

*Note: `meowoirs_flutter/android/` contains the Android host runner required by Flutter and will remain fully intact.*
