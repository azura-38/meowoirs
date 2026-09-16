# MEOWOIRS FLUTTER — ROUTING & APPLICATION SHELL ARCHITECTURE
**Phase 5 Reference Documentation**
**Parity Target:** Kotlin Meowoirs V0.1 (`MainActivity.kt`, `MeowoirsApp.kt`, `MeowoirsNavigation.kt`, `MeowoirsBottomNavigation.kt`, `MeowoirsFab.kt`, `MainScaffold.kt`)

---

## 1. Root Application Architecture

The Flutter application root maintains a strict, unfragmented singleton initialization chain matching the Android application graph:

```
main.dart
  └── ProviderScope (Riverpod global container)
        └── System & Native Initialization (WidgetsFlutterBinding, Firebase, SharedPreferences)
              └── MeowoirsApp (Root ConsumerWidget)
                    └── MaterialApp.router
                          ├── themeMode: themeModeStreamProvider (System / Light / Dark)
                          ├── locale: languageCodeStreamProvider (10 supported languages, English fallback)
                          ├── localizationsDelegates: AppLocalizations delegates
                          └── routerConfig: routerProvider (GoRouter instance)
```

No redundant database or repository instances are constructed. Subscriptions are retained across navigation without leaking memory or triggering unnecessary recompositions.

---

## 2. Onboarding & Legal Gate

Application startup inspects persistent storage (`PreferencesRepository.isOnboardingCompleted()`) as the single source of truth:

```mermaid
graph TD
    A[App Launch] --> B{isOnboardingCompleted == true?}
    B -->|No| C[/onboarding]
    B -->|Yes| D[/ Home Shell]
    C --> E[Page 1: Cilt I • Giriş]
    E --> F[Page 2: Cilt II • Hatıralar]
    F --> G[Page 3: Cilt III • Çevre & Gizlilik]
    G --> H[Page 4: Cilt IV • Yasal İzinler]
    H -->|Accept Privacy & Terms| I[completeOnboarding]
    I -->|Reactive Trigger| D
```

- **Reactive Gate**: `routerProvider` registers `GoRouterRefreshStream(prefs.onboardingCompletedStream)`. Whenever onboarding completes or is reset, the router evaluates redirects instantaneously without restart.
- **Legal Safeguard**: Onboarding Page 4 requires affirmative toggles for both Privacy Policy and Terms of Service. If incomplete, `completeOnboarding` cannot be triggered, and back button press on Android is prevented via `PopScope(canPop: uiState.currentStep == 1)`.

---

## 3. GoRouter & StatefulShellRoute Hierarchy

To guarantee persistent scroll positions, filter states, and memory efficiency across the 4 primary tabs, `StatefulShellRoute.indexedStack` is employed:

### Primary Branches & Routes

| Branch | Path | Component | Turkish Label | Top-Level? | Shows BottomNav? | Shows FAB? |
|---|---|---|---|---|---|---|
| **0: Home** | `/` (alias: `/home`) | `HomeScreen` | `ANA SAYFA` | Yes | Yes | Yes |
| **1: Cats** | `/cats` | `CatsScreen` | `KEDİLERİM` | Yes | Yes | Yes |
| **2: Memories** | `/memories` | `MemoriesScreen` | `ANILAR` | Yes | Yes | Yes |
| **3: Profile** | `/profile` | `ProfileScreen` | `PROFİL` | Yes | Yes | Yes |

### Sub-Routes & Detail Views
- `/cats/add` (`AddCatScreen` — Add new cat or edit via `catId`)
- `/cats/:catId` (`CatDetailScreen` — Cat narrative, photos, cat memories)
- `/memories/add` (`AddMemoryScreen` — Add memory with optional query `?catId=...`)
- `/memories/:memoryId` (`MemoryDetailScreen` — Memory narrative, moods, photo, edit/delete)
- `/story` (`MyStoryScreen` — Full personal narrative and statistics)
- `/settings` (`SettingsScreen` — Theme, language, backup, legal viewer)

### Kotlin V0.1 Compatibility Aliases
The router retains 100% backward-compatible redirects matching legacy deep links:
- `/my_story` ➔ `/story`
- `/add_cat` ➔ `/cats/add`
- `/add_memory` ➔ `/memories/add`
- `/cat_detail/:catId` ➔ `/cats/:catId`
- `/memory_detail/:memoryId` ➔ `/memories/:memoryId`

---

## 4. Shell Route & Centralized UI Policy

All shell visual decisions are encapsulated inside [`RouteUiPolicy`](file:///c:/Users/olum3/OneDrive/Masaüstü/Meowoirs/meowoirs_flutter/lib/core/routing/route_ui_policy.dart):

```dart
class RouteUiPolicy {
  static bool isTopLevel(String location);
  static bool shouldShowBottomNav(String location);
  static bool shouldShowFab(String location);
  static bool shouldShowBannerAd(String location);
  static String? getAppBarTitle(String location, AppLocalizations l10n);
}
```

- **Bottom Navigation**: Exactly 4 navigation destinations with icons, unselected icons, and localized semantic labels.
- **Global FAB (`Anı Ekle`)**: Displayed exclusively on top-level browsing routes (`/`, `/cats`, `/memories`, `/profile`). Hidden on all forms, detail views, settings, and onboarding.
- **Banner Ad Placement**: Permitted only on top-level screens (`/`, `/cats`, `/memories`, `/profile`) and detail pages. Strictly prohibited on onboarding, legal, forms, settings, and reach us.

---

## 5. Deep Link Safety & Error Boundaries

Invalid identifiers navigated directly (e.g., `/cats/unknown_123` or `/memories/nonexistent_456`) are caught safely without unhandled exceptions or infinite redirect loops:
- `catByIdStreamProvider` / `memoryByIdStreamProvider` return `null`.
- Screen renders a warm, friendly `Kedi Bulunamadı` or `Anı Bulunamadı` card with a primary `Geri Dön` recovery button returning to the appropriate top-level tab.

---

## 6. Accessibility & Responsive Safe Area

- **Touch Targets**: All navigation destinations and buttons maintain minimum 48×48 dp touch boundaries.
- **Semantics**: Navigation items include semantic labels and tooltips (`tooltip: item.label`).
- **Safe Area**: `MainScaffold` wraps content and bottom navigation with `SafeArea(bottom: false)` on body and handles bottom insets dynamically to fit cutouts, notch phones, and gesture navigation bars.
- **Flex Responsiveness**: Cards, pill widgets, and metadata rows utilize `Flexible` and `TextOverflow.ellipsis` to prevent `RenderFlex` overflows on compact device profiles.

---

## 7. Diagnostics & Privacy Boundaries

In adherence to strict privacy rules:
- No user content (cat names, notes, memories, avatars, moods) is serialized into routing diagnostic breadcrumbs or crash logs.
- Technical route parameters (e.g. route paths and status codes) only are emitted in error logs.

---

## 8. Automated Verification Suite

Phase 5 includes comprehensive test coverage:
1. `test/routing/routing_shell_test.dart` (17 tests covering redirect gate, 4-tab navigation, shell preservation, FAB behavior, route policies, valid/invalid routes, theme & language integration, compatibility aliases, and pop navigation).
2. `test/domain/domain_state_preferences_test.dart` (27 tests covering repositories, state, and metrics).
3. `test/database/database_parity_test.dart` (30 tests covering Drift database parity).

**Total Test Count:** 74/74 passing tests.
