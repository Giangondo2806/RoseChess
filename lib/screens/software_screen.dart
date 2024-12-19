import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/rose.dart';
import '../engine/rose_state.dart';
import '../providers/board_state.dart';
import '../widgets/analysis_widget.dart';
import '../widgets/chess_board.dart';
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
  Rose? _roseEngine;
  bool _engineReady = false;
  bool _gameStarted = false;
  bool _isSettingEngine = false;
  bool _readyOkReceived = false;

  final String _testFen =
      "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR w";


  void _handleMenuAction(String action) {
    print('Menu action received: $action');
    switch (action) {
      case 'new_game':
        _startGame();
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initEngine();
    });
  }

  @override
  void dispose() {
    _pauseGame();
    _roseEngine?.dispose();
    super.dispose();
  }

  void _pauseGame() {
    if (_gameStarted == false) return;
    _roseEngine?.stdin = 'stop\n';
    setState(() {
      _gameStarted = false;
    });
    print("Game paused.");
  }

  void _startGame() {
      if (_gameStarted == true) return;
      setState(() {
        _gameStarted = true;
      });
    print("Game started.");
  }


  Future<void> _initEngine() async {
    try {
      _roseEngine = await roseAsync();
      print('start engine');
      if (_roseEngine != null) {
        _roseEngine?.stdout.listen((line) {
          print('[Engine Out]: $line');
          if (line.trim() == 'readyok') {
            if (mounted) {
              setState(() {
                _readyOkReceived = true;
              });
            }
          }
        });
        if (_roseEngine!.state.value == RoseState.ready) {
          if (mounted) {
            setState(() {
              _engineReady = true;
            });
          }
          if (!_isSettingEngine) {
            _settingEngine();
          }
        } else {
          _roseEngine?.state.addListener(_engineStateListener);
        }
      }
    } catch (error) {
      print('Error init engine: $error');
    }
  }

  void _engineStateListener() {
    if (_roseEngine?.state.value == RoseState.ready) {
      print("Engine is ready");
      if (mounted) {
        setState(() {
          _engineReady = true;
        });
      }
      if (!_isSettingEngine && _engineReady) {
        _settingEngine();
      }
    } else if (_roseEngine?.state.value == RoseState.error) {
      print("Engine has error");
      if (mounted) {
        setState(() {
          _engineReady = false;
        });
      }
    } else {
      print('Engine state update to ${_roseEngine?.state.value}');
    }
  }

  Future<void> _settingEngine() async {
    if (_isSettingEngine) return;
    _isSettingEngine = true;
    print('setting engine');
    print('engine${widget.engineFileName}');

    _roseEngine?.stdin = 'uci\n';
    _roseEngine?.stdin = 'setoption name Threads value 2\n';
    _roseEngine?.stdin = 'setoption name Hash value 300\n';
    _roseEngine?.stdin =
        'setoption name Evalfile value ${widget.engineFileName} \n';
    _roseEngine?.stdin = 'isready\n';
    if(mounted){
      setState(() {
        _isSettingEngine = false;
      });
    }
  }

  void _move(String fen) {
    if (!_engineReady || !_gameStarted || !_readyOkReceived) return;
    print('sent $fen');
    _roseEngine?.stdin = 'position fen $fen\n';
    _roseEngine?.stdin = 'go\n';
    print('Sent Move $fen');
  }


  @override
  Widget build(BuildContext context) {
    // Kiểm tra state và gửi lệnh move ở đây
    if (_engineReady && _gameStarted && _readyOkReceived) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
          _move(_testFen);
       });
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => BoardState(),
          ),
          Provider.value(value: _move),
        ],
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: MenuBarWidget(onMenuAction: _handleMenuAction),
              ),
              Expanded(
                child: ChessBoardWidget(),
              ),
              AnalysisWidget(),
            ],
          ),
        ));
  }
}