import 'package:flutter/material.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class PiecesRankListWidget extends StatelessWidget {
  const PiecesRankListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Create a list of all animal types sorted by rank (strongest to weakest)
    final animalTypes = List<AnimalType>.from(AnimalType.values);
    animalTypes.sort((a, b) => a.rank.compareTo(b.rank));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
            animalName: _getLocalizedAnimalName(localizations, animalType),
          ),
          title: Text(
            _getLocalizedAnimalName(localizations, animalType),
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  String _getLocalizedAnimalName(
    AppLocalizations localizations,
    AnimalType animalType,
  ) {
    switch (animalType) {
      case AnimalType.elephant:
        return localizations.elephantName;
      case AnimalType.lion:
        return localizations.lionName;
      case AnimalType.tiger:
        return localizations.tigerName;
      case AnimalType.leopard:
        return localizations.leopardName;
      case AnimalType.wolf:
        return localizations.wolfName;
      case AnimalType.dog:
        return localizations.dogName;
      case AnimalType.cat:
        return localizations.catName;
      case AnimalType.rat:
        return localizations.ratName;
    }
  }
}
