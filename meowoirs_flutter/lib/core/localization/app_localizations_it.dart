// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Ogni gatto ha una storia';

  @override
  String get navHome => 'Home';

  @override
  String get navCats => 'I miei gatti';

  @override
  String get navMemories => 'Ricordi';

  @override
  String get navProfile => 'Profilo';

  @override
  String get navMyStory => 'La mia storia';

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
  String get editCatTitle => 'Modifica gatto';

  @override
  String get editCatSubtitle => 'Aggiorna i dettagli.';

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
  String get editMemoryTitle => 'Modifica ricordo';

  @override
  String get editMemorySubtitle => 'Aggiorna questo ricordo.';

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
  String get memoryDetailTitle => 'Dettaglio ricordo';

  @override
  String get memoryNotFoundTitle => 'Ricordo non trovato';

  @override
  String get memoryNotFoundDesc =>
      'Questo ricordo non è più disponibile o potrebbe essere stato eliminato.';

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
  String get catNotFoundTitle => 'Gatto non trovato';

  @override
  String get catNotFoundDesc =>
      'Questa storia non è più disponibile o potrebbe essere stata eliminata.';

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
  String get profileTitle => 'Profilo';

  @override
  String get profileGreetingPrefix => 'Ciao';

  @override
  String get profileDefaultTitle => 'La tua storia';

  @override
  String get profileSubtitle => 'Questo è il tuo spazio personale in Meowoirs.';

  @override
  String get profileEditButton => 'Modifica profilo';

  @override
  String get profileEditDialogTitle => 'Modifica profilo';

  @override
  String get profileNicknameLabel => 'Soprannome';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Scegli avatar';

  @override
  String get profileSave => 'Salva';

  @override
  String get profileCancel => 'Annulla';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'Non hai ancora un gatto preferito.';

  @override
  String get favoriteCatEmptyCta => 'Aggiungi il tuo primo gatto';

  @override
  String get favoriteCatNoneSelected => 'Nessun gatto preferito selezionato.';

  @override
  String get favoriteCatDialogTitle => 'Seleziona il gatto preferito';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Guarda tutta la storia';

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
  String get statCats => 'Gatti';

  @override
  String get statMemories => 'Ricordi';

  @override
  String get statHome => 'Casa';

  @override
  String get statStreet => 'Strada';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Informativa sulla Privacy';

  @override
  String get settingsTermsOfService => 'Termini di Servizio';

  @override
  String get settingsAdPrivacy => 'Privacy degli annunci';

  @override
  String get privacyPendingTitle => 'Informazioni';

  @override
  String get privacyPendingDesc =>
      'L\'informativa sulla privacy e i termini saranno presto disponibili online.';

  @override
  String get umpNotRequired =>
      'Le opzioni di consenso pubblicitario non sono richieste per la tua regione.';

  @override
  String get settingsLanguage => 'Lingua dell\'app';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Contattaci';

  @override
  String get reachUsThankYouTitle => 'Grazie per aver scelto Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'Siamo felici che ogni piccolo ricordo diventi una storia con te.';

  @override
  String get reachUsActionSuggestion => 'Invia suggerimento';

  @override
  String get reachUsActionBug => 'Segnala un problema';

  @override
  String get reachUsActionContact => 'Scrivici';

  @override
  String get reachUsNoEmailApp =>
      'Nessuna app di posta trovata su questo dispositivo.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Versione %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Versione %1\$s (Build %2\$d)';
  }

  @override
  String get actionEdit => 'Modifica';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get actionCancel => 'Annulla';

  @override
  String get actionSave => 'Salva';

  @override
  String get actionSaveChanges => 'Salva modifiche';

  @override
  String get actionBack => 'Indietro';

  @override
  String get actionRetry => 'Riprova';

  @override
  String get loading => 'Caricamento...';

  @override
  String get deleteCatTitle => 'Sei sicuro di voler eliminare questo gatto?';

  @override
  String get deleteCatMessage =>
      'Il profilo del gatto verrà eliminato. I ricordi salvati saranno conservati.';

  @override
  String get deleteMemoryTitle =>
      'Sei sicuro di voler eliminare questo ricordo?';

  @override
  String get deleteMemoryMessage =>
      'Questo ricordo verrà eliminato definitivamente.';

  @override
  String get errorGenericOperation =>
      'Si è verificato un errore durante l\'operazione. Riprova.';

  @override
  String get catSaveError =>
      'Si è verificato un errore durante il salvataggio del gatto. Riprova.';

  @override
  String get memorySaveError =>
      'Si è verificato un errore durante il salvataggio del ricordo. Riprova.';

  @override
  String get catDeleteError =>
      'Si è verificato un errore durante l\'eliminazione del gatto. Riprova.';

  @override
  String get memoryDeleteError =>
      'Si è verificato un errore durante l\'eliminazione del ricordo. Riprova.';

  @override
  String get photoLoadFailed => 'Impossibile caricare la foto';

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
  String get onboardingSkip => 'SALTA';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'VOLUME I — CAPITOLO 01';

  @override
  String get onboardingStep1Badge => 'LUCE MATTUTINA';

  @override
  String get onboardingStep1Quote => '«Come un sussurro silenzioso...»';

  @override
  String get onboardingStep1Intro => 'NOTA INTRODUTTIVA';

  @override
  String get onboardingStep1IntroSub => 'APERTURA';

  @override
  String get onboardingStep1Title => 'Ogni gatto ha una storia.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs è il tuo spazio personale per conservare i piccoli momenti, le foto e le storie che condividi con i tuoi gatti.';

  @override
  String get onboardingStep1FeatureTitle => 'Crea il tuo archivio personale';

  @override
  String get onboardingStep1FeatureDesc =>
      'Costruisci il tuo archivio di ricordi con foto, appunti e piccoli momenti.';

  @override
  String get onboardingStep1Footer1 => 'ARCHIVIO MEOWOIRS';

  @override
  String get onboardingStep1Footer2 => 'PRIMA PAGINA';

  @override
  String get onboardingStep2Chap => 'CAPITOLO II — FRAMMENTI DI DIARIO';

  @override
  String get onboardingStep2Title => 'Conserva i piccoli momenti.';

  @override
  String get onboardingStep2Subtitle =>
      'Una foto, poche parole e il sentimento di quel momento.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Sonno mattutino';

  @override
  String get onboardingStep2Date => '14 Ottobre';

  @override
  String get onboardingStep2Mood => 'Pacifico';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs trasforma i momenti ordinari in piccole storie che non vorrai dimenticare.';

  @override
  String get onboardingStep2Footer1 => 'ARCHIVIO PERSONALE';

  @override
  String get onboardingStep2Footer2 => 'PICCOLI MOMENTI';

  @override
  String get onboardingStep3Chap => 'CAPITOLO III — NELLA TUA STORIA';

  @override
  String get onboardingStep3Title =>
      'Ogni gatto può far parte della tua storia.';

  @override
  String get onboardingStep3Desc =>
      'Dal gatto in casa tua a un amico incontrato per strada, conserva i piccoli momenti che toccano la tua vita.';

  @override
  String get onboardingStep3HomeBadge => 'A CASA';

  @override
  String get onboardingStep3HomeTitle => 'La storia della nostra casa';

  @override
  String get onboardingStep3StreetBadge => 'STORIA DI STRADA';

  @override
  String get onboardingStep3StreetTitle => 'Spirito della strada';

  @override
  String get onboardingStep3StreetSubtitle =>
      'Olive — Vecchio amico del quartiere';

  @override
  String get onboardingStep3FeatureTitle => 'A casa o per strada';

  @override
  String get onboardingStep3FeatureDesc =>
      'Includi i gatti della tua casa o quelli che incontri per strada nella tua storia.';

  @override
  String get onboardingStep3Footer1 => 'ARCHIVIO MEOWOIRS';

  @override
  String get onboardingStep3Footer2 => 'OGNI GATTO';

  @override
  String get onboardingStep4Chap => 'CAPITOLO IV • PRIVACY E FIDUCIA';

  @override
  String get onboardingStep4Title => 'La tua storia è tua.';

  @override
  String get onboardingStep4Desc =>
      'I tuoi ricordi e le tue foto rimangono sul tuo dispositivo. Meowoirs non li archivia sui propri server e non richiede un account o la sincronizzazione cloud.';

  @override
  String get onboardingStep4FeatureTitle => 'Rimane sul tuo dispositivo';

  @override
  String get onboardingStep4FeatureDesc =>
      'I tuoi profili dei gatti, le foto, gli appunti e i ricordi sono archiviati localmente sul tuo dispositivo.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'Ho letto e accetto l\'Informativa sulla privacy.';

  @override
  String get onboardingStep4PrivacyLink => 'Privacy Policy';

  @override
  String get onboardingStep4TermsCheckbox =>
      'Ho letto e accetto i Termini di servizio.';

  @override
  String get onboardingStep4TermsLink => 'Terms of Service';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • ARCHIVIO PERSONALE';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Gatto arancione caldo';

  @override
  String get avatarDescSageCat => 'Gatto salvia tranquillo';

  @override
  String get avatarDescLavenderCat => 'Gatto lavanda sognatore';

  @override
  String get avatarDescCuriousCat => 'Gatto curioso';

  @override
  String get avatarDescCozyCat => 'Gatto addormentato sereno';

  @override
  String get avatarDescGentlePaw => 'Zampina gentile';

  @override
  String get avatarDescStarGazer => 'Gatto sotto le stelle';

  @override
  String get avatarDescBookCat => 'Gatto lettore';

  @override
  String get avatarDescSunlitCat => 'Gatto al sole';

  @override
  String get avatarDescWhiskerHeart => 'Cuore con baffi';

  @override
  String get debugPanelUnlocked => 'Pannello sviluppatore sbloccato';

  @override
  String get debugOnboardingCompleted => 'Benvenuto completato';

  @override
  String get debugAcceptedLegalVersion => 'Versione legale accettata';

  @override
  String get debugResetOnboarding => 'SVILUPPATORE: REIMPOSTA BENVENUTO';

  @override
  String get debugOnboardingResetToast => 'Stato di benvenuto reimpostato';

  @override
  String get profileNicknamePlaceholder => 'es: Luna';

  @override
  String get favoriteCatSectionTitle => 'Gatto preferito';

  @override
  String get favoriteCatChangeButton => 'Cambia gatto preferito';

  @override
  String get favoriteCatSelectButton => 'Scegli gatto preferito';

  @override
  String get myStorySectionTitle => 'La mia storia';

  @override
  String get profileSettingsButton => 'Impostazioni';

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
