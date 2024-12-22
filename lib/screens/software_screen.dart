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
  bool _engineInitialized = false;
  BoardState? _boardState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cleanupEngine();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _cleanupEngine() {
    if (_boardState != null) {
      _boardState!.pauseGame();
      _engineInitialized = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_boardState == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _initializeEngineIfNeeded();
        if (_boardState!.isBoardInitialized) {
          _boardState!.resumeGame();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _boardState!.pauseGame();
        break;
      default:
        break;
    }
  }

  void _initializeEngineIfNeeded() {
    if (!_engineInitialized && _boardState != null) {
      _boardState!.initEngine().then((_) {
        if (mounted) {
          setState(() {
            _engineInitialized = true;
          });
        }
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _cleanupEngine();
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
              previous) {
            final boardState = previous ??
                BoardState(widget.engineFileName, engineAnalysisState, arrowState,
                    bookState);
            _boardState = boardState;
            return boardState;
          },
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Consumer<BoardState>(
            builder: (context, boardState, child) {
              // Initialize engine after first build
              if (!_engineInitialized) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _initializeEngineIfNeeded();
                  if (!boardState.isBoardInitialized) {
                    boardState.newGame();
                  }
                });
              }

              return Column(
                children: [
                  MenuBarWidget(
                    onMenuAction: boardState.handleMenuAction,
                  ),
                  ChessBoardWidget(boardState: boardState),
                  const Expanded(child: AnalysisWidget()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}