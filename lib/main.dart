import 'package:flutter/material.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
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

  // Get localized string based on current language
  static String _getLocalizedString(
    String english,
    String chineseTraditional,
    String chineseSimplified,
    Language currentLanguage,
  ) {
    switch (currentLanguage) {
      case Language.english:
        return english;
      case Language.chineseTraditional:
        return chineseTraditional;
      case Language.chineseSimplified:
        return chineseSimplified;
    }
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
  // Game configuration
  GameConfig _gameConfig = GameConfig();

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
                Text(
                  _getLocalizedString('Animal Chess', '鬥獸棋', '斗兽棋', _currentLanguage),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 40),

                // Menu buttons
                IntrinsicWidth(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          _getLocalizedString('New Game', '新遊戲', '新游戏', _currentLanguage),
                          Icons.play_arrow,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimalChessGame(
                                  gameConfig: _gameConfig,
                                  currentLanguage: _currentLanguage,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          _getLocalizedString('Game Instructions', '遊戲說明', '游戏说明', _currentLanguage),
                          Icons.help,
                          () {
                            _showGameInstructions();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          _getLocalizedString('Settings', '設定', '设置', _currentLanguage),
                          Icons.settings,
                          () {
                            _showSettingsDialog();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton('Language', Icons.language, () {
                          _showLanguageSelection();
                        }),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          _getLocalizedString('About', '關於', '关于', _currentLanguage),
                          Icons.info,
                          () {
                            _showAboutDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ), // Larger padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36), // Larger icon
          const SizedBox(width: 10), // Space between icon and text
          Text(
            text,
            style: const TextStyle(fontSize: 24), // Larger text
            overflow: TextOverflow.visible, // Allow text to be fully visible
            softWrap: false, // Prevent text wrapping
          ),
        ],
      ),
    );
  }

  // Show game instructions
  void _showGameInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AnimalChessApp._getLocalizedString('Game Instructions', '遊戲規則', '游戏规则', _currentLanguage)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AnimalChessApp._getLocalizedString(
                    'Animal Chess is a strategic board game for two players.',
                    '鬥獸棋是兩人對弈的戰略棋盤遊戲。',
                    '斗兽棋是两人对弈的战略棋盘游戏。',
                    _currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '1. Each player commands 8 animals with different ranks.',
                    '1. 每位玩家指揮8隻不同等級的動物。',
                    '1. 每位玩家指挥8只不同等级的动物。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    "2. Objective: Move any piece into opponent's den or capture all opponent pieces.",
                    '2. 目標：將任何棋子移入對方獸穴或捕獲所有對方棋子。',
                    '2. 目标：将任何棋子移入对方兽穴或捕获所有对方棋子。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '3. Pieces move one space orthogonally (up, down, left, or right).',
                    '3. 棋子可向上、下、左、右移動一格。',
                    '3. 棋子可向上、下、左、右移动一格。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '4. Only the Rat can enter the river.',
                    '4. 只有老鼠可以進入河流。',
                    '4. 只有老鼠可以进入河流。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '5. Lion and Tiger can jump over rivers.',
                    '5. 獅子和老虎可以跳過河流。',
                    '5. 狮子和老虎可以跳过河流。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '6. Pieces in traps can be captured by any opponent piece.',
                    '6. 在陷阱中的棋子可被任何對手棋子捕獲。',
                    '6. 在陷阱中的棋子可被任何对手棋子捕获。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    "7. A piece can capture an opponent's piece if it is of equal or lower rank.",
                    '7. 棋子可以捕獲等級相同或較低的對手棋子。',
                    '7. 棋子可以捕获等级相同或较低的对手棋子。',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                    '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                    '8. 例外：老鼠可以捕获大象，大象可以捕获老鼠。',
                    _currentLanguage,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(AnimalChessApp._getLocalizedString('Close', '關閉', '关闭', _currentLanguage)),
            ),
          ],
        );
      },
    );
  }

  // Show settings dialog
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AnimalChessApp._getLocalizedString('Game Settings', '遊戲設定', '游戏设置', _currentLanguage)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildVariantToggle(
                    AnimalChessApp._getLocalizedString('Rat-Only Den Entry', '只有老鼠可以進入獸穴', '只有老鼠可以进入兽穴', _currentLanguage),
                    _gameConfig.ratOnlyDenEntry,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(ratOnlyDenEntry: value);
                      });
                    },
                  ),
                  _buildVariantToggle(
                    AnimalChessApp._getLocalizedString('Extended Lion/Tiger Jumps', '獅虎跳躍擴展', '狮虎跳跃扩展', _currentLanguage),
                    _gameConfig.extendedLionTigerJumps,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(extendedLionTigerJumps: value);
                      });
                    },
                  ),
                  _buildVariantToggle(
                    AnimalChessApp._getLocalizedString('Dog River Variant', '狗入河變體', '狗入河变体', _currentLanguage),
                    _gameConfig.dogRiverVariant,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(dogRiverVariant: value);
                      });
                    },
                  ),
                  _buildVariantToggle(
                    AnimalChessApp._getLocalizedString('Rat cannot capture Elephant', '老鼠不能捕獲大象', '老鼠不能捕获大象', _currentLanguage),
                    _gameConfig.ratCannotCaptureElephant,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(ratCannotCaptureElephant: value);
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Update the main menu state to reflect changes
                    this.setState(() {});
                  },
                  child: Text(AnimalChessApp._getLocalizedString('Close', '關閉', '关闭', _currentLanguage)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildVariantToggle(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  // Show language selection
  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AnimalChessApp._getLocalizedString('Select Language', '選擇語言', '选择语言', _currentLanguage)),
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
              child: Text(AnimalChessApp._getLocalizedString('Cancel', '取消', '取消', _currentLanguage)),
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
      applicationName: AnimalChessApp._getLocalizedString('Animal Chess', '鬥獸棋', '斗兽棋', _currentLanguage),
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.adb),
      applicationLegalese: '© 2025 Animal Chess',
      children: [
        Text(
          AnimalChessApp._getLocalizedString(
            'A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).',
            '經典中國棋盤遊戲鬥獸棋的Flutter實現。',
            '经典中国棋盘游戏斗兽棋的Flutter实现。',
            _currentLanguage,
          ),
        ),
      ],
    );
  }

  // Get localized string based on current language
  static String _getLocalizedString(
    String english,
    String chineseTraditional,
    String chineseSimplified,
    Language currentLanguage,
  ) {
    switch (currentLanguage) {
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
  final GameConfig gameConfig;
  final Language currentLanguage;

  const AnimalChessGame({super.key, required this.gameConfig, required this.currentLanguage});

  @override
  State<AnimalChessGame> createState() => _AnimalChessGameState();
}

class _AnimalChessGameState extends State<AnimalChessGame> {
  late final GameController _gameController;
  List<Position> _validMoves = [];

  @override
  void initState() {
    super.initState();
    _gameController = GameController(gameConfig: widget.gameConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AnimalChessApp._getLocalizedString('Animal Chess', '鬥獸棋', '斗兽棋', widget.currentLanguage)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: AnimalChessApp._getLocalizedString('Reset Game', '重置遊戲', '重置游戏', widget.currentLanguage),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'rules',
                  child: Text(AnimalChessApp._getLocalizedString('Game Rules', '遊戲規則', '游戏规则', widget.currentLanguage)),
                ),
                PopupMenuItem<String>(
                  value: 'variants',
                  child: Text(AnimalChessApp._getLocalizedString('Game Variants', '遊戲變體', '游戏变体', widget.currentLanguage)),
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
                      padding: const EdgeInsets.all(16.0),
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Pieces Rank',
                          style: TextStyle(
                            fontSize: 16,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerIndicator(
            PlayerColor.green,
            AnimalChessApp._getLocalizedString('Green Player', '綠方玩家', '绿方玩家', widget.currentLanguage),
            _gameController.currentPlayer == PlayerColor.green,
          ),
          _buildPlayerIndicator(
            PlayerColor.red,
            AnimalChessApp._getLocalizedString('Red Player', '紅方玩家', '红方玩家', widget.currentLanguage),
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
            ? AnimalChessApp._getLocalizedString('Green Player', '綠方玩家', '绿方玩家', widget.currentLanguage)
            : AnimalChessApp._getLocalizedString('Red Player', '紅方玩家', '红方玩家', widget.currentLanguage);
        statusText = AnimalChessApp._getLocalizedString(
            'Game Over! $winner wins!',
            '遊戲結束！$winner 獲勝！',
            '游戏结束！$winner 获胜！',
            widget.currentLanguage);
        statusColor = _gameController.winner == PlayerColor.green
            ? Colors.green
            : Colors.red;
      } else {
        statusText = AnimalChessApp._getLocalizedString('Game Over! It\'s a draw!', '遊戲結束！平局！', '游戏结束！平局！', widget.currentLanguage);
        statusColor = Colors.grey;
      }
    } else {
      String currentPlayer = _gameController.currentPlayer == PlayerColor.green
          ? AnimalChessApp._getLocalizedString('Green Player', '綠方玩家', '绿方玩家', widget.currentLanguage)
          : AnimalChessApp._getLocalizedString('Red Player', '紅方玩家', '红方玩家', widget.currentLanguage);
      statusText = AnimalChessApp._getLocalizedString(
          '$currentPlayer\'s turn',
          '$currentPlayer 的回合',
          '$currentPlayer 的回合',
          widget.currentLanguage);
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
          title: Text(AnimalChessApp._getLocalizedString('Game Rules', '遊戲規則', '游戏规则', widget.currentLanguage)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AnimalChessApp._getLocalizedString(
                    'Animal Chess is a strategic board game for two players.',
                    '鬥獸棋是兩人對弈的戰略棋盤遊戲。',
                    '斗兽棋是两人對弈的戰略棋盤遊戲。', widget.currentLanguage)),
                const SizedBox(height: 10),
                Text(AnimalChessApp._getLocalizedString(
                    '1. Each player commands 8 animals with different ranks.',
                    '1. 每位玩家指揮8隻不同等級的動物。',
                    '1. 每位玩家指挥8只不同等级的动物。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '2. Objective: Move any piece into opponent\'s den or capture all opponent pieces.',
                    '2. 目標：將任何棋子移入對方獸穴或捕獲所有對方棋子。',
                    '2. 目标：将任何棋子移入对方兽穴或捕获所有对方棋子。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '3. Pieces move one space orthogonally (up, down, left, or right).',
                    '3. 棋子可向上、下、左、右移動一格。',
                    '3. 棋子可向上、下、左、右移动一格。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '4. Only the Rat can enter the river.',
                    '4. 只有老鼠可以進入河流。',
                    '4. 只有老鼠可以进入河流。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '5. Lion and Tiger can jump over rivers.',
                    '5. 獅子和老虎可以跳過河流。',
                    '5. 狮子和老虎可以跳过河流。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '6. Pieces in traps can be captured by any opponent piece.',
                    '6. 在陷阱中的棋子可被任何對手棋子捕獲。',
                    '6. 在陷阱中的棋子可被任何对手棋子捕获。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '7. A piece can capture an opponent\'s piece if it is of equal or lower rank.',
                    '7. 棋子可以捕獲等級相同或較低的對手棋子。',
                    '7. 棋子可以捕获等级相同或较低的对手棋子。', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                    '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                    '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。', widget.currentLanguage)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(AnimalChessApp._getLocalizedString('Close', '關閉', '关闭', widget.currentLanguage)),
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
          title: Text(AnimalChessApp._getLocalizedString('Game Variants', '遊戲變體', '游戏变体', widget.currentLanguage)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AnimalChessApp._getLocalizedString(
                    '1. Rat-Only Den Entry: Only the Rat can enter the opponent\'s den to win',
                    '1. 只有老鼠可以進入獸穴：只有老鼠可以進入對手獸穴獲勝',
                    '1. 只有老鼠可以进入兽穴：只有老鼠可以进入对手兽穴获胜',
                    widget.currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(AnimalChessApp._getLocalizedString(
                    '2. Extended Lion/Tiger Jumps:',
                    '2. 獅虎跳躍擴展：',
                    '2. 狮虎跳跃扩展：', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '   - Lion can jump over both rivers',
                    '   - 獅子可以跳過兩條河流',
                    '   - 狮子可以跳过两条河流', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '   - Tiger can jump over a single river',
                    '   - 老虎可以跳過一條河流',
                    '   - 老虎可以跳过一条河流', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '   - Leopard can cross rivers horizontally',
                    '   - 豹可以橫向過河',
                    '   - 豹可以横向过河', widget.currentLanguage)),
                const SizedBox(height: 10),
                Text(AnimalChessApp._getLocalizedString(
                    '3. Dog River Variant:',
                    '3. 狗入河變體：',
                    '3. 狗入河变体：', widget.currentLanguage)),
                Text(AnimalChessApp._getLocalizedString(
                    '   - Dog can enter the river',
                    '   - 狗可以進入河流',
                    '   - 狗可以进入河流', widget.currentLanguage)),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '   - Only the Dog can capture pieces on the shore from within the river',
                    '   - 只有狗可以在河中捕獲岸上的棋子',
                    '   - 只有狗可以在河中捕获岸上的棋子',
                    widget.currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(AnimalChessApp._getLocalizedString(
                    '4. Rat cannot capture Elephant',
                    '4. 老鼠不能捕獲大象',
                    '4. 老鼠不能捕获大象', widget.currentLanguage)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(AnimalChessApp._getLocalizedString('Close', '關閉', '关闭', widget.currentLanguage)),
            ),
          ],
        );
      },
    );
  }

  /// Build pieces rank list
  Widget _buildPiecesRankList() {
    // Create a list of all animal types sorted by rank (strongest to weakest)
    final animalTypes = List<AnimalType>.from(AnimalType.values);
    animalTypes.sort((a, b) => a.rank.compareTo(b.rank));

    return ListView.builder(
      itemCount: animalTypes.length,
      itemBuilder: (context, index) {
        final animalType = animalTypes[index];
        return ListTile(
          leading: PieceWidget(
            piece: Piece(
              animalType,
              PlayerColor.red,
            ), // Show red pieces as example
            isSelected: false,
            size: 30,
            isRankDisplay: true,
          ),
          title: Text(animalType.name, style: const TextStyle(fontSize: 12)),
        );
      },
    );
  }
}
