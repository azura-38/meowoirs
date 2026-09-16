// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Każdy kot ma swoją historię';

  @override
  String get navHome => 'Główna';

  @override
  String get navCats => 'Moje Koty';

  @override
  String get navMemories => 'Wspomnienia';

  @override
  String get navProfile => 'Profil';

  @override
  String get navMyStory => 'Moja Historia';

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
  String get editCatTitle => 'Edytuj kota';

  @override
  String get editCatSubtitle => 'Zaktualizuj szczegóły.';

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
  String get editMemoryTitle => 'Edytuj wspomnienie';

  @override
  String get editMemorySubtitle => 'Zaktualizuj to wspomnienie.';

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
  String get memoryDetailTitle => 'Szczegóły wspomnienia';

  @override
  String get memoryNotFoundTitle => 'Nie znaleziono wspomnienia';

  @override
  String get memoryNotFoundDesc =>
      'To wspomnienie nie jest już dostępne lub mogło zostać usunięte.';

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
  String get catNotFoundTitle => 'Nie znaleziono kota';

  @override
  String get catNotFoundDesc =>
      'Ta historia nie jest już dostępna lub mogła zostać usunięta.';

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
  String get profileTitle => 'Profil';

  @override
  String get profileGreetingPrefix => 'Cześć';

  @override
  String get profileDefaultTitle => 'Twoja Historia';

  @override
  String get profileSubtitle => 'To Twoja osobista przestrzeń w Meowoirs.';

  @override
  String get profileEditButton => 'Edytuj Profil';

  @override
  String get profileEditDialogTitle => 'Edytuj Profil';

  @override
  String get profileNicknameLabel => 'Pseudonim';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Wybierz Awatar';

  @override
  String get profileSave => 'Zapisz';

  @override
  String get profileCancel => 'Anuluj';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'Nie masz jeszcze ulubionego kota.';

  @override
  String get favoriteCatEmptyCta => 'Dodaj Pierwszego Kota';

  @override
  String get favoriteCatNoneSelected => 'Nie wybrano jeszcze ulubionego kota.';

  @override
  String get favoriteCatDialogTitle => 'Wybierz Ulubionego Kota';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Zobacz Całą Historię';

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
  String get statCats => 'Koty';

  @override
  String get statMemories => 'Chwile';

  @override
  String get statHome => 'Dom';

  @override
  String get statStreet => 'Ulica';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Polityka Prywatności';

  @override
  String get settingsTermsOfService => 'Warunki Korzystania';

  @override
  String get settingsAdPrivacy => 'Prywatność Reklam';

  @override
  String get privacyPendingTitle => 'Informacja';

  @override
  String get privacyPendingDesc =>
      'Nasza polityka prywatności i warunki będą wkrótce dostępne online.';

  @override
  String get umpNotRequired =>
      'Opcje prywatności reklam nie są wymagane w Twoim regionie.';

  @override
  String get settingsLanguage => 'Język Aplikacji';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Skontaktuj się z Nami';

  @override
  String get reachUsThankYouTitle => 'Dziękujemy za korzystanie z Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'Cieszymy się, że każda mała chwila staje się z Tobą historią.';

  @override
  String get reachUsActionSuggestion => 'Wyślij Sugestię';

  @override
  String get reachUsActionBug => 'Zgłoś Błąd';

  @override
  String get reachUsActionContact => 'Napisz do Nas';

  @override
  String get reachUsNoEmailApp =>
      'Nie znaleziono aplikacji pocztowej na tym urządzeniu.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Wersja %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Wersja %1\$s (Kompilacja %2\$d)';
  }

  @override
  String get actionEdit => 'Edytuj';

  @override
  String get actionDelete => 'Usuń';

  @override
  String get actionCancel => 'Anuluj';

  @override
  String get actionSave => 'Zapisz';

  @override
  String get actionSaveChanges => 'Zapisz zmiany';

  @override
  String get actionBack => 'Wstecz';

  @override
  String get actionRetry => 'Ponów';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get deleteCatTitle => 'Czy na pewno chcesz usunąć tego kota?';

  @override
  String get deleteCatMessage =>
      'Profil kota zostanie usunięty. Zapisane wspomnienia zostaną zachowane.';

  @override
  String get deleteMemoryTitle => 'Czy na pewno chcesz usunąć to wspomnienie?';

  @override
  String get deleteMemoryMessage => 'To wspomnienie zostanie trwale usunięte.';

  @override
  String get errorGenericOperation =>
      'Wystąpił błąd podczas operacji. Spróbuj ponownie.';

  @override
  String get catSaveError =>
      'Wystąpił błąd podczas zapisywania kota. Spróbuj ponownie.';

  @override
  String get memorySaveError =>
      'Wystąpił błąd podczas zapisywania wspomnienia. Spróbuj ponownie.';

  @override
  String get catDeleteError =>
      'Wystąpił błąd podczas usuwania kota. Spróbuj ponownie.';

  @override
  String get memoryDeleteError =>
      'Wystąpił błąd podczas usuwania wspomnienia. Spróbuj ponownie.';

  @override
  String get photoLoadFailed => 'Nie udało się załadować zdjęcia';

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
  String get onboardingSkip => 'POMIŃ';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'TOM I — ROZDZIAŁ 01';

  @override
  String get onboardingStep1Badge => 'PORANNE ŚWIATŁO';

  @override
  String get onboardingStep1Quote => '«Jak cichy szept...»';

  @override
  String get onboardingStep1Intro => 'NOTATKA WSTĘPNA';

  @override
  String get onboardingStep1IntroSub => 'OTWARCIE';

  @override
  String get onboardingStep1Title => 'Każdy kot ma swoją historię.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs to Twoja osobista przestrzeń na małe chwile, zdjęcia i historie dzielone z kotami.';

  @override
  String get onboardingStep1FeatureTitle => 'Stwórz własne archiwum';

  @override
  String get onboardingStep1FeatureDesc =>
      'Buduj własne archiwum wspomnień ze zdjęciami, notatkami i drobnymi chwilami.';

  @override
  String get onboardingStep1Footer1 => 'ARCHIWUM MEOWOIRS';

  @override
  String get onboardingStep1Footer2 => 'PIERWSZA STRONA';

  @override
  String get onboardingStep2Chap => 'ROZDZIAŁ II — FRAGMENTY DZIENNIKA';

  @override
  String get onboardingStep2Title => 'Zachowaj małe chwile.';

  @override
  String get onboardingStep2Subtitle =>
      'Zdjęcie, kilka słów i emocja tamtej chwili.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Poranny sen';

  @override
  String get onboardingStep2Date => '14 października';

  @override
  String get onboardingStep2Mood => 'Spokojny';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs zamienia zwykłe chwile w małe opowieści, których nie chcesz zapomnieć.';

  @override
  String get onboardingStep2Footer1 => 'OSOBISTE ARCHIWUM';

  @override
  String get onboardingStep2Footer2 => 'MAŁE CHWILE';

  @override
  String get onboardingStep3Chap => 'ROZDZIAŁ III — W TWOJEJ OPOWIEŚCI';

  @override
  String get onboardingStep3Title => 'Każdy kot może być w Twojej historii.';

  @override
  String get onboardingStep3Desc =>
      'Od kota w domu po przyjaciela spotkanego na ulicy, zachowaj małe chwile, które dotykają Twojego życia.';

  @override
  String get onboardingStep3HomeBadge => 'W DOMU';

  @override
  String get onboardingStep3HomeTitle => 'Historia naszego domu';

  @override
  String get onboardingStep3StreetBadge => 'HISTORIA Z ULICY';

  @override
  String get onboardingStep3StreetTitle => 'Duch ulicy';

  @override
  String get onboardingStep3StreetSubtitle =>
      'Oliwek — Stary przyjaciel z sąsiedztwa';

  @override
  String get onboardingStep3FeatureTitle => 'W domu lub na ulicy';

  @override
  String get onboardingStep3FeatureDesc =>
      'Włącz do swojej historii koty mieszkające w domu i te spotkane na ulicy.';

  @override
  String get onboardingStep3Footer1 => 'ARCHIWUM MEOWOIRS';

  @override
  String get onboardingStep3Footer2 => 'KAŻDY KOT';

  @override
  String get onboardingStep4Chap => 'ROZDZIAŁ IV • PRYWATNOŚĆ I ZAUFANIE';

  @override
  String get onboardingStep4Title => 'Twoja historia należy do Ciebie.';

  @override
  String get onboardingStep4Desc =>
      'Twoje wspomnienia i zdjęcia pozostają na Twoim urządzeniu. Meowoirs nie przechowuje ich na swoich serwerach i nie wymaga konta ani synchronizacji w chmurze.';

  @override
  String get onboardingStep4FeatureTitle => 'Zostaje na urządzeniu';

  @override
  String get onboardingStep4FeatureDesc =>
      'Profile Twoich kotów, zdjęcia, notatki i wspomnienia są przechowywane lokalnie na urządzeniu.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'Przeczytałem(-am) i akceptuję Politykę Prywatności.';

  @override
  String get onboardingStep4PrivacyLink => 'Privacy Policy';

  @override
  String get onboardingStep4TermsCheckbox =>
      'Przeczytałem(-am) i akceptuję Warunki Korzystania.';

  @override
  String get onboardingStep4TermsLink => 'Terms of Service';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • OSOBISTE ARCHIWUM';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Ciepły rudy kot';

  @override
  String get avatarDescSageCat => 'Spokojny szałwiowy kot';

  @override
  String get avatarDescLavenderCat => 'Marzycielski lawendowy kot';

  @override
  String get avatarDescCuriousCat => 'Ciekawski kot';

  @override
  String get avatarDescCozyCat => 'Przytulny śpiący kot';

  @override
  String get avatarDescGentlePaw => 'Łagodny ślad łapki';

  @override
  String get avatarDescStarGazer => 'Kot patrzący w gwiazdy';

  @override
  String get avatarDescBookCat => 'Kot czytelnik';

  @override
  String get avatarDescSunlitCat => 'Kot wygrzewający się w słońcu';

  @override
  String get avatarDescWhiskerHeart => 'Wąsate serduszko';

  @override
  String get debugPanelUnlocked => 'Panel programisty odblokowany';

  @override
  String get debugOnboardingCompleted => 'Wprowadzenie ukończone';

  @override
  String get debugAcceptedLegalVersion => 'Zaakceptowana wersja prawna';

  @override
  String get debugResetOnboarding => 'PROGRAMISTA: ZRESETUJ WPROWADZENIE';

  @override
  String get debugOnboardingResetToast => 'Status wprowadzenia zresetowany';

  @override
  String get profileNicknamePlaceholder => 'np. Luna';

  @override
  String get favoriteCatSectionTitle => 'Ulubiony Kot';

  @override
  String get favoriteCatChangeButton => 'Zmień Ulubionego Kota';

  @override
  String get favoriteCatSelectButton => 'Wybierz Ulubionego Kota';

  @override
  String get myStorySectionTitle => 'Moja Historia';

  @override
  String get profileSettingsButton => 'Ustawienia';

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
}
