class XiangqiColor {
  static const b = 'b';
  static const r = 'r';
}

class XiangqiPieceType {
  static const p = 'p';
  static const c = 'c';
  static const r = 'r';
  static const n = 'n';
  static const b = 'b';
  static const a = 'a';
  static const k = 'k';
}

class XiangqiPieceInfo {
  int number;
  List<int> squares;

  XiangqiPieceInfo({required this.number, required this.squares});
}

typedef Square = String;

class FlagKeys {
  static const NORMAL = 'n';
  static const CAPTURE = 'c';
}

class XiangqiPiece {
  String type;
  String color;
  String? notion;

  XiangqiPiece({required this.type, required this.color, this.notion});
}

class Move {
  int? moveNumber;
  String color;
  int from;
  int to;
  int flags;
  String piece;
  String? captured;
  String? fen;
  String? iccs;
  String? flagsDisplay;
  String? san;

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
  Map<String, int> kings;
  String turn;

  HistoryMove({required this.move, required this.kings, required this.turn});
}

class ValidationResult {
  bool valid;
  int errorNumber;
  String error;

  ValidationResult(
      {required this.valid, required this.errorNumber, required this.error});
}

///  thư viện chứa logic cờ tướng, dùng để check rule và tạo fen sau các nước đi

class Xiangqi {
  static const WHITE = 'w';
  static const BLACK = XiangqiColor.b;
  static const RED = XiangqiColor.r;
  static const EMPTY = -1;
  static const PAWN = XiangqiPieceType.p;
  static const CANNON = XiangqiPieceType.c;
  static const ROOK = XiangqiPieceType.r;
  static const KNIGHT = XiangqiPieceType.n;
  static const BISHOP = XiangqiPieceType.b;
  static const ADVISER = XiangqiPieceType.a;
  static const KING = XiangqiPieceType.k;
  static const SYMBOLS = 'pcrnbakPCRNBAK';
  static const DEFAULT_POSITION =
      'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR r - - 0 1';
  static const POSSIBLE_RESULTS = ['1-0', '0-1', '1/2-1/2', '*'];
  static const PAWN_OFFSETS = {
    XiangqiColor.b: [0x10, -0x01, 0x01],
    XiangqiColor.r: [-0x10, -0x01, 0x01]
  };

  static const PIECE_OFFSETS = {
    XiangqiPieceType.c: [-0x10, 0x10, -0x01, 0x01],
    XiangqiPieceType.r: [-0x10, 0x10, -0x01, 0x01],
    XiangqiPieceType.n: [
      -0x20 - 0x01,
      -0x20 + 0x01,
      0x20 - 0x01,
      0x20 + 0x01,
      -0x10 - 0x02,
      0x10 - 0x02,
      -0x10 + 0x02,
      0x10 + 0x02
    ],
    XiangqiPieceType.b: [-0x20 - 0x02, 0x20 + 0x02, 0x20 - 0x02, -0x20 + 0x02],
    XiangqiPieceType.a: [-0x10 - 0x01, 0x10 + 0x01, 0x10 - 0x01, -0x10 + 0x01],
    XiangqiPieceType.k: [-0x10, 0x10, -0x01, 0x01],
  };

  static const FLAGS = {
    FlagKeys.NORMAL: 'n',
    FlagKeys.CAPTURE: 'c',
  };

  static const BITS = {
    FlagKeys.NORMAL: 1,
    FlagKeys.CAPTURE: 2,
  };

  static const SQUARES = {
    'a9': 0x00,
    'b9': 0x01,
    'c9': 0x02,
    'd9': 0x03,
    'e9': 0x04,
    'f9': 0x05,
    'g9': 0x06,
    'h9': 0x07,
    'i9': 0x08,
    'a8': 0x10,
    'b8': 0x11,
    'c8': 0x12,
    'd8': 0x13,
    'e8': 0x14,
    'f8': 0x15,
    'g8': 0x16,
    'h8': 0x17,
    'i8': 0x18,
    'a7': 0x20,
    'b7': 0x21,
    'c7': 0x22,
    'd7': 0x23,
    'e7': 0x24,
    'f7': 0x25,
    'g7': 0x26,
    'h7': 0x27,
    'i7': 0x28,
    'a6': 0x30,
    'b6': 0x31,
    'c6': 0x32,
    'd6': 0x33,
    'e6': 0x34,
    'f6': 0x35,
    'g6': 0x36,
    'h6': 0x37,
    'i6': 0x38,
    'a5': 0x40,
    'b5': 0x41,
    'c5': 0x42,
    'd5': 0x43,
    'e5': 0x44,
    'f5': 0x45,
    'g5': 0x46,
    'h5': 0x47,
    'i5': 0x48,
    'a4': 0x50,
    'b4': 0x51,
    'c4': 0x52,
    'd4': 0x53,
    'e4': 0x54,
    'f4': 0x55,
    'g4': 0x56,
    'h4': 0x57,
    'i4': 0x58,
    'a3': 0x60,
    'b3': 0x61,
    'c3': 0x62,
    'd3': 0x63,
    'e3': 0x64,
    'f3': 0x65,
    'g3': 0x66,
    'h3': 0x67,
    'i3': 0x68,
    'a2': 0x70,
    'b2': 0x71,
    'c2': 0x72,
    'd2': 0x73,
    'e2': 0x74,
    'f2': 0x75,
    'g2': 0x76,
    'h2': 0x77,
    'i2': 0x78,
    'a1': 0x80,
    'b1': 0x81,
    'c1': 0x82,
    'd1': 0x83,
    'e1': 0x84,
    'f1': 0x85,
    'g1': 0x86,
    'h1': 0x87,
    'i1': 0x88,
    'a0': 0x90,
    'b0': 0x91,
    'c0': 0x92,
    'd0': 0x93,
    'e0': 0x94,
    'f0': 0x95,
    'g0': 0x96,
    'h0': 0x97,
    'i0': 0x98,
  };

