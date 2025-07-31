// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get animalChess => 'Animal Chess';

  @override
  String get appDescription =>
      'A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).';

  @override
  String get newGame => 'New Game';

  @override
  String get gameInstructions => 'Game Instructions';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get gameRules => 'Game Rules';

  @override
  String get gameVariants => 'Game Variants';

  @override
  String get resetGame => 'Reset Game';

  @override
  String get greenPlayer => 'Green Player';

  @override
  String get redPlayer => 'Red Player';

  @override
  String gameOverWins(Object player) {
    return 'Game Over! $player wins!';
  }

  @override
  String get gameOverDraw => 'Game Over! It\'s a draw!';

  @override
  String turn(Object player) {
    return '$player\'s turn';
  }

  @override
  String get gameRule1 =>
      'Each player commands 8 animals with different ranks.';

  @override
  String get gameRule2 =>
      'Objective: Move any piece into opponent\'s den or capture all opponent pieces.';

  @override
  String get gameRule3 =>
      'Pieces move one space orthogonally (up, down, left, or right).';

  @override
  String get gameRule4 => 'Only the Rat can enter the river.';

  @override
  String get gameRule5 => 'Lion and Tiger can jump over rivers.';

  @override
  String get gameRule6 =>
      'Pieces in traps can be captured by any opponent piece.';

  @override
  String get gameRule7 =>
      'A piece can capture an opponent\'s piece if it is of equal or lower rank.';

  @override
  String get gameRule8 =>
      'Exception: Rat can capture Elephant, and Elephant can capture Rat.';

  @override
  String get close => 'Close';

  @override
  String get ratOnlyDenEntry => 'Rat-Only Den Entry';

  @override
  String get extendedLionTigerJumps => 'Extended Lion/Tiger Jumps';

  @override
  String get dogRiverVariant => 'Dog River Variant';

  @override
  String get ratCannotCaptureElephant => 'Rat cannot capture Elephant';

  @override
  String get variantRatOnlyDenEntry =>
      'Only the Rat can enter the opponent\'s den to win';

  @override
  String get variantExtendedLionTigerJumps => 'Extended Lion/Tiger Jumps:';

  @override
  String get variantLionJumpBothRivers => 'Lion can jump over both rivers';

  @override
  String get variantTigerJumpSingleRiver =>
      'Tiger can jump over a single river';

  @override
  String get variantLeopardCrossRivers =>
      'Leopard can cross rivers horizontally';

  @override
  String get variantDogRiver => 'Dog River Variant:';

  @override
  String get variantDogEnterRiver => 'Dog can enter the river';

  @override
  String get variantDogCaptureFromRiver =>
      'Only the Dog can capture pieces on the shore from within the river';

  @override
  String get piecesRank => 'Pieces Rank';
}
