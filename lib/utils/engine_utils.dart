import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EngineUtils {
  static Future<File> getEngineFile(String engineFileName) async {
    // Sử dụng getApplicationDocumentsDirectory() thay vì getExternalStorageDirectory()
    final directory = await getApplicationDocumentsDirectory(); 
    return File('${directory.path}/$engineFileName');
  }
}