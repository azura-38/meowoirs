// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Every cat has a story.';

  @override
  String get navHome => 'Home';

  @override
  String get navCats => 'Cats';

  @override
  String get navMemories => 'Memories';

  @override
  String get navProfile => 'Profile';

  @override
  String get navMyStory => 'My Story';

  @override
  String get fabAddMemory => 'Add Memory';

  @override
  String get homeTitle => 'Meowoirs';

  @override
  String get homeEmptyTitle => 'You don\'t have any memories yet...';

  @override
  String get homeEmptyDesc =>
      'The little moments you share with your cats will eventually become your own story.';

  @override
  String get homeEmptyAddMemory => 'Add Your First Memory';

  @override
  String get homeEmptyAddCat => 'Add Your First Cat';

  @override
  String get homeCatsSectionTitle => 'Your Cats';

  @override
  String homeCatsSectionSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cat stories',
      one: '1 cat story',
    );
    return '$_temp0';
  }

  @override
  String get homeRecentMemoriesTitle => 'Recent Memories';

  @override
  String get homeRecentMemoriesViewAll => 'View All';

  @override
  String get homeCatsNoMemoriesTitle => 'Your cats are here.';

  @override
  String get homeCatsNoMemoriesDesc =>
      'Keep the first memory you share with them.';

  @override
  String get catsTitle => 'My Cats';

  @override
  String get catsActionNewCat => 'New Cat';

  @override
  String get catsSubtitleDefault => 'Little stories touching your life.';

  @override
  String catsSubtitleWithSummary(String summary) {
    return 'Touching your life: $summary';
  }

  @override
  String get catsFilterAll => 'All';

  @override
  String get catsFilterHome => 'Home';

  @override
  String get catsFilterStreet => 'Street';

  @override
  String get catsEmptyTitle => 'You don\'t have a cat yet.';

  @override
  String get catsEmptyDesc =>
      'Start your story by adding a cat from your life.';

  @override
  String get catsEmptyAddCat => 'Add Your First Cat';

  @override
  String get catsFilterEmptyHome => 'You haven\'t added a home cat yet.';

  @override
  String get catsFilterEmptyHomeCta => 'Add Home Cat';

  @override
  String get catsFilterEmptyStreet => 'You haven\'t added a street cat yet.';

  @override
  String get catsFilterEmptyStreetCta => 'Add Street Cat';

  @override
  String get catsFilterEmptyAll => 'No cats found.';

  @override
  String get catsFilterEmptyAllCta => 'Add Cat';

  @override
  String get catTypeHome => 'Home Cat';

  @override
  String get catTypeStreet => 'Street Cat';

  @override
  String catCardMemoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String catSummaryHomeAndStreet(int homeCount, int streetCount) {
    return '$homeCount home · $streetCount street';
  }

  @override
  String catSummaryTotalOnly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cats',
      one: '1 cat',
    );
    return '$_temp0';
  }

  @override
  String catPhotoContentDescription(String name) {
    return 'Photo of $name';
  }

  @override
  String get addCatTitle => 'Add Cat';

  @override
  String get addCatSubtitle => 'Their story begins here.';

  @override
  String get editCatTitle => 'Edit Cat';

  @override
  String get editCatSubtitle => 'Update their details.';

  @override
  String get catNameLabel => 'Cat Name';

  @override
  String get catNameHint => 'e.g. Minnoş';

  @override
  String get catNameRequired => 'Please enter the cat\'s name.';

  @override
  String get catNoteLabel => 'Personal Note';

  @override
  String get catNoteHint => 'A little about this cat...';

  @override
  String get catPhotoLabel => 'Photo';

  @override
  String get catTypeLabel => 'Cat Type';

  @override
  String get catTypeHomeDesc => 'Your companion at home';

  @override
  String get catTypeStreetDesc => 'Your friend from the street';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get changePhoto => 'Change';

  @override
  String get removePhoto => 'Remove';

  @override
  String get addPhotoSemantic => 'Add cat photo';

  @override
  String get selectedPhotoSemantic => 'Selected cat photo';

  @override
  String get changePhotoSemantic => 'Change photo';

  @override
  String get removePhotoSemantic => 'Remove photo';

  @override
  String get memoriesTitle => 'Memories';

  @override
  String get memoriesSubtitle => 'Archive of little moments in your life.';

  @override
  String get memoriesFilterAll => 'All';

  @override
  String get memoriesEmptyTitle => 'No memories yet.';

  @override
  String get memoriesEmptyDesc =>
      'Start capturing the little moments you share with your cats.';

  @override
  String get memoriesGlobalEmptyTitle => 'You don\'t have any memories yet.';

  @override
  String get memoriesGlobalEmptyDesc =>
      'Little moments spent with your cats will gather here.';

  @override
  String get memoriesGlobalEmptyCta => 'Add Your First Memory';

  @override
  String memoriesFilterEmptyTitle(String catName) {
    return 'No memories for $catName yet.';
  }

  @override
  String get memoriesFilterEmptyDesc => 'Save a little memory spent with them.';

  @override
  String get memoriesFilterEmptyCta => 'Add Memory';

  @override
  String get memoriesErrorTitle => 'Could not load memories';

  @override
  String get memoriesErrorDesc =>
      'An error occurred while loading memories. Please try again.';

  @override
  String get memoriesErrorRetry => 'Retry';

  @override
  String memoriesCardSemantic(String catName) {
    return 'Open memory saved with $catName';
  }

  @override
  String get addMemoryTitle => 'Add Memory';

  @override
  String get addMemorySubtitle => 'Keep a little memory from today.';

  @override
  String get editMemoryTitle => 'Edit Memory';

  @override
  String get editMemorySubtitle => 'Update this memory.';

  @override
  String get memoryNoteLabel => 'Note';

  @override
  String get memoryNoteHint => 'What happened?';

  @override
  String get memoryNoteHintLong =>
      'What happened today? e.g. Fell asleep by the window again today...';

  @override
  String get memoryWhoWith => 'With who?';

  @override
  String get memoryPhotoSectionTitle =>
      'A photo that reminds you of this memory';

  @override
  String get memoryWhatHappened => 'What happened?';

  @override
  String get memoryCatMoodSection => 'Their mood';

  @override
  String get memoryUserMoodSection => 'How you felt?';

  @override
  String get memoryWhenSection => 'When?';

  @override
  String get memorySaved => 'Saved ✓';

  @override
  String get memorySelectCat => 'Select Cat';

  @override
  String get memoryCatRequired => 'Please select a cat for this memory.';

  @override
  String get memoryPhotoLabel => 'Photo';

  @override
  String get memoryCatMoodLabel => 'Cat\'s Mood';

  @override
  String get memoryUserMoodLabel => 'Your Mood';

  @override
  String get memoryDateLabel => 'Date';

  @override
  String get memoryTimeLabel => 'Time';

  @override
  String get memoryDetailTitle => 'Memory Detail';

  @override
  String get memoryNotFoundTitle => 'Memory not found';

  @override
  String get memoryNotFoundDesc =>
      'This memory is no longer available or may have been deleted.';

  @override
  String get memoryMoodSectionTitle => 'Mood';

  @override
  String memoryCatMoodFormat(String mood) {
    return 'Their mood: $mood';
  }

  @override
  String memoryUserMoodFormat(String mood) {
    return 'Your mood: $mood';
  }

  @override
  String get catDetailTitle => 'Cat Story';

  @override
  String get catNotFoundTitle => 'Cat not found';

  @override
  String get catNotFoundDesc =>
      'This story is no longer available or may have been deleted.';

  @override
  String catDetailStorySubtitle(String memoryText) {
    return 'Little moments you shared together. $memoryText';
  }

  @override
  String get catDetailMemoryCountZero =>
      'This story will begin with its first memory.';

  @override
  String get catDetailMemoryCountSingle => '1 little moment here.';

  @override
  String catDetailMemoryCountMultiple(int count) {
    return '$count little moments here.';
  }

  @override
  String get catDetailMemoriesSectionTitle => 'Memories';

  @override
  String catDetailMemoriesSectionSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories recorded',
      one: '1 memory recorded',
    );
    return '$_temp0';
  }

  @override
  String get catDetailEmptyMemoriesTitle => 'The story is just beginning.';

  @override
  String get catDetailEmptyMemoriesDesc =>
      'You can save the first little moment you shared with this cat here.';

  @override
  String get catDetailEmptyMemoriesCta => 'Add First Memory';

  @override
  String get catDetailActionAddMemory => 'Add Memory';

  @override
  String get catDetailNoteTitle => 'Note';

  @override
  String catDetailPhotoSemantic(String name) {
    return 'Photo of $name';
  }

  @override
  String get catDetailBackSemantic => 'Go back from cat details';

  @override
  String get catDetailDeleteSemantic => 'Delete cat';

  @override
  String get catDetailEditSemantic => 'Edit cat';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGreetingPrefix => 'Hello';

  @override
  String get profileDefaultTitle => 'Your Story';

  @override
  String get profileSubtitle => 'This is your personal space in Meowoirs.';

  @override
  String get profileEditButton => 'Edit Profile';

  @override
  String get profileEditDialogTitle => 'Edit Profile';

  @override
  String get profileNicknameLabel => 'Nickname';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Choose Avatar';

  @override
  String get profileSave => 'Save';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'You don\'t have a favorite cat yet.';

  @override
  String get favoriteCatEmptyCta => 'Add Your First Cat';

  @override
  String get favoriteCatNoneSelected => 'No favorite cat selected yet.';

  @override
  String get favoriteCatDialogTitle => 'Select Favorite Cat';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'View Full Story';

  @override
  String get myStoryYourStory => 'Your Meowoirs';

  @override
  String get myStoryCatsSection => 'Your Cats';

  @override
  String get myStorySeeAll => 'View All';

  @override
  String get myStoryMostRememberedTitle => 'Most remembered';

  @override
  String myStoryMostRememberedSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories recorded',
      one: '1 memory recorded',
    );
    return '$_temp0';
  }

  @override
  String get myStoryRecentMoment => 'Recent Moment';

  @override
  String get myStoryBeginningTitle => 'Your first moment in Meowoirs';

  @override
  String get myStoryCompletelyEmptyTitle => 'Your story will begin here.';

  @override
  String get myStoryCompletelyEmptySubtitle =>
      'The little moments shared with your cats will turn into your own story over time.';

  @override
  String get myStoryCompletelyEmptyAddMemory => 'Add First Memory';

  @override
  String get myStoryCompletelyEmptyAddCat => 'Add First Cat';

  @override
  String get myStoryPartialEmptyTitle => 'No memories to tell yet.';

  @override
  String get myStoryPartialEmptySubtitle =>
      'Your cats are here. Save the first little moment you shared with them.';

  @override
  String get myStoryPartialEmptyAddMemory => 'Add First Memory';

  @override
  String get myStoryErrorTitle => 'Could not load story';

  @override
  String get myStoryErrorDesc => 'A problem occurred while loading your story.';

  @override
  String get myStoryErrorRetry => 'Retry';

  @override
  String myStoryMostRememberedSemantic(String catName, int count) {
    return '$catName, most remembered cat. $count memories.';
  }

  @override
  String myStoryBeginningSemantic(String date) {
    return 'Your first moment in Meowoirs: $date';
  }

  @override
  String get statCats => 'Cats';

  @override
  String get statMemories => 'Memories';

  @override
  String get statHome => 'Home';

  @override
  String get statStreet => 'Street';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsAdPrivacy => 'Ad Privacy Options';

  @override
  String get privacyPendingTitle => 'Information';

  @override
  String get privacyPendingDesc =>
      'Our Privacy Policy and Terms of Service will soon be available online.';

  @override
  String get umpNotRequired =>
      'Ad privacy options are not required for your region or current session.';

  @override
  String get umpPrivacySubtitle => 'Manage ad preferences and permissions';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Reach Us';

  @override
  String get reachUsThankYouTitle => 'Thank you for using Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'We are happy that every little memory turns into a personal story with you.';

  @override
  String get reachUsActionSuggestion => 'Send Suggestion';

  @override
  String get reachUsActionBug => 'Report Bug';

  @override
  String get reachUsActionContact => 'Contact Us';

  @override
  String get reachUsNoEmailApp => 'No email application found on this device.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Version $version';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSaveChanges => 'Save Changes';

  @override
  String get actionBack => 'Back';

  @override
  String get actionRetry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get deleteCatTitle => 'Are you sure you want to delete this cat?';

  @override
  String get deleteCatMessage =>
      'The cat profile will be deleted. Saved memories will be preserved.';

  @override
  String get deleteMemoryTitle =>
      'Are you sure you want to delete this memory?';

  @override
  String get deleteMemoryMessage => 'This memory will be permanently deleted.';

  @override
  String get errorGenericOperation =>
      'An error occurred during the operation. Please try again.';

  @override
  String get catSaveError =>
      'An error occurred while saving the cat. Please try again.';

  @override
  String get memorySaveError =>
      'An error occurred while saving the memory. Please try again.';

  @override
  String get catDeleteError =>
      'An error occurred while deleting the cat. Please try again.';

  @override
  String get memoryDeleteError =>
      'An error occurred while deleting the memory. Please try again.';

  @override
  String get photoLoadFailed => 'Photo could not be loaded';

  @override
  String get legalViewOnline => 'View Online';

  @override
  String get legalDocumentClose => 'Close';

  @override
  String get legalDataDeletion => 'Data & Deletion';

  @override
  String get legalThirdParty => 'Third-Party Services';

  @override
  String get legalAdvertisingConsent => 'Advertising & Consent';

  @override
  String get legalDisclaimer => 'Legal Disclaimer';

  @override
  String get legalDocumentLoadError => 'Could not load document.';

  @override
  String get legalDocumentRetry => 'Retry';

  @override
  String get onboardingSkip => 'SKIP';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'VOLUME I — CHAPTER 01';

  @override
  String get onboardingStep1Badge => 'MORNING LIGHT';

  @override
  String get onboardingStep1Quote => '«Like a quiet whisper...»';

  @override
  String get onboardingStep1Intro => 'INTRODUCTORY NOTE';

  @override
  String get onboardingStep1IntroSub => 'OPENING';

  @override
  String get onboardingStep1Title => 'Every cat has a story.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs is your personal space to keep the little moments, photos, and stories you share with your cats.';

  @override
  String get onboardingStep1FeatureTitle => 'Create Your Personal Archive';

  @override
  String get onboardingStep1FeatureDesc =>
      'Build your own memory archive with photos, notes, and little moments.';

  @override
  String get onboardingStep1Footer1 => 'MEOWOIRS ARCHIVE';

  @override
  String get onboardingStep1Footer2 => 'FIRST PAGE';

  @override
  String get onboardingStep2Chap => 'CHAPTER II — DIARY FRAGMENTS';

  @override
  String get onboardingStep2Title => 'Keep the little moments.';

  @override
  String get onboardingStep2Subtitle =>
      'A photo, a few words, and the feeling of that moment.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Morning Sleep';

  @override
  String get onboardingStep2Date => 'October 14';

  @override
  String get onboardingStep2Mood => 'Peaceful';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs turns ordinary moments into little stories you won\'t want to forget.';

  @override
  String get onboardingStep2Footer1 => 'PERSONAL ARCHIVE';

  @override
  String get onboardingStep2Footer2 => 'LITTLE MOMENTS';

  @override
  String get onboardingStep3Chap => 'CHAPTER III — IN YOUR STORY';

  @override
  String get onboardingStep3Title => 'Every cat can be in your story.';

  @override
  String get onboardingStep3Desc =>
      'From the cat in your home to a friend you met on the street, keep the little moments that touch your life.';

  @override
  String get onboardingStep3HomeBadge => 'AT HOME';

  @override
  String get onboardingStep3HomeTitle => 'Our Home\'s Story';

  @override
  String get onboardingStep3StreetBadge => 'STREET STORY';

  @override
  String get onboardingStep3StreetTitle => 'Spirit of the Street';

  @override
  String get onboardingStep3StreetSubtitle =>
      'Olive — Old friend from the neighborhood';

  @override
  String get onboardingStep3FeatureTitle => 'At Home or On the Street';

  @override
  String get onboardingStep3FeatureDesc =>
      'Include the cats in your home or those you meet on the street in your own story.';

  @override
  String get onboardingStep3Footer1 => 'MEOWOIRS ARCHIVE';

  @override
  String get onboardingStep3Footer2 => 'EVERY CAT';

  @override
  String get onboardingStep4Chap => 'CHAPTER IV • PRIVACY & TRUST';

  @override
  String get onboardingStep4Title => 'Your story is yours.';

  @override
  String get onboardingStep4Desc =>
      'Your memories and photos stay on your device. Meowoirs does not store them on its servers and does not require an account or cloud sync.';

  @override
  String get onboardingStep4FeatureTitle => 'Stays on Your Device';

  @override
  String get onboardingStep4FeatureDesc =>
      'Your cat profiles, photos, notes, and memories are stored locally on your device.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'I have read and agree to the Privacy Policy.';

  @override
  String get onboardingStep4PrivacyLink => 'Privacy Policy';

  @override
  String get onboardingStep4TermsCheckbox =>
      'I have read and agree to the Terms of Service.';

  @override
  String get onboardingStep4TermsLink => 'Terms of Service';

  @override
  String get onboardingStep4CombinedCheckbox =>
      'I have read and agree to the Privacy Policy and Terms of Service.';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • PERSONAL ARCHIVE';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Warm ginger cat';

  @override
  String get avatarDescSageCat => 'Calm sage cat';

  @override
  String get avatarDescLavenderCat => 'Dreamy lavender cat';

  @override
  String get avatarDescCuriousCat => 'Curious cat';

  @override
  String get avatarDescCozyCat => 'Cozy sleeping cat';

  @override
  String get avatarDescGentlePaw => 'Gentle paw print';

  @override
  String get avatarDescStarGazer => 'Star gazing cat';

  @override
  String get avatarDescBookCat => 'Book lover cat';

  @override
  String get avatarDescSunlitCat => 'Sunlit resting cat';

  @override
  String get avatarDescWhiskerHeart => 'Whisker heart';

  @override
  String get debugPanelUnlocked => 'Developer panel unlocked';

  @override
  String get debugOnboardingCompleted => 'Onboarding Completed';

  @override
  String get debugAcceptedLegalVersion => 'Accepted Legal Version';

  @override
  String get debugResetOnboarding => 'DEVELOPER: RESET ONBOARDING';

  @override
  String get debugOnboardingResetToast => 'Onboarding status reset';

  @override
  String get profileNicknamePlaceholder => 'e.g. Luna';

  @override
  String get favoriteCatSectionTitle => 'Favorite Cat';

  @override
  String get favoriteCatChangeButton => 'Change Favorite Cat';

  @override
  String get favoriteCatSelectButton => 'Select Favorite Cat';

  @override
  String get myStorySectionTitle => 'My Story';

  @override
  String get profileSettingsButton => 'Settings';

  @override
  String get tooltipBack => 'Go back';

  @override
  String get semanticsSelected => 'selected';

  @override
  String get semanticsNotSelected => 'not selected';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodCurious => 'Curious';

  @override
  String get moodSleepy => 'Sleepy';

  @override
  String get moodPlayful => 'Playful';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodAffectionate => 'Affectionate';

  @override
  String get moodPeaceful => 'Peaceful';

  @override
  String get moodNostalgic => 'Nostalgic';

  @override
  String get moodJoyful => 'Joyful';

  @override
  String get moodEmotional => 'Emotional';

  @override
  String addMemorySelectDate(String date) {
    return 'Select date: $date';
  }

  @override
  String get addMemoryCatEmptyAction => 'Add Cat';

  @override
  String memoryCatNoteLabel(String catName, String note) {
    return '$catName\'s memory: $note';
  }

  @override
  String get storyNarrativeEmpty =>
      'The little moments you share with your cats will eventually become your own story.';

  @override
  String get storyNarrativeCatsNoMemories =>
      'Your cats are here. Keep the first little moment you share with them.';

  @override
  String storyNarrativeSingleCat(String catName, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count little moments',
      one: '1 little moment',
    );
    return '$catName has $_temp0 kept here.';
  }

  @override
  String storyNarrativeHomeAndStreet(int memoriesCount, int catsCount) {
    return 'You\'ve gathered $memoriesCount little moments with $catsCount friends. Warm moments at home and little street stories together.';
  }

  @override
  String storyNarrativeGeneral(int memoriesCount, int catsCount) {
    return 'You\'ve gathered $memoriesCount little moments with $catsCount cats. Over time, these moments form your Meowoirs story.';
  }

  @override
  String get legalTitlePrivacyPolicy => 'Privacy Policy';

  @override
  String get legalTitleTermsOfService => 'Terms of Service';

  @override
  String get legalTitleDataDeletion => 'Data Deletion Policy';

  @override
  String get legalTitleThirdPartyServices => 'Third-Party Services';

  @override
  String get legalTitleAdvertisingAndConsent => 'Advertising & Consent Policy';

  @override
  String get legalTitleLegalDisclaimer => 'Legal Disclaimer';

  @override
  String get memoriesViewMenuLabel => 'View';

  @override
  String get memoriesViewMenuSemantic => 'View options';

  @override
  String get memoriesViewModeTiles => 'Tiles';

  @override
  String get memoriesViewModeLargeIcons => 'Large Icons';

  @override
  String get memoriesViewModeSmallIcons => 'Small Icons';

  @override
  String get memoriesViewModeList => 'List';

  @override
  String get memoriesViewModeContent => 'Content';

  @override
  String get profileTryOtherAppsTitle => 'Try Our Other Apps';

  @override
  String get profileTryOtherAppsSubtitle => 'Discover more apps from LIMANEX';

  @override
  String get profileComingSoonTitle => 'Coming Soon';

  @override
  String get profileComingSoonSubtitle => 'See upcoming features';

  @override
  String get limanexAppsPageTitle => 'Try Our Other Apps';

  @override
  String get limanexStudioBadge => 'LIMANEX STUDIO';

  @override
  String get limanexStudioWelcome =>
      'Crafted with care by LIMANEX. Discover other thoughtful applications from our studio.';

  @override
  String get vitaCaseAppName => 'VitaCase';

  @override
  String get vitaCaseTagline => 'Your Personal Health & Wellness Companion';

  @override
  String get vitaCaseDescription =>
      'Organize your medical documents, track appointments, and manage daily medication reminders privately on your device.';

  @override
  String get vitaCaseCtaExplore => 'Explore VitaCase';

  @override
  String get vitaCaseLaunchFallbackMessage =>
      'Could not open the store link on this device.';

  @override
  String get vitaCasePromoPlaceholderLabel => 'VitaCase Preview';

  @override
  String get comingSoonPageTitle => 'Coming Soon';

  @override
  String get comingSoonHeaderIntro =>
      'Exciting new features are on the way to make Meowoirs even more special!';

  @override
  String get comingSoonFeature1Title => 'Memory Collage';

  @override
  String get comingSoonFeature1Desc =>
      'Create, edit, save, reopen, delete, and export beautiful memory collages using 2–6 photos and three templates, with optional title, date, and cat association.';

  @override
  String get comingSoonFeature2Title => 'Cat Timeline';

  @override
  String get comingSoonFeature2Desc =>
      'Bring a cat\'s memories together in chronological order, with date-based navigation, first encounters, and important moments.';

  @override
  String get comingSoonFeature3Title => 'On This Day';

  @override
  String get comingSoonFeature3Desc =>
      'Rediscover memories saved on the same date in previous years, bringing old photos and meaningful moments back to the surface.';

  @override
  String get comingSoonFeature4Title => 'Our Story';

  @override
  String get comingSoonFeature4Desc =>
      'A personal story page featuring the date a user met their cat, meaningful milestones, selected photos, and special memories.';

  @override
  String get comingSoonFeature5Title => 'Memory Reminders';

  @override
  String get comingSoonFeature5Desc =>
      'Optional local reminders, reminder preferences, and controlled notifications to revisit meaningful memories.';

  @override
  String get comingSoonFeature6Title => 'Archive Improvements';

  @override
  String get comingSoonFeature6Desc =>
      'Improved memory search, date and cat filters, favorites, and faster archive navigation.';

  @override
  String get comingSoonFeature7Title => 'Shareable Memory Designs';

  @override
  String get comingSoonFeature7Desc =>
      'More collage layouts, additional visual themes, and story-style export formats for sharing selected memories.';

  @override
  String get comingSoonFeature8Title => 'Personal Archive Tools';

  @override
  String get comingSoonFeature8Desc =>
      'Explore local archive export and restore options, improve file integrity, storage management, and protection against data loss.';
}
