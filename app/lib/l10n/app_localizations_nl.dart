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

  @override
  String get addResult => 'Resultaat Toevoegen';

  @override
  String get editResult => 'Resultaat Bewerken';

  @override
  String get disciplineLabel => 'Discipline';

  @override
  String get disciplineHint => 'Selecteer of voer discipline in';

  @override
  String get disciplineError => 'Voer een discipline in';

  @override
  String get dateLabel => 'Datum';

  @override
  String get dateHint => 'Selecteer datum';

  @override
  String get pointsMadeLabel => 'Caramboles';

  @override
  String get pointsMadeHint => 'Voer caramboles in';

  @override
  String get pointsMadeError => 'Caramboles moet 0 of hoger zijn';

  @override
  String get inningsLabel => 'Aantal Beurten';

  @override
  String get inningsHint => 'Voer aantal beurten in';

  @override
  String get inningsError => 'Beurten moet groter zijn dan 0';

  @override
  String get highestRunLabel => 'Hoogste Serie';

  @override
  String get highestRunHint => 'Voer hoogste serie in';

  @override
  String get highestRunError =>
      'Hoogste serie moet tussen 0 en caramboles liggen';

  @override
  String get adversaryLabel => 'Tegenstander (Optioneel)';

  @override
  String get adversaryHint => 'Voer naam tegenstander in';

  @override
  String get outcomeLabel => 'Wedstrijduitslag (Optioneel)';

  @override
  String get outcomeWon => 'Gewonnen';

  @override
  String get outcomeLost => 'Verloren';

  @override
  String get outcomeDraw => 'Gelijk';

  @override
  String get outcomeUnknown => 'Onbekend';

  @override
  String get competitionLabel => 'Competitie (Optioneel)';

  @override
  String get competitionHint => 'Voer competitie naam in';

  @override
  String get resultSaved => 'Resultaat succesvol opgeslagen';

  @override
  String get resultDeleted => 'Resultaat verwijderd';

  @override
  String get errorSavingResult => 'Fout bij opslaan resultaat';

  @override
  String get deleteResultTitle => 'Resultaat Verwijderen?';

  @override
  String get deleteResultMessage =>
      'Dit zal dit resultaat permanent verwijderen.';

  @override
  String warningHighPoints(int limit) {
    return 'Waarschuwing: Caramboles waarde lijkt hoog (>$limit). Controleer a.u.b.';
  }

  @override
  String warningHighInnings(int limit) {
    return 'Waarschuwing: Beurten waarde lijkt hoog (>$limit). Controleer a.u.b.';
  }

  @override
  String warningHighRun(int limit) {
    return 'Waarschuwing: Hoogste serie lijkt hoog (>$limit). Controleer a.u.b.';
  }

  @override
  String get requiredFields => 'Verplichte velden';

  @override
  String get optionalFields => 'Optionele velden';

  @override
  String get average => 'Gemiddelde';

  @override
  String get disciplineFreeSmall => 'Vrij spel - Klein biljart';

  @override
  String get disciplineFreeMatch => 'Vrij spel - Match biljart';

  @override
  String get discipline1CushionSmall => '1-band - Klein biljart';

  @override
  String get discipline1CushionMatch => '1-band - Match biljart';

  @override
  String get discipline3CushionSmall => '3-banden - Klein biljart';

  @override
  String get discipline3CushionMatch => '3-banden - Match biljart';

  @override
  String get disciplineBalkline382Small => 'Kader 38/2 - Klein biljart';

  @override
  String get disciplineBalkline572Small => 'Kader 57/2 - Klein biljart';

  @override
  String get disciplineBalkline472Match => 'Kader 47/2 - Match biljart';

  @override
  String get disciplineBalkline471Match => 'Kader 47/1 - Match biljart';

  @override
  String get disciplineBalkline712Match => 'Kader 71/2 - Match biljart';
}
