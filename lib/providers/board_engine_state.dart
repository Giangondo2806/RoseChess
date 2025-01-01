import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rose_chess/models/engine_info.dart';
import 'package:rose_chess/providers/arrow_state.dart';
import 'package:rose_chess/providers/board_state.dart';
import 'package:rose_chess/providers/book_state.dart';
import 'package:rose_chess/providers/navigation_state.dart';
import '../engine/rose.dart';
import '../engine/rose_state.dart';
import '../generated/l10n.dart';
import '../models/piece.dart';
import '../models/board_position.dart';
import '../utils/xiangqi.dart';
import 'engine_analysis_state.dart';

class BoardEngineState extends BoardState {
  // Board dimensions
 
  List<String> canMoves = [];
  Rose? _roseEngine;
  bool _connectedEngine = false;
  bool _isSettingEngine = false;
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
  late AppLocalizations lang;
  StreamSubscription<String>? _engineOutputSubscription;
  final List<Map<BoardPosition, Piece?>> _boardHistory = [];
  bool _automoveRed = false;
  bool _automoveBlack = false;
  bool _searchModeEnabled = false;
  bool get automoveRed => _automoveRed;
  bool get automoveBlack => _automoveBlack;
  bool get searchModeEnabled => _searchModeEnabled;
  late String _lastBestMove;
  String get _currentFen {
    final current = navigationState.currentMove - 1;
    return current >= 0
        ? xiangqi.getHistory(verbose: true)[current].fen
        : xiangqi.initFen;
  }

