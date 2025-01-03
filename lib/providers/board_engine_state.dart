import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rose_chess/database/repositories/move_repository.dart';
import 'package:rose_chess/models/engine_info.dart';
import 'package:rose_chess/providers/arrow_state.dart';
import 'package:rose_chess/providers/board_state.dart';
import 'package:rose_chess/providers/book_state.dart';
import 'package:rose_chess/providers/graph_state.dart';
import 'package:rose_chess/providers/navigation_state.dart';
import 'package:rose_chess/services/service_locator.dart';
import '../database/database.dart';
import '../engine/rose.dart';
import '../engine/rose_state.dart';
import '../generated/l10n.dart';
import '../models/piece.dart';
import '../models/board_position.dart';
import '../utils/xiangqi.dart';
import 'engine_analysis_state.dart';

class BoardEngineState extends BoardState {
  List<String> canMoves = [];
  Rose? _roseEngine;
  bool _connectedEngine = false;
  bool _readyOkReceived = false;
  late String engineFileName;
  bool _isBoardInitialized = false;
  bool _isEngineInitializing = false;
  Rose? get roseEngine => _roseEngine;
  bool get isEngineInitializing => _isEngineInitializing;
  bool get engineReady => _readyOkReceived;
  bool get isBoardInitialized => _isBoardInitialized;
  late EngineAnalysisState engineAnalysisState;
  late final BookState _bookState;
  late ArrowState arrowState;
  late NavigationState navigationState;
  late GraphState graphState;
  late AppLocalizations lang;
  StreamSubscription<String>? _engineOutputSubscription;
  final List<Map<BoardPosition, Piece?>> _boardHistory = [];

  //flag for auto move red and black and searchmode
  bool _automoveRed = false;
  bool _automoveBlack = false;
  bool _searchModeEnabled = false;
  bool get automoveRed => _automoveRed;
  bool get automoveBlack => _automoveBlack;
  bool get searchModeEnabled => _searchModeEnabled;

  //flag for inserdb
  bool _inserdb = false;

  late String _lastBestMove;
  final chessRepo = getIt.get<ChessRepository>();

  String get _currentFen {
    final current = navigationState.currentMove;
    final histories = xiangqi.getHistory(verbose: true);

    return current <= histories.length - 1 && current > 0
        ? xiangqi.getHistory(verbose: true)[current].fen
        : xiangqi.generateFen();
  }

  BoardEngineState(this.engineFileName, this.engineAnalysisState,
      this.arrowState, this._bookState, this.navigationState, this.graphState) {
    board = {};
  }

  setLang(AppLocalizations inputLang) {
    lang = inputLang;
  }

  @override
  void onPieceTapped(BoardPosition position) {
    if (selectedPosition == null) {
      _handleNewPieceSelection(position);
    } else {
      _handleExistingPieceSelection(position);
    }
    notifyListeners();
  }

  void _handleNewPieceSelection(BoardPosition position) {
    if (board[position] != null) {
      _selectPiece(position);
      if (canMoves.isEmpty) {
        _deselectPiece();
      }
    }
  }

  void _handleExistingPieceSelection(BoardPosition position) {
    if (position == selectedPosition) {
      _deselectPiece();
    } else {
      final selectedPiece = board[selectedPosition];
      final targetPiece = board[position];

      if (_isValidMove(selectedPiece, targetPiece, position)) {
        _handleMovePiece(selectedPosition!, position, selectedPiece!);
      } else if (_canSelectNewPiece(targetPiece, selectedPiece)) {
        _selectPiece(position);
        if (canMoves.isEmpty) {
          _deselectPiece();
        }
      }
    }
  }

  void _selectPiece(BoardPosition position) {
    selectedPosition = position;

    final xiangqiCanmove = Xiangqi(fen: _currentFen);
    canMoves = xiangqiCanmove
        .generatePrettyMoves(square: selectedPosition!.notation)
        .map((el) => el.iccs!)
        .toList();
  }

  void _deselectPiece() {
    selectedPosition = null;
    canMoves = [];
  }

  bool _isValidMove(
      Piece? selectedPiece, Piece? targetPiece, BoardPosition targetPosition) {
    return selectedPiece != null &&
        (targetPiece == null || targetPiece.color != selectedPiece.color) &&
        canMoves.contains(selectedPosition!.notation + targetPosition.notation);
  }

  bool _canSelectNewPiece(Piece? targetPiece, Piece? selectedPiece) {
    return targetPiece != null && targetPiece.color == selectedPiece?.color;
  }

