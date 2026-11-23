import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../services/ads/ad_manager.dart';
import 'legal_document.dart';
import 'legal_text_parser.dart';
import 'legal_text_renderer.dart';

/// Modal overlay legal document viewer dialog designed for Meowoirs.
/// Displays bundled legal documents with custom Meowoirs aesthetics,
/// scrolling, full light/dark theme support, public authoritative web links,
/// and in-flow UMP privacy options management for the Privacy Policy.
class LegalDocumentViewerDialog extends StatefulWidget {
  const LegalDocumentViewerDialog({
    super.key,
    required this.document,
  });

  final LegalDocument document;

  static Future<void> show(BuildContext context, LegalDocument document) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      useSafeArea: true,
      builder: (context) => LegalDocumentViewerDialog(document: document),
    );
  }

  @override
  State<LegalDocumentViewerDialog> createState() =>
      _LegalDocumentViewerDialogState();
}

class _LegalDocumentViewerDialogState extends State<LegalDocumentViewerDialog> {
  String? _documentText;
  bool _isLoading = true;
  bool _hasError = false;
  PrivacyOptionsRequirementStatus _privacyStatus =
      PrivacyOptionsRequirementStatus.unknown;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDocument();
        _loadPrivacyStatus();
      }
    });
  }

  Future<void> _loadPrivacyStatus() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus()
          .timeout(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _privacyStatus = status);
      }
    } catch (_) {
      // Keep unknown state — card will be hidden
    }
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final content = await DefaultAssetBundle.of(context)
          .loadString(widget.document.assetPath);
      if (mounted) {
        setState(() {
          _documentText = content;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchWebUrl() async {
    final uri = Uri.parse(widget.document.webUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  IconData _getDocumentIcon() {
    switch (widget.document) {
      case LegalDocument.privacyPolicy:
      case LegalDocument.dataDeletion:
      case LegalDocument.thirdPartyServices:
      case LegalDocument.advertisingAndConsent:
        return Icons.privacy_tip_outlined;
      case LegalDocument.termsOfService:
        return Icons.policy_outlined;
      case LegalDocument.legalDisclaimer:
        return Icons.gavel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    final documentTitle = widget.document.localizedTitle(l10n);
    final isPrivacyDoc = widget.document == LegalDocument.privacyPolicy;
    final showUmpCard = isPrivacyDoc &&
        _privacyStatus == PrivacyOptionsRequirementStatus.required;

    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 6,
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.medium,
        vertical: spacing.mediumLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 580,
          maxHeight: screenHeight * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header with Meowoirs Branding
            Container(
              padding: EdgeInsets.fromLTRB(
                spacing.mediumLarge,
                spacing.medium,
                spacing.small,
                spacing.mediumSmall,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                border: Border(
                  bottom: BorderSide(color: colors.cardBorder),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.accentOrangeContainer,
                      borderRadius: shapes.smallRadius,
                    ),
                    child: Icon(
                      _getDocumentIcon(),
                      size: 20,
                      color: colors.orange,
                    ),
                  ),
                  SizedBox(width: spacing.mediumSmall),
                  Expanded(
                    child: Text(
                      documentTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: l10n.actionBack,
                    color: colors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Body
            Flexible(
              child: _buildBody(
                context,
                colors,
                spacing,
                shapes,
                l10n,
                showUmpCard,
              ),
            ),

            // 3. Footer with External Web Link & Close Action
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.mediumLarge,
                vertical: spacing.mediumSmall,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                border: Border(
                  top: BorderSide(color: colors.cardBorder),
                ),
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _launchWebUrl,
                    icon: Icon(Icons.open_in_browser, size: 16, color: colors.orange),
                    label: Text(
                      'Web',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colors.orange,
                      ),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: shapes.mediumRadius,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.large,
                        vertical: spacing.small,
                      ),
                    ),
                    child: Text(l10n.actionBack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MeowoirsColors colors,
    MeowoirsSpacing spacing,
    MeowoirsShapes shapes,
    AppLocalizations l10n,
    bool showUmpCard,
  ) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.large),
          child: CircularProgressIndicator(color: colors.orange),
        ),
      );
    }

    if (_hasError || _documentText == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.large),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.legalDocumentLoadError,
                style: TextStyle(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.medium),
              ElevatedButton(
                onPressed: _loadDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.legalDocumentRetry),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.mediumLarge,
        vertical: spacing.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Authoritative Public Notice Card
          InkWell(
            onTap: _launchWebUrl,
            borderRadius: shapes.smallRadius,
            child: Container(
              padding: EdgeInsets.all(spacing.mediumSmall),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: shapes.smallRadius,
                border: Border.all(color: colors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIMANEX Studio Legal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.orange,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: spacing.xxSmall),
                        Text(
                          widget.document.webUrl,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 16, color: colors.textTertiary),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.medium),

          // UMP Privacy Options In-Flow Action (Conditional on actual SDK state)
          if (showUmpCard) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, size: 22, color: colors.sage),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsAdPrivacy,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.umpPrivacySubtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        AdManager.instance.showPrivacyOptions(
                          onComplete: (isAvailable, error) {
                            if (!isAvailable && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.umpNotRequired),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colors.orange,
                      ),
                      child: Text(
                        l10n.actionEdit,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.medium),
          ],

          // Parsed and Rendered Legal Content
          LegalTextRenderer(
            elements: LegalTextParser.parse(_documentText!),
          ),
          SizedBox(height: spacing.medium),
        ],
      ),
    );
  }
}
