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

  @override
  String get addResult => 'Add Result';

  @override
  String get editResult => 'Edit Result';

  @override
  String get disciplineLabel => 'Discipline';

  @override
  String get disciplineHint => 'Select or enter discipline';

  @override
  String get disciplineError => 'Please enter a discipline';

  @override
  String get dateLabel => 'Date';

  @override
  String get dateHint => 'Select date';

  @override
  String get pointsMadeLabel => 'Points Made';

  @override
  String get pointsMadeHint => 'Enter points made';

  @override
  String get pointsMadeError => 'Points must be 0 or greater';

  @override
  String get inningsLabel => 'Number of Innings';

  @override
  String get inningsHint => 'Enter number of innings';

  @override
  String get inningsError => 'Innings must be greater than 0';

  @override
  String get highestRunLabel => 'Highest Run';

  @override
  String get highestRunHint => 'Enter highest run';

  @override
  String get highestRunError => 'Highest run must be between 0 and points made';

  @override
  String get adversaryLabel => 'Adversary (Optional)';

  @override
  String get adversaryHint => 'Enter opponent name';

  @override
  String get outcomeLabel => 'Match Outcome (Optional)';

  @override
  String get outcomeWon => 'Won';

  @override
  String get outcomeLost => 'Lost';

  @override
  String get outcomeDraw => 'Draw';

  @override
  String get outcomeUnknown => 'Unknown';

  @override
  String get competitionLabel => 'Competition (Optional)';

  @override
  String get competitionHint => 'Enter competition name';

  @override
  String get resultSaved => 'Result saved successfully';

  @override
  String get resultDeleted => 'Result deleted';

  @override
  String get errorSavingResult => 'Error saving result';

  @override
  String get deleteResultTitle => 'Delete Result?';

  @override
  String get deleteResultMessage => 'This will permanently delete this result.';

  @override
  String warningHighPoints(int limit) {
    return 'Warning: Points value seems high (>$limit). Please verify.';
  }

  @override
  String warningHighInnings(int limit) {
    return 'Warning: Innings value seems high (>$limit). Please verify.';
  }

  @override
  String warningHighRun(int limit) {
    return 'Warning: Highest run seems high (>$limit). Please verify.';
  }

  @override
  String get requiredFields => 'Required fields';

  @override
  String get optionalFields => 'Optional fields';

  @override
  String get average => 'Average';

  @override
  String get disciplineFreeSmall => 'Free game - Small table';

  @override
  String get disciplineFreeMatch => 'Free game - Match table';

  @override
  String get discipline1CushionSmall => '1-cushion - Small table';

  @override
  String get discipline1CushionMatch => '1-cushion - Match table';

  @override
  String get discipline3CushionSmall => '3-cushion - Small table';

  @override
  String get discipline3CushionMatch => '3-cushion - Match table';

  @override
  String get disciplineBalkline382Small => 'Balkline 38/2 - Small table';

  @override
  String get disciplineBalkline572Small => 'Balkline 57/2 - Small table';

  @override
  String get disciplineBalkline472Match => 'Balkline 47/2 - Match table';

  @override
  String get disciplineBalkline471Match => 'Balkline 47/1 - Match table';

  @override
  String get disciplineBalkline712Match => 'Balkline 71/2 - Match table';

  @override
  String get currentSeason => 'Current Season';

  @override
  String get selectSeason => 'Select Season';

  @override
  String get noResultsYet => 'No results yet';

  @override
  String get addFirstResult => 'Tap the + button to add your first result';

  @override
  String get noResultsThisSeason => 'No results for this season';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get totalInnings => 'Total Innings';

  @override
  String get highestRun => 'Highest Run';

  @override
  String get matches => 'Matches';

  @override
  String get won => 'W';

  @override
  String get lost => 'L';

  @override
  String get draw => 'D';

  @override
  String get unknown => '?';

  @override
  String detailTitle(String discipline) {
    return '$discipline Details';
  }

  @override
  String get averageEvolution => 'Average Evolution';

  @override
  String get highestRunEvolution => 'Highest Run Evolution';

  @override
  String get outcomeRatio => 'Win/Loss/Draw Ratio';

  @override
  String get allSeasons => 'All Seasons';

  @override
  String get performanceTrend => 'Performance Trend';

  @override
  String get improving => 'Improving';

  @override
  String get declining => 'Declining';

  @override
  String get stable => 'Stable';

  @override
  String get tapToViewResults => 'Tap any graph to view results';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String matchNumber(int number) {
    return 'Match #$number';
  }

  @override
  String percentage(String percent) {
    return '$percent%';
  }

  @override
  String get aboveTarget => 'Above Target';

  @override
  String get belowTarget => 'Below Target';

  @override
  String get withinTarget => 'Within Target';

  @override
  String get resultList => 'Results';

  @override
  String get filterResults => 'Filter Results';

  @override
  String get filterByCompetition => 'Filter by Competition';

  @override
  String get filterByAdversary => 'Filter by Adversary';

  @override
  String get allCompetitions => 'All Competitions';

  @override
  String get allAdversaries => 'All Adversaries';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get noMatchingResults => 'No results match the selected filters';

  @override
  String get deleteResult => 'Delete Result';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this result? This action cannot be undone.';

  @override
  String get resultUpdated => 'Result updated';
}
