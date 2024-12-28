import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../utils/engine_utils.dart';
import 'software_screen.dart';


class EngineLoaderScreen extends StatefulWidget {
  const EngineLoaderScreen({Key? key}) : super(key: key);

  @override
  _EngineLoaderScreenState createState() => _EngineLoaderScreenState();
}

class _EngineLoaderScreenState extends State<EngineLoaderScreen> {
  // Thêm .nnue vào tên file
  final String engineFileName = 'pikafish.nnue';
  // Sửa URL download, thêm .nnue vào cuối
  final String engineDownloadUrl =
      'https://github.com/official-pikafish/Networks/releases/download/master-net/pikafish.nnue';

  bool _engineExists = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _message = 'Đang kiểm tra engine...';
  late String engineFilePath; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEngine();
    });
  }

  Future<void> _checkEngine() async {
    final engineFile = await EngineUtils.getEngineFile(engineFileName);

    if (await engineFile.exists()) {
      engineFilePath = engineFile.path;
      setState(() {
        _engineExists = true;
        _message = 'Engine đã sẵn sàng!';
      });
      _navigateToSoftwareScreen();
    } else {
      setState(() {
        _message = 'Engine chưa có. Bắt đầu tải...';
      });
      await _downloadEngine();
    }
  }


  Future<void> _downloadEngine() async {
    setState(() {
      _isDownloading = true;
    });

    final engineFile = await EngineUtils.getEngineFile(engineFileName);
    engineFilePath = engineFile.path;
    final dio = Dio();

    try {
      await dio.download(
        engineDownloadUrl,
        engineFilePath,
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


      setState(() {
        _engineExists = true;
        _message = 'Tải engine thành công!';
      });
      _navigateToSoftwareScreen();
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

  void _navigateToSoftwareScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SoftwareScreen(engineFileName: engineFilePath),
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