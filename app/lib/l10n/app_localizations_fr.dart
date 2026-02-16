// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Résultats de Billard';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get results => 'Résultats';

  @override
  String get settings => 'Paramètres';

  @override
  String get onboardingWelcome => 'Bienvenue dans Résultats de Billard!';

  @override
  String get onboardingSubtitle => 'Configurons votre profil';

  @override
  String get nameLabel => 'Votre Nom';

  @override
  String get nameHint => 'Entrez votre nom';

  @override
  String get nameError => 'Veuillez entrer votre nom';

  @override
  String get seasonStartLabel => 'Date de Début de Saison';

  @override
  String get seasonStartHint => 'Sélectionnez le jour et le mois';

  @override
  String get seasonStartError =>
      'Veuillez sélectionner une date de début de saison';

  @override
  String get getStarted => 'Commencer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get editProfile => 'Modifier le Profil';

  @override
  String get languageLabel => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get dutch => 'Néerlandais';

  @override
  String get french => 'Français';

  @override
  String get classificationLevels => 'Niveaux de Classification';

  @override
  String get classificationLevelsSubtitle =>
      'Définir les plages de moyenne cible par discipline';

  @override
  String get noDisciplines =>
      'Aucune discipline pour le moment. Ajoutez des résultats pour définir les niveaux de classification.';

  @override
  String get minimumAverage => 'Moyenne Minimale';

  @override
  String get maximumAverage => 'Moyenne Maximale';

  @override
  String get averageRange => 'Plage de Moyenne';

  @override
  String get notSet => 'Non défini';

  @override
  String get dataManagement => 'Gestion des Données';

  @override
  String get importData => 'Importer depuis CSV';

  @override
  String get importDataDescription =>
      'Importez les résultats depuis un fichier CSV exporté depuis Numbers ou Excel';

  @override
  String get selectCsvFile => 'Sélectionner le Fichier CSV';

  @override
  String get importPreview => 'Aperçu de l\'Importation';

  @override
  String get importResults => 'Importer les Résultats';

  @override
  String importSuccess(int count) {
    return '$count résultats importés avec succès';
  }

  @override
  String importErrors(int errorCount) {
    return 'Importation terminée avec $errorCount erreurs';
  }

  @override
  String get importFailed => 'Échec de l\'importation';

  @override
  String get noFileSelected => 'Aucun fichier sélectionné';

  @override
  String get csvFormatHelp => 'Aide sur le Format CSV';

  @override
  String get csvFormatDescription =>
      'Votre fichier CSV doit avoir ces colonnes:\n\nObligatoire:\n• Date (AAAA-MM-JJ, JJ/MM/AAAA, ou MM/JJ/AAAA)\n• Discipline\n• Points\n• Manches\n• Série la Plus Élevée\n\nOptionnel:\n• Adversaire\n• Compétition\n• Résultat (won/lost/draw)';

  @override
  String get downloadExample => 'Télécharger Exemple CSV';

  @override
  String importConfirmTitle(int count) {
    return 'Importer $count Résultats?';
  }

  @override
  String importConfirmMessage(int count) {
    return 'Cela ajoutera $count résultats à votre base de données. Continuer?';
  }

  @override
  String get cloudBackup => 'Sauvegarde Cloud';

  @override
  String get backupToCloud => 'Sauvegarder vers le Cloud';

  @override
  String get restoreFromCloud => 'Restaurer depuis le Cloud';

  @override
  String get backupToICloud => 'Sauvegardez vos données vers iCloud Drive';

  @override
  String get backupToGoogleDrive => 'Sauvegardez vos données vers Google Drive';

  @override
  String get restoreFromICloud => 'Restaurez vos données depuis iCloud Drive';

  @override
  String get restoreFromGoogleDrive =>
      'Restaurez vos données depuis Google Drive';

  @override
  String get lastBackup => 'Dernière Sauvegarde';

  @override
  String get never => 'Jamais';

  @override
  String get backingUp => 'Sauvegarde en cours...';

  @override
  String get restoring => 'Restauration en cours...';

  @override
  String get backupSuccessful => 'Sauvegarde réussie';

  @override
  String get backupFailed => 'Échec de la sauvegarde';

  @override
  String get restoreSuccessful => 'Restauration réussie';

  @override
  String get restoreFailed => 'Échec de la restauration';

  @override
  String get noBackupFound => 'Aucune sauvegarde trouvée dans le cloud';

  @override
  String get restoreConfirmTitle => 'Restaurer depuis le Cloud?';

  @override
  String get restoreConfirmMessage =>
      'Cela remplacera toutes vos données actuelles par la sauvegarde. Cette action ne peut pas être annulée. Continuer?';

  @override
  String get signInToGoogle => 'Se connecter à Google';

  @override
  String signedInAs(String email) {
    return 'Connecté en tant que $email';
  }

  @override
  String get signOut => 'Se Déconnecter';

  @override
  String get deleteAllData => 'Supprimer Toutes les Données';

  @override
  String get deleteAllDataConfirmTitle => 'Supprimer Toutes les Données?';

  @override
  String get deleteAllDataConfirmMessage =>
      'Cela supprimera définitivement tous vos résultats, niveaux de classification et paramètres. Cette action ne peut pas être annulée.';

  @override
  String get deleteClassificationTitle => 'Supprimer la Classification?';

  @override
  String deleteClassificationMessage(String discipline) {
    return 'Supprimer le niveau de classification pour $discipline?';
  }

  @override
  String get dataDeleted => 'Toutes les données ont été supprimées';

  @override
  String get settingsSaved => 'Paramètres enregistrés avec succès';

  @override
  String get classificationSaved => 'Niveau de classification enregistré';

  @override
  String get classificationDeleted => 'Niveau de classification supprimé';

  @override
  String get errorSavingSettings =>
      'Erreur lors de l\'enregistrement des paramètres';

  @override
  String get errorLoadingSettings => 'Erreur lors du chargement des paramètres';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Février';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';

  @override
  String get addResult => 'Ajouter Résultat';

  @override
  String get editResult => 'Éditer le Résultat';

  @override
  String get disciplineLabel => 'Discipline';

  @override
  String get disciplineHint => 'Sélectionner ou entrer discipline';

  @override
  String get disciplineError => 'Veuillez entrer une discipline';

  @override
  String get dateLabel => 'Date';

  @override
  String get dateHint => 'Sélectionner la date';

  @override
  String get pointsMadeLabel => 'Points Marqués';

  @override
  String get pointsMadeHint => 'Entrez les points marqués';

  @override
  String get pointsMadeError => 'Les points doivent être 0 ou plus';

  @override
  String get inningsLabel => 'Nombre de Reprises';

  @override
  String get inningsHint => 'Entrez le nombre de reprises';

  @override
  String get inningsError => 'Les reprises doivent être supérieures à 0';

  @override
  String get highestRunLabel => 'Série Maximum';

  @override
  String get highestRunHint => 'Entrez la série maximum';

  @override
  String get highestRunError =>
      'La série maximum doit être entre 0 et les points marqués';

  @override
  String get adversaryLabel => 'Adversaire (Optionnel)';

  @override
  String get adversaryHint => 'Entrez le nom de l\'adversaire';

  @override
  String get outcomeLabel => 'Résultat du Match (Optionnel)';

  @override
  String get outcomeWon => 'Gagné';

  @override
  String get outcomeLost => 'Perdu';

  @override
  String get outcomeDraw => 'Nul';

  @override
  String get outcomeUnknown => 'Inconnu';

  @override
  String get competitionLabel => 'Compétition (Optionnelle)';

  @override
  String get competitionHint => 'Entrez le nom de la compétition';

  @override
  String get resultSaved => 'Résultat enregistré avec succès';

  @override
  String get resultDeleted => 'Résultat supprimé';

  @override
  String get errorSavingResult =>
      'Erreur lors de l\'enregistrement du résultat';

  @override
  String get deleteResultTitle => 'Supprimer le Résultat?';

  @override
  String get deleteResultMessage =>
      'Cela supprimera définitivement ce résultat.';

  @override
  String warningHighPoints(int limit) {
    return 'Attention: Valeur de points semble élevée (>$limit). Veuillez vérifier.';
  }

  @override
  String warningHighInnings(int limit) {
    return 'Attention: Valeur de reprises semble élevée (>$limit). Veuillez vérifier.';
  }

  @override
  String warningHighRun(int limit) {
    return 'Attention: Série maximum semble élevée (>$limit). Veuillez vérifier.';
  }

  @override
  String get requiredFields => 'Champs obligatoires';

  @override
  String get optionalFields => 'Champs optionnels';

  @override
  String get average => 'Moyenne';

  @override
  String get disciplineFreeSmall => 'Partie libre - Petite table';

  @override
  String get disciplineFreeMatch => 'Partie libre - Table de match';

  @override
  String get discipline1CushionSmall => '1 bande - Petite table';

  @override
  String get discipline1CushionMatch => '1 bande - Table de match';

  @override
  String get discipline3CushionSmall => '3 bandes - Petite table';

  @override
  String get discipline3CushionMatch => '3 bandes - Table de match';

  @override
  String get disciplineBalkline382Small => 'Cadre 38/2 - Petite table';

  @override
  String get disciplineBalkline572Small => 'Cadre 57/2 - Petite table';

  @override
  String get disciplineBalkline472Match => 'Cadre 47/2 - Table de match';

  @override
  String get disciplineBalkline471Match => 'Cadre 47/1 - Table de match';

  @override
  String get disciplineBalkline712Match => 'Cadre 71/2 - Table de match';

  @override
  String get currentSeason => 'Saison Actuelle';

  @override
  String get selectSeason => 'Sélectionner la Saison';

  @override
  String get noResultsYet => 'Aucun résultat pour l\'instant';

  @override
  String get addFirstResult =>
      'Appuyez sur le bouton + pour ajouter votre premier résultat';

  @override
  String get noResultsThisSeason => 'Aucun résultat pour cette saison';

  @override
  String get totalPoints => 'Points Totaux';

  @override
  String get totalInnings => 'Reprises Totales';

  @override
  String get highestRun => 'Série Maximum';

  @override
  String get matches => 'Parties';

  @override
  String get won => 'G';

  @override
  String get lost => 'P';

  @override
  String get draw => 'N';

  @override
  String get unknown => '?';

  @override
  String detailTitle(String discipline) {
    return '$discipline Détails';
  }

  @override
  String get averageEvolution => 'Évolution de la Moyenne';

  @override
  String get highestRunEvolution => 'Évolution de la Série Maximale';

  @override
  String get outcomeRatio => 'Ratio Victoire/Défaite/Égalité';

  @override
  String get allSeasons => 'Toutes les Saisons';

  @override
  String get performanceTrend => 'Tendance de Performance';

  @override
  String get improving => 'En Amélioration';

  @override
  String get declining => 'En Baisse';

  @override
  String get stable => 'Stable';

  @override
  String get tapToViewResults =>
      'Appuyez sur n\'importe quel graphique pour voir les résultats';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String matchNumber(int number) {
    return 'Partie #$number';
  }

  @override
  String percentage(String percent) {
    return '$percent%';
  }

  @override
  String get aboveTarget => 'Au-dessus de l\'Objectif';

  @override
  String get belowTarget => 'En-dessous de l\'Objectif';

  @override
  String get withinTarget => 'Dans l\'Objectif';

  @override
  String get resultList => 'Résultats';

  @override
  String get filterResults => 'Filtrer les Résultats';

  @override
  String get filterByCompetition => 'Filtrer par Compétition';

  @override
  String get filterByAdversary => 'Filtrer par Adversaire';

  @override
  String get allCompetitions => 'Toutes les Compétitions';

  @override
  String get allAdversaries => 'Tous les Adversaires';

  @override
  String get applyFilters => 'Appliquer les Filtres';

  @override
  String get clearFilters => 'Effacer les Filtres';

  @override
  String get noMatchingResults =>
      'Aucun résultat ne correspond aux filtres sélectionnés';

  @override
  String get deleteResult => 'Supprimer le Résultat';

  @override
  String get confirmDelete => 'Confirmer la Suppression';

  @override
  String get confirmDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer ce résultat? Cette action ne peut pas être annulée.';

  @override
  String get resultUpdated => 'Résultat mis à jour';
}
