import 'package:flutter/material.dart';

class UIConstants {
  // Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFFF44336);
  static const Color boardBackgroundColor = Color(0xFFFFF8E1);
  static const Color riverColor = Color(0xFFBBDEFB);
  static const Color greenDenColor = Color(0xFFC8E6C9);
  static const Color redDenColor = Color(0xFFFFCDD2);
  static const Color greenTrapColor = Color(0xFFC8E6C9);
  static const Color redTrapColor = Color(0xFFFFCDD2);
  static const Color boardBorderColor = Colors.brown;
  static const Color cellBorderColor = Colors.brown;
  static const Color validMoveIndicatorColor = Colors.green;
  static const Color denBorderColor = Colors.brown;
  static const Color denIconColor = Colors.brown;
  static const Color trapBorderColor = Colors.orange;
  static const Color trapIconColor = Colors.orange;
  static const Color riverIconColor = Colors.blue;
  static const Color greenPieceColor = Color(0xFF81C784);
  static const Color redPieceColor = Color(0xFFE57373);
  static const Color darkGreenPieceColor = Color(
    0xFF0C3F10,
  ); // Darker green for green's turn
  static const Color darkRedPieceColor = Color(
    0xFF331F1F,
  ); // Darker red for red's turn
  static const Color pieceTextColor = Colors.white;
  static const Color rankDisplayBackgroundColor = Color(0xFF424242);
  static const Color pieceBorderColorNormal = Colors.black;
  static const Color pieceBorderColorSelected = Colors.yellow;
  static const Color pieceShadowColor = Colors.black;
  static const double pieceShadowBlurRadius = 2.0;
  static const Offset pieceShadowOffset = Offset(1, 1);

  // Sizes
  static const double boardBorderWidth = 2.0;
  static const double cellBorderWidth = 0.3;
  static const double pieceBorderWidthNormal = 1.0;
  static const double pieceBorderWidthSelected = 3.0;
  static const double validMoveIndicatorSizeFactor = 0.3;
  static const double pieceSizeFactor = 0.9;
  static const double pieceFontSizeFactor = 0.450; // Reduced by 5% from 0.5
  static const double pieceTapPadding =
      12.0; // Padding for better touch targets

  // Border Radius
  static const double denBorderRadius = 8.0;
  static const double trapBorderRadius = 4.0;
  static const double pieceBorderRadius = 20.0;

  // Padding & Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double pieceIndicatorSize = 20.0;
  static const double pieceIndicatorSpacing = 8.0;

  // Font Sizes
  static const double titleFontSize = 32.0;
  static const double buttonFontSize = 24.0;
  static const double boardFontSize = 16.0;
  static const double statusFontSize = 18.0;
  static const double rankListFontSize = 12.0;

  // Icon Sizes
  static const double denIconSize = 20.0;
  static const double trapIconSize = 16.0;
  static const double riverIconSize = 16.0;
  static const double buttonIconSize = 36.0;
}
