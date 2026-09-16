enum AppThemeMode {
  system,
  light,
  dark;

  static AppThemeMode fromString(String? value) {
    return switch (value?.toUpperCase()) {
      'LIGHT' => AppThemeMode.light,
      'DARK' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }

  String toStorageString() => switch (this) {
    AppThemeMode.light => 'LIGHT',
    AppThemeMode.dark => 'DARK',
    AppThemeMode.system => 'SYSTEM',
  };
}
