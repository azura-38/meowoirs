import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowoirs/core/localization/app_localizations.dart';
import 'package:meowoirs/features/memories/mood_helper.dart';

void main() {
  group('Mood Helper & CatMoodStickerMapper Tests', () {
    test('1. Cat mood constants and canonical values', () {
      expect(CatMoodConstants.canonicalCatMoods, [
        'Mutlu',
        'Meraklı',
        'Uykulu',
        'Oyuncu',
        'Sakin',
        'Sevecen',
      ]);
      expect(CatMoodConstants.canonicalUserMoods, [
        'Mutlu',
        'Huzurlu',
        'Özlemli',
        'Neşeli',
        'Sakin',
        'Duygusal',
      ]);
    });

    test('2. CatMoodStickerMapper returns exact 6 fixed asset paths', () {
      expect(
        CatMoodStickerMapper.assetForMood('Mutlu'),
        'assets/images/moods/cat_mood_happy.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Meraklı'),
        'assets/images/moods/cat_mood_curious.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Uykulu'),
        'assets/images/moods/cat_mood_sleepy.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Oyuncu'),
        'assets/images/moods/cat_mood_playful.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Sakin'),
        'assets/images/moods/cat_mood_calm.png',
      );
      expect(
        CatMoodStickerMapper.assetForMood('Sevecen'),
        'assets/images/moods/cat_mood_loving.png',
      );
    });

    test('3. CatMoodStickerMapper safe null and unknown handling', () {
      expect(CatMoodStickerMapper.assetForMood(null), isNull);
      expect(CatMoodStickerMapper.assetForMood(''), isNull);
      expect(CatMoodStickerMapper.assetForMood('   '), isNull);
      expect(CatMoodStickerMapper.assetForMood('Bilinmeyen'), isNull);
      expect(CatMoodStickerMapper.assetForMood('Angry'), isNull);
    });

    test('4. resolveCatMood normalizes canonical and English aliases safely', () {
      expect(resolveCatMood('Mutlu'), 'Mutlu');
      expect(resolveCatMood('mutlu'), 'Mutlu');
      expect(resolveCatMood('happy'), 'Mutlu');
      expect(resolveCatMood('Meraklı'), 'Meraklı');
      expect(resolveCatMood('merakli'), 'Meraklı');
      expect(resolveCatMood('curious'), 'Meraklı');
      expect(resolveCatMood('Uykulu'), 'Uykulu');
      expect(resolveCatMood('sleepy'), 'Uykulu');
      expect(resolveCatMood('Oyuncu'), 'Oyuncu');
      expect(resolveCatMood('playful'), 'Oyuncu');
      expect(resolveCatMood('Sakin'), 'Sakin');
      expect(resolveCatMood('calm'), 'Sakin');
      expect(resolveCatMood('Sevecen'), 'Sevecen');
      expect(resolveCatMood('loving'), 'Sevecen');
      expect(resolveCatMood(null), isNull);
      expect(resolveCatMood(''), isNull);
      expect(resolveCatMood('unknown'), isNull);
    });

    test('5. resolveUserMood normalizes canonical and English aliases safely', () {
      expect(resolveUserMood('Mutlu'), 'Mutlu');
      expect(resolveUserMood('Huzurlu'), 'Huzurlu');
      expect(resolveUserMood('peaceful'), 'Huzurlu');
      expect(resolveUserMood('Özlemli'), 'Özlemli');
      expect(resolveUserMood('nostalgic'), 'Özlemli');
      expect(resolveUserMood('Neşeli'), 'Neşeli');
      expect(resolveUserMood('joyful'), 'Neşeli');
      expect(resolveUserMood('Sakin'), 'Sakin');
      expect(resolveUserMood('Duygusal'), 'Duygusal');
      expect(resolveUserMood('emotional'), 'Duygusal');
      expect(resolveUserMood(null), isNull);
      expect(resolveUserMood(''), isNull);
      expect(resolveUserMood('random'), isNull);
    });

    testWidgets('6. Localized cat mood translations across Turkish, English, and Japanese', (tester) async {
      late AppLocalizations l10nTr;
      late AppLocalizations l10nEn;
      late AppLocalizations l10nJa;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          home: Builder(
            builder: (context) {
              l10nTr = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(getLocalizedCatMood('Mutlu', l10nTr), 'Mutlu');
      expect(getLocalizedCatMood('Meraklı', l10nTr), 'Meraklı');
      expect(getLocalizedCatMood('Uykulu', l10nTr), 'Uykulu');
      expect(getLocalizedCatMood('Oyuncu', l10nTr), 'Oyuncu');
      expect(getLocalizedCatMood('Sakin', l10nTr), 'Sakin');
      expect(getLocalizedCatMood('Sevecen', l10nTr), 'Sevecen');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              l10nEn = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(getLocalizedCatMood('Mutlu', l10nEn), 'Happy');
      expect(getLocalizedCatMood('Meraklı', l10nEn), 'Curious');
      expect(getLocalizedCatMood('Uykulu', l10nEn), 'Sleepy');
      expect(getLocalizedCatMood('Oyuncu', l10nEn), 'Playful');
      expect(getLocalizedCatMood('Sakin', l10nEn), 'Calm');
      expect(getLocalizedCatMood('Sevecen', l10nEn), 'Affectionate');

      expect(getLocalizedUserMood('Mutlu', l10nEn), 'Happy');
      expect(getLocalizedUserMood('Huzurlu', l10nEn), 'Peaceful');
      expect(getLocalizedUserMood('Özlemli', l10nEn), 'Nostalgic');
      expect(getLocalizedUserMood('Neşeli', l10nEn), 'Joyful');
      expect(getLocalizedUserMood('Sakin', l10nEn), 'Calm');
      expect(getLocalizedUserMood('Duygusal', l10nEn), 'Emotional');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ja'),
          home: Builder(
            builder: (context) {
              l10nJa = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(getLocalizedCatMood('Mutlu', l10nJa), '嬉しい');
      expect(getLocalizedCatMood('Meraklı', l10nJa), '好奇心旺盛');
      expect(getLocalizedCatMood('Uykulu', l10nJa), '眠い');
      expect(getLocalizedCatMood('Oyuncu', l10nJa), '遊びたい');
      expect(getLocalizedCatMood('Sakin', l10nJa), '穏やか');
      expect(getLocalizedCatMood('Sevecen', l10nJa), '甘えん坊');
    });

    testWidgets('7. CatMoodStickerMapper.buildSticker produces valid Image widget for all 6 moods', (tester) async {
      for (final mood in CatMoodConstants.canonicalCatMoods) {
        final widget = CatMoodStickerMapper.buildSticker(mood: mood, size: 40.0);
        expect(widget, isNotNull);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget!,
            ),
          ),
        );
        expect(find.byType(Image), findsOneWidget);
      }
    });

    test('8. CatMoodStickerMapper.buildSticker returns null for null/unknown mood without throwing', () {
      expect(CatMoodStickerMapper.buildSticker(mood: null), isNull);
      expect(CatMoodStickerMapper.buildSticker(mood: ''), isNull);
      expect(CatMoodStickerMapper.buildSticker(mood: 'non_existent'), isNull);
    });
  });
}
