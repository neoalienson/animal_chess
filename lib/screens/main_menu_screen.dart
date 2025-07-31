import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/screens/animal_chess_game_screen.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/widgets/game_rules_dialog_widget.dart';
import 'package:animal_chess/widgets/about_dialog_widget.dart';
import 'package:animal_chess/widgets/settings_dialog_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'dart:math';

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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
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
                                builder: (context) => AnimalChessGameScreen(
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
        minimumSize: const Size(200, 60), // Minimum button size
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36), // Larger icon
          const SizedBox(width: 10), // Space between icon and text
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 24), // Larger text
              overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
              softWrap: false, // Prevent text wrapping
            ),
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
      title: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
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
