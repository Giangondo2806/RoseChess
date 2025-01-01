import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final _nativeLib = Platform.isAndroid
    ? DynamicLibrary.open('librose.so')
    : DynamicLibrary.process();

final int Function() nativeInit = _nativeLib
    .lookup<NativeFunction<Int32 Function()>>('rose_init')
    .asFunction();

final int Function() nativeMain = _nativeLib
    .lookup<NativeFunction<Int32 Function()>>('rose_main')
    .asFunction();

final int Function(Pointer<Utf8>) nativeStdinWrite = _nativeLib
    .lookup<NativeFunction<IntPtr Function(Pointer<Utf8>)>>(
        'rose_stdin_write')
    .asFunction();

final Pointer<Utf8> Function() nativeStdoutRead = _nativeLib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>('rose_stdout_read')
    .asFunction();