  Future<void> _handleMovePiece(
      BoardPosition from, BoardPosition to, Piece piece) async {
    if (_boardHistory.length - 1 != navigationState.currentMove) {
      _handleSyncXiangqiMove();
    }
    _inserdb = true;
    // if (_searchModeEnabled || _automoveRed || _automoveBlack) {
    //   return;
    // }

    // datamove = BaseMovesCompanion(
    //   fen: Value(xiangqi.generateFen()),
    //   notation: Value(from.notation+to.notation),
    // );

    // final chessRepo = getIt.get<ChessRepository>();
    // await chessRepo.insertOrUpdateBaseMove(datamove);

    // chessRepo.insertBaseMove(datamove);

    engineAnalysisState.clearAnalysis();
    xiangqi.simpleMove({'from': from.notation, 'to': to.notation});
    _bookState.getbook(xiangqi.generateFen(), lang);
    arrowState.clearArrows();
    navigationState.setNavigation(xiangqi.getHistory(verbose: true));
    movePiece(from, to, piece);
    _boardHistory.add(Map.from(board));
    // if (_searchModeEnabled) {
    _engineSearch('$initFen - - moves ${xiangqi.getHistory().join(' ')}');
    // }

    final turn = xiangqi.turn;
    if (_automoveBlack && turn == XiangqiColor.BLACK) {
      _handleEngineSearchBlack();
    }

    if (_automoveRed && turn == XiangqiColor.RED) {
      _handleEngineSearchRed();
    }

    _deselectPiece();
  }

  _handleSyncXiangqiMove() {
    final currentMove = navigationState.currentMove;
    xiangqi.setCurrentMove(currentMove: currentMove);
    _boardHistory.removeRange(currentMove + 1, _boardHistory.length);
  }

  void gotoBoard({int index = 0}) {
    // _searchModeEnabled = false;
    // pauseEngine();
    _inserdb = false;

    if (index < _boardHistory.length) {
      board = Map.from(_boardHistory[index]);
      selectedPosition = null;
    }

    print('[current] $_currentFen');
    _engineSearch(_currentFen);
    Future.delayed(Duration(milliseconds: 10), () {
      engineAnalysisState.clearAnalysis();
      arrowState.clearArrows();
      notifyListeners();
    });
  }

  void handleMenuAction(String action) {
    switch (action) {
      case 'new_game':
        newGame();
        break;
      case 'auto_red':
        _autoRed();
        break;
      case 'auto_black':
        _autoBlack();
        break;
      case 'enable_engine':
        _toggleEngine();
        break;
      case 'quick_move':
        _handleQuickMove();
        break;
      case 'copy':
        Clipboard.setData(ClipboardData(text: _currentFen));
        break;
      case 'flip_board':
        isFlipped = !isFlipped;
        break;
    }
  }

  void newGame({String? fen}) {
    _searchModeEnabled = false;
    _inserdb = false;
    // if (roseEngine?.state.value == RoseState.ready) {
    //   pauseEngine();
    // }

    _boardHistory.clear();
    engineAnalysisState.clearAnalysis();
    Future.delayed(Duration(milliseconds: 10), () {
      arrowState.clearArrows();
    });

    navigationState.clearNavigation();
    selectedPosition = null;
    initializeBoard(lang: lang, fen: fen);
    _isBoardInitialized = true;
    _bookState.getbook(initFen, lang);
    _boardHistory.add(Map.from(board));
    _engineSearch(initFen);
    notifyListeners();
  }

  Future<void> initEngine() async {
    if (_isEngineInitializing) {
      return;
    }

    _isEngineInitializing = true;
    try {
      _roseEngine = GetIt.instance.get<Rose>();
      if (_roseEngine != null) {
        _engineOutputSubscription?.cancel();
        _engineOutputSubscription =
            _roseEngine?.stdout.listen(_handleEngineOutput);
        if (_roseEngine!.state.value == RoseState.ready) {
          _connectedEngine = true;
        } else {
          _roseEngine?.state.addListener(_engineStateListener);
        }
      }
    } catch (error) {
      debugPrint('[rose] Error init engine: $error');
    } finally {
      _isEngineInitializing = false;
    }
  }

  void _handleEngineOutput(String line) {
    if (line == 'readyok') {
      _processingReadyOk();
    } else if (line.startsWith('info depth')) {
      _processingInfoDepth(line);
    } else if (line.startsWith('bestmove')
        // &&(_automoveBlack || _automoveRed)
        ) {
      _handleEngineBestMove(line);
    }
  }

  void _processingReadyOk() {
    _readyOkReceived = true;
    notifyListeners();
  }

  void _processingInfoDepth(String line) {
    final info = parseEngineInfo(fen: _currentFen, input: line, lang: lang);
    if (info != null) {
      if (searchModeEnabled) {
        engineAnalysisState.addAnalysis(info);
        _extractMoves(line);
      }
      _lastBestMove = info.bestmove;
   
      if (xiangqi.history.isNotEmpty) {
        xiangqi.history.last['move'].evaluation =
            xiangqi.history.last['move'].color == 'r'
                ? -info.evaluation
                : info.evaluation;
        final history = xiangqi.getHistory(verbose: true);
        final fen = history.last.fen;
        final notation = history.last.iccs;

        graphState.setMoves(history);

        if (_inserdb) {
          final datamove = BaseMovesCompanion(
              fen: Value(fen),
              notation: Value(notation),
              depth: Value(info.depth),
              evaluation: Value(info.evaluation));

          // chessRepo.insertOrUpdateBaseMove(datamove);
        }
      }
    }
  }

