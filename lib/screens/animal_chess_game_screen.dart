import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/widgets/victory_dialog_widget.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';
import 'package:animal_chess/widgets/game_info_dialog_widget.dart';
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
  late GameController _gameController;
  List<Position> _validMoves = [];
  late ConfettiController _confettiController;
  bool _hasShownVictoryDialog = false;
  PieceDisplayFormat _displayFormat = PieceDisplayFormat.traditionalChinese;

  @override
  void initState() {
    super.initState();
    _gameController = locator<GameController>();
    // Set up callback for game state changes
    _gameController.onGameStateChanged = () {
      // Use a delayed execution to allow UI to update
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            // This will trigger a rebuild of the UI
          });
        }
      });
    };
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Initialize display format from config
    _displayFormat = locator<GameConfig>().pieceDisplayFormat;

    // Check if AI should make the first move
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndExecuteAIMove();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    // Deactivate controller when screen is disposed
    _gameController.isActive = false;
    // Reset game state when returning to main menu
    _gameController.resetGame();
    // Clear UI state
    _validMoves = [];
    _hasShownVictoryDialog = false;
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
                            displayFormat: _displayFormat,
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
        tooltip: AppLocalizations.of(context).gameVariants,
        onPressed: _showGameInfo,
        child: const Icon(Icons.info),
      ),
    );
  }

  /// Show game info dialog with pieces rank and game variants
  void _showGameInfo() {
    final gameConfig = locator<GameConfig>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text(AppLocalizations.of(context).gameVariants),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                Expanded(
                  child: GameInfoDialogWidget(
                    displayFormat: _displayFormat,
                    gameConfig: gameConfig,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text(AppLocalizations.of(context).close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          } else {
            // Check if next player is AI after a short delay to allow UI update
            _checkAndExecuteAIMove();
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

      // Check if AI should make the first move in the new game
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndExecuteAIMove();
      });
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

  /// Check and execute AI move after a short delay
  void _checkAndExecuteAIMove() {
    // Use a delayed execution to allow UI to update
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_gameController.gameEnded) {
        _gameController.executeAIMoveIfNecessary();
      }
    });
  }

  /// Show victory dialog with confetti
  void _showVictoryDialog() {
    _hasShownVictoryDialog = true;
    _confettiController.play();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VictoryDialogWidget(
          winner: _gameController.winner,
          confettiController: _confettiController,
          onClose: () {
            Navigator.of(context).pop();
            _confettiController.stop();
          },
        );
      },
    );
  }
}
