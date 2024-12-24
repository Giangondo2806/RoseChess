import 'dart:async';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:rose_chess/services/service_locator.dart';

import 'ffi.dart';
import 'rose_state.dart';

/// A wrapper for C++ engine.
class Rose {
  final Completer<Rose>? completer;

  final _state = _RoseState();
  final _stdoutController = StreamController<String>.broadcast();
  final _mainPort = ReceivePort();
  final _stdoutPort = ReceivePort();

  late StreamSubscription _mainSubscription;
  late StreamSubscription _stdoutSubscription;

  bool _shouldDispose = false; // Flag to control disposal
  Completer<void>? _restartCompleter; // Completer for restarting

  Rose._({this.completer}) {
    _registerInstance();
    _mainSubscription =
        _mainPort.listen((message) => _cleanUp(message is int ? message : 1));
    _stdoutSubscription = _stdoutPort.listen((message) {
      if (message is String) {
        _stdoutController.sink.add(message);
      } else if (message == RoseState.error) {
        debugPrint('[rose] Received error signal from stdout isolate');
        _restart(); // Restart the engine
      } else {
        debugPrint('[rose] The stdout isolate sent $message');
      }
    });

    _initIsolates();
  }

  static Rose? _instance;

  /// Creates a C++ engine.
  ///
  /// This may throws a [StateError] if an active instance is being used.
  /// Owner must [dispose] it before a new instance can be created.
  factory Rose() {
    if (_instance != null) {
      throw StateError('Multiple instances are not supported, yet.');
    }

    _instance = Rose._();
    return _instance!;
  }

  /// The current state of the underlying C++ engine.
  ValueListenable<RoseState> get state => _state;

  /// The standard output stream.
  Stream<String> get stdout => _stdoutController.stream;

  /// The standard input sink.
  set stdin(String line) {
    final stateValue = _state.value;
    if (stateValue != RoseState.ready) {
      throw StateError('Rose is not ready ($stateValue)');
    }

    final pointer = '$line\n'.toNativeUtf8();
    nativeStdinWrite(pointer);
    calloc.free(pointer);
  }

  /// Stops the C++ engine.
  void dispose() {
    _shouldDispose = true; // Indicate that dispose was called intentionally
    stdin = 'quit\n';
  }

  Future<void> _initIsolates() async {
    await compute(_spawnIsolates, [_mainPort.sendPort, _stdoutPort.sendPort])
        .then(
      (success) {
        final state = success ? RoseState.ready : RoseState.error;
        _state._setValue(state);
        if (state == RoseState.ready) {
          completer?.complete(this);
        }
      },
      onError: (error) {
        debugPrint('[rose] The init isolate encountered an error $error');
        _cleanUp(1);
      },
    );
  }

  Future<void> _restart() async {
    if (_restartCompleter != null && !_restartCompleter!.isCompleted) {
      return; // Already restarting
    }
    _restartCompleter = Completer<void>();

    debugPrint('[rose] Restarting engine...');
    _cleanUp(1, restarting: true); // Clean up without setting _instance to null
    _state._setValue(RoseState.starting);

    // Reinitialize the isolates
    _mainSubscription =
        _mainPort.listen((message) => _cleanUp(message is int ? message : 1));
    _stdoutSubscription = _stdoutPort.listen((message) {
      if (message is String) {
        _stdoutController.sink.add(message);
      } else if (message == RoseState.error) {
        debugPrint('[rose] Received error signal from stdout isolate');
        _restart(); // Restart the engine if still error
      } else {
        debugPrint('[rose] The stdout isolate sent $message');
      }
    });

    await _initIsolates();
    debugPrint('[rose] Engine restarted.');
    _restartCompleter!.complete();
    _restartCompleter = null;
  }

  void _cleanUp(int exitCode, {bool restarting = false}) {
    _stdoutController.close();
    _mainSubscription.cancel();
    _stdoutSubscription.cancel();
    _state._setValue(exitCode == 0 ? RoseState.disposed : RoseState.error);
    if (!restarting && _shouldDispose) {
      _unregisterInstance();
      _instance = null; // Only set to null if not restarting and should dispose
    }
  }

  void _registerInstance() {
    if (getIt.isRegistered<Rose>()) {
      getIt.unregister<Rose>();
    }
    getIt.registerSingleton<Rose>(this);
  }

  void _unregisterInstance() {
    if (getIt.isRegistered<Rose>()) {
      getIt.unregister<Rose>();
    }
  }

  forceClean() async {
    _shouldDispose = true;

    stdin = 'quit\n';
    _stdoutController.close();
    _mainSubscription.cancel();
    _stdoutSubscription.cancel();
    _mainPort.close();
    _stdoutPort.close();
    _unregisterInstance();
    _instance = null;
    _shouldDispose = false;
    _restartCompleter = null;
    _state._setValue(RoseState.disposed);
  }
}

Future<Rose> roseAsync() {
  if (Rose._instance != null) {
    return Future.error(StateError('Only one instance can be used at a time'));
  }

  final completer = Completer<Rose>();
  Rose._instance = Rose._(completer: completer);
  return completer.future;
}

class _RoseState extends ChangeNotifier implements ValueListenable<RoseState> {
  RoseState _value = RoseState.starting;

  @override
  RoseState get value => _value;

  _setValue(RoseState v) {
    if (v == _value) return;
    _value = v;
    notifyListeners();
  }
}

void _isolateMain(SendPort mainPort) {
  final exitCode = nativeMain();
  mainPort.send(exitCode);

  debugPrint('[rose] nativeMain returns $exitCode');
}

void _isolateStdout(SendPort stdoutPort) {
  String previous = '';

  while (true) {
    final pointer = nativeStdoutRead();

    if (pointer.address == 0) {
      debugPrint('[rose] nativeStdoutRead returns NULL');
      // Send a message to the main isolate to indicate an error and request restart
      stdoutPort.send(RoseState.error); // Use RoseState.error as a signal
      return;
    }

    final data = previous + pointer.toDartString();
    final lines = data.split('\n');
    previous = lines.removeLast();
    for (final line in lines) {
      if (line.trim() == 'readyok') {
        stdoutPort.send(line);
      } else if (line.startsWith('bestmove')) {
        stdoutPort.send(line);
      } else if (line.startsWith('info depth') &&
          !line.contains('currmovenumber')) {
        try {
          final depthStr = line.split('depth ')[1].split(' ')[0];
          final depth = int.parse(depthStr);
          if (depth > 12) {
            stdoutPort.send(line);
          }
        } catch (e) {
          debugPrint('[rose] Error parsing info depth line: $line');
        }
      }
    }
  }
}

Future<bool> _spawnIsolates(List<SendPort> mainAndStdout) async {
  final initResult = nativeInit();
  if (initResult != 0) {
    debugPrint('[rose] initResult=$initResult');
    return false;
  }

  try {
    await Isolate.spawn(_isolateStdout, mainAndStdout[1]);
  } catch (error) {
    debugPrint('[rose] Failed to spawn stdout isolate: $error');
    return false;
  }

  try {
    await Isolate.spawn(_isolateMain, mainAndStdout[0]);
  } catch (error) {
    debugPrint('[rose] Failed to spawn main isolate: $error');
    return false;
  }

  return true;
}
