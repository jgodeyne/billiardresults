import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Billiard Results'**
  String get appTitle;

  /// Dashboard tab label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Results tab label
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Billiard Results!'**
  String get onboardingWelcome;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your profile'**
  String get onboardingSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @nameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameError;

  /// No description provided for @seasonStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Season Start Date'**
  String get seasonStartLabel;

  /// No description provided for @seasonStartHint.
  ///
  /// In en, this message translates to:
  /// **'Select day and month'**
  String get seasonStartHint;

  /// No description provided for @seasonStartError.
  ///
  /// In en, this message translates to:
  /// **'Please select a season start date'**
  String get seasonStartError;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @classificationLevels.
  ///
  /// In en, this message translates to:
  /// **'Classification Levels'**
  String get classificationLevels;

  /// No description provided for @classificationLevelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set target average ranges per discipline'**
  String get classificationLevelsSubtitle;

  /// No description provided for @noDisciplines.
  ///
  /// In en, this message translates to:
  /// **'No disciplines yet. Add results to set classification levels.'**
  String get noDisciplines;

  /// No description provided for @minimumAverage.
  ///
  /// In en, this message translates to:
  /// **'Minimum Average'**
  String get minimumAverage;

  /// No description provided for @maximumAverage.
  ///
  /// In en, this message translates to:
  /// **'Maximum Average'**
  String get maximumAverage;

  /// No description provided for @averageRange.
  ///
  /// In en, this message translates to:
  /// **'Average Range'**
  String get averageRange;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data?'**
  String get deleteAllDataConfirmTitle;

  /// No description provided for @deleteAllDataConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your results, classification levels, and settings. This action cannot be undone.'**
  String get deleteAllDataConfirmMessage;

  /// No description provided for @deleteClassificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Classification?'**
  String get deleteClassificationTitle;

  /// No description provided for @deleteClassificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove classification level for {discipline}?'**
  String deleteClassificationMessage(String discipline);

  /// No description provided for @dataDeleted.
  ///
  /// In en, this message translates to:
  /// **'All data has been deleted'**
  String get dataDeleted;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @classificationSaved.
  ///
  /// In en, this message translates to:
  /// **'Classification level saved'**
  String get classificationSaved;

  /// No description provided for @classificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Classification level deleted'**
  String get classificationDeleted;

  /// No description provided for @errorSavingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error saving settings'**
  String get errorSavingSettings;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @addResult.
  ///
  /// In en, this message translates to:
  /// **'Add Result'**
  String get addResult;

  /// No description provided for @editResult.
  ///
  /// In en, this message translates to:
  /// **'Edit Result'**
  String get editResult;

  /// No description provided for @disciplineLabel.
  ///
  /// In en, this message translates to:
  /// **'Discipline'**
  String get disciplineLabel;

  /// No description provided for @disciplineHint.
  ///
  /// In en, this message translates to:
  /// **'Select or enter discipline'**
  String get disciplineHint;

  /// No description provided for @disciplineError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a discipline'**
  String get disciplineError;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @dateHint.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get dateHint;

  /// No description provided for @pointsMadeLabel.
  ///
  /// In en, this message translates to:
  /// **'Points Made'**
  String get pointsMadeLabel;

  /// No description provided for @pointsMadeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter points made'**
  String get pointsMadeHint;

  /// No description provided for @pointsMadeError.
  ///
  /// In en, this message translates to:
  /// **'Points must be 0 or greater'**
  String get pointsMadeError;

  /// No description provided for @inningsLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of Innings'**
  String get inningsLabel;

  /// No description provided for @inningsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter number of innings'**
  String get inningsHint;

  /// No description provided for @inningsError.
  ///
  /// In en, this message translates to:
  /// **'Innings must be greater than 0'**
  String get inningsError;

  /// No description provided for @highestRunLabel.
  ///
  /// In en, this message translates to:
  /// **'Highest Run'**
  String get highestRunLabel;

  /// No description provided for @highestRunHint.
  ///
  /// In en, this message translates to:
  /// **'Enter highest run'**
  String get highestRunHint;

  /// No description provided for @highestRunError.
  ///
  /// In en, this message translates to:
  /// **'Highest run must be between 0 and points made'**
  String get highestRunError;

  /// No description provided for @adversaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Adversary (Optional)'**
  String get adversaryLabel;

  /// No description provided for @adversaryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter opponent name'**
  String get adversaryHint;

  /// No description provided for @outcomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Match Outcome (Optional)'**
  String get outcomeLabel;

  /// No description provided for @outcomeWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get outcomeWon;

  /// No description provided for @outcomeLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get outcomeLost;

  /// No description provided for @outcomeDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get outcomeDraw;

  /// No description provided for @outcomeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get outcomeUnknown;

  /// No description provided for @competitionLabel.
  ///
  /// In en, this message translates to:
  /// **'Competition (Optional)'**
  String get competitionLabel;

  /// No description provided for @competitionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter competition name'**
  String get competitionHint;

  /// No description provided for @resultSaved.
  ///
  /// In en, this message translates to:
  /// **'Result saved successfully'**
  String get resultSaved;

  /// No description provided for @resultDeleted.
  ///
  /// In en, this message translates to:
  /// **'Result deleted'**
  String get resultDeleted;

  /// No description provided for @errorSavingResult.
  ///
  /// In en, this message translates to:
  /// **'Error saving result'**
  String get errorSavingResult;

  /// No description provided for @deleteResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Result?'**
  String get deleteResultTitle;

  /// No description provided for @deleteResultMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this result.'**
  String get deleteResultMessage;

  /// No description provided for @warningHighPoints.
  ///
  /// In en, this message translates to:
  /// **'Warning: Points value seems high (>{limit}). Please verify.'**
  String warningHighPoints(int limit);

  /// No description provided for @warningHighInnings.
  ///
  /// In en, this message translates to:
  /// **'Warning: Innings value seems high (>{limit}). Please verify.'**
  String warningHighInnings(int limit);

  /// No description provided for @warningHighRun.
  ///
  /// In en, this message translates to:
  /// **'Warning: Highest run seems high (>{limit}). Please verify.'**
  String warningHighRun(int limit);

  /// No description provided for @requiredFields.
  ///
  /// In en, this message translates to:
  /// **'Required fields'**
  String get requiredFields;

  /// No description provided for @optionalFields.
  ///
  /// In en, this message translates to:
  /// **'Optional fields'**
  String get optionalFields;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @disciplineFreeSmall.
  ///
  /// In en, this message translates to:
  /// **'Free game - Small table'**
  String get disciplineFreeSmall;

  /// No description provided for @disciplineFreeMatch.
  ///
  /// In en, this message translates to:
  /// **'Free game - Match table'**
  String get disciplineFreeMatch;

  /// No description provided for @discipline1CushionSmall.
  ///
  /// In en, this message translates to:
  /// **'1-cushion - Small table'**
  String get discipline1CushionSmall;

  /// No description provided for @discipline1CushionMatch.
  ///
  /// In en, this message translates to:
  /// **'1-cushion - Match table'**
  String get discipline1CushionMatch;

  /// No description provided for @discipline3CushionSmall.
  ///
  /// In en, this message translates to:
  /// **'3-cushion - Small table'**
  String get discipline3CushionSmall;

  /// No description provided for @discipline3CushionMatch.
  ///
  /// In en, this message translates to:
  /// **'3-cushion - Match table'**
  String get discipline3CushionMatch;

  /// No description provided for @disciplineBalkline382Small.
  ///
  /// In en, this message translates to:
  /// **'Balkline 38/2 - Small table'**
  String get disciplineBalkline382Small;

  /// No description provided for @disciplineBalkline572Small.
  ///
  /// In en, this message translates to:
  /// **'Balkline 57/2 - Small table'**
  String get disciplineBalkline572Small;

  /// No description provided for @disciplineBalkline472Match.
  ///
  /// In en, this message translates to:
  /// **'Balkline 47/2 - Match table'**
  String get disciplineBalkline472Match;

  /// No description provided for @disciplineBalkline471Match.
  ///
  /// In en, this message translates to:
  /// **'Balkline 47/1 - Match table'**
  String get disciplineBalkline471Match;

  /// No description provided for @disciplineBalkline712Match.
  ///
  /// In en, this message translates to:
  /// **'Balkline 71/2 - Match table'**
  String get disciplineBalkline712Match;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
