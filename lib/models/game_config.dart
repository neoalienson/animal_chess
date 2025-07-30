import 'package:flutter/foundation.dart';

class GameConfig {
  bool ratOnlyDenEntry;
  bool extendedLionTigerJumps;
  bool dogRiverVariant;
  bool ratCannotCaptureElephant;

  GameConfig({
    this.ratOnlyDenEntry = false,
    this.extendedLionTigerJumps = false,
    this.dogRiverVariant = false,
    this.ratCannotCaptureElephant = false,
  });

  GameConfig copyWith({
    bool? ratOnlyDenEntry,
    bool? extendedLionTigerJumps,
    bool? dogRiverVariant,
    bool? ratCannotCaptureElephant,
  }) {
    return GameConfig(
      ratOnlyDenEntry: ratOnlyDenEntry ?? this.ratOnlyDenEntry,
      extendedLionTigerJumps: extendedLionTigerJumps ?? this.extendedLionTigerJumps,
      dogRiverVariant: dogRiverVariant ?? this.dogRiverVariant,
      ratCannotCaptureElephant: ratCannotCaptureElephant ?? this.ratCannotCaptureElephant,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig &&
        other.ratOnlyDenEntry == ratOnlyDenEntry &&
        other.extendedLionTigerJumps == extendedLionTigerJumps &&
        other.dogRiverVariant == dogRiverVariant &&
        other.ratCannotCaptureElephant == ratCannotCaptureElephant;
  }

  @override
  int get hashCode => Object.hash(
        ratOnlyDenEntry,
        extendedLionTigerJumps,
        dogRiverVariant,
        ratCannotCaptureElephant,
      );
}
