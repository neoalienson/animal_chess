import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

import 'package:animal_chess/core/service_locator.dart';

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

        return AlertDialog(
          title: Text(localizations.settings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVariantToggle(
                localizations.ratOnlyDenEntry,
                _gameConfig.ratOnlyDenEntry,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(ratOnlyDenEntry: value);
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildVariantToggle(
                localizations.extendedLionTigerJumps,
                _gameConfig.extendedLionTigerJumps,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(
                      extendedLionTigerJumps: value,
                    );
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildVariantToggle(
                localizations.dogRiverVariant,
                _gameConfig.dogRiverVariant,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(dogRiverVariant: value);
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildVariantToggle(
                localizations.ratCannotCaptureElephant,
                _gameConfig.ratCannotCaptureElephant,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(
                      ratCannotCaptureElephant: value,
                    );
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildDisplayFormatSelector(
                localizations.pieceDisplayFormat,
                _gameConfig.pieceDisplayFormat,
                (PieceDisplayFormat value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(
                      pieceDisplayFormat: value,
                    );
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
            ],
          ),
          actions: [
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
                locator.registerSingleton<GameConfig>(_gameConfig.copyWith());

                // Notify listeners of the change
                widget.onConfigChanged(_gameConfig);

                Navigator.of(context).pop();
              },
              child: Text(localizations.save),
            ),
          ],
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
      title: Text(title, overflow: TextOverflow.ellipsis, maxLines: 2),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDisplayFormatSelector(
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
