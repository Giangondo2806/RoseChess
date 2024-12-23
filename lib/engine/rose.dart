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

  Rose({this.completer}) {
    debugPrint('[Rose] Constructor called'); 
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
    stdin = 'quit\n';
  }

  void _cleanUp(int exitCode) {
    _stdoutController.close();
    _mainSubscription.cancel();
    _stdoutSubscription.cancel();

    _state._setValue(exitCode == 0 ? RoseState.disposed : RoseState.error);
  }
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
      if (line.trim() == 'readyok') {
        stdoutPort.send(line);
      } else if (line.startsWith('bestmove')) {
        stdoutPort.send(line);
      } else if (line.startsWith('info depth') && !line.contains('currmovenumber')) {
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