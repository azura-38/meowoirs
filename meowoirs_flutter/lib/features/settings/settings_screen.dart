import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/supported_languages.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/providers/database_provider.dart';
import '../../services/ads/ad_manager.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/subtle_motion.dart';
import '../debug/debug_center_screen.dart';
import '../legal/legal_document.dart';
import '../legal/legal_document_viewer.dart';
import 'debug_tap_detector.dart';

/// SettingsScreen: Appearance, Privacy & Legal, Language, Reach Us, and App Info.
/// Direct parity with SettingsScreen.kt.
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
    _debugTapDetector = DebugTapDetector(requiredTaps: 10, windowMillis: 4000);
  }

  void _handleAppInfoTap(AppLocalizations loc) {
    if (!kDebugMode || !AppConfig.meowoirsDebugPanelEnabled) return;

    final isUnlocked = _debugTapDetector.onUserTap();
    if (isUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.debugPanelUnlocked),
          duration: const Duration(seconds: 2),
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
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.settingsTheme),
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
            child: Text(loc.profileCancel),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(String currentLangCode, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.settingsLanguage),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = supportedLanguages[index];
              final isSelected = lang.code == currentLangCode;

              return ListTile(
                title: Text(
                  lang.displayName,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary)
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
            child: Text(loc.profileCancel),
          ),
        ],
      ),
    );
  }

  void _showReachUsDialog(AppLocalizations loc) {
    final colors = context.meowoirsColors;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.mail_outline, size: 32, color: colors.orange),
        title: Text(
          loc.reachUsThankYouTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              loc.reachUsThankYouDesc,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
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
                minimumSize: const Size(double.infinity, 44),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _sendEmail(
                  'Meowoirs Bug Report',
                  'App Version: ${AppConfig.versionName} (${AppConfig.versionCode})\nDevice: \n\nDescription of issue:\n',
                  loc,
                );
              },
              child: Text(loc.reachUsActionBug),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _sendEmail('Meowoirs Contact', '', loc);
              },
              child: Text(loc.reachUsActionContact),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.legalDocumentClose),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail(String subject, String body, AppLocalizations loc) async {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          tooltip: loc.actionBack,
          onPressed: widget.onBack,
        ),
        title: Text(
          loc.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SubtleContentEntrance(
          child: ListView(
            padding: EdgeInsets.all(spacing.medium),
            children: [
              // 1. Görünüm (Appearance)
              _SettingsSection(
                title: loc.settingsAppearance,
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

              // 2. Gizlilik ve Yasal (Privacy & Legal)
              _SettingsSection(
                title: loc.settingsPrivacyLegal,
                children: [
                  _SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    label: loc.settingsPrivacyPolicy,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.privacyPolicy,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1),
                  _SettingsRow(
                    icon: Icons.policy_outlined,
                    label: loc.settingsTermsOfService,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.termsOfService,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1),
                  _SettingsRow(
                    icon: Icons.info_outline,
                    label: loc.legalDataDeletion,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.dataDeletion,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1),
                  _SettingsRow(
                    icon: Icons.shield_outlined,
                    label: loc.legalThirdParty,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.thirdPartyServices,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1),
                  _SettingsRow(
                    icon: Icons.security_outlined,
                    label: loc.legalAdvertisingConsent,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.advertisingAndConsent,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1),
                  _SettingsRow(
                    icon: Icons.gavel_outlined,
                    label: loc.legalDisclaimer,
                    onTap: () => LegalDocumentViewerDialog.show(
                      context,
                      LegalDocument.legalDisclaimer,
                    ),
                  ),
                  Divider(color: colors.cardBorder, height: 1),
                  _SettingsRow(
                    icon: Icons.security_outlined,
                    label: loc.settingsAdPrivacy,
                    onTap: () {
                      AdManager.instance.showPrivacyOptions(
                        onComplete: (isAvailable, error) {
                          if (!isAvailable && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loc.umpNotRequired),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: spacing.large),

              // 3. Dil (Language)
              _SettingsSection(
                title: loc.settingsLanguage,
                children: [
                  _SettingsRow(
                    icon: Icons.language_outlined,
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
                children: [
                  _SettingsRow(
                    icon: Icons.mail_outline,
                    label: loc.settingsReachUs,
                    onTap: () => _showReachUsDialog(loc),
                  ),
                ],
              ),
              SizedBox(height: spacing.large),

              // 5. Uygulama Bilgisi (Application & Debug Tap Detector)
              _SettingsSection(
                title: loc.settingsApp,
                children: [
                  InkWell(
                    onTap: () => _handleAppInfoTap(loc),
                    borderRadius: shapes.largeRadius,
                    child: Padding(
                      padding: EdgeInsets.all(spacing.medium),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.accentOrangeContainer,
                              borderRadius: shapes.mediumRadius,
                            ),
                            child: Icon(
                              Icons.pets_outlined,
                              size: 24,
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
                ],
              ),
              SizedBox(height: spacing.large),
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
    required this.children,
  });

  final String title;
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
          padding: EdgeInsets.only(left: spacing.extraSmall),
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.orange,
                  ),
            ),
          ),
        ),
        SizedBox(height: spacing.small),
        MeowoirsCard(
          shape: shapes.largeShape,
          padding: EdgeInsets.zero,
          child: Column(
            children: children,
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
              Icon(icon, size: 22, color: colors.textSecondary),
              SizedBox(width: spacing.medium),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
    return Semantics(
      selected: isSelected,
      child: ListTile(
        title: Text(label),
        trailing: isSelected
            ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
