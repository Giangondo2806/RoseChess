enum Color { b, r }

enum PawnType { p }

enum ExcludePawnType { c, r, n, b, a, k }

typedef PieceType = dynamic; // Union type not directly supported, using dynamic

enum Square {
  a9,
  b9,
  c9,
  d9,
  e9,
  f9,
  g9,
  h9,
  i9,
  a8,
  b8,
  c8,
  d8,
  e8,
  f8,
  g8,
  h8,
  i8,
  a7,
  b7,
  c7,
  d7,
  e7,
  f7,
  g7,
  h7,
  i7,
  a6,
  b6,
  c6,
  d6,
  e6,
  f6,
  g6,
  h6,
  i6,
  a5,
  b5,
  c5,
  d5,
  e5,
  f5,
  g5,
  h5,
  i5,
  a4,
  b4,
  c4,
  d4,
  e4,
  f4,
  g4,
  h4,
  i4,
  a3,
  b3,
  c3,
  d3,
  e3,
  f3,
  g3,
  h3,
  i3,
  a2,
  b2,
  c2,
  d2,
  e2,
  f2,
  g2,
  h2,
  i2,
  a1,
  b1,
  c1,
  d1,
  e1,
  f1,
  g1,
  h1,
  i1,
  a0,
  b0,
  c0,
  d0,
  e0,
  f0,
  g0,
  h0,
  i0
}

enum FlagKeys { NORMAL, CAPTURE }

class Piece {
  PieceType type;
  Color color;

  Piece({required this.type, required this.color});
}

class Move {
  int? moveNumber;
  Color color;
  int from;
  int to;
  int flags;
  PieceType piece;
  PieceType? captured;
  String? fen;
  String? iccs;

  Move({
    this.moveNumber,
    required this.color,
    required this.from,
    required this.to,
    required this.flags,
    required this.piece,
    this.captured,
    this.fen,
    this.iccs,
  });
}

class HistoryMove {
  Move move;
  Map<Color, int> kings;
  Color turn;

  HistoryMove({required this.move, required this.kings, required this.turn});
}

class ValidationResult {
  bool valid;
  int errorNumber;
  String error;

  ValidationResult(
      {required this.valid, required this.errorNumber, required this.error});
}

/**
 *  thư viện chứa logic cờ tướng, dùng để check rule và tạo fen sau các nước đi
 */

class Xiangqi {
  static const Color BLACK = Color.b;
  static const Color RED = Color.r;
  static const int EMPTY = -1;
  static const PieceType PAWN = PawnType.p;
  static const PieceType CANNON = ExcludePawnType.c;
  static const PieceType ROOK = ExcludePawnType.r;
  static const PieceType KNIGHT = ExcludePawnType.n;
  static const PieceType BISHOP = ExcludePawnType.b;
  static const PieceType ADVISER = ExcludePawnType.a;
  static const PieceType KING = ExcludePawnType.k;
  static const String SYMBOLS = 'pcrnbakPCRNBAK';
  static const String DEFAULT_POSITION =
      'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR r';
  static const List<String> POSSIBLE_RESULTS = ['1-0', '0-1', '1/2-1/2', '*'];
  static const Map<Color, List<int>> PAWN_OFFSETS = {
    Color.b: [0x10, -0x01, 0x01],
    Color.r: [-0x10, -0x01, 0x01]
  };

  static const Map<ExcludePawnType, List<int>> PIECE_OFFSETS = {
    ExcludePawnType.c: [-0x10, 0x10, -0x01, 0x01],
    ExcludePawnType.r: [-0x10, 0x10, -0x01, 0x01],
    ExcludePawnType.n: [
      -0x20 - 0x01,
      -0x20 + 0x01,
      0x20 - 0x01,
      0x20 + 0x01,
      -0x10 - 0x02,
      0x10 - 0x02,
      -0x10 + 0x02,
      0x10 + 0x02
    ],
    ExcludePawnType.b: [-0x20 - 0x02, 0x20 + 0x02, 0x20 - 0x02, -0x20 + 0x02],
    ExcludePawnType.a: [-0x10 - 0x01, 0x10 + 0x01, 0x10 - 0x01, -0x10 + 0x01],
    ExcludePawnType.k: [-0x10, 0x10, -0x01, 0x01],
  };

