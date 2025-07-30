import 'package:flutter/material.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'dart:math';

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
      home: const MainMenuScreen(),
    );
  }
}

// Main menu screen
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  // Language options
  Language _currentLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with random pieces
          _buildBackgroundWithRandomPieces(),

          // Main menu content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Animal Chess\n鬥獸棋',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 40),

                // Menu buttons
                _buildMenuButton('New Game', Icons.play_arrow, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnimalChessGame(),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                _buildMenuButton('Game Instructions', Icons.help, () {
                  _showGameInstructions();
                }),
                const SizedBox(height: 20),

                _buildMenuButton('Language', Icons.language, () {
                  _showLanguageSelection();
                }),
                const SizedBox(height: 20),

                _buildMenuButton('About', Icons.info, () {
                  _showAboutDialog();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build background with random pieces
  Widget _buildBackgroundWithRandomPieces() {
    return Container(
      color: Colors.amber[50],
      child: Stack(
        children: List.generate(15, (index) {
          final random = Random();
          final animalTypes = AnimalType.values;
          final animalType = animalTypes[random.nextInt(animalTypes.length)];
          final playerColors = PlayerColor.values;
          final playerColor = playerColors[random.nextInt(playerColors.length)];

          return Positioned(
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            top: random.nextDouble() * MediaQuery.of(context).size.height,
            child: Transform.rotate(
              angle: random.nextDouble() * 2 * pi,
              child: PieceWidget(
                piece: Piece(animalType, playerColor),
                isSelected: false,
                size:
                    30 +
                    random.nextDouble() * 30, // Random size between 30 and 60
              ),
            ),
          );
        }),
      ),
    );
  }

  // Build a menu button
  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  // Show game instructions
  void _showGameInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getLocalizedString('Game Instructions', '遊戲規則', '游戏规则')),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedString(
                    'Animal Chess is a strategic board game for two players.',
                    '鬥獸棋是兩人對弈的戰略棋盤遊戲。',
                    '斗兽棋是两人对弈的战略棋盘游戏。',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getLocalizedString(
                    '1. Each player commands 8 animals with different ranks.',
                    '1. 每位玩家指揮8隻不同等級的動物。',
                    '1. 每位玩家指挥8只不同等级的动物。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '2. Objective: Move any piece into opponent\'s den or capture all opponent pieces.',
                    '2. 目標：將任何棋子移入對方獸穴或.capture所有對方棋子。',
                    '2. 目标：将任何棋子移入对方兽穴或.capture所有对方棋子。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '3. Pieces move one space orthogonally (up, down, left, or right).',
                    '3. 棋子可向上、下、左、右移動一格。',
                    '3. 棋子可向上、下、左、右移动一格。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '4. Only the Rat can enter the river.',
                    '4. 只有老鼠可以進入河流。',
                    '4. 只有老鼠可以进入河流。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '5. Lion and Tiger can jump over rivers.',
                    '5. 獅子和老虎可以跳過河流。',
                    '5. 狮子和老虎可以跳过河流。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '6. Pieces in traps can be captured by any opponent piece.',
                    '6. 在陷阱中的棋子可被任何對手棋子.capture。',
                    '6. 在陷阱中的棋子可被任何对手棋子.capture。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '7. A piece can capture an opponent\'s piece if it is of equal or lower rank.',
                    '7. 棋子可以.capture等級相同或較低的對手棋子。',
                    '7. 棋子可以.capture等级相同或较低的对手棋子。',
                  ),
                ),
                Text(
                  _getLocalizedString(
                    '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                    '8. 例外：老鼠可以.capture大象，大象可以.capture老鼠。',
                    '8. 例外：老鼠可以.capture大象，大象可以.capture老鼠。',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(_getLocalizedString('Close', '關閉', '关闭')),
            ),
          ],
        );
      },
    );
  }

  // Show language selection
  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getLocalizedString('Select Language', '選擇語言', '选择语言')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(Language.english, 'English'),
              _buildLanguageOption(Language.chineseTraditional, '繁體中文'),
              _buildLanguageOption(Language.chineseSimplified, '简体中文'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(_getLocalizedString('Cancel', '取消', '取消')),
            ),
          ],
        );
      },
    );
  }

  // Build language option
  Widget _buildLanguageOption(Language language, String label) {
    return ListTile(
      title: Text(label),
      trailing: _currentLanguage == language ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() {
          _currentLanguage = language;
        });
        Navigator.of(context).pop();
      },
    );
  }

  // Show about dialog
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: _getLocalizedString('Animal Chess', '鬥獸棋', '斗兽棋'),
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.adb),
      applicationLegalese: '© 2025 Animal Chess',
      children: [
        Text(
          _getLocalizedString(
            'A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).',
            '經典中國棋盤遊戲鬥獸棋的Flutter實現。',
            '经典中国棋盘游戏斗兽棋的Flutter实现。',
          ),
        ),
      ],
    );
  }

  // Get localized string based on current language
  String _getLocalizedString(
    String english,
    String chineseTraditional,
    String chineseSimplified,
  ) {
    switch (_currentLanguage) {
      case Language.english:
        return english;
      case Language.chineseTraditional:
        return chineseTraditional;
      case Language.chineseSimplified:
        return chineseSimplified;
    }
  }
}

// Language enum
enum Language { english, chineseTraditional, chineseSimplified }

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
