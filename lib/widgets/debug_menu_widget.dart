import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class DebugMenuWidget extends StatelessWidget {
  final GameController gameController;
  final VoidCallback onClose;

  const DebugMenuWidget({
    super.key,
    required this.gameController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.debugMenuTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(localizations.forceGreenWin),
            onTap: () {
              onClose();
              gameController.forceWin(PlayerColor.green);
            },
          ),
          ListTile(
            title: Text(localizations.forceRedWin),
            onTap: () {
              onClose();
              gameController.forceWin(PlayerColor.red);
            },
          ),
        ],
      ),
    );
  }
}
