import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/constants/ui_constants.dart';

class VictoryDialogWidget extends StatelessWidget {
  final PlayerColor? winner;
  final ConfettiController confettiController;
  final VoidCallback onClose;

  const VictoryDialogWidget({
    super.key,
    required this.winner,
    required this.confettiController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    String winnerText = winner == PlayerColor.green
        ? localizations.greenPlayer
        : localizations.redPlayer;

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.gameOverWins(winnerText),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.01,
                numberOfParticles: 50,
                gravity: 0.1,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(onPressed: onClose, child: Text(localizations.close)),
          ],
        ),
      ),
    );
  }
}
