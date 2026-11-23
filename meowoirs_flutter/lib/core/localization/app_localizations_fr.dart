// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Chaque chat a une histoire';

  @override
  String get navHome => 'Accueil';

  @override
  String get navCats => 'Mes chats';

  @override
  String get navMemories => 'Souvenirs';

  @override
  String get navProfile => 'Profil';

  @override
  String get navMyStory => 'Mon histoire';

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
  String get editCatTitle => 'Modifier le chat';

  @override
  String get editCatSubtitle => 'Mettre à jour les informations.';

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
  String get editMemoryTitle => 'Modifier le souvenir';

  @override
  String get editMemorySubtitle => 'Mettre à jour ce souvenir.';

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
  String get memoryDetailTitle => 'Détail du souvenir';

  @override
  String get memoryNotFoundTitle => 'Souvenir non trouvé';

  @override
  String get memoryNotFoundDesc =>
      'Ce souvenir n\'est plus disponible ou a été supprimé.';

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
  String get catNotFoundTitle => 'Chat non trouvé';

  @override
  String get catNotFoundDesc =>
      'Cette histoire n\'est plus disponible ou a été supprimée.';

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
  String get profileGreetingPrefix => 'Bonjour';

  @override
  String get profileDefaultTitle => 'Votre histoire';

  @override
  String get profileSubtitle => 'C\'est votre espace personnel dans Meowoirs.';

  @override
  String get profileEditButton => 'Modifier le profil';

  @override
  String get profileEditDialogTitle => 'Modifier le profil';

  @override
  String get profileNicknameLabel => 'Pseudo';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Choisir un avatar';

  @override
  String get profileSave => 'Enregistrer';

  @override
  String get profileCancel => 'Annuler';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle =>
      'Vous n\'avez pas encore de chat préféré.';

  @override
  String get favoriteCatEmptyCta => 'Ajouter un premier chat';

  @override
  String get favoriteCatNoneSelected => 'Aucun chat préféré sélectionné.';

  @override
  String get favoriteCatDialogTitle => 'Sélectionner le chat préféré';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Voir toute l\'histoire';

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
  String get statCats => 'Chats';

  @override
  String get statMemories => 'Souvenirs';

  @override
  String get statHome => 'Maison';

  @override
  String get statStreet => 'Rue';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsTermsOfService => 'Conditions d\'utilisation';

  @override
  String get settingsAdPrivacy => 'Confidentialité publicitaire';

  @override
  String get privacyPendingTitle => 'Information';

  @override
  String get privacyPendingDesc =>
      'Nos mentions légales et conditions seront bientôt disponibles en ligne.';

  @override
  String get umpNotRequired =>
      'Les options publicitaires ne sont pas requises pour votre région ou session.';

  @override
  String get umpPrivacySubtitle =>
      'Gérer les préférences et autorisations publicitaires';

  @override
  String get settingsLanguage => 'Langue de l\'application';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Nous contacter';

  @override
  String get reachUsThankYouTitle => 'Merci d\'utiliser Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'Chaque petit souvenir devient une histoire précieuse grâce à vous.';

  @override
  String get reachUsActionSuggestion => 'Envoyer une suggestion';

  @override
  String get reachUsActionBug => 'Signaler un bogue';

  @override
  String get reachUsActionContact => 'Nous écrire';

  @override
  String get reachUsNoEmailApp =>
      'Aucune application d\'e-mail trouvée sur cet appareil.';

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
  String get actionEdit => 'Modifier';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionSaveChanges => 'Enregistrer les modifications';

  @override
  String get actionBack => 'Retour';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get deleteCatTitle => 'Voulez-vous vraiment supprimer ce chat ?';

  @override
  String get deleteCatMessage =>
      'Le profil du chat sera supprimé. Les souvenirs enregistrés seront conservés.';

  @override
  String get deleteMemoryTitle =>
      'Voulez-vous vraiment supprimer ce souvenir ?';

  @override
  String get deleteMemoryMessage => 'Ce souvenir sera définitivement supprimé.';

  @override
  String get errorGenericOperation =>
      'Une erreur est survenue lors de l\'opération. Veuillez réessayer.';

  @override
  String get catSaveError =>
      'Une erreur est survenue lors de l\'enregistrement du chat. Veuillez réessayer.';

  @override
  String get memorySaveError =>
      'Une erreur est survenue lors de l\'enregistrement du souvenir. Veuillez réessayer.';

  @override
  String get catDeleteError =>
      'Une erreur est survenue lors de la suppression du chat. Veuillez réessayer.';

  @override
  String get memoryDeleteError =>
      'Une erreur est survenue lors de la suppression du souvenir. Veuillez réessayer.';

  @override
  String get photoLoadFailed => 'La photo n\'a pas pu être chargée';

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
  String get onboardingSkip => 'PASSER';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'VOLUME I — CHAPITRE 01';

  @override
  String get onboardingStep1Badge => 'LUMIÈRE MATINALE';

  @override
  String get onboardingStep1Quote => '«Comme un murmure silencieux...»';

  @override
  String get onboardingStep1Intro => 'NOTE INTRODUCTIVE';

  @override
  String get onboardingStep1IntroSub => 'OUVERTURE';

  @override
  String get onboardingStep1Title => 'Chaque chat a une histoire.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs est votre espace personnel pour conserver les petits moments, les photos et les histoires que vous partagez avec vos chats.';

  @override
  String get onboardingStep1FeatureTitle => 'Créez votre archive personnelle';

  @override
  String get onboardingStep1FeatureDesc =>
      'Construisez votre propre archive de souvenirs avec des photos, des notes et des petits moments.';

  @override
  String get onboardingStep1Footer1 => 'ARCHIVE MEOWOIRS';

  @override
  String get onboardingStep1Footer2 => 'PREMIÈRE PAGE';

  @override
  String get onboardingStep2Chap => 'CHAPITRE II — FRAGMENTS DE JOURNAL';

  @override
  String get onboardingStep2Title => 'Gardez les petits moments.';

  @override
  String get onboardingStep2Subtitle =>
      'Une photo, quelques mots et le sentiment de ce moment.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Sommeil matinal';

  @override
  String get onboardingStep2Date => '14 octobre';

  @override
  String get onboardingStep2Mood => 'Paisible';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs transforme les moments ordinaires en petites histoires que vous ne voudrez pas oublier.';

  @override
  String get onboardingStep2Footer1 => 'ARCHIVE PERSONNELLE';

  @override
  String get onboardingStep2Footer2 => 'PETITS MOMENTS';

  @override
  String get onboardingStep3Chap => 'CHAPITRE III — DANS VOTRE HISTOIRE';

  @override
  String get onboardingStep3Title =>
      'Chaque chat peut faire partie de votre histoire.';

  @override
  String get onboardingStep3Desc =>
      'Du chat de votre maison à un ami rencontré dans la rue, gardez les petits moments qui touchent votre vie.';

  @override
  String get onboardingStep3HomeBadge => 'À LA MAISON';

  @override
  String get onboardingStep3HomeTitle => 'L\'histoire de notre maison';

  @override
  String get onboardingStep3StreetBadge => 'HISTOIRE DE RUE';

  @override
  String get onboardingStep3StreetTitle => 'Esprit de la rue';

  @override
  String get onboardingStep3StreetSubtitle => 'Olive — Vieil ami du quartier';

  @override
  String get onboardingStep3FeatureTitle => 'À la maison ou dans la rue';

  @override
  String get onboardingStep3FeatureDesc =>
      'Incluez les chats de votre maison ou ceux que vous rencontrez dans la rue dans votre propre histoire.';

  @override
  String get onboardingStep3Footer1 => 'ARCHIVE MEOWOIRS';

  @override
  String get onboardingStep3Footer2 => 'CHAQUE CHAT';

  @override
  String get onboardingStep4Chap => 'CHAPITRE IV • CONFIDENTIALITÉ & CONFIANCE';

  @override
  String get onboardingStep4Title => 'Votre histoire vous appartient.';

  @override
  String get onboardingStep4Desc =>
      'Vos souvenirs et photos restent sur votre appareil. Meowoirs ne les stocke pas sur ses serveurs et ne nécessite aucun compte ni synchronisation cloud.';

  @override
  String get onboardingStep4FeatureTitle => 'Reste sur votre appareil';

  @override
  String get onboardingStep4FeatureDesc =>
      'Vos profils de chats, photos, notes et souvenirs sont stockés localement sur votre appareil.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'J\'ai lu et j\'accepte la Politique de confidentialité.';

  @override
  String get onboardingStep4PrivacyLink => 'Politique de confidentialité';

  @override
  String get onboardingStep4TermsCheckbox =>
      'J\'ai lu et j\'accepte les Conditions d\'utilisation.';

  @override
  String get onboardingStep4TermsLink => 'Conditions d\'utilisation';

  @override
  String get onboardingStep4CombinedCheckbox =>
      'J\'ai lu et j\'accepte la Politique de confidentialité et les Conditions d\'utilisation.';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • ARCHIVE PERSONNELLE';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Chat orange chaleureux';

  @override
  String get avatarDescSageCat => 'Chat sauge serein';

  @override
  String get avatarDescLavenderCat => 'Chat lavande rêveur';

  @override
  String get avatarDescCuriousCat => 'Chat curieux';

  @override
  String get avatarDescCozyCat => 'Chat endormi paisible';

  @override
  String get avatarDescGentlePaw => 'Douce patte de chat';

  @override
  String get avatarDescStarGazer => 'Chat observant les étoiles';

  @override
  String get avatarDescBookCat => 'Chat lecteur';

  @override
  String get avatarDescSunlitCat => 'Chat au soleil';

  @override
  String get avatarDescWhiskerHeart => 'Cœur à moustaches';

  @override
  String get debugPanelUnlocked => 'Panneau développeur déverrouillé';

  @override
  String get debugOnboardingCompleted => 'Bienvenue terminé';

  @override
  String get debugAcceptedLegalVersion => 'Version légale acceptée';

  @override
  String get debugResetOnboarding => 'DÉVELOPPEUR : RÉINITIALISER BIENVENUE';

  @override
  String get debugOnboardingResetToast => 'Statut de bienvenue réinitialisé';

  @override
  String get profileNicknamePlaceholder => 'ex: Luna';

  @override
  String get favoriteCatSectionTitle => 'Chat préféré';

  @override
  String get favoriteCatChangeButton => 'Changer de chat préféré';

  @override
  String get favoriteCatSelectButton => 'Choisir un chat préféré';

  @override
  String get myStorySectionTitle => 'Mon histoire';

  @override
  String get profileSettingsButton => 'Paramètres';

  @override
  String get tooltipBack => 'Go back';

  @override
  String get semanticsSelected => 'selected';

  @override
  String get semanticsNotSelected => 'not selected';

  @override
  String get moodHappy => 'Heureux';

  @override
  String get moodCurious => 'Curieux';

  @override
  String get moodSleepy => 'Endormi';

  @override
  String get moodPlayful => 'Joueur';

  @override
  String get moodCalm => 'Calme';

  @override
  String get moodAffectionate => 'Affectueux';

  @override
  String get moodPeaceful => 'Paisible';

  @override
  String get moodNostalgic => 'Nostalgique';

  @override
  String get moodJoyful => 'Joyeux';

  @override
  String get moodEmotional => 'Ému';

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
  String get memoriesViewMenuLabel => 'Affichage';

  @override
  String get memoriesViewMenuSemantic => 'Options d\'affichage';

  @override
  String get memoriesViewModeTiles => 'Mosaïque';

  @override
  String get memoriesViewModeLargeIcons => 'Grandes icônes';

  @override
  String get memoriesViewModeSmallIcons => 'Petites icônes';

  @override
  String get memoriesViewModeList => 'Liste';

  @override
  String get memoriesViewModeContent => 'Contenu';

  @override
  String get profileTryOtherAppsTitle => 'Essayez nos autres applications';

  @override
  String get profileTryOtherAppsSubtitle =>
      'Découvrez d\'autres applications de LIMANEX';

  @override
  String get profileComingSoonTitle => 'Bientôt disponible';

  @override
  String get profileComingSoonSubtitle => 'Voir les prochaines fonctionnalités';

  @override
  String get limanexAppsPageTitle => 'Essayez nos autres applications';

  @override
  String get limanexStudioBadge => 'LIMANEX STUDIO';

  @override
  String get limanexStudioWelcome =>
      'Conçu avec soin par LIMANEX. Découvrez les autres applications bienveillantes de notre studio.';

  @override
  String get vitaCaseAppName => 'VitaCase';

  @override
  String get vitaCaseTagline => 'Your Personal Health & Wellness Companion';

  @override
  String get vitaCaseDescription =>
      'Organisez vos documents médicaux, suivez vos rendez-vous et gérez vos rappels de médicaments en toute confidentialité sur votre appareil.';

  @override
  String get vitaCaseCtaExplore => 'Découvrir VitaCase';

  @override
  String get vitaCaseLaunchFallbackMessage =>
      'Impossible d\'ouvrir le lien de la boutique sur cet appareil.';

  @override
  String get vitaCasePromoPlaceholderLabel => 'Aperçu de VitaCase';

  @override
  String get comingSoonPageTitle => 'Bientôt disponible';

  @override
  String get comingSoonHeaderIntro =>
      'De nouvelles fonctionnalités arrivent bientôt pour rendre Meowoirs encore plus spécial !';

  @override
  String get comingSoonFeature1Title => 'Collage de souvenirs';

  @override
  String get comingSoonFeature1Desc =>
      'Créez, modifiez, enregistrez, rouvrez, supprimez et exportez de magnifiques collages avec 2 à 6 photos et trois modèles, avec titre, date et chat associé.';

  @override
  String get comingSoonFeature2Title => 'Chronologie du chat';

  @override
  String get comingSoonFeature2Desc =>
      'Rassemblez les souvenirs d\'un chat par ordre chronologique avec navigation par date, premières rencontres et moments importants.';

  @override
  String get comingSoonFeature3Title => 'Ce jour-là';

  @override
  String get comingSoonFeature3Desc =>
      'Redécouvrez les souvenirs enregistrés à la même date les années précédentes et faites revivre vos moments précieux.';

  @override
  String get comingSoonFeature4Title => 'Notre histoire';

  @override
  String get comingSoonFeature4Desc =>
      'Une page d\'histoire personnelle présentant la date de rencontre avec votre chat, les étapes marquantes, des photos choisies et des souvenirs spéciaux.';

  @override
  String get comingSoonFeature5Title => 'Rappels de souvenirs';

  @override
  String get comingSoonFeature5Desc =>
      'Rappels locaux facultatifs, préférences personnalisées et notifications discrètes pour revisiter vos souvenirs.';

  @override
  String get comingSoonFeature6Title => 'Améliorations des archives';

  @override
  String get comingSoonFeature6Desc =>
      'Recherche améliorée, filtres par date et par chat, favoris et navigation plus rapide dans les archives.';

  @override
  String get comingSoonFeature7Title => 'Créations partageables';

  @override
  String get comingSoonFeature7Desc =>
      'Plus de mises en page de collages, de nouveaux thèmes visuels et des formats d\'exportation de type story pour partager vos souvenirs.';

  @override
  String get comingSoonFeature8Title => 'Outils d\'archivage personnel';

  @override
  String get comingSoonFeature8Desc =>
      'Options d\'exportation et de restauration locales, intégrité des fichiers renforcée, gestion du stockage et protection contre la perte de données.';
}
