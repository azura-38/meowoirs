import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

/// Centralized route UI policy determining TopBar title, bottom navigation,
/// FAB visibility, and banner ad placement across all routes.
class RouteUiPolicy {
  RouteUiPolicy._();

  /// Top-level destinations that display the 4-tab bottom navigation bar.
  static bool isTopLevel(String location) {
    return location == '/' ||
        location == '/home' ||
        location == '/cats' ||
        location == '/memories' ||
        location == '/profile';
  }

  /// Bottom navigation bar should only be visible on top-level browsing destinations.
  static bool shouldShowBottomNav(String location) {
    return isTopLevel(location);
  }

  /// Global Floating Action Button ("Anı Ekle") should appear on top-level
  /// browsing screens (Home, Cats, Memories).
  /// Strictly hidden on: Onboarding, Add/Edit forms, Details, Settings, Legal.
  static bool shouldShowFab(String location) {
    return location == '/' ||
        location == '/home' ||
        location == '/cats' ||
        location == '/memories';
  }

  /// Banner ad placement policy aligned with AdManager rules.
  /// Allowed on: Home, Cats, Cat Detail, Memories, Profile/My Story.
  /// Strictly prohibited on: Onboarding, Add/Edit forms, Settings, Legal, Debug.
  static bool shouldShowBannerAd(String location) {
    // Prohibited screens
    if (location == '/onboarding' ||
        location == '/settings' ||
        location == '/other_apps' ||
        location == '/coming_soon' ||
        location.startsWith('/cats/add') ||
        location.startsWith('/add_cat') ||
        location.startsWith('/memories/add') ||
        location.startsWith('/add_memory')) {
      return false;
    }

    // Top-level destinations (/, /home, /cats, /memories, /profile)
    if (isTopLevel(location)) {
      return true;
    }

    // Cat detail routes
    if (location.startsWith('/cats/') || location.startsWith('/cat_detail/')) {
      return true;
    }

    // Story browsing routes
    if (location == '/story' || location == '/my_story') {
      return true;
    }

    return false;
  }

  /// Returns user-facing, localized AppBar title for the current route.
  static String getTitle(BuildContext context, String location) {
    final l10n = AppLocalizations.of(context);

    if (location == '/' || location == '/home') {
      return l10n.homeTitle;
    } else if (location == '/cats') {
      return l10n.catsTitle;
    } else if (location == '/memories') {
      return l10n.navMemories;
    } else if (location == '/profile') {
      return l10n.navProfile;
    } else if (location.startsWith('/add_cat') ||
        location.startsWith('/cats/add')) {
      return l10n.addCatTitle;
    } else if (location.startsWith('/cat_detail') ||
        location.startsWith('/cats/')) {
      return l10n.catDetailTitle;
    } else if (location.startsWith('/add_memory') ||
        location.startsWith('/memories/add')) {
      return l10n.fabAddMemory;
    } else if (location.startsWith('/memory_detail') ||
        location.startsWith('/memories/')) {
      return l10n.memoryDetailTitle;
    } else if (location == '/story' || location == '/my_story') {
      return l10n.navMyStory;
    } else if (location == '/settings') {
      return l10n.settingsTitle;
    } else if (location == '/other_apps') {
      return l10n.limanexAppsPageTitle;
    } else if (location == '/coming_soon') {
      return l10n.comingSoonPageTitle;
    }
    return l10n.appName;
  }
}