  static final Map<String, Square> _stringToEnumMap = {
    'a9': Square.a9,
    'b9': Square.b9,
    'c9': Square.c9,
    'd9': Square.d9,
    'e9': Square.e9,
    'f9': Square.f9,
    'g9': Square.g9,
    'h9': Square.h9,
    'i9': Square.i9,
    'a8': Square.a8,
    'b8': Square.b8,
    'c8': Square.c8,
    'd8': Square.d8,
    'e8': Square.e8,
    'f8': Square.f8,
    'g8': Square.g8,
    'h8': Square.h8,
    'i8': Square.i8,
    'a7': Square.a7,
    'b7': Square.b7,
    'c7': Square.c7,
    'd7': Square.d7,
    'e7': Square.e7,
    'f7': Square.f7,
    'g7': Square.g7,
    'h7': Square.h7,
    'i7': Square.i7,
    'a6': Square.a6,
    'b6': Square.b6,
    'c6': Square.c6,
    'd6': Square.d6,
    'e6': Square.e6,
    'f6': Square.f6,
    'g6': Square.g6,
    'h6': Square.h6,
    'i6': Square.i6,
    'a5': Square.a5,
    'b5': Square.b5,
    'c5': Square.c5,
    'd5': Square.d5,
    'e5': Square.e5,
    'f5': Square.f5,
    'g5': Square.g5,
    'h5': Square.h5,
    'i5': Square.i5,
    'a4': Square.a4,
    'b4': Square.b4,
    'c4': Square.c4,
    'd4': Square.d4,
    'e4': Square.e4,
    'f4': Square.f4,
    'g4': Square.g4,
    'h4': Square.h4,
    'i4': Square.i4,
    'a3': Square.a3,
    'b3': Square.b3,
    'c3': Square.c3,
    'd3': Square.d3,
    'e3': Square.e3,
    'f3': Square.f3,
    'g3': Square.g3,
    'h3': Square.h3,
    'i3': Square.i3,
    'a2': Square.a2,
    'b2': Square.b2,
    'c2': Square.c2,
    'd2': Square.d2,
    'e2': Square.e2,
    'f2': Square.f2,
    'g2': Square.g2,
    'h2': Square.h2,
    'i2': Square.i2,
    'a1': Square.a1,
    'b1': Square.b1,
    'c1': Square.c1,
    'd1': Square.d1,
    'e1': Square.e1,
    'f1': Square.f1,
    'g1': Square.g1,
    'h1': Square.h1,
    'i1': Square.i1,
    'a0': Square.a0,
    'b0': Square.b0,
    'c0': Square.c0,
    'd0': Square.d0,
    'e0': Square.e0,
    'f0': Square.f0,
    'g0': Square.g0,
    'h0': Square.h0,
    'i0': Square.i0,
  };

  static const Map<FlagKeys, String> FLAGS = {
    FlagKeys.NORMAL: 'n',
    FlagKeys.CAPTURE: 'c',
  };

  static const Map<FlagKeys, int> BITS = {
    FlagKeys.NORMAL: 1,
    FlagKeys.CAPTURE: 2,
  };

  static const Map<Square, int> SQUARES = {
    Square.a9: 0x00,
    Square.b9: 0x01,
    Square.c9: 0x02,
    Square.d9: 0x03,
    Square.e9: 0x04,
    Square.f9: 0x05,
    Square.g9: 0x06,
    Square.h9: 0x07,
    Square.i9: 0x08,
    Square.a8: 0x10,
    Square.b8: 0x11,
    Square.c8: 0x12,
    Square.d8: 0x13,
    Square.e8: 0x14,
    Square.f8: 0x15,
    Square.g8: 0x16,
    Square.h8: 0x17,
    Square.i8: 0x18,
    Square.a7: 0x20,
    Square.b7: 0x21,
    Square.c7: 0x22,
    Square.d7: 0x23,
    Square.e7: 0x24,
    Square.f7: 0x25,
    Square.g7: 0x26,
    Square.h7: 0x27,
    Square.i7: 0x28,
    Square.a6: 0x30,
    Square.b6: 0x31,
    Square.c6: 0x32,
    Square.d6: 0x33,
    Square.e6: 0x34,
    Square.f6: 0x35,
    Square.g6: 0x36,
    Square.h6: 0x37,
    Square.i6: 0x38,
    Square.a5: 0x40,
    Square.b5: 0x41,
    Square.c5: 0x42,
    Square.d5: 0x43,
    Square.e5: 0x44,
    Square.f5: 0x45,
    Square.g5: 0x46,
    Square.h5: 0x47,
    Square.i5: 0x48,
    Square.a4: 0x50,
    Square.b4: 0x51,
    Square.c4: 0x52,
    Square.d4: 0x53,
    Square.e4: 0x54,
    Square.f4: 0x55,
    Square.g4: 0x56,
    Square.h4: 0x57,
    Square.i4: 0x58,
    Square.a3: 0x60,
    Square.b3: 0x61,
    Square.c3: 0x62,
    Square.d3: 0x63,
    Square.e3: 0x64,
    Square.f3: 0x65,
    Square.g3: 0x66,
    Square.h3: 0x67,
    Square.i3: 0x68,
    Square.a2: 0x70,
    Square.b2: 0x71,
    Square.c2: 0x72,
    Square.d2: 0x73,
    Square.e2: 0x74,
    Square.f2: 0x75,
    Square.g2: 0x76,
    Square.h2: 0x77,
    Square.i2: 0x78,
    Square.a1: 0x80,
    Square.b1: 0x81,
    Square.c1: 0x82,
    Square.d1: 0x83,
    Square.e1: 0x84,
    Square.f1: 0x85,
    Square.g1: 0x86,
    Square.h1: 0x87,
    Square.i1: 0x88,
    Square.a0: 0x90,
    Square.b0: 0x91,
    Square.c0: 0x92,
    Square.d0: 0x93,
    Square.e0: 0x94,
    Square.f0: 0x95,
    Square.g0: 0x96,
    Square.h0: 0x97,
    Square.i0: 0x98,
  };

  List<Piece?> board = List<Piece?>.filled(256, null);
  Map<Color, int> kings = {Color.r: Xiangqi.EMPTY, Color.b: Xiangqi.EMPTY};
  Color turn = Xiangqi.RED;
  // int half_moves = 0;
  // int move_number = 1;
  List<HistoryMove> history = [];
  List<Move> futures = [];
  Map<String, String> header = {};
  int moveNumber = 0;

  Xiangqi({String? fen}) {
    if (fen == null) {
      load(Xiangqi.DEFAULT_POSITION);
    } else {
      load(fen);
    }
  }

  Color getCurrentTurn() {
    return turn;
  }

  void clear({bool keepHeaders = false}) {
    board = List<Piece?>.filled(256, null);
    kings = {Color.r: Xiangqi.EMPTY, Color.b: Xiangqi.EMPTY};
    turn = Xiangqi.RED;
    history = [];
    futures = [];
    if (!keepHeaders) header = {};
    updateSetup(generateFen());
  }

