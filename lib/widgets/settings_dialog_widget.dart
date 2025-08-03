import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

import 'package:animal_chess/core/service_locator.dart';
import 'package:animal_chess/widgets/ai_settings_tab.dart';
import 'package:animal_chess/widgets/game_variants_tab.dart';
import 'package:animal_chess/widgets/display_settings_tab.dart';

class SettingsDialogWidget extends StatefulWidget {
  final Function(GameConfig) onConfigChanged;

  const SettingsDialogWidget({super.key, required this.onConfigChanged});

  @override
  State<SettingsDialogWidget> createState() => _SettingsDialogWidgetState();
}

class _SettingsDialogWidgetState extends State<SettingsDialogWidget> {
  late GameConfig _gameConfig;

  @override
  void initState() {
    super.initState();
    _gameConfig = locator<GameConfig>();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final localizations = AppLocalizations.of(context);

        return DefaultTabController(
          length: 3,
          child: Dialog(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: localizations.aiPlayers),
                      Tab(text: localizations.gameVariants),
                      Tab(text: localizations.pieceDisplayFormat),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: TabBarView(
                      children: [
                        AiSettingsTab(
                          gameConfig: _gameConfig,
                          onConfigChanged: (config) {
                            setState(() {
                              _gameConfig = config;
                            });
                            widget.onConfigChanged(config);
                          },
                        ),
                        GameVariantsTab(
                          gameConfig: _gameConfig,
                          onConfigChanged: (config) {
                            setState(() {
                              _gameConfig = config;
                            });
                            widget.onConfigChanged(config);
                          },
                        ),
                        DisplaySettingsTab(
                          gameConfig: _gameConfig,
                          onConfigChanged: (config) {
                            setState(() {
                              _gameConfig = config;
                            });
                            widget.onConfigChanged(config);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(localizations.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            // Replace the singleton GameConfig instance
                            locator.unregister<GameConfig>();
                            locator.registerSingleton<GameConfig>(
                              _gameConfig.copyWith(),
                            );

                            // Recreate the game controller with the new config
                            recreateGameController();

                            // Notify listeners of the change
                            widget.onConfigChanged(_gameConfig);

                            Navigator.of(context).pop();
                          },
                          child: Text(localizations.save),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
