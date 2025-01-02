import 'package:drift/drift.dart';

// Tương ứng với bảng BaseMoves
class BaseMoves extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get notation => text()();
  IntColumn get evaluation => integer()();
  TextColumn get fen => text()();
  IntColumn get depth => integer()();
  DateTimeColumn get sync => dateTime().nullable()();
}

// Tương ứng với bảng Games
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get whitePlayer => text().nullable()();
  TextColumn get blackPlayer => text().nullable()();
  TextColumn get result => textEnum<GameResult>()();
}

// Enum cho kết quả ván cờ
enum GameResult {
  whiteWin('1-0'),
  blackWin('0-1'),
  draw('1/2-1/2'),
  inProgress('*');

  final String value;
  const GameResult(this.value);
}

// Tương ứng với bảng GameMoves
class GameMoves extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(Games, #id)();
  IntColumn get moveNumber => integer()();
  IntColumn get baseMoveId => integer().references(BaseMoves, #id)();
  IntColumn get parentMoveId => integer().nullable().references(GameMoves, #id)();
}