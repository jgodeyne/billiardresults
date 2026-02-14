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
}
