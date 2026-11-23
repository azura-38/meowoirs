import 'package:flutter/widgets.dart';
import '../../core/localization/app_localizations.dart';

/// Centralized mood definitions, resolution, localization, and sticker mapper.
class CatMoodConstants {
  static const String happy = 'Mutlu';
  static const String curious = 'Meraklı';
  static const String sleepy = 'Uykulu';
  static const String playful = 'Oyuncu';
  static const String calm = 'Sakin';
  static const String loving = 'Sevecen';

  static const List<String> canonicalCatMoods = [
    happy,
    curious,
    sleepy,
    playful,
    calm,
    loving,
  ];

  static const List<String> canonicalUserMoods = [
    'Mutlu',
    'Huzurlu',
    'Özlemli',
    'Neşeli',
    'Sakin',
    'Duygusal',
  ];
}

/// Centralized mapper for cat mood stickers.
/// Fixed mapping:
/// - Mutlu   -> assets/images/moods/cat_mood_happy.png
/// - Meraklı -> assets/images/moods/cat_mood_curious.png
/// - Uykulu  -> assets/images/moods/cat_mood_sleepy.png
/// - Oyuncu  -> assets/images/moods/cat_mood_playful.png
/// - Sakin   -> assets/images/moods/cat_mood_calm.png
/// - Sevecen -> assets/images/moods/cat_mood_loving.png
class CatMoodStickerMapper {
  static const Map<String, String> _moodToAsset = {
    CatMoodConstants.happy: 'assets/images/moods/cat_mood_happy.png',
    CatMoodConstants.curious: 'assets/images/moods/cat_mood_curious.png',
    CatMoodConstants.sleepy: 'assets/images/moods/cat_mood_sleepy.png',
    CatMoodConstants.playful: 'assets/images/moods/cat_mood_playful.png',
    CatMoodConstants.calm: 'assets/images/moods/cat_mood_calm.png',
    CatMoodConstants.loving: 'assets/images/moods/cat_mood_loving.png',
  };

  /// Returns the asset path for a canonical cat mood.
  /// Safely returns null if the mood is null, empty, or unsupported.
  static String? assetForMood(String? rawMood) {
    final canonical = resolveCatMood(rawMood);
    if (canonical == null) return null;
    return _moodToAsset[canonical];
  }

  /// Builds a sticker widget with consistent sizing and aspect ratio.
  /// If the mood cannot be resolved, returns null.
  static Widget? buildSticker({
    required String? mood,
    double size = 40.0,
    BoxFit fit = BoxFit.contain,
    bool isDecorative = true,
    AppLocalizations? l10n,
  }) {
    final assetPath = assetForMood(mood);
    if (assetPath == null) return null;

    final imageWidget = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
      excludeFromSemantics: isDecorative,
    );

    if (isDecorative || l10n == null) {
      return SizedBox(
        width: size,
        height: size,
        child: imageWidget,
      );
    }

    final localized = getLocalizedCatMood(mood, l10n);
    return Semantics(
      label: 'Cat mood: $localized',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: imageWidget,
      ),
    );
  }
}

/// Safely normalizes and resolves raw cat mood values.
/// Returns null if null, empty, whitespace, or unrecognized.
String? resolveCatMood(String? rawMood) {
  if (rawMood == null) return null;
  final trimmed = rawMood.trim();
  if (trimmed.isEmpty) return null;

  // Direct match with canonical
  if (CatMoodConstants.canonicalCatMoods.contains(trimmed)) {
    return trimmed;
  }

  // Case-insensitive fallback and English alias resolution
  final lower = trimmed.toLowerCase();
  switch (lower) {
    case 'mutlu':
    case 'happy':
      return CatMoodConstants.happy;
    case 'meraklı':
    case 'merakli':
    case 'curious':
      return CatMoodConstants.curious;
    case 'uykulu':
    case 'sleepy':
      return CatMoodConstants.sleepy;
    case 'oyuncu':
    case 'playful':
      return CatMoodConstants.playful;
    case 'sakin':
    case 'calm':
      return CatMoodConstants.calm;
    case 'sevecen':
    case 'loving':
    case 'affectionate':
      return CatMoodConstants.loving;
    default:
      return null;
  }
}

/// Safely normalizes and resolves raw user mood values.
/// Returns null if null, empty, whitespace, or unrecognized.
String? resolveUserMood(String? rawMood) {
  if (rawMood == null) return null;
  final trimmed = rawMood.trim();
  if (trimmed.isEmpty) return null;

  if (CatMoodConstants.canonicalUserMoods.contains(trimmed)) {
    return trimmed;
  }

  final lower = trimmed.toLowerCase();
  switch (lower) {
    case 'mutlu':
    case 'happy':
      return 'Mutlu';
    case 'huzurlu':
    case 'peaceful':
      return 'Huzurlu';
    case 'özlemli':
    case 'ozlemli':
    case 'nostalgic':
    case 'longing':
      return 'Özlemli';
    case 'neşeli':
    case 'neseli':
    case 'joyful':
    case 'cheerful':
      return 'Neşeli';
    case 'sakin':
    case 'calm':
      return 'Sakin';
    case 'duygusal':
    case 'emotional':
      return 'Duygusal';
    default:
      return null;
  }
}

/// Returns the localized display text for a cat mood.
/// Falls back to raw string if unrecognized.
String getLocalizedCatMood(String? rawMood, AppLocalizations l10n) {
  if (rawMood == null || rawMood.trim().isEmpty) return '';
  final canonical = resolveCatMood(rawMood);

  switch (canonical) {
    case CatMoodConstants.happy:
      return l10n.moodHappy;
    case CatMoodConstants.curious:
      return l10n.moodCurious;
    case CatMoodConstants.sleepy:
      return l10n.moodSleepy;
    case CatMoodConstants.playful:
      return l10n.moodPlayful;
    case CatMoodConstants.calm:
      return l10n.moodCalm;
    case CatMoodConstants.loving:
      return l10n.moodAffectionate;
    default:
      return rawMood;
  }
}

/// Returns the localized display text for a user mood.
/// Falls back to raw string if unrecognized.
String getLocalizedUserMood(String? rawMood, AppLocalizations l10n) {
  if (rawMood == null || rawMood.trim().isEmpty) return '';
  final canonical = resolveUserMood(rawMood);

  switch (canonical) {
    case 'Mutlu':
      return l10n.moodHappy;
    case 'Huzurlu':
      return l10n.moodPeaceful;
    case 'Özlemli':
      return l10n.moodNostalgic;
    case 'Neşeli':
      return l10n.moodJoyful;
    case 'Sakin':
      return l10n.moodCalm;
    case 'Duygusal':
      return l10n.moodEmotional;
    default:
      return rawMood;
  }
}
