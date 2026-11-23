/// Lightweight parser for Meowoirs legal document TXT files.
///
/// Transforms raw legal text (containing `====` / `----` separators,
/// section headings, metadata key:value lines, and body paragraphs)
/// into structured [LegalTextElement] objects for styled rendering.
///
/// IMPORTANT: This parser does NOT modify legal meaning or content.
/// It only classifies lines for presentation purposes.
library;

/// Base type for parsed legal document elements.
sealed class LegalTextElement {
  const LegalTextElement();
}

/// The document title (first significant non-empty line).
class LegalDocumentTitle extends LegalTextElement {
  const LegalDocumentTitle(this.text);
  final String text;
}

/// Metadata key-value pair (e.g., "Developer / Operator: LIMANEX").
class LegalMetadata extends LegalTextElement {
  const LegalMetadata(this.key, this.value);
  final String key;
  final String value;
}

/// Section heading (e.g., "1. INTRODUCTION & SCOPE").
class LegalSectionHeading extends LegalTextElement {
  const LegalSectionHeading(this.text);
  final String text;
}

/// Body paragraph text.
class LegalParagraph extends LegalTextElement {
  const LegalParagraph(this.text);
  final String text;
}

/// Bullet/list item (lines starting with "- " or numbered sub-items).
class LegalBulletItem extends LegalTextElement {
  const LegalBulletItem(this.text, {this.indent = 0});
  final String text;
  final int indent;
}

/// Parser that converts raw legal TXT content into structured elements.
class LegalTextParser {
  LegalTextParser._();

  /// Regex matching raw ASCII separator lines (====, ----, etc.).
  static final RegExp _separatorPattern = RegExp(r'^[=\-]{4,}\s*$');

  /// Regex matching numbered section headings like "1. TITLE" or "12. TITLE".
  static final RegExp _sectionHeadingPattern =
      RegExp(r'^\d+\.\s+[A-ZÇĞIÖŞÜ\s&\-,/()]+$');

  /// Regex matching metadata key:value lines like "Developer / Operator: LIMANEX".
  static final RegExp _metadataPattern =
      RegExp(r'^([A-Za-zÀ-ÿçğıöşüÇĞİÖŞÜ\s/&\-()]+):\s+(.+)$');

  /// Regex matching bullet items starting with "- " or "  - ".
  static final RegExp _bulletPattern = RegExp(r'^(\s*)[-•]\s+(.+)$');

  /// Regex matching numbered list items like "1. Item text" but NOT section headings.
  static final RegExp _numberedItemPattern =
      RegExp(r'^(\s*)\d+\.\s+(?![A-ZÇĞIÖŞÜ\s&\-,/()]+$)(.+)$');

  /// Parse raw legal document text into structured elements.
  static List<LegalTextElement> parse(String rawText) {
    final lines = rawText.split('\n');
    final elements = <LegalTextElement>[];

    bool titleFound = false;
    bool pastMetadataBlock = false;
    final paragraphBuffer = StringBuffer();

    void flushParagraph() {
      if (paragraphBuffer.isNotEmpty) {
        elements.add(LegalParagraph(paragraphBuffer.toString().trim()));
        paragraphBuffer.clear();
      }
    }

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trimRight();

      // Skip raw separator lines entirely
      if (_separatorPattern.hasMatch(trimmed)) {
        continue;
      }

      // Skip empty lines (flush any buffered paragraph)
      if (trimmed.isEmpty) {
        flushParagraph();
        continue;
      }

      // Document title: first non-empty, non-separator line
      if (!titleFound) {
        flushParagraph();
        elements.add(LegalDocumentTitle(trimmed));
        titleFound = true;
        continue;
      }

      // Section heading detection (numbered ALL-CAPS titles)
      if (_sectionHeadingPattern.hasMatch(trimmed)) {
        flushParagraph();
        elements.add(LegalSectionHeading(trimmed));
        pastMetadataBlock = true;
        continue;
      }

      // Metadata detection (only before first section heading)
      if (!pastMetadataBlock) {
        final metaMatch = _metadataPattern.firstMatch(trimmed);
        if (metaMatch != null) {
          flushParagraph();
          elements.add(LegalMetadata(
            metaMatch.group(1)!.trim(),
            metaMatch.group(2)!.trim(),
          ));
          continue;
        }
      }

      // Bullet item detection
      final bulletMatch = _bulletPattern.firstMatch(line);
      if (bulletMatch != null) {
        flushParagraph();
        final indent = bulletMatch.group(1)!.length ~/ 2;
        elements.add(LegalBulletItem(
          bulletMatch.group(2)!.trim(),
          indent: indent,
        ));
        continue;
      }

      // Numbered sub-item detection (within body, not ALL-CAPS headings)
      final numberedMatch = _numberedItemPattern.firstMatch(line);
      if (numberedMatch != null && pastMetadataBlock) {
        flushParagraph();
        final indent = numberedMatch.group(1)!.length ~/ 2;
        // Keep the full line text including the number
        elements.add(LegalBulletItem(
          trimmed.trim(),
          indent: indent,
        ));
        continue;
      }

      // Regular paragraph text — buffer consecutive lines
      if (paragraphBuffer.isNotEmpty) {
        paragraphBuffer.write(' ');
      }
      paragraphBuffer.write(trimmed);
    }

    // Flush any remaining paragraph
    flushParagraph();

    return elements;
  }
}
