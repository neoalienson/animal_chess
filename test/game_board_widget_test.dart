import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_chess/widgets/game_board_widget.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';

class PositionFake extends Fake implements Position {}

class MockGameBoard extends Mock implements GameBoard {}

class MockGameController extends Mock implements GameController {}

void main() {
  setUpAll(() {
    registerFallbackValue(PositionFake());
  });

  late MockGameController mockGameController;
  late MockGameBoard mockGameBoard;
  final testPositions = [Position(0, 0), Position(1, 1)];

  setUp(() {
    mockGameController = MockGameController();
    mockGameBoard = MockGameBoard();

    // Mock the GameController properties
    when(() => mockGameController.board).thenAnswer((_) => mockGameBoard);
    when(() => mockGameController.selectedPosition).thenReturn(null);

    // Mock the GameBoard methods
    when(
      () => mockGameBoard.isDen(any(that: isA<Position>())),
    ).thenReturn(false);
    when(
      () => mockGameBoard.isTrap(any(that: isA<Position>())),
    ).thenReturn(false);
    when(
      () => mockGameBoard.isRiver(any(that: isA<Position>())),
    ).thenReturn(false);
    when(
      () => mockGameBoard.getZoneOwner(any(that: isA<Position>())),
    ).thenReturn(null);
    when(
      () => mockGameBoard.getPiece(any(that: isA<Position>())),
    ).thenReturn(null);
  });

  tearDown(() {
    reset(mockGameController);
    reset(mockGameBoard);
  });

  testWidgets('GameBoardWidget renders with required parameters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: GameBoardWidget(
            gameController: mockGameController,
            onPositionTap: (_) {},
            validMoves: testPositions,
          ),
        ),
      ),
    );

    expect(find.byType(GameBoardWidget), findsOneWidget);
  });

  testWidgets('GameBoardWidget renders correct number of cells', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: GameBoardWidget(
            gameController: mockGameController,
            onPositionTap: (_) {},
            validMoves: testPositions,
          ),
        ),
      ),
    );

    expect(find.byType(GestureDetector), findsNWidgets(63)); // 7x9 board
  });

  testWidgets('GameBoardWidget calls onPositionTap when cell tapped', (
    WidgetTester tester,
  ) async {
    Position? tappedPosition;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: GameBoardWidget(
            gameController: mockGameController,
            onPositionTap: (position) => tappedPosition = position,
            validMoves: testPositions,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find the exact cell and ensure it's visible
    final cellFinder = find.byKey(const Key('cell_0_0'));
    expect(cellFinder, findsOneWidget);

    // Tap using the widget finder which properly handles hit testing
    await tester.tap(cellFinder);
    await tester.pump();

    // Alternative: If we need to tap at precise coordinates
    // final cell = tester.getRect(cellFinder);
    // await tester.tapAt(cell.center + Offset(2, 2)); // Small offset to avoid borders
    // await tester.pump();

    // Verify callback was called with correct position
    expect(tappedPosition, isNotNull);
    expect(tappedPosition!.column, equals(0));
    expect(tappedPosition!.row, equals(0));
  });
}
