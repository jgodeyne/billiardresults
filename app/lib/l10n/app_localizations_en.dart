// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Billiard Results';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get results => 'Results';

  @override
  String get settings => 'Settings';

  @override
  String get onboardingWelcome => 'Welcome to Billiard Results!';

  @override
  String get onboardingSubtitle => 'Let\'s set up your profile';

  @override
  String get nameLabel => 'Your Name';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get nameError => 'Please enter your name';

  @override
  String get seasonStartLabel => 'Season Start Date';

  @override
  String get seasonStartHint => 'Select day and month';

  @override
  String get seasonStartError => 'Please select a season start date';

  @override
  String get getStarted => 'Get Started';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get languageLabel => 'Language';

  @override
  String get english => 'English';

  @override
  String get dutch => 'Dutch';

  @override
  String get french => 'French';

  @override
  String get classificationLevels => 'Classification Levels';

  @override
  String get classificationLevelsSubtitle =>
      'Set target average ranges per discipline';

  @override
  String get noDisciplines =>
      'No disciplines yet. Add results to set classification levels.';

  @override
  String get minimumAverage => 'Minimum Average';

  @override
  String get maximumAverage => 'Maximum Average';

  @override
  String get averageRange => 'Average Range';

  @override
  String get notSet => 'Not set';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get deleteAllDataConfirmTitle => 'Delete All Data?';

  @override
  String get deleteAllDataConfirmMessage =>
      'This will permanently delete all your results, classification levels, and settings. This action cannot be undone.';

  @override
  String get deleteClassificationTitle => 'Delete Classification?';

  @override
  String deleteClassificationMessage(String discipline) {
    return 'Remove classification level for $discipline?';
  }

  @override
  String get dataDeleted => 'All data has been deleted';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get classificationSaved => 'Classification level saved';

  @override
  String get classificationDeleted => 'Classification level deleted';

  @override
  String get errorSavingSettings => 'Error saving settings';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';
}
