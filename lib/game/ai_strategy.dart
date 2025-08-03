import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/ai_move.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/game/board_evaluator.dart';
import 'dart:collection';

class AIStrategy {
  final GameConfig config;
  final GameActions gameActions;
  final BoardEvaluator boardEvaluator;
  final Set<String> _boardHistory = HashSet();
  static const int _maxHistory = 5;

  AIStrategy(this.config, this.gameActions, [BoardEvaluator? boardEvaluator])
    : boardEvaluator =
          boardEvaluator ??
          BoardEvaluator(gameRules: gameActions.gameRules, config: config);

  /// Check if a piece can capture a target piece
  bool _canCapture(Piece attacker, Piece? target) {
    if (target == null) return false;
    if (target.playerColor == attacker.playerColor) return false;
    return attacker.canCapture(target);
  }

  /// Check if move would create a repeated position
  bool _isRepetition(GameBoard board, Move move) {
    final tempBoard = board.copy();
    final tempActions = GameActions(
      board: tempBoard,
      gameConfig: config,
      gameRules: gameActions.gameRules,
    );
    tempActions.movePiece(move.from, move.to);
    return _boardHistory.contains(_boardHash(tempBoard));
  }

  /// Get all valid moves for the current player
  List<Move> _getAllValidMoves(
    GameBoard board,
    PlayerColor player,
    GameActions gameActions,
  ) {
    final moves = <Move>[];
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        if (piece?.playerColor == player) {
          final validTargets = gameActions.getValidMoves(pos, player);
          for (final target in validTargets) {
            moves.add(Move(from: pos, to: target));
          }
        }
      }
    }
    return moves;
  }

  /// Calculate the best move with 2-ply lookahead
  Move? calculateBestMove(
    GameBoard board,
    PlayerColor player,
    GameActions gameActions,
  ) {
    final validMoves = _getAllValidMoves(board, player, gameActions);
    if (validMoves.isEmpty) return null;

    Move bestMove = validMoves[0];
    double bestScore = -double.infinity;

    for (final move in validMoves) {
      // Skip moves that create repeated positions
      if (_isRepetition(board, move)) continue;

      // Simulate our move
      final tempBoard = board.copy();
      final tempActions = gameActions.copyWithBoard(tempBoard);
      tempActions.movePiece(move.from, move.to);

      // Find opponent's best response
      final opponent = player == PlayerColor.red
          ? PlayerColor.green
          : PlayerColor.red;
      final opponentMoves = _getAllValidMoves(tempBoard, opponent, tempActions);

      double worstOutcome = double.infinity;
      for (final oppMove in opponentMoves) {
        // Simulate opponent's move
        final oppBoard = tempBoard.copy();
        final oppActions = tempActions.copyWithBoard(oppBoard);
        oppActions.movePiece(oppMove.from, oppMove.to);

        // Evaluate resulting position
        final outcomeScore = boardEvaluator.evaluateBoardState(
          oppBoard,
          player,
        );
        if (outcomeScore < worstOutcome) {
          worstOutcome = outcomeScore;
        }
      }

      // Use worst-case outcome as move score
      final moveScore = worstOutcome == double.infinity
          ? boardEvaluator.evaluateBoardState(tempBoard, player)
          : worstOutcome;

      if (moveScore > bestScore) {
        bestScore = moveScore;
        bestMove = move;
      }
    }

    // Track board history
    _boardHistory.add(_boardHash(board));
    if (_boardHistory.length > _maxHistory) {
      _boardHistory.remove(_boardHistory.first);
    }

    return bestMove;
  }

  /// Generate unique board state hash
  String _boardHash(GameBoard board) {
    final buffer = StringBuffer();
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 9; row++) {
        final pos = Position(col, row);
        final piece = board.getPiece(pos);
        buffer.write('${piece?.playerColor ?? ''}${piece?.animalType ?? ''}');
      }
    }
    return buffer.toString();
  }
}
