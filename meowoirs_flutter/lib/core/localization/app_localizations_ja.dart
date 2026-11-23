// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'すべての猫に物語がある';

  @override
  String get navHome => 'ホーム';

  @override
  String get navCats => '愛猫たち';

  @override
  String get navMemories => '思い出';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get navMyStory => 'マイストーリー';

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
  String get editCatTitle => '猫を編集';

  @override
  String get editCatSubtitle => '情報を更新する。';

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
  String get editMemoryTitle => '思い出を編集';

  @override
  String get editMemorySubtitle => 'この思い出を更新する。';

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
  String get memoryDetailTitle => '思い出の詳細';

  @override
  String get memoryNotFoundTitle => '思い出が見つかりません';

  @override
  String get memoryNotFoundDesc => 'この思い出は利用できないか、削除された可能性があります。';

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
  String get catNotFoundTitle => '猫が見つかりません';

  @override
  String get catNotFoundDesc => 'このストーリーは利用できないか、削除された可能性があります。';

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
  String get profileTitle => 'プロフィール';

  @override
  String get profileGreetingPrefix => 'こんにちは';

  @override
  String get profileDefaultTitle => 'あなたの物語';

  @override
  String get profileSubtitle => 'ここはMeowoirsのあなた専用の空間です。';

  @override
  String get profileEditButton => 'プロフィールを編集';

  @override
  String get profileEditDialogTitle => 'プロフィール編集';

  @override
  String get profileNicknameLabel => 'ニックネーム';

  @override
  String get profileNicknameHint => 'e.g. Luna';

  @override
  String get profileSelectAvatar => 'アバターを選択';

  @override
  String get profileSave => '保存';

  @override
  String get profileCancel => 'キャンセル';

  @override
  String get favoriteCatTitle => 'Favorite Cat';

  @override
  String get favoriteCatChange => 'Change Favorite Cat';

  @override
  String get favoriteCatSelect => 'Select Favorite Cat';

  @override
  String get favoriteCatEmptyTitle => 'まだお気に入りの猫がいません。';

  @override
  String get favoriteCatEmptyCta => '最初の猫を追加';

  @override
  String get favoriteCatNoneSelected => 'お気に入りの猫が選択されていません。';

  @override
  String get favoriteCatDialogTitle => 'お気に入りの猫を選択';

  @override
  String get myStoryTitle => 'My Story';

  @override
  String get myStorySubtitle =>
      'Little moments gathered between you and your cats.';

  @override
  String get myStoryViewAll => 'すべての物語を見る';

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
  String get statCats => '猫たち';

  @override
  String get statMemories => '思い出';

  @override
  String get statHome => 'おうち';

  @override
  String get statStreet => '外の猫';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get themeSystem => 'システム設定';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get settingsPrivacyLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTermsOfService => '利用規約';

  @override
  String get settingsAdPrivacy => '広告プライバシー設定';

  @override
  String get privacyPendingTitle => 'ご案内';

  @override
  String get privacyPendingDesc => 'プライバシーポリシーおよび利用規約は近日公開予定です。';

  @override
  String get umpNotRequired => '現在の地域またはセッションでは広告プライバシー設定は不要です。';

  @override
  String get umpPrivacySubtitle => '広告の設定と権限を管理する';

  @override
  String get settingsLanguage => 'アプリの言語';

  @override
  String get settingsAppLanguage => 'App Language';

  @override
  String get settingsReachUs => 'お問い合わせ';

  @override
  String get reachUsThankYouTitle => 'Meowoirsをご利用いただきありがとうございます。';

  @override
  String get reachUsThankYouDesc => 'あなたと猫のかけがえのない思い出が物語になることを願っています。';

  @override
  String get reachUsActionSuggestion => 'ご意見・ご提案';

  @override
  String get reachUsActionBug => '不具合を報告';

  @override
  String get reachUsActionContact => 'メッセージを送る';

  @override
  String get reachUsNoEmailApp => 'メールアプリが見つかりませんでした。';

  @override
  String get settingsApp => 'Application';

  @override
  String versionFormat(String version) {
    return 'バージョン %1\$s';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'バージョン %1\$s (ビルド %2\$d)';
  }

  @override
  String get actionEdit => '編集';

  @override
  String get actionDelete => '削除';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionSave => '保存';

  @override
  String get actionSaveChanges => '変更を保存';

  @override
  String get actionBack => '戻る';

  @override
  String get actionRetry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get deleteCatTitle => 'この猫を削除してもよろしいですか？';

  @override
  String get deleteCatMessage => '猫のプロフィールは削除されます。保存された思い出は保持されます。';

  @override
  String get deleteMemoryTitle => 'この思い出を削除してもよろしいですか？';

  @override
  String get deleteMemoryMessage => 'この思い出は完全に削除されます。';

  @override
  String get errorGenericOperation => '操作中にエラーが発生しました。もう一度お試しください。';

  @override
  String get catSaveError => '猫の保存中にエラーが発生しました。もう一度お試しください。';

  @override
  String get memorySaveError => '思い出の保存中にエラーが発生しました。もう一度お試しください。';

  @override
  String get catDeleteError => '猫の削除中にエラーが発生しました。もう一度お試しください。';

  @override
  String get memoryDeleteError => '思い出の削除中にエラーが発生しました。もう一度お試しください。';

  @override
  String get photoLoadFailed => '写真を読み込めませんでした';

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
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingContinue => 'Continue →';

  @override
  String get onboardingStep1Chap => '第I巻 — 第01章';

  @override
  String get onboardingStep1Badge => '朝の光';

  @override
  String get onboardingStep1Quote => '«静かなささやきのように...»';

  @override
  String get onboardingStep1Intro => 'はじめに';

  @override
  String get onboardingStep1IntroSub => 'オープニング';

  @override
  String get onboardingStep1Title => 'すべての猫には物語があります。';

  @override
  String get onboardingStep1Desc =>
      'Meowoirsは、猫と共有する小さな瞬間、写真、物語を保管するための個人的なスペースです。';

  @override
  String get onboardingStep1FeatureTitle => '個人アーカイブを作成';

  @override
  String get onboardingStep1FeatureDesc => '写真、メモ、小さな瞬間で独自の思い出アーカイブを構築します。';

  @override
  String get onboardingStep1Footer1 => 'MEOWOIRSアーカイブ';

  @override
  String get onboardingStep1Footer2 => '最初のページ';

  @override
  String get onboardingStep2Chap => '第II章 — 日記の断片';

  @override
  String get onboardingStep2Title => '小さな瞬間を保管する。';

  @override
  String get onboardingStep2Subtitle => '写真、いくつかの言葉、そしてその瞬間の気持ち。';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 朝の眠り';

  @override
  String get onboardingStep2Date => '10月14日';

  @override
  String get onboardingStep2Mood => '平和';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirsは、普通の瞬間を忘れたくない小さな物語に変えます。';

  @override
  String get onboardingStep2Footer1 => '個人アーカイブ';

  @override
  String get onboardingStep2Footer2 => '小さな瞬間';

  @override
  String get onboardingStep3Chap => '第III章 — あなたの物語の中で';

  @override
  String get onboardingStep3Title => 'すべての猫があなたの物語の中にいることができます。';

  @override
  String get onboardingStep3Desc =>
      '家にいる猫から道で出会った友達まで、あなたの人生に触れる小さな瞬間を保管してください。';

  @override
  String get onboardingStep3HomeBadge => '家で';

  @override
  String get onboardingStep3HomeTitle => '私たちの家の物語';

  @override
  String get onboardingStep3StreetBadge => 'ストリートストーリー';

  @override
  String get onboardingStep3StreetTitle => 'ストリートの精神';

  @override
  String get onboardingStep3StreetSubtitle => 'オリーブ — 近所の古い友達';

  @override
  String get onboardingStep3FeatureTitle => '家でも街でも';

  @override
  String get onboardingStep3FeatureDesc => 'あなたの家の猫や通りで出会う猫を、あなた自身の物語に含めてください。';

  @override
  String get onboardingStep3Footer1 => 'MEOWOIRSアーカイブ';

  @override
  String get onboardingStep3Footer2 => 'すべての猫';

  @override
  String get onboardingStep4Chap => '第IV章 • プライバシーと信頼';

  @override
  String get onboardingStep4Title => 'あなたの物語はあなたのものです。';

  @override
  String get onboardingStep4Desc =>
      'あなたの思い出と写真はデバイスに残ります。Meowoirsはそれらをサーバーに保存せず、アカウントやクラウド同期も必要ありません。';

  @override
  String get onboardingStep4FeatureTitle => 'デバイスに残ります';

  @override
  String get onboardingStep4FeatureDesc =>
      '猫のプロフィール、写真、メモ、思い出はデバイスにローカルに保存されます。';

  @override
  String get onboardingStep4PrivacyCheckbox => 'プライバシーポリシーを読み、同意します。';

  @override
  String get onboardingStep4PrivacyLink => 'プライバシーポリシー';

  @override
  String get onboardingStep4TermsCheckbox => '利用規約を読み、同意します。';

  @override
  String get onboardingStep4TermsLink => '利用規約';

  @override
  String get onboardingStep4CombinedCheckbox => 'プライバシーポリシーと利用規約を読み、同意します。';

  @override
  String get onboardingStep4Start => 'Start Meowoirs →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • 個人アーカイブ';

  @override
  String get onboardingLegalOk => 'OK';

  @override
  String get avatarDescWarmCat => 'あたたかい茶トラ猫';

  @override
  String get avatarDescSageCat => '穏やかなセージ猫';

  @override
  String get avatarDescLavenderCat => '夢見るラベンダー猫';

  @override
  String get avatarDescCuriousCat => '好奇心旺盛な猫';

  @override
  String get avatarDescCozyCat => '丸くなって眠る猫';

  @override
  String get avatarDescGentlePaw => 'やさしい肉球';

  @override
  String get avatarDescStarGazer => '星空を見上げる猫';

  @override
  String get avatarDescBookCat => '本と猫';

  @override
  String get avatarDescSunlitCat => 'ひなたぼっこする猫';

  @override
  String get avatarDescWhiskerHeart => 'ひげとハート';

  @override
  String get debugPanelUnlocked => '開発者パネルがロック解除されました';

  @override
  String get debugOnboardingCompleted => 'オンボーディング完了';

  @override
  String get debugAcceptedLegalVersion => '同意された規約バージョン';

  @override
  String get debugResetOnboarding => '開発者：オンボーディングをリセット';

  @override
  String get debugOnboardingResetToast => 'オンボーディング状態をリセットしました';

  @override
  String get profileNicknamePlaceholder => '例: ルナ';

  @override
  String get favoriteCatSectionTitle => 'お気に入りの猫';

  @override
  String get favoriteCatChangeButton => 'お気に入りの猫を変更';

  @override
  String get favoriteCatSelectButton => 'お気に入りの猫を選択';

  @override
  String get myStorySectionTitle => 'マイストーリー';

  @override
  String get profileSettingsButton => '設定';

  @override
  String get tooltipBack => 'Go back';

  @override
  String get semanticsSelected => 'selected';

  @override
  String get semanticsNotSelected => 'not selected';

  @override
  String get moodHappy => '嬉しい';

  @override
  String get moodCurious => '好奇心旺盛';

  @override
  String get moodSleepy => '眠い';

  @override
  String get moodPlayful => '遊びたい';

  @override
  String get moodCalm => '穏やか';

  @override
  String get moodAffectionate => '甘えん坊';

  @override
  String get moodPeaceful => '平和';

  @override
  String get moodNostalgic => '懐かしい';

  @override
  String get moodJoyful => '陽気';

  @override
  String get moodEmotional => '感動的';

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
  String get memoriesViewMenuLabel => '表示';

  @override
  String get memoriesViewMenuSemantic => '表示オプション';

  @override
  String get memoriesViewModeTiles => '並べて表示';

  @override
  String get memoriesViewModeLargeIcons => '大アイコン';

  @override
  String get memoriesViewModeSmallIcons => '小アイコン';

  @override
  String get memoriesViewModeList => 'リスト';

  @override
  String get memoriesViewModeContent => 'コンテンツ';

  @override
  String get profileTryOtherAppsTitle => '他のアプリを試す';

  @override
  String get profileTryOtherAppsSubtitle => 'LIMANEXの他のアプリをチェック';

  @override
  String get profileComingSoonTitle => '近日公開';

  @override
  String get profileComingSoonSubtitle => '今後の新機能を見る';

  @override
  String get limanexAppsPageTitle => '他のアプリを試す';

  @override
  String get limanexStudioBadge => 'LIMANEX STUDIO';

  @override
  String get limanexStudioWelcome =>
      'LIMANEXが心を込めて制作しました。当スタジオの他のアプリもぜひご覧ください。';

  @override
  String get vitaCaseAppName => 'VitaCase';

  @override
  String get vitaCaseTagline => 'Your Personal Health & Wellness Companion';

  @override
  String get vitaCaseDescription =>
      '医療書類の整理、通院予定の管理、毎日の服薬リマインダーをデバイス上で安全・プライベートに管理できます。';

  @override
  String get vitaCaseCtaExplore => 'VitaCaseを見る';

  @override
  String get vitaCaseLaunchFallbackMessage => 'このデバイスでストアのリンクを開けませんでした。';

  @override
  String get vitaCasePromoPlaceholderLabel => 'VitaCase プレビュー';

  @override
  String get comingSoonPageTitle => '近日公開';

  @override
  String get comingSoonHeaderIntro => 'Meowoirsをもっと特別なものにするワクワクする新機能が準備中です！';

  @override
  String get comingSoonFeature1Title => '思い出コラージュ';

  @override
  String get comingSoonFeature1Desc =>
      '2〜6枚の写真と3つのテンプレートを使って、タイトル・日付・猫の関連付け付きの素敵なコラージュを作成、編集、保存、再編集、削除、書き出しできます。';

  @override
  String get comingSoonFeature2Title => '猫のタイムライン';

  @override
  String get comingSoonFeature2Desc =>
      '初めての出会いや大切な瞬間など、猫との思い出を日付ナビゲーション付きで時系列にまとめます。';

  @override
  String get comingSoonFeature3Title => 'あの日あの時';

  @override
  String get comingSoonFeature3Desc =>
      '過去の同じ日に保存された思い出を振り返り、懐かしい写真や大切な瞬間にもう一度出会えます。';

  @override
  String get comingSoonFeature4Title => '私たちの物語';

  @override
  String get comingSoonFeature4Desc =>
      '猫と出会った日、大切な節目、お気に入りの写真、特別な思い出をまとめるパーソナルストーリーページです。';

  @override
  String get comingSoonFeature5Title => '思い出リマインダー';

  @override
  String get comingSoonFeature5Desc =>
      '大切な思い出を振り返るための、任意で設定できるローカルリマインダーと控えめな通知機能です。';

  @override
  String get comingSoonFeature6Title => 'アーカイブの改善';

  @override
  String get comingSoonFeature6Desc =>
      '思い出検索の強化、日付や猫での絞り込み、お気に入り登録、よりスムーズなアーカイブ閲覧を実現します。';

  @override
  String get comingSoonFeature7Title => 'シェア用メモリーデザイン';

  @override
  String get comingSoonFeature7Desc =>
      '選んだ思い出をシェアするためのコラージュレイアウト、追加テーマ、ストーリー形式の書き出しフォーマットです。';

  @override
  String get comingSoonFeature8Title => 'パーソナルアーカイブツール';

  @override
  String get comingSoonFeature8Desc =>
      'ローカルアーカイブの書き出しと復元、ファイル整合性の向上、ストレージ管理、データ消失防止機能を提供します。';
}
