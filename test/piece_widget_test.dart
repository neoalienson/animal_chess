import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/player_color.dart';

void main() {
  group('PieceWidget Tests', () {
    testWidgets('renders correctly with all parameters', (tester) async {
      final piece = Piece(AnimalType.lion, PlayerColor.red);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PieceWidget(
              piece: piece,
              isSelected: false,
              onTap: () {},
              size: 100,
              animalName: '獅',
            ),
          ),
        ),
      );

      expect(find.byType(PieceWidget), findsOneWidget);
      expect(find.text('獅'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      final piece = Piece(AnimalType.elephant, PlayerColor.green);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PieceWidget(
              piece: piece,
              isSelected: false,
              onTap: () => tapped = true,
              size: 100,
              animalName: '象',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PieceWidget));
      expect(tapped, isTrue);
    });

    testWidgets('shows selection indicator when selected', (tester) async {
      final piece = Piece(AnimalType.tiger, PlayerColor.red);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PieceWidget(
              piece: piece,
              isSelected: true,
              onTap: () {},
              size: 100,
              animalName: '虎',
            ),
          ),
        ),
      );

      expect(find.byType(DecoratedBox), findsWidgets);
    });
  });
}
