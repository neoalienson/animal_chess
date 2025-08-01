import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

import 'package:animal_chess/core/service_locator.dart';

class SettingsDialogWidget extends StatefulWidget {
  final Function(GameConfig) onConfigChanged;

  const SettingsDialogWidget({
    super.key,
    required this.onConfigChanged,
  });

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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
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
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
