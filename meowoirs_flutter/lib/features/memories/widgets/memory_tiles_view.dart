import 'package:flutter/material.dart';
import '../../../core/theme/meowoirs_theme.dart';
import '../../../data/models/memory.dart';
import '../../../widgets/memory_card.dart';

/// Döşeme (Tiles) View:
/// The default premium Meowoirs card view in a responsive grid.
/// Emphasizes: memory photo, cat name, memory title / short text, date,
/// cat mood sticker, localized cat mood.
class MemoryTilesView extends StatelessWidget {
  const MemoryTilesView({
    super.key,
    required this.memories,
    required this.onNavigateToMemoryDetail,
  });

  final List<Memory> memories;
  final ValueChanged<String> onNavigateToMemoryDetail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.meowoirsSpacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Responsive columns:
        // Ultra-compact (<360) -> 1 column (e.g. 320x533)
        // Standard phone (360-719) -> 2 columns (e.g. 360x800, 390x844, 412x915)
        // Tablet (720-1023) -> 3 columns
        // Desktop / Wide (>=1024) -> 4 columns
        final int columns = width < 360
            ? 1
            : (width < 720
                ? 2
                : (width < 1024
                    ? 3
                    : 4));

        if (columns == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final memory in memories)
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.medium),
                  child: MemoryCard(
                    memory: memory,
                    showCatName: true,
                    onTap: () => onNavigateToMemoryDetail(memory.id),
                  ),
                ),
            ],
          );
        }

        // Chunk memories into rows of [columns]
        final List<List<Memory>> rows = [];
        for (var i = 0; i < memories.length; i += columns) {
          final end = (i + columns < memories.length) ? i + columns : memories.length;
          rows.add(memories.sublist(i, end));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final row in rows)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < columns; i++) ...[
                      if (i > 0) SizedBox(width: spacing.medium),
                      if (i < row.length)
                        Expanded(
                          child: MemoryCard(
                            memory: row[i],
                            showCatName: true,
                            onTap: () => onNavigateToMemoryDetail(row[i].id),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox.shrink()),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
