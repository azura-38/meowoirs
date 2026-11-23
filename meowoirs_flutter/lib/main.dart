import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import 'core/localization/app_localizations.dart';
import 'core/localization/locale_resolver.dart';
import 'core/routing/app_router.dart';
import 'core/theme/meowoirs_theme.dart';
import 'data/database/meowoirs_database.dart';
import 'data/providers/database_provider.dart';
import 'data/repositories/drift_meowoirs_repository.dart';
import 'data/repositories/preferences_repository.dart';
import 'services/ads/ad_manager.dart';
import 'services/ads/launch_counter_manager.dart';
import 'services/crashlytics/crashlytics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Crashlytics technical diagnostics (Phase 16.5 / TD-04)
  await CrashlyticsService.instance.initialize();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  final preferencesRepo = PreferencesRepository(prefs);

  // Auto-detect system locale on very first launch (Phase 18.1 Issue 1)
  if (preferencesRepo.getLanguageCode().isEmpty) {
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    final initialLang = LocaleResolver.resolveDeviceLocale(systemLocales);
    await preferencesRepo.updateLanguageCode(initialLang);
  }

  // Initialize LaunchCounterManager & Ads (Phase 15)
  final launchCounter = LaunchCounterManager(prefs);
  AdManager.instance.setLaunchCounterManager(launchCounter);
  final sessionId = const Uuid().v4();
  launchCounter.recordGenuineLaunch(sessionId);

  // Initialize local SQLite database
  final db = MeowoirsDatabase();
  final repository = DriftMeowoirsRepository(
    catDao: db.catDao,
    memoryDao: db.memoryDao,
    preferencesRepository: preferencesRepo,
  );

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        preferencesRepositoryProvider.overrideWithValue(preferencesRepo),
        repositoryProvider.overrideWithValue(repository),
      ],
      child: const MeowoirsApp(),
    ),
  );

  // Schedule UMP consent & AdMob SDK initialization after the first frame
  // so Android Activity attachment to GoogleMobileAdsPlugin is guaranteed.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AdManager.instance.requestConsentAndInitialize();
  });
}

class MeowoirsApp extends ConsumerWidget {
  const MeowoirsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeStreamProvider).value;
    final languageCode = ref.watch(languageCodeStreamProvider).value;
    final router = ref.watch(routerProvider);

    // Resolve locale with fallback to English if unsupported
    final resolvedLang = (languageCode != null && languageCode.isNotEmpty)
        ? languageCode
        : LocaleResolver.resolveDeviceLocale(WidgetsBinding.instance.platformDispatcher.locales);
    final locale = LocaleResolver.resolveLocale(resolvedLang);

    return MaterialApp.router(
      title: 'Meowoirs',
      debugShowCheckedModeBanner: false,
      theme: MeowoirsTheme.lightTheme,
      darkTheme: MeowoirsTheme.darkTheme,
      themeMode: switch (themeMode) {
        null => ThemeMode.system,
        _ => switch (themeMode) {
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
            AppThemeMode.system => ThemeMode.system,
          },
      },
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
