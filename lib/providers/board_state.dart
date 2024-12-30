import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rose_chess/models/engine_info.dart';
import 'package:rose_chess/providers/arrow_state.dart';
import 'package:rose_chess/providers/book_state.dart';
import 'package:rose_chess/providers/navigation_state.dart';
import '../engine/rose.dart';
import '../engine/rose_state.dart';
import '../generated/l10n.dart';
import '../models/piece.dart';
import '../models/board_position.dart';
import '../utils/xiangqi.dart';
import 'engine_analysis_state.dart';

class BoardState with ChangeNotifier {
  // Board dimensions
  final int rows = 10;
  final int cols = 9;
  late Xiangqi xiangqi;
  List<String> canMoves = [];
  late String initFen;
  late Map<BoardPosition, Piece?> board;
  BoardPosition? selectedPosition;
  late Map<String, BoardPosition> piecePositions;
  Rose? _roseEngine;
  bool _connectedEngine = false;
  bool _isSettingEngine = false;
  bool _readyOkReceived = false;
  String engineFileName;
  bool _isBoardInitialized = false;
  bool _isEngineInitializing = false;
  Rose? get roseEngine => _roseEngine;
  bool get isEngineInitializing => _isEngineInitializing;
  bool get engineReady => _readyOkReceived;
  bool get isBoardInitialized => _isBoardInitialized;
  late EngineAnalysisState engineAnalysisState;
  late BookState bookState;
  late ArrowState arrowState;
  late NavigationState navigationState;
  late AppLocalizations lang;
  StreamSubscription<String>? _engineOutputSubscription;
  final List<Map<BoardPosition, Piece?>> _boardHistory = [];

  BoardState(this.engineFileName, this.engineAnalysisState, this.arrowState,
      this.bookState, this.navigationState) {
    board = {};
  }

  setLang(AppLocalizations inputLang) {
    lang = inputLang;
  }

  void newGame() {
    if (roseEngine?.state.value == RoseState.ready) {
      pauseGame();
    }

    _boardHistory.clear();
    engineAnalysisState.clearAnalysis();
    Future.delayed(Duration(milliseconds: 10), () {
     arrowState.clearArrows();
    });
    
    navigationState.clearNavigation();
    selectedPosition = null;
    _isBoardInitialized = false;
    _initializeBoard();
    notifyListeners();
  }

  void _initializeBoard() {
    if (_isBoardInitialized) return;
    piecePositions = {};
    board = {};
    xiangqi = Xiangqi();
    initFen = xiangqi.generateFen();
    bookState.getbook(initFen, lang);

    var initialBoard = xiangqi.getBoard();
    int idCounter = 0;
    for (int i = 0; i < initialBoard.length; i++) {
      for (int j = 0; j < initialBoard[i].length; j++) {
        final pieceData = initialBoard[i][j];
        if (pieceData != null) {
          // Đảm bảo BoardPosition luôn có notation
          if (pieceData.notion == null) {
            throw Exception("Piece data notion is null at i=$i, j=$j");
          }
          final piece = createPieceFromData(pieceData, idCounter);
          board[BoardPosition(pieceData.notion!)] = piece;
          piecePositions[piece.id] = BoardPosition(pieceData.notion!);
          idCounter++;
        }
      }
    }

    _boardHistory.add(Map.from(board));
    _isBoardInitialized = true;
  }



  void onPieceTapped(BoardPosition position) {
 
    
    if (selectedPosition== null) {
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
    final current = navigationState.currentMove-1;
    final xiangqiCanmove  = current>=0? Xiangqi(fen:xiangqi.getHistory(verbose: true)[current].fen):Xiangqi(fen:xiangqi.initFen);
    canMoves =  xiangqiCanmove
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
       if(_boardHistory.length-1 !=navigationState.currentMove){
      _handleSyncXiangqiMove();
    }
    
    engineAnalysisState.clearAnalysis();
    xiangqi.simpleMove({'from': from.notation, 'to': to.notation}, lang: lang);
    bookState.getbook(xiangqi.generateFen(), lang);
    _movePiece(from, to, piece); // Hàm _movePiece của bạn để cập nhật giao diện
    _engineSearch('$initFen - - moves ${xiangqi.getHistory().join(' ')}');
    arrowState.clearArrows();
    navigationState.setNavigation(xiangqi.getHistory(verbose: true));
    _boardHistory.add(Map.from(board));
    _deselectPiece();
  }

  _handleSyncXiangqiMove(){
    final currentMove = navigationState.currentMove;
    xiangqi.setCurrentMove(currentMove: currentMove);
    _boardHistory.removeRange(currentMove+1, _boardHistory.length);
  }

  void _movePiece(BoardPosition from, BoardPosition to, Piece piece) {
    board[to] = piece;
    board[from] = null;
    piecePositions[piece.id] = to;
    selectedPosition = null;
  }

  void gotoBoard({int index = 0}) {
    pauseGame();
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
    print('Menu action received: $action');
    switch (action) {
      case 'new_game':
        newGame();
        break;
      case 'detect_image':
        // Xử lý Detect Image
        break;
      case 'flip_board':
        // Xử lý Flip Board
        break;
      case 'settings':
        // Xử lý Settings
        break;
    }
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

            if (info.moves != '') {
              // engineAnalysis.insert(0, info);
              try {
                engineAnalysisState.addAnalysis(info);
                _extractMoves(line);
              } catch (e) {
                print('co loi');
              }

              // notifyListeners(); // Thông báo cho UI cập nhật
            }
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

  void _engineStateListener() {
    if (_roseEngine?.state.value == RoseState.ready) {
      print("Engine is ready");
      _connectedEngine = true;
      notifyListeners();
    } else if (_roseEngine?.state.value == RoseState.error) {
      print("Engine has error");
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

  void pauseGame() {
    _roseEngine?.stdin = 'stop\n';
  }

  void resumeGame() {
    _engineSearch('$initFen - - moves ${xiangqi.getHistory().join(' ')}');
    notifyListeners(); // Important: Cập nhật UI sau khi khôi phục trạng thái
  }

  void _engineSearch(String fen) {
    if (!_connectedEngine || !_readyOkReceived) return;
    // engineAnalysis.clear();
    engineAnalysisState.clearAnalysis();
    _roseEngine?.stdin = 'stop\n';
    _roseEngine?.stdin = 'position fen $fen\n';
    _roseEngine?.stdin = 'go\n';
    notifyListeners(); // Cập nhật giao diện
  }

  @override
  void dispose() {
    _engineOutputSubscription?.cancel();
    _roseEngine = null;
    _isEngineInitializing = false;
    super.dispose();
  }
}
