import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_config.dart';

/// Manages persistent tracking of genuine application sessions / launches
/// for the 5–7 launch interstitial frequency cycle.
/// Direct parity with LaunchCounterManager.kt.
class LaunchCounterManager {
  LaunchCounterManager(this._prefs);

  final SharedPreferences _prefs;

  static const String keyLaunchCount = 'key_launch_count';
  static const String keyCurrentThreshold = 'key_current_threshold';
  static const String keyTotalLaunches = 'key_total_launches';

  String? _currentSessionId;

  int get launchCount => _prefs.getInt(keyLaunchCount) ?? 0;

  int get totalLifetimeLaunches => _prefs.getInt(keyTotalLaunches) ?? 0;

  int get currentThreshold {
    final saved = _prefs.getInt(keyCurrentThreshold) ?? 0;
    if (saved >= AdConfig.minLaunchThreshold &&
        saved <= AdConfig.maxLaunchThreshold) {
      return saved;
    } else {
      final newThreshold = pickRandomThreshold();
      _prefs.setInt(keyCurrentThreshold, newThreshold);
      return newThreshold;
    }
  }

  /// Records a genuine application launch.
  /// Prevents double-counting during hot reload or widget rebuilds with sessionId check.
  bool recordGenuineLaunch(String sessionId) {
    if (_currentSessionId == sessionId) {
      return isEligibleForInterstitial();
    }

    _currentSessionId = sessionId;
    final newCount = launchCount + 1;
    final newTotal = totalLifetimeLaunches + 1;

    _prefs.setInt(keyLaunchCount, newCount);
    _prefs.setInt(keyTotalLaunches, newTotal);

    return isEligibleForInterstitial();
  }

  /// Determines whether an interstitial ad is eligible to be shown.
  /// Never eligible on launches 1 through 4.
  bool isEligibleForInterstitial() {
    final count = launchCount;
    if (count < AdConfig.minLaunchThreshold) return false;
    return count >= currentThreshold;
  }

  /// Called after an interstitial ad has been successfully displayed.
  /// Resets the current cycle launch counter and chooses a new threshold between 5 and 7.
  void onInterstitialShown() {
    final nextThreshold = pickRandomThreshold();
    _prefs.setInt(keyLaunchCount, 0);
    _prefs.setInt(keyCurrentThreshold, nextThreshold);
  }

  /// Picks a random threshold between 5 and 7 inclusive.
  int pickRandomThreshold() {
    final random = Random();
    return AdConfig.minLaunchThreshold +
        random.nextInt(
          AdConfig.maxLaunchThreshold - AdConfig.minLaunchThreshold + 1,
        );
  }

  void resetForTesting() {
    _prefs.remove(keyLaunchCount);
    _prefs.remove(keyCurrentThreshold);
    _prefs.remove(keyTotalLaunches);
    _currentSessionId = null;
  }
}
