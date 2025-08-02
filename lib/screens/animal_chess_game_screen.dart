import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';
import 'package:animal_chess/widgets/pieces_rank_list_widget.dart';
import 'package:animal_chess/widgets/game_rules_dialog_widget.dart';
import 'package:animal_chess/widgets/debug_menu_widget.dart';
import 'package:animal_chess/widgets/player_indicator_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/constants/ui_constants.dart';

import 'package:animal_chess/core/service_locator.dart';

class AnimalChessGameScreen extends StatefulWidget {
  const AnimalChessGameScreen({super.key});

  @override
  State<AnimalChessGameScreen> createState() => _AnimalChessGameScreenState();
}

class _AnimalChessGameScreenState extends State<AnimalChessGameScreen> {
  late final GameController _gameController;
  List<Position> _validMoves = [];
  late ConfettiController _confettiController;
  bool _hasShownVictoryDialog = false;

  @override
  void initState() {
    super.initState();
    _gameController = locator<GameController>();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.animalChess),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: localizations.resetGame,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'rules',
                  child: Text(localizations.gameRules),
                ),
                if (kDebugMode)
                  PopupMenuItem<String>(
                    value: 'debug',
                    child: const Text('Debug Menu'),
                  ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: _gameController.currentPlayer == PlayerColor.green
            ? UIConstants.darkGreenPieceColor
            : UIConstants.darkRedPieceColor,
        child: Column(
          children: [
            // Player indicators
            _buildPlayerIndicators(),

            // Game board and captured pieces
            Expanded(
              child: Row(
                children: [
                  // Game board
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          UIConstants.defaultPadding,
                        ),
                        child: AspectRatio(
                          aspectRatio: 7 / 9, // Maintain board aspect ratio
                          child: GameBoardWidget(
                            gameController: _gameController,
                            onPositionTap: _handlePositionTap,
                            validMoves: _validMoves,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Game status
            _buildGameStatus(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context).piecesRank,
        child: const Icon(Icons.list),
        onPressed: _showPiecesRank,
      ),
    );
  }

  /// Show pieces rank dialog
  void _showPiecesRank() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).piecesRank),
          content: SizedBox(
            height: 400, // Fixed height to prevent layout issues
            width: 300, // Fixed width for consistent dialog
            child: const PiecesRankListWidget(),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context).close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Build player indicators showing whose turn it is
  Widget _buildPlayerIndicators() {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: PlayerIndicatorWidget(
              player: PlayerColor.green,
              label: localizations.greenPlayer,
              isActive: _gameController.currentPlayer == PlayerColor.green,
            ),
          ),
          const SizedBox(width: UIConstants.smallPadding * 1.25),
          Flexible(
            child: PlayerIndicatorWidget(
              player: PlayerColor.red,
              label: localizations.redPlayer,
              isActive: _gameController.currentPlayer == PlayerColor.red,
            ),
          ),
        ],
      ),
    );
  }

  /// Build game status display (winner or current player)
  Widget _buildGameStatus() {
    final localizations = AppLocalizations.of(context);

    String statusText;
    Color statusColor;

    if (_gameController.gameEnded) {
      if (_gameController.winner != null) {
        String winner = _gameController.winner == PlayerColor.green
            ? localizations.greenPlayer
            : localizations.redPlayer;
        statusText = localizations.gameOverWins(winner);
        statusColor = _gameController.winner == PlayerColor.green
            ? UIConstants.greenPieceColor
            : UIConstants.redPieceColor;
      } else {
        statusText = localizations.gameOverDraw;
        statusColor = Colors.grey;
      }
    } else {
      String currentPlayer = _gameController.currentPlayer == PlayerColor.green
          ? localizations.greenPlayer
          : localizations.redPlayer;
      statusText = localizations.turn(currentPlayer);
      statusColor = _gameController.currentPlayer == PlayerColor.green
          ? UIConstants.greenPieceColor
          : UIConstants.redPieceColor;
    }

    return Container(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: UIConstants.statusFontSize,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  /// Handle tap on a board position
  void _handlePositionTap(Position position) {
    setState(() {
      // If game is over, ignore taps
      if (_gameController.gameEnded) return;

      // If a piece is already selected, try to move it
      if (_gameController.selectedPosition != null) {
        bool moved = _gameController.movePiece(position);
        if (moved) {
          _validMoves = [];
          if (_gameController.gameEnded && !_hasShownVictoryDialog) {
            _showVictoryDialog();
          }
        } else {
          // If move failed, check if we're selecting a different piece
          bool selected = _gameController.selectPiece(position);
          if (selected) {
            _validMoves = _gameController.getValidMoves(position);
            if (_gameController.gameEnded && !_hasShownVictoryDialog) {
              _showVictoryDialog();
            }
          } else {
            _validMoves = [];
          }
        }
      }
      // If no piece is selected, try to select this piece
      else {
        bool selected = _gameController.selectPiece(position);
        if (selected) {
          _validMoves = _gameController.getValidMoves(position);
        }
      }
    });
  }

  /// Reset the game
  void _resetGame() {
    setState(() {
      _gameController.resetGame();
      _validMoves = [];
      _hasShownVictoryDialog = false;
    });
  }

  /// Handle menu selections
  void _handleMenuSelection(String value) {
    if (value == 'rules') {
      _showRulesDialog();
    } else if (value == 'debug') {
      _showDebugMenu();
    }
  }

  /// Show rules dialog
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const GameRulesDialogWidget();
      },
    );
  }

  /// Show debug menu with testing options
  void _showDebugMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugMenuWidget(
          gameController: _gameController,
          onClose: () {
            Navigator.pop(context);
            _showVictoryDialog();
          },
        );
      },
    );
  }

  /// Show victory dialog with confetti
  void _showVictoryDialog() {
    _hasShownVictoryDialog = true;
    _confettiController.play();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context);
        String winner = _gameController.winner == PlayerColor.green
            ? localizations.greenPlayer
            : localizations.redPlayer;

        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(UIConstants.defaultPadding),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.gameOverWins(winner),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    emissionFrequency: 0.01,
                    numberOfParticles: 50,
                    gravity: 0.1,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: Text(localizations.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _confettiController.stop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
