import 'package:flutter/material.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';
import 'package:animal_chess/widgets/pieces_rank_list_widget.dart';
import 'package:animal_chess/widgets/game_rules_dialog_widget.dart';
import 'package:animal_chess/widgets/variants_dialog_widget.dart';
import 'package:animal_chess/widgets/player_indicator_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/constants/ui_constants.dart';

import 'package:animal_chess/core/service_locator.dart';

class AnimalChessGameScreen extends StatefulWidget {
  const AnimalChessGameScreen({
    super.key,
  });

  @override
  State<AnimalChessGameScreen> createState() => _AnimalChessGameScreenState();
}

class _AnimalChessGameScreenState extends State<AnimalChessGameScreen> {
  late final GameController _gameController;
  List<Position> _validMoves = [];

  @override
  void initState() {
    super.initState();
    _gameController = locator<GameController>();
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
                PopupMenuItem<String>(
                  value: 'variants',
                  child: Text(localizations.gameVariants),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
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
                      padding: const EdgeInsets.all(UIConstants.defaultPadding),
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

                // Pieces Rank panel
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(UIConstants.smallPadding),
                        child: Text(
                          localizations.piecesRank,
                          style: const TextStyle(
                            fontSize: UIConstants.boardFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: _buildPiecesRankList()),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Game status
          _buildGameStatus(),
        ],
      ),
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
        } else {
          // If move failed, check if we're selecting a different piece
          bool selected = _gameController.selectPiece(position);
          if (selected) {
            _validMoves = _gameController.getValidMoves(position);
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
    });
  }

  /// Handle menu selections
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'rules':
        _showRulesDialog();
        break;
      case 'variants':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return VariantsDialogWidget();
          },
        );
        break;
    }
  }

  /// Build pieces rank list
  Widget _buildPiecesRankList() {
    return PiecesRankListWidget();
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
}
