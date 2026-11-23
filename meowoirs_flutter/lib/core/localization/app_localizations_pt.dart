// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Cada gato tem uma história';

  @override
  String get navHome => 'Início';

  @override
  String get navCats => 'Meus Gatos';

  @override
  String get navMemories => 'Memórias';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navMyStory => 'Minha História';

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
  String get editCatSubtitle => 'Atualize os detalhes.';

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
  String get editMemoryTitle => 'Editar memória';

  @override
  String get editMemorySubtitle => 'Atualize esta memória.';

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
  String get memoryDetailTitle => 'Detalhe da memória';

  @override
  String get memoryNotFoundTitle => 'Lembrança não encontrada';

  @override
  String get memoryNotFoundDesc =>
      'Esta lembrança não está mais disponível ou pode ter sido excluída.';

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
  String get catNotFoundTitle => 'Gato não encontrado';

  @override
  String get catNotFoundDesc =>
      'Esta história não está mais disponível ou pode ter sido excluída.';

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
  String get profileGreetingPrefix => 'Olá';

  @override
  String get profileDefaultTitle => 'Sua História';

  @override
  String get profileSubtitle => 'Este é o seu espaço pessoal no Meowoirs.';

  @override
  String get profileEditButton => 'Editar Perfil';

  @override
  String get profileEditDialogTitle => 'Editar Perfil';

  @override
  String get profileNicknameLabel => 'Apelido';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'Escolher Avatar';

  @override
  String get profileSave => 'Salvar';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'Você ainda não tem um gato favorito.';

  @override
  String get favoriteCatEmptyCta => 'Adicionar Primeiro Gato';

  @override
  String get favoriteCatNoneSelected => 'Nenhum gato favorito selecionado.';

  @override
  String get favoriteCatDialogTitle => 'Selecionar Gato Favorito';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'Ver História Completa';

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
  String get statMemories => 'Memórias';

  @override
  String get statHome => 'Casa';

  @override
  String get statStreet => 'Rua';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidade';

  @override
  String get settingsTermsOfService => 'Termos de Serviço';

  @override
  String get settingsAdPrivacy => 'Privacidade de Anúncios';

  @override
  String get privacyPendingTitle => 'Informação';

  @override
  String get privacyPendingDesc =>
      'Nossa política de privacidade e termos estarão disponíveis online em breve.';

  @override
  String get umpNotRequired =>
      'Opções de privacidade de anúncios não são necessárias na sua região.';

  @override
  String get umpPrivacySubtitle =>
      'Gerencie suas preferências e permissões de anúncios';

  @override
  String get settingsLanguage => 'Idioma do Aplicativo';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'Fale Conosco';

  @override
  String get reachUsThankYouTitle => 'Obrigado por usar o Meowoirs.';

  @override
  String get reachUsThankYouDesc =>
      'Ficamos felizes que cada pequena memória se torne uma história com você.';

  @override
  String get reachUsActionSuggestion => 'Enviar Sugestão';

  @override
  String get reachUsActionBug => 'Relatar Erro';

  @override
  String get reachUsActionContact => 'Escreva para Nós';

  @override
  String get reachUsNoEmailApp =>
      'Nenhum aplicativo de e-mail encontrado neste dispositivo.';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'Versão %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Versão %1\$s (Build %2\$d)';
  }

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionSaveChanges => 'Salvar alterações';

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get loading => 'Carregando...';

  @override
  String get deleteCatTitle => 'Tem certeza de que deseja excluir este gato?';

  @override
  String get deleteCatMessage =>
      'O perfil do gato será excluído. As memórias salvas serão preservadas.';

  @override
  String get deleteMemoryTitle =>
      'Tem certeza de que deseja excluir esta memória?';

  @override
  String get deleteMemoryMessage =>
      'Esta memória será excluída permanentemente.';

  @override
  String get errorGenericOperation =>
      'Ocorreu um erro durante a operação. Tente novamente.';

  @override
  String get catSaveError =>
      'Ocorreu um erro ao salvar o gato. Tente novamente.';

  @override
  String get memorySaveError =>
      'Ocorreu um erro ao salvar a lembrança. Tente novamente.';

  @override
  String get catDeleteError =>
      'Ocorreu um erro ao excluir o gato. Tente novamente.';

  @override
  String get memoryDeleteError =>
      'Ocorreu um erro ao excluir a lembrança. Tente novamente.';

  @override
  String get photoLoadFailed => 'Não foi possível carregar a foto';

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
  String get onboardingSkip => 'PULAR';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => 'VOLUME I — CAPÍTULO 01';

  @override
  String get onboardingStep1Badge => 'LUZ DA MANHÃ';

  @override
  String get onboardingStep1Quote => '«Como um sussurro silencioso...»';

  @override
  String get onboardingStep1Intro => 'NOTA INTRODUTÓRIA';

  @override
  String get onboardingStep1IntroSub => 'ABERTURA';

  @override
  String get onboardingStep1Title => 'Cada gato tem uma história.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs é o seu espaço pessoal para guardar os pequenos momentos, fotos e histórias que você compartilha com seus gatos.';

  @override
  String get onboardingStep1FeatureTitle => 'Crie seu Arquivo Pessoal';

  @override
  String get onboardingStep1FeatureDesc =>
      'Construa seu próprio arquivo de memórias com fotos, notas e pequenos momentos.';

  @override
  String get onboardingStep1Footer1 => 'ARQUIVO MEOWOIRS';

  @override
  String get onboardingStep1Footer2 => 'PRIMEIRA PÁGINA';

  @override
  String get onboardingStep2Chap => 'CAPÍTULO II — FRAGMENTOS DE DIÁRIO';

  @override
  String get onboardingStep2Title => 'Guarde os pequenos momentos.';

  @override
  String get onboardingStep2Subtitle =>
      'Uma foto, algumas palavras e o sentimento daquele momento.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Sono Matinal';

  @override
  String get onboardingStep2Date => '14 de Outubro';

  @override
  String get onboardingStep2Mood => 'Pacífico';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs transforma momentos comuns em pequenas histórias que você não vai querer esquecer.';

  @override
  String get onboardingStep2Footer1 => 'ARQUIVO PESSOAL';

  @override
  String get onboardingStep2Footer2 => 'PEQUENOS MOMENTOS';

  @override
  String get onboardingStep3Chap => 'CAPÍTULO III — NA SUA HISTÓRIA';

  @override
  String get onboardingStep3Title => 'Cada gato pode estar na sua história.';

  @override
  String get onboardingStep3Desc =>
      'Desde o gato na sua casa até um amigo que conheceu na rua, guarde os pequenos momentos que tocam a sua vida.';

  @override
  String get onboardingStep3HomeBadge => 'EM CASA';

  @override
  String get onboardingStep3HomeTitle => 'A História da Nossa Casa';

  @override
  String get onboardingStep3StreetBadge => 'HISTÓRIA DE RUA';

  @override
  String get onboardingStep3StreetTitle => 'Espírito da Rua';

  @override
  String get onboardingStep3StreetSubtitle => 'Olive — Velho amigo do bairro';

  @override
  String get onboardingStep3FeatureTitle => 'Em Casa ou na Rua';

  @override
  String get onboardingStep3FeatureDesc =>
      'Inclua os gatos da sua casa ou aqueles que você encontra na rua na sua própria história.';

  @override
  String get onboardingStep3Footer1 => 'ARQUIVO MEOWOIRS';

  @override
  String get onboardingStep3Footer2 => 'CADA GATO';

  @override
  String get onboardingStep4Chap => 'CAPÍTULO IV • PRIVACIDADE E CONFIANÇA';

  @override
  String get onboardingStep4Title => 'A sua história é sua.';

  @override
  String get onboardingStep4Desc =>
      'As suas memórias e fotos permanecem no seu dispositivo. O Meowoirs não as armazena nos seus servidores e não requer uma conta ou sincronização na nuvem.';

  @override
  String get onboardingStep4FeatureTitle => 'Permanece no seu Dispositivo';

  @override
  String get onboardingStep4FeatureDesc =>
      'Os seus perfis de gatos, fotos, notas e memórias são armazenados localmente no seu dispositivo.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'Li e concordo com a Política de Privacidade.';

  @override
  String get onboardingStep4PrivacyLink => 'Política de Privacidade';

  @override
  String get onboardingStep4TermsCheckbox =>
      'Li e concordo com os Termos de Serviço.';

  @override
  String get onboardingStep4TermsLink => 'Termos de Serviço';

  @override
  String get onboardingStep4CombinedCheckbox =>
      'Li e concordo com a Política de Privacidade e os Termos de Serviço.';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • ARQUIVO PESSOAL';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'Gato laranja acolhedor';

  @override
  String get avatarDescSageCat => 'Gato sálvia sereno';

  @override
  String get avatarDescLavenderCat => 'Gato lavanda sonhador';

  @override
  String get avatarDescCuriousCat => 'Gato curioso';

  @override
  String get avatarDescCozyCat => 'Gato dormindo aconchegante';

  @override
  String get avatarDescGentlePaw => 'Patinha gentil';

  @override
  String get avatarDescStarGazer => 'Gato olhando as estrelas';

  @override
  String get avatarDescBookCat => 'Gato leitor';

  @override
  String get avatarDescSunlitCat => 'Gato ao sol';

  @override
  String get avatarDescWhiskerHeart => 'Coração com bigodes';

  @override
  String get debugPanelUnlocked => 'Painel de desenvolvedor desbloqueado';

  @override
  String get debugOnboardingCompleted => 'Apresentação concluída';

  @override
  String get debugAcceptedLegalVersion => 'Versão legal aceita';

  @override
  String get debugResetOnboarding => 'DESENVOLVEDOR: REINICIAR APRESENTAÇÃO';

  @override
  String get debugOnboardingResetToast => 'Status de apresentação redefinido';

  @override
  String get profileNicknamePlaceholder => 'ex: Luna';

  @override
  String get favoriteCatSectionTitle => 'Gato Favorito';

  @override
  String get favoriteCatChangeButton => 'Alterar Gato Favorito';

  @override
  String get favoriteCatSelectButton => 'Escolher Gato Favorito';

  @override
  String get myStorySectionTitle => 'Minha História';

  @override
  String get profileSettingsButton => 'Configurações';

  @override
  String get tooltipBack => 'Go back';

  @override
  String get semanticsSelected => 'selected';

  @override
  String get semanticsNotSelected => 'not selected';

  @override
  String get moodHappy => 'Feliz';

  @override
  String get moodCurious => 'Curioso';

  @override
  String get moodSleepy => 'Sonolento';

  @override
  String get moodPlayful => 'Brincalhão';

  @override
  String get moodCalm => 'Calmo';

  @override
  String get moodAffectionate => 'Carinhoso';

  @override
  String get moodPeaceful => 'Tranquilo';

  @override
  String get moodNostalgic => 'Nostálgico';

  @override
  String get moodJoyful => 'Alegre';

  @override
  String get moodEmotional => 'Emocionado';

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
  String get memoriesViewMenuLabel => 'Visualização';

  @override
  String get memoriesViewMenuSemantic => 'Opções de visualização';

  @override
  String get memoriesViewModeTiles => 'Mosaicos';

  @override
  String get memoriesViewModeLargeIcons => 'Ícones grandes';

  @override
  String get memoriesViewModeSmallIcons => 'Ícones pequenos';

  @override
  String get memoriesViewModeList => 'Lista';

  @override
  String get memoriesViewModeContent => 'Conteúdo';

  @override
  String get profileTryOtherAppsTitle =>
      'Experimente nossos outros aplicativos';

  @override
  String get profileTryOtherAppsSubtitle =>
      'Descubra mais aplicativos da LIMANEX';

  @override
  String get profileComingSoonTitle => 'Em breve';

  @override
  String get profileComingSoonSubtitle => 'Veja os próximos recursos';

  @override
  String get limanexAppsPageTitle => 'Experimente nossos outros aplicativos';

  @override
  String get limanexStudioBadge => 'LIMANEX STUDIO';

  @override
  String get limanexStudioWelcome =>
      'Criado com carinho pela LIMANEX. Descubra outros aplicativos cuidadosamente desenvolvidos pelo nosso estúdio.';

  @override
  String get vitaCaseAppName => 'VitaCase';

  @override
  String get vitaCaseTagline => 'Your Personal Health & Wellness Companion';

  @override
  String get vitaCaseDescription =>
      'Organize seus documentos médicos, acompanhe consultas e gerencie lembretes diários de medicamentos com privacidade no seu dispositivo.';

  @override
  String get vitaCaseCtaExplore => 'Explorar VitaCase';

  @override
  String get vitaCaseLaunchFallbackMessage =>
      'Não foi possível abrir o link da loja neste dispositivo.';

  @override
  String get vitaCasePromoPlaceholderLabel => 'Prévia do VitaCase';

  @override
  String get comingSoonPageTitle => 'Em breve';

  @override
  String get comingSoonHeaderIntro =>
      'Novos recursos incríveis estão a caminho para tornar o Meowoirs ainda mais especial!';

  @override
  String get comingSoonFeature1Title => 'Colagem de memórias';

  @override
  String get comingSoonFeature1Desc =>
      'Crie, edite, salve, reabra, exclua e exporte belas colagens de memórias usando de 2 a 6 fotos e três modelos, com título, data e gato associado opcionais.';

  @override
  String get comingSoonFeature2Title => 'Linha do tempo do gato';

  @override
  String get comingSoonFeature2Desc =>
      'Reúna as memórias de um gato em ordem cronológica, com navegação por data, primeiros encontros e momentos importantes.';

  @override
  String get comingSoonFeature3Title => 'Neste dia';

  @override
  String get comingSoonFeature3Desc =>
      'Redescubra memórias salvas na mesma data em anos anteriores, trazendo fotos antigas e momentos significativos de volta à superfície.';

  @override
  String get comingSoonFeature4Title => 'Nossa história';

  @override
  String get comingSoonFeature4Desc =>
      'Uma página de história pessoal com a data em que você conheceu seu gato, marcos significativos, fotos selecionadas e memórias especiais.';

  @override
  String get comingSoonFeature5Title => 'Lembretes de memórias';

  @override
  String get comingSoonFeature5Desc =>
      'Lembretes locais opcionais, preferências de aviso e notificações controladas para revisitar memórias significativas.';

  @override
  String get comingSoonFeature6Title => 'Melhorias no arquivo';

  @override
  String get comingSoonFeature6Desc =>
      'Busca de memórias aprimorada, filtros por data e gato, favoritos e navegação mais rápida pelo arquivo.';

  @override
  String get comingSoonFeature7Title => 'Designs compartilháveis';

  @override
  String get comingSoonFeature7Desc =>
      'Mais layouts de colagem, temas visuais adicionais e formatos de exportação estilo story para compartilhar memórias selecionadas.';

  @override
  String get comingSoonFeature8Title => 'Ferramentas de arquivo pessoal';

  @override
  String get comingSoonFeature8Desc =>
      'Opções locais de exportação e restauração do arquivo, melhoria na integridade de arquivos, gerenciamento de armazenamento e proteção contra perda de dados.';
}
