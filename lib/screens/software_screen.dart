import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/providers/book_state.dart';
import 'package:rose_chess/providers/navigation_state.dart';
import 'package:rose_chess/screens/edit_board_screen.dart';
import '../engine/rose_state.dart';
import '../generated/l10n.dart';
import '../providers/arrow_state.dart';
import '../providers/board_engine_state.dart';
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
            NavigationState, BoardEngineState>(
          create: (context) => BoardEngineState(
            widget.engineFileName,
            Provider.of<EngineAnalysisState>(context, listen: false),
            Provider.of<ArrowState>(context, listen: false),
            Provider.of<BookState>(context, listen: false),
            Provider.of<NavigationState>(context, listen: false),
          ),
          update: (context, engineAnalysisState, arrowState, bookState,
              navigationState, previous) {
            final boardState = previous ??
                BoardEngineState(widget.engineFileName, engineAnalysisState,
                    arrowState, bookState, navigationState);
             navigationState.setBoardState(boardState: boardState);
            return boardState;
          },
        ),
      ],
      child: const EngineWrapper(
        // Wrap the Scaffold with EngineWrapper
        child: Scaffold(
            // Scaffold is now inside EngineWrapper, which handles loading state
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

class _EngineWrapperState extends State<EngineWrapper>
    with WidgetsBindingObserver {
  late BoardEngineState _boardState;
  bool _isLoading = true;
  bool _loadFailed = false;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boardState = Provider.of<BoardEngineState>(context, listen: false);
      _initEngineIfNeeded();
      // Start a timer to check for engine loading status
      _loadingTimer = Timer(const Duration(seconds: 12), () {
        if (mounted && !_boardState.engineReady) {
          setState(() {
            _isLoading = false;
            _loadFailed = true;
          });
        }
      });
      _boardState.addListener(_engineReadyListener);
    });
  }

  void _engineReadyListener() {
    if (mounted && _boardState.engineReady) {
      setState(() {
        _isLoading = false;
      });
      _loadingTimer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _boardState.removeListener(_engineReadyListener);
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initEngineIfNeeded();
    } else if (state == AppLifecycleState.paused) {
      _boardState.pauseGame();
    }
  }

  Future<void> _initEngineIfNeeded() async {
    if (_boardState.roseEngine == null ||
        _boardState.roseEngine!.state.value != RoseState.ready) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _loadFailed = false;
        });
      }
      _boardState.initEngine();
    }
  }

  Future<void> _reloadApp() async {}

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(lang.engineLoading),
            ],
          ),
        ),
      );
    } else if (_loadFailed) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lang.loadFailed),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _reloadApp,
                child: Text(lang.reload),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: Consumer<BoardEngineState>(
            builder: (context, boardState, child) {
              // Initialize board state only once after the first frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                boardState.setLang(lang);
                if (!boardState.isBoardInitialized) {
                  boardState.newGame();
                }
              });

              void onEditBoard() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoardEditScreen(fen: boardState.xiangqi.generateFen()),
                  ),
                );
              }

              return Column(
                children: [
                  MenuBarWidget(
                    onMenuAction: boardState.handleMenuAction,
                    onEditBoard: onEditBoard,
                    automoveRed: boardState.automoveRed,
                    automoveBlack: boardState.automoveBlack,
                    searchModeEnabled: boardState.searchModeEnabled
                  ),
                  ChessBoardWidget(boardState: boardState),
                  Expanded(child: AnalysisWidget()),
                ],
              );
            },
          ),
        ),
      );
    }
  }


}
