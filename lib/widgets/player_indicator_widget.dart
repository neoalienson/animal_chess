import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/constants/ui_constants.dart';

class PlayerIndicatorWidget extends StatelessWidget {
  final PlayerColor player;
  final String label;
  final bool isActive;

  const PlayerIndicatorWidget({
    super.key,
    required this.player,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    Color color = player == PlayerColor.green
        ? UIConstants.greenPieceColor
        : UIConstants.redPieceColor;
    Color backgroundColor = isActive
        ? color.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding,
        vertical: UIConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(UIConstants.pieceBorderRadius),
        border: Border.all(color: color, width: UIConstants.boardBorderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: UIConstants.pieceIndicatorSize,
            height: UIConstants.pieceIndicatorSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: UIConstants.pieceIndicatorSpacing),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? color : Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
