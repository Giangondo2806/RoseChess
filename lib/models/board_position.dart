class BoardPosition {
  final String notation;

  const BoardPosition(this.notation);

  // Convert notation to row and column
  int get row {
    return 9 - int.parse(notation[1]);
  }

  int get col {
    return notation.codeUnitAt(0) - 'a'.codeUnitAt(0);
  }

  @override
  bool operator ==(Object other) {
    return other is BoardPosition && notation == other.notation;
  }

  @override
  int get hashCode => notation.hashCode;
}