  void reset() {
    load(Xiangqi.DEFAULT_POSITION);
  }

  Square squareToEnum(int square) {
    return Xiangqi.SQUARES.keys
        .firstWhere((key) => Xiangqi.SQUARES[key] == square);
  }

  int squareTextToIndex(String text) {
    if (text.length != 2) {
      return -1; // Hoặc giá trị nào đó để chỉ ra lỗi
    }
    int file = text.codeUnitAt(0) - 'a'.codeUnitAt(0);
    int rank = 9 - int.parse(text[1]);
    return rank * 9 + file;
  }

  bool load(String fen, {bool keepHeaders = false}) {
    if (!validateFen(fen).valid) {
      return false;
    }
    clear(keepHeaders: false);
    final tokens = fen.split(RegExp(r'\s+'));
    final position = tokens[0];
    int file = 0;
    int rank = 9;

    for (int i = 0; i < position.length; ++i) {
      final piece = position[i];

      if (piece == '/') {
        file = 0;
        rank--;
      } else if (isDigit(piece)) {
        file += int.parse(piece);
      } else {
        final color =
            piece.toUpperCase() == piece ? Xiangqi.RED : Xiangqi.BLACK;
        final sq = algebraicToEnum('${"abcdefghi"[file]}$rank');

        put(
            Piece(
                type: getPieceTypeFromSymbol(piece.toLowerCase()),
                color: color),
            sq!);

        file++;
      }
    }

    turn = (tokens[1] == 'b' || tokens[1] == 'w') ? Xiangqi.BLACK : Xiangqi.RED;
    moveNumber = turn == Color.b ? 1 : 0;

    updateSetup(generateFen());

    return true;
  }

  ValidationResult validateFen(String fen) {
    final errors = {
      0: 'No errors.',
      1: 'FEN string must contain six space-delimited fields.',
      2: '6th field (move number) must be a positive integer.',
      3: '5th field (half move counter) must be a non-negative integer.',
      4: "4th field (en-passant square) should be '-'.",
      5: "3rd field (castling availability) should be '-'.",
      6: '2nd field (side to move) is invalid.',
      7: "1st field (piece positions) does not contain 10 '/'-delimited rows.",
      8: '1st field (piece positions) is invalid [consecutive numbers].',
      9: '1st field (piece positions) is invalid [invalid piece].',
      10: '1st field (piece positions) is invalid [row too large].',
      11: '1st field (piece positions) is invalid [each side has one king].',
      12: '1st field (piece positions) is invalid [each side has no more than 2 advisers].',
      13: '1st field (piece positions) is invalid [each side has no more than 2 bishops].',
      14: '1st field (piece positions) is invalid [each side has no more than 2 knights].',
      15: '1st field (piece positions) is invalid [each side has no more than 2 rooks].',
      16: '1st field (piece positions) is invalid [each side has no more than 2 cannons].',
      17: '1st field (piece positions) is invalid [each side has no more than 5 pawns].',
      18: '1st field (piece positions) is invalid [black king should at right position].',
      19: '1st field (piece positions) is invalid [red king should at right position].',
      20: '1st field (piece positions) is invalid [black adviser should at right position].',
      21: '1st field (piece positions) is invalid [red adviser should at right position].',
      22: '1st field (piece positions) is invalid [black bishop should at right position].',
      23: '1st field (piece positions) is invalid [red bishop should at right position].',
      24: '1st field (piece positions) is invalid [black pawn should at right position].',
      25: '1st field (piece positions) is invalid [red pawn should at right position].',
    };

    ValidationResult result(int errNum) {
      return ValidationResult(
          valid: errNum == 0, errorNumber: errNum, error: errors[errNum]!);
    }

    final tokens = fen.split(RegExp(r'\s+'));
    if (tokens.length < 2) {
      return result(1);
    }

    if (!RegExp(r'^([rwb])$').hasMatch(tokens[1])) {
      return result(6);
    }

    final rows = tokens[0].split('/');
    if (rows.length != 10) {
      return result(7);
    }

    final Map<String, Map<String, dynamic>> pieces = {
      'p': {'number': 0, 'squares': <int>[]},
      'P': {'number': 0, 'squares': <int>[]},
      'c': {'number': 0, 'squares': <int>[]},
      'C': {'number': 0, 'squares': <int>[]},
      'r': {'number': 0, 'squares': <int>[]},
      'R': {'number': 0, 'squares': <int>[]},
      'n': {'number': 0, 'squares': <int>[]},
      'N': {'number': 0, 'squares': <int>[]},
      'b': {'number': 0, 'squares': <int>[]},
      'B': {'number': 0, 'squares': <int>[]},
      'a': {'number': 0, 'squares': <int>[]},
      'A': {'number': 0, 'squares': <int>[]},
      'k': {'number': 0, 'squares': <int>[]},
      'K': {'number': 0, 'squares': <int>[]},
    };

    for (int i = 0; i < rows.length; i++) {
      int sumFields = 0;
      bool previousWasNumber = false;

      for (int j = 0; j < rows[i].length; j++) {
        if (isDigit(rows[i][j])) {
          if (previousWasNumber) {
            return result(8);
          }
          sumFields += int.parse(rows[i][j]);
          previousWasNumber = true;
        } else {
          try {
            pieces[rows[i][j]]!['number']++;
          } catch (e) {
            return result(9);
          }
          pieces[rows[i][j]]!['squares'].add((i << 4) | sumFields);
          sumFields += 1;
          previousWasNumber = false;
        }
      }
      if (sumFields != 9) {
        return result(10);
      }
    }

    if (pieces['k']!['number'] != 1 || pieces['K']!['number'] != 1) {
      return result(11);
    }
    if (pieces['a']!['number'] > 2 || pieces['A']!['number'] > 2) {
      return result(12);
    }
    if (pieces['b']!['number'] > 2 || pieces['B']!['number'] > 2) {
      return result(13);
    }
    if (pieces['n']!['number'] > 2 || pieces['N']!['number'] > 2) {
      return result(14);
    }
    if (pieces['r']!['number'] > 2 || pieces['R']!['number'] > 2) {
      return result(15);
    }
    if (pieces['c']!['number'] > 2 || pieces['C']!['number'] > 2) {
      return result(16);
    }
    if (pieces['p']!['number'] > 5 || pieces['P']!['number'] > 5) {
      return result(17);
    }

    if (outOfPlace(Xiangqi.KING, pieces['k']!['squares'][0], Xiangqi.BLACK)) {
      return result(18);
    }
    if (outOfPlace(Xiangqi.KING, pieces['K']!['squares'][0], Xiangqi.RED)) {
      return result(19);
    }
    for (int i = 0; i < pieces['a']!['squares'].length; ++i) {
      if (outOfPlace(
          Xiangqi.ADVISER, pieces['a']!['squares'][i], Xiangqi.BLACK)) {
        return result(20);
      }
    }
    for (int i = 0; i < pieces['A']!['squares'].length; ++i) {
      if (outOfPlace(
          Xiangqi.ADVISER, pieces['A']!['squares'][i], Xiangqi.RED)) {
        return result(21);
      }
    }
    for (int i = 0; i < pieces['b']!['squares'].length; ++i) {
      if (outOfPlace(
          Xiangqi.BISHOP, pieces['b']!['squares'][i], Xiangqi.BLACK)) {
        return result(22);
      }
    }
    for (int i = 0; i < pieces['B']!['squares'].length; ++i) {
      if (outOfPlace(Xiangqi.BISHOP, pieces['B']!['squares'][i], Xiangqi.RED)) {
        return result(23);
      }
    }
    for (int i = 0; i < pieces['p']!['squares'].length; ++i) {
      if (outOfPlace(Xiangqi.PAWN, pieces['p']!['squares'][i], Xiangqi.BLACK)) {
        return result(24);
      }
    }
    for (int i = 0; i < pieces['P']!['squares'].length; ++i) {
      if (outOfPlace(Xiangqi.PAWN, pieces['P']!['squares'][i], Xiangqi.RED)) {
        return result(25);
      }
    }

    return result(0);
  }

