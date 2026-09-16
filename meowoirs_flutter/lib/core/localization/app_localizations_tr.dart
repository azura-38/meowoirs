// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Meowoirs';

  @override
  String get tagline => 'Her kedinin bir hikâyesi var.';

  @override
  String get navHome => 'ANA SAYFA';

  @override
  String get navCats => 'KEDİLER';

  @override
  String get navMemories => 'ANILAR';

  @override
  String get navProfile => 'PROFİL';

  @override
  String get navMyStory => 'Hikâyem';

  @override
  String get fabAddMemory => 'Anı Ekle';

  @override
  String get homeTitle => 'Meowoirs';

  @override
  String get homeEmptyTitle => 'Henüz bir anın yok...';

  @override
  String get homeEmptyDesc =>
      'Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.';

  @override
  String get homeEmptyAddMemory => 'İlk Anını Ekle';

  @override
  String get homeEmptyAddCat => 'İlk Kedini Ekle';

  @override
  String get homeCatsSectionTitle => 'Kedilerin';

  @override
  String homeCatsSectionSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kedi hikâyesi',
      one: '1 kedi hikâyesi',
    );
    return '$_temp0';
  }

  @override
  String get homeRecentMemoriesTitle => 'Son Anılar';

  @override
  String get homeRecentMemoriesViewAll => 'Tümünü Gör';

  @override
  String get homeCatsNoMemoriesTitle => 'Kedilerin burada.';

  @override
  String get homeCatsNoMemoriesDesc => 'Onlarla geçirdiğin ilk anıyı sakla.';

  @override
  String get catsTitle => 'Kedilerim';

  @override
  String get catsActionNewCat => 'Yeni Kedi';

  @override
  String get catsSubtitleDefault => 'Hayatına dokunan küçük hikâyeler.';

  @override
  String catsSubtitleWithSummary(String summary) {
    return 'Hayatına dokunan $summary';
  }

  @override
  String get catsFilterAll => 'Tümü';

  @override
  String get catsFilterHome => 'Ev';

  @override
  String get catsFilterStreet => 'Sokak';

  @override
  String get catsEmptyTitle => 'Henüz bir kedin yok.';

  @override
  String get catsEmptyDesc =>
      'Hayatındaki bir kediyi ekleyerek hikâyene başla.';

  @override
  String get catsEmptyAddCat => 'İlk Kedini Ekle';

  @override
  String get catsFilterEmptyHome => 'Henüz bir ev kedisi eklemedin.';

  @override
  String get catsFilterEmptyHomeCta => 'Ev Kedisi Ekle';

  @override
  String get catsFilterEmptyStreet => 'Henüz bir sokak kedisi eklemedin.';

  @override
  String get catsFilterEmptyStreetCta => 'Sokak Kedisi Ekle';

  @override
  String get catsFilterEmptyAll => 'Henüz kedi bulunmuyor.';

  @override
  String get catsFilterEmptyAllCta => 'Kedi Ekle';

  @override
  String get catTypeHome => 'Ev Kedisi';

  @override
  String get catTypeStreet => 'Sokak Kedisi';

  @override
  String catCardMemoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return '$_temp0';
  }

  @override
  String catSummaryHomeAndStreet(int homeCount, int streetCount) {
    return '$homeCount ev · $streetCount sokak';
  }

  @override
  String catSummaryTotalOnly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kedi',
      one: '1 kedi',
    );
    return '$_temp0';
  }

  @override
  String catPhotoContentDescription(String name) {
    return '$name adlı kedinin fotoğrafı';
  }

  @override
  String get addCatTitle => 'Yeni Kedi';

  @override
  String get addCatSubtitle => 'Onun hikâyesi burada başlıyor.';

  @override
  String get editCatTitle => 'Kediyi Düzenle';

  @override
  String get editCatSubtitle => 'Bilgilerini güncelleyin.';

  @override
  String get catNameLabel => 'Kedinin Adı';

  @override
  String get catNameHint => 'Örn. Minnoş';

  @override
  String get catNameRequired => 'Lütfen kedinin adını yazın.';

  @override
  String get catNoteLabel => 'Kişisel Not';

  @override
  String get catNoteHint => 'Bu kedi hakkında küçük bir not...';

  @override
  String get catPhotoLabel => 'Fotoğraf';

  @override
  String get catTypeLabel => 'Kedi Türü';

  @override
  String get catTypeHomeDesc => 'Birlikte yaşadığın dostun';

  @override
  String get catTypeStreetDesc => 'Sokakta karşılaştığın dostun';

  @override
  String get addPhoto => 'Fotoğraf ekle';

  @override
  String get changePhoto => 'Değiştir';

  @override
  String get removePhoto => 'Kaldır';

  @override
  String get addPhotoSemantic => 'Fotoğraf ekle';

  @override
  String get selectedPhotoSemantic => 'Seçilen kedi fotoğrafı';

  @override
  String get changePhotoSemantic => 'Fotoğrafı değiştir';

  @override
  String get removePhotoSemantic => 'Fotoğrafı kaldır';

  @override
  String get memoriesTitle => 'Anılar';

  @override
  String get memoriesSubtitle => 'Hayatındaki küçük anların arşivi.';

  @override
  String get memoriesFilterAll => 'Tümü';

  @override
  String get memoriesEmptyTitle => 'Henüz anı yok.';

  @override
  String get memoriesEmptyDesc =>
      'Kedilerinle paylaştığın küçük anları kaydetmeye başla.';

  @override
  String get memoriesGlobalEmptyTitle => 'Henüz bir anın yok.';

  @override
  String get memoriesGlobalEmptyDesc =>
      'Kedilerinle geçirdiğin küçük anlar burada birikecek.';

  @override
  String get memoriesGlobalEmptyCta => 'İlk Anını Ekle';

  @override
  String memoriesFilterEmptyTitle(String catName) {
    return '$catName için henüz bir anın yok.';
  }

  @override
  String get memoriesFilterEmptyDesc =>
      'Onunla geçirdiğin küçük bir anı sakla.';

  @override
  String get memoriesFilterEmptyCta => 'Anı Ekle';

  @override
  String get memoriesErrorTitle => 'Anılar yüklenemedi';

  @override
  String get memoriesErrorDesc =>
      'Anılar yüklenirken bir sorun oluştu. Lütfen tekrar deneyin.';

  @override
  String get memoriesErrorRetry => 'Tekrar Dene';

  @override
  String memoriesCardSemantic(String catName) {
    return '$catName ile kaydedilmiş anıyı aç';
  }

  @override
  String get addMemoryTitle => 'Anı Ekle';

  @override
  String get addMemorySubtitle => 'Bugünden küçük bir anı sakla.';

  @override
  String get editMemoryTitle => 'Anı Düzenle';

  @override
  String get editMemorySubtitle => 'Bu anıyı güncelle.';

  @override
  String get memoryNoteLabel => 'Not';

  @override
  String get memoryNoteHint => 'Ne oldu?';

  @override
  String get memoryNoteHintLong =>
      'Bugün ne oldu? Örneğin: Bugün yine pencerenin önünde uyuyakaldı...';

  @override
  String get memoryWhoWith => 'Kiminle?';

  @override
  String get memoryPhotoSectionTitle => 'Bu anı hatırlatan bir fotoğraf';

  @override
  String get memoryWhatHappened => 'Ne oldu?';

  @override
  String get memoryCatMoodSection => 'Onun ruh hâli';

  @override
  String get memoryUserMoodSection => 'Sen nasıl hissettin?';

  @override
  String get memoryWhenSection => 'Ne zaman?';

  @override
  String get memorySaved => 'Kaydedildi ✓';

  @override
  String get memorySelectCat => 'Kedi Seç';

  @override
  String get memoryCatRequired => 'Lütfen bu anı için bir kedi seçin.';

  @override
  String get memoryPhotoLabel => 'Fotoğraf';

  @override
  String get memoryCatMoodLabel => 'Kedinin Ruh Hali';

  @override
  String get memoryUserMoodLabel => 'Senin Ruh Halin';

  @override
  String get memoryDateLabel => 'Tarih';

  @override
  String get memoryTimeLabel => 'Saat';

  @override
  String get memoryDetailTitle => 'Anı Detayı';

  @override
  String get memoryNotFoundTitle => 'Anı bulunamadı';

  @override
  String get memoryNotFoundDesc =>
      'Bu anı artık mevcut değil veya silinmiş olabilir.';

  @override
  String get memoryMoodSectionTitle => 'Ruh Hâli';

  @override
  String memoryCatMoodFormat(String mood) {
    return 'Onun hâli: $mood';
  }

  @override
  String memoryUserMoodFormat(String mood) {
    return 'Senin hissin: $mood';
  }

  @override
  String get catDetailTitle => 'Kedi Hikâyesi';

  @override
  String get catNotFoundTitle => 'Kedi bulunamadı';

  @override
  String get catNotFoundDesc =>
      'Bu hikâye artık mevcut değil veya silinmiş olabilir.';

  @override
  String catDetailStorySubtitle(String memoryText) {
    return 'Birlikte biriktirdiğiniz küçük anlar. $memoryText';
  }

  @override
  String get catDetailMemoryCountZero => 'Bu hikâye ilk anısıyla başlayacak.';

  @override
  String get catDetailMemoryCountSingle => '1 küçük anı burada.';

  @override
  String catDetailMemoryCountMultiple(int count) {
    return '$count küçük anı burada.';
  }

  @override
  String get catDetailMemoriesSectionTitle => 'Anılar';

  @override
  String catDetailMemoriesSectionSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı kaydedildi',
      one: '1 anı kaydedildi',
    );
    return '$_temp0';
  }

  @override
  String get catDetailEmptyMemoriesTitle => 'Hikâye daha yeni başlıyor.';

  @override
  String get catDetailEmptyMemoriesDesc =>
      'Bu kediyle yaşadığın ilk küçük anı burada saklayabilirsin.';

  @override
  String get catDetailEmptyMemoriesCta => 'İlk Anıyı Ekle';

  @override
  String get catDetailActionAddMemory => 'Anı Ekle';

  @override
  String get catDetailNoteTitle => 'Not';

  @override
  String catDetailPhotoSemantic(String name) {
    return '$name fotoğrafı';
  }

  @override
  String get catDetailBackSemantic => 'Kedi detayından geri dön';

  @override
  String get catDetailDeleteSemantic => 'Kediyi sil';

  @override
  String get catDetailEditSemantic => 'Kediyi düzenle';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGreetingPrefix => 'Merhaba';

  @override
  String get profileDefaultTitle => 'Senin Hikâyen';

  @override
  String get profileSubtitle => 'Bu senin Meowoirs\'teki kişisel alanın.';

  @override
  String get profileEditButton => 'Profili Düzenle';

  @override
  String get profileEditDialogTitle => 'Profili Düzenle';

  @override
  String get profileNicknameLabel => 'Takma Adın';

  @override
  String get profileNicknameHint => 'ör. Luna';

  @override
  String get profileSelectAvatar => 'Profil Görseli Seç';

  @override
  String get profileSave => 'Kaydet';

  @override
  String get profileCancel => 'Vazgeç';

  @override
  String get favoriteCatTitle => 'Favori Kedi';

  @override
  String get favoriteCatChange => 'Favori Kediyi Değiştir';

  @override
  String get favoriteCatSelect => 'Favori Kedi Seç';

  @override
  String get favoriteCatEmptyTitle => 'Henüz favori bir kedin yok.';

  @override
  String get favoriteCatEmptyCta => 'İlk Kedini Ekle';

  @override
  String get favoriteCatNoneSelected => 'Henüz bir favori kedi seçilmedi.';

  @override
  String get favoriteCatDialogTitle => 'Favori Kedini Seç';

  @override
  String get myStoryTitle => 'Hikâyem';

  @override
  String get myStorySubtitle =>
      'Sen ve kedilerin arasında biriken küçük anlar.';

  @override
  String get myStoryViewAll => 'Tüm Hikâyeyi Gör';

  @override
  String get myStoryYourStory => 'Senin Meowoirs\'in';

  @override
  String get myStoryCatsSection => 'Kedilerin';

  @override
  String get myStorySeeAll => 'Tümünü Gör';

  @override
  String get myStoryMostRememberedTitle => 'En çok anı biriktirdiğin';

  @override
  String myStoryMostRememberedSubtitle(int count) {
    return '$count anı biriktirildi';
  }

  @override
  String get myStoryRecentMoment => 'Son Anın';

  @override
  String get myStoryBeginningTitle => 'Meowoirs\'teki ilk anın';

  @override
  String get myStoryCompletelyEmptyTitle => 'Burada senin hikâyen başlayacak.';

  @override
  String get myStoryCompletelyEmptySubtitle =>
      'Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.';

  @override
  String get myStoryCompletelyEmptyAddMemory => 'İlk Anını Ekle';

  @override
  String get myStoryCompletelyEmptyAddCat => 'İlk Kedini Ekle';

  @override
  String get myStoryPartialEmptyTitle => 'Henüz anlatacak bir anın yok.';

  @override
  String get myStoryPartialEmptySubtitle =>
      'Kedilerin burada. Onlarla geçirdiğin ilk küçük anı sakla.';

  @override
  String get myStoryPartialEmptyAddMemory => 'İlk Anını Ekle';

  @override
  String get myStoryErrorTitle => 'Hikâye yüklenemedi';

  @override
  String get myStoryErrorDesc => 'Hikâyeniz yüklenirken bir sorun oluştu.';

  @override
  String get myStoryErrorRetry => 'Tekrar Dene';

  @override
  String myStoryMostRememberedSemantic(String catName, int count) {
    return '$catName, en çok anı biriktirdiğin kedi. $count anı.';
  }

  @override
  String myStoryBeginningSemantic(String date) {
    return 'Meowoirs\'teki ilk anın: $date';
  }

  @override
  String get statCats => 'Kedi';

  @override
  String get statMemories => 'Anı';

  @override
  String get statHome => 'Ev';

  @override
  String get statStreet => 'Sokak';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAppearance => 'Görünüm';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get settingsPrivacyLegal => 'Gizlilik ve Yasal';

  @override
  String get settingsPrivacyPolicy => 'Gizlilik Politikası';

  @override
  String get settingsTermsOfService => 'Kullanım Koşulları';

  @override
  String get settingsAdPrivacy => 'Reklam Gizlilik Seçenekleri';

  @override
  String get privacyPendingTitle => 'Bilgi';

  @override
  String get privacyPendingDesc =>
      'Gizlilik Politikamız ve Kullanım Koşullarımız yakında çevrimiçi olarak erişilebilir olacaktır.';

  @override
  String get umpNotRequired =>
      'Reklam gizlilik seçenekleri bölgeniz veya mevcut oturumunuz için gerekli değildir.';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsAppLanguage => 'Uygulama Dili';

  @override
  String get settingsReachUs => 'Bize Ulaşın';

  @override
  String get reachUsThankYouTitle =>
      'Meowoirs\'u kullandığınız için teşekkürler.';

  @override
  String get reachUsThankYouDesc =>
      'Her küçük anının sizinle birlikte kişisel bir hikâyeye dönüşmesine sevindik.';

  @override
  String get reachUsActionSuggestion => 'Öneri Gönder';

  @override
  String get reachUsActionBug => 'Hata Bildir';

  @override
  String get reachUsActionContact => 'İletişim';

  @override
  String get reachUsNoEmailApp => 'Bu cihazda e-posta uygulaması bulunamadı.';

  @override
  String get settingsApp => 'Uygulama';

  @override
  String versionFormat(String version) {
    return 'Sürüm $version';
  }

  @override
  String versionBuildFormat(String version, int build) {
    return 'Sürüm $version (Derleme $build)';
  }

  @override
  String get actionEdit => 'Düzenle';

  @override
  String get actionDelete => 'Sil';

  @override
  String get actionCancel => 'İptal';

  @override
  String get actionSave => 'Kaydet';

  @override
  String get actionSaveChanges => 'Değişiklikleri Kaydet';

  @override
  String get actionBack => 'Geri';

  @override
  String get actionRetry => 'Tekrar Dene';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get deleteCatTitle => 'Bu kediyi silmek istediğinizden emin misiniz?';

  @override
  String get deleteCatMessage =>
      'Kedi profili silinecektir. Kaydedilmiş anılar korunacaktır.';

  @override
  String get deleteMemoryTitle =>
      'Bu anıyı silmek istediğinizden emin misiniz?';

  @override
  String get deleteMemoryMessage => 'Bu anı kalıcı olarak silinecektir.';

  @override
  String get errorGenericOperation =>
      'İşlem sırasında bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get catSaveError =>
      'Kedi kaydedilirken bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get memorySaveError =>
      'Anı kaydedilirken bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get catDeleteError =>
      'Kedi silinirken bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get memoryDeleteError =>
      'Anı silinirken bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get photoLoadFailed => 'Fotoğraf yüklenemedi';

  @override
  String get legalViewOnline => 'Çevrimiçi Görüntüle';

  @override
  String get legalDocumentClose => 'Kapat';

  @override
  String get legalDataDeletion => 'Veri ve Silme';

  @override
  String get legalThirdParty => 'Üçüncü Taraf Hizmetleri';

  @override
  String get legalAdvertisingConsent => 'Reklam ve Onay';

  @override
  String get legalDisclaimer => 'Yasal Uyarı';

  @override
  String get legalDocumentLoadError => 'Belge yüklenirken bir hata oluştu.';

  @override
  String get legalDocumentRetry => 'Tekrar Dene';

  @override
  String get onboardingSkip => 'ATLA';

  @override
  String get onboardingContinue => 'Devam Et →';

  @override
  String get onboardingStep1Chap => 'CİLT I — BÖLÜM 01';

  @override
  String get onboardingStep1Badge => 'GÜNÜN IŞIĞI';

  @override
  String get onboardingStep1Quote => '«Sessiz bir fısıltı gibi...»';

  @override
  String get onboardingStep1Intro => 'GİRİŞ NOTU';

  @override
  String get onboardingStep1IntroSub => 'AÇILIŞ';

  @override
  String get onboardingStep1Title => 'Her kedinin bir hikâyesi var.';

  @override
  String get onboardingStep1Desc =>
      'Meowoirs, kedilerinle paylaştığın küçük anları, fotoğrafları ve hikâyeleri saklamak için kişisel alanın.';

  @override
  String get onboardingStep1FeatureTitle => 'Kişisel Arşivinizi Oluşturun';

  @override
  String get onboardingStep1FeatureDesc =>
      'Fotoğraf, notlar ve küçük anlarla kendi anı arşivinizi oluşturun.';

  @override
  String get onboardingStep1Footer1 => 'MEOWOIRS ARŞİVİ';

  @override
  String get onboardingStep1Footer2 => 'İLK SAYFA';

  @override
  String get onboardingStep2Chap => 'BÖLÜM II — GÜNLÜK PARÇALARI';

  @override
  String get onboardingStep2Title => 'Küçük anları sakla.';

  @override
  String get onboardingStep2Subtitle =>
      'Bir fotoğraf, birkaç kelime ve o anın duygusu.';

  @override
  String get onboardingStep2Badge1 => 'ANNO. 128';

  @override
  String get onboardingStep2Badge2 => '08:45 Sabah Uykusu';

  @override
  String get onboardingStep2Date => '14 Ekim';

  @override
  String get onboardingStep2Mood => 'Huzurlu';

  @override
  String get onboardingStep2EditorialText =>
      'Meowoirs, sıradan anları unutmak istemeyeceğin küçük hikâyelere dönüştürür.';

  @override
  String get onboardingStep2Footer1 => 'KİŞİSEL ARŞİV';

  @override
  String get onboardingStep2Footer2 => 'KÜÇÜK ANLAR';

  @override
  String get onboardingStep3Chap => 'BÖLÜM III — HİKÂYENDEKİLER';

  @override
  String get onboardingStep3Title => 'Her kedi hikâyende yer alabilir.';

  @override
  String get onboardingStep3Desc =>
      'Evindeki kediden sokakta karşılaştığın bir dosta kadar, hayatına dokunan küçük anları sakla.';

  @override
  String get onboardingStep3HomeBadge => 'EVDE';

  @override
  String get onboardingStep3HomeTitle => 'Evimizin Hikâyesi';

  @override
  String get onboardingStep3StreetBadge => 'SOKAK HİKÂYESİ';

  @override
  String get onboardingStep3StreetTitle => 'Sokağın Ruhu';

  @override
  String get onboardingStep3StreetSubtitle => 'Zeytin — Mahalledeki eski dost';

  @override
  String get onboardingStep3FeatureTitle => 'Evde veya Sokakta';

  @override
  String get onboardingStep3FeatureDesc =>
      'Evindeki ya da sokakta karşılaştığın kedileri kendi hikâyene dahil et.';

  @override
  String get onboardingStep3Footer1 => 'MEOWOIRS ARŞİVİ';

  @override
  String get onboardingStep3Footer2 => 'HER KEDİ';

  @override
  String get onboardingStep4Chap => 'BÖLÜM IV • MAHREMİYET & GÜVEN';

  @override
  String get onboardingStep4Title => 'Hikâyen senin.';

  @override
  String get onboardingStep4Desc =>
      'Anıların ve fotoğrafların cihazında kalır. Meowoirs, bunları kendi sunucularında saklamaz ve hesap veya bulut senkronizasyonu gerektirmez.';

  @override
  String get onboardingStep4FeatureTitle => 'Cihazında Kalır';

  @override
  String get onboardingStep4FeatureDesc =>
      'Kedi profillerin, fotoğrafların, notların ve anıların cihazında yerel olarak saklanır.';

  @override
  String get onboardingStep4PrivacyCheckbox =>
      'Gizlilik Politikası\'nı okudum ve kabul ediyorum.';

  @override
  String get onboardingStep4PrivacyLink => 'Gizlilik Politikası';

  @override
  String get onboardingStep4TermsCheckbox =>
      'Kullanım Koşulları\'nı okudum ve kabul ediyorum.';

  @override
  String get onboardingStep4TermsLink => 'Kullanım Koşulları';

  @override
  String get onboardingStep4Start => 'Meowoirs\'e Başla →';

  @override
  String get onboardingStep4Footer => 'MEOWOIRS • KİŞİSEL ARŞİV';

  @override
  String get onboardingLegalOk => 'Tamam';

  @override
  String get avatarDescWarmCat => 'Sıcak turuncu kedi';

  @override
  String get avatarDescSageCat => 'Sakin adaçayı kedi';

  @override
  String get avatarDescLavenderCat => 'Hayalperest lavanta kedi';

  @override
  String get avatarDescCuriousCat => 'Meraklı kedi';

  @override
  String get avatarDescCozyCat => 'Rahat uyuyan kedi';

  @override
  String get avatarDescGentlePaw => 'Nazik pati izi';

  @override
  String get avatarDescStarGazer => 'Yıldız seyreden kedi';

  @override
  String get avatarDescBookCat => 'Kitap sever kedi';

  @override
  String get avatarDescSunlitCat => 'Güneşte dinlenen kedi';

  @override
  String get avatarDescWhiskerHeart => 'Bıyık kalp';

  @override
  String get debugPanelUnlocked => 'Geliştirici paneli açıldı';

  @override
  String get debugOnboardingCompleted => 'Başlangıç Tamamlandı';

  @override
  String get debugAcceptedLegalVersion => 'Kabul Edilen Yasal Sürüm';

  @override
  String get debugResetOnboarding => 'GELİŞTİRİCİ: BAŞLANGIÇ SIFIRLA';

  @override
  String get debugOnboardingResetToast => 'Başlangıç durumu sıfırlandı';

  @override
  String get profileNicknamePlaceholder => 'Örn: Luna';

  @override
  String get favoriteCatSectionTitle => 'Favori Kedim';

  @override
  String get favoriteCatChangeButton => 'Favori Kediyi Değiştir';

  @override
  String get favoriteCatSelectButton => 'Favori Kediyi Seç';

  @override
  String get myStorySectionTitle => 'Benim Hikâyem';

  @override
  String get profileSettingsButton => 'Ayarlar';

  @override
  String get tooltipBack => 'Geri dön';

  @override
  String get semanticsSelected => 'seçildi';

  @override
  String get semanticsNotSelected => 'seçilmedi';

  @override
  String get moodHappy => 'Mutlu';

  @override
  String get moodCurious => 'Meraklı';

  @override
  String get moodSleepy => 'Uykulu';

  @override
  String get moodPlayful => 'Oyuncu';

  @override
  String get moodCalm => 'Sakin';

  @override
  String get moodAffectionate => 'Sevecen';

  @override
  String get moodPeaceful => 'Huzurlu';

  @override
  String get moodNostalgic => 'Özlemli';

  @override
  String get moodJoyful => 'Neşeli';

  @override
  String get moodEmotional => 'Duygusal';

  @override
  String addMemorySelectDate(String date) {
    return 'Tarih seç: $date';
  }

  @override
  String get addMemoryCatEmptyAction => 'Kedi Ekle';

  @override
  String memoryCatNoteLabel(String catName, String note) {
    return '$catName anısı: $note';
  }

  @override
  String get storyNarrativeEmpty =>
      'Kedilerinle paylaştığın küçük anlar, zamanla kendi hikâyene dönüşecek.';

  @override
  String get storyNarrativeCatsNoMemories =>
      'Kedilerin burada. Onlarla geçirdiğin ilk küçük anı sakla.';

  @override
  String storyNarrativeSingleCat(String catName, int count) {
    return '$catName ile birlikte $count küçük an burada saklanıyor.';
  }

  @override
  String storyNarrativeHomeAndStreet(int memoriesCount, int catsCount) {
    return '$catsCount dostunla $memoriesCount küçük an biriktirdin. Evdeki sıcak anlar ve sokakta karşılaştığın küçük hikâyeler bir arada.';
  }

  @override
  String storyNarrativeGeneral(int memoriesCount, int catsCount) {
    return '$catsCount kedinle $memoriesCount küçük an biriktirdin. Zamanla biriken bu anlar senin Meowoirs hikâyeni oluşturuyor.';
  }

  @override
  String get legalTitlePrivacyPolicy => 'Gizlilik Politikası';

  @override
  String get legalTitleTermsOfService => 'Kullanım Koşulları';

  @override
  String get legalTitleDataDeletion => 'Veri Silme Politikası';

  @override
  String get legalTitleThirdPartyServices => 'Üçüncü Taraf Hizmetleri';

  @override
  String get legalTitleAdvertisingAndConsent => 'Reklam ve İzin Politikası';

  @override
  String get legalTitleLegalDisclaimer => 'Yasal Uyarı';
}
