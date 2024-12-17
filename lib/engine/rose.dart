import 'dart:async';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

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

  Rose._({this.completer}) {
    _mainSubscription =
        _mainPort.listen((message) => _cleanUp(message is int ? message : 1));
    _stdoutSubscription = _stdoutPort.listen((message) {
      if (message is String) {
        _stdoutController.sink.add(message);
      } else {
        debugPrint('[rose] The stdout isolate sent $message');
      }
    });

    
    compute(_spawnIsolates, [_mainPort.sendPort, _stdoutPort.sendPort]).then(
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
    stdin = 'quit';
  }

  void _cleanUp(int exitCode) {
    _stdoutController.close();

    _mainSubscription.cancel();
    _stdoutSubscription.cancel();

    _state._setValue(exitCode == 0 ? RoseState.disposed : RoseState.error);

    _instance = null;
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
      return;
    }

    final data = previous + pointer.toDartString();
    final lines = data.split('\n');
    previous = lines.removeLast();
    for (final line in lines) {
      stdoutPort.send(line);
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