  String generateFen() {
    int empty = 0;
    String fen = '';

    for (int i = Xiangqi.SQUARES[Square.a9]!;
        i <= Xiangqi.SQUARES[Square.i0]!;
        ++i) {
      if (board[i] == null) {
        empty++;
      } else {
        if (empty > 0) {
          fen += empty.toString();
          empty = 0;
        }
        final color = board[i]!.color;
        final piece = board[i]!.type;

        fen += color == Xiangqi.RED
            ? getPieceSymbol(piece).toUpperCase()
            : getPieceSymbol(piece).toLowerCase();
      }

      if (file(i) == 8) {
        if (empty > 0) {
          fen += empty.toString();
        }

        if (i != Xiangqi.SQUARES[Square.i0]) {
          fen += '/';
        }

        empty = 0;
        i += 0x07;
      }
    }

    // Thêm moveNumber và các thông số khác vào chuỗi FEN
    return [fen, turn == Color.r ? 'w' : 'b'].join(' ');
  }

  Map<String, String> setHeader(List<String> args) {
    for (int i = 0; i < args.length; i += 2) {
      if (i + 1 < args.length && args[i] is String && args[i + 1] is String) {
        header[args[i]] = args[i + 1];
      }
    }
    return header;
  }

  void updateSetup(String fen) {
    if (history.isNotEmpty) return;

    if (fen != Xiangqi.DEFAULT_POSITION) {
      header['FEN'] = fen;
    } else {
      header.remove('FEN');
    }
  }

  Piece? get(Square square) {
    final piece = board[Xiangqi.SQUARES[square]!];
    return piece != null ? Piece(type: piece.type, color: piece.color) : null;
  }

  bool put(Piece piece, Square square) {
    // ignore: unnecessary_null_comparison
    if (piece.type == null || piece.color == null) {
      return false;
    }

    if (!Xiangqi.SQUARES.containsKey(square)) {
      return false;
    }

    final sq = Xiangqi.SQUARES[square]!;

    if (piece.type == Xiangqi.KING &&
        !(kings[piece.color] == Xiangqi.EMPTY || kings[piece.color] == sq)) {
      return false;
    }

    if (outOfPlace(piece.type, sq, piece.color)) {
      return false;
    }

    board[sq] = Piece(type: piece.type, color: piece.color);
    if (piece.type == Xiangqi.KING) {
      kings[piece.color] = sq;
    }

    updateSetup(generateFen());

    return true;
  }

  Piece? remove(Square square) {
    final piece = get(square);
    board[Xiangqi.SQUARES[square]!] = null;
    if (piece != null && piece.type == Xiangqi.KING) {
      kings[piece.color] = Xiangqi.EMPTY;
    }

    updateSetup(generateFen());

    return piece;
  }

