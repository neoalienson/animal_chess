import 'package:flutter/material.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/widgets/pieces_rank_list_widget.dart';
import 'package:animal_chess/widgets/game_rules_dialog_widget.dart';
import 'package:animal_chess/widgets/about_dialog_widget.dart';
import 'package:animal_chess/widgets/variants_dialog_widget.dart';
import 'package:animal_chess/widgets/settings_dialog_widget.dart';
import 'package:animal_chess/widgets/player_indicator_widget.dart';
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
  static String getLocalizedString(
    String english,
    String chineseTraditional,
    String chineseSimplified,
    String japanese,
    String korean,
    String thai,
    String french,
    String spanish,
    String portuguese,
    String german,
    Language currentLanguage,
  ) {
    switch (currentLanguage) {
      case Language.english:
        return english;
      case Language.chineseTraditional:
        return chineseTraditional;
      case Language.chineseSimplified:
        return chineseSimplified;
      case Language.japanese:
        return japanese;
      case Language.korean:
        return korean;
      case Language.thai:
        return thai;
      case Language.french:
        return french;
      case Language.spanish:
        return spanish;
      case Language.portuguese:
        return portuguese;
      case Language.german:
        return german;
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
  Language _currentLanguage = Language.chineseTraditional;
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
                  getLocalizedString(
                    'Animal Chess',
                    '鬥獸棋',
                    '斗兽棋',
                    '動物チェス',
                    '동물 체스',
                    'หมากรุกสัตว์',
                    'Échecs Animaux',
                    'Ajedrez Animal',
                    'Xadrez Animal',
                    'Tier Schach',
                    _currentLanguage,
                  ),
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
                          getLocalizedString(
                            'New Game',
                            '新遊戲',
                            '新游戏',
                            '新しいゲーム',
                            '새 게임',
                            'เกมใหม่',
                            'Nouvelle partie',
                            'Nuevo juego',
                            'Novo Jogo',
                            'Neues Spiel',
                            _currentLanguage,
                          ),
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
                          getLocalizedString(
                            'Game Instructions',
                            '遊戲說明',
                            '游戏说明',
                            'ゲームの遊び方',
                            '게임 방법',
                            'คำแนะนำเกม',
                            'Instructions du jeu',
                            'Instrucciones del juego',
                            'Instruções do Jogo',
                            'Spielanleitung',
                            _currentLanguage,
                          ),
                          Icons.help,
                          () {
                            _showRulesDialog();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          getLocalizedString(
                            'Settings',
                            '設定',
                            '设置',
                            '設定',
                            '설정',
                            'การตั้งค่า',
                            'Paramètres',
                            'Configuración',
                            'Configurações',
                            'Einstellungen',
                            _currentLanguage,
                          ),
                          Icons.settings,
                          () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SettingsDialogWidget(
                                  currentLanguage: _currentLanguage,
                                  gameConfig: _gameConfig,
                                  onConfigChanged: (GameConfig newConfig) {
                                    setState(() {
                                      _gameConfig = newConfig;
                                    });
                                  },
                                );
                              },
                            );
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
                          getLocalizedString(
                            'About',
                            '關於',
                            '关于',
                            'について',
                            '정보',
                            'เกี่ยวกับ',
                            'À propos',
                            'Acerca de',
                            'Sobre',
                            'Über',
                            _currentLanguage,
                          ),
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

  Widget _buildVariantToggle(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
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
          title: Text(
            AnimalChessApp.getLocalizedString(
              'Select Language',
              '選擇語言',
              '选择语言',
              '言語選択',
              '언어 선택',
              'เลือกภาษา',
              'Sélectionner la langue',
              'Seleccionar idioma',
              'Selecionar Idioma',
              'Sprache auswählen',
              _currentLanguage,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(Language.english, 'English'),
              _buildLanguageOption(Language.chineseTraditional, '繁體中文'),
              _buildLanguageOption(Language.chineseSimplified, '简体中文'),
              _buildLanguageOption(Language.japanese, '日本語'),
              _buildLanguageOption(Language.korean, '한국어'),
              _buildLanguageOption(Language.thai, 'ไทย'),
              _buildLanguageOption(Language.french, 'Français'),
              _buildLanguageOption(Language.spanish, 'Español'),
              _buildLanguageOption(Language.portuguese, 'Português'),
              _buildLanguageOption(Language.german, 'Deutsch'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                AnimalChessApp.getLocalizedString(
                  'Cancel',
                  '取消',
                  '取消',
                  'キャンセル',
                  '취소',
                  'ยกเลิก',
                  'Annuler',
                  'Cancelar',
                  'Cancelar',
                  'Abbrechen',
                  _currentLanguage,
                ),
              ),
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

  // Show rules dialog
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameRulesDialogWidget(currentLanguage: _currentLanguage);
      },
    );
  }

  // Show about dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialogWidget(currentLanguage: _currentLanguage);
      },
    );
  }

  // Get localized string based on current language
  static String getLocalizedString(
    String english,
    String chineseTraditional,
    String chineseSimplified,
    String japanese,
    String korean,
    String thai,
    String french,
    String spanish,
    String portuguese,
    String german,
    Language currentLanguage,
  ) {
    switch (currentLanguage) {
      case Language.english:
        return english;
      case Language.chineseTraditional:
        return chineseTraditional;
      case Language.chineseSimplified:
        return chineseSimplified;
      case Language.japanese:
        return japanese;
      case Language.korean:
        return korean;
      case Language.thai:
        return thai;
      case Language.french:
        return french;
      case Language.spanish:
        return spanish;
      case Language.portuguese:
        return portuguese;
      case Language.german:
        return german;
    }
  }
}