  void _autoRed() {
    _automoveRed = !_automoveRed;
    if (_searchModeEnabled) {
      _searchModeEnabled = false;
    }
    if (_automoveRed) {
      _handleEngineSearchRed();
    }
    notifyListeners();
  }

  void _autoBlack() {
    _automoveBlack = !_automoveBlack;
    if (_searchModeEnabled) {
      _searchModeEnabled = false;
    }
    if (_automoveBlack) {
      _handleEngineSearchBlack();
    }
    notifyListeners();
  }

  void _toggleEngine() {
    _searchModeEnabled = !_searchModeEnabled;
    if (_searchModeEnabled) {
      _automoveRed = false;
      _automoveBlack = false;
      _engineSearch(_currentFen);
    }
    // pauseEngine();
    Future.delayed(Duration(milliseconds: 10), () {
      engineAnalysisState.clearAnalysis();
      arrowState.clearArrows();
    });

    notifyListeners();
  }

  void _engineStateListener() {
    if (_roseEngine?.state.value == RoseState.ready) {
      _connectedEngine = true;
      if (_roseEngine!.state.value == RoseState.ready) {
        _settingEngine();
      }
      notifyListeners();
    } else if (_roseEngine?.state.value == RoseState.error) {
      if (true) {
        _connectedEngine = false;
        _readyOkReceived = false;
        notifyListeners();
      }
      initEngine();
    } else {
      print('Engine state update to ${_roseEngine?.state.value}');
    }
  }

  void _extractMoves(String line) {
    try {
      arrowState.addArrows(line);
    } catch (e) {
      print('[rose] extract move $e');
    }
  }

  Future<void> _settingEngine() async {
    _roseEngine?.stdin = 'uci\n';
    _roseEngine?.stdin = 'setoption name Threads value 2\n';
    _roseEngine?.stdin = 'setoption name Hash value 64\n';
    _roseEngine?.stdin = 'setoption name Evalfile value $engineFileName \n';
    _roseEngine?.stdin = 'isready\n';
    notifyListeners();
  }

  void pauseEngine() {
    _roseEngine?.stdin = 'stop\n';
  }

  void resumeGame() {
    _engineSearch('$initFen - - moves ${xiangqi.getHistory().join(' ')}');
    notifyListeners();
  }

  void _engineSearch(String fen) {
    if (!_connectedEngine || !_readyOkReceived) return;
    _roseEngine?.stdin = 'stop\n';
    _roseEngine?.stdin = 'position fen $fen\n';
    _roseEngine?.stdin = 'go\n';
    engineAnalysisState.clearAnalysis();
    notifyListeners();
  }

  void _engineSearchMoveTime(String fen, int moveTime) {
    if (!_connectedEngine || !_readyOkReceived) return;

    _roseEngine?.stdin = 'stop\n';
    _roseEngine?.stdin = 'position fen $fen\n';
    _roseEngine?.stdin = 'go movetime $moveTime\n';
    engineAnalysisState.clearAnalysis();
    notifyListeners();
  }

  @override
  void dispose() {
    _engineOutputSubscription?.cancel();
    _roseEngine = null;
    _isEngineInitializing = false;
    super.dispose();
  }

  void _handleEngineSearchBlack() {
    if (xiangqi.turn == XiangqiColor.BLACK) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _moveWithNotation(null);
      });
      // final fen = '$initFen - - moves ${xiangqi.getHistory().join(' ')}';
      // _engineSearchMoveTime(fen, 1000);
    }
  }

  void _handleEngineSearchRed() {
    if (xiangqi.turn == XiangqiColor.RED) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _moveWithNotation(null);
      });
      // final fen = '$initFen - - moves ${xiangqi.getHistory().join(' ')}';
      // _engineSearchMoveTime(fen, 1000);
    }
  }

  void _handleEngineBestMove(String line) {
    _lastBestMove = line.split(' ')[1];
    // _moveWithNotation(bestMove);

    // notifyListeners();
  }

  void _moveWithNotation(String? notation) {
    notation ??= _lastBestMove;
    final from = BoardPosition(notation.substring(0, 2));
    final to = BoardPosition(notation.substring(2, 4));
    final piece = board[from];
    if (piece != null && piece.color.name == xiangqi.turn) {
      _handleMovePiece(from, to, piece);
    }
    notifyListeners();
  }

  void _handleQuickMove() {
    if (_lastBestMove.isNotEmpty) {
      _moveWithNotation(_lastBestMove);
    }
  }
}
