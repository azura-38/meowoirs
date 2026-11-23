import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meowoirs/core/routing/route_ui_policy.dart';
import 'package:meowoirs/core/utils/turkish_suffix.dart';
import 'package:meowoirs/data/models/cat.dart';
import 'package:meowoirs/data/models/memory.dart';
import 'package:meowoirs/domain/story/story_metrics_calculator.dart';
import 'package:meowoirs/features/profile/profile_avatars.dart';
import 'package:meowoirs/services/ads/ad_config.dart';
import 'package:meowoirs/services/ads/ad_manager.dart';
import 'package:meowoirs/services/ads/launch_counter_manager.dart';

void main() {
  group('StoryMetricsCalculator Tests', () {
    test('Calculates empty state correctly', () {
      final metrics = StoryMetricsCalculator.calculate([], []);

      expect(metrics.totalCats, 0);
      expect(metrics.totalMemories, 0);
      expect(metrics.mostRememberedCat, isNull);
      expect(metrics.earliestMemory, isNull);
      expect(metrics.latestMemory, isNull);
    });

    test('Calculates metrics with data correctly', () {
      const cat1 = Cat(
        id: 'cat_1',
        name: 'Pamuk',
        type: CatType.home,
        createdAt: 1000,
      );
      const cat2 = Cat(
        id: 'cat_2',
        name: 'Tekir',
        type: CatType.street,
        createdAt: 2000,
      );

      const mem1 = Memory(
        id: 'mem_1',
        catId: 'cat_1',
        catName: 'Pamuk',
        note: 'Sleeping peacefully',
        createdAt: 1500,
      );
      const mem2 = Memory(
        id: 'mem_2',
        catId: 'cat_1',
        catName: 'Pamuk',
        note: 'Playing with string',
        createdAt: 2500,
      );

      final metrics = StoryMetricsCalculator.calculate(
        [cat1, cat2],
        [mem1, mem2],
      );

      expect(metrics.totalCats, 2);
      expect(metrics.homeCatsCount, 1);
      expect(metrics.streetCatsCount, 1);
      expect(metrics.totalMemories, 2);
      expect(metrics.mostRememberedCat?.id, 'cat_1');
      expect(metrics.mostRememberedCount, 2);
      expect(metrics.earliestMemory?.id, 'mem_1');
      expect(metrics.latestMemory?.id, 'mem_2');
    });
  });

  group('Turkish Title Suffix Tests', () {
    test('Matches grammatical vowel harmony correctly', () {
      // Consonant ending, 'o' / 'u' -> 'un
      expect(getCatStoryTitle('Minnoş'), "Minnoş'un Hikâyesi");
      expect(getCatStoryTitle('Pamuk'), "Pamuk'un Hikâyesi");

      // Consonant ending, 'e' / 'i' -> 'in
      expect(getCatStoryTitle('Tekir'), "Tekir'in Hikâyesi");
      expect(getCatStoryTitle('Zeytin'), "Zeytin'in Hikâyesi");

      // Consonant ending, 'a' / 'ı' -> 'ın
      expect(getCatStoryTitle('Duman'), "Duman'ın Hikâyesi");
      expect(getCatStoryTitle('Çıtır'), "Çıtır'ın Hikâyesi");

      // Consonant ending, 'ö' / 'ü' -> 'ün
      expect(getCatStoryTitle('Kömür'), "Kömür'ün Hikâyesi");

      // Vowel ending, 'a' / 'ı' -> 'nın
      expect(getCatStoryTitle('Maya'), "Maya'nın Hikâyesi");

      // Vowel ending, 'e' / 'i' -> 'nin
      expect(getCatStoryTitle('Gölge'), "Gölge'nin Hikâyesi");
      expect(getCatStoryTitle('Bobi'), "Bobi'nin Hikâyesi");

      // Blank input fallback
      expect(getCatStoryTitle(''), 'Kedinin Hikâyesi');
      expect(getCatStoryTitle('   '), 'Kedinin Hikâyesi');
    });
  });

  group('Profile Avatars Tests', () {
    test('Curated avatars count is 10', () {
      expect(ProfileAvatars.all.length, 10);
    });

    test('Get avatar by known id', () {
      final avatar = ProfileAvatars.getById('avatar_sage_cat');
      expect(avatar.id, 'avatar_sage_cat');
    });

    test('Get avatar fallback on unknown id', () {
      final fallback = ProfileAvatars.getById('non_existent_avatar');
      expect(fallback.id, 'avatar_warm_cat');
    });
  });

  group('Ad System & Safety Tests', () {
    test('AdConfig constants match production credentials', () {
      expect(AdConfig.applicationId, 'ca-app-pub-5877011177866406~4355156867');
      expect(AdConfig.androidBannerAdUnitId,
          'ca-app-pub-5877011177866406/2930394553');
      expect(AdConfig.androidInterstitialAdUnitId,
          'ca-app-pub-5877011177866406/2195897382');
      expect(AdConfig.minLaunchThreshold, 5);
      expect(AdConfig.maxLaunchThreshold, 7);
    });

    test('Safe routes for interstitial presentation', () {
      expect(AdManager.isSafeRouteForInterstitial('/'), isTrue);
      expect(AdManager.isSafeRouteForInterstitial('/home'), isTrue);
      expect(AdManager.isSafeRouteForInterstitial('/cats'), isTrue);
      expect(AdManager.isSafeRouteForInterstitial('/memories'), isTrue);
      expect(AdManager.isSafeRouteForInterstitial('/story'), isTrue);

      // Strict exclusions
      expect(AdManager.isSafeRouteForInterstitial('/cats/add'), isFalse);
      expect(AdManager.isSafeRouteForInterstitial('/memories/add'), isFalse);
      expect(AdManager.isSafeRouteForInterstitial('/settings'), isFalse);
      expect(AdManager.isSafeRouteForInterstitial('/onboarding'), isFalse);
      expect(AdManager.isSafeRouteForInterstitial(null), isFalse);
    });

    test('RouteUiPolicy banner ad visibility rules', () {
      // Top-level browsing
      expect(RouteUiPolicy.shouldShowBannerAd('/'), isTrue);
      expect(RouteUiPolicy.shouldShowBannerAd('/home'), isTrue);
      expect(RouteUiPolicy.shouldShowBannerAd('/cats'), isTrue);
      expect(RouteUiPolicy.shouldShowBannerAd('/memories'), isTrue);
      expect(RouteUiPolicy.shouldShowBannerAd('/profile'), isTrue);

      // Cat detail routes
      expect(RouteUiPolicy.shouldShowBannerAd('/cats/cat_123'), isTrue);
      expect(RouteUiPolicy.shouldShowBannerAd('/cat_detail/cat_123'), isTrue);

      // Story browsing
      expect(RouteUiPolicy.shouldShowBannerAd('/story'), isTrue);
      expect(RouteUiPolicy.shouldShowBannerAd('/my_story'), isTrue);

      // Prohibited routes
      expect(RouteUiPolicy.shouldShowBannerAd('/onboarding'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/settings'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/cats/add'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/add_cat'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/memories/add'), isFalse);
      expect(RouteUiPolicy.shouldShowBannerAd('/add_memory'), isFalse);
    });

    test('LaunchCounterManager tracks sessions and resets accurately', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final manager = LaunchCounterManager(prefs);

      // Session deduplication
      manager.recordGenuineLaunch('session_1');
      expect(manager.launchCount, 1);
      manager.recordGenuineLaunch('session_1'); // same session
      expect(manager.launchCount, 1);

      // Launches 1 to 4 should never trigger
      expect(manager.isEligibleForInterstitial(), isFalse);

      manager.recordGenuineLaunch('session_2');
      manager.recordGenuineLaunch('session_3');
      manager.recordGenuineLaunch('session_4');
      expect(manager.launchCount, 4);
      expect(manager.isEligibleForInterstitial(), isFalse);

      // Ensure threshold is between 5 and 7
      final threshold = manager.currentThreshold;
      expect(threshold >= 5 && threshold <= 7, isTrue);

      // Reset on interstitial shown
      manager.onInterstitialShown();
      expect(manager.launchCount, 0);
    });
  });
}
