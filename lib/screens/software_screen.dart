import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/engine/rose.dart';
import 'package:rose_chess/providers/book_state.dart';
import 'package:rose_chess/providers/navigation_state.dart';
import '../engine/rose_state.dart';
import '../generated/l10n.dart';
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

class _SoftwareScreenState extends State<SoftwareScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
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
        ChangeNotifierProvider(
          create: (context) => NavigationState(),
        ),
        ChangeNotifierProxyProvider4<EngineAnalysisState, ArrowState, BookState,
            NavigationState, BoardState>(
          create: (context) => BoardState(
            widget.engineFileName,
            Provider.of<EngineAnalysisState>(context, listen: false),
            Provider.of<ArrowState>(context, listen: false),
            Provider.of<BookState>(context, listen: false),
            Provider.of<NavigationState>(context, listen: false),
          ),
          update: (context, engineAnalysisState, arrowState, bookState,
                  navigationState, previous) =>
              previous ??
              BoardState(widget.engineFileName, engineAnalysisState, arrowState,
                  bookState, navigationState),
        ),
      ],
      child: EngineWrapper( // Wrap the Scaffold with EngineWrapper
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Consumer<BoardState>(
              builder: (context, boardState, child) {
                // Initialize board state only once after the first frame
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  boardState.setLang(lang);
                  if (!boardState.isBoardInitialized) {
                    boardState.newGame();
                  }
                });

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
      ),
    );
  }
}

// EngineWrapper widget to handle engine initialization and app lifecycle events
class EngineWrapper extends StatefulWidget {
  final Widget child;

  const EngineWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _EngineWrapperState createState() => _EngineWrapperState();
}

class _EngineWrapperState extends State<EngineWrapper> with WidgetsBindingObserver {
  late BoardState _boardState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _boardState = Provider.of<BoardState>(context, listen: false);
    _initEngineIfNeeded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.resumed) {
      _initEngineIfNeeded();
    } else if (state == AppLifecycleState.paused) {
      _boardState.pauseGame();
    }
  }

  void _initEngineIfNeeded() {
    if (_boardState.roseEngine == null ||
        _boardState.roseEngine!.state.value != RoseState.ready) {
      print('Initializing or re-initializing engine');
      _boardState.initEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}