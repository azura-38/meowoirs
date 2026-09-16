import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PHASE 16.5 — FIREBASE & GOOGLE SERVICES CONFIGURATION SUITE (TD-07)', () {
    const expectedApplicationId = 'com.limanex.meowoirs';
    const expectedProjectId = 'meowoirs';

    test('1. android/app/google-services.json exists and is valid JSON', () {
      final file = File('android/app/google-services.json');
      expect(file.existsSync(), isTrue, reason: 'google-services.json must exist in android/app/');

      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      expect(json, isNotNull);
    });

    test('2. google-services.json project_id matches "meowoirs"', () {
      final file = File('android/app/google-services.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final projectInfo = json['project_info'] as Map<String, dynamic>;

      expect(projectInfo['project_id'], equals(expectedProjectId));
      expect(projectInfo['project_number'], equals('327952023374'));
    });

    test('3. google-services.json package_name matches "com.limanex.meowoirs"', () {
      final file = File('android/app/google-services.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final clients = json['client'] as List<dynamic>;

      expect(clients, isNotEmpty);
      final firstClient = clients[0] as Map<String, dynamic>;
      final clientInfo = firstClient['client_info'] as Map<String, dynamic>;
      final androidClientInfo = clientInfo['android_client_info'] as Map<String, dynamic>;

      expect(androidClientInfo['package_name'], equals(expectedApplicationId));
    });

    test('4. android/app/build.gradle.kts configures applicationId = "com.limanex.meowoirs"', () {
      final file = File('android/app/build.gradle.kts');
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();
      expect(
        content.contains('applicationId = "com.limanex.meowoirs"'),
        isTrue,
        reason: 'Android applicationId must be com.limanex.meowoirs',
      );
      expect(
        content.contains('namespace = "com.limanex.meowoirs"'),
        isTrue,
        reason: 'Android namespace must be com.limanex.meowoirs',
      );
    });

    test('5. android/settings.gradle.kts and app/build.gradle.kts apply Google Services and Crashlytics plugins', () {
      final settingsFile = File('android/settings.gradle.kts');
      expect(settingsFile.existsSync(), isTrue);
      final settingsContent = settingsFile.readAsStringSync();
      expect(settingsContent.contains('com.google.gms.google-services'), isTrue);
      expect(settingsContent.contains('com.google.firebase.crashlytics'), isTrue);

      final appGradleFile = File('android/app/build.gradle.kts');
      expect(appGradleFile.existsSync(), isTrue);
      final appGradleContent = appGradleFile.readAsStringSync();
      expect(appGradleContent.contains('id("com.google.gms.google-services")'), isTrue);
      expect(appGradleContent.contains('id("com.google.firebase.crashlytics")'), isTrue);
    });

    test('6. android/app/build.gradle.kts specifies compileSdk 36, minSdk 26, targetSdk 36', () {
      final appGradleFile = File('android/app/build.gradle.kts');
      expect(appGradleFile.existsSync(), isTrue);
      final content = appGradleFile.readAsStringSync();
      expect(content.contains('compileSdk = 36'), isTrue);
      expect(content.contains('minSdk = 26'), isTrue);
      expect(content.contains('targetSdk = 36'), isTrue);
    });
  });
}
