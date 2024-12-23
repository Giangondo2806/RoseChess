import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rose_chess/database/database.dart';
import 'package:rose_chess/services/service_locator.dart';
import '../database/repositories/config_repository.dart';
import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';

class UserSettingsProvider with ChangeNotifier {
  late Locale _currentLocale = Locale(Intl.systemLocale.substring(0, 2));
  late ThemeData _currentTheme = darkTheme;
  bool _isLoading = true;

  Locale get currentLocale => _currentLocale;
  ThemeData get currentTheme => _currentTheme;
  bool get isLoading => _isLoading;

  UserSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    var langSystem = Intl.systemLocale.substring(0, 2);
    final configRepo = getIt<ConfigRepository>();
    ConfigData? config = await configRepo.getLastConfig();

    if (config != null) {
      _currentLocale = Locale(config.lang);
      _currentTheme = config.theme == 'dark' ? darkTheme : lightTheme;
    } else {
      if (!['en', 'vi', 'ja'].contains(langSystem)) {
        langSystem = 'en';
      }
      _currentTheme = darkTheme;
      _currentLocale = Locale(langSystem);
      final defaultConfig = ConfigCompanion(
        lang: Value(langSystem),
        theme: const Value('dark'),
      );
      await configRepo.saveConfig(defaultConfig);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeLanguage(String newLang) async {
    final configRepo = getIt<ConfigRepository>();
    ConfigData? config = await configRepo.getLastConfig(); // Lấy ConfigData có id lớn nhất
    if (config != null) {
      final updatedConfig = config.copyWith(lang: newLang);
      await configRepo.saveConfig(updatedConfig);
      _currentLocale = Locale(newLang);
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final configRepo = getIt<ConfigRepository>();
    ConfigData? config = await configRepo.getLastConfig(); // Lấy ConfigData có id lớn nhất
    if (config != null) {
      final newTheme = _currentTheme == darkTheme ? 'light' : 'dark';
      final updatedConfig = config.copyWith(theme: newTheme);
      _currentTheme = _currentTheme == darkTheme ? lightTheme : darkTheme;
      await configRepo.saveConfig(updatedConfig);
      notifyListeners();
    }
  }
}