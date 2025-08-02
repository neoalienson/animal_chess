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

        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text(localizations.settings),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRatOnlyDenEntryVariant(context, localizations),
                        _buildExtendedLionTigerJumpsVariant(
                          context,
                          localizations,
                        ),
                        _buildDogRiverVariant(context, localizations),
                        _buildRatCannotCaptureElephantVariant(
                          context,
                          localizations,
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
        );
      },
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: Theme.of(context).textTheme.bodySmall),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildRatOnlyDenEntryVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.ratOnlyDenEntry,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: _gameConfig.ratOnlyDenEntry,
          onChanged: (bool value) {
            setState(() {
              _gameConfig = _gameConfig.copyWith(ratOnlyDenEntry: value);
            });
            widget.onConfigChanged(_gameConfig);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              _gameConfig.ratOnlyDenEntry
                  ? localizations.variantRatOnlyDenEntryDescriptionEnabled
                  : localizations.variantRatOnlyDenEntryDescriptionDisabled,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExtendedLionTigerJumpsVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.extendedLionTigerJumps,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: _gameConfig.extendedLionTigerJumps,
          onChanged: (bool value) {
            setState(() {
              _gameConfig = _gameConfig.copyWith(extendedLionTigerJumps: value);
            });
            widget.onConfigChanged(_gameConfig);
          },
        ),
        if (_gameConfig.extendedLionTigerJumps) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(
                  context,
                  localizations.variantLionJumpBothRivers,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantTigerJumpSingleRiver,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantLeopardCrossRivers,
                ),
              ],
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(
                  context,
                  localizations.variantLionJumpStandard,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantTigerJumpStandard,
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantLeopardCrossRiversStandard,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDogRiverVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.dogRiverVariant,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: _gameConfig.dogRiverVariant,
          onChanged: (bool value) {
            setState(() {
              _gameConfig = _gameConfig.copyWith(dogRiverVariant: value);
            });
            widget.onConfigChanged(_gameConfig);
          },
        ),
        if (_gameConfig.dogRiverVariant) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(context, localizations.variantDogEnterRiver),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  context,
                  localizations.variantDogCaptureFromRiver,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatCannotCaptureElephantVariant(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            localizations.ratCannotCaptureElephant,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          value: _gameConfig.ratCannotCaptureElephant,
          onChanged: (bool value) {
            setState(() {
              _gameConfig = _gameConfig.copyWith(
                ratCannotCaptureElephant: value,
              );
            });
            widget.onConfigChanged(_gameConfig);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              _gameConfig.ratCannotCaptureElephant
                  ? localizations
                        .variantRatCannotCaptureElephantDescriptionEnabled
                  : localizations
                        .variantRatCannotCaptureElephantDescriptionDisabled,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
      ],
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
