import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Minimal, privacy-compliant Crashlytics wrapper for Meowoirs.
/// Strictly captures technical crashes without recording any user personal data,
/// cat names, notes, memories, or user identifiers.
class CrashlyticsService {
  CrashlyticsService._();

  static final CrashlyticsService instance = CrashlyticsService._();

  bool _isInitialized = false;

  /// Whether Crashlytics has been successfully initialized.
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    try {
      // Check if Firebase default app options exist before initializing
      if (Firebase.apps.isEmpty) {
        // Will initialize if google-services.json / GoogleService-Info.plist is bundled
        await Firebase.initializeApp();
      }

      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Ensure collection is enabled only in release builds
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);

      _isInitialized = true;
    } catch (e) {
      debugPrint('CrashlyticsService: initialization skipped or failed: $e');
    }
  }

  /// In-memory diagnostic error tracking for Debug Center & Bug Reporting
  String? lastError;
  String? lastErrorType;
  String? lastErrorMessage;
  String? lastStackTrace;
  DateTime? lastErrorTimestamp;
  int errorCount = 0;

  void recordDebugError(dynamic error, StackTrace? stack) {
    errorCount++;
    lastError = error.toString();
    lastErrorType = error.runtimeType.toString();
    lastErrorMessage = error.toString();
    lastStackTrace = stack?.toString();
    lastErrorTimestamp = DateTime.now();
  }

  /// Records a non-fatal technical error without any user personal data.
  Future<void> recordNonFatal(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    recordDebugError(exception, stack);
    if (!_isInitialized) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (_) {}
  }

  /// Alias for [recordNonFatal] to record non-fatal technical errors safely.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) =>
      recordNonFatal(exception, stack, reason: reason);
}
