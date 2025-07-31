// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get animalChess => 'Échecs Animaux';

  @override
  String get appDescription =>
      'Une implémentation Flutter du jeu de société chinois classique Animal Chess (Dou Shou Qi).';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get gameInstructions => 'Instructions du jeu';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get about => 'À propos';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get cancel => 'Annuler';

  @override
  String get gameRules => 'Règles du jeu';

  @override
  String get gameVariants => 'Variantes du jeu';

  @override
  String get resetGame => 'Réinitialiser le jeu';

  @override
  String get greenPlayer => 'Joueur Vert';

  @override
  String get redPlayer => 'Joueur Rouge';

  @override
  String gameOverWins(Object player) {
    return 'Partie terminée ! $player gagne !';
  }

  @override
  String get gameOverDraw => 'Partie terminée ! Match nul !';

  @override
  String turn(Object player) {
    return 'Tour de $player';
  }

  @override
  String get gameRule1 =>
      'Chaque joueur commande 8 animaux de rangs différents.';

  @override
  String get gameRule2 =>
      'Objectif: Déplacer une pièce dans le repaire de l\'adversaire ou capturer toutes les pièces adverses.';

  @override
  String get gameRule3 =>
      'Les pièces se déplacent d\'une case orthogonalement (haut, bas, gauche ou droite).';

  @override
  String get gameRule4 => 'Seul le Rat peut entrer dans la rivière.';

  @override
  String get gameRule5 =>
      'Le Lion et le Tigre peuvent sauter par-dessus les rivières.';

  @override
  String get gameRule6 =>
      'Les pièces dans les pièges peuvent être capturées par n\'importe quelle pièce adverse.';

  @override
  String get gameRule7 =>
      'Une pièce peut capturer une pièce adverse si elle est de rang égal ou inférieur.';

  @override
  String get gameRule8 =>
      'Exception: Le rat peut capturer l\'éléphant, et l\'éléphant peut capturer le rat.';

  @override
  String get close => 'Fermer';

  @override
  String get ratOnlyDenEntry => 'Entrée de la tanière réservée aux rats';

  @override
  String get extendedLionTigerJumps => 'Sauts étendus Lion/Tigre';

  @override
  String get dogRiverVariant => 'Variante de la rivière du chien';

  @override
  String get ratCannotCaptureElephant =>
      'Le rat ne peut pas capturer l\'éléphant';

  @override
  String get variantRatOnlyDenEntry =>
      'Seul le Rat peut entrer dans la tanière de l\'adversaire pour gagner';

  @override
  String get variantExtendedLionTigerJumps => 'Sauts étendus Lion/Tigre:';

  @override
  String get variantLionJumpBothRivers =>
      'Le Lion peut sauter par-dessus les deux rivières';

  @override
  String get variantTigerJumpSingleRiver =>
      'Le Tigre peut sauter par-dessus une seule rivière';

  @override
  String get variantLeopardCrossRivers =>
      'Le Léopard peut traverser les rivières horizontalement';

  @override
  String get variantDogRiver => 'Variante de la rivière du chien:';

  @override
  String get variantDogEnterRiver => 'Le Chien peut entrer dans la rivière.';

  @override
  String get variantDogCaptureFromRiver =>
      'Seul le Chien peut capturer des pièces sur le rivage depuis la rivière';

  @override
  String get piecesRank => 'Rang des pièces';
}
