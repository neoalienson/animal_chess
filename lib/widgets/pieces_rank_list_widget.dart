import 'package:flutter/material.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/l10n/app_localizations.dart';

class PiecesRankListWidget extends StatelessWidget {
  final PieceDisplayFormat displayFormat;

  const PiecesRankListWidget({
    super.key,
    this.displayFormat = PieceDisplayFormat.traditionalChinese,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Create a list of all animal types sorted by rank (strongest to weakest)
    final animalTypes = List<AnimalType>.from(AnimalType.values);
    animalTypes.sort((a, b) => a.rank.compareTo(b.rank));

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: animalTypes.length,
      itemBuilder: (context, index) {
        final animalType = animalTypes[index];
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: PieceWidget(
                  piece: Piece(
                    animalType,
                    PlayerColor.red,
                  ), // Color will be override by isRankDisplay: true,
                  isSelected: false,
                  size: 40, // Directly set the piece size to 80
                  isRankDisplay: true,
                  displayFormat: displayFormat,
                  animalName: _getLocalizedAnimalName(
                    localizations,
                    animalType,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _getLocalizedAnimalName(localizations, animalType),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
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
