import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../database/config.dart';

class IsarService {
  final Isar _isar; // Không cần late nữa

  IsarService._(this._isar); // Private constructor

  // Factory constructor để khởi tạo Isar
  static Future<IsarService> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [ConfigSchema],
      directory: dir.path,
      inspector: true,
    );
    return IsarService._(isar);
  }

  // Các phương thức không cần thay đổi
  Future<Config?> getConfig(int id) async {
      return await _isar.configs.get(id);
  }

  Future<void> saveConfig(Config config) async {
      await _isar.writeTxn(() async {
          await _isar.configs.put(config);
      });
  }
}