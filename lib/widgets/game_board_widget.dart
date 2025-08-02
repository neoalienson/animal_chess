import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_board.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/models/position.dart';
import 'package:animal_chess/models/piece.dart';
import 'package:animal_chess/models/animal_type.dart';
import 'package:animal_chess/models/piece_display_format.dart';
import 'package:animal_chess/widgets/piece_widget.dart';
import 'package:animal_chess/game/game_controller.dart';
import 'package:animal_chess/l10n/app_localizations.dart';
import 'package:animal_chess/constants/board_constants.dart';
import 'package:animal_chess/constants/ui_constants.dart';

class GameBoardWidget extends StatelessWidget {
  final GameController gameController;
  final Function(Position) onPositionTap;
  final List<Position> validMoves;
  final PieceDisplayFormat displayFormat;

  const GameBoardWidget({
    super.key,
    required this.gameController,
    required this.onPositionTap,
    required this.validMoves,
    this.displayFormat = PieceDisplayFormat.traditionalChinese,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          BoardConstants.columns / BoardConstants.rows, // 7 columns × 9 rows
      child: LayoutBuilder(
        builder: (context, constraints) {
          final localizations = AppLocalizations.of(context);
          // Calculate the size of each cell
          final cellSize = constraints.maxWidth / BoardConstants.columns;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: UIConstants.boardBorderColor,
                width: UIConstants.boardBorderWidth,
              ),
              color: UIConstants.boardBackgroundColor,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: BoardConstants.columns, // 7 columns
              ),
              itemCount: BoardConstants.columns * BoardConstants.rows,
              itemBuilder: (context, index) {
                int row = index ~/ BoardConstants.columns;
                int col = index % BoardConstants.columns;
                Position position = Position(col, row);

                return _buildBoardCell(position, cellSize, localizations);
              },
            ),
          );
        },
      ),
    );
  }

  /// Build a single cell of the board
  Widget _buildBoardCell(
    Position position,
    double cellSize,
    AppLocalizations localizations,
  ) {
    GameBoard board = gameController.board;
    Piece? piece = board.getPiece(position);
    bool isSelected = gameController.selectedPosition == position;
    bool isValidMove = validMoves.contains(position);

    // Determine cell background color
    Color cellColor = _getCellBackgroundColor(position);

    // Add highlight for valid moves
    if (isValidMove) {
      cellColor = cellColor.withOpacity(0.7);
    }

    return GestureDetector(
      key: Key('cell_${position.column}_${position.row}'),
      onTap: () => onPositionTap(position),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(
            color: UIConstants.cellBorderColor.withOpacity(
              UIConstants.cellBorderWidth,
            ),
          ),
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
                size: cellSize, // Pass the cell size to the PieceWidget
                displayFormat: displayFormat, // Pass the display format
                animalName: _getLocalizedAnimalName(
                  localizations,
                  piece.animalType,
                ),
              )
            // Empty cell
            else
              Container(color: Colors.transparent),

            // Valid move indicator
            if (isValidMove && piece == null)
              Container(
                width: cellSize * UIConstants.validMoveIndicatorSizeFactor,
                height: cellSize * UIConstants.validMoveIndicatorSizeFactor,
                decoration: const BoxDecoration(
                  color: UIConstants.validMoveIndicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
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

  /// Get background color for a cell based on its type
  Color _getCellBackgroundColor(Position position) {
    GameBoard board = gameController.board;

    // Dens
    if (board.isDen(position)) {
      return board.getZoneOwner(position) == PlayerColor.green
          ? UIConstants.greenDenColor
          : UIConstants.redDenColor;
    }

    // Traps
    if (board.isTrap(position)) {
      return board.getZoneOwner(position) == PlayerColor.green
          ? UIConstants.greenTrapColor
          : UIConstants.redTrapColor;
    }

    // Rivers
    if (board.isRiver(position)) {
      return UIConstants.riverColor;
    }

    // Regular cells
    return UIConstants.boardBackgroundColor;
  }

  /// Build indicator for den cells
  Widget _buildDenIndicator(Position position) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: UIConstants.denBorderColor,
          width: UIConstants.boardBorderWidth,
        ),
        borderRadius: BorderRadius.circular(UIConstants.denBorderRadius),
      ),
      child: const Center(
        child: Icon(
          Icons.home,
          color: UIConstants.denIconColor,
          size: UIConstants.denIconSize,
        ),
      ),
    );
  }

  /// Build indicator for trap cells
  Widget _buildTrapIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: UIConstants.trapBorderColor,
          width: UIConstants.boardBorderWidth,
        ),
        borderRadius: BorderRadius.circular(UIConstants.trapBorderRadius),
      ),
      child: const Center(
        child: Icon(
          Icons.warning,
          color: UIConstants.trapIconColor,
          size: UIConstants.trapIconSize,
        ),
      ),
    );
  }

  /// Build indicator for river cells
  Widget _buildRiverIndicator() {
    return const Center(
      child: Icon(
        Icons.water_drop,
        color: UIConstants.riverIconColor,
        size: UIConstants.riverIconSize,
      ),
    );
  }
}
