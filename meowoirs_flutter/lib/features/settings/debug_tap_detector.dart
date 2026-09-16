/// Detects a sequence of rapid taps within a defined time window.
/// Direct parity with Kotlin DebugTapDetector.kt.
///
/// Rules:
/// - Exactly [requiredTaps] (default 10) taps within approximately [windowMillis] (default 4000ms).
/// - The time window starts on the first tap of a sequence.
/// - If the elapsed time between the current tap and the first tap exceeds [windowMillis],
///   the counter resets and the current tap counts as the first tap of a new attempt.
/// - When [requiredTaps] is reached within the window, it returns true and immediately resets.
/// - Accidental taps or slow taps never unlock the panel.
class DebugTapDetector {
  DebugTapDetector({
    this.requiredTaps = 10,
    this.windowMillis = 4000,
  });

  final int requiredTaps;
  final int windowMillis;

  int _tapCount = 0;
  int _firstTapTimestamp = 0;

  int get currentTapCount => _tapCount;

  /// Registers a tap.
  /// @param nowMillis The timestamp of the tap (defaults to DateTime.now().millisecondsSinceEpoch).
  /// @return true if the required number of taps was achieved within the time window.
  bool onUserTap([int? nowMillis]) {
    final now = nowMillis ?? DateTime.now().millisecondsSinceEpoch;

    if (_firstTapTimestamp == 0 || (now - _firstTapTimestamp) > windowMillis) {
      _firstTapTimestamp = now;
      _tapCount = 1;
      return false;
    }

    _tapCount++;
    if (_tapCount >= requiredTaps) {
      reset();
      return true;
    }

    return false;
  }

  /// Resets the tap state.
  void reset() {
    _tapCount = 0;
    _firstTapTimestamp = 0;
  }
}