  BoardEngineState(this.engineFileName, this.engineAnalysisState, this.arrowState,
      this._bookState, this.navigationState) {
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

// Xử lý khi chưa có quân cờ nào được chọn
  void _handleNewPieceSelection(BoardPosition position) {
    if (board[position] != null) {
      _selectPiece(position);
      if (canMoves.isEmpty) {
        _deselectPiece();
      }
    }
  }

// Xử lý khi đã có quân cờ được chọn
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

// Chọn một quân cờ
  void _selectPiece(BoardPosition position) {
    selectedPosition = position;

    // print('[currentFen] $_currentFen');
    final xiangqiCanmove = Xiangqi(fen: _currentFen);
    canMoves = xiangqiCanmove
        .generatePrettyMoves(square: selectedPosition!.notation)
        .map((el) => el.iccs!)
        .toList();
  }

// Bỏ chọn quân cờ
  void _deselectPiece() {
    selectedPosition = null;
    canMoves = [];
  }

// Kiểm tra nước đi hợp lệ
  bool _isValidMove(
      Piece? selectedPiece, Piece? targetPiece, BoardPosition targetPosition) {
    return selectedPiece != null &&
        (targetPiece == null || targetPiece.color != selectedPiece.color) &&
        canMoves.contains(selectedPosition!.notation + targetPosition.notation);
  }

// Kiểm tra xem có thể chọn quân cờ mới hay không
  bool _canSelectNewPiece(Piece? targetPiece, Piece? selectedPiece) {
    return targetPiece != null && targetPiece.color == selectedPiece?.color;
  }

// Di chuyển quân cờ
  void _handleMovePiece(BoardPosition from, BoardPosition to, Piece piece) {
    if (_boardHistory.length - 1 != navigationState.currentMove) {
      _handleSyncXiangqiMove();
    }

    engineAnalysisState.clearAnalysis();
    xiangqi.simpleMove({'from': from.notation, 'to': to.notation});
    _bookState.getbook(xiangqi.generateFen(), lang);
    arrowState.clearArrows();
    navigationState.setNavigation(xiangqi.getHistory(verbose: true));
    movePiece(from, to, piece);
    _boardHistory.add(Map.from(board));
    if (_searchModeEnabled) {
      _engineSearch('$initFen - - moves ${xiangqi.getHistory().join(' ')}');
    }

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

  // void _movePiece(BoardPosition from, BoardPosition to, Piece piece) {
  //   board[to] = piece;
  //   board[from] = null;
  //   piecePositions[piece.id] = to;
  //   selectedPosition = null;
  // }

  void gotoBoard({int index = 0}) {
    pauseEngine();
    _searchModeEnabled = false;
    engineAnalysisState.clearAnalysis();
    Future.delayed(Duration(milliseconds: 10), () {
      arrowState.clearArrows();
    });
    if (index < _boardHistory.length) {
      board = Map.from(_boardHistory[index]);
      selectedPosition = null;
      notifyListeners();
    }
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
        notifyListeners();
        break;
    }
  }

  

  void newGame({String? fen}) {
    _searchModeEnabled=false;
    if (roseEngine?.state.value == RoseState.ready) {
      pauseEngine();
    }

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
    notifyListeners();
  }

  Future<void> initEngine() async {
    if (_isEngineInitializing) {
      return;
    }

    _isEngineInitializing = true;
    try {
      _roseEngine = GetIt.instance.get<Rose>();

      debugPrint("state engine: ${_roseEngine!.state.value}");
      if (_roseEngine != null) {
        _engineOutputSubscription?.cancel();
        _engineOutputSubscription = _roseEngine?.stdout.listen((line) {
          if (line.startsWith('started')) {
            if (_roseEngine!.state.value == RoseState.ready) {
              _settingEngine();
            }
          } else if (line == 'readyok') {
            if (true) {
              _readyOkReceived = true;
              notifyListeners();
            }
          } else if (line.startsWith('info depth')) {
            final info = parseEngineInfo(
                fen: xiangqi.generateFen(), input: line, lang: lang);

            if (info != null) {
              engineAnalysisState.addAnalysis(info);
              _extractMoves(line);
              _lastBestMove = info.bestmove;
            }
          } else if (line.startsWith('bestmove')) {
            _handleEngineBestMove(line);
          }
        });
        if (_roseEngine!.state.value == RoseState.ready) {
          _connectedEngine = true;
        } else {
          _roseEngine?.state.addListener(_engineStateListener);
        }
      }
    } catch (error) {
      print('Error init engine: $error');
    } finally {
      _isEngineInitializing = false;
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
      print('current fen $_currentFen');
      _engineSearch(_currentFen);
    } else {
      pauseEngine();
      Future.delayed(Duration(milliseconds: 10), () {
        arrowState.clearArrows();
      });
    }

    notifyListeners();
  }

  void _engineStateListener() {
    if (_roseEngine?.state.value == RoseState.ready) {
      _connectedEngine = true;
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
    if (_isSettingEngine) return;
    _isSettingEngine = true;
    _roseEngine?.stdin = 'uci\n';
    _roseEngine?.stdin = 'setoption name Threads value 2\n';
    _roseEngine?.stdin = 'setoption name Hash value 64\n';
    _roseEngine?.stdin = 'setoption name Evalfile value $engineFileName \n';
    _roseEngine?.stdin = 'isready\n';
    _isSettingEngine = false;
    notifyListeners();
  }

  void pauseEngine() {
    _roseEngine?.stdin = 'stop\n';
  }

  void resumeGame() {
    _engineSearch('$initFen - - moves ${xiangqi.getHistory().join(' ')}');
    notifyListeners(); // Important: Cập nhật UI sau khi khôi phục trạng thái
  }

  void _engineSearch(String fen) {
    if (!_connectedEngine || !_readyOkReceived) return;

    _roseEngine?.stdin = 'stop\n';
    _roseEngine?.stdin = 'position fen $fen\n';
    _roseEngine?.stdin = 'go\n';
    engineAnalysisState.clearAnalysis();
    notifyListeners(); // Cập nhật giao diện
  }

  void _engineSearchMoveTime(String fen, int moveTime) {
    if (!_connectedEngine || !_readyOkReceived) return;

    _roseEngine?.stdin = 'stop\n';
    _roseEngine?.stdin = 'position fen $fen\n';
    _roseEngine?.stdin = 'go movetime $moveTime\n';
    engineAnalysisState.clearAnalysis();
    notifyListeners(); // Cập nhật giao diện
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
      final _fen = '$initFen - - moves ${xiangqi.getHistory().join(' ')}';
      _engineSearchMoveTime(_fen, 1000);
    }
  }

  void _handleEngineSearchRed() {
    if (xiangqi.turn == XiangqiColor.RED) {
      final _fen = '$initFen - - moves ${xiangqi.getHistory().join(' ')}';
      _engineSearchMoveTime(_fen, 1000);
    }
  }

  void _handleEngineBestMove(String line) {
    final bestMove = line.split(' ')[1];
    _moveWithNotation(bestMove);

    notifyListeners();
  }

  void _moveWithNotation(String notation) {
    final from = BoardPosition(notation.substring(0, 2));
    final to = BoardPosition(notation.substring(2, 4));
    final piece = board[from];
    if (piece != null && piece.color.name == xiangqi.turn) {
      _handleMovePiece(from, to, piece);
    }
  }

  void _handleQuickMove() {
    if (_searchModeEnabled && _lastBestMove.isNotEmpty) {
      _moveWithNotation(_lastBestMove);
    }

    notifyListeners();
  }
}
