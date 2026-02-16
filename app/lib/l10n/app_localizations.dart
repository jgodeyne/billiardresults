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
  /// **'CaromStats'**
  String get appTitle;

  /// Dashboard tab label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Results tab label
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get results;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CaromStats!'**
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

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get selectMonth;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select day'**
  String get selectDay;

  /// No description provided for @selectMonthFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a month first'**
  String get selectMonthFirst;

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

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import from CSV'**
  String get importData;

  /// No description provided for @importDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Import results from a CSV file exported from Numbers or Excel'**
  String get importDataDescription;

  /// No description provided for @selectCsvFile.
  ///
  /// In en, this message translates to:
  /// **'Select CSV File'**
  String get selectCsvFile;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Import Preview'**
  String get importPreview;

  /// No description provided for @importResults.
  ///
  /// In en, this message translates to:
  /// **'Import Results'**
  String get importResults;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} results'**
  String importSuccess(int count);

  /// No description provided for @importErrors.
  ///
  /// In en, this message translates to:
  /// **'Import completed with {errorCount} errors'**
  String importErrors(int errorCount);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @csvFormatHelp.
  ///
  /// In en, this message translates to:
  /// **'CSV Format Help'**
  String get csvFormatHelp;

  /// No description provided for @csvFormatDescription.
  ///
  /// In en, this message translates to:
  /// **'Your CSV file must have these columns:\n\nRequired:\n• Date (YYYY-MM-DD, DD/MM/YYYY, or MM/DD/YYYY)\n• Discipline\n• Points\n• Innings\n• Highest Run\n\nOptional:\n• Adversary\n• Competition\n• Outcome (won/lost/draw)'**
  String get csvFormatDescription;

  /// No description provided for @downloadExample.
  ///
  /// In en, this message translates to:
  /// **'Download Example CSV'**
  String get downloadExample;

  /// No description provided for @importConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Import {count} Results?'**
  String importConfirmTitle(int count);

  /// No description provided for @importConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will add {count} results to your database. Continue?'**
  String importConfirmMessage(int count);

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @backupToCloud.
  ///
  /// In en, this message translates to:
  /// **'Backup to Cloud'**
  String get backupToCloud;

  /// No description provided for @restoreFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud'**
  String get restoreFromCloud;

  /// No description provided for @backupToICloud.
  ///
  /// In en, this message translates to:
  /// **'Backup your data to iCloud Drive'**
  String get backupToICloud;

  /// No description provided for @backupToGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Backup your data to Google Drive'**
  String get backupToGoogleDrive;

  /// No description provided for @restoreFromICloud.
  ///
  /// In en, this message translates to:
  /// **'Restore your data from iCloud Drive'**
  String get restoreFromICloud;

  /// No description provided for @restoreFromGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Restore your data from Google Drive'**
  String get restoreFromGoogleDrive;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get lastBackup;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @backingUp.
  ///
  /// In en, this message translates to:
  /// **'Backing up...'**
  String get backingUp;

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// No description provided for @backupSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Backup successful'**
  String get backupSuccessful;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @restoreSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Restore successful'**
  String get restoreSuccessful;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get restoreFailed;

  /// No description provided for @noBackupFound.
  ///
  /// In en, this message translates to:
  /// **'No backup found in cloud'**
  String get noBackupFound;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace all your current data with the backup. This action cannot be undone. Continue?'**
  String get restoreConfirmMessage;

  /// No description provided for @signInToGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Google'**
  String get signInToGoogle;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

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
  /// **'Competition'**
  String get competitionLabel;

  /// No description provided for @competitionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter competition name'**
  String get competitionHint;

  /// No description provided for @competitionError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a competition name'**
  String get competitionError;

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

  /// No description provided for @currentSeason.
  ///
  /// In en, this message translates to:
  /// **'Current Season'**
  String get currentSeason;

  /// No description provided for @selectSeason.
  ///
  /// In en, this message translates to:
  /// **'Select Season'**
  String get selectSeason;

  /// No description provided for @noResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get noResultsYet;

  /// No description provided for @addFirstResult.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first result'**
  String get addFirstResult;

  /// No description provided for @noResultsThisSeason.
  ///
  /// In en, this message translates to:
  /// **'No results for this season'**
  String get noResultsThisSeason;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @totalInnings.
  ///
  /// In en, this message translates to:
  /// **'Total Innings'**
  String get totalInnings;

  /// No description provided for @highestRun.
  ///
  /// In en, this message translates to:
  /// **'Highest Run'**
  String get highestRun;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @won.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get won;

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get lost;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get draw;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get unknown;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'{discipline} Details'**
  String detailTitle(String discipline);

  /// No description provided for @averageEvolution.
  ///
  /// In en, this message translates to:
  /// **'Average Evolution'**
  String get averageEvolution;

  /// No description provided for @highestRunEvolution.
  ///
  /// In en, this message translates to:
  /// **'Highest Run Evolution'**
  String get highestRunEvolution;

  /// No description provided for @outcomeRatio.
  ///
  /// In en, this message translates to:
  /// **'Win/Loss/Draw Ratio'**
  String get outcomeRatio;

  /// No description provided for @allSeasons.
  ///
  /// In en, this message translates to:
  /// **'All Seasons'**
  String get allSeasons;

  /// No description provided for @performanceTrend.
  ///
  /// In en, this message translates to:
  /// **'Performance Trend'**
  String get performanceTrend;

  /// No description provided for @improving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get improving;

  /// No description provided for @declining.
  ///
  /// In en, this message translates to:
  /// **'Declining'**
  String get declining;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @tapToViewResults.
  ///
  /// In en, this message translates to:
  /// **'Tap any graph to view results'**
  String get tapToViewResults;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @matchNumber.
  ///
  /// In en, this message translates to:
  /// **'Match #{number}'**
  String matchNumber(int number);

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String percentage(String percent);

  /// No description provided for @aboveTarget.
  ///
  /// In en, this message translates to:
  /// **'Above Target'**
  String get aboveTarget;

  /// No description provided for @belowTarget.
  ///
  /// In en, this message translates to:
  /// **'Below Target'**
  String get belowTarget;

  /// No description provided for @withinTarget.
  ///
  /// In en, this message translates to:
  /// **'Within Target'**
  String get withinTarget;

  /// No description provided for @resultList.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultList;

  /// No description provided for @filterResults.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get filterResults;

  /// No description provided for @filterByCompetition.
  ///
  /// In en, this message translates to:
  /// **'Filter by Competition'**
  String get filterByCompetition;

  /// No description provided for @filterByAdversary.
  ///
  /// In en, this message translates to:
  /// **'Filter by Adversary'**
  String get filterByAdversary;

  /// No description provided for @allCompetitions.
  ///
  /// In en, this message translates to:
  /// **'All Competitions'**
  String get allCompetitions;

  /// No description provided for @allAdversaries.
  ///
  /// In en, this message translates to:
  /// **'All Adversaries'**
  String get allAdversaries;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @noMatchingResults.
  ///
  /// In en, this message translates to:
  /// **'No results match the selected filters'**
  String get noMatchingResults;

  /// No description provided for @deleteResult.
  ///
  /// In en, this message translates to:
  /// **'Delete Result'**
  String get deleteResult;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this result? This action cannot be undone.'**
  String get confirmDeleteMessage;

  /// No description provided for @resultUpdated.
  ///
  /// In en, this message translates to:
  /// **'Result updated'**
  String get resultUpdated;

  /// No description provided for @autoBackupEnabled.
  ///
  /// In en, this message translates to:
  /// **'Auto-Backup Enabled'**
  String get autoBackupEnabled;

  /// No description provided for @autoBackupEnabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically backup your data to the cloud'**
  String get autoBackupEnabledDescription;

  /// No description provided for @autoBackupFrequency.
  ///
  /// In en, this message translates to:
  /// **'Auto-Backup Frequency'**
  String get autoBackupFrequency;

  /// No description provided for @autoBackupResultCount.
  ///
  /// In en, this message translates to:
  /// **'Backup After Results'**
  String get autoBackupResultCount;

  /// No description provided for @backupAfter.
  ///
  /// In en, this message translates to:
  /// **'Backup after'**
  String get backupAfter;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @afterResults.
  ///
  /// In en, this message translates to:
  /// **'After Results'**
  String get afterResults;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @numberOfResults.
  ///
  /// In en, this message translates to:
  /// **'Number of Results'**
  String get numberOfResults;
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