  List<XiangqiPiece?> board = List.filled(256, null);
  Map<String, int> kings = {
    XiangqiColor.r: Xiangqi.EMPTY,
    XiangqiColor.b: Xiangqi.EMPTY
  };
  String turn = Xiangqi.RED;
  List<dynamic> history = [];
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

  String getCurrentTurn() {
    return turn;
  }

  void clear({bool keepHeaders = false}) {
    board = List.filled(256, null);
    kings = {XiangqiColor.r: Xiangqi.EMPTY, XiangqiColor.b: Xiangqi.EMPTY};
    turn = Xiangqi.RED;
    history = [];
    futures = [];
    if (!keepHeaders) header = {};
    updateSetup(generateFen());
  }

  void reset() {
    load(Xiangqi.DEFAULT_POSITION);
  }

  bool load(String fen, {bool keepHeaders = false}) {
    if (!validateFen(fen).valid) {
      return false;
    }

    final tokens = fen.split(RegExp(r'\s+'));
    final position = tokens[0];
    int square = 0;

    clear(keepHeaders: keepHeaders);

    for (int i = 0; i < position.length; ++i) {
      final piece = position[i];

      if (piece == '/') {
        square += 0x07;
      } else if (isDigit(piece)) {
        square += int.parse(piece);
      } else {
        final color = piece.codeUnitAt(0) < 'a'.codeUnitAt(0)
            ? Xiangqi.RED
            : Xiangqi.BLACK;
        put(XiangqiPiece(type: piece.toLowerCase(), color: color),
            algebraic(square));
        square++;
      }
    }

    turn = (tokens[1] == Xiangqi.BLACK)
        ? Xiangqi.BLACK
        : Xiangqi.RED;
    moveNumber = turn == 'b' ? 1 : 0;

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

    final Map<String, XiangqiPieceInfo> pieces = {
      'p': XiangqiPieceInfo(number: 0, squares: []),
      'P': XiangqiPieceInfo(number: 0, squares: []),
      'c': XiangqiPieceInfo(number: 0, squares: []),
      'C': XiangqiPieceInfo(number: 0, squares: []),
      'r': XiangqiPieceInfo(number: 0, squares: []),
      'R': XiangqiPieceInfo(number: 0, squares: []),
      'n': XiangqiPieceInfo(number: 0, squares: []),
      'N': XiangqiPieceInfo(number: 0, squares: []),
      'b': XiangqiPieceInfo(number: 0, squares: []),
      'B': XiangqiPieceInfo(number: 0, squares: []),
      'a': XiangqiPieceInfo(number: 0, squares: []),
      'A': XiangqiPieceInfo(number: 0, squares: []),
      'k': XiangqiPieceInfo(number: 0, squares: []),
      'K': XiangqiPieceInfo(number: 0, squares: []),
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
            pieces[rows[i][j]]!.number = pieces[rows[i][j]]!.number + 1;
          } catch (e) {
            return result(9);
          }
          pieces[rows[i][j]]!.squares.add((i << 4) | sumFields);
          sumFields += 1;
          previousWasNumber = false;
        }
      }
      if (sumFields != 9) {
        return result(10);
      }
    }

    if (pieces['k']!.number != 1 || pieces['K']!.number != 1) {
      return result(11);
    }
    if (pieces['a']!.number > 2 || pieces['A']!.number > 2) {
      return result(12);
    }
    if (pieces['b']!.number > 2 || pieces['B']!.number > 2) {
      return result(13);
    }
    if (pieces['n']!.number > 2 || pieces['N']!.number > 2) {
      return result(14);
    }
    if (pieces['r']!.number > 2 || pieces['R']!.number > 2) {
      return result(15);
    }
    if (pieces['c']!.number > 2 || pieces['C']!.number > 2) {
      return result(16);
    }
    if (pieces['p']!.number > 5 || pieces['P']!.number > 5) {
      return result(17);
    }

    if (outOfPlace(Xiangqi.KING, pieces['k']!.squares[0], Xiangqi.BLACK)) {
      return result(18);
    }
    if (outOfPlace(Xiangqi.KING, pieces['K']!.squares[0], Xiangqi.RED)) {
      return result(19);
    }
    for (int i = 0; i < pieces['a']!.squares.length; ++i) {
      if (outOfPlace(Xiangqi.ADVISER, pieces['a']!.squares[i], Xiangqi.BLACK)) {
        return result(20);
      }
    }
    for (int i = 0; i < pieces['A']!.squares.length; ++i) {
      if (outOfPlace(Xiangqi.ADVISER, pieces['A']!.squares[i], Xiangqi.RED)) {
        return result(21);
      }
    }
    for (int i = 0; i < pieces['b']!.squares.length; ++i) {
      if (outOfPlace(Xiangqi.BISHOP, pieces['b']!.squares[i], Xiangqi.BLACK)) {
        return result(22);
      }
    }
    for (int i = 0; i < (pieces['B']!.squares as dynamic).length; ++i) {
      if (outOfPlace(Xiangqi.BISHOP, pieces['B']!.squares[i], Xiangqi.RED)) {
        return result(23);
      }
    }
    for (int i = 0; i < (pieces['p']!.squares as dynamic).length; ++i) {
      if (outOfPlace(Xiangqi.PAWN, pieces['p']!.squares[i], Xiangqi.BLACK)) {
        return result(24);
      }
    }
    for (int i = 0; i < pieces['P']!.squares.length; ++i) {
      if (outOfPlace(Xiangqi.PAWN, pieces['P']!.squares[i], Xiangqi.RED)) {
        return result(25);
      }
    }

    return result(0);
  }

  String generateFen() {
    int empty = 0;
    String fen = '';

    for (int i = Xiangqi.SQUARES['a9']!; i <= Xiangqi.SQUARES['i0']!; ++i) {
      if (board[i] == null) {
        empty++;
      } else {
        if (empty > 0) {
          fen += empty.toString();
          empty = 0;
        }
        final color = board[i]!.color;
        final piece = board[i]!.type;

        fen += color == Xiangqi.RED ? piece.toUpperCase() : piece.toLowerCase();
      }

      if (file(i) >= 8) {
        if (empty > 0) {
          fen += empty.toString();
        }

        if (i != Xiangqi.SQUARES['i0']) {
          fen += '/';
        }

        empty = 0;
        i += 0x07;
      }
    }

    return [fen, turn == 'r' ? 'w' : 'b'].join(' ');
  }

  Map<String, String> setHeader(List<String> args) {
    for (int i = 0; i < args.length; i += 2) {
      header[args[i]] = args[i + 1];
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

  XiangqiPiece? get(Square square) {
    final piece = board[Xiangqi.SQUARES[square]!];
    return piece != null
        ? XiangqiPiece(type: piece.type, color: piece.color)
        : null;
  }

  bool put(XiangqiPiece piece, Square square) {
    if (!piece.type.isNotEmpty || !piece.color.isNotEmpty) {
      return false;
    }

    if (!Xiangqi.SYMBOLS.contains(piece.type.toLowerCase())) {
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

    board[sq] = XiangqiPiece(type: piece.type, color: piece.color);
    if (piece.type == Xiangqi.KING) {
      kings[piece.color] = sq;
    }

    updateSetup(generateFen());

    return true;
  }

  XiangqiPiece? remove(Square square) {
    final piece = get(square);
    board[Xiangqi.SQUARES[square]!] = null;
    if (piece != null && piece.type == Xiangqi.KING) {
      kings[piece.color] = Xiangqi.EMPTY;
    }

    updateSetup(generateFen());

    return piece;
  }

  Move buildMove(List<XiangqiPiece?> board, int from, int to, int flags) {
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
    void addMove(List<XiangqiPiece?> board, List<Move> moves, int from, int to,
        int flags) {
      moves.add(buildMove(board, from, to, flags));
    }

    List<Move> moves = [];
    String us = turn;
    String them = swapXiangqiColor(us);

    int firstSq = Xiangqi.SQUARES['a9']!;
    int lastSq = Xiangqi.SQUARES['i0']!;

    if (square != null) {
      if (Xiangqi.SQUARES.containsKey(square)) {
        firstSq = lastSq = Xiangqi.SQUARES[square]!;
      } else {
        return [];
      }
    }

    if (opponent) {
      turn = swapXiangqiColor(turn);
      us = turn;
      them = swapXiangqiColor(us);
    }

    for (int i = firstSq; i <= lastSq; ++i) {
      final piece = board[i];
      if (piece == null || piece.color != us) continue;

      final OFFSETS = piece.type == Xiangqi.PAWN
          ? Xiangqi.PAWN_OFFSETS[us]!
          : Xiangqi.PIECE_OFFSETS[piece.type]!;

      for (int j = 0, len = OFFSETS.length; j < len; ++j) {
        if (piece.type == Xiangqi.PAWN && j > 0 && !crossedRiver(i, us)) break;

        int offset = OFFSETS[j];
        int square_ = i;
        bool crossed = false;

        while (true) {
          square_ += offset;

          if (outOfBoard(square_)) {
            crossed = false;
            break;
          } else if (piece.type == Xiangqi.KNIGHT && hobblingHorseLeg(i, j)) {
            crossed = false;
            break;
          } else if (piece.type == Xiangqi.BISHOP &&
              (blockingElephantEye(i, j) || crossedRiver(square_, us))) {
            crossed = false;
            break;
          } else if ((piece.type == Xiangqi.ADVISER ||
                  piece.type == Xiangqi.KING) &&
              outOfPlace(piece.type, square_, us)) {
            crossed = false;
            break;
          }

          if (board[square_] == null) {
            if (piece.type == Xiangqi.CANNON && crossed) continue;
            addMove(board, moves, i, square_, Xiangqi.BITS[FlagKeys.NORMAL]!);
          } else {
            if (piece.type == Xiangqi.CANNON) {
              if (crossed) {
                if ((board[square_] as XiangqiPiece).color == them) {
                  addMove(board, moves, i, square_,
                      Xiangqi.BITS[FlagKeys.CAPTURE]!);
                }
                crossed = false;
                break;
              }
              crossed = true;
            } else {
              if ((board[square_] as XiangqiPiece).color == them) {
                addMove(
                    board, moves, i, square_, Xiangqi.BITS[FlagKeys.CAPTURE]!);
              }
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
    for (int i = 0, len = moves.length; i < len; i++) {
      makeMove(moves[i]);
      if (!kingAttacked(us)) {
        legalMoves.add(moves[i]);
      }
      undoMove();
    }

    if (opponent) {
      turn = swapXiangqiColor(turn);
    }

    return legalMoves;
  }

  String moveToIccs(Move move, {bool sloppy = false}) {
    String output = '';
    output = algebraic(move.from) + algebraic(move.to);
    return output;
  }

  String strippedIccs(String move) {
    return move.replaceAll('=', '').replaceAll(RegExp(r'[+#]?[?!]*$'), '');
  }

  bool kingAttacked(String color) {
    int square = kings[color]!;
    String them = swapXiangqiColor(color);

    for (int i = 0, len = Xiangqi.PIECE_OFFSETS[Xiangqi.KNIGHT]!.length;
        i < len;
        ++i) {
      int sq = square + Xiangqi.PIECE_OFFSETS[Xiangqi.KNIGHT]![i];
      if (!outOfBoard(sq) &&
          board[sq] != null && // Thêm !outOfBoard(sq)
          board[sq]!.color == them &&
          board[sq]!.type == Xiangqi.KNIGHT &&
          !hobblingHorseLeg(sq, i < 4 ? 3 - i : 11 - i)) {
        return true;
      }
    }

    for (int i = 0, len = Xiangqi.PIECE_OFFSETS[Xiangqi.ROOK]!.length;
        i < len;
        ++i) {
      int offset = Xiangqi.PIECE_OFFSETS[Xiangqi.ROOK]![i];
      bool crossed = false;
      for (int sq = square + offset; !outOfBoard(sq); sq += offset) {
        XiangqiPiece? piece = board[sq];
        if (piece != null) {
          if (piece.color == them) {
            if (crossed) {
              if (piece.type == Xiangqi.CANNON) return true;
            } else {
              if (piece.type == Xiangqi.ROOK || piece.type == Xiangqi.KING) {
                return true;
              }
            }
          }
          if (crossed) {
            break;
          } else {
            crossed = true;
          }
        }
      }
    }

    for (int i = 0, len = Xiangqi.PAWN_OFFSETS[them]!.length; i < len; ++i) {
      int sq = square - Xiangqi.PAWN_OFFSETS[them]![i];
      if (!outOfBoard(sq) &&
          board[sq] != null && // Thêm !outOfBoard(sq)
          board[sq]!.color == them &&
          board[sq]!.type == Xiangqi.PAWN) {
        return true;
      }
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
    Map<String, int> pieces = {};
    int numXiangqiPieces = 0;

    for (String sq in Xiangqi.SQUARES.keys) {
      XiangqiPiece? piece = board[Xiangqi.SQUARES[sq]!];
      if (piece != null) {
        pieces[piece.type] = (pieces[piece.type] ?? 0) + 1;
        numXiangqiPieces++;
      }
    }

    if (numXiangqiPieces == 2) {
      return true;
    } else if (!pieces.containsKey(Xiangqi.KNIGHT) &&
        !pieces.containsKey(Xiangqi.ROOK) &&
        !pieces.containsKey(Xiangqi.CANNON) &&
        !pieces.containsKey(Xiangqi.PAWN)) return true;

    return false;
  }

  bool inThreefoldRepetition() {
    List<Move> moves = [];
    Map<String, int> positions = {};
    bool repetition = false;

    while (true) {
      Move? move = undoMove();
      if (move == null) break;
      moves.add(move);
    }

    while (true) {
      String fen = generateFen().split(' ').sublist(0, 2).join('');

      positions[fen] = (positions[fen] ?? 0) + 1;
      if (positions[fen]! >= 3) {
        repetition = true;
      }

      if (moves.isEmpty) {
        break;
      }
      makeMove(moves.removeLast());
    }

    return repetition;
  }

  void push(List list, Move? move) {
    list.add({
      'move': move,
      'kings': {'b': kings['b']!, 'r': kings['r']!},
      'turn': turn,
    });
  }

  Move _buildMoveFromInput({dynamic input}) {
    var from = '';
    var to = '';
    if (input is String) {
      from = input.substring(0, 2);
      to = input.substring(2, 4);
    } else {
      from = input['from'];
      to = input['to'];
    }

    return Move(
        color: turn,
        from: SQUARES[from]!,
        to: SQUARES[to]!,
        piece: board[SQUARES[from]!]!.type,
        flags: BITS[FlagKeys.NORMAL]!);
  }

  void makeMove(Move move) {

    if(move.iccs !=null){
  print('move ${move.from} ${move.to}');
    }

  
    push(history, move);
    if (board[move.to] != null && board[move.to]!.type == Xiangqi.KING) {
      kings[board[move.to]!.color] = Xiangqi.EMPTY;
    }

    board[move.to] = board[move.from];
    board[move.from] = null;

    if (board[move.to]!.type == Xiangqi.KING) {
      kings[board[move.to]!.color] = move.to;
    }

    turn = swapXiangqiColor(turn);
    move.fen = generateFen();
  }

  Move? setMove(dynamic old, {bool undo = true}) {
    if (old == null) {
      return null;
    }

    final move = old['move'];
    kings = old['kings'];
    turn = old['turn'];

    board[move.from] = board[move.to];
    board[move.from]!.type = move.piece;
    board[move.to] = null;

    if ((move.flags & Xiangqi.BITS[FlagKeys.CAPTURE]!) > 0 && undo) {
      // No need for int.parse anymore
      board[move.to] =
          XiangqiPiece(type: move.captured!, color: swapXiangqiColor(turn));
    }

    return move;
  }

  Move? undoMove() {
    return setMove(history.removeLast());
  }

  Move? redoMove() {
    return setMove(futures.removeLast(), undo: false);
  }

  String getDisambiguator(Move move, {bool sloppy = false}) {
    final moves = generateMoves(legal: !sloppy);

    final from = move.from;
    final to = move.to;
    final piece = move.piece;

    int ambiguities = 0;
    int sameRank = 0;
    int sameFile = 0;

    for (int i = 0, len = moves.length; i < len; i++) {
      int ambigFrom = moves[i].from;
      int ambigTo = moves[i].to;
      String ambigXiangqiPiece = moves[i].piece;

      if (piece == ambigXiangqiPiece && from != ambigFrom && to == ambigTo) {
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
        return algebraic(from);
      } else if (sameFile > 0) {
        return algebraic(from)[1];
      } else {
        return algebraic(from)[0];
      }
    }

    return '';
  }

  Move? moveFromIccs(String move, {bool sloppy = false}) {
    String cleanMove = strippedIccs(move);

    RegExp matches = RegExp(r'([a-iA-I][0-9])-?([a-iA-I][0-9])');
    String? from, to;

    if (matches.hasMatch(cleanMove)) {
      final match = matches.firstMatch(cleanMove)!;
      from = match.group(1);
      to = match.group(2);
    }

    List<Move> moves = generateMoves();
    for (int i = 0, len = moves.length; i < len; i++) {
      if (cleanMove == strippedIccs(moveToIccs(moves[i])) ||
          (sloppy &&
              cleanMove == strippedIccs(moveToIccs(moves[i], sloppy: true)))) {
        return moves[i];
      } else {
        if (from != null &&
            to != null &&
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

  Square algebraic(int i) {
    final f = file(i);
    final r = rank(i);
    return 'abcdefghi'.substring(f, f + 1) + '9876543210'.substring(r, r + 1);
  }

  String swapXiangqiColor(String c) {
    return c == Xiangqi.RED ? Xiangqi.BLACK : Xiangqi.RED;
  }

  bool isDigit(String c) {
    return '0123456789'.contains(c);
  }

  bool crossedRiver(int p, String c) {
    return c == Xiangqi.RED ? rank(p) < 5 : rank(p) > 4;
  }

  bool outOfBoard(int square) {
    return square < 0 || rank(square) > 9 || file(square) > 8;
  }

  bool outOfPlace(String piece, int square, String color) {
    Map<String, List<int>> side = {};
    if (piece == Xiangqi.PAWN) {
      side = {
        'RED': [0, 2, 4, 6, 8],
        'BLACK': [0, 2, 4, 6, 8]
      };
      if (color == Xiangqi.RED) {
        return rank(square) > 6 ||
            (rank(square) > 4 && !side['RED']!.contains(file(square)));
      } else {
        return rank(square) < 3 ||
            (rank(square) < 5 && !side['BLACK']!.contains(file(square)));
      }
    } else if (piece == Xiangqi.BISHOP) {
      side[Xiangqi.RED] = [0x92, 0x96, 0x70, 0x74, 0x78, 0x52, 0x56];
      side[Xiangqi.BLACK] = [0x02, 0x06, 0x20, 0x24, 0x28, 0x42, 0x46];
    } else if (piece == Xiangqi.ADVISER) {
      side[Xiangqi.RED] = [0x93, 0x95, 0x84, 0x73, 0x75];
      side[Xiangqi.BLACK] = [0x03, 0x05, 0x14, 0x23, 0x25];
    } else if (piece == Xiangqi.KING) {
      side[Xiangqi.RED] = [
        0x93,
        0x94,
        0x95,
        0x83,
        0x84,
        0x85,
        0x73,
        0x74,
        0x75
      ];
      side[Xiangqi.BLACK] = [
        0x03,
        0x04,
        0x05,
        0x13,
        0x14,
        0x15,
        0x23,
        0x24,
        0x25
      ];
    } else {
      return outOfBoard(square);
    }

    return !side[color]!.contains(square);
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
    move.piece = turn == Xiangqi.RED
        ? move.piece.toUpperCase()
        : move.piece.toLowerCase();
    move.fen = uglyMove.fen ?? generateFen();
    move.moveNumber = uglyMove.moveNumber;
    move.san = uglyMove.san;

    String flags = '';

    for (String flag in Xiangqi.FLAGS.keys) {
      if ((uglyMove.flags & Xiangqi.BITS[flag]!) > 0) {
        flags += Xiangqi.FLAGS[flag]!;
      }
    }
    // Gán flags mới cho move.flags để hiển thị, không thay đổi giá trị gốc
    move.flagsDisplay =
        flags; // thêm một trường flagsDisplay để lưu trữ giá trị flags dạng chuỗi cho mục đích hiển thị

    return move;
  }

  dynamic clone(dynamic obj) {
    if (obj is List) {
      List dupe = [];
      for (var element in obj) {
        if (element is Map || element is List) {
          dupe.add(clone(element));
        } else {
          dupe.add(element);
        }
      }
      return dupe;
    } else if (obj is Map) {
      Map dupe = {};
      for (var key in obj.keys) {
        if (obj[key] is Map || obj[key] is List) {
          dupe[key] = clone(obj[key]);
        } else {
          dupe[key] = obj[key];
        }
      }
      return dupe;
    } else {
      return obj;
    }
  }

  String trim(String str) {
    return str.trim();
  }

  int perft(int depth) {
    final moves = generateMoves(legal: false);
    int nodes = 0;

    for (int i = 0, len = moves.length; i < len; i++) {
      makeMove(moves[i]);
      if (!kingAttacked(turn)) {
        if (depth - 1 > 0) {
          int childNodes = perft(depth - 1);
          nodes += childNodes;
        } else {
          nodes++;
        }
      }
      undoMove();
    }

    return nodes;
  }

  List<dynamic> moves(
      {bool legal = true,
      Square? square,
      bool opponent = false,
      bool verbose = false}) {
    final uglyMoves =
        generateMoves(legal: legal, square: square, opponent: opponent);
    List<dynamic> moves = [];

    for (int i = 0, len = uglyMoves.length; i < len; i++) {
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
        kings[swapXiangqiColor(turn)] == Xiangqi.EMPTY;
  }

  String fen() {
    return generateFen();
  }

  List<List<XiangqiPiece?>> getBoard() {
    List<List<XiangqiPiece?>> output = [];
    List<XiangqiPiece?> row = [];

    for (int i = Xiangqi.SQUARES['a9']!; i <= Xiangqi.SQUARES['i0']!; i++) {
      if (board[i] == null) {
        row.add(null);
      } else {
        row.add(XiangqiPiece(
            type: board[i]!.type,
            color: board[i]!.color,
            notion: algebraic(i)));
      }
      if ((i & 0x08) != 0) {
        output.add(row);
        row = [];
        i += 7;
      }
    }

    return output;
  }

  String pgn({int maxWidth = 0, String newlineChar = '\n'}) {
    String newline = newlineChar;
    int maxWidth_ = maxWidth;
    List<String> result = [];
    bool headerExists = false;

    for (String key in header.keys) {
      result.add('[$key "${header[key]}"]$newline');
      headerExists = true;
    }

    if (headerExists && history.isNotEmpty) {
      result.add(newline);
    }

    List<Move> reversedHistory = [];
    while (history.isNotEmpty) {
      reversedHistory.add(undoMove()!);
    }

    List<String> moves = [];
    String moveString = '';

    while (reversedHistory.isNotEmpty) {
      Move move = reversedHistory.removeLast();

      if (history.isEmpty && move.color == 'b') {
      } else if (move.color != 'b') {
        if (moveString.isNotEmpty) {
          moves.add(moveString);
        }
        moveString =
            '${move.moveNumber ?? (turn == 'r' ? moveNumber + 1 : moveNumber)}.';
      }

      moveString = '$moveString ${moveToIccs(move)}';
      makeMove(move);
    }

    if (moveString.isNotEmpty) {
      moves.add(moveString);
    }

    if (header.containsKey('Result')) {
      moves.add(header['Result']!);
    }

    if (maxWidth_ == 0) {
      return result.join('') + moves.join(' ');
    }

    int currentWidth = 0;
    for (int i = 0; i < moves.length; i++) {
      if (currentWidth + moves[i].length > maxWidth_ && i != 0) {
        if (result.last == ' ') {
          result.removeLast();
        }

        result.add(newline);
        currentWidth = 0;
      } else if (i != 0) {
        result.add(' ');
        currentWidth++;
      }
      result.add(moves[i]);
      currentWidth += moves[i].length;
    }

    return result.join('');
  }

  bool loadPgn(String pgn,
      {String newlineChar = '\r?\n', bool sloppy = false}) {
    bool sloppy_ = sloppy;

    String mask(String str) {
      return str.replaceAll('\\', '\\\\');
    }

    bool hasKeys(Map object) {
      for (String _ in object.keys) {
        return true;
      }
      return false;
    }

    Map<String, String> parsePgnHeader(String header,
        {String newlineChar = '\r?\n'}) {
      String newlineChar_ = newlineChar;
      Map<String, String> headerObj = {};
      List<String> headers = header.split(RegExp(mask(newlineChar_)));

      for (int i = 0; i < headers.length; i++) {
        String key = headers[i]
            .replaceFirst(RegExp(r'^\[([A-Z][A-Za-z]*)\s.*\]$'), r'$1');
        String value =
            headers[i].replaceFirst(RegExp(r'^\[[A-Za-z]+\s"(.*)"]$'), r'$1');
        if (trim(key).isNotEmpty) {
          headerObj[key] = value;
        }
      }

      return headerObj;
    }

    String newlineChar_ = newlineChar;

    RegExp headerRegex =
        RegExp(r'^(?:\s)*(((?:' + mask(newlineChar_) + r')*\[[^\]]+\])+)');

    String headerString =
        headerRegex.hasMatch(pgn) ? headerRegex.firstMatch(pgn)!.group(1)! : '';
    reset();

    Map<String, String> headers =
        parsePgnHeader(headerString, newlineChar: newlineChar_);
    // for (String key in headers.keys) {
    //     setHeader([key, headers[key]]);
    // }

    if (headers.containsKey('FEN')) {
      if (!load(headers['FEN']!, keepHeaders: true)) {
        print('load header FEN failed!');
        return false;
      }
    }

    String ms = pgn
        .replaceFirst(headerString, '')
        .replaceAll(RegExp(mask(newlineChar_), multiLine: true), ' ');

    ms = ms.replaceAllMapped(RegExp(r'({[^}]+})+?'), (match) => '');
    RegExp ravRegex = RegExp(r'(\([^()]+\))+?');
    while (ravRegex.hasMatch(ms)) {
      ms = ms.replaceAll(ravRegex, '');
    }

    ms = ms.replaceAll(RegExp(r'\d+\.(\.\.)?'), '');

    ms = ms.replaceAll(RegExp(r'\.\.\.'), '');

    ms = ms.replaceAll(RegExp(r'\$\d+'), '');

    List<String> moves = trim(ms).split(RegExp(r'\s+'));

    moves = moves.join(',').replaceAll(',,', ',').split(',');
    dynamic move = '';

    for (int halfMove = 0; halfMove < moves.length - 1; halfMove++) {
      move = moveFromIccs(moves[halfMove], sloppy: sloppy_);

      if (move == null) {
        print('impossible move: ${moves[halfMove]}!\n${ascii()}');
        return false;
      } else {
        makeMove(move);
      }
    }

    move = moves.last;
    if (Xiangqi.POSSIBLE_RESULTS.contains(move)) {
      if (hasKeys(header) && !header.containsKey('Result')) {
        setHeader(['Result', move]);
      }
    } else {
      move = moveFromIccs(move, sloppy: sloppy_);
      if (move == null) {
        print('impossible last move: ${moves.last}!\n${ascii()}');
        return false;
      } else {
        makeMove(move);
      }
    }
    return true;
  }

  Move? move(dynamic moveInput, {bool sloppy = false, List<Move>? canMoves}) {
    bool sloppy_ = sloppy;
    Move? moveObj;
    if (moveInput is String) {
      moveObj = moveFromIccs(moveInput, sloppy: sloppy_);
    } else if (moveInput is Map) {
      List<Move> moves = generateMoves();
      
      print(moveInput);

      for (int i = 0, len = moves.length; i < len; i++) {
        if (moveInput['from'] == algebraic(moves[i].from) &&
            moveInput['to'] == algebraic(moves[i].to)) {
          moveObj = moves[i];
          break;
        }
      }
    }

    print(moveObj);

    if (moveObj == null) {
      return null;
    }

    if (getCurrentTurn() == 'r') {
      moveNumber++;
    }

    moveObj.san = moveToJsChinese(moveObj);
    Move prettyMove = makePretty(moveObj);

    makeMove(moveObj);
    if (history.isNotEmpty) {
      (history.last as dynamic)['move'].moveNumber = moveNumber;
    }
    futures = [];

    return prettyMove;
  }

  Move? undo() {
    push(futures, null);
    Move? move = undoMove();
    if (move != null) {
      Move prettyMove = makePretty(move);
      List temp = [move.from, move.to];
      move.from = temp[1];
      move.to = temp[0];
      move.flags =
          (history.last as dynamic)['move'].flags; // khôi phục lại flags gốc
      futures[futures.length - 1] = move;
      return prettyMove;
    } else {
      futures.removeLast();
      return null;
    }
  }

  Move? redo() {
    push(history, null);
    Move? move = redoMove();
    if (move != null) {
      List temp = [move.from, move.to];
      move.from = temp[1];
      move.to = temp[0];
      move.flags =
          (futures.last as dynamic)['move'].flags; // khôi phục lại flags gốc
      history[history.length - 1] = move;
      return makePretty(move);
    } else {
      history.removeLast();
      return null;
    }
  }

  List<dynamic> getHistory({bool verbose = false}) {
    List<dynamic> moveHistory = [];

    for (int i = 0; i < history.length; i++) {
      if (verbose) {
        moveHistory.add(makePretty(history[i]['move']));
      } else {
        moveHistory.add(moveToIccs(history[i]['move']));
      }
    }

    // while (history.isNotEmpty) {
    //   reversedHistory.add(undoMove()!);
    // }

    // while (reversedHistory.isNotEmpty) {

    //   if (verbose) {
    //     moveHistory.add(makePretty(move));
    //   } else {
    //     moveHistory.add(moveToIccs(move));
    //   }
    //   makeMove(move);
    // }

    return moveHistory;
  }

  String ascii() {
    String s = '   +---------------------------+\n';
    for (int i = Xiangqi.SQUARES['a9']!; i <= Xiangqi.SQUARES['i0']!; i++) {
      if (file(i) == 0) {
        s += ' ${'9876543210'[rank(i)]} |';
      }

      if (board[i] == null) {
        s += ' . ';
      } else {
        String piece = board[i]!.type;
        String color = board[i]!.color;
        String symbol =
            color == Xiangqi.RED ? piece.toUpperCase() : piece.toLowerCase();
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

  static Square toNotion(int x, int y) {
    const files = "abcdefghi";
    final file = files[y];
    final rank = 9 - x;
    return '$file$rank';
  }

  static Map<String, int>? fromNotion(String notion) {
    if (notion.length != 2) {
      return null;
    }
    final colChar = notion[0];
    final rowChar = notion[1];

    final col = colChar.codeUnitAt(0) - 'a'.codeUnitAt(0);
    final row = 9 - int.parse(rowChar);

    if (col < 0 || col > 8 || row < 0 || row > 9) {
      return null;
    }
    return {'row': row, 'col': col};
  }



  String getSanfromNotation(String notation){
     Move move = _buildMoveFromInput(input: notation);
     return moveToJsChinese(move);
  }

  String moveToJsChinese(Move move) {
    Map<String, String> figureNames = {
      'P': 'B',
      'C': 'P',
      'R': 'X',
      'N': 'M',
      'B': 'V',
      'A': 'S',
      'K': 'Tg',
    };

    Map<String, List<String>> figureDir = {
      'r': ['.', '/'], // [forward, backward]
      'b': ['/', '.'], // [forward, backward]
      'p': ['-']
    };

    Map<String, List<String>> figureOrd = {
      'r': ['前', '後'], // [front, rear]
      'b': ['後', '前'], // [front, rear]
      'm': ['中']
    };

    Map<String, List<String>> figureValues = {
      'r': ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
      'b': ['9', '8', '7', '6', '5', '4', '3', '2', '1'],
    };

    String pieceType = move.piece.toUpperCase();
    String pieceName = figureNames[pieceType] ?? '';

    String from = algebraic(move.from);
    String to = algebraic(move.to);

    // Sửa fromX và toX
    int fromX = (from.codeUnitAt(0) - 97); // Không đảo ngược thứ tự cột
    int fromY = (from.codeUnitAt(1) - 48);
    int toX = (to.codeUnitAt(0) - 97); // Không đảo ngược thứ tự cột
    int toY = (to.codeUnitAt(1) - 48);

    // Tìm các quân cờ cùng loại, cùng màu và cùng cột
    List<int> sameXiangqiPieces = [];
    for (int i = Xiangqi.SQUARES['a9']!; i <= Xiangqi.SQUARES['i0']!; ++i) {
      if (board[i] != null &&
          board[i]!.type.toUpperCase() == pieceType &&
          board[i]!.color == move.color &&
          i != move.from) {
        sameXiangqiPieces.add(i);
      }
    }

    String s1 = '';
    String s2 = '';

    // Xử lý s1 (Tối ưu: Không chia trường hợp, hoán đổi 'tr' và 's')
    if (pieceType != 'A' && pieceType != 'B') {
      int cr = 0;
      // Kiểm tra số quân cờ cùng loại và cùng màu trên toàn bàn cờ (cr)
      for (int x = 0; x < 9; x++) {
        if (x == fromX) continue;
        for (int y = 0; y < 10; y++) {
          String sq = '${'abcdefghi'[x]}$y';
          if (Xiangqi.SQUARES.containsKey(sq) &&
              board[Xiangqi.SQUARES[sq]!] != null &&
              board[Xiangqi.SQUARES[sq]!]!.type.toUpperCase() == pieceType &&
              board[Xiangqi.SQUARES[sq]!]!.color == move.color) {
            cr++;
          }
        }
        if (cr < 2) cr = 0;
      }

      int c = 0;
      int cc = 0;
      // Xác định s1 dựa trên vị trí các quân cờ cùng loại trên cùng cột
      List<int> sameColXiangqiPieces = sameXiangqiPieces
          .where((piece) => file(piece) == file(move.from))
          .toList();
      sameColXiangqiPieces.add(move.from);
      sameColXiangqiPieces.sort((a, b) {
        // Sắp xếp: rank lớn hơn ở trước (đỏ), rank nhỏ hơn ở trước (đen)
        return (turn == Xiangqi.RED) ? rank(b) - rank(a) : rank(a) - rank(b);
      });

      for (int p in sameColXiangqiPieces) {
        int y = int.parse(algebraic(p)[1]); // rank

        // Không cần chia trường hợp đỏ/đen
        if (y.compareTo(fromY) * (turn == 'r' ? -1 : 1) > 0) {
          // Nằm trước quân đang xét
          if (cr == 0) {
            s1 = figureOrd[turn]![0] + pieceName; // tr/s + tên quân
            c++;
          } else {
            s1 = figureOrd[turn]![0] +
                figureValues[turn]![8 - fromX]; // tr/s + số thứ tự cột
            c++;
          }
        } else if (y == fromY) {
          if (c == 0) {
            s1 = pieceName +
                figureValues[turn]![8 - fromX]; // tên quân + số thứ tự cột
          } else {
            cc = c;
          }
        } else {
          // Nằm sau quân đang xét
          if (cr == 0) {
            if (c == 0) {
              s1 = figureOrd[turn]![1] + pieceName; // s/tr + tên quân
            } else {
              // Giữ nguyên 'g' + tên quân
              s1 = 'g$pieceName';
              c++;
            }
          } else {
            if (c == 0) {
              s1 = figureOrd[turn]![1] +
                  figureValues[turn]![8 - fromX]; // s/tr + số thứ tự cột
            } else {
              // Giữ nguyên 'g' + số thứ tự cột
              s1 = 'g${figureValues[turn]![8 - fromX]}';
              c++;
            }
          }
        }
      }

      if (c > 2 && c != cc) {
        s1 = figureValues[turn]![cc] + pieceName;
      }
    } else {
      s1 = pieceName + figureValues[turn]![8 - fromX];
    }

    // Xử lý s2
    if (fromY > toY) {
      if (fromX == toX) {
        s2 = figureDir[turn]![1] + (fromY - toY).toString();
      } else {
        s2 = figureDir[turn]![1] + figureValues[turn]![8 - toX];
      }
    } else if (fromY == toY) {
      s2 = figureDir['p']![0] + figureValues[turn]![8 - toX];
    } else {
      if (fromX == toX) {
        s2 = figureDir[turn]![0] + (toY - fromY).toString();
      } else {
        s2 = figureDir[turn]![0] + figureValues[turn]![8 - toX];
      }
    }

    return s1 + s2;
  }

  String simpleMove(dynamic input) {
    final move = _buildMoveFromInput(input: input);
    final san = moveToJsChinese(move);
    if (getCurrentTurn() == 'r') {
      moveNumber++;
    }
    move.san = san;
    makeMove(move);
    if (history.isNotEmpty) {
      (history.last as dynamic)['move'].moveNumber = moveNumber;
    }
    return san;
  }
}

String getSanMovesFromfenAndNotations(
    {required String fen, required String chainNotation}) {
  final xiangqi = Xiangqi(fen: fen);
  final List<String> moves = chainNotation.split(" ");
  String sans = '';
  for (int i = 0; i < moves.length; i++) {
    String san = xiangqi.simpleMove(moves[i]);
    sans += ' $san';
  }
  return sans;
}