  Move buildMove(List<Piece?> board, int from, int to, int flags) {
    Move move = Move(
      color: turn,
      from: from,
      to: to,
      flags: flags,
      piece: board[from]!.type,
    );

    if (board[to] != null) {
      move.captured = board[to]!.type;
    }
    return move;
  }

  List<Move> generateMoves(
      {bool legal = true, Square? square, bool opponent = false}) {
    void addMove(
        List<Piece?> board, List<Move> moves, int from, int to, int flags) {
      moves.add(buildMove(board, from, to, flags));
    }

    List<Move> moves = [];
    Color us = turn;
    Color them = swapColor(us);

    int firstSq = Xiangqi.SQUARES[Square.a9]!;
    int lastSq = Xiangqi.SQUARES[Square.i0]!;

    if (square != null) {
      if (Xiangqi.SQUARES.containsKey(square)) {
        firstSq = lastSq = Xiangqi.SQUARES[square]!;
      } else {
        return [];
      }
    }

    if (opponent) {
      turn = swapColor(turn);
      us = turn;
      them = swapColor(us);
    }

    for (int i = firstSq; i <= lastSq; ++i) {
      final piece = board[i];
      if (piece == null || piece.color != us) continue;

      final List<int> offsets = (piece.type == Xiangqi.PAWN
          ? Xiangqi.PAWN_OFFSETS[us]!
          : Xiangqi.PIECE_OFFSETS[piece.type]!);

      for (int j = 0; j < offsets.length; ++j) {
        if (piece.type == Xiangqi.PAWN && j > 0 && !crossedRiver(i, us)) break;

        final offset = offsets[j];
        int square_ = i;
        bool crossed = false;

        while (true) {
          square_ += offset as int;

          if (outOfBoard(square_))
            break;
          else if (piece.type == Xiangqi.KNIGHT && hobblingHorseLeg(i, j))
            break;
          else if (piece.type == Xiangqi.BISHOP &&
              (blockingElephantEye(i, j) || crossedRiver(square_, us)))
            break;
          else if ((piece.type == Xiangqi.ADVISER ||
                  piece.type == Xiangqi.KING) &&
              outOfPlace(piece.type, square_, us)) break;

          if (board[square_] == null) {
            if (piece.type == Xiangqi.CANNON && crossed) continue;
            addMove(board, moves, i, square_, Xiangqi.BITS[FlagKeys.NORMAL]!);
          } else {
            if (piece.type == Xiangqi.CANNON) {
              if (crossed) {
                if (board[square_]!.color == them)
                  addMove(board, moves, i, square_,
                      Xiangqi.BITS[FlagKeys.CAPTURE]!);
                break;
              }
              crossed = true;
            } else {
              if (board[square_]!.color == them)
                addMove(
                    board, moves, i, square_, Xiangqi.BITS[FlagKeys.CAPTURE]!);
              break;
            }
          }
          if (piece.type != Xiangqi.CANNON && piece.type != Xiangqi.ROOK) break;
        }
      }

      if (file(i) >= 8) {
        i = i + 0x07;
      }
    }

    if (!legal) {
      return moves;
    }

    List<Move> legalMoves = [];
    for (int i = 0; i < moves.length; i++) {
      if (!kingAttacked(us)) {
        legalMoves.add(moves[i]);
      }
    }

    if (opponent) {
      turn = swapColor(turn);
    }

    return legalMoves;
  }

  String moveToIccs(Move move, {bool sloppy = false}) {
    return algebraic(move.from)! + algebraic(move.to)!;
  }

  String strippedIccs(String move) {
    return move
        .replaceAll(RegExp(r'='), '')
        .replaceAll(RegExp(r'[+#]?[?!]*\$'), '');
  }

  bool kingAttacked(Color us) {
    int square = kings[us]!;
    Color them = swapColor(us);

    for (int i = 0; i < Xiangqi.PIECE_OFFSETS[Xiangqi.KNIGHT]!.length; ++i) {
      int sq = square + Xiangqi.PIECE_OFFSETS[Xiangqi.KNIGHT]![i];
      // Kiểm tra sq có nằm trong bàn cờ không trước khi truy cập board[sq]
      if (!outOfBoard(sq) &&
          board[sq] != null &&
          board[sq]!.color == them &&
          board[sq]!.type == Xiangqi.KNIGHT &&
          !hobblingHorseLeg(sq, i < 4 ? 3 - i : 11 - i)) {
        return true;
      }
    }

    for (int i = 0; i < Xiangqi.PIECE_OFFSETS[Xiangqi.ROOK]!.length; ++i) {
      int offset = Xiangqi.PIECE_OFFSETS[Xiangqi.ROOK]![i];
      bool crossed = false;
      for (int sq = square + offset; !outOfBoard(sq); sq += offset) {
        Piece? piece = board[sq];
        if (piece != null) {
          if (piece.color == them) {
            if (crossed) {
              if (piece.type == Xiangqi.CANNON) return true;
            } else {
              if (piece.type == Xiangqi.ROOK || piece.type == Xiangqi.KING)
                return true;
            }
          }
          if (crossed)
            break;
          else
            crossed = true;
        }
      }
    }

    for (int i = 0; i < Xiangqi.PAWN_OFFSETS[them]!.length; ++i) {
      int sq = square - Xiangqi.PAWN_OFFSETS[them]![i];
      if (board[sq] != null &&
          !outOfBoard(sq) &&
          board[sq]!.color == them &&
          board[sq]!.type == Xiangqi.PAWN) return true;
    }

    return false;
  }

  bool inCheck() {
    return kingAttacked(turn);
  }

  bool inCheckmate() {
    return inCheck() && generateMoves().isEmpty;
  }

