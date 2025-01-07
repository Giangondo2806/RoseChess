import 'package:flutter/material.dart';
import 'package:rose_chess/providers/board_engine_state.dart';
import 'package:rose_chess/utils/xiangqi.dart';
import 'package:rose_chess/widgets/navigation_content_widget.dart';

class NavigationState with ChangeNotifier {
  List<dynamic> _moves = [];
  List<dynamic> get moves => _moves;
  late BoardEngineState _boardState;
  int _currentMove = 0;
  get currentMove => _currentMove;
  Move? get hightLightMove =>
      _currentMove - 1 >= 0 ? _moves[_currentMove - 1] : null;
  NavigationContentState? _navigationContentState;
  late ScrollController _scrollController;
  set scrollController(ScrollController scrollController) {
    _scrollController = scrollController;
  }

  void setNavigationContentState(
      NavigationContentState navigationContentState) {
    _navigationContentState = navigationContentState;
  }

  void clearNavigation() {
    _moves.clear();
    _currentMove = 0;
    notifyListeners();
  }

  void setNavigation(List<dynamic> data) {
    _moves = data;
    _currentMove = _moves.length;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToHighlightedMove();
    });
  }

  void setBoardState({required boardState}) {
    _boardState = boardState;
  }

  void previousMove() {
    if (_currentMove > 0) {
      _currentMove--;
      _boardState.gotoBoard(index: _currentMove);
      notifyListeners();
      _scrollToHighlightedMove();
    }
  }

  void nextMove() {
    if (_currentMove < _moves.length) {
      _currentMove++;
      _boardState.gotoBoard(index: _currentMove);
      notifyListeners();
      _scrollToHighlightedMove();
    }
  }

  void gotoMove(Move move) {
    final index = _moves.indexOf(move) + 1;
    _currentMove = index;
    _boardState.gotoBoard(index: _currentMove);
    notifyListeners();
    _scrollToHighlightedMove();
  }

  void gotoFistMove() {
    _currentMove = 0;
    _boardState.gotoBoard(index: _currentMove);
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300), // Thời gian ngắn hơn
          curve: Curves.easeInOut, // Bạn có thể thay đổi curve
        );
      }
    });
  }

  void gotoLastMove() {
    _currentMove = _moves.length;
    _boardState.gotoBoard(index: _currentMove);
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), // Thời gian ngắn hơn
          curve: Curves.easeInOut, // Bạn có thể thay đổi curve
        );
      }
    });
  }

  void _scrollToHighlightedMove() {
    if (hightLightMove == null) return;
    final index = (_moves.indexOf(hightLightMove) / 2).floor();

    // Tìm context của item được highlight
    final itemContext =
        _navigationContentState?.itemKeys[index]?.currentContext;

    if (itemContext != null) {
      // Đảm bảo item được hiển thị trong viewport
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          itemContext,
          duration: const Duration(
              milliseconds: 300), // Bạn có thể tùy chỉnh duration
          curve: Curves.easeInOut, // Bạn có thể tùy chỉnh curve
          alignment: 0.5, // Đưa item vào giữa viewport (tùy chọn)
        );
      });
    }
  }
}
