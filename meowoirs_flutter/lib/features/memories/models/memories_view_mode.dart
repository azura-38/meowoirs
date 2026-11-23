/// Five explorer-style view modes for browsing memories.
/// Parity with Windows File Explorer view concept tailored for Meowoirs.
enum MemoriesViewMode {
  tiles,
  largeIcons,
  smallIcons,
  list,
  content;

  static const String keyTiles = 'tiles';
  static const String keyLargeIcons = 'large_icons';
  static const String keySmallIcons = 'small_icons';
  static const String keyList = 'list';
  static const String keyContent = 'content';

  /// Serializes the view mode to a stable string representation for local persistence.
  String toStorageString() {
    switch (this) {
      case MemoriesViewMode.tiles:
        return keyTiles;
      case MemoriesViewMode.largeIcons:
        return keyLargeIcons;
      case MemoriesViewMode.smallIcons:
        return keySmallIcons;
      case MemoriesViewMode.list:
        return keyList;
      case MemoriesViewMode.content:
        return keyContent;
    }
  }

  /// Parses a stored string value back to [MemoriesViewMode].
  /// Safely falls back to [MemoriesViewMode.tiles] on null, empty, or unrecognized values.
  static MemoriesViewMode fromString(String? raw) {
    if (raw == null) return MemoriesViewMode.tiles;
    switch (raw.trim().toLowerCase()) {
      case keyTiles:
        return MemoriesViewMode.tiles;
      case keyLargeIcons:
        return MemoriesViewMode.largeIcons;
      case keySmallIcons:
        return MemoriesViewMode.smallIcons;
      case keyList:
        return MemoriesViewMode.list;
      case keyContent:
        return MemoriesViewMode.content;
      default:
        return MemoriesViewMode.tiles;
    }
  }
}
