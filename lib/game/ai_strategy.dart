import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/game/ai_move.dart';
import 'package:animal_chess/game/game_actions.dart';
import 'package:animal_chess/game/board_evaluator.dart';
import 'package:animal_chess/game/game_rules.dart';
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
          BoardEvaluator(
            gameRules: gameActions.gameRules,
            config: config,
            safetyWeight: 1.0,
            denProximityWeight: 1.2,
            pieceValueWeight: 0.9,
            threatWeight: 0.7,
          );

  /// Create a BoardEvaluator with weights based on the AI strategy
  static BoardEvaluator _createEvaluator(
    AIStrategyType strategy,
    GameRules rules,
    GameConfig config,
  ) {
    switch (strategy) {
      case AIStrategyType.offensive:
        return BoardEvaluator(
          gameRules: rules,
          config: config,
          safetyWeight: 0.3,
          denProximityWeight: 1.5,
          pieceValueWeight: 1.2,
          threatWeight: 1.0,
        );
      case AIStrategyType.balanced:
        return BoardEvaluator(
          gameRules: rules,
          config: config,
          safetyWeight: 0.7,
          denProximityWeight: 1.2,
          pieceValueWeight: 0.9,
          threatWeight: 1.0,
        );
      case AIStrategyType.exploratory:
        return BoardEvaluator(
          gameRules: rules,
          config: config,
          safetyWeight: 0.5,
          denProximityWeight: 2.0,
          pieceValueWeight: 0.9,
          threatWeight: 0.8,
        );
      default: // defensive
        return BoardEvaluator(
          gameRules: rules,
          config: config,
          safetyWeight: 1.0,
          denProximityWeight: 1.2,
          pieceValueWeight: 0.9,
          threatWeight: 0.7,
        );
    }
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

  /// Get the AI strategy for a specific player
  AIStrategyType _getStrategyForPlayer(PlayerColor player) {
    switch (player) {
      case PlayerColor.green:
        return config.aiGreenStrategy;
      case PlayerColor.red:
        return config.aiRedStrategy;
    }
  }

  /// Calculate the best move with 2-ply lookahead
  Move? calculateBestMove(
    GameBoard board,
    PlayerColor player,
    GameActions gameActions,
  ) {
    // Create evaluator based on player's strategy
    final strategy = _getStrategyForPlayer(player);
    final evaluator = _createEvaluator(strategy, gameActions.gameRules, config);

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
        final outcomeScore = evaluator.evaluateBoardState(oppBoard, player);
        if (outcomeScore < worstOutcome) {
          worstOutcome = outcomeScore;
        }
      }

      // Use worst-case outcome as move score
      final moveScore = worstOutcome == double.infinity
          ? evaluator.evaluateBoardState(tempBoard, player)
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
