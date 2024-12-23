import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/providers/book_state.dart';
import 'package:rose_chess/providers/navigation_state.dart';
import 'package:rose_chess/screens/engine_loader_screen.dart';
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
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EngineLoaderScreen(),
        ),
      );
      // Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

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
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Consumer<BoardState>(
            builder: (context, boardState, child) {
              // Di chuyển logic khởi tạo vào đây

              if (!_initialized) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (boardState.isEngineInitializing) {
                    boardState.dispose();
                    await Future.delayed(Duration(milliseconds: 1000));
                  }

                  boardState.setLang(lang);
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
