class Position {
  final int column;
  final int row;

  Position(this.column, this.row);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Position && other.column == column && other.row == row;
  }

  @override
  int get hashCode => Object.hash(column, row);

  @override
  String toString() => 'Position($column, $row)';

  /// Check if position is within board boundaries (7 columns × 9 rows)
  bool get isValid => column >= 0 && column < 7 && row >= 0 && row < 9;

  /// Get adjacent positions (up, down, left, right)
  List<Position> get adjacentPositions {
    return [
      Position(column, row - 1), // Up
      Position(column, row + 1), // Down
      Position(column - 1, row), // Left
      Position(column + 1, row), // Right
    ].where((position) => position.isValid).toList();
  }
}
