import 'package:flutter/material.dart';
import 'package:animal_chess/models/player_color.dart';
import 'package:animal_chess/main.dart';

class PlayerIndicatorWidget extends StatelessWidget {
  final PlayerColor player;
  final String label;
  final bool isActive;
  final Language currentLanguage;

  const PlayerIndicatorWidget({
    super.key,
    required this.player,
    required this.label,
    required this.isActive,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    Color color = player == PlayerColor.green ? Colors.green : Colors.red;
    Color backgroundColor = isActive
        ? color.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
