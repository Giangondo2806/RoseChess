import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Xóa import shared_preferences
import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';

class UserSettingsProvider with ChangeNotifier {
  // Ngôn ngữ
  Locale _currentLocale = Locale('en'); // Ngôn ngữ mặc định
  Locale get currentLocale => _currentLocale;

  // Theme
  ThemeData _currentTheme = lightTheme; // Theme mặc định
  ThemeData get currentTheme => _currentTheme;

  // Các cài đặt khác của người dùng có thể thêm vào đây
  // ...

  // Bỏ hàm _loadSettings() vì không dùng SharedPreferences nữa

  // Thay đổi ngôn ngữ
  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    // final prefs = await SharedPreferences.getInstance(); // Xóa dòng này
    // await prefs.setString('languageCode', languageCode); // Xóa dòng này
    notifyListeners();
  }

  // Thay đổi theme
  void toggleTheme() {
    _currentTheme = _currentTheme == lightTheme ? darkTheme : lightTheme;
    // final prefs = await SharedPreferences.getInstance(); // Xóa dòng này
    // await prefs.setBool('isDarkMode', _currentTheme == darkTheme); // Xóa dòng này
    notifyListeners();
  }

  // Các hàm thay đổi cài đặt khác
  // ...
}