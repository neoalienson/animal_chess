// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get animalChess => 'Tier Schach';

  @override
  String get appDescription =>
      'Eine Flutter-Implementierung des klassischen chinesischen Brettspiels Tier Schach (Dou Shou Qi).';

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get gameInstructions => 'Spielanleitung';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get about => 'Über';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get gameRules => 'Spielregeln';

  @override
  String get gameVariants => 'Spielvarianten';

  @override
  String get resetGame => 'Spiel zurücksetzen';

  @override
  String get greenPlayer => 'Grüner Spieler';

  @override
  String get redPlayer => 'Roter Spieler';

  @override
  String gameOverWins(Object player) {
    return 'Spiel vorbei! $player gewinnt!';
  }

  @override
  String get gameOverDraw => 'Spiel vorbei! Unentschieden!';

  @override
  String turn(Object player) {
    return '$player ist am Zug';
  }

  @override
  String get gameRule1 =>
      'Jeder Spieler befehligt 8 Tiere mit unterschiedlichen Rängen.';

  @override
  String get gameRule2 =>
      'Ziel: Eine Figur in die Höhle des Gegners bewegen oder alle gegnerischen Figuren schlagen.';

  @override
  String get gameRule3 =>
      'Figuren bewegen sich ein Feld orthogonal (hoch, runter, links oder rechts).';

  @override
  String get gameRule4 => 'Nur die Ratte darf den Fluss betreten.';

  @override
  String get gameRule5 => 'Löwe und Tiger können über beide Flüsse springen.';

  @override
  String get gameRule6 =>
      'Figuren in Fallen können von jeder gegnerischen Figur geschlagen werden.';

  @override
  String get gameRule7 =>
      'Eine Figur kann eine gegnerische Figur schlagen, wenn sie gleich oder niedriger im Rang ist.';

  @override
  String get gameRule8 =>
      'Ausnahme: Ratte kann Elefant schlagen, und Elefant kann Ratte schlagen.';

  @override
  String get close => 'Schließen';

  @override
  String get ratOnlyDenEntry => 'Nur Ratten dürfen den Bau betreten';

  @override
  String get extendedLionTigerJumps => 'Erweiterte Löwen-/Tiger-Sprünge';

  @override
  String get dogRiverVariant => 'Hund-Fluss-Variante';

  @override
  String get ratCannotCaptureElephant => 'Ratte kann Elefant nicht schlagen';

  @override
  String get variantRatOnlyDenEntry =>
      'Nur die Ratte darf den Bau des Gegners betreten, um zu gewinnen';

  @override
  String get variantExtendedLionTigerJumps =>
      'Erweiterte Löwen-/Tiger-Sprünge:';

  @override
  String get variantLionJumpBothRivers =>
      'Löwe kann über beide Flüsse springen';

  @override
  String get variantTigerJumpSingleRiver =>
      'Tiger kann über einen einzelnen Fluss springen';

  @override
  String get variantLeopardCrossRivers =>
      'Leopard kann Flüsse horizontal überqueren';

  @override
  String get variantDogRiver => 'Hund-Fluss-Variante:';

  @override
  String get variantDogEnterRiver => 'Hund kann den Fluss betreten.';

  @override
  String get variantDogCaptureFromRiver =>
      'Nur der Hund kann Figuren am Ufer vom Fluss aus schlagen';

  @override
  String get piecesRank => 'Figuren-Rang';
}
