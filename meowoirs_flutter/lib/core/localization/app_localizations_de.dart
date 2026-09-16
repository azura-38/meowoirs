// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Jede Katze hat eine Geschichte';

  @override
  String get navHome => 'Start';

  @override
  String get navCats => 'Meine Katzen';

  @override
  String get navMemories => 'Erinnerungen';

  @override
  String get navProfile => 'Profil';

  @override
  String get navMyStory => 'Meine Geschichte';

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
  String get editCatTitle => 'Katze bearbeiten';

  @override
  String get editCatSubtitle => 'Details aktualisieren.';

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
  String get editMemoryTitle => 'Erinnerung bearbeiten';

  @override
  String get editMemorySubtitle => 'Aktualisiere diese Erinnerung.';

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
  String get memoryDetailTitle => 'Erinnerungsdetails';

  @override
  String get memoryNotFoundTitle => 'Erinnerung nicht gefunden';

  @override
  String get memoryNotFoundDesc =>
      'Diese Erinnerung ist nicht mehr verfügbar oder wurde gelöscht.';

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
  String get catNotFoundTitle => 'Katze nicht gefunden';

  @override
  String get catNotFoundDesc =>
      'Diese Geschichte ist nicht mehr verfügbar oder wurde gelöscht.';

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
  String get profileGreetingPrefix => 'Hallo';

  @override
  String get profileDefaultTitle => 'Deine Geschichte';

  @override
  String get profileSubtitle =>
      'Dies ist dein persönlicher Bereich in Meowoirs.';

  @override
  String get profileEditButton => 'Profil bearbeiten';

  @override
  String get profileEditDialogTitle => 'Profil bearbeiten';

  @override
  String get profileNicknameLabel => 'Spitzname';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Avatar auswählen';

  @override
  String get profileSave => 'Speichern';

  @override
  String get profileCancel => 'Abbrechen';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'Du hast noch keine Lieblingskatze.';

  @override
  String get favoriteCatEmptyCta => 'Erste Katze hinzufügen';

  @override
  String get favoriteCatNoneSelected => 'Noch keine Lieblingskatze ausgewählt.';

  @override
  String get favoriteCatDialogTitle => 'Lieblingskatze auswählen';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Ganze Geschichte ansehen';

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
  String get statCats => 'Katzen';

  @override
  String get statMemories => 'Momente';

  @override
  String get statHome => 'Zuhause';

  @override
  String get statStreet => 'Draußen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsTermsOfService => 'Nutzungsbedingungen';

  @override
  String get settingsAdPrivacy => 'Werbe-Datenschutz';

  @override
  String get privacyPendingTitle => 'Information';

  @override
  String get privacyPendingDesc =>
      'Unsere Datenschutzerklärung und Nutzungsbedingungen sind bald online verfügbar.';

  @override
  String get umpNotRequired =>
      'Datenschutzoptionen sind für Ihre Region oder Sitzung nicht erforderlich.';

  @override
  String get settingsLanguage => 'App-Sprache';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Kontakt aufnehmen';

  @override
  String get reachUsThankYouTitle => 'Vielen Dank, dass du Meowoirs nutzt.';

  @override
  String get reachUsThankYouDesc =>
      'Wir freuen uns, dass jede kleine Erinnerung mit dir zu einer Geschichte wird.';

  @override
  String get reachUsActionSuggestion => 'Vorschlag senden';

  @override
  String get reachUsActionBug => 'Fehler melden';

  @override
  String get reachUsActionContact => 'Schreib uns';

  @override
  String get reachUsNoEmailApp => 'Keine E-Mail-App auf diesem Gerät gefunden.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Version %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Version %1\$s (Build %2\$d)';
  }

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionSaveChanges => 'Änderungen speichern';

  @override
  String get actionBack => 'Zurück';

  @override
  String get actionRetry => 'Wiederholen';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get deleteCatTitle => 'Möchtest du diese Katze wirklich löschen?';

  @override
  String get deleteCatMessage =>
      'Das Katzenprofil wird gelöscht. Gespeicherte Erinnerungen bleiben erhalten.';

  @override
  String get deleteMemoryTitle =>
      'Möchtest du diese Erinnerung wirklich löschen?';

  @override
  String get deleteMemoryMessage => 'Diese Erinnerung wird dauerhaft gelöscht.';

  @override
  String get errorGenericOperation =>
      'Während des Vorgangs ist ein Fehler aufgetreten. Bitte versuche es erneut.';

  @override
  String get catSaveError =>
      'Beim Speichern der Katze ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get memorySaveError =>
      'Beim Speichern der Erinnerung ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get catDeleteError =>
      'Beim Löschen der Katze ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get memoryDeleteError =>
      'Beim Löschen der Erinnerung ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get photoLoadFailed => 'Foto konnte nicht geladen werden';

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
  String get onboardingSkip => 'ÜBERSPRINGEN';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'BAND I — KAPITEL 01';

  @override
  String get onboardingStep1Badge => 'MORGENLICHT';

  @override
  String get onboardingStep1Quote => '«Wie ein leises Flüstern...»';

  @override
  String get onboardingStep1Intro => 'EINFÜHRUNGSNOTIZ';

  @override
  String get onboardingStep1IntroSub => 'ERÖFFNUNG';

  @override
  String get onboardingStep1Title => 'Jede Katze hat eine Geschichte.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs ist Ihr persönlicher Raum, um die kleinen Momente, Fotos und Geschichten aufzubewahren, die Sie mit Ihren Katzen teilen.';

  @override
  String get onboardingStep1FeatureTitle =>
      'Erstellen Sie Ihr persönliches Archiv';

  @override
  String get onboardingStep1FeatureDesc =>
      'Bauen Sie Ihr eigenes Erinnerungsarchiv mit Fotos, Notizen und kleinen Momenten auf.';

  @override
  String get onboardingStep1Footer1 => 'MEOWOIRS ARCHIV';

  @override
  String get onboardingStep1Footer2 => 'ERSTE SEITE';

  @override
  String get onboardingStep2Chap => 'KAPITEL II — TAGEBUCHFRAGMENTE';

  @override
  String get onboardingStep2Title => 'Bewahren Sie die kleinen Momente.';

  @override
  String get onboardingStep2Subtitle =>
      'Ein Foto, ein paar Worte und das Gefühl dieses Moments.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Morgenschlaf';

  @override
  String get onboardingStep2Date => '14. Oktober';

  @override
  String get onboardingStep2Mood => 'Friedlich';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs verwandelt gewöhnliche Momente in kleine Geschichten, die Sie nicht vergessen wollen.';

  @override
  String get onboardingStep2Footer1 => 'PERSÖNLICHES ARCHIV';

  @override
  String get onboardingStep2Footer2 => 'KLEINE MOMENTE';

  @override
  String get onboardingStep3Chap => 'KAPITEL III — IN IHRER GESCHICHTE';

  @override
  String get onboardingStep3Title =>
      'Jede Katze kann in Ihrer Geschichte sein.';

  @override
  String get onboardingStep3Desc =>
      'Von der Katze in Ihrem Zuhause bis zu einem Freund, den Sie auf der Straße getroffen haben, bewahren Sie die kleinen Momente, die Ihr Leben berühren.';

  @override
  String get onboardingStep3HomeBadge => 'ZU HAUSE';

  @override
  String get onboardingStep3HomeTitle => 'Die Geschichte unseres Zuhauses';

  @override
  String get onboardingStep3StreetBadge => 'STRASSENGESCHICHTE';

  @override
  String get onboardingStep3StreetTitle => 'Geist der Straße';

  @override
  String get onboardingStep3StreetSubtitle =>
      'Olive — Alter Freund aus der Nachbarschaft';

  @override
  String get onboardingStep3FeatureTitle => 'Zu Hause oder auf der Straße';

  @override
  String get onboardingStep3FeatureDesc =>
      'Nehmen Sie die Katzen in Ihrem Zuhause oder die, die Sie auf der Straße treffen, in Ihre eigene Geschichte auf.';

  @override
  String get onboardingStep3Footer1 => 'MEOWOIRS ARCHIV';

  @override
  String get onboardingStep3Footer2 => 'JEDE KATZE';

  @override
  String get onboardingStep4Chap => 'KAPITEL IV • DATENSCHUTZ & VERTRAUEN';

  @override
  String get onboardingStep4Title => 'Ihre Geschichte gehört Ihnen.';

  @override
  String get onboardingStep4Desc =>
      'Ihre Erinnerungen und Fotos bleiben auf Ihrem Gerät. Meowoirs speichert sie nicht auf seinen Servern und erfordert kein Konto oder Cloud-Synchronisierung.';

  @override
  String get onboardingStep4FeatureTitle => 'Bleibt auf Ihrem Gerät';

  @override
  String get onboardingStep4FeatureDesc =>
      'Ihre Katzenprofile, Fotos, Notizen und Erinnerungen werden lokal auf Ihrem Gerät gespeichert.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'Ich habe die Datenschutzrichtlinie gelesen und stimme zu.';

  @override
  String get onboardingStep4PrivacyLink => 'Privacy Policy';

  @override
  String get onboardingStep4TermsCheckbox =>
      'Ich habe die Nutzungsbedingungen gelesen und stimme zu.';

  @override
  String get onboardingStep4TermsLink => 'Terms of Service';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • PERSÖNLICHES ARCHIV';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Warme orange Katze';

  @override
  String get avatarDescSageCat => 'Ruhige Salbeikatze';

  @override
  String get avatarDescLavenderCat => 'Verträumte Lavendelkatze';

  @override
  String get avatarDescCuriousCat => 'Neugierige Katze';

  @override
  String get avatarDescCozyCat => 'Gemütliche schlafende Katze';

  @override
  String get avatarDescGentlePaw => 'Sanfter Pfotenabdruck';

  @override
  String get avatarDescStarGazer => 'Katze unter Sternen';

  @override
  String get avatarDescBookCat => 'Bücherkatze';

  @override
  String get avatarDescSunlitCat => 'Sonnige Katze';

  @override
  String get avatarDescWhiskerHeart => 'Schnurrhaar-Herz';

  @override
  String get debugPanelUnlocked => 'Entwickler-Panel freigeschaltet';

  @override
  String get debugOnboardingCompleted => 'Onboarding abgeschlossen';

  @override
  String get debugAcceptedLegalVersion => 'Akzeptierte rechtliche Version';

  @override
  String get debugResetOnboarding => 'ENTWICKLER: ONBOARDING ZURÜCKSETZEN';

  @override
  String get debugOnboardingResetToast => 'Onboarding-Status zurückgesetzt';

  @override
  String get profileNicknamePlaceholder => 'z.B. Luna';

  @override
  String get favoriteCatSectionTitle => 'Lieblingskatze';

  @override
  String get favoriteCatChangeButton => 'Lieblingskatze ändern';

  @override
  String get favoriteCatSelectButton => 'Lieblingskatze wählen';

  @override
  String get myStorySectionTitle => 'Meine Geschichte';

  @override
  String get profileSettingsButton => 'Einstellungen';

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
