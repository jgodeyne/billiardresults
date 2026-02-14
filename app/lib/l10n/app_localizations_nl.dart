// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Biljart Resultaten';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get results => 'Resultaten';

  @override
  String get settings => 'Instellingen';

  @override
  String get onboardingWelcome => 'Welkom bij Biljart Resultaten!';

  @override
  String get onboardingSubtitle => 'Laten we je profiel instellen';

  @override
  String get nameLabel => 'Je Naam';

  @override
  String get nameHint => 'Voer je naam in';

  @override
  String get nameError => 'Voer je naam in';

  @override
  String get seasonStartLabel => 'Seizoen Startdatum';

  @override
  String get seasonStartHint => 'Selecteer dag en maand';

  @override
  String get seasonStartError => 'Selecteer een seizoen startdatum';

  @override
  String get getStarted => 'Aan de slag';

  @override
  String get save => 'Opslaan';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get editProfile => 'Profiel Bewerken';

  @override
  String get languageLabel => 'Taal';

  @override
  String get english => 'Engels';

  @override
  String get dutch => 'Nederlands';

  @override
  String get french => 'Frans';

  @override
  String get classificationLevels => 'Classificatieniveaus';

  @override
  String get classificationLevelsSubtitle =>
      'Stel doelgemiddelden in per discipline';

  @override
  String get noDisciplines =>
      'Nog geen disciplines. Voeg resultaten toe om classificatieniveaus in te stellen.';

  @override
  String get minimumAverage => 'Minimum Gemiddelde';

  @override
  String get maximumAverage => 'Maximum Gemiddelde';

  @override
  String get averageRange => 'Gemiddelde Bereik';

  @override
  String get notSet => 'Niet ingesteld';

  @override
  String get dataManagement => 'Gegevensbeheer';

  @override
  String get deleteAllData => 'Alle Gegevens Verwijderen';

  @override
  String get deleteAllDataConfirmTitle => 'Alle Gegevens Verwijderen?';

  @override
  String get deleteAllDataConfirmMessage =>
      'Dit zal permanent al je resultaten, classificatieniveaus en instellingen verwijderen. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get deleteClassificationTitle => 'Classificatie Verwijderen?';

  @override
  String deleteClassificationMessage(String discipline) {
    return 'Classificatieniveau verwijderen voor $discipline?';
  }

  @override
  String get dataDeleted => 'Alle gegevens zijn verwijderd';

  @override
  String get settingsSaved => 'Instellingen succesvol opgeslagen';

  @override
  String get classificationSaved => 'Classificatieniveau opgeslagen';

  @override
  String get classificationDeleted => 'Classificatieniveau verwijderd';

  @override
  String get errorSavingSettings => 'Fout bij opslaan instellingen';

  @override
  String get errorLoadingSettings => 'Fout bij laden instellingen';

  @override
  String get january => 'Januari';

  @override
  String get february => 'Februari';

  @override
  String get march => 'Maart';

  @override
  String get april => 'April';

  @override
  String get may => 'Mei';

  @override
  String get june => 'Juni';

  @override
  String get july => 'Juli';

  @override
  String get august => 'Augustus';

  @override
  String get september => 'September';

  @override
  String get october => 'Oktober';

  @override
  String get november => 'November';

  @override
  String get december => 'December';
}
