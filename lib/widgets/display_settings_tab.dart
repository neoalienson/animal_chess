import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class DisplaySettingsTab extends StatelessWidget {
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;

  const DisplaySettingsTab({
    super.key,
    required this.gameConfig,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDisplayFormatSelector(
            context,
            localizations.pieceDisplayFormat,
            gameConfig.pieceDisplayFormat,
            (PieceDisplayFormat value) {
              onConfigChanged(gameConfig.copyWith(pieceDisplayFormat: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayFormatSelector(
    BuildContext context,
    String title,
    PieceDisplayFormat value,
    ValueChanged<PieceDisplayFormat> onChanged,
  ) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile<PieceDisplayFormat>(
          title: Text(localizations.displayFormatEmoji),
          value: PieceDisplayFormat.emoji,
          groupValue: value,
          onChanged: (PieceDisplayFormat? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
        RadioListTile<PieceDisplayFormat>(
          title: Text(localizations.displayFormatSimplifiedChinese),
          value: PieceDisplayFormat.simplifiedChinese,
          groupValue: value,
          onChanged: (PieceDisplayFormat? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
        RadioListTile<PieceDisplayFormat>(
          title: Text(localizations.displayFormatTraditionalChinese),
          value: PieceDisplayFormat.traditionalChinese,
          groupValue: value,
          onChanged: (PieceDisplayFormat? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
