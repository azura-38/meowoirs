import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/theme/meowoirs_theme.dart';
import 'ad_manager.dart';

/// High-performance, lifecycle-aware Banner Ad component for Meowoirs.
/// Displays an AdMob 320x50 banner in a visually harmonious container when loaded.
/// Collapses cleanly to 0 height when loading, unready, or on failure (never showing fake ads).
/// Direct parity with MeowoirsBannerAd.kt.
class MeowoirsBannerAd extends StatefulWidget {
  const MeowoirsBannerAd({super.key});

  @override
  State<MeowoirsBannerAd> createState() => _MeowoirsBannerAdState();
}

class _MeowoirsBannerAdState extends State<MeowoirsBannerAd> {
  @override
  void initState() {
    super.initState();
    AdManager.instance.preloadBanner();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return const SizedBox.shrink();
    }

    final colors = context.meowoirsColors;

    return ValueListenableBuilder<BannerState>(
      valueListenable: AdManager.instance.bannerStateNotifier,
      builder: (context, state, _) {
        final isLoaded = state == BannerState.loaded &&
            AdManager.instance.activeBannerAd != null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isLoaded ? 58.0 : 0.0,
          width: double.infinity,
          color: colors.cream,
          child: isLoaded
              ? Center(
                  child: SizedBox(
                    width: AdManager.instance.activeBannerAd!.size.width.toDouble(),
                    height: AdManager.instance.activeBannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: AdManager.instance.activeBannerAd!),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
