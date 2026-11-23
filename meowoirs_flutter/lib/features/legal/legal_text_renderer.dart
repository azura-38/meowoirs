import 'package:flutter/material.dart';
import '../../core/theme/meowoirs_theme.dart';
import 'legal_text_parser.dart';

/// Renders parsed [LegalTextElement] objects with Meowoirs typography.
///
/// Uses the existing Meowoirs design language:
/// - Document title: 22–24sp, bold
/// - Section heading: 17–18sp, medium/bold
/// - Body paragraph: 15sp, readable line height
/// - Metadata: 13sp, subtle
/// - Bullet items: 14sp with indent
///
/// 24dp horizontal content padding is applied by the caller (legal viewer).
class LegalTextRenderer extends StatelessWidget {
  const LegalTextRenderer({
    super.key,
    required this.elements,
  });

  final List<LegalTextElement> elements;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;

    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final element in elements) _buildElement(context, element, colors),
        ],
      ),
    );
  }

  Widget _buildElement(
    BuildContext context,
    LegalTextElement element,
    MeowoirsColors colors,
  ) {
    return switch (element) {
      LegalDocumentTitle(text: final text) => _buildTitle(context, text, colors),
      LegalMetadata(key: final key, value: final value) =>
        _buildMetadata(context, key, value, colors),
      LegalSectionHeading(text: final text) =>
        _buildSectionHeading(context, text, colors),
      LegalParagraph(text: final text) =>
        _buildParagraph(context, text, colors),
      LegalBulletItem(text: final text, indent: final indent) =>
        _buildBulletItem(context, text, indent, colors),
    };
  }

  Widget _buildTitle(BuildContext context, String text, MeowoirsColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildMetadata(
    BuildContext context,
    String key,
    String value,
    MeowoirsColors colors,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$key: ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(
    BuildContext context,
    String text,
    MeowoirsColors colors,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildParagraph(
    BuildContext context,
    String text,
    MeowoirsColors colors,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: colors.textPrimary,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBulletItem(
    BuildContext context,
    String text,
    int indent,
    MeowoirsColors colors,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0 + (indent * 16.0),
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: colors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: colors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
