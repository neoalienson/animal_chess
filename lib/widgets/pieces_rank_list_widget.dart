import 'package:flutter/material.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/widgets/piece_widget.dart';

class PiecesRankListWidget extends StatelessWidget {
  const PiecesRankListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a list of all animal types sorted by rank (strongest to weakest)
    final animalTypes = List<AnimalType>.from(AnimalType.values);
    animalTypes.sort((a, b) => a.rank.compareTo(b.rank));

    return ListView.builder(
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
          ),
          title: Text(animalType.name, style: const TextStyle(fontSize: 12)),
        );
      },
    );
  }
}
