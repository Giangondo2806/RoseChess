import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_state.dart';
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
    with TickerProviderStateMixin {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BoardState(widget.engineFileName),
        ),
      ],
      child: Consumer<BoardState>(
        builder: (context, boardState, child) {
          if (!_initialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              boardState.initEngine();
            });
            _initialized = true;
          }

          return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  MenuBarWidget(
                    onMenuAction: boardState.handleMenuAction,
                  ),
                  ChessBoardWidget(boardState: boardState),
            
                  Expanded(child: AnalysisWidget()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}