// Language enum
enum Language {
  english,
  chineseTraditional,
  chineseSimplified,
  japanese,
  korean,
  thai,
  french,
  spanish,
  portuguese,
  german,
}

class AnimalChessGame extends StatefulWidget {
  final GameConfig gameConfig;
  final Language currentLanguage;

  const AnimalChessGame({
    super.key,
    required this.gameConfig,
    required this.currentLanguage,
  });

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
        title: Text(
          AnimalChessApp.getLocalizedString(
            'Animal Chess',
            '鬥獸棋',
            '斗兽棋',
            '動物チェス',
            '동물 체스',
            'หมากรุกสัตว์',
            'Échecs Animaux',
            'Ajedrez Animal',
            'Xadrez Animal',
            'Tier Schach',
            widget.currentLanguage,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: AnimalChessApp.getLocalizedString(
              'Reset Game',
              '重置遊戲',
              '重置游戏',
              'ゲームをリセット',
              '게임 재설정',
              'รีเซ็ตเกม',
              'Réinitialiser le jeu',
              'Reiniciar juego',
              'Reiniciar Jogo',
              'Spiel zurücksetzen',
              widget.currentLanguage,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'rules',
                  child: Text(
                    AnimalChessApp.getLocalizedString(
                      'Game Rules',
                      '遊戲規則',
                      '游戏规则',
                      'ゲームルール',
                      '게임 규칙',
                      'กฎของเกม',
                      'Règles du jeu',
                      'Reglas del juego',
                      'Regras do Jogo',
                      'Spielregeln',
                      widget.currentLanguage,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'variants',
                  child: Text(
                    AnimalChessApp.getLocalizedString(
                      'Game Variants',
                      '遊戲變體',
                      '游戏变体',
                      'ゲームバリアント',
                      '게임 변형',
                      'รูปแบบเกม',
                      'Variantes du jeu',
                      'Variantes del juego',
                      'Variantes do Jogo',
                      'Spielvarianten',
                      widget.currentLanguage,
                    ),
                  ),
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
          PlayerIndicatorWidget(
            player: PlayerColor.green,
            label: AnimalChessApp.getLocalizedString(
              'Green Player',
              '綠方玩家',
              '绿方玩家',
              '緑のプレイヤー',
              '녹색 플레이어',
              'ผู้เล่นสีเขียว',
              'Joueur Vert',
              'Jugador Verde',
              'Jogador Verde',
              'Grüner Spieler',
              widget.currentLanguage,
            ),
            isActive: _gameController.currentPlayer == PlayerColor.green,
            currentLanguage: widget.currentLanguage,
          ),
          PlayerIndicatorWidget(
            player: PlayerColor.red,
            label: AnimalChessApp.getLocalizedString(
              'Red Player',
              '紅方玩家',
              '红方玩家',
              '赤のプレイヤー',
              '빨간색 플레이어',
              'ผู้เล่นสีแดง',
              'Joueur Rouge',
              'Jugador Rojo',
              'Jogador Vermelho',
              'Roter Spieler',
              widget.currentLanguage,
            ),
            isActive: _gameController.currentPlayer == PlayerColor.red,
            currentLanguage: widget.currentLanguage,
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
            ? AnimalChessApp.getLocalizedString(
                'Green Player',
                '綠方玩家',
                '绿方玩家',
                '緑のプレイヤー',
                '녹색 플레이어',
                'ผู้เล่นสีเขียว',
                'Joueur Vert',
                'Jugador Verde',
                'Jogador Verde',
                'Grüner Spieler',
                widget.currentLanguage,
              )
            : AnimalChessApp.getLocalizedString(
                'Red Player',
                '紅方玩家',
                '红方玩家',
                '赤のプレイヤー',
                '빨간색 플레이어',
                'ผู้เล่นสีแดง',
                'Joueur Rouge',
                'Jugador Rojo',
                'Jogador Vermelho',
                'Roter Spieler',
                widget.currentLanguage,
              );
        statusText = AnimalChessApp.getLocalizedString(
          'Game Over! $winner wins!',
          '遊戲結束！$winner 獲勝！',
          '游戏结束！$winner 获胜！',
          'ゲームオーバー！$winnerの勝ち！',
          '게임 종료! $winner 승리!',
          'จบเกม! $winner ชนะ!',
          'Partie terminée ! $winner gagne !',
          '¡Juego terminado! ¡$winner gana!',
          'Fim de jogo! $winner vence!',
          'Spiel vorbei! $winner gewinnt!',
          widget.currentLanguage,
        );
        statusColor = _gameController.winner == PlayerColor.green
            ? Colors.green
            : Colors.red;
      } else {
        statusText = AnimalChessApp.getLocalizedString(
          'Game Over! It\'s a draw!',
          '遊戲結束！平局！',
          '游戏结束！平局！',
          'ゲームオーバー！引き分け！',
          '게임 종료! 무승부!',
          'จบเกม! เสมอ!',
          'Partie terminée ! Match nul !',
          '¡Juego terminado! ¡Es un empate!',
          'Fim de jogo! É um empate!',
          'Spiel vorbei! Unentschieden!',
          widget.currentLanguage,
        );
        statusColor = Colors.grey;
      }
    } else {
      String currentPlayer = _gameController.currentPlayer == PlayerColor.green
          ? AnimalChessApp.getLocalizedString(
              'Green Player',
              '綠方玩家',
              '绿方玩家',
              '緑のプレイヤー',
              '녹색 플레이어',
              'ผู้เล่นสีเขียว',
              'Joueur Vert',
              'Jugador Verde',
              'Jogador Verde',
              'Grüner Spieler',
              widget.currentLanguage,
            )
          : AnimalChessApp.getLocalizedString(
              'Red Player',
              '紅方玩家',
              '红方玩家',
              '赤のプレイヤー',
              '빨간색 플레이어',
              'ผู้เล่นสีแดง',
              'Joueur Rouge',
              'Jugador Rojo',
              'Jogador Vermelho',
              'Roter Spieler',
              widget.currentLanguage,
            );
      statusText = AnimalChessApp.getLocalizedString(
        '$currentPlayer' + '\'s turn',
        '$currentPlayer 的回合',
        '$currentPlayer 的回合',
        '$currentPlayer のターン',
        '$currentPlayer의 차례',
        'ตาของ $currentPlayer',
        'Tour de $currentPlayer',
        'Turno de $currentPlayer',
        'Vez de $currentPlayer',
        '$currentPlayer ist am Zug',
        widget.currentLanguage,
      );
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return VariantsDialogWidget(
              currentLanguage: widget.currentLanguage,
              gameConfig: widget.gameConfig,
              onConfigChanged: (GameConfig newConfig) {},
            );
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
        return GameRulesDialogWidget(currentLanguage: widget.currentLanguage);
      },
    );
  }
}
