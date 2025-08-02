import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/widgets/player_indicator_widget.dart';
import 'package:animal_chess/models/player_color.dart';

void main() {
  group('PlayerIndicatorWidget Tests', () {
    testWidgets('renders correctly for green player', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerIndicatorWidget(
              player: PlayerColor.green,
              label: 'Player 1',
              isActive: true,
            ),
          ),
        ),
      );

      expect(find.byType(PlayerIndicatorWidget), findsOneWidget);
      expect(find.text('Player 1'), findsOneWidget);
    });

    testWidgets('renders correctly for red player', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerIndicatorWidget(
              player: PlayerColor.red,
              label: 'Player 2',
              isActive: false,
            ),
          ),
        ),
      );

      expect(find.byType(PlayerIndicatorWidget), findsOneWidget);
      expect(find.text('Player 2'), findsOneWidget);
    });

    testWidgets('shows active styling when isActive=true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerIndicatorWidget(
              player: PlayerColor.green,
              label: 'Active Player',
              isActive: true,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Active Player'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('shows inactive styling when isActive=false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerIndicatorWidget(
              player: PlayerColor.red,
              label: 'Inactive Player',
              isActive: false,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Inactive Player'));
      expect(text.style?.fontWeight, equals(FontWeight.normal));
    });
  });
}
