import 'package:animal_chess/models/piece_display_format.dart';

class GameConfig {
  bool ratOnlyDenEntry;
  bool extendedLionTigerJumps;
  bool dogRiverVariant;
  bool ratCannotCaptureElephant;
  PieceDisplayFormat pieceDisplayFormat;

  GameConfig({
    this.ratOnlyDenEntry = false,
    this.extendedLionTigerJumps = false,
    this.dogRiverVariant = false,
    this.ratCannotCaptureElephant = false,
    this.pieceDisplayFormat = PieceDisplayFormat.traditionalChinese,
  });

  GameConfig copyWith({
    bool? ratOnlyDenEntry,
    bool? extendedLionTigerJumps,
    bool? dogRiverVariant,
    bool? ratCannotCaptureElephant,
    PieceDisplayFormat? pieceDisplayFormat,
  }) {
    return GameConfig(
      ratOnlyDenEntry: ratOnlyDenEntry ?? this.ratOnlyDenEntry,
      extendedLionTigerJumps:
          extendedLionTigerJumps ?? this.extendedLionTigerJumps,
      dogRiverVariant: dogRiverVariant ?? this.dogRiverVariant,
      ratCannotCaptureElephant:
          ratCannotCaptureElephant ?? this.ratCannotCaptureElephant,
      pieceDisplayFormat: pieceDisplayFormat ?? this.pieceDisplayFormat,
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
        other.pieceDisplayFormat == pieceDisplayFormat;
  }

  @override
  int get hashCode => Object.hash(
    ratOnlyDenEntry,
    extendedLionTigerJumps,
    dogRiverVariant,
    ratCannotCaptureElephant,
    pieceDisplayFormat,
  );
}
