import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  // Màu sắc cơ bản
  brightness: Brightness.light,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0, // Loại bỏ đổ bóng
  ),
  // Bottom AppBar
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
    elevation: 0, // Loại bỏ đổ bóng
  ),
  // Nút (Buttons)
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.black,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  // Card
  cardTheme: CardTheme(
    color: Colors.grey[100],
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  // Chip
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[200],
    disabledColor: Colors.grey[300],
    selectedColor: Colors.black,
    secondarySelectedColor: Colors.black,
    labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    padding: const EdgeInsets.all(4.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
    elevation: 0,
  ),
  // Dialog
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(color: Colors.black),
  ),
  // Divider
  dividerTheme: const DividerThemeData(
    color: Colors.black26,
    thickness: 1.0,
  ),
  // Floating Action Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  // Icon
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  // Input Decoration (Text Fields, etc.)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(8.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    labelStyle: const TextStyle(color: Colors.black),
    hintStyle: TextStyle(color: Colors.grey[700]),
    fillColor: Colors.grey[100],
    filled: true,
  ),
  // List Tile
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black,
    textColor: Colors.black,
  ),
  // Progress Indicator
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.black,
    circularTrackColor: Colors.grey,
  ),
  // Slider
  sliderTheme: const SliderThemeData(
    activeTrackColor: Colors.black,
    inactiveTrackColor: Colors.grey,
    thumbColor: Colors.black,
    overlayColor: Colors.black38,
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.black;
      }
      return Colors.grey;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.black38;
      }
      return Colors.grey[400];
    }),
  ),
  // Tab Bar
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
  ),
  // Text Theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.black),
    displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
    titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.black),
    labelSmall: TextStyle(fontSize: 10.0, color: Colors.grey),
  ),
  // Color Scheme
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.light,
    secondary: Colors.grey[400],
    error: Colors.red,
    background: Colors.white,
    surface: Colors.grey[100],
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onError: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
);