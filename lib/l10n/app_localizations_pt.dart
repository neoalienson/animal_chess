// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get animalChess => 'Xadrez Animal';

  @override
  String get appDescription =>
      'Uma implementação Flutter do clássico jogo de tabuleiro chinês Xadrez Animal (Dou Shou Qi).';

  @override
  String get newGame => 'Novo Jogo';

  @override
  String get gameInstructions => 'Instruções do Jogo';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get about => 'Sobre';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get cancel => 'Cancelar';

  @override
  String get gameRules => 'Regras do Jogo';

  @override
  String get gameVariants => 'Variantes do Jogo';

  @override
  String get resetGame => 'Reiniciar Jogo';

  @override
  String get greenPlayer => 'Jogador Verde';

  @override
  String get redPlayer => 'Jogador Vermelho';

  @override
  String gameOverWins(Object player) {
    return 'Fim de jogo! $player vence!';
  }

  @override
  String get gameOverDraw => 'Fim de jogo! É um empate!';

  @override
  String turn(Object player) {
    return 'Vez de $player';
  }

  @override
  String get gameRule1 =>
      'Cada jogador comanda 8 animais com diferentes patentes.';

  @override
  String get gameRule2 =>
      'Objetivo: Mover qualquer peça para a toca do oponente ou capturar todas as peças do oponente.';

  @override
  String get gameRule3 =>
      'As peças movem-se uma casa ortogonalmente (para cima, para baixo, para a esquerda ou para a direita).';

  @override
  String get gameRule4 => 'Apenas o Rato pode entrar no rio.';

  @override
  String get gameRule5 => 'O Leão e o Tigre podem saltar sobre ambos os rios.';

  @override
  String get gameRule6 =>
      'Peças em armadilhas podem ser capturadas por qualquer peça adversária.';

  @override
  String get gameRule7 =>
      'Uma peça pode capturar uma peça do oponente se for de patente igual ou inferior.';

  @override
  String get gameRule8 =>
      'Exceção: O Rato pode capturar o Elefante, e o Elefante pode capturar o Rato.';

  @override
  String get close => 'Fechar';

  @override
  String get ratOnlyDenEntry => 'Entrada da toca apenas para Rato';

  @override
  String get extendedLionTigerJumps => 'Saltos Estendidos de Leão/Tigre';

  @override
  String get dogRiverVariant => 'Variante do Rio Cão';

  @override
  String get ratCannotCaptureElephant => 'Rato não pode capturar Elefante';

  @override
  String get variantRatOnlyDenEntry =>
      'Apenas o Rato pode entrar na toca do oponente para vencer';

  @override
  String get variantExtendedLionTigerJumps =>
      'Saltos Estendidos de Leão/Tigre:';

  @override
  String get variantLionJumpBothRivers =>
      'O Leão pode saltar sobre ambos os rios';

  @override
  String get variantTigerJumpSingleRiver =>
      'O Tigre pode saltar sobre um único rio';

  @override
  String get variantLeopardCrossRivers =>
      'O Leopardo pode atravessar rios horizontalmente';

  @override
  String get variantDogRiver => 'Variante do Rio Cão:';

  @override
  String get variantDogEnterRiver => 'O Cão pode entrar no rio.';

  @override
  String get variantDogCaptureFromRiver =>
      'Apenas o Cão pode capturar peças na margem a partir do rio';

  @override
  String get piecesRank => 'Patente das peças';
}
