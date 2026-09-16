import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// app name
  ///
  /// In en, this message translates to:
  /// **'Meowoirs'**
  String get appName;

  /// tagline
  ///
  /// In en, this message translates to:
  /// **'Every cat has a story.'**
  String get tagline;

  /// nav home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// nav cats
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get navCats;

  /// nav memories
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get navMemories;

  /// nav profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// nav my story
  ///
  /// In en, this message translates to:
  /// **'My Story'**
  String get navMyStory;

  /// fab add memory
  ///
  /// In en, this message translates to:
  /// **'Add Memory'**
  String get fabAddMemory;

  /// home title
  ///
  /// In en, this message translates to:
  /// **'Meowoirs'**
  String get homeTitle;

  /// home empty title
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any memories yet...'**
  String get homeEmptyTitle;

  /// home empty desc
  ///
  /// In en, this message translates to:
  /// **'The little moments you share with your cats will eventually become your own story.'**
  String get homeEmptyDesc;

  /// home empty add memory
  ///
  /// In en, this message translates to:
  /// **'Add Your First Memory'**
  String get homeEmptyAddMemory;

  /// home empty add cat
  ///
  /// In en, this message translates to:
  /// **'Add Your First Cat'**
  String get homeEmptyAddCat;

  /// home cats section title
  ///
  /// In en, this message translates to:
  /// **'Your Cats'**
  String get homeCatsSectionTitle;

  /// No description provided for @homeCatsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 cat story} other{{count} cat stories}}'**
  String homeCatsSectionSubtitle(int count);

  /// home recent memories title
  ///
  /// In en, this message translates to:
  /// **'Recent Memories'**
  String get homeRecentMemoriesTitle;

  /// home recent memories view all
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeRecentMemoriesViewAll;

  /// home cats no memories title
  ///
  /// In en, this message translates to:
  /// **'Your cats are here.'**
  String get homeCatsNoMemoriesTitle;

  /// home cats no memories desc
  ///
  /// In en, this message translates to:
  /// **'Keep the first memory you share with them.'**
  String get homeCatsNoMemoriesDesc;

  /// cats title
  ///
  /// In en, this message translates to:
  /// **'My Cats'**
  String get catsTitle;

  /// cats action new cat
  ///
  /// In en, this message translates to:
  /// **'New Cat'**
  String get catsActionNewCat;

  /// cats subtitle default
  ///
  /// In en, this message translates to:
  /// **'Little stories touching your life.'**
  String get catsSubtitleDefault;

  /// No description provided for @catsSubtitleWithSummary.
  ///
  /// In en, this message translates to:
  /// **'Touching your life: {summary}'**
  String catsSubtitleWithSummary(String summary);

  /// cats filter all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catsFilterAll;

  /// cats filter home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get catsFilterHome;

  /// cats filter street
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get catsFilterStreet;

  /// cats empty title
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a cat yet.'**
  String get catsEmptyTitle;

  /// cats empty desc
  ///
  /// In en, this message translates to:
  /// **'Start your story by adding a cat from your life.'**
  String get catsEmptyDesc;

  /// cats empty add cat
  ///
  /// In en, this message translates to:
  /// **'Add Your First Cat'**
  String get catsEmptyAddCat;

  /// cats filter empty home
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added a home cat yet.'**
  String get catsFilterEmptyHome;

  /// cats filter empty home cta
  ///
  /// In en, this message translates to:
  /// **'Add Home Cat'**
  String get catsFilterEmptyHomeCta;

  /// cats filter empty street
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added a street cat yet.'**
  String get catsFilterEmptyStreet;

  /// cats filter empty street cta
  ///
  /// In en, this message translates to:
  /// **'Add Street Cat'**
  String get catsFilterEmptyStreetCta;

  /// cats filter empty all
  ///
  /// In en, this message translates to:
  /// **'No cats found.'**
  String get catsFilterEmptyAll;

  /// cats filter empty all cta
  ///
  /// In en, this message translates to:
  /// **'Add Cat'**
  String get catsFilterEmptyAllCta;

  /// cat type home
  ///
  /// In en, this message translates to:
  /// **'Home Cat'**
  String get catTypeHome;

  /// cat type street
  ///
  /// In en, this message translates to:
  /// **'Street Cat'**
  String get catTypeStreet;

  /// No description provided for @catCardMemoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory} other{{count} memories}}'**
  String catCardMemoryCount(int count);

  /// No description provided for @catSummaryHomeAndStreet.
  ///
  /// In en, this message translates to:
  /// **'{homeCount} home · {streetCount} street'**
  String catSummaryHomeAndStreet(int homeCount, int streetCount);

  /// No description provided for @catSummaryTotalOnly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 cat} other{{count} cats}}'**
  String catSummaryTotalOnly(int count);

  /// No description provided for @catPhotoContentDescription.
  ///
  /// In en, this message translates to:
  /// **'Photo of {name}'**
  String catPhotoContentDescription(String name);

  /// add cat title
  ///
  /// In en, this message translates to:
  /// **'Add Cat'**
  String get addCatTitle;

  /// add cat subtitle
  ///
  /// In en, this message translates to:
  /// **'Their story begins here.'**
  String get addCatSubtitle;

  /// edit cat title
  ///
  /// In en, this message translates to:
  /// **'Edit Cat'**
  String get editCatTitle;

  /// edit cat subtitle
  ///
  /// In en, this message translates to:
  /// **'Update their details.'**
  String get editCatSubtitle;

  /// cat name label
  ///
  /// In en, this message translates to:
  /// **'Cat Name'**
  String get catNameLabel;

  /// cat name hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Minnoş'**
  String get catNameHint;

  /// cat name required
  ///
  /// In en, this message translates to:
  /// **'Please enter the cat\'s name.'**
  String get catNameRequired;

  /// cat note label
  ///
  /// In en, this message translates to:
  /// **'Personal Note'**
  String get catNoteLabel;

  /// cat note hint
  ///
  /// In en, this message translates to:
  /// **'A little about this cat...'**
  String get catNoteHint;

  /// cat photo label
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get catPhotoLabel;

  /// cat type label
  ///
  /// In en, this message translates to:
  /// **'Cat Type'**
  String get catTypeLabel;

  /// cat type home desc
  ///
  /// In en, this message translates to:
  /// **'Your companion at home'**
  String get catTypeHomeDesc;

  /// cat type street desc
  ///
  /// In en, this message translates to:
  /// **'Your friend from the street'**
  String get catTypeStreetDesc;

  /// add photo
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// change photo
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePhoto;

  /// remove photo
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removePhoto;

  /// add photo semantic
  ///
  /// In en, this message translates to:
  /// **'Add cat photo'**
  String get addPhotoSemantic;

  /// selected photo semantic
  ///
  /// In en, this message translates to:
  /// **'Selected cat photo'**
  String get selectedPhotoSemantic;

  /// change photo semantic
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhotoSemantic;

  /// remove photo semantic
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhotoSemantic;

  /// memories title
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get memoriesTitle;

  /// memories subtitle
  ///
  /// In en, this message translates to:
  /// **'Archive of little moments in your life.'**
  String get memoriesSubtitle;

  /// memories filter all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get memoriesFilterAll;

  /// memories empty title
  ///
  /// In en, this message translates to:
  /// **'No memories yet.'**
  String get memoriesEmptyTitle;

  /// memories empty desc
  ///
  /// In en, this message translates to:
  /// **'Start capturing the little moments you share with your cats.'**
  String get memoriesEmptyDesc;

  /// memories global empty title
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any memories yet.'**
  String get memoriesGlobalEmptyTitle;

  /// memories global empty desc
  ///
  /// In en, this message translates to:
  /// **'Little moments spent with your cats will gather here.'**
  String get memoriesGlobalEmptyDesc;

  /// memories global empty cta
  ///
  /// In en, this message translates to:
  /// **'Add Your First Memory'**
  String get memoriesGlobalEmptyCta;

  /// No description provided for @memoriesFilterEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No memories for {catName} yet.'**
  String memoriesFilterEmptyTitle(String catName);

  /// memories filter empty desc
  ///
  /// In en, this message translates to:
  /// **'Save a little memory spent with them.'**
  String get memoriesFilterEmptyDesc;

  /// memories filter empty cta
  ///
  /// In en, this message translates to:
  /// **'Add Memory'**
  String get memoriesFilterEmptyCta;

  /// memories error title
  ///
  /// In en, this message translates to:
  /// **'Could not load memories'**
  String get memoriesErrorTitle;

  /// memories error desc
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading memories. Please try again.'**
  String get memoriesErrorDesc;

  /// memories error retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get memoriesErrorRetry;

  /// No description provided for @memoriesCardSemantic.
  ///
  /// In en, this message translates to:
  /// **'Open memory saved with {catName}'**
  String memoriesCardSemantic(String catName);

  /// add memory title
  ///
  /// In en, this message translates to:
  /// **'Add Memory'**
  String get addMemoryTitle;

  /// add memory subtitle
  ///
  /// In en, this message translates to:
  /// **'Keep a little memory from today.'**
  String get addMemorySubtitle;

  /// edit memory title
  ///
  /// In en, this message translates to:
  /// **'Edit Memory'**
  String get editMemoryTitle;

  /// edit memory subtitle
  ///
  /// In en, this message translates to:
  /// **'Update this memory.'**
  String get editMemorySubtitle;

  /// memory note label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get memoryNoteLabel;

  /// memory note hint
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get memoryNoteHint;

  /// memory note hint long
  ///
  /// In en, this message translates to:
  /// **'What happened today? e.g. Fell asleep by the window again today...'**
  String get memoryNoteHintLong;

  /// memory who with
  ///
  /// In en, this message translates to:
  /// **'With who?'**
  String get memoryWhoWith;

  /// memory photo section title
  ///
  /// In en, this message translates to:
  /// **'A photo that reminds you of this memory'**
  String get memoryPhotoSectionTitle;

  /// memory what happened
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get memoryWhatHappened;

  /// memory cat mood section
  ///
  /// In en, this message translates to:
  /// **'Their mood'**
  String get memoryCatMoodSection;

  /// memory user mood section
  ///
  /// In en, this message translates to:
  /// **'How you felt?'**
  String get memoryUserMoodSection;

  /// memory when section
  ///
  /// In en, this message translates to:
  /// **'When?'**
  String get memoryWhenSection;

  /// memory saved
  ///
  /// In en, this message translates to:
  /// **'Saved ✓'**
  String get memorySaved;

  /// memory select cat
  ///
  /// In en, this message translates to:
  /// **'Select Cat'**
  String get memorySelectCat;

  /// memory cat required
  ///
  /// In en, this message translates to:
  /// **'Please select a cat for this memory.'**
  String get memoryCatRequired;

  /// memory photo label
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get memoryPhotoLabel;

  /// memory cat mood label
  ///
  /// In en, this message translates to:
  /// **'Cat\'s Mood'**
  String get memoryCatMoodLabel;

  /// memory user mood label
  ///
  /// In en, this message translates to:
  /// **'Your Mood'**
  String get memoryUserMoodLabel;

  /// memory date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get memoryDateLabel;

  /// memory time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get memoryTimeLabel;

  /// memory detail title
  ///
  /// In en, this message translates to:
  /// **'Memory Detail'**
  String get memoryDetailTitle;

  /// memory not found title
  ///
  /// In en, this message translates to:
  /// **'Memory not found'**
  String get memoryNotFoundTitle;

  /// memory not found desc
  ///
  /// In en, this message translates to:
  /// **'This memory is no longer available or may have been deleted.'**
  String get memoryNotFoundDesc;

  /// memory mood section title
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get memoryMoodSectionTitle;

  /// No description provided for @memoryCatMoodFormat.
  ///
  /// In en, this message translates to:
  /// **'Their mood: {mood}'**
  String memoryCatMoodFormat(String mood);

  /// No description provided for @memoryUserMoodFormat.
  ///
  /// In en, this message translates to:
  /// **'Your mood: {mood}'**
  String memoryUserMoodFormat(String mood);

  /// cat detail title
  ///
  /// In en, this message translates to:
  /// **'Cat Story'**
  String get catDetailTitle;

  /// cat not found title
  ///
  /// In en, this message translates to:
  /// **'Cat not found'**
  String get catNotFoundTitle;

  /// cat not found desc
  ///
  /// In en, this message translates to:
  /// **'This story is no longer available or may have been deleted.'**
  String get catNotFoundDesc;

  /// No description provided for @catDetailStorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Little moments you shared together. {memoryText}'**
  String catDetailStorySubtitle(String memoryText);

  /// cat detail memory count zero
  ///
  /// In en, this message translates to:
  /// **'This story will begin with its first memory.'**
  String get catDetailMemoryCountZero;

  /// cat detail memory count single
  ///
  /// In en, this message translates to:
  /// **'1 little moment here.'**
  String get catDetailMemoryCountSingle;

  /// No description provided for @catDetailMemoryCountMultiple.
  ///
  /// In en, this message translates to:
  /// **'{count} little moments here.'**
  String catDetailMemoryCountMultiple(int count);

  /// cat detail memories section title
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get catDetailMemoriesSectionTitle;

  /// No description provided for @catDetailMemoriesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory recorded} other{{count} memories recorded}}'**
  String catDetailMemoriesSectionSubtitle(int count);

  /// cat detail empty memories title
  ///
  /// In en, this message translates to:
  /// **'The story is just beginning.'**
  String get catDetailEmptyMemoriesTitle;

  /// cat detail empty memories desc
  ///
  /// In en, this message translates to:
  /// **'You can save the first little moment you shared with this cat here.'**
  String get catDetailEmptyMemoriesDesc;

  /// cat detail empty memories cta
  ///
  /// In en, this message translates to:
  /// **'Add First Memory'**
  String get catDetailEmptyMemoriesCta;

  /// cat detail action add memory
  ///
  /// In en, this message translates to:
  /// **'Add Memory'**
  String get catDetailActionAddMemory;

  /// cat detail note title
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get catDetailNoteTitle;

  /// No description provided for @catDetailPhotoSemantic.
  ///
  /// In en, this message translates to:
  /// **'Photo of {name}'**
  String catDetailPhotoSemantic(String name);

  /// cat detail back semantic
  ///
  /// In en, this message translates to:
  /// **'Go back from cat details'**
  String get catDetailBackSemantic;

  /// cat detail delete semantic
  ///
  /// In en, this message translates to:
  /// **'Delete cat'**
  String get catDetailDeleteSemantic;

  /// cat detail edit semantic
  ///
  /// In en, this message translates to:
  /// **'Edit cat'**
  String get catDetailEditSemantic;

  /// profile title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// profile greeting prefix
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get profileGreetingPrefix;

  /// profile default title
  ///
  /// In en, this message translates to:
  /// **'Your Story'**
  String get profileDefaultTitle;

  /// profile subtitle
  ///
  /// In en, this message translates to:
  /// **'This is your personal space in Meowoirs.'**
  String get profileSubtitle;

  /// profile edit button
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditButton;

  /// profile edit dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditDialogTitle;

  /// profile nickname label
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get profileNicknameLabel;

  /// profile nickname hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Luna'**
  String get profileNicknameHint;

  /// profile select avatar
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get profileSelectAvatar;

  /// profile save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// profile cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// favorite cat title
  ///
  /// In en, this message translates to:
  /// **'Favorite Cat'**
  String get favoriteCatTitle;

  /// favorite cat change
  ///
  /// In en, this message translates to:
  /// **'Change Favorite Cat'**
  String get favoriteCatChange;

  /// favorite cat select
  ///
  /// In en, this message translates to:
  /// **'Select Favorite Cat'**
  String get favoriteCatSelect;

  /// favorite cat empty title
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a favorite cat yet.'**
  String get favoriteCatEmptyTitle;

  /// favorite cat empty cta
  ///
  /// In en, this message translates to:
  /// **'Add Your First Cat'**
  String get favoriteCatEmptyCta;

  /// favorite cat none selected
  ///
  /// In en, this message translates to:
  /// **'No favorite cat selected yet.'**
  String get favoriteCatNoneSelected;

  /// favorite cat dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Favorite Cat'**
  String get favoriteCatDialogTitle;

  /// my story title
  ///
  /// In en, this message translates to:
  /// **'My Story'**
  String get myStoryTitle;

  /// my story subtitle
  ///
  /// In en, this message translates to:
  /// **'Little moments gathered between you and your cats.'**
  String get myStorySubtitle;

  /// my story view all
  ///
  /// In en, this message translates to:
  /// **'View Full Story'**
  String get myStoryViewAll;

  /// my story your story
  ///
  /// In en, this message translates to:
  /// **'Your Meowoirs'**
  String get myStoryYourStory;

  /// my story cats section
  ///
  /// In en, this message translates to:
  /// **'Your Cats'**
  String get myStoryCatsSection;

  /// my story see all
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get myStorySeeAll;

  /// my story most remembered title
  ///
  /// In en, this message translates to:
  /// **'Most remembered'**
  String get myStoryMostRememberedTitle;

  /// No description provided for @myStoryMostRememberedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory recorded} other{{count} memories recorded}}'**
  String myStoryMostRememberedSubtitle(int count);

  /// my story recent moment
  ///
  /// In en, this message translates to:
  /// **'Recent Moment'**
  String get myStoryRecentMoment;

  /// my story beginning title
  ///
  /// In en, this message translates to:
  /// **'Your first moment in Meowoirs'**
  String get myStoryBeginningTitle;

  /// my story completely empty title
  ///
  /// In en, this message translates to:
  /// **'Your story will begin here.'**
  String get myStoryCompletelyEmptyTitle;

  /// my story completely empty subtitle
  ///
  /// In en, this message translates to:
  /// **'The little moments shared with your cats will turn into your own story over time.'**
  String get myStoryCompletelyEmptySubtitle;

  /// my story completely empty add memory
  ///
  /// In en, this message translates to:
  /// **'Add First Memory'**
  String get myStoryCompletelyEmptyAddMemory;

  /// my story completely empty add cat
  ///
  /// In en, this message translates to:
  /// **'Add First Cat'**
  String get myStoryCompletelyEmptyAddCat;

  /// my story partial empty title
  ///
  /// In en, this message translates to:
  /// **'No memories to tell yet.'**
  String get myStoryPartialEmptyTitle;

  /// my story partial empty subtitle
  ///
  /// In en, this message translates to:
  /// **'Your cats are here. Save the first little moment you shared with them.'**
  String get myStoryPartialEmptySubtitle;

  /// my story partial empty add memory
  ///
  /// In en, this message translates to:
  /// **'Add First Memory'**
  String get myStoryPartialEmptyAddMemory;

  /// my story error title
  ///
  /// In en, this message translates to:
  /// **'Could not load story'**
  String get myStoryErrorTitle;

  /// my story error desc
  ///
  /// In en, this message translates to:
  /// **'A problem occurred while loading your story.'**
  String get myStoryErrorDesc;

  /// my story error retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get myStoryErrorRetry;

  /// No description provided for @myStoryMostRememberedSemantic.
  ///
  /// In en, this message translates to:
  /// **'{catName}, most remembered cat. {count} memories.'**
  String myStoryMostRememberedSemantic(String catName, int count);

  /// No description provided for @myStoryBeginningSemantic.
  ///
  /// In en, this message translates to:
  /// **'Your first moment in Meowoirs: {date}'**
  String myStoryBeginningSemantic(String date);

  /// stat cats
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get statCats;

  /// stat memories
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get statMemories;

  /// stat home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get statHome;

  /// stat street
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get statStreet;

  /// settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// settings appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// settings theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// theme system
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// theme light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// theme dark
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// settings privacy legal
  ///
  /// In en, this message translates to:
  /// **'Privacy & Legal'**
  String get settingsPrivacyLegal;

  /// settings privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// settings terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// settings ad privacy
  ///
  /// In en, this message translates to:
  /// **'Ad Privacy Options'**
  String get settingsAdPrivacy;

  /// privacy pending title
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get privacyPendingTitle;

  /// privacy pending desc
  ///
  /// In en, this message translates to:
  /// **'Our Privacy Policy and Terms of Service will soon be available online.'**
  String get privacyPendingDesc;

  /// ump not required
  ///
  /// In en, this message translates to:
  /// **'Ad privacy options are not required for your region or current session.'**
  String get umpNotRequired;

  /// settings language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// settings app language
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsAppLanguage;

  /// settings reach us
  ///
  /// In en, this message translates to:
  /// **'Reach Us'**
  String get settingsReachUs;

  /// reach us thank you title
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Meowoirs.'**
  String get reachUsThankYouTitle;

  /// reach us thank you desc
  ///
  /// In en, this message translates to:
  /// **'We are happy that every little memory turns into a personal story with you.'**
  String get reachUsThankYouDesc;

  /// reach us action suggestion
  ///
  /// In en, this message translates to:
  /// **'Send Suggestion'**
  String get reachUsActionSuggestion;

  /// reach us action bug
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reachUsActionBug;

  /// reach us action contact
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get reachUsActionContact;

  /// reach us no email app
  ///
  /// In en, this message translates to:
  /// **'No email application found on this device.'**
  String get reachUsNoEmailApp;

  /// settings app
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settingsApp;

  /// No description provided for @versionFormat.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionFormat(String version);

  /// No description provided for @versionBuildFormat.
  ///
  /// In en, this message translates to:
  /// **'Version {version} (Build {build})'**
  String versionBuildFormat(String version, int build);

  /// action edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// action delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// action cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// action save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// action save changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get actionSaveChanges;

  /// action back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// action retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// loading
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// delete cat title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this cat?'**
  String get deleteCatTitle;

  /// delete cat message
  ///
  /// In en, this message translates to:
  /// **'The cat profile will be deleted. Saved memories will be preserved.'**
  String get deleteCatMessage;

  /// delete memory title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this memory?'**
  String get deleteMemoryTitle;

  /// delete memory message
  ///
  /// In en, this message translates to:
  /// **'This memory will be permanently deleted.'**
  String get deleteMemoryMessage;

  /// error generic operation
  ///
  /// In en, this message translates to:
  /// **'An error occurred during the operation. Please try again.'**
  String get errorGenericOperation;

  /// cat save error
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the cat. Please try again.'**
  String get catSaveError;

  /// memory save error
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the memory. Please try again.'**
  String get memorySaveError;

  /// cat delete error
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting the cat. Please try again.'**
  String get catDeleteError;

  /// memory delete error
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting the memory. Please try again.'**
  String get memoryDeleteError;

  /// photo load failed
  ///
  /// In en, this message translates to:
  /// **'Photo could not be loaded'**
  String get photoLoadFailed;

  /// legal view online
  ///
  /// In en, this message translates to:
  /// **'View Online'**
  String get legalViewOnline;

  /// legal document close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get legalDocumentClose;

  /// legal data deletion
  ///
  /// In en, this message translates to:
  /// **'Data & Deletion'**
  String get legalDataDeletion;

  /// legal third party
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get legalThirdParty;

  /// legal advertising consent
  ///
  /// In en, this message translates to:
  /// **'Advertising & Consent'**
  String get legalAdvertisingConsent;

  /// legal disclaimer
  ///
  /// In en, this message translates to:
  /// **'Legal Disclaimer'**
  String get legalDisclaimer;

  /// legal document load error
  ///
  /// In en, this message translates to:
  /// **'Could not load document.'**
  String get legalDocumentLoadError;

  /// legal document retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get legalDocumentRetry;

  /// onboarding skip
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get onboardingSkip;

  /// onboarding continue
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get onboardingContinue;

  /// onboarding step1 chap
  ///
  /// In en, this message translates to:
  /// **'VOLUME I — CHAPTER 01'**
  String get onboardingStep1Chap;

  /// onboarding step1 badge
  ///
  /// In en, this message translates to:
  /// **'MORNING LIGHT'**
  String get onboardingStep1Badge;

  /// onboarding step1 quote
  ///
  /// In en, this message translates to:
  /// **'«Like a quiet whisper...»'**
  String get onboardingStep1Quote;

  /// onboarding step1 intro
  ///
  /// In en, this message translates to:
  /// **'INTRODUCTORY NOTE'**
  String get onboardingStep1Intro;

  /// onboarding step1 intro sub
  ///
  /// In en, this message translates to:
  /// **'OPENING'**
  String get onboardingStep1IntroSub;

  /// onboarding step1 title
  ///
  /// In en, this message translates to:
  /// **'Every cat has a story.'**
  String get onboardingStep1Title;

  /// onboarding step1 desc
  ///
  /// In en, this message translates to:
  /// **'Meowoirs is your personal space to keep the little moments, photos, and stories you share with your cats.'**
  String get onboardingStep1Desc;

  /// onboarding step1 feature title
  ///
  /// In en, this message translates to:
  /// **'Create Your Personal Archive'**
  String get onboardingStep1FeatureTitle;

  /// onboarding step1 feature desc
  ///
  /// In en, this message translates to:
  /// **'Build your own memory archive with photos, notes, and little moments.'**
  String get onboardingStep1FeatureDesc;

  /// onboarding step1 footer1
  ///
  /// In en, this message translates to:
  /// **'MEOWOIRS ARCHIVE'**
  String get onboardingStep1Footer1;

  /// onboarding step1 footer2
  ///
  /// In en, this message translates to:
  /// **'FIRST PAGE'**
  String get onboardingStep1Footer2;

  /// onboarding step2 chap
  ///
  /// In en, this message translates to:
  /// **'CHAPTER II — DIARY FRAGMENTS'**
  String get onboardingStep2Chap;

  /// onboarding step2 title
  ///
  /// In en, this message translates to:
  /// **'Keep the little moments.'**
  String get onboardingStep2Title;

  /// onboarding step2 subtitle
  ///
  /// In en, this message translates to:
  /// **'A photo, a few words, and the feeling of that moment.'**
  String get onboardingStep2Subtitle;

  /// onboarding step2 badge1
  ///
  /// In en, this message translates to:
  /// **'ANNO. 128'**
  String get onboardingStep2Badge1;

  /// onboarding step2 badge2
  ///
  /// In en, this message translates to:
  /// **'08:45 Morning Sleep'**
  String get onboardingStep2Badge2;

  /// onboarding step2 date
  ///
  /// In en, this message translates to:
  /// **'October 14'**
  String get onboardingStep2Date;

  /// onboarding step2 mood
  ///
  /// In en, this message translates to:
  /// **'Peaceful'**
  String get onboardingStep2Mood;

  /// onboarding step2 editorial text
  ///
  /// In en, this message translates to:
  /// **'Meowoirs turns ordinary moments into little stories you won\'t want to forget.'**
  String get onboardingStep2EditorialText;

  /// onboarding step2 footer1
  ///
  /// In en, this message translates to:
  /// **'PERSONAL ARCHIVE'**
  String get onboardingStep2Footer1;

  /// onboarding step2 footer2
  ///
  /// In en, this message translates to:
  /// **'LITTLE MOMENTS'**
  String get onboardingStep2Footer2;

  /// onboarding step3 chap
  ///
  /// In en, this message translates to:
  /// **'CHAPTER III — IN YOUR STORY'**
  String get onboardingStep3Chap;

  /// onboarding step3 title
  ///
  /// In en, this message translates to:
  /// **'Every cat can be in your story.'**
  String get onboardingStep3Title;

  /// onboarding step3 desc
  ///
  /// In en, this message translates to:
  /// **'From the cat in your home to a friend you met on the street, keep the little moments that touch your life.'**
  String get onboardingStep3Desc;

  /// onboarding step3 home badge
  ///
  /// In en, this message translates to:
  /// **'AT HOME'**
  String get onboardingStep3HomeBadge;

  /// onboarding step3 home title
  ///
  /// In en, this message translates to:
  /// **'Our Home\'s Story'**
  String get onboardingStep3HomeTitle;

  /// onboarding step3 street badge
  ///
  /// In en, this message translates to:
  /// **'STREET STORY'**
  String get onboardingStep3StreetBadge;

  /// onboarding step3 street title
  ///
  /// In en, this message translates to:
  /// **'Spirit of the Street'**
  String get onboardingStep3StreetTitle;

  /// onboarding step3 street subtitle
  ///
  /// In en, this message translates to:
  /// **'Olive — Old friend from the neighborhood'**
  String get onboardingStep3StreetSubtitle;

  /// onboarding step3 feature title
  ///
  /// In en, this message translates to:
  /// **'At Home or On the Street'**
  String get onboardingStep3FeatureTitle;

  /// onboarding step3 feature desc
  ///
  /// In en, this message translates to:
  /// **'Include the cats in your home or those you meet on the street in your own story.'**
  String get onboardingStep3FeatureDesc;

  /// onboarding step3 footer1
  ///
  /// In en, this message translates to:
  /// **'MEOWOIRS ARCHIVE'**
  String get onboardingStep3Footer1;

  /// onboarding step3 footer2
  ///
  /// In en, this message translates to:
  /// **'EVERY CAT'**
  String get onboardingStep3Footer2;

  /// onboarding step4 chap
  ///
  /// In en, this message translates to:
  /// **'CHAPTER IV • PRIVACY & TRUST'**
  String get onboardingStep4Chap;

  /// onboarding step4 title
  ///
  /// In en, this message translates to:
  /// **'Your story is yours.'**
  String get onboardingStep4Title;

  /// onboarding step4 desc
  ///
  /// In en, this message translates to:
  /// **'Your memories and photos stay on your device. Meowoirs does not store them on its servers and does not require an account or cloud sync.'**
  String get onboardingStep4Desc;

  /// onboarding step4 feature title
  ///
  /// In en, this message translates to:
  /// **'Stays on Your Device'**
  String get onboardingStep4FeatureTitle;

  /// onboarding step4 feature desc
  ///
  /// In en, this message translates to:
  /// **'Your cat profiles, photos, notes, and memories are stored locally on your device.'**
  String get onboardingStep4FeatureDesc;

  /// onboarding step4 privacy checkbox
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Privacy Policy.'**
  String get onboardingStep4PrivacyCheckbox;

  /// onboarding step4 privacy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get onboardingStep4PrivacyLink;

  /// onboarding step4 terms checkbox
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms of Service.'**
  String get onboardingStep4TermsCheckbox;

  /// onboarding step4 terms link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get onboardingStep4TermsLink;

  /// onboarding step4 start
  ///
  /// In en, this message translates to:
  /// **'Start Meowoirs →'**
  String get onboardingStep4Start;

  /// onboarding step4 footer
  ///
  /// In en, this message translates to:
  /// **'MEOWOIRS • PERSONAL ARCHIVE'**
  String get onboardingStep4Footer;

  /// onboarding legal ok
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get onboardingLegalOk;

  /// avatar desc warm cat
  ///
  /// In en, this message translates to:
  /// **'Warm ginger cat'**
  String get avatarDescWarmCat;

  /// avatar desc sage cat
  ///
  /// In en, this message translates to:
  /// **'Calm sage cat'**
  String get avatarDescSageCat;

  /// avatar desc lavender cat
  ///
  /// In en, this message translates to:
  /// **'Dreamy lavender cat'**
  String get avatarDescLavenderCat;

  /// avatar desc curious cat
  ///
  /// In en, this message translates to:
  /// **'Curious cat'**
  String get avatarDescCuriousCat;

  /// avatar desc cozy cat
  ///
  /// In en, this message translates to:
  /// **'Cozy sleeping cat'**
  String get avatarDescCozyCat;

  /// avatar desc gentle paw
  ///
  /// In en, this message translates to:
  /// **'Gentle paw print'**
  String get avatarDescGentlePaw;

  /// avatar desc star gazer
  ///
  /// In en, this message translates to:
  /// **'Star gazing cat'**
  String get avatarDescStarGazer;

  /// avatar desc book cat
  ///
  /// In en, this message translates to:
  /// **'Book lover cat'**
  String get avatarDescBookCat;

  /// avatar desc sunlit cat
  ///
  /// In en, this message translates to:
  /// **'Sunlit resting cat'**
  String get avatarDescSunlitCat;

  /// avatar desc whisker heart
  ///
  /// In en, this message translates to:
  /// **'Whisker heart'**
  String get avatarDescWhiskerHeart;

  /// debug panel unlocked
  ///
  /// In en, this message translates to:
  /// **'Developer panel unlocked'**
  String get debugPanelUnlocked;

  /// debug onboarding completed
  ///
  /// In en, this message translates to:
  /// **'Onboarding Completed'**
  String get debugOnboardingCompleted;

  /// debug accepted legal version
  ///
  /// In en, this message translates to:
  /// **'Accepted Legal Version'**
  String get debugAcceptedLegalVersion;

  /// debug reset onboarding
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER: RESET ONBOARDING'**
  String get debugResetOnboarding;

  /// debug onboarding reset toast
  ///
  /// In en, this message translates to:
  /// **'Onboarding status reset'**
  String get debugOnboardingResetToast;

  /// profile nickname placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g. Luna'**
  String get profileNicknamePlaceholder;

  /// favorite cat section title
  ///
  /// In en, this message translates to:
  /// **'Favorite Cat'**
  String get favoriteCatSectionTitle;

  /// favorite cat change button
  ///
  /// In en, this message translates to:
  /// **'Change Favorite Cat'**
  String get favoriteCatChangeButton;

  /// favorite cat select button
  ///
  /// In en, this message translates to:
  /// **'Select Favorite Cat'**
  String get favoriteCatSelectButton;

  /// my story section title
  ///
  /// In en, this message translates to:
  /// **'My Story'**
  String get myStorySectionTitle;

  /// profile settings button
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsButton;

  /// tooltip back
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get tooltipBack;

  /// semantics selected
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get semanticsSelected;

  /// semantics not selected
  ///
  /// In en, this message translates to:
  /// **'not selected'**
  String get semanticsNotSelected;

  /// mood happy
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// mood curious
  ///
  /// In en, this message translates to:
  /// **'Curious'**
  String get moodCurious;

  /// mood sleepy
  ///
  /// In en, this message translates to:
  /// **'Sleepy'**
  String get moodSleepy;

  /// mood playful
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get moodPlayful;

  /// mood calm
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// mood affectionate
  ///
  /// In en, this message translates to:
  /// **'Affectionate'**
  String get moodAffectionate;

  /// mood peaceful
  ///
  /// In en, this message translates to:
  /// **'Peaceful'**
  String get moodPeaceful;

  /// mood nostalgic
  ///
  /// In en, this message translates to:
  /// **'Nostalgic'**
  String get moodNostalgic;

  /// mood joyful
  ///
  /// In en, this message translates to:
  /// **'Joyful'**
  String get moodJoyful;

  /// mood emotional
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get moodEmotional;

  /// No description provided for @addMemorySelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date: {date}'**
  String addMemorySelectDate(String date);

  /// add memory cat empty action
  ///
  /// In en, this message translates to:
  /// **'Add Cat'**
  String get addMemoryCatEmptyAction;

  /// No description provided for @memoryCatNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'{catName}\'s memory: {note}'**
  String memoryCatNoteLabel(String catName, String note);

  /// story narrative empty
  ///
  /// In en, this message translates to:
  /// **'The little moments you share with your cats will eventually become your own story.'**
  String get storyNarrativeEmpty;

  /// story narrative cats no memories
  ///
  /// In en, this message translates to:
  /// **'Your cats are here. Keep the first little moment you share with them.'**
  String get storyNarrativeCatsNoMemories;

  /// No description provided for @storyNarrativeSingleCat.
  ///
  /// In en, this message translates to:
  /// **'{catName} has {count, plural, =1{1 little moment} other{{count} little moments}} kept here.'**
  String storyNarrativeSingleCat(String catName, int count);

  /// No description provided for @storyNarrativeHomeAndStreet.
  ///
  /// In en, this message translates to:
  /// **'You\'ve gathered {memoriesCount} little moments with {catsCount} friends. Warm moments at home and little street stories together.'**
  String storyNarrativeHomeAndStreet(int memoriesCount, int catsCount);

  /// No description provided for @storyNarrativeGeneral.
  ///
  /// In en, this message translates to:
  /// **'You\'ve gathered {memoriesCount} little moments with {catsCount} cats. Over time, these moments form your Meowoirs story.'**
  String storyNarrativeGeneral(int memoriesCount, int catsCount);

  /// legal title privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalTitlePrivacyPolicy;

  /// legal title terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get legalTitleTermsOfService;

  /// legal title data deletion
  ///
  /// In en, this message translates to:
  /// **'Data Deletion Policy'**
  String get legalTitleDataDeletion;

  /// legal title third party services
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get legalTitleThirdPartyServices;

  /// legal title advertising and consent
  ///
  /// In en, this message translates to:
  /// **'Advertising & Consent Policy'**
  String get legalTitleAdvertisingAndConsent;

  /// legal title legal disclaimer
  ///
  /// In en, this message translates to:
  /// **'Legal Disclaimer'**
  String get legalTitleLegalDisclaimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'nl',
    'pl',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
