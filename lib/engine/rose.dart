import 'dart:async';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';
import '../services/service_locator.dart';
import 'ffi.dart';
import 'rose_state.dart';

class Rose {
  final Completer<Rose>? completer;
  final _state = _RoseState();
  final _stdoutController = StreamController<String>.broadcast();
  final _mainPort = ReceivePort();
  final _stdoutPort = ReceivePort();
  final _disposeLock = Lock();

  late StreamSubscription _mainSubscription;
  late StreamSubscription _stdoutSubscription;

  bool _isDisposing = false;
  bool _shouldDispose = false;
  Completer<void>? _restartCompleter;

  static Rose? _instance;

  Rose._({this.completer}) {
    _registerInstance();
    _initializeSubscriptions();
    _initIsolates();
  }

  factory Rose() {
    if (_instance != null) {
      throw StateError('Multiple instances are not supported.');
    }
    _instance = Rose._();
    return _instance!;
  }

  ValueListenable<RoseState> get state => _state;
  Stream<String> get stdout => _stdoutController.stream;

  set stdin(String line) {
    if (_state.value != RoseState.ready) {
      throw StateError('Rose is not ready (${_state.value})');
    }
    final pointer = '$line\n'.toNativeUtf8();
    nativeStdinWrite(pointer);
    calloc.free(pointer);
  }

  void _initializeSubscriptions() {
    _mainSubscription =
        _mainPort.listen((message) => _cleanUp(message is int ? message : 1));

    _stdoutSubscription = _stdoutPort.listen((message) {
      if (message is String) {
        _stdoutController.sink.add(message);
      } else if (message == RoseState.error) {
        debugPrint('[rose] Received error signal from stdout isolate');
        _restart();
      } else {
        debugPrint('[rose] The stdout isolate sent $message');
      }
    });
  }

  Future<void> _initIsolates() async {
    try {
      final success = await compute(
          _spawnIsolates, [_mainPort.sendPort, _stdoutPort.sendPort]);

      final state = success ? RoseState.ready : RoseState.error;
      _state._setValue(state);

      if (state == RoseState.ready) {
        completer?.complete(this);
      }
    } catch (error) {
      debugPrint('[rose] Init isolate error: $error');
      _cleanUp(1);
    }
  }

  Future<void> _restart() async {
    await _disposeLock.synchronized(() async {
      if (_restartCompleter != null) {
        return await _restartCompleter!.future;
      }

      _restartCompleter = Completer<void>();
      try {
        await _cleanUpResources();
        _state._setValue(RoseState.starting);
        _initializeSubscriptions();
        await _initIsolates();
        debugPrint('[rose] Engine restarted successfully');
      } finally {
        _restartCompleter!.complete();
        _restartCompleter = null;
      }
    });
  }

  Future<void> dispose() async {
    await _disposeLock.synchronized(() async {
      if (_isDisposing) return;
      _isDisposing = true;
      _shouldDispose = true;

      try {
        await _cleanUpResources();
      } finally {
        _isDisposing = false;
      }
    });
  }

  Future<void> _cleanUpResources() async {
    try {
      stdin = 'quit\n';
    } catch (e) {
      debugPrint('[rose] Error sending quit command: $e');
    }
    // _mainIsolate?.kill(priority: Isolate.immediate);
    // _stdoutIsolate?.kill(priority: Isolate.immediate);
    // _mainIsolate = null;
    // _stdoutIsolate = null;

    await _mainSubscription.cancel();
    await _stdoutSubscription.cancel();
    await _stdoutController.close();
    _mainPort.close();
    _stdoutPort.close();
  }

  void _cleanUp(int exitCode) {
    final state = exitCode == 0 ? RoseState.disposed : RoseState.error;
    _state._setValue(state);

    if (_shouldDispose) {
      _unregisterInstance();
      _instance = null;
    }
  }

  Future<void> forceClean() async {
    await _disposeLock.synchronized(() async {
      _shouldDispose = true;
      await _cleanUpResources();
      _unregisterInstance();
      _instance = null;
      _shouldDispose = false;
      _state._setValue(RoseState.disposed);
    });
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

  void _setValue(RoseState v) {
    if (v == _value) return;
    _value = v;
    notifyListeners();
  }
}

Future<bool> _spawnIsolates(List<SendPort> ports) async {
  final initResult = nativeInit();
  if (initResult != 0) {
    debugPrint('[rose] initResult=$initResult');
    return false;
  }

  try {
   await Isolate.spawn(_isolateStdout, ports[1]);
    await Isolate.spawn(_isolateMain, ports[0]);
    return true;
  } catch (error) {
    debugPrint('[rose] Spawn isolate error: $error');
    return false;
  }
}

void _isolateMain(SendPort mainPort) {
  final exitCode = nativeMain();
  mainPort.send(exitCode);
  debugPrint('[rose] nativeMain returns $exitCode');
}

void _isolateStdout(SendPort stdoutPort) {
  String buffer = '';

  while (true) {
    final pointer = nativeStdoutRead();
    if (pointer.address == 0) {
      debugPrint('[rose] nativeStdoutRead returns NULL');
      stdoutPort.send(RoseState.error);
      return;
    }

    final data = buffer + pointer.toDartString();
    final lines = data.split('\n');
    buffer = lines.removeLast();

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed == 'readyok' || line.startsWith('bestmove')) {
        stdoutPort.send(line);
      } else if (line.startsWith('info depth')) {
        _processInfoDepth(line, stdoutPort);
      }
    }
  }
}

void _processInfoDepth(String line, SendPort stdoutPort) {
  if (line.contains('currmovenumber')) return;

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
