# Meowoirs (Miyavlar) 🐾

> Every cat has a story. Personal memory book for cats.  
> *Her kedinin bir hikayesi var. Kediler için kişisel anı günlüğü.*

Meowoirs is an offline-first mobile application built with **Flutter**, targeting **Android** and **iOS**. The single canonical production codebase is located under [`meowoirs_flutter/`](file:///c:/Users/olum3/OneDrive/Masa%C3%BCst%C3%BC/Meowoirs/meowoirs_flutter).

---

## Architecture & Technology Stack

- **Framework**: Flutter (Dart)
- **Architecture**: Clean Architecture + Feature-First structure
- **State Management**: Flutter Riverpod (`flutter_riverpod: ^2.6.1`)
- **Navigation & Routing**: GoRouter (`go_router: ^14.8.1`)
- **Local Persistence**: Drift (SQLite abstraction, `drift: ^2.25.0`) + SharedPreferences (`shared_preferences: ^2.5.3`)
- **Privacy & Telemetry**: Firebase Crashlytics (`firebase_crashlytics: ^4.3.3`) — strict zero personal data transmission
- **Monetization & Ads**: Google Mobile Ads (`google_mobile_ads: ^5.3.0`) gated strictly behind User Messaging Platform (UMP) consent
- **Design System**: Custom Meowoirs aesthetic (Cream, Orange, Sage, Dark Brown, Lavender) with Google Fonts (Plus Jakarta Sans)
- **Localization**: 10 languages supported (`tr`, `en`, `de`, `fr`, `es`, `it`, `pt`, `nl`, `pl`, `ja`)

---

## Repository Structure

```
MEOWOIRS
└── meowoirs_flutter/            # Official Canonical Production Application
    ├── lib/
    │   ├── core/                # Theme, routing, localization, configuration
    │   ├── data/                # Drift SQLite database, DAOs, preferences
    │   ├── domain/              # Entity models and state classes
    │   ├── features/            # Feature modules (Cats, Memories, Home, Profile, Story, Settings, Legal, Onboarding, Debug)
    │   ├── services/            # AdManager, Crashlytics, LaunchCounter
    │   └── widgets/             # Reusable UI components
    ├── android/                 # Android platform runner & Gradle host
    ├── ios/                     # iOS platform runner
    ├── assets/                  # Bundled images, avatars, onboarding, fonts, and 6 legal documents
    └── test/                    # Comprehensive unit and widget test suite (511+ tests)
```

---

## Development & Build Instructions

### Prerequisites
- Flutter SDK (>= 3.41.0)
- Android SDK (compileSdk 36, minSdk 26)
- Java 17+

### Running the App
```bash
cd meowoirs_flutter
flutter pub get
flutter run
```

### Running Tests & Static Analysis
```bash
cd meowoirs_flutter
flutter analyze
flutter test
```

### Building Production Release Artifacts
```bash
cd meowoirs_flutter
flutter build apk --release
flutter build appbundle --release
```

Release bundle output:
`meowoirs_flutter/build/app/outputs/bundle/release/app-release.aab`
