// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Elke kat heeft een verhaal';

  @override
  String get navHome => 'Home';

  @override
  String get navCats => 'Mijn katten';

  @override
  String get navMemories => 'Herinneringen';

  @override
  String get navProfile => 'Profiel';

  @override
  String get navMyStory => 'Mijn verhaal';

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
  String get editCatTitle => 'Kat bewerken';

  @override
  String get editCatSubtitle => 'Gegevens bijwerken.';

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
  String get editMemoryTitle => 'Herinnering bewerken';

  @override
  String get editMemorySubtitle => 'Werk deze herinnering bij.';

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
  String get memoryDetailTitle => 'Herinnering detail';

  @override
  String get memoryNotFoundTitle => 'Herinnering niet gevonden';

  @override
  String get memoryNotFoundDesc =>
      'Deze herinnering is niet meer beschikbaar of is mogelijk verwijderd.';

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
  String get catNotFoundTitle => 'Kat niet gevonden';

  @override
  String get catNotFoundDesc =>
      'Dit verhaal is niet meer beschikbaar of is mogelijk verwijderd.';

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
  String get profileTitle => 'Profiel';

  @override
  String get profileGreetingPrefix => 'Hallo';

  @override
  String get profileDefaultTitle => 'Jouw verhaal';

  @override
  String get profileSubtitle => 'Dit is jouw persoonlijke plekje in Meowoirs.';

  @override
  String get profileEditButton => 'Profiel bewerken';

  @override
  String get profileEditDialogTitle => 'Profiel bewerken';

  @override
  String get profileNicknameLabel => 'Bijnaam';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Kies avatar';

  @override
  String get profileSave => 'Opslaan';

  @override
  String get profileCancel => 'Annuleren';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'Je hebt nog geen favoriete kat.';

  @override
  String get favoriteCatEmptyCta => 'Voeg je eerste kat toe';

  @override
  String get favoriteCatNoneSelected => 'Nog geen favoriete kat gekozen.';

  @override
  String get favoriteCatDialogTitle => 'Kies favoriete kat';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Bekijk heel het verhaal';

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
  String get statCats => 'Katten';

  @override
  String get statMemories => 'Momenten';

  @override
  String get statHome => 'Thuis';

  @override
  String get statStreet => 'Buiten';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Privacybeleid';

  @override
  String get settingsTermsOfService => 'Algemene Voorwaarden';

  @override
  String get settingsAdPrivacy => 'Advertentie-privacy';

  @override
  String get privacyPendingTitle => 'Informatie';

  @override
  String get privacyPendingDesc =>
      'Onze voorwaarden en privacybeleid zijn binnenkort online beschikbaar.';

  @override
  String get umpNotRequired =>
      'Advertentie-privacyopties zijn niet vereist in jouw regio.';

  @override
  String get settingsLanguage => 'App-taal';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Contacteer ons';

  @override
  String get reachUsThankYouTitle => 'Bedankt voor het gebruik van Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'We zijn blij dat elke kleine herinnering samen met jou een verhaal wordt.';

  @override
  String get reachUsActionSuggestion => 'Suggestie sturen';

  @override
  String get reachUsActionBug => 'Fout melden';

  @override
  String get reachUsActionContact => 'Schrijf ons';

  @override
  String get reachUsNoEmailApp => 'Geen e-mailapp gevonden op dit apparaat.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Versie %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Versie %1\$s (Build %2\$d)';
  }

  @override
  String get actionEdit => 'Bewerken';

  @override
  String get actionDelete => 'Verwijderen';

  @override
  String get actionCancel => 'Annuleren';

  @override
  String get actionSave => 'Opslaan';

  @override
  String get actionSaveChanges => 'Wijzigingen opslaan';

  @override
  String get actionBack => 'Terug';

  @override
  String get actionRetry => 'Opnieuw proberen';

  @override
  String get loading => 'Laden...';

  @override
  String get deleteCatTitle =>
      'Weet je zeker dat je deze kat wilt verwijderen?';

  @override
  String get deleteCatMessage =>
      'Het kattenprofiel wordt verwijderd. Opgeslagen herinneringen blijven bewaard.';

  @override
  String get deleteMemoryTitle =>
      'Weet je zeker dat je deze herinnering wilt verwijderen?';

  @override
  String get deleteMemoryMessage =>
      'Deze herinnering wordt permanent verwijderd.';

  @override
  String get errorGenericOperation =>
      'Er is een fout opgetreden tijdens de bewerking. Probeer het opnieuw.';

  @override
  String get catSaveError =>
      'Er is een fout opgetreden bij het opslaan van de kat. Probeer het opnieuw.';

  @override
  String get memorySaveError =>
      'Er is een fout opgetreden bij het opslaan van de herinnering. Probeer het opnieuw.';

  @override
  String get catDeleteError =>
      'Er is een fout opgetreden bij het verwijderen van de kat. Probeer het opnieuw.';

  @override
  String get memoryDeleteError =>
      'Er is een fout opgetreden bij het verwijderen van de herinnering. Probeer het opnieuw.';

  @override
  String get photoLoadFailed => 'Foto kon niet worden geladen';

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
  String get onboardingSkip => 'OVERSLAAN';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'DEEL I — HOOFDSTUK 01';

  @override
  String get onboardingStep1Badge => 'OCHTENDLICHT';

  @override
  String get onboardingStep1Quote => '«Als een zacht gefluister...»';

  @override
  String get onboardingStep1Intro => 'INLEIDENDE NOTITIE';

  @override
  String get onboardingStep1IntroSub => 'OPENING';

  @override
  String get onboardingStep1Title => 'Elke kat heeft een verhaal.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs is jouw persoonlijke plek om kleine momenten, foto\'s en verhalen met je katten te bewaren.';

  @override
  String get onboardingStep1FeatureTitle => 'Bouw je persoonlijke archief';

  @override
  String get onboardingStep1FeatureDesc =>
      'Creëer je eigen herinneringenarchief met foto\'s, notities en kleine momenten.';

  @override
  String get onboardingStep1Footer1 => 'MEOWOIRS ARCHIEF';

  @override
  String get onboardingStep1Footer2 => 'EERSTE PAGINA';

  @override
  String get onboardingStep2Chap => 'HOOFDSTUK II — DAGBOEKFRAGMENTEN';

  @override
  String get onboardingStep2Title => 'Bewaar de kleine momenten.';

  @override
  String get onboardingStep2Subtitle =>
      'Een foto, een paar woorden en het gevoel van dat moment.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Ochtendslaap';

  @override
  String get onboardingStep2Date => '14 oktober';

  @override
  String get onboardingStep2Mood => 'Vredig';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs maakt van gewone momenten kleine verhalen die je nooit wilt vergeten.';

  @override
  String get onboardingStep2Footer1 => 'PERSOONLIJK ARCHIEF';

  @override
  String get onboardingStep2Footer2 => 'KLEINE MOMENTEN';

  @override
  String get onboardingStep3Chap => 'HOOFDSTUK III — IN JOUW VERHAAL';

  @override
  String get onboardingStep3Title => 'Elke kat kan in jouw verhaal horen.';

  @override
  String get onboardingStep3Desc =>
      'Van de kat in huis tot een vriend die je op straat ontmoet, bewaar de kleine momenten die je leven raken.';

  @override
  String get onboardingStep3HomeBadge => 'THUIS';

  @override
  String get onboardingStep3HomeTitle => 'Het verhaal van ons thuis';

  @override
  String get onboardingStep3StreetBadge => 'STRAATVERHAAL';

  @override
  String get onboardingStep3StreetTitle => 'Geest van de straat';

  @override
  String get onboardingStep3StreetSubtitle =>
      'Olijfje — Oude vriend uit de buurt';

  @override
  String get onboardingStep3FeatureTitle => 'Thuis of op straat';

  @override
  String get onboardingStep3FeatureDesc =>
      'Neem de katten thuis of die je op straat tegenkomt op in je eigen verhaal.';

  @override
  String get onboardingStep3Footer1 => 'MEOWOIRS ARCHIEF';

  @override
  String get onboardingStep3Footer2 => 'ELKE KAT';

  @override
  String get onboardingStep4Chap => 'HOOFDSTUK IV • PRIVACY & VERTROUWEN';

  @override
  String get onboardingStep4Title => 'Jouw verhaal is van jou.';

  @override
  String get onboardingStep4Desc =>
      'Je herinneringen en foto\'s blijven op je apparaat. Meowoirs slaat ze niet op eigen servers op en vereist geen account of cloudsynchronisatie.';

  @override
  String get onboardingStep4FeatureTitle => 'Blijft op je apparaat';

  @override
  String get onboardingStep4FeatureDesc =>
      'Je katprofielen, foto\'s, notities en herinneringen worden lokaal opgeslagen.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'Ik heb het Privacybeleid gelezen en ga akkoord.';

  @override
  String get onboardingStep4PrivacyLink => 'Privacy Policy';

  @override
  String get onboardingStep4TermsCheckbox =>
      'Ik heb de Gebruiksvoorwaarden gelezen en ga akkoord.';

  @override
  String get onboardingStep4TermsLink => 'Terms of Service';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • PERSOONLIJK ARCHIEF';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Warme oranje kat';

  @override
  String get avatarDescSageCat => 'Rustige saliekat';

  @override
  String get avatarDescLavenderCat => 'Dromerige lavendelkat';

  @override
  String get avatarDescCuriousCat => 'Nieuwsgierige kat';

  @override
  String get avatarDescCozyCat => 'Gezellige slapende kat';

  @override
  String get avatarDescGentlePaw => 'Zacht pootje';

  @override
  String get avatarDescStarGazer => 'Kat onder de sterren';

  @override
  String get avatarDescBookCat => 'Lezende kat';

  @override
  String get avatarDescSunlitCat => 'Kat in het zonlicht';

  @override
  String get avatarDescWhiskerHeart => 'Snorharen hartje';

  @override
  String get debugPanelUnlocked => 'Ontwikkelaarspaneel ontgrendeld';

  @override
  String get debugOnboardingCompleted => 'Introductie voltooid';

  @override
  String get debugAcceptedLegalVersion => 'Geaccepteerde juridische versie';

  @override
  String get debugResetOnboarding => 'ONTWIKKELAAR: INTRODUCTIE RESETTEN';

  @override
  String get debugOnboardingResetToast => 'Introductiestatus gereset';

  @override
  String get profileNicknamePlaceholder => 'bijv: Luna';

  @override
  String get favoriteCatSectionTitle => 'Favoriete kat';

  @override
  String get favoriteCatChangeButton => 'Favoriete kat wijzigen';

  @override
  String get favoriteCatSelectButton => 'Favoriete kat kiezen';

  @override
  String get myStorySectionTitle => 'Mijn verhaal';

  @override
  String get profileSettingsButton => 'Instellingen';

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