  bool inStalemate() {
    return !inCheck() && generateMoves().isEmpty;
  }

  bool insufficientMaterial() {
    Map<PieceType, int> pieces = {};
    int numPieces = 0;

    for (Square sq in Xiangqi.SQUARES.keys) {
      Piece? piece = board[Xiangqi.SQUARES[sq]!];
      if (piece != null) {
        pieces[piece.type] = (pieces[piece.type] ?? 0) + 1;
        numPieces++;
      }
    }

    if (numPieces == 2)
      return true;
    else if (!pieces.containsKey(Xiangqi.KNIGHT) &&
        !pieces.containsKey(Xiangqi.ROOK) &&
        !pieces.containsKey(Xiangqi.CANNON) &&
        !pieces.containsKey(Xiangqi.PAWN)) {
      return true;
    }

    return false;
  }

  // bool inThreefoldRepetition() {
  //   List<Move> moves = [];
  //   Map<String, int> positions = {};
  //   bool repetition = false;

  //   while (true) {
  //     // Move? move = undoMove();
  //     if (move == null) break;
  //     moves.add(move);
  //   }

  //   while (true) {
  //     String fen = generateFen().split(' ').sublist(0, 2).join('');

  //     positions[fen] = (positions[fen] ?? 0) + 1;
  //     if (positions[fen]! >= 3) {
  //       repetition = true;
  //     }

  //     if (moves.isEmpty) {
  //       break;
  //     }
  //     makeMove(moves.removeLast());
  //   }

  //   return repetition;
  // }

  void push(List list, Move? move) {
    list.add(HistoryMove(
      move: move!,
      kings: {Color.b: kings[Color.b]!, Color.r: kings[Color.r]!},
      turn: turn,
    ));
  }

  void makeMove(Move move, {String? from, String? to}) {
    if (move.iccs == null) return;

    final int moveFrom = Xiangqi.SQUARES[_stringToEnumMap[from]]!;
    final int moveTo = Xiangqi.SQUARES[_stringToEnumMap[to]]!;
    print(board[moveFrom]?.type);

    push(history, move);
    if (board[moveFrom] != null && board[moveTo]?.type == Xiangqi.KING) {
      kings[board[moveTo]!.color] = Xiangqi.EMPTY;
    }

    if (turn == Color.r) {
      moveNumber++;
    }

    if (board[moveFrom] != null) {
      board[moveTo] = board[moveFrom];
      board[moveFrom] = null;
    }

    // Kiểm tra board[move.to] trước khi truy cập type và color
    if (board[moveTo] != null && board[moveTo]?.type == Xiangqi.KING) {
      kings[board[moveTo]!.color] = moveTo;
    }

    turn = swapColor(turn);

    print(generateFen());
  }

  Move? setMove(dynamic old, {bool undo = true}) {
    if (old == null) {
      return null;
    }

    final Move move = old.move;
    kings = old.kings;
    turn = old.turn;

    board[move.from] = board[move.to];
    board[move.from]!.type = move.piece;
    board[move.to] = null;

    if ((move.flags & Xiangqi.BITS[FlagKeys.CAPTURE]!) > 0 && undo) {
      board[move.to] = Piece(type: move.captured!, color: swapColor(turn));
    }

    return move;
  }

  // Move? undoMove() {
  //   return setMove(history.isNotEmpty ? history.removeLast() : null);
  // }

  // Move? redoMove() {
  //   return setMove(futures.isNotEmpty ? futures.removeLast() : null,
  //       undo: false);
  // }

  String getDisambiguator(Move move, {bool sloppy = false}) {
    final moves = generateMoves(legal: !sloppy);

    final from = move.from;
    final to = move.to;
    final piece = move.piece;

    int ambiguities = 0;
    int sameRank = 0;
    int sameFile = 0;

    for (int i = 0; i < moves.length; i++) {
      final ambigFrom = moves[i].from;
      final ambigTo = moves[i].to;
      final ambigPiece = moves[i].piece;

      if (piece == ambigPiece && from != ambigFrom && to == ambigTo) {
        ambiguities++;

        if (rank(from) == rank(ambigFrom)) {
          sameRank++;
        }

        if (file(from) == file(ambigFrom)) {
          sameFile++;
        }
      }
    }

    if (ambiguities > 0) {
      if (sameRank > 0 && sameFile > 0) {
        return algebraic(from)!;
      } else if (sameFile > 0) {
        return algebraic(from)![1];
      } else {
        return algebraic(from)![0];
      }
    }

    return '';
  }

  Move? moveFromIccs(String move, {bool sloppy = false}) {
    String cleanMove = strippedIccs(move);

    RegExpMatch? matches =
        RegExp(r'([a-iA-I][0-9])-?([a-iA-I][0-9])').firstMatch(cleanMove);

    Square? from;
    Square? to;

    if (sloppy) {
      if (matches != null) {
        from = algebraicToEnum(matches.group(1));
        to = algebraicToEnum(matches.group(2));
      }
    }

    List<Move> moves = generateMoves();
    for (int i = 0; i < moves.length; i++) {
      if (cleanMove == strippedIccs(moveToIccs(moves[i])) ||
          (sloppy &&
              cleanMove == strippedIccs(moveToIccs(moves[i], sloppy: true)))) {
        return moves[i];
      } else {
        if (matches != null &&
            Xiangqi.SQUARES[from] == moves[i].from &&
            Xiangqi.SQUARES[to] == moves[i].to) {
          return moves[i];
        }
      }
    }

    return null;
  }

  int rank(int i) {
    return i >> 4;
  }

  int file(int i) {
    return i & 0x0f;
  }

