// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get animalChess => 'Ajedrez Animal';

  @override
  String get appDescription =>
      'Una implementación en Flutter del clásico juego de mesa chino Ajedrez Animal (Dou Shou Qi).';

  @override
  String get newGame => 'Nuevo juego';

  @override
  String get gameInstructions => 'Instrucciones del juego';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get about => 'Acerca de';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get cancel => 'Cancelar';

  @override
  String get gameRules => 'Reglas del juego';

  @override
  String get gameVariants => 'Variantes del juego';

  @override
  String get resetGame => 'Reiniciar juego';

  @override
  String get greenPlayer => 'Jugador Verde';

  @override
  String get redPlayer => 'Jugador Rojo';

  @override
  String gameOverWins(Object player) {
    return '¡Juego terminado! ¡$player gana!';
  }

  @override
  String get gameOverDraw => '¡Juego terminado! ¡Es un empate!';

  @override
  String turn(Object player) {
    return 'Turno de $player';
  }

  @override
  String get gameRule1 =>
      'Cada jugador comanda 8 animales con diferentes rangos.';

  @override
  String get gameRule2 =>
      'Objetivo: Mover cualquier pieza al den del oponente o capturar todas las piezas del oponente.';

  @override
  String get gameRule3 =>
      'Las piezas se mueven una casilla ortogonalmente (arriba, abajo, izquierda o derecha).';

  @override
  String get gameRule4 => 'Solo la Rata puede entrar al río.';

  @override
  String get gameRule5 => 'El León y el Tigre pueden saltar sobre ambos ríos.';

  @override
  String get gameRule6 =>
      'Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.';

  @override
  String get gameRule7 =>
      'Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.';

  @override
  String get gameRule8 =>
      'Excepción: La rata puede capturar al elefante, y el elefante puede capturar a la rata.';

  @override
  String get close => 'Cerrar';

  @override
  String get ratOnlyDenEntry => 'Entrada a la guarida solo para ratas';

  @override
  String get extendedLionTigerJumps => 'Saltos extendidos de León/Tigre';

  @override
  String get dogRiverVariant => 'Variante del río Perro';

  @override
  String get ratCannotCaptureElephant =>
      'La rata no puede capturar al elefante';

  @override
  String get variantRatOnlyDenEntry =>
      'Solo la Rata puede entrar en la guarida del oponente para ganar';

  @override
  String get variantExtendedLionTigerJumps =>
      'Saltos extendidos de León/Tigre:';

  @override
  String get variantLionJumpBothRivers =>
      'El León puede saltar sobre ambos ríos';

  @override
  String get variantTigerJumpSingleRiver =>
      'El Tigre puede saltar sobre un solo río';

  @override
  String get variantLeopardCrossRivers =>
      'El Leopardo puede cruzar ríos horizontalmente';

  @override
  String get variantDogRiver => 'Variante del río Perro:';

  @override
  String get variantDogEnterRiver => 'El Perro puede entrar al río.';

  @override
  String get variantDogCaptureFromRiver =>
      'Solo el Perro puede capturar piezas en la orilla desde dentro del río';

  @override
  String get piecesRank => 'Rango de piezas';
}
