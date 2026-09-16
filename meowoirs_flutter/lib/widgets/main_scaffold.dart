import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routing/route_ui_policy.dart';
import '../core/theme/meowoirs_theme.dart';
import '../services/ads/ad_manager.dart';
import '../services/ads/meowoirs_banner_ad.dart';
import 'meowoirs_bottom_navigation.dart';
import 'meowoirs_fab.dart';
import 'meowoirs_top_bar.dart';

/// Main application shell scaffolding TopBar, BottomNav, FAB, and content host.
/// Exact parity with MainScaffold.kt.
class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
    required this.currentLocation,
    this.navigationShell,
  });

  final Widget child;
  final String currentLocation;
  final StatefulNavigationShell? navigationShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final isTopLevel = RouteUiPolicy.isTopLevel(currentLocation);
    final showBottomNav = RouteUiPolicy.shouldShowBottomNav(currentLocation);
    final showFab = RouteUiPolicy.shouldShowFab(currentLocation);
    final showBanner = RouteUiPolicy.shouldShowBannerAd(currentLocation);
    final title = RouteUiPolicy.getTitle(context, currentLocation);

    if (isTopLevel) {
      AdManager.instance.checkAndShowLaunchInterstitial();
    }

    return Scaffold(
      backgroundColor: colors.cream,
      appBar: MeowoirsTopBar(
        title: title,
        canNavigateBack: !isTopLevel,
        onNavigateBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      ),
      body: SafeArea(
        top: false, // AppBar handles top safe area
        bottom: !showBottomNav, // BottomNav handles bottom safe area when visible
        child: Column(
          children: [
            if (showBanner) const MeowoirsBannerAd(),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? MeowoirsBottomNavigation(
              currentRoute: currentLocation,
              onNavigateToRoute: (route) {
                if (navigationShell != null) {
                  final index = switch (route) {
                    '/' || '/home' => 0,
                    '/cats' => 1,
                    '/memories' => 2,
                    '/profile' => 3,
                    _ => 0,
                  };
                  navigationShell!.goBranch(
                    index,
                    initialLocation: index == navigationShell!.currentIndex,
                  );
                } else if (currentLocation != route) {
                  context.go(route);
                }
              },
            )
          : null,
      floatingActionButton: showFab
          ? MeowoirsFab(
              onPressed: () {
                context.push('/add_memory');
              },
            )
          : null,
    );
  }
}
