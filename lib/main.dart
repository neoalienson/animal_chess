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
import 'package:animal_chess/l10n/app_localizations.dart';
import 'dart:math';

void main() {
  runApp(const AnimalChessApp());
}

class AnimalChessApp extends StatefulWidget {
  const AnimalChessApp({super.key});

  @override
  State<AnimalChessApp> createState() => _AnimalChessAppState();
}

class _AnimalChessAppState extends State<AnimalChessApp> {
  Locale _locale = const Locale('zh');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Chess (Dou Shou Qi)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: MainMenuScreen(setLocale: setLocale),
    );
  }
}

// Main menu screen
class MainMenuScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const MainMenuScreen({super.key, required this.setLocale});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  // Game configuration
  GameConfig _gameConfig = GameConfig();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
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
                  localizations.animalChess,
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
                          localizations.newGame,
                          Icons.play_arrow,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimalChessGame(
                                  gameConfig: _gameConfig,
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
                          localizations.gameInstructions,
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
                          localizations.settings,
                          Icons.settings,
                          () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SettingsDialogWidget(
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
                        child: _buildMenuButton(
                          localizations.language,
                          Icons.language,
                          () {
                            _showLanguageSelection();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buildMenuButton(
                          localizations.about,
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

  // Show language selection
  void _showLanguageSelection() {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(const Locale('en'), 'English'),
              _buildLanguageOption(const Locale('zh', 'TW'), '繁體中文'),
              _buildLanguageOption(const Locale('zh'), '简体中文'),
              _buildLanguageOption(const Locale('ja'), '日本語'),
              _buildLanguageOption(const Locale('ko'), '한국어'),
              _buildLanguageOption(const Locale('th'), 'ไทย'),
              _buildLanguageOption(const Locale('fr'), 'Français'),
              _buildLanguageOption(const Locale('es'), 'Español'),
              _buildLanguageOption(const Locale('pt'), 'Português'),
              _buildLanguageOption(const Locale('de'), 'Deutsch'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(localizations.cancel),
            ),
          ],
        );
      },
    );
  }

  // Build language option
  Widget _buildLanguageOption(Locale locale, String label) {
    return ListTile(
      title: Text(label),
      trailing: Localizations.localeOf(context) == locale ? const Icon(Icons.check) : null,
      onTap: () {
        widget.setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }

  // Show rules dialog
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const GameRulesDialogWidget();
      },
    );
  }

  // Show about dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AboutDialogWidget();
      },
    );
  }
}

class AnimalChessGame extends StatefulWidget {
  final GameConfig gameConfig;

  const AnimalChessGame({
    super.key,
    required this.gameConfig,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          localizations.piecesRank,
                          style: const TextStyle(
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
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PlayerIndicatorWidget(
            player: PlayerColor.green,
            label: localizations.greenPlayer,
            isActive: _gameController.currentPlayer == PlayerColor.green,
          ),
          PlayerIndicatorWidget(
            player: PlayerColor.red,
            label: localizations.redPlayer,
            isActive: _gameController.currentPlayer == PlayerColor.red,
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
            ? Colors.green
            : Colors.red;
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
        return const GameRulesDialogWidget();
      },
    );
  }
}
