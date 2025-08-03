import 'package:animal_chess/models/piece_display_format.dart';

enum AIStrategyType { defensive, offensive, balanced, exploratory }

class GameConfig {
  bool ratOnlyDenEntry;
  bool extendedLionTigerJumps;
  bool dogRiverVariant;
  bool ratCannotCaptureElephant;
  PieceDisplayFormat pieceDisplayFormat;

  // AI player configuration
  bool aiGreen;
  bool aiRed;
  AIStrategyType aiGreenStrategy;
  AIStrategyType aiRedStrategy;

  GameConfig({
    this.ratOnlyDenEntry = false,
    this.extendedLionTigerJumps = false,
    this.dogRiverVariant = false,
    this.ratCannotCaptureElephant = false,
    this.pieceDisplayFormat = PieceDisplayFormat.traditionalChinese,
    this.aiGreen = false,
    this.aiRed = false,
    this.aiGreenStrategy = AIStrategyType.offensive,
    this.aiRedStrategy = AIStrategyType.offensive,
  });

  GameConfig copyWith({
    bool? ratOnlyDenEntry,
    bool? extendedLionTigerJumps,
    bool? dogRiverVariant,
    bool? ratCannotCaptureElephant,
    PieceDisplayFormat? pieceDisplayFormat,
    bool? aiGreen,
    bool? aiRed,
    AIStrategyType? aiGreenStrategy,
    AIStrategyType? aiRedStrategy,
  }) {
    return GameConfig(
      ratOnlyDenEntry: ratOnlyDenEntry ?? this.ratOnlyDenEntry,
      extendedLionTigerJumps:
          extendedLionTigerJumps ?? this.extendedLionTigerJumps,
      dogRiverVariant: dogRiverVariant ?? this.dogRiverVariant,
      ratCannotCaptureElephant:
          ratCannotCaptureElephant ?? this.ratCannotCaptureElephant,
      pieceDisplayFormat: pieceDisplayFormat ?? this.pieceDisplayFormat,
      aiGreen: aiGreen ?? this.aiGreen,
      aiRed: aiRed ?? this.aiRed,
      aiGreenStrategy: aiGreenStrategy ?? this.aiGreenStrategy,
      aiRedStrategy: aiRedStrategy ?? this.aiRedStrategy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig &&
        other.ratOnlyDenEntry == ratOnlyDenEntry &&
        other.extendedLionTigerJumps == extendedLionTigerJumps &&
        other.dogRiverVariant == dogRiverVariant &&
        other.ratCannotCaptureElephant == ratCannotCaptureElephant &&
        other.pieceDisplayFormat == pieceDisplayFormat &&
        other.aiGreen == aiGreen &&
        other.aiRed == aiRed &&
        other.aiGreenStrategy == aiGreenStrategy &&
        other.aiRedStrategy == aiRedStrategy;
  }

  @override
  int get hashCode => Object.hash(
    ratOnlyDenEntry,
    extendedLionTigerJumps,
    dogRiverVariant,
    ratCannotCaptureElephant,
    pieceDisplayFormat,
    aiGreen,
    aiRed,
    aiGreenStrategy,
    aiRedStrategy,
  );
}
