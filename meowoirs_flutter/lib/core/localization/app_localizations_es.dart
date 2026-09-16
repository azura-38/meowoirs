// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Cada gato tiene una historia';

  @override
  String get navHome => 'Inicio';

  @override
  String get navCats => 'Mis Gatos';

  @override
  String get navMemories => 'Recuerdos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navMyStory => 'Mi Historia';

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
  String get editCatTitle => 'Editar gato';

  @override
  String get editCatSubtitle => 'Actualizar los detalles.';

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
  String get editMemoryTitle => 'Editar recuerdo';

  @override
  String get editMemorySubtitle => 'Actualizar este recuerdo.';

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
  String get memoryDetailTitle => 'Detalle del recuerdo';

  @override
  String get memoryNotFoundTitle => 'Recuerdo no encontrado';

  @override
  String get memoryNotFoundDesc =>
      'Este recuerdo ya no está disponible o puede haber sido eliminado.';

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
  String get catNotFoundTitle => 'Gato no encontrado';

  @override
  String get catNotFoundDesc =>
      'Esta historia ya no está disponible o puede haber sido eliminada.';

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
  String get profileTitle => 'Perfil';

  @override
  String get profileGreetingPrefix => 'Hola';

  @override
  String get profileDefaultTitle => 'Tu Historia';

  @override
  String get profileSubtitle => 'Este es tu rincón personal en Meowoirs.';

  @override
  String get profileEditButton => 'Editar Perfil';

  @override
  String get profileEditDialogTitle => 'Editar Perfil';

  @override
  String get profileNicknameLabel => 'Apodo';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Elegir Avatar';

  @override
  String get profileSave => 'Guardar';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'Aún no tienes un gato favorito.';

  @override
  String get favoriteCatEmptyCta => 'Añadir Primer Gato';

  @override
  String get favoriteCatNoneSelected => 'Ningún gato favorito seleccionado.';

  @override
  String get favoriteCatDialogTitle => 'Seleccionar Gato Favorito';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Ver Historia Completa';

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
  String get statCats => 'Gatos';

  @override
  String get statMemories => 'Recuerdos';

  @override
  String get statHome => 'Casa';

  @override
  String get statStreet => 'Calle';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidad';

  @override
  String get settingsTermsOfService => 'Términos de Servicio';

  @override
  String get settingsAdPrivacy => 'Privacidad de Anuncios';

  @override
  String get privacyPendingTitle => 'Información';

  @override
  String get privacyPendingDesc =>
      'Nuestros términos y políticas estarán disponibles en línea próximamente.';

  @override
  String get umpNotRequired =>
      'Las opciones de privacidad no son requeridas en su región o sesión actual.';

  @override
  String get settingsLanguage => 'Idioma de la Aplicación';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Contáctanos';

  @override
  String get reachUsThankYouTitle => 'Gracias por usar Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'Nos alegra que cada pequeño recuerdo se convierta en una historia contigo.';

  @override
  String get reachUsActionSuggestion => 'Enviar Sugerencia';

  @override
  String get reachUsActionBug => 'Informar de un Error';

  @override
  String get reachUsActionContact => 'Escríbenos';

  @override
  String get reachUsNoEmailApp =>
      'No se encontró ninguna aplicación de correo en este dispositivo.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Versión %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Versión %1\$s (Compilación %2\$d)';
  }

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionSaveChanges => 'Guardar cambios';

  @override
  String get actionBack => 'Atrás';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get loading => 'Cargando...';

  @override
  String get deleteCatTitle => '¿Seguro que quieres eliminar este gato?';

  @override
  String get deleteCatMessage =>
      'Se eliminará el perfil del gato. Se conservarán los recuerdos guardados.';

  @override
  String get deleteMemoryTitle => '¿Seguro que quieres eliminar este recuerdo?';

  @override
  String get deleteMemoryMessage =>
      'Este recuerdo se eliminará permanentemente.';

  @override
  String get errorGenericOperation =>
      'Ocurrió un error durante la operación. Por favor, inténtalo de nuevo.';

  @override
  String get catSaveError =>
      'Ocurrió un error al guardar el gato. Por favor, inténtalo de nuevo.';

  @override
  String get memorySaveError =>
      'Ocurrió un error al guardar el recuerdo. Por favor, inténtalo de nuevo.';

  @override
  String get catDeleteError =>
      'Ocurrió un error al eliminar el gato. Por favor, inténtalo de nuevo.';

  @override
  String get memoryDeleteError =>
      'Ocurrió un error al eliminar el recuerdo. Por favor, inténtalo de nuevo.';

  @override
  String get photoLoadFailed => 'No se pudo cargar la foto';

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
  String get onboardingSkip => 'OMITIR';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'VOLUMEN I — CAPÍTULO 01';

  @override
  String get onboardingStep1Badge => 'LUZ DE LA MAÑANA';

  @override
  String get onboardingStep1Quote => '«Como un susurro silencioso...»';

  @override
  String get onboardingStep1Intro => 'NOTA INTRODUCTORIA';

  @override
  String get onboardingStep1IntroSub => 'APERTURA';

  @override
  String get onboardingStep1Title => 'Cada gato tiene una historia.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs es tu espacio personal para guardar los pequeños momentos, fotos e historias que compartes con tus gatos.';

  @override
  String get onboardingStep1FeatureTitle => 'Crea tu archivo personal';

  @override
  String get onboardingStep1FeatureDesc =>
      'Construye tu propio archivo de recuerdos con fotos, notas y pequeños momentos.';

  @override
  String get onboardingStep1Footer1 => 'ARCHIVO MEOWOIRS';

  @override
  String get onboardingStep1Footer2 => 'PRIMERA PÁGINA';

  @override
  String get onboardingStep2Chap => 'CAPÍTULO II — FRAGMENTOS DE DIARIO';

  @override
  String get onboardingStep2Title => 'Guarda los pequeños momentos.';

  @override
  String get onboardingStep2Subtitle =>
      'Una foto, unas pocas palabras y el sentimiento de ese momento.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Sueño matutino';

  @override
  String get onboardingStep2Date => '14 de octubre';

  @override
  String get onboardingStep2Mood => 'Pacífico';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs convierte los momentos ordinarios en pequeñas historias que no querrás olvidar.';

  @override
  String get onboardingStep2Footer1 => 'ARCHIVO PERSONAL';

  @override
  String get onboardingStep2Footer2 => 'PEQUEÑOS MOMENTOS';

  @override
  String get onboardingStep3Chap => 'CAPÍTULO III — EN TU HISTORIA';

  @override
  String get onboardingStep3Title => 'Cada gato puede estar en tu historia.';

  @override
  String get onboardingStep3Desc =>
      'Desde el gato en tu hogar hasta un amigo que conociste en la calle, guarda los pequeños momentos que tocan tu vida.';

  @override
  String get onboardingStep3HomeBadge => 'EN CASA';

  @override
  String get onboardingStep3HomeTitle => 'La historia de nuestro hogar';

  @override
  String get onboardingStep3StreetBadge => 'HISTORIA DE LA CALLE';

  @override
  String get onboardingStep3StreetTitle => 'Espíritu de la calle';

  @override
  String get onboardingStep3StreetSubtitle => 'Olive — Viejo amigo del barrio';

  @override
  String get onboardingStep3FeatureTitle => 'En casa o en la calle';

  @override
  String get onboardingStep3FeatureDesc =>
      'Incluye a los gatos de tu hogar o a los que conoces en la calle en tu propia historia.';

  @override
  String get onboardingStep3Footer1 => 'ARCHIVO MEOWOIRS';

  @override
  String get onboardingStep3Footer2 => 'CADA GATO';

  @override
  String get onboardingStep4Chap => 'CAPÍTULO IV • PRIVACIDAD Y CONFIANZA';

  @override
  String get onboardingStep4Title => 'Tu historia es tuya.';

  @override
  String get onboardingStep4Desc =>
      'Tus recuerdos y fotos permanecen en tu dispositivo. Meowoirs no los almacena en sus servidores y no requiere una cuenta ni sincronización en la nube.';

  @override
  String get onboardingStep4FeatureTitle => 'Permanece en tu dispositivo';

  @override
  String get onboardingStep4FeatureDesc =>
      'Tus perfiles de gatos, fotos, notas y recuerdos se almacenan localmente en tu dispositivo.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'He leído y acepto la Política de Privacidad.';

  @override
  String get onboardingStep4PrivacyLink => 'Privacy Policy';

  @override
  String get onboardingStep4TermsCheckbox =>
      'He leído y acepto los Términos de Servicio.';

  @override
  String get onboardingStep4TermsLink => 'Terms of Service';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • ARCHIVO PERSONAL';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Gato naranja cálido';

  @override
  String get avatarDescSageCat => 'Gato salvia sereno';

  @override
  String get avatarDescLavenderCat => 'Gato lavanda soñador';

  @override
  String get avatarDescCuriousCat => 'Gato curioso';

  @override
  String get avatarDescCozyCat => 'Gato dormido acogedor';

  @override
  String get avatarDescGentlePaw => 'Huella suave de gato';

  @override
  String get avatarDescStarGazer => 'Gato mirando las estrellas';

  @override
  String get avatarDescBookCat => 'Gato lector';

  @override
  String get avatarDescSunlitCat => 'Gato al sol';

  @override
  String get avatarDescWhiskerHeart => 'Corazón con bigotes';

  @override
  String get debugPanelUnlocked => 'Panel de desarrollador desbloqueado';

  @override
  String get debugOnboardingCompleted => 'Bienvenida completada';

  @override
  String get debugAcceptedLegalVersion => 'Versión legal aceptada';

  @override
  String get debugResetOnboarding => 'DESARROLLADOR: REINICIAR BIENVENIDA';

  @override
  String get debugOnboardingResetToast => 'Estado de bienvenida restablecido';

  @override
  String get profileNicknamePlaceholder => 'ej: Luna';

  @override
  String get favoriteCatSectionTitle => 'Gato Favorito';

  @override
  String get favoriteCatChangeButton => 'Cambiar Gato Favorito';

  @override
  String get favoriteCatSelectButton => 'Elegir Gato Favorito';

  @override
  String get myStorySectionTitle => 'Mi Historia';

  @override
  String get profileSettingsButton => 'Ajustes';

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
