import 'package:flutter/material.dart';
import '../../../data/models/memory.dart';
import '../models/memories_view_mode.dart';
import 'memory_content_view.dart';
import 'memory_large_icons_view.dart';
import 'memory_list_view.dart';
import 'memory_small_icons_view.dart';
import 'memory_tiles_view.dart';

/// Renders the active layout among the 5 explorer-style view modes.
class MemoriesViewSwitcher extends StatelessWidget {
  const MemoriesViewSwitcher({
    super.key,
    required this.viewMode,
    required this.memories,
    required this.onNavigateToMemoryDetail,
  });

  final MemoriesViewMode viewMode;
  final List<Memory> memories;
  final ValueChanged<String> onNavigateToMemoryDetail;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: KeyedSubtree(
        key: ValueKey(viewMode),
        child: _buildCurrentView(),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (viewMode) {
      case MemoriesViewMode.tiles:
        return MemoryTilesView(
          memories: memories,
          onNavigateToMemoryDetail: onNavigateToMemoryDetail,
        );
      case MemoriesViewMode.largeIcons:
        return MemoryLargeIconsView(
          memories: memories,
          onNavigateToMemoryDetail: onNavigateToMemoryDetail,
        );
      case MemoriesViewMode.smallIcons:
        return MemorySmallIconsView(
          memories: memories,
          onNavigateToMemoryDetail: onNavigateToMemoryDetail,
        );
      case MemoriesViewMode.list:
        return MemoryListView(
          memories: memories,
          onNavigateToMemoryDetail: onNavigateToMemoryDetail,
        );
      case MemoriesViewMode.content:
        return MemoryContentView(
          memories: memories,
          onNavigateToMemoryDetail: onNavigateToMemoryDetail,
        );
    }
  }
}
