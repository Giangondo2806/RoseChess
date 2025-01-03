import 'package:drift/drift.dart';
import 'package:rose_chess/database/database.dart';

class ChessRepository {
  final RoseDatabase db;

  ChessRepository(this.db);

  // --- BaseMoves ---

// ... (Phần còn lại của code như database, table definition) ...

Future<void> insertOrUpdateBaseMove(BaseMovesCompanion move) async {
  // Lấy depth từ move mới
  final newDepth = move.depth.value;
  final newNotation = move.notation.value;
  final newFen = move.fen.value;

  // Tìm bản ghi hiện tại với cùng notation và fen
  final existingMove = await (db.select(db.baseMoves)
    ..where((t) => t.notation.equals(newNotation) & t.fen.equals(newFen)))
    .getSingleOrNull();

  if (existingMove == null || existingMove.depth  < (newDepth)) {
    // Nếu không tồn tại hoặc depth mới lớn hơn thì mới update
    await db.into(db.baseMoves).insertOnConflictUpdate(move);
  }
}

  Future<BaseMove?> getBaseMoveByFen(String fen) {
    final query = db.select(db.baseMoves)..where((t) => t.fen.equals(fen));
    return query.getSingleOrNull();
  }

  Future<List<BaseMove>> getAllBaseMoves() => db.select(db.baseMoves).get();

  // --- Games ---

  Future<int> insertGame(GamesCompanion game) => db.into(db.games).insert(game);

  Future<Game> getGameById(int gameId) {
    final query = db.select(db.games)..where((t) => t.id.equals(gameId));
    return query.getSingle();
  }

  Future<List<Game>> getAllGames() => db.select(db.games).get();

  Future<void> updateGame(Game game) => db.update(db.games).replace(game);

  // --- GameMoves ---

  Future<int> insertGameMove(GameMovesCompanion gameMove) =>
      db.into(db.gameMoves).insert(gameMove);

  // Lấy tất cả nước đi của một ván cờ, bao gồm thông tin từ BaseMoves
  Future<List<GameMoveWithBaseMove>> getMovesForGame(int gameId) async {
    final query = db.select(db.gameMoves).join([
      innerJoin(
          db.baseMoves, db.baseMoves.id.equalsExp(db.gameMoves.baseMoveId))
    ])
      ..where(db.gameMoves.gameId.equals(gameId))
      ..orderBy([OrderingTerm(expression: db.gameMoves.moveNumber)]);

    return query.map((row) {
      return GameMoveWithBaseMove(
        gameMove: row.readTable(db.gameMoves),
        baseMove: row.readTable(db.baseMoves),
      );
    }).get();
  }

  // Lấy các nước đi con (các nhánh)
  Future<List<GameMove>> getChildMoves(int parentMoveId) {
    final query = db.select(db.gameMoves)
      ..where((t) => t.parentMoveId.equals(parentMoveId));
    return query.get();
  }

  // Lấy nước đi cha của nước đi hiện tại
  Future<GameMove?> getParentMove(int currentMoveId) {
    final query = db.select(db.gameMoves)
      ..where((t) => t.id.equals(currentMoveId));
    return query.getSingleOrNull();
  }

  // Lấy đường đi từ nước đi đầu tiên đến một nước đi cụ thể
  Future<List<GameMoveWithBaseMove>> getMovePath(int gameMoveId) async {
    final List<GameMoveWithBaseMove> path = [];
    GameMove? currentMove = await (db.select(db.gameMoves)
          ..where((t) => t.id.equals(gameMoveId)))
        .getSingleOrNull();

    while (currentMove != null) {
      final baseMove = await (db.select(db.baseMoves)
            ..where((t) => t.id.equals(currentMove!.baseMoveId)))
          .getSingle();
      path.insert(
          0, GameMoveWithBaseMove(gameMove: currentMove, baseMove: baseMove));

      currentMove = await getParentMove(
          currentMove.parentMoveId ?? -1); // Handle potential null
    }

    return path;
  }

  // --- Các hàm tiện ích ---
  // Tìm các ván cờ có một nước đi cụ thể
  Future<List<Game>> getGamesWithMove(String fen) async {
    final baseMove = await getBaseMoveByFen(fen);
    if (baseMove == null) return [];

    final query = db.select(db.games).join([
      innerJoin(db.gameMoves, db.gameMoves.gameId.equalsExp(db.games.id)),
      innerJoin(
          db.baseMoves, db.baseMoves.id.equalsExp(db.gameMoves.baseMoveId)),
    ])
      ..where(db.baseMoves.id.equals(baseMove.id));

    return query.map((row) => row.readTable(db.games)).get();
  }

  // Lấy các nước đi phổ biến nhất
  Future<List<BaseMoveWithCount>> getMostCommonMoves(int limit) {
    final moveCount =
        db.gameMoves.baseMoveId.count(filter: db.baseMoves.id.isNotNull());

    final query = db.selectOnly(db.baseMoves)
      ..addColumns([
        db.baseMoves.notation,
        db.baseMoves.evaluation,
        db.baseMoves.fen,
        moveCount
      ])
      ..join([
        innerJoin(
            db.gameMoves, db.gameMoves.baseMoveId.equalsExp(db.baseMoves.id))
      ])
      ..groupBy([db.baseMoves.id])
      ..orderBy([OrderingTerm(expression: moveCount, mode: OrderingMode.desc)])
      ..limit(limit);

    return query.map((row) {
      return BaseMoveWithCount(
        notation: row.read(db.baseMoves.notation) ?? '',
        evaluation: row.read(db.baseMoves.evaluation) ?? 0,
        fen: row.read(db.baseMoves.fen) ?? '',
        count: row.read(moveCount) ?? 0,
      );
    }).get();
  }
}

// Lớp hỗ trợ cho việc kết hợp GameMove và BaseMove
class GameMoveWithBaseMove {
  final GameMove gameMove;
  final BaseMove baseMove;

  GameMoveWithBaseMove({required this.gameMove, required this.baseMove});
}

// Lớp hỗ trợ cho việc đếm số lần xuất hiện của BaseMove
class BaseMoveWithCount {
  final String notation;
  final int evaluation;
  final String fen;
  final int count;

  BaseMoveWithCount({
    required this.notation,
    required this.evaluation,
    required this.fen,
    required this.count,
  });
}
