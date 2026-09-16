import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import 'legal_document.dart';

/// Modal popup overlay legal document viewer dialog.
/// Displays local plain-text legal assets within a floating centered modal
/// without full-screen navigation takeover.
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadDocument();
    });
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final content =
          await DefaultAssetBundle.of(context).loadString(widget.document.assetPath);
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

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    final documentTitle = widget.document.localizedTitle(l10n);

    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 8,
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.medium,
        vertical: spacing.medium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: screenHeight * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.mediumLarge,
                spacing.medium,
                spacing.small,
                spacing.mediumSmall,
              ),
              child: Row(
                children: [
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
            Divider(height: 1, thickness: 1, color: colors.cardBorder),

            // 2. Scrollable Body
            Flexible(
              child: _buildBody(context, colors, spacing, shapes, l10n),
            ),

            // 3. Footer
            Divider(height: 1, thickness: 1, color: colors.cardBorder),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.mediumLarge,
                vertical: spacing.mediumSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: shapes.mediumRadius,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.mediumLarge,
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
          Container(
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
              ],
            ),
          ),
          SizedBox(height: spacing.medium),

          // Plain Text Content with High Readability
          SelectableText(
            _documentText!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colors.textPrimary,
                ),
          ),
          SizedBox(height: spacing.medium),
        ],
      ),
    );
  }
}