  Square? algebraicToEnum(String? alg) {
    if (alg == null || alg.length != 2) return null;
    final lowerCaseAlg = alg.toLowerCase();
    return Square.values
        .firstWhere((e) => e.toString().split('.').last == lowerCaseAlg);
  }

  String? algebraic(int i) {
    final f = file(i);
    final r = rank(i);
    final square = '${"abcdefghi"[f]}${"9876543210"[r]}';
    return algebraicToEnum(square)?.toString().split('.').last;
  }

  Color swapColor(Color c) {
    return c == Xiangqi.RED ? Xiangqi.BLACK : Xiangqi.RED;
  }

  bool isDigit(String c) {
    return '0123456789'.contains(c);
  }

  bool crossedRiver(int p, Color c) {
    return c == Xiangqi.RED ? rank(p) < 5 : rank(p) > 4;
  }

  bool outOfBoard(int square) {
    return square < 0 || rank(square) > 9 || file(square) > 8;
  }

  bool outOfPlace(PieceType piece, int square, Color color) {
    Map<String, List<int>> side = {
      'RED': [],
      'BLACK': []
    }; // Khởi tạo với mảng rỗng
    if (piece == Xiangqi.PAWN) {
      side['RED'] = [0, 2, 4, 6, 8];
      side['BLACK'] = [0, 2, 4, 6, 8];
      if (color == Xiangqi.RED) {
        return rank(square) > 6 ||
            (rank(square) > 4 && !side['RED']!.contains(file(square)));
      } else {
        return rank(square) < 3 ||
            (rank(square) < 5 && !side['BLACK']!.contains(file(square)));
      }
    } else if (piece == Xiangqi.BISHOP) {
      side['RED'] = [0x92, 0x96, 0x70, 0x74, 0x78, 0x52, 0x56];
      side['BLACK'] = [0x02, 0x06, 0x20, 0x24, 0x28, 0x42, 0x46];
    } else if (piece == Xiangqi.ADVISER) {
      side['RED'] = [0x93, 0x95, 0x84, 0x73, 0x75];
      side['BLACK'] = [0x03, 0x05, 0x14, 0x23, 0x25];
    } else if (piece == Xiangqi.KING) {
      side['RED'] = [0x93, 0x94, 0x95, 0x83, 0x84, 0x85, 0x73, 0x74, 0x75];
      side['BLACK'] = [0x03, 0x04, 0x05, 0x13, 0x14, 0x15, 0x23, 0x24, 0x25];
    } else {
      return outOfBoard(square);
    }

    String colorKey = color.toString().split('.').last.toUpperCase();
    List<int>? allowedSquares = side[colorKey];

    if (allowedSquares == null) {
      // Xử lý trường hợp colorKey không tồn tại trong side.
      // Có thể:
      // - Trả về giá trị mặc định (false hoặc true)
      // - Throw exception (nếu đây là lỗi nghiêm trọng)
      // - Ghi log lỗi
      return false; // Hoặc xử lý phù hợp
    } else {
      return !allowedSquares.contains(square);
    }
  }

  bool hobblingHorseLeg(int square, int index) {
    final orientation = [-0x10, 0x10, -0x01, 0x01];
    return board[square + orientation[index ~/ 2]] != null;
  }

  bool blockingElephantEye(int square, int index) {
    final orientation = [-0x10 - 0x01, 0x10 + 0x01, 0x10 - 0x01, -0x10 + 0x01];
    return board[square + orientation[index]] != null;
  }

  Move makePretty(Move uglyMove) {
    Move move = clone(uglyMove);
    move.iccs = moveToIccs(move);
    move.to = Xiangqi.SQUARES.keys
        .firstWhere((k) => Xiangqi.SQUARES[k] == move.to)
        .index;
    move.from = Xiangqi.SQUARES.keys
        .firstWhere((k) => Xiangqi.SQUARES[k] == move.from)
        .index;
    move.piece = turn == Xiangqi.RED
        ? getPieceTypeFromSymbol(getPieceSymbol(move.piece).toUpperCase())
        : move.piece;
    move.fen = generateFen();
    move.moveNumber = uglyMove.moveNumber;

    String flags = '';

    for (FlagKeys flag in Xiangqi.BITS.keys) {
      if ((Xiangqi.BITS[flag]! & move.flags) > 0) {
        flags += Xiangqi.FLAGS[flag]!;
      }
    }
    move.flags = flags.codeUnits.isEmpty
        ? 0
        : flags.codeUnits.first; // Assuming flags is a single character

    return move;
  }

  T clone<T>(T obj) {
    if (obj is List) {
      return obj.map((item) => clone(item)).toList() as T;
    } else if (obj is Map) {
      return obj.map((key, value) => MapEntry(key, clone(value))) as T;
    } else {
      return obj;
    }
  }

  String trim(String str) {
    return str.trim();
  }

  // int perft(int depth) {
  //   final moves = generateMoves(legal: false);
  //   int nodes = 0;

  //   for (int i = 0; i < moves.length; i++) {
  //     makeMove(moves[i]);
  //     if (!kingAttacked(turn)) {
  //       if (depth - 1 > 0) {
  //         int childNodes = perft(depth - 1);
  //         nodes += childNodes;
  //       } else {
  //         nodes++;
  //       }
  //     }
  //     undoMove();
  //   }

  //   return nodes;
  // }

