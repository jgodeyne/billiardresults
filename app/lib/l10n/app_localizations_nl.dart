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
  String get importData => 'Importeren uit CSV';

  @override
  String get importDataDescription =>
      'Importeer resultaten uit een CSV-bestand geëxporteerd vanuit Numbers of Excel';

  @override
  String get selectCsvFile => 'Selecteer CSV-bestand';

  @override
  String get importPreview => 'Importvoorbeeld';

  @override
  String get importResults => 'Resultaten Importeren';

  @override
  String importSuccess(int count) {
    return '$count resultaten succesvol geïmporteerd';
  }

  @override
  String importErrors(int errorCount) {
    return 'Import voltooid met $errorCount fouten';
  }

  @override
  String get importFailed => 'Import mislukt';

  @override
  String get noFileSelected => 'Geen bestand geselecteerd';

  @override
  String get csvFormatHelp => 'CSV-formaathulp';

  @override
  String get csvFormatDescription =>
      'Uw CSV-bestand moet deze kolommen hebben:\n\nVerplicht:\n• Datum (JJJJ-MM-DD, DD/MM/JJJJ, of MM/DD/JJJJ)\n• Discipline\n• Punten\n• Beurten\n• Hoogste Serie\n\nOptioneel:\n• Tegenstander\n• Competitie\n• Uitslag (won/lost/draw)';

  @override
  String get downloadExample => 'Download Voorbeeld CSV';

  @override
  String importConfirmTitle(int count) {
    return '$count Resultaten Importeren?';
  }

  @override
  String importConfirmMessage(int count) {
    return 'Dit zal $count resultaten toevoegen aan uw database. Doorgaan?';
  }

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

  @override
  String get currentSeason => 'Huidig Seizoen';

  @override
  String get selectSeason => 'Selecteer Seizoen';

  @override
  String get noResultsYet => 'Nog geen resultaten';

  @override
  String get addFirstResult =>
      'Tik op de + knop om je eerste resultaat toe te voegen';

  @override
  String get noResultsThisSeason => 'Geen resultaten voor dit seizoen';

  @override
  String get totalPoints => 'Totaal Caramboles';

  @override
  String get totalInnings => 'Totaal Beurten';

  @override
  String get highestRun => 'Hoogste Serie';

  @override
  String get matches => 'Partijen';

  @override
  String get won => 'W';

  @override
  String get lost => 'V';

  @override
  String get draw => 'G';

  @override
  String get unknown => '?';

  @override
  String detailTitle(String discipline) {
    return '$discipline Details';
  }

  @override
  String get averageEvolution => 'Evolutie Gemiddelde';

  @override
  String get highestRunEvolution => 'Evolutie Hoogste Serie';

  @override
  String get outcomeRatio => 'Winst/Verlies/Gelijk Verhouding';

  @override
  String get allSeasons => 'Alle Seizoenen';

  @override
  String get performanceTrend => 'Prestatie Trend';

  @override
  String get improving => 'Verbeterend';

  @override
  String get declining => 'Dalend';

  @override
  String get stable => 'Stabiel';

  @override
  String get tapToViewResults => 'Tik op een grafiek om resultaten te bekijken';

  @override
  String get noDataAvailable => 'Geen gegevens beschikbaar';

  @override
  String matchNumber(int number) {
    return 'Partij #$number';
  }

  @override
  String percentage(String percent) {
    return '$percent%';
  }

  @override
  String get aboveTarget => 'Boven Doel';

  @override
  String get belowTarget => 'Onder Doel';

  @override
  String get withinTarget => 'Binnen Doel';

  @override
  String get resultList => 'Resultaten';

  @override
  String get filterResults => 'Filter Resultaten';

  @override
  String get filterByCompetition => 'Filter op Competitie';

  @override
  String get filterByAdversary => 'Filter op Tegenstander';

  @override
  String get allCompetitions => 'Alle Competities';

  @override
  String get allAdversaries => 'Alle Tegenstanders';

  @override
  String get applyFilters => 'Filters Toepassen';

  @override
  String get clearFilters => 'Filters Wissen';

  @override
  String get noMatchingResults =>
      'Geen resultaten komen overeen met de geselecteerde filters';

  @override
  String get deleteResult => 'Resultaat Verwijderen';

  @override
  String get confirmDelete => 'Verwijdering Bevestigen';

  @override
  String get confirmDeleteMessage =>
      'Weet u zeker dat u dit resultaat wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get resultUpdated => 'Resultaat bijgewerkt';
}
