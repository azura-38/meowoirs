import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/database_provider.dart';
import '../../features/cats/add_cat_screen.dart';
import '../../features/cats/cat_detail_screen.dart';
import '../../features/cats/cats_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/memories/add_memory_screen.dart';
import '../../features/memories/memories_screen.dart';
import '../../features/memories/memory_detail_screen.dart';
import '../../features/my_story/my_story_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../widgets/main_scaffold.dart';

/// Helper to refresh GoRouter whenever a stream emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(preferencesRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(prefs.onboardingCompletedStream),
    redirect: (context, state) {
      final isOnboardingCompleted = prefs.isOnboardingCompleted();
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      if (!isOnboardingCompleted && !isOnboardingRoute) {
        return '/onboarding';
      }
      if (isOnboardingCompleted && isOnboardingRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(
          onOnboardingFinished: () {
            context.go('/');
          },
        ),
      ),

      // Main 4 Top-level Tabs wrapped in StatefulShellRoute to preserve tab states
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(
            navigationShell: navigationShell,
            currentLocation: state.matchedLocation,
            child: navigationShell,
          );
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: Cats
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cats',
                builder: (context, state) => CatsScreen(
                  onNavigateToAddCat: () => context.push('/add_cat'),
                  onNavigateToCatDetail: (catId) =>
                      context.push('/cat_detail/$catId'),
                ),
              ),
            ],
          ),
          // Branch 2: Memories
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/memories',
                builder: (context, state) => MemoriesScreen(
                  onNavigateToCatDetail: (catId) =>
                      context.push('/cat_detail/$catId'),
                  onNavigateToMemoryDetail: (memId) =>
                      context.push('/memory_detail/$memId'),
                  onNavigateToAddMemory: (catId) {
                    if (catId != null) {
                      context.push('/add_memory?catId=$catId');
                    } else {
                      context.push('/add_memory');
                    }
                  },
                ),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => ProfileScreen(
                  onNavigateToSettings: () => context.push('/settings'),
                  onNavigateToMyStory: () => context.push('/story'),
                  onNavigateToAddCat: () => context.push('/cats/add'),
                  onNavigateToCatDetail: (catId) =>
                      context.push('/cats/$catId'),
                ),
              ),
            ],
          ),
        ],
      ),

      // Redirect for /home
      GoRoute(
        path: '/home',
        redirect: (_, __) => '/',
      ),

      // Detail and Feature routes
      GoRoute(
        path: '/cats/add',
        builder: (context, state) {
          final catId = state.uri.queryParameters['catId'];
          return AddCatScreen(
            catId: catId,
            onBack: () => context.pop(),
          );
        },
      ),
      GoRoute(
        path: '/cats/:catId',
        builder: (context, state) {
          final catId = state.pathParameters['catId'] ?? '';
          return CatDetailScreen(
            catId: catId,
            onBack: () => context.pop(),
            onNavigateToEditCat: (id) => context.push('/add_cat?catId=$id'),
            onNavigateToAddMemory: (id) =>
                context.push('/add_memory?catId=$id'),
            onNavigateToMemoryDetail: (id) =>
                context.push('/memory_detail/$id'),
          );
        },
      ),
      GoRoute(
        path: '/memories/add',
        builder: (context, state) {
          final catId = state.uri.queryParameters['catId'];
          final memoryId = state.uri.queryParameters['memoryId'];
          return AddMemoryScreen(
            initialCatId: catId,
            memoryId: memoryId,
            onBack: () => context.pop(),
            onNavigateToAddCat: () => context.push('/cats/add'),
          );
        },
      ),
      GoRoute(
        path: '/memories/:memoryId',
        builder: (context, state) {
          final memoryId = state.pathParameters['memoryId'] ?? '';
          return MemoryDetailScreen(
            memoryId: memoryId,
            onBack: () => context.pop(),
            onNavigateToEditMemory: (id) =>
                context.push('/memories/add?memoryId=$id'),
            onNavigateToCatDetail: (catId) => context.push('/cats/$catId'),
          );
        },
      ),
      GoRoute(
        path: '/story',
        builder: (context, state) => MyStoryScreen(
          onNavigateToCats: () => context.go('/cats'),
          onNavigateToCatDetail: (catId) => context.push('/cats/$catId'),
          onNavigateToAddMemory: () => context.push('/memories/add'),
          onNavigateToAddCat: () => context.push('/cats/add'),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(
          onBack: () => context.pop(),
        ),
      ),

      // Route aliases for 100% Kotlin navigation parity
      GoRoute(
        path: '/my_story',
        redirect: (_, __) => '/story',
      ),
      GoRoute(
        path: '/add_cat',
        redirect: (_, state) =>
            '/cats/add${state.uri.query.isNotEmpty ? "?${state.uri.query}" : ""}',
      ),
      GoRoute(
        path: '/add_memory',
        redirect: (_, state) =>
            '/memories/add${state.uri.query.isNotEmpty ? "?${state.uri.query}" : ""}',
      ),
      GoRoute(
        path: '/cat_detail/:catId',
        redirect: (_, state) => '/cats/${state.pathParameters["catId"]}',
      ),
      GoRoute(
        path: '/memory_detail/:memoryId',
        redirect: (_, state) => '/memories/${state.pathParameters["memoryId"]}',
      ),
    ],
  );
});
