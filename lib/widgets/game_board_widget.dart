import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/game/game_controller.dart';

class GameBoardWidget extends StatelessWidget {
  final GameController gameController;
  final Function(Position) onPositionTap;
  final List<Position> validMoves;

  const GameBoardWidget({
    super.key,
    required this.gameController,
    required this.onPositionTap,
    required this.validMoves,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7 / 9, // 7 columns × 9 rows
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown, width: 2),
          color: Colors.amber[50],
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 columns
          ),
          itemCount: GameBoard.columns * GameBoard.rows,
          itemBuilder: (context, index) {
            int row = index ~/ GameBoard.columns;
            int col = index % GameBoard.columns;
            Position position = Position(col, row);

            return _buildBoardCell(position);
          },
        ),
      ),
    );
  }

  /// Build a single cell of the board
  Widget _buildBoardCell(Position position) {
    GameBoard board = gameController.board;
    Piece? piece = board.getPiece(position);
    bool isSelected = gameController.selectedPosition == position;
    bool isValidMove = validMoves.contains(position);

    // Determine cell background color
    Color cellColor = _getCellBackgroundColor(position);

    // Add highlight for valid moves
    if (isValidMove) {
      cellColor = cellColor.withValues(alpha: 0.7);
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(color: Colors.brown.withOpacity(0.3)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Special zone indicators
          if (board.isDen(position))
            _buildDenIndicator(position)
          else if (board.isTrap(position))
            _buildTrapIndicator()
          else if (board.isRiver(position))
            _buildRiverIndicator(),

          // Piece widget
          if (piece != null)
            PieceWidget(
              piece: piece,
              isSelected: isSelected,
              onTap: () => onPositionTap(position),
            )
          // Empty cell tap handler
          else
            GestureDetector(
              onTap: () => onPositionTap(position),
              child: Container(color: Colors.transparent),
            ),

          // Valid move indicator
          if (isValidMove && piece == null)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  /// Get background color for a cell based on its type
  Color _getCellBackgroundColor(Position position) {
    GameBoard board = gameController.board;

    // Dens
    if (board.isDen(position)) {
      return board.getZoneOwner(position) == PlayerColor.green
          ? Colors.green[100]!
          : Colors.red[100]!;
    }

    // Traps
    if (board.isTrap(position)) {
      return board.getZoneOwner(position) == PlayerColor.green
          ? Colors.green[200]!
          : Colors.red[200]!;
    }

    // Rivers
    if (board.isRiver(position)) {
      return Colors.blue[100]!;
    }

    // Regular cells
    return Colors.amber[50]!;
  }

  /// Build indicator for den cells
  Widget _buildDenIndicator(Position position) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.brown, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.home, color: Colors.brown, size: 20),
      ),
    );
  }

  /// Build indicator for trap cells
  Widget _buildTrapIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Icon(Icons.warning, color: Colors.orange, size: 16),
      ),
    );
  }

  /// Build indicator for river cells
  Widget _buildRiverIndicator() {
    return const Center(
      child: Icon(Icons.water_drop, color: Colors.blue, size: 16),
    );
  }
}
