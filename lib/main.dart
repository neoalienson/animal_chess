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
                  _getLocalizedString(
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
                          _getLocalizedString(
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
                          _getLocalizedString(
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
                            _showGameInstructions();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          _getLocalizedString(
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
                          _getLocalizedString(
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

  // Show game instructions
  void _showGameInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AnimalChessApp._getLocalizedString(
              'Game Instructions',
              '遊戲規則',
              '游戏规则',
              'ゲームの遊び方',
              '게임 방법',
              'คำแนะนำเกม',
              'Instructions du jeu',
              'Instrucciones del juego',
              'Instruções do Jogo',
              'Spielanleitung',
              _currentLanguage,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AnimalChessApp._getLocalizedString(
                    'Animal Chess is a strategic board game for two players.',
                    '鬥獸棋是兩人對弈的戰略棋盤遊戲。',
                    '斗兽棋是两人对弈的战略棋盘游戏。',
                    '動物チェスは2人用の戦略ボードゲームです。',
                    '동물 체스는 두 명의 플레이어를 위한 전략 보드 게임입니다.',
                    'หมากรุกสัตว์เป็นเกมกระดานกลยุทธ์สำหรับผู้เล่นสองคน',
                    'Animal Chess est un jeu de société stratégique pour deux joueurs.',
                    'El Ajedrez Animal es un juego de mesa estratégico para dos jugadores.',
                    'Xadrez Animal é um jogo de tabuleiro estratégico para dois jogadores.',
                    'Tier Schach ist ein strategisches Brettspiel für zwei Spieler.',
                    _currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '1. Each player commands 8 animals with different ranks.',
                    '1. 每位玩家指揮8隻不同等級的動物。',
                    '1. 每位玩家指挥8只不同等级的动物。',
                    '1. 各プレイヤーは異なるランクの8匹の動物を指揮します。',
                    '1. 각 플레이어는 다른 등급의 동물 8마리를 지휘합니다.',
                    '1. ผู้เล่นแต่ละคนควบคุมสัตว์ 8 ตัวที่มีอันดับต่างกัน',
                    '1. Chaque joueur commande 8 animaux de rangs différents.',
                    '1. Cada jugador comanda 8 animales con diferentes rangos.',
                    '1. Cada jogador comanda 8 animais com diferentes patentes.',
                    '1. Jeder Spieler befehligt 8 Tiere mit unterschiedlichen Rängen.',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    "2. Objective: Move any piece into opponent's den or capture all opponent pieces.",
                    '2. 目標：將任何棋子移入對方獸穴或捕獲所有對方棋子。',
                    '2. 目标：将任何棋子移入对方兽穴或捕获所有对方棋子。',
                    '2. 目的：相手の巣穴に駒を進めるか、相手の駒をすべて捕獲する。',
                    '2. 목표: 상대방의 굴에 말을 이동시키거나 상대방의 말을 모두 잡는 것입니다.',
                    '2. วัตถุประสงค์: ย้ายหมากตัวใดตัวหนึ่งเข้าไปในรังของคู่ต่อสู้ หรือจับหมากของคู่ต่อสู้ทั้งหมด',
                    '2. Objectif: Déplacer une pièce dans le repaire de l\'adversaire ou capturer toutes les pièces adverses.',
                    '2. Objetivo: Mover cualquier pieza al den del oponente o capturar todas las piezas del oponente.',
                    '2. Objetivo: Mover qualquer peça para a toca do oponente ou capturar todas as peças do oponente.',
                    '2. Ziel: Eine Figur in die Höhle des Gegners bewegen oder alle gegnerischen Figuren schlagen.',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '3. Pieces move one space orthogonally (up, down, left, or right).',
                    '3. 棋子可向上、下、左、右移動一格。',
                    '3. 棋子可向上、下、左、右移动一格。',
                    '3. 駒は縦横に1マス移動します。',
                    '3. 말은 상하좌우로 한 칸씩 움직입니다.',
                    '3. หมากเคลื่อนที่ได้หนึ่งช่องในแนวตั้ง (ขึ้น, ลง, ซ้าย, หรือขวา)',
                    '3. Les pièces se déplacent d\'une case orthogonalement (haut, bas, gauche ou droite).',
                    '3. Las piezas se mueven una casilla ortogonalmente (arriba, abajo, izquierda o derecha).',
                    '3. As peças movem-se uma casa ortogonalmente (para cima, para baixo, para a esquerda ou para a direita).',
                    '3. Figuren bewegen sich ein Feld orthogonal (hoch, runter, links oder rechts).',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '4. Only the Rat can enter the river.',
                    '4. 只有老鼠可以進入河流。',
                    '4. 只有老鼠可以进入河流。',
                    '4. ネズミだけが川に入ることができます。',
                    '4. 쥐만 강에 들어갈 수 있습니다.',
                    '4. หนูเท่านั้นที่สามารถลงแม่น้ำได้',
                    '4. Seul le Rat peut entrer dans la rivière.',
                    '4. Solo la Rata puede entrar al río.',
                    '4. Apenas o Rato pode entrar no rio.',
                    '4. Nur die Ratte darf den Fluss betreten.',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '5. Lion and Tiger can jump over rivers.',
                    '5. 獅子和老虎可以跳過河流。',
                    '5. 狮子和老虎可以跳过河流。',
                    '5. ライオンとトラは川を飛び越えることができます。',
                    '5. 사자와 호랑이는 강을 뛰어넘을 수 있습니다.',
                    '5. สิงโตและเสือสามารถกระโดดข้ามแม่น้ำได้',
                    '5. Le Lion et le Tigre peuvent sauter par-dessus les rivières.',
                    '5. El León y el Tigre pueden saltar sobre los ríos.',
                    '5. O Leão e o Tigre podem saltar sobre os rios.',
                    '5. Löwe und Tiger können über Flüsse springen.',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '6. Pieces in traps can be captured by any opponent piece.',
                    '6. 在陷阱中的棋子可被任何對手棋子捕獲。',
                    '6. 在陷阱中的棋子可被任何对手棋子捕获。',
                    '6. 罠の中の駒は、相手のどの駒でも捕獲できます。',
                    '6. 덫에 갇힌 말은 상대방의 어떤 말이라도 잡을 수 있습니다.',
                    '6. หมากในกับดักสามารถถูกจับได้โดยหมากของคู่ต่อสู้',
                    '6. Les pièces dans les pièges peuvent être capturées par n\'importe quelle pièce adverse.',
                    '6. Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.',
                    '6. Peças em armadilhas podem ser capturadas por qualquer peça adversária.',
                    '6. Figuren in Fallen können von jeder gegnerischen Figur geschlagen werden.',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    "7. A piece can capture an opponent's piece if it is of equal or lower rank.",
                    '7. 棋子可以捕獲等級相同或較低的對手棋子。',
                    '7. 棋子可以捕获等级相同或较低的对手棋子。',
                    '7. 駒は、同等またはそれ以下のランクの相手の駒を捕獲できます。',
                    '7. 말은 자신과 같거나 낮은 등급의 상대방 말을 잡을 수 있습니다.',
                    '7. หมากสามารถจับหมากของคู่ต่อสู้ได้หากมีอันดับเท่ากันหรือต่ำกว่า',
                    '7. Une pièce peut capturer une pièce adverse si elle est de rang égal ou inférieur.',
                    '7. Una pieza puede capturar una pieza oponente si es de igual o menor rango.',
                    '7. Uma peça pode capturar uma peça do oponente se for de patente igual ou inferior.',
                    '7. Eine Figur kann eine gegnerische Figur schlagen, wenn sie gleich oder niedriger im Rang ist.',
                    _currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                    '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                    '8. 例外：老鼠可以捕获大象，大象可以捕获老鼠。',
                    '8. 例外：ネズミはゾウを捕獲でき、ゾウはネズミを捕獲できます。',
                    '8. 예외: 쥐는 코끼리를 잡을 수 있고, 코끼리는 쥐를 잡을 수 있습니다.',
                    '8. ข้อยกเว้น: หนูจับช้างได้ และช้างจับหนูได้',
                    '8. Exception: Le rat peut capturer l\'éléphant, et l\'éléphant peut capturer le rat.',
                    '8. Excepción: La rata puede capturar al elefante, y el elefante puede capturar a la rata.',
                    '8. Exceção: O Rato pode capturar o Elefante, e o Elefante pode capturar o Rato.',
                    '8. Ausnahme: Ratte kann Elefant schlagen, und Elefant kann Ratte schlagen.',
                    _currentLanguage,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                AnimalChessApp._getLocalizedString(
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
                AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
            AnimalChessApp._getLocalizedString(
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
                AnimalChessApp._getLocalizedString(
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

  // Show about dialog
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AnimalChessApp._getLocalizedString(
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
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.adb),
      applicationLegalese: '© 2025 Animal Chess',
      children: [
        Text(
          AnimalChessApp._getLocalizedString(
            'A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).',
            '經典中國棋盤遊戲鬥獸棋的Flutter實現。',
            '经典中国棋盘游戏斗兽棋的Flutter实现。',
            '古典的な中国のボードゲーム「動物チェス（鬥獸棋）」のFlutter実装。',
            '고전 중국 보드 게임 동물 체스(鬥獸棋)의 Flutter 구현.',
            'การนำเกมหมากรุกสัตว์ (鬥獸棋) แบบจีนคลาสสิกมาใช้ใน Flutter',
            'Une implémentation Flutter du jeu de société chinois classique Animal Chess (Dou Shou Qi).',
            'Una implementación en Flutter del clásico juego de mesa chino Ajedrez Animal (Dou Shou Qi).',
            'Uma implementação Flutter do clássico jogo de tabuleiro chinês Xadrez Animal (Dou Shou Qi).',
            'Eine Flutter-Implementierung des klassischen chinesischen Brettspiels Tier Schach (Dou Shou Qi).',
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
          AnimalChessApp._getLocalizedString(
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
            tooltip: AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
                    AnimalChessApp._getLocalizedString(
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
            AnimalChessApp._getLocalizedString(
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
            AnimalChessApp._getLocalizedString(
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
            ? AnimalChessApp._getLocalizedString(
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
            : AnimalChessApp._getLocalizedString(
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
        statusText = AnimalChessApp._getLocalizedString(
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
        statusText = AnimalChessApp._getLocalizedString(
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
          ? AnimalChessApp._getLocalizedString(
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
          : AnimalChessApp._getLocalizedString(
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
      statusText = AnimalChessApp._getLocalizedString(
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

  /// Show game rules dialog
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AnimalChessApp._getLocalizedString(
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AnimalChessApp._getLocalizedString(
                    'Animal Chess is a strategic board game for two players.',
                    '鬥獸棋是兩人對弈的戰略棋盤遊戲。',
                    '斗兽棋是两人对弈的战略棋盘游戏。',
                    '動物チェスは2人用の戦略ボードゲームです。',
                    '동물 체스는 두 명의 플레이어를 위한 전략 보드 게임입니다.',
                    'หมากรุกสัตว์เป็นเกมกระดานกลยุทธ์สำหรับผู้เล่นสองคน',
                    'Animal Chess est un jeu de société stratégique pour deux joueurs.',
                    'El Ajedrez Animal es un juego de mesa estratégico para dos jugadores.',
                    'Xadrez Animal é um jogo de tabuleiro estratégico para dois jogadores.',
                    'Tier Schach ist ein strategisches Brettspiel für zwei Spieler.',
                    widget.currentLanguage,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '1. Each player commands 8 animals with different ranks.',
                    '1. 每位玩家指揮8隻不同等級的動物。',
                    '1. 每位玩家指挥8只不同等级的动物。',
                    '1. 各プレイヤーは異なるランクの8匹の動物を指揮します。',
                    '1. 각 플레이어는 다른 등급의 동물 8마리를 지휘합니다.',
                    '1. ผู้เล่นแต่ละคนควบคุมสัตว์ 8 ตัวที่มีอันดับต่างกัน',
                    '1. Chaque joueur commande 8 animaux de rangs différents.',
                    '1. Cada jugador comanda 8 animales con diferentes rangos.',
                    '1. Cada jogador comanda 8 animais com diferentes patentes.',
                    '1. Jeder Spieler befehligt 8 Tiere mit unterschiedlichen Rängen.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    "2. Objective: Move any piece into opponent's den or capture all opponent pieces.",
                    '2. 目標：將任何棋子移入對方獸穴或捕獲所有對方棋子。',
                    '2. 目标：将任何棋子移入对方兽穴或捕获所有对方棋子。',
                    '2. 目的：相手の巣穴に駒を進めるか、相手の駒をすべて捕獲する。',
                    '2. 목표: 상대방의 굴에 말을 이동시키거나 상대방의 말을 모두 잡는 것입니다.',
                    '2. วัตถุประสงค์: ย้ายหมากตัวใดตัวหนึ่งเข้าไปในรังของคู่ต่อสู้ หรือจับหมากของคู่ต่อสู้ทั้งหมด',
                    "2. Objectif: Déplacer une pièce dans le repaire de l'adversaire ou capturer toutes les pièces adverses.",
                    '2. Objetivo: Mover cualquier pieza al den del oponente o capturar todas las piezas del oponente.',
                    '2. Objetivo: Mover qualquer peça para a toca do oponente ou capturar todas as peças do oponente.',
                    '2. Ziel: Eine Figur in die Höhle des Gegners bewegen oder alle gegnerischen Figuren schlagen.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '3. Pieces move one space orthogonally (up, down, left, or right).',
                    '3. 棋子可向上、下、左、右移動一格。',
                    '3. 棋子可向上、下、左、右移动一格。',
                    '3. 駒は縦横に1マス移動します。',
                    '3. 말은 상하좌우로 한 칸씩 움직입니다.',
                    '3. หมากเคลื่อนที่ได้หนึ่งช่องในแนวตั้ง (ขึ้น, ลง, ซ้าย, หรือขวา)',
                    '3. Les pièces se déplacent d\'une case orthogonalement (haut, bas, gauche ou droite).',
                    '3. Las piezas se mueven una casilla ortogonalmente (arriba, abajo, izquierda o derecha).',
                    '3. As peças movem-se uma casa ortogonalmente (para cima, para baixo, para a esquerda ou para a direita).',
                    '3. Figuren bewegen sich ein Feld orthogonal (hoch, runter, links oder rechts).',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '4. Only the Rat can enter the river.',
                    '4. 只有老鼠可以進入河流。',
                    '4. 只有老鼠可以进入河流。',
                    '4. ネズミだけが川に入ることができます。',
                    '4. 쥐만 강에 들어갈 수 있습니다.',
                    '4. หนูเท่านั้นที่สามารถลงแม่น้ำได้',
                    '4. Seul le Rat peut entrer dans la rivière.',
                    '4. Solo la Rata puede entrar al río.',
                    '4. Apenas o Rato pode entrar no rio.',
                    '4. Nur die Ratte darf den Fluss betreten.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '5. Lion and Tiger can jump over rivers.',
                    '5. 獅子和老虎可以跳過河流。',
                    '5. 狮子和老虎可以跳过两条河流。',
                    '5. ライオンとトラは川を飛び越えることができます。',
                    '5. 사자와 호랑이는 강을 뛰어넘을 수 있습니다.',
                    '5. สิงโตและเสือสามารถกระโดดข้ามแม่น้ำทั้งสองได้',
                    '5. Le Lion et le Tigre peuvent sauter par-dessus les rivières.',
                    '5. El León y el Tigre pueden saltar sobre ambos ríos.',
                    '5. O Leão e o Tigre podem saltar sobre ambos os rios.',
                    '5. Löwe und Tiger können über beide Flüsse springen.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '6. Pieces in traps can be captured by any opponent piece.',
                    '6. 在陷阱中的棋子可被任何對手棋子捕獲。',
                    '6. 在陷阱中的棋子可被任何对手棋子捕获。',
                    '6. 罠の中の駒は、相手のどの駒でも捕獲できます。',
                    '6. 덫에 갇힌 말은 상대방의 어떤 말이라도 잡을 수 있습니다.',
                    '6. หมากในกับดักสามารถถูกจับได้โดยหมากของคู่ต่อสู้',
                    '6. Les pièces dans les pièges peuvent être capturées par n\'importe quelle pièce adverse.',
                    '6. Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.',
                    '6. Peças em armadilhas podem ser capturadas por qualquer peça adversária.',
                    '6. Figuren in Fallen können von jeder gegnerischen Figur geschlagen werden.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '7. A piece can capture an opponent\'s piece if it is of equal or lower rank.',
                    '7. 棋子可以捕獲等級相同或較低的對手棋子。',
                    '7. 棋子可以捕获等级相同或较低的对手棋子。',
                    '7. 駒は、同等またはそれ以下のランクの相手の駒を捕獲できます。',
                    '7. 말은 자신과 같거나 낮은 등급의 상대방 말을 잡을 수 있습니다.',
                    '7. หมากสามารถจับหมากของคู่ต่อสู้ได้หากมีอันดับเท่ากันหรือต่ำกว่า',
                    '7. Une pièce peut capturer une pièce adverse si elle est de rang égal ou inférieur.',
                    '7. Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.',
                    '7. Uma peça pode capturar uma peça do oponente se for de patente igual ou inferior.',
                    '7. Eine Figur kann eine gegnerische Figur schlagen, wenn sie gleich oder niedriger im Rang ist.',
                    widget.currentLanguage,
                  ),
                ),
                Text(
                  AnimalChessApp._getLocalizedString(
                    '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                    '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                    '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                    '8. 例外：ネズミはゾウを捕獲でき、ゾウはネズミを捕獲できます。',
                    '8. 예외: 쥐는 코끼리를 잡을 수 있고, 코끼리는 쥐를 잡을 수 있습니다.',
                    '8. ข้อยกเว้น: หนูจับช้างได้ และช้างจับหนูได้',
                    '8. Exception: Le rat peut capturer l\'éléphant, et l\'éléphant peut capturer le rat.',
                    '8. Excepción: La rata puede capturar al elefante, y el elefante puede capturar a la rata.',
                    '8. Exceção: O Rato pode capturar o Elefante, e o Elefante pode capturar o Rato.',
                    '8. Ausnahme: Ratte kann Elefant schlagen, und Elefant kann Ratte schlagen.',
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
                AnimalChessApp._getLocalizedString(
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

  /// Show game variants dialog
  void _showVariantsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                  AnimalChessApp._getLocalizedString(
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
                AnimalChessApp._getLocalizedString(
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
