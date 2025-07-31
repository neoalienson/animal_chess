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

  // Show settings dialog
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AnimalChessApp.getLocalizedString(
                  'Game Settings',
                  '遊戲設定',
                  '游戏设置',
                  'ゲーム設定',
                  '게임 설정',
                  'การตั้งค่าเกม',
                  'Paramètres du jeu',
                  'Configuración del juego',
                  'Configurações do Jogo',
                  'Spieleinstellungen',
                  _currentLanguage,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildVariantToggle(
                    AnimalChessApp.getLocalizedString(
                      'Rat-Only Den Entry',
                      '只有老鼠可以進入獸穴',
                      '只有老鼠可以进入兽穴',
                      'ネズミのみの巣穴侵入',
                      '쥐만 굴에 들어갈 수 있음',
                      'หนูเท่านั้นที่เข้าถ้ำได้',
                      'Entrée de la tanière réservée aux rats',
                      'Entrada a la guarida solo para ratas',
                      'Entrada da toca apenas para Rato',
                      'Nur Ratten dürfen den Bau betreten',
                      _currentLanguage,
                    ),
                    _gameConfig.ratOnlyDenEntry,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(
                          ratOnlyDenEntry: value,
                        );
                      });
                    },
                  ),
                  _buildVariantToggle(
                    AnimalChessApp.getLocalizedString(
                      'Extended Lion/Tiger Jumps',
                      '獅虎跳躍擴展',
                      '狮虎跳跃扩展',
                      '拡張ライオン/トラのジャンプ',
                      '확장된 사자/호랑이 점프',
                      'การกระโดดของสิงโต/เสือที่ขยายออกไป',
                      'Sauts étendus Lion/Tigre',
                      'Saltos extendidos de León/Tigre',
                      'Saltos Estendidos de Leão/Tigre',
                      'Erweiterte Löwen-/Tiger-Sprünge',
                      _currentLanguage,
                    ),
                    _gameConfig.extendedLionTigerJumps,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(
                          extendedLionTigerJumps: value,
                        );
                      });
                    },
                  ),
                  _buildVariantToggle(
                    AnimalChessApp.getLocalizedString(
                      'Dog River Variant',
                      '狗入河變體',
                      '狗入河变体',
                      '犬の川のバリアント',
                      '개 강 변형',
                      'รูปแบบแม่น้ำสุนัข',
                      'Variante de la rivière du chien',
                      'Variante del río Perro',
                      'Variante do Rio Cão',
                      'Hund-Fluss-Variante',
                      _currentLanguage,
                    ),
                    _gameConfig.dogRiverVariant,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(
                          dogRiverVariant: value,
                        );
                      });
                    },
                  ),
                  _buildVariantToggle(
                    AnimalChessApp.getLocalizedString(
                      'Rat cannot capture Elephant',
                      '老鼠不能捕獲大象',
                      '老鼠不能捕获大象',
                      'ネズミはゾウを捕獲できません',
                      '쥐는 코끼리를 잡을 수 없습니다',
                      'หนูจับช้างไม่ได้',
                      'Le rat ne peut pas capturer l\'éléphant',
                      'La rata no puede capturar al elefante',
                      'Rato não pode capturar Elefante',
                      'Ratte kann Elefant nicht schlagen',
                      _currentLanguage,
                    ),
                    _gameConfig.ratCannotCaptureElephant,
                    (bool value) {
                      setState(() {
                        _gameConfig = _gameConfig.copyWith(
                          ratCannotCaptureElephant: value,
                        );
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
                  child: Text(
                    AnimalChessApp.getLocalizedString(
                      'Close',
                      '關閉',
                      '关闭',
                      '閉じる',
                      '닫기',
                      'ปิด',
                      'Fermer',
                      'Cerrar',
                      'Fechar',
                      'Schließen',
                      _currentLanguage,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
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
          _buildPlayerIndicator(
            PlayerColor.green,
            AnimalChessApp.getLocalizedString(
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
            _gameController.currentPlayer == PlayerColor.green,
          ),
          _buildPlayerIndicator(
            PlayerColor.red,
            AnimalChessApp.getLocalizedString(
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
        _showVariantsDialog();
        break;
    }
  }

  /// Show game variants dialog
  void _showVariantsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AnimalChessApp.getLocalizedString(
                    '1. Rat-Only Den Entry: Only the Rat can enter the opponent\'s den to win',
                    '1. 只有老鼠可以進入獸穴：只有老鼠可以進入對手獸穴獲勝',
                    '1. 只有老鼠可以进入兽穴：只有老鼠可以进入对手兽穴获胜',
                    '1. ネズミのみの巣穴侵入：ネズミだけが相手の巣穴に入って勝つことができます',
                    '1. 쥐만 굴에 들어갈 수 있음: 쥐만 상대방의 굴에 들어가 승리할 수 있습니다',
                    '1. หนูเท่านั้นที่เข้าถ้ำได้: หนูเท่านั้นที่สามารถเข้าถ้ำของคู่ต่อสู้เพื่อชนะได้',
                    '1. Entrée de la tanière réservée aux rats: Seul le Rat peut entrer dans la tanière de l\'adversaire pour gagner',
                    '1. Entrada a la guarida solo para ratas: Solo la Rata puede entrar en la guarida del oponente para ganar',
                    '1. Entrada da toca apenas para Rato: Apenas o Rato pode entrar na toca do oponente para vencer',
                    '1. Nur Ratten dürfen den Bau betreten: Nur die Ratte darf den Bau des Gegners betreten, um zu gewinnen',
                    widget.currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '2. Extended Lion/Tiger Jumps:',
                    '2. 獅虎跳躍擴展：',
                    '2. 狮虎跳跃扩展：',
                    '2. 拡張ライオン/トラのジャンプ：',
                    '2. 확장된 사자/호랑이 점프:',
                    '2. การกระโดดของสิงโต/เสือที่ขยายออกไป:',
                    '2. Sauts étendus Lion/Tigre:',
                    '2. Saltos extendidos de León/Tigre:',
                    '2. Saltos Estendidos de Leão/Tigre:',
                    '2. Erweiterte Löwen-/Tiger-Sprünge:',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '   - Lion can jump over both rivers',
                    '   - 獅子可以跳過兩條河流',
                    '   - 狮子可以跳过两条河流',
                    '   - ライオンは両方の川を飛び越えることができます',
                    '   - 사자는 두 강을 모두 뛰어넘을 수 있습니다',
                    '   - สิงโตสามารถกระโดดข้ามแม่น้ำทั้งสองได้',
                    '   - Le Lion peut sauter par-dessus les deux rivières',
                    '   - El León puede saltar sobre ambos ríos',
                    '   - O Leão pode saltar sobre ambos os rios',
                    '   - Löwe kann über beide Flüsse springen',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '   - Tiger can jump over a single river',
                    '   - 老虎可以跳過一條河流',
                    '   - 老虎可以跳过一条河流',
                    '   - トラは単一の川を飛び越えることができます',
                    '   - 호랑이는 단일 강을 뛰어넘을 수 있습니다',
                    '   - เสือสามารถกระโดดข้ามแม่น้ำสายเดียวได้',
                    '   - Le Tigre peut sauter par-dessus une seule rivière',
                    '   - El Tigre puede saltar sobre un solo río',
                    '   - O Tigre pode saltar sobre um único rio',
                    '   - Tiger kann über einen einzelnen Fluss springen',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '   - Leopard can cross rivers horizontally',
                    '   - 豹可以橫向過河',
                    '   - 豹可以横向过河',
                    '   - ヒョウは川を水平に渡ることができます',
                    '   - 표범은 강을 수평으로 건널 수 있습니다',
                    '   - เสือดาวสามารถข้ามแม่น้ำในแนวนอนได้',
                    '   - Le Léopard peut traverser les rivières horizontalement',
                    '   - El Leopardo puede cruzar ríos horizontalmente',
                    '   - O Leopardo pode atravessar rios horizontalmente',
                    '   - Leopard kann Flüsse horizontal überqueren',
                    widget.currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '3. Dog River Variant:',
                    '3. 狗入河變體：',
                    '3. 狗入河变体：',
                    '3. 犬の川のバリアント：',
                    '3. 개 강 변형:',
                    '3. รูปแบบแม่น้ำสุนัข:',
                    '3. Variante de la rivière du chien:',
                    '3. Variante del río Perro:',
                    '3. Variante do Rio Cão:',
                    '3. Hund-Fluss-Variante:',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '   - Dog can enter the river',
                    '   - 狗可以進入河流。',
                    '   - 狗可以进入河流。',
                    '   - 犬は川に入ることができます。',
                    '   - 개는 강에 들어갈 수 있습니다.',
                    '   - สุนัขสามารถลงแม่น้ำได้',
                    '   - Le Chien peut entrer dans la rivière.',
                    '   - El Perro puede entrar al río.',
                    '   - O Cão pode entrar no rio.',
                    '   - Hund kann den Fluss betreten.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '   - Only the Dog can capture pieces on the shore from within the river',
                    '   - 只有狗可以在河中捕獲岸上的棋子',
                    '   - 只有狗可以在河中捕获岸上的棋子',
                    '   - 犬だけが川の中から岸の駒を捕獲できます',
                    '   - 개만이 강에서 해안의 말을 잡을 수 있습니다',
                    '   - สุนัขเท่านั้นที่สามารถจับหมากบนฝั่งจากในแม่น้ำได้',
                    '   - Seul le Chien peut capturer des pièces sur le rivage depuis la rivière',
                    '   - Solo el Perro puede capturar piezas en la orilla desde dentro del río',
                    '   - Apenas o Cão pode capturar peças na margem a partir do rio',
                    '   - Nur der Hund kann Figuren am Ufer vom Fluss aus schlagen',
                    widget.currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AnimalChessApp.getLocalizedString(
                    '4. Rat cannot capture Elephant',
                    '4. 老鼠不能捕獲大象',
                    '4. 老鼠不能捕獲大象',
                    '4. ネズミはゾウを捕獲できません',
                    '4. 쥐는 코끼리를 잡을 수 없습니다',
                    '4. หนูจับช้างไม่ได้',
                    "4. Le rat ne peut pas capturer l'éléphant",
                    '4. La rata no puede capturar al elefante',
                    '4. Rato não pode capturar Elefante',
                    '4. Ratte kann Elefant nicht schlagen',
                    widget.currentLanguage,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                AnimalChessApp.getLocalizedString(
                  'Close',
                  '關閉',
                  '关闭',
                  '閉じる',
                  '닫기',
                  'ปิด',
                  'Fermer',
                  'Cerrar',
                  'Fechar',
                  'Schließen',
                  widget.currentLanguage,
                ),
              ),
            ),
          ],
        );
      },
    );
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