  List<dynamic> moves(
      {bool legal = true,
      Square? square,
      bool opponent = false,
      bool verbose = false}) {
    final uglyMoves =
        generateMoves(legal: legal, square: square, opponent: opponent);
    List<dynamic> moves = [];

    for (int i = 0; i < uglyMoves.length; i++) {
      if (verbose) {
        moves.add(makePretty(uglyMoves[i]));
      } else {
        moves.add(moveToIccs(uglyMoves[i]));
      }
    }

    return moves;
  }

  bool inDraw() {
    return insufficientMaterial();
  }

  bool gameOver() {
    return inCheckmate() ||
        inStalemate() ||
        insufficientMaterial() ||
        kings[swapColor(turn)] == Xiangqi.EMPTY;
  }

  String fen() {
    return generateFen();
  }

  List<List<Piece?>> getBoard() {
    List<List<Piece?>> output = [];
    List<Piece?> row = [];

    for (int i = Xiangqi.SQUARES[Square.a9]!;
        i <= Xiangqi.SQUARES[Square.i0]!;
        i++) {
      if (board[i] == null) {
        row.add(null);
      } else {
        row.add(Piece(type: board[i]!.type, color: board[i]!.color));
      }
      if ((i & 0x08) != 0) {
        output.add(row);
        row = [];
        i += 7;
      }
    }

    return output;
  }

  Move? move(dynamic moveInput, {bool sloppy = false}) {
    Move? moveObj = null;

    if (moveInput is String) {
      moveObj = moveFromIccs(moveInput, sloppy: sloppy);
    } else if (moveInput is Map) {
      List<Move> moves = generateMoves();

      for (int i = 0; i < moves.length; i++) {
        if (moveInput['from'] == algebraic(moves[i].from) &&
            moveInput['to'] == algebraic(moves[i].to) &&
            !moveInput.containsKey('promotion')) {
          moveObj = moves[i];
          moves[i].iccs = moveInput['from'] + moveInput['to'];
          break;
        }
      }
    }

    if (moveObj == null) {
      return null;
    }

    if (getCurrentTurn() == Color.r) {
      moveNumber++;
    }

    Move prettyMove = makePretty(moveObj);
    makeMove(moveObj, from: moveInput['from'], to: moveInput['to']);
    if (history.isNotEmpty) {
      history.last.move.moveNumber = moveNumber;
    }
    futures = [];

    return prettyMove;
  }

  List<dynamic> getHistory({bool verbose = false}) {
    List<Move> reversedHistory = [];
    List<dynamic> moveHistory = [];

    // while (history.isNotEmpty) {
    //   reversedHistory.add(undoMove()!);
    // }

    while (reversedHistory.isNotEmpty) {
      Move move = reversedHistory.removeLast();
      if (verbose) {
        moveHistory.add(makePretty(move));
      } else {
        moveHistory.add(moveToIccs(move));
      }
      // makeMove(move);
    }

    return moveHistory;
  }

  String ascii() {
    String s = '   +---------------------------+\n';
    for (int i = Xiangqi.SQUARES[Square.a9]!;
        i <= Xiangqi.SQUARES[Square.i0]!;
        i++) {
      if (file(i) == 0) {
        s += ' ${'9876543210'[rank(i)]} |';
      }

      if (board[i] == null) {
        s += ' . ';
      } else {
        PieceType piece = board[i]!.type;
        Color color = board[i]!.color;
        String symbol = color == Xiangqi.RED
            ? getPieceSymbol(piece).toUpperCase()
            : getPieceSymbol(piece).toLowerCase();
        s += ' $symbol ';
      }

      if ((i & 0x08) != 0) {
        s += '|\n';
        i += 7;
      }
    }
    s += '   +---------------------------+\n';
    s += '     a  b  c  d  e  f  g  h  i\n';

    return s;
  }

  List<Move> generatePrettyMoves(
      {bool legal = true, Square? square, bool opponent = false}) {
    return generateMoves(legal: legal, square: square, opponent: opponent)
        .map((e) => makePretty(e))
        .toList();
  }

  Square toNotion(int x, int y) {
    const files = "abcdefghi";
    final file = files[y];
    final rank = 9 - x;
    return algebraicToEnum('$file$rank')!;
  }

  static Map<String, int>? fromNotion(String notion) {
    if (notion.length != 2) {
      return null;
    }
    final colChar = notion[0];
    final rowChar = notion[1];

    final col = colChar.codeUnitAt(0) - 'a'.codeUnitAt(0);
    final row = 9 - int.parse(rowChar);

    if (col < 0 || col > 8 || row.isNaN || row < 0 || row > 9) {
      return null;
    }
    return {'row': row, 'col': col};
  }

  String getPieceSymbol(PieceType piece) {
    if (piece is PawnType) {
      return 'p';
    } else if (piece is ExcludePawnType) {
      switch (piece) {
        case ExcludePawnType.c:
          return 'c';
        case ExcludePawnType.r:
          return 'r';
        case ExcludePawnType.n:
          return 'n';
        case ExcludePawnType.b:
          return 'b';
        case ExcludePawnType.a:
          return 'a';
        case ExcludePawnType.k:
          return 'k';
      }
    }
    return '';
  }

  PieceType? getPieceTypeFromSymbol(String symbol) {
    switch (symbol.toLowerCase()) {
      // Sửa ở đây: Chuyển symbol thành chữ thường
      case 'p':
        return PawnType.p;
      case 'c':
        return ExcludePawnType.c;
      case 'r':
        return ExcludePawnType.r;
      case 'n':
        return ExcludePawnType.n;
      case 'b':
        return ExcludePawnType.b;
      case 'a':
        return ExcludePawnType.a;
      case 'k':
        return ExcludePawnType.k;
      default:
        throw ArgumentError('Invalid piece symbol: $symbol');
    }
  }
}
