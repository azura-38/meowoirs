import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/supported_languages.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/providers/database_provider.dart';
import '../../services/ads/ad_manager.dart';
import '../../services/crashlytics/crashlytics_service.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/subtle_motion.dart';
import '../debug/debug_center_screen.dart';
import '../legal/legal_document.dart';
import '../legal/legal_document_viewer.dart';
import 'debug_tap_detector.dart';

/// SettingsScreen: Appearance, Privacy & Legal, Language, Reach Us, and Application Info.
/// Redesigned to reflect the premium personal cat memory archive aesthetic.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final DebugTapDetector _debugTapDetector;

  @override
  void initState() {
    super.initState();
    // 7 taps within 5000ms for hidden release-safe debug access
    _debugTapDetector = DebugTapDetector(requiredTaps: 7, windowMillis: 5000);
  }

  void _handleAppInfoTap(AppLocalizations loc) {
    if (!AppConfig.meowoirsDebugPanelEnabled) return;

    final isUnlocked = _debugTapDetector.onUserTap();
    if (isUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.debugPanelUnlocked),
          duration: const Duration(seconds: 2),
          backgroundColor: context.meowoirsColors.orange,
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DebugCenterScreen(),
        ),
      );
    }
  }

  void _showThemeDialog(AppThemeMode currentMode, AppLocalizations loc) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: shapes.extraLargeRadius),
        title: Text(
          loc.settingsTheme,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              label: loc.themeSystem,
              isSelected: currentMode == AppThemeMode.system,
              onTap: () {
                ref
                    .read(preferencesRepositoryProvider)
                    .setThemeMode(AppThemeMode.system);
                Navigator.of(dialogContext).pop();
              },
            ),
            _ThemeOption(
              label: loc.themeLight,
              isSelected: currentMode == AppThemeMode.light,
              onTap: () {
                ref
                    .read(preferencesRepositoryProvider)
                    .setThemeMode(AppThemeMode.light);
                Navigator.of(dialogContext).pop();
              },
            ),
            _ThemeOption(
              label: loc.themeDark,
              isSelected: currentMode == AppThemeMode.dark,
              onTap: () {
                ref
                    .read(preferencesRepositoryProvider)
                    .setThemeMode(AppThemeMode.dark);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              loc.profileCancel,
              style: TextStyle(color: colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(String currentLangCode, AppLocalizations loc) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: shapes.extraLargeRadius),
        title: Text(
          loc.settingsLanguage,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = supportedLanguages[index];
              final isSelected = lang.code == currentLangCode;

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.mediumRadius,
                ),
                title: Text(
                  lang.displayName,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? colors.orange : colors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: colors.orange)
                    : null,
                onTap: () {
                  ref
                      .read(preferencesRepositoryProvider)
                      .setLanguageCode(lang.code);
                  Navigator.of(dialogContext).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              loc.profileCancel,
              style: TextStyle(color: colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  void _showReachUsDialog(AppLocalizations loc) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: shapes.extraLargeRadius),
        icon: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colors.accentOrangeContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mail_outline, size: 28, color: colors.orange),
        ),
        title: Text(
          loc.reachUsThankYouTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              loc.reachUsThankYouDesc,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.mediumRadius,
                ),
                minimumSize: const Size(double.infinity, 46),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _sendEmail('Meowoirs Suggestion', '', loc);
              },
              child: Text(loc.reachUsActionSuggestion),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.textPrimary,
                side: BorderSide(color: colors.cardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.mediumRadius,
                ),
                minimumSize: const Size(double.infinity, 46),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _handleBugReport(loc);
              },
              child: Text(loc.reachUsActionBug),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _sendEmail('Meowoirs Contact', '', loc);
              },
              child: Text(
                loc.reachUsActionContact,
                style: TextStyle(color: colors.orange),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              loc.legalDocumentClose,
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBugReport(AppLocalizations loc) async {
    String manufacturer = 'Unknown';
    String model = 'Unknown';
    String osVersion = Platform.operatingSystemVersion;

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        manufacturer = androidInfo.manufacturer;
        model = androidInfo.model;
        osVersion =
            'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        manufacturer = 'Apple';
        model = iosInfo.utsname.machine;
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }
    } catch (_) {
      // Fallback to platform properties
    }

    final crashService = CrashlyticsService.instance;
    final lastErrorType = crashService.lastErrorType ?? 'None';
    final lastErrorMsg =
        crashService.lastErrorMessage ?? 'No recent crash recorded';
    final lastErrorTime =
        crashService.lastErrorTimestamp?.toIso8601String() ?? 'None';

    final adManager = AdManager.instance;
    final adMobInitialized = adManager.isMobileAdsInitialized ? 'YES' : 'NO';
    final canRequestAds = adManager.canRequestAds ? 'YES' : 'NO';
    final bannerState = adManager.bannerState.name;

    String umpState = 'Unknown';
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final consentStatus =
            await ConsentInformation.instance.getConsentStatus();
        umpState = consentStatus.name;
      } catch (_) {}
    }

    final body = StringBuffer()
      ..writeln('App Version: ${AppConfig.versionName}')
      ..writeln('Build: ${AppConfig.versionCode}')
      ..writeln('Platform: ${Platform.operatingSystem}')
      ..writeln('Device Manufacturer: $manufacturer')
      ..writeln('Device Model: $model')
      ..writeln('OS Version: $osVersion')
      ..writeln()
      ..writeln('Last Error:')
      ..writeln('Error Type: $lastErrorType')
      ..writeln('Error Message: $lastErrorMsg')
      ..writeln('Timestamp: $lastErrorTime')
      ..writeln()
      ..writeln('AdMob:')
      ..writeln('Initialized: $adMobInitialized')
      ..writeln('canRequestAds: $canRequestAds')
      ..writeln('Banner State: $bannerState')
      ..writeln('UMP Consent State: $umpState')
      ..writeln()
      ..writeln('Description of issue:')
      ..writeln();

    await _sendEmail('Meowoirs Bug Report', body.toString(), loc);
  }

  Future<void> _sendEmail(
      String subject, String body, AppLocalizations loc) async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppConfig.supportEmail,
      queryParameters: {
        'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.reachUsNoEmailApp),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.reachUsNoEmailApp),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    final themeMode =
        ref.watch(themeModeStreamProvider).value ?? AppThemeMode.system;
    final prefs = ref.watch(preferencesRepositoryProvider);
    final currentLangCode = prefs.languageCode;
    final currentLang = supportedLanguages
        .firstWhere((l) => l.code == currentLangCode,
            orElse: () => supportedLanguages.first)
        .displayName;

    final themeLabel = switch (themeMode) {
      AppThemeMode.system => loc.themeSystem,
      AppThemeMode.light => loc.themeLight,
      AppThemeMode.dark => loc.themeDark,
    };

    final versionString = loc.versionBuildFormat(
      AppConfig.versionName,
      AppConfig.versionCode,
    );

    return Scaffold(
      backgroundColor: colors.cream,
      appBar: AppBar(
        backgroundColor: colors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          tooltip: loc.actionBack,
          onPressed: widget.onBack,
        ),
        title: Text(
          loc.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SubtleContentEntrance(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.medium,
              vertical: spacing.small,
            ),
            children: [
              // 1. Görünüm (Appearance)
              _SettingsSection(
                title: loc.settingsAppearance,
                icon: Icons.palette_outlined,
                children: [
                  _SettingsRow(
                    icon: Icons.color_lens_outlined,
                    label: loc.settingsTheme,
                    value: themeLabel,
                    onTap: () => _showThemeDialog(themeMode, loc),
                  ),
                ],
              ),
              SizedBox(height: spacing.large),

              // 2. Gizlilik ve Yasal (Privacy & Legal) — STRICTLY ONLY 3 PRIMARY DOCUMENTS
              _SettingsSection(
                title: loc.settingsPrivacyLegal,
                icon: Icons.shield_outlined,
                children: [
                  _SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    label: loc.settingsPrivacyPolicy,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.privacyPolicy,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1, indent: 56),
                  _SettingsRow(
                    icon: Icons.policy_outlined,
                    label: loc.settingsTermsOfService,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.termsOfService,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1, indent: 56),
                  _SettingsRow(
                    icon: Icons.gavel_outlined,
                    label: loc.legalDisclaimer,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.legalDisclaimer,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.large),

              // 3. Dil (Language)
              _SettingsSection(
                title: loc.settingsLanguage,
                icon: Icons.language_outlined,
                children: [
                  _SettingsRow(
                    icon: Icons.translate_outlined,
                    label: loc.settingsAppLanguage,
                    value: currentLang,
                    onTap: () => _showLanguageDialog(currentLangCode, loc),
                  ),
                ],
              ),
              SizedBox(height: spacing.large),

              // 4. Bize Ulaşın (Reach Us)
              _SettingsSection(
                title: loc.settingsReachUs,
                icon: Icons.support_agent_outlined,
                children: [
                  _SettingsRow(
                    icon: Icons.chat_bubble_outline,
                    label: loc.settingsReachUs,
                    onTap: () => _showReachUsDialog(loc),
                  ),
                ],
              ),
              SizedBox(height: spacing.large),

              // 5. Uygulama Bilgisi (Application & Hidden 7-Tap Debug Detector)
              _SettingsSection(
                title: loc.settingsApp,
                icon: Icons.info_outline,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleAppInfoTap(loc),
                      borderRadius: shapes.largeRadius,
                      child: Padding(
                        padding: EdgeInsets.all(spacing.medium),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: colors.accentOrangeContainer,
                                borderRadius: shapes.mediumRadius,
                                border: Border.all(
                                  color: colors.orange.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.pets,
                                size: 26,
                                color: colors.orange,
                              ),
                            ),
                            SizedBox(width: spacing.medium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meowoirs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                        ),
                                  ),
                                  SizedBox(height: spacing.xxSmall),
                                  Text(
                                    versionString,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: colors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.extraLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: spacing.small, bottom: spacing.small),
          child: Row(
            children: [
              Icon(icon, size: 16, color: colors.orange),
              SizedBox(width: spacing.extraSmall),
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: colors.orange,
                      ),
                ),
              ),
            ],
          ),
        ),
        MeowoirsCard(
          shape: shapes.largeShape,
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: shapes.largeRadius,
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;

    return Semantics(
      button: true,
      label: value != null ? '$label, $value' : label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.largeRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.medium,
              vertical: spacing.medium,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: shapes.smallRadius,
                  ),
                  child: Icon(icon, size: 20, color: colors.sage),
                ),
                SizedBox(width: spacing.medium),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                  ),
                ),
                if (value != null) ...[
                  Text(
                    value!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                  SizedBox(width: spacing.extraSmall),
                ],
                Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;

    return Semantics(
      selected: isSelected,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: shapes.mediumRadius),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? colors.orange : colors.textPrimary,
          ),
        ),
        trailing: isSelected ? Icon(Icons.check, color: colors.orange) : null,
        onTap: onTap,
      ),
    );
  }
}
