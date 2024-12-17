import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/engine_utils.dart';
import 'game_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';

class EngineLoaderScreen extends StatefulWidget {
  const EngineLoaderScreen({Key? key}) : super(key: key);

  @override
  _EngineLoaderScreenState createState() => _EngineLoaderScreenState();
}

class _EngineLoaderScreenState extends State<EngineLoaderScreen> {
  // Thêm .nnue vào tên file
  final String engineFileName = 'stockfish.nnue';
  // Sửa URL download, thêm .nnue vào cuối
  final String engineDownloadUrl =
      'https://github.com/official-pikafish/Networks/releases/download/master-net/pikafish.nnue';

  bool _engineExists = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _message = 'Đang kiểm tra engine...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEngine();
    });
  }

  Future<void> _checkEngine() async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      return;
    }

    final engineFile = await EngineUtils.getEngineFile(engineFileName);

    if (await engineFile.exists()) {
      setState(() {
        _engineExists = true;
        _message = 'Engine đã sẵn sàng!';
      });
      _navigateToGameScreen();
    } else {
      setState(() {
        _message = 'Engine chưa có. Bắt đầu tải...';
      });
      await _downloadEngine();
    }
  }

  Future<bool> _requestStoragePermission() async {
    // Chỉ xử lý logic cho Android
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var androidInfo = await deviceInfo.androidInfo;
      var sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        var manageStorageStatus = await Permission.manageExternalStorage.status;
        if (manageStorageStatus.isGranted) {
          return true;
        } else {
          var status = await Permission.manageExternalStorage.request();
          if (status.isGranted) {
            return true;
          } else {
            if (status.isPermanentlyDenied) {
              openAppSettings();
            } else {
              setState(() {
                _message = 'Ứng dụng cần quyền quản lý bộ nhớ để lưu engine.';
              });
            }
            return false;
          }
        }
      } else {
        var storageStatus = await Permission.storage.status;
        var manageStorageStatus = await Permission.manageExternalStorage.status;

        if (storageStatus.isGranted && manageStorageStatus.isGranted) {
          return true;
        } else {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
            Permission.manageExternalStorage,
          ].request();

          if (statuses[Permission.storage]!.isGranted &&
              statuses[Permission.manageExternalStorage]!.isGranted) {
            return true;
          } else {
            if (statuses[Permission.storage]!.isPermanentlyDenied ||
                statuses[Permission.manageExternalStorage]!.isPermanentlyDenied) {
              openAppSettings();
            } else {
              setState(() {
                _message =
                    'Ứng dụng cần quyền truy cập bộ nhớ để lưu engine.';
              });
            }
            return false;
          }
        }
      }
    } else {
      // Đối với iOS, không cần xin quyền đặc biệt, trả về true luôn
      return true;
    }
  }

  Future<void> _downloadEngine() async {
    setState(() {
      _isDownloading = true;
    });

    final engineFile = await EngineUtils.getEngineFile(engineFileName);
    final dio = Dio();

    try {
      await dio.download(
        engineDownloadUrl,
        engineFile.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
              _message =
                  'Đang tải engine: ${(_downloadProgress * 100).toStringAsFixed(0)}%';
            });
          }
        },
      );

      // Không cần thiết phải cấp quyền execute trên iOS
      // if (Platform.isAndroid || Platform.isLinux) {
      //   await Process.run('chmod', ['+x', engineFile.path]);
      // }

      setState(() {
        _engineExists = true;
        _message = 'Tải engine thành công!';
      });
      _navigateToGameScreen();
    } catch (e) {
      setState(() {
        _message = 'Lỗi khi tải engine: $e';
      });
      print('Download error: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  void _navigateToGameScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameScreen(engineFileName: engineFileName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            if (_isDownloading)
              Padding(
                // Thêm Padding bao quanh LinearProgressIndicator
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                // Padding 2 đầu
                child: SizedBox(
                  // Dùng SizedBox để custom chiều cao
                  height: 16, // Chiều cao của progress bar
                  child: ClipRRect(
                    // Dùng ClipRRect để bo tròn góc
                    borderRadius: BorderRadius.circular(8),
                    // Bo tròn góc với radius 8 (một nửa chiều cao)
                    child: LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: Colors.grey[300], // Màu nền của progress bar
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor), // Màu của thanh tiến trình
                    ),
                  ),
                ),
              ),
            if (!_isDownloading && !_engineExists)
              ElevatedButton(
                onPressed: () {
                  _checkEngine();
                },
                child: const Text('Xin quyền và kiểm tra lại'),
              ),
          ],
        ),
      ),
    );
  }
}