import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/meowoirs_theme.dart';

class MeowoirsNavItem {
  const MeowoirsNavItem({
    required this.route,
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  });

  final String route;
  final String label;
  final Widget selectedIcon;
  final Widget unselectedIcon;
}

/// Clean, lightweight, warm bottom navigation bar.
/// Direct parity with MeowoirsBottomNavigation.kt.
class MeowoirsBottomNavigation extends StatelessWidget {
  const MeowoirsBottomNavigation({
    super.key,
    required this.currentRoute,
    required this.onNavigateToRoute,
    this.items,
  });

  final String currentRoute;
  final ValueChanged<String> onNavigateToRoute;
  final List<MeowoirsNavItem>? items;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final elevations = context.meowoirsElevation;
    final l10n = AppLocalizations.of(context);

    final navItems = items ?? [
      MeowoirsNavItem(
        route: '/',
        label: l10n.navHome,
        selectedIcon: const Icon(Icons.home),
        unselectedIcon: const Icon(Icons.home_outlined),
      ),
      MeowoirsNavItem(
        route: '/cats',
        label: l10n.navCats,
        selectedIcon: const Icon(Icons.pets),
        unselectedIcon: const Icon(Icons.pets_outlined),
      ),
      MeowoirsNavItem(
        route: '/memories',
        label: l10n.navMemories,
        selectedIcon: const Icon(Icons.auto_stories),
        unselectedIcon: const Icon(Icons.auto_stories_outlined),
      ),
      MeowoirsNavItem(
        route: '/profile',
        label: l10n.navProfile,
        selectedIcon: const Icon(Icons.person),
        unselectedIcon: const Icon(Icons.person_outline),
      ),
    ];

    final selectedIndex = navItems.indexWhere(
      (item) => item.route == currentRoute || (item.route != '/' && currentRoute.startsWith(item.route)),
    );

    return NavigationBar(
      selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
      onDestinationSelected: (index) {
        if (index >= 0 && index < navItems.length) {
          onNavigateToRoute(navItems[index].route);
        }
      },
      backgroundColor: colors.cardBackground,
      elevation: elevations.level1,
      indicatorColor: colors.accentOrangeContainer,
      destinations: navItems.map((item) {
        return NavigationDestination(
          icon: item.unselectedIcon,
          selectedIcon: item.selectedIcon,
          label: item.label,
          tooltip: item.label,
        );
      }).toList(),
    );
  }
}
