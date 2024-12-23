import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rose_chess/themes/dark_theme.dart';
import 'package:rose_chess/themes/light_theme.dart';
import '../database/config.dart';
import 'isar_service.dart'; // Import IsarService

class UserSettingsProvider extends ChangeNotifier {
  final IsarService _isarService;
  late Locale _currentLocale = Locale('en');
  ThemeData _currentTheme = darkTheme;

  Locale get currentLocale => _currentLocale;
  ThemeData get currentTheme => _currentTheme;

  UserSettingsProvider(this._isarService) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    var langSystem = Intl.systemLocale.substring(0, 2);
    final config = await _isarService.getConfig(1); // Lấy config từ IsarService
    print(config?.lang);
    if (config != null) {
      _currentLocale = Locale(config.lang);
      _currentTheme =
          config.theme == 'dark' ? darkTheme : lightTheme;
    } else {
      if (!['en', 'vi', 'ja'].contains(langSystem)) {
        langSystem = 'en';
      }
      _currentTheme = darkTheme;
      final defaultConfig = Config();
      // _currentLocale = locale;
      defaultConfig.lang = langSystem;
      _currentLocale = Locale(langSystem);
      await _isarService.saveConfig(defaultConfig);
    }
    notifyListeners();
  }

  Future<void> changeLanguage(String newLang) async {
    final config = await _isarService.getConfig(1);
    if (config != null) {
      config.lang = newLang;
      await _isarService.saveConfig(config); // Lưu config thông qua IsarService
      _currentLocale = Locale(newLang);
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final config = await _isarService.getConfig(1);
    print(config);
    if (config != null) {
      config.theme = _currentTheme == darkTheme ? 'light' : 'dark';
      _currentTheme = currentTheme == darkTheme ? lightTheme : darkTheme;
      await _isarService.saveConfig(config);
      notifyListeners();
    }
  }
}
