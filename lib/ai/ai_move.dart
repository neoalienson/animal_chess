import 'package:animal_chess/models/position.dart';

class Move {
  final Position from;
  final Position to;

  Move({required this.from, required this.to});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Move && other.from == from && other.to == to;
  }

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() {
    return 'Move(from: $from, to: $to)';
  }
}
