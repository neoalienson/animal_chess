import 'package:flutter/material.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';

void main() {
  runApp(const AnimalChessApp());
}

class AnimalChessApp extends StatelessWidget {
  const AnimalChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Chess (Dou Shou Qi)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const AnimalChessGame(),
    );
  }
}

class AnimalChessGame extends StatefulWidget {
  const AnimalChessGame({super.key});

  @override
  State<AnimalChessGame> createState() => _AnimalChessGameState();
}

class _AnimalChessGameState extends State<AnimalChessGame> {
  final GameController _gameController = GameController();
  List<Position> _validMoves = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Chess (鬥獸棋)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reset Game',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'rules',
                  child: Text('Game Rules'),
                ),
                const PopupMenuItem<String>(
                  value: 'variants',
                  child: Text('Game Variants'),
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

          // Game board
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GameBoardWidget(
                gameController: _gameController,
                onPositionTap: _handlePositionTap,
                validMoves: _validMoves,
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerIndicator(
            PlayerColor.green,
            'Green Player',
            _gameController.currentPlayer == PlayerColor.green,
          ),
          _buildPlayerIndicator(
            PlayerColor.red,
            'Red Player',
            _gameController.currentPlayer == PlayerColor.red,
          ),
        ],
      ),
    );
  }

  /// Build a single player indicator
  Widget _buildPlayerIndicator(
    PlayerColor player,
    String label,
    bool isActive,
  ) {
    Color color = player == PlayerColor.green ? Colors.green : Colors.red;
    Color backgroundColor = isActive
        ? color.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Build game status display (winner or current player)
  Widget _buildGameStatus() {
    String statusText;
    Color statusColor;

    if (_gameController.gameEnded) {
      if (_gameController.winner != null) {
        String winner = _gameController.winner == PlayerColor.green
            ? 'Green Player'
            : 'Red Player';
        statusText = 'Game Over! $winner wins!';
        statusColor = _gameController.winner == PlayerColor.green
            ? Colors.green
            : Colors.red;
      } else {
        statusText = 'Game Over! It\'s a draw!';
        statusColor = Colors.grey;
      }
    } else {
      String currentPlayer = _gameController.currentPlayer == PlayerColor.green
          ? 'Green Player'
          : 'Red Player';
      statusText = '$currentPlayer\'s turn';
      statusColor = _gameController.currentPlayer == PlayerColor.green
          ? Colors.green
          : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
        textAlign: TextAlign.center,
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
        _showVariantsDialog();
        break;
    }
  }

  /// Show game rules dialog
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Rules'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Animal Chess is a strategic board game for two players.'),
                SizedBox(height: 10),
                Text('1. Each player commands 8 animals with different ranks.'),
                Text(
                  '2. Objective: Move any piece into opponent\'s den or capture all opponent pieces.',
                ),
                Text(
                  '3. Pieces move one space orthogonally (up, down, left, or right).',
                ),
                Text('4. Only the Rat can enter the river.'),
                Text('5. Lion and Tiger can jump over rivers.'),
                Text(
                  '6. Pieces in traps can be captured by any opponent piece.',
                ),
                Text(
                  '7. A piece can capture an opponent\'s piece if it is of equal or lower rank.',
                ),
                Text(
                  '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Show game variants dialog
  void _showVariantsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Variants'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Rat-Only Den Entry: Only the Rat can enter the opponent\'s den to win',
                ),
                SizedBox(height: 10),
                Text('2. Extended Lion/Tiger Jumps:'),
                Text('   - Lion can jump over both rivers'),
                Text('   - Tiger can jump over a single river'),
                Text('   - Leopard can cross rivers horizontally'),
                SizedBox(height: 10),
                Text('3. Dog River Variant:'),
                Text('   - Dog can enter the river'),
                Text(
                  '   - Only the Dog can capture pieces on the shore from within the river',
                ),
                SizedBox(height: 10),
                Text('4. Rat cannot capture Elephant'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
