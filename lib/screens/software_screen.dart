import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/providers/book_state.dart';
import '../providers/arrow_state.dart';
import '../providers/board_state.dart';
import '../providers/engine_analysis_state.dart';
import '../widgets/analysis_widget.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/menu_bar_widget.dart';

class SoftwareScreen extends StatefulWidget {
  final String engineFileName;

  const SoftwareScreen({Key? key, required this.engineFileName})
      : super(key: key);

  @override
  State<SoftwareScreen> createState() => _SoftwareScreenState();
}

class _SoftwareScreenState extends State<SoftwareScreen>
    with WidgetsBindingObserver {
  bool _initialized = false; // Thêm biến flag để đánh dấu

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final boardState = Provider.of<BoardState>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      boardState.initEngine();
      if (boardState.isBoardInitialized) {
        boardState.resumeGame();
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      boardState.pauseGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EngineAnalysisState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ArrowState(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookState(), 
        ),
        ChangeNotifierProxyProvider3<EngineAnalysisState, ArrowState, BookState,
            BoardState>(
          create: (context) => BoardState(
            widget.engineFileName,
            Provider.of<EngineAnalysisState>(context, listen: false),
            Provider.of<ArrowState>(context, listen: false),
            Provider.of<BookState>(context, listen: false),
          ),
          update: (context, engineAnalysisState, arrowState, bookState,
                  previous) =>
              previous ??
              BoardState(widget.engineFileName, engineAnalysisState, arrowState,
                  bookState),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Consumer<BoardState>(
            builder: (context, boardState, child) {
              // Di chuyển logic khởi tạo vào đây
              if (!_initialized) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  boardState.initEngine();
                  if (!boardState.isBoardInitialized) {
                    boardState.newGame();
                  }
                });
                _initialized = true;
              }

              return Column(
                children: [
                  MenuBarWidget(
                    onMenuAction: boardState.handleMenuAction,
                  ),
                  ChessBoardWidget(boardState: boardState),
                  Expanded(child: AnalysisWidget()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
