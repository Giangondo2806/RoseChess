import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  // Màu sắc cơ bản
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFCD853F), // Peru - Nâu đất
  scaffoldBackgroundColor: const Color(0xFF483C32), // Taupe - Nâu xám
  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 97, 74, 52), // Peru - Nâu đất
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0, // Loại bỏ đổ bóng
  ),
  // Bottom AppBar
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFFCD853F), // Peru - Nâu đất
    elevation: 0, // Loại bỏ đổ bóng
  ),
  // Nút (Buttons)
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFFCD853F), // Peru - Nâu đất
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFCD853F), // Peru - Nâu đất
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFCD853F), // Peru - Nâu đất
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFCD853F), // Peru - Nâu đất
      side: const BorderSide(color: Color(0xFFCD853F)), // Peru - Nâu đất
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  // Card
  cardTheme: CardTheme(
    color: const Color(0xFF5D4E42), // Màu nâu xám đậm hơn nền một chút
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  // Chip
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[800],
    disabledColor: Colors.grey[700],
    selectedColor: const Color(0xFFCD853F), // Peru - Nâu đất
    secondarySelectedColor: const Color(0xFFCD853F), // Peru - Nâu đất
    labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    padding: const EdgeInsets.all(4.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    labelStyle: const TextStyle(color: Colors.white),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.dark,
    elevation: 2,
  ),
  // Dialog
  dialogTheme: DialogTheme(
    backgroundColor:
        const Color(0xFF5D4E42), // Màu nâu xám đậm hơn nền một chút
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
  // Divider
  dividerTheme: const DividerThemeData(
    color: Colors.white30,
    thickness: 1.0,
  ),
  // Floating Action Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFCD853F), // Peru - Nâu đất
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  // Icon
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  // Input Decoration (Text Fields, etc.)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFCD853F)), // Peru - Nâu đất
      borderRadius: BorderRadius.circular(8.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFCD853F)), // Peru - Nâu đất
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
          color: Color(0xFFCD853F), width: 2.0), // Peru - Nâu đất
      borderRadius: BorderRadius.circular(8.0),
    ),
    labelStyle: const TextStyle(color: Colors.white),
    hintStyle: TextStyle(color: Colors.grey[400]),
    fillColor: const Color(0xFF5D4E42), // Màu nâu xám đậm hơn nền một chút
    filled: true,
  ),
  // List Tile
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  // Progress Indicator
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFCD853F), // Peru - Nâu đất
    circularTrackColor: Color(0xFF5D4E42),
  ),
  // Slider
  sliderTheme: const SliderThemeData(
    activeTrackColor: Color(0xFFCD853F), // Peru - Nâu đất
    inactiveTrackColor: Color(0xFF5D4E42),
    thumbColor: Color(0xFFCD853F), // Peru - Nâu đất
    overlayColor: Color(0xFFCD853F), // Peru - Nâu đất
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFCD853F); // Peru - Nâu đất
      }
      return Colors.grey[700];
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFCD853F).withOpacity(0.5); // Peru - Nâu đất
      }
      return Colors.grey[500];
    }),
  ),
  // Tab Bar
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide:
          BorderSide(color: Color(0xFFCD853F), width: 2.0), // Peru - Nâu đất
    ),
  ),
  // Text Theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(
        fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.white),
    displaySmall: TextStyle(
        fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(
        fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.white),
    headlineSmall: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
    labelLarge: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.white),
    labelSmall: TextStyle(fontSize: 10.0, color: Colors.grey),
  ),
  // Color Scheme
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.dark,
    primary: const Color(0xFFCD853F), // Peru - Nâu đất
    secondary: const Color(0xFFF4A460), // Sandy Brown - Nâu cát
    error: const Color(0xFFDC143C), // Crimson - Đỏ thẫm
    background: const Color(0xFF483C32), // Taupe - Nâu xám
    surface: const Color(0xFF5D4E42), // Màu nâu xám đậm hơn nền một chút
    onPrimary: Colors.white, // Màu chữ trên primary color
    onSecondary: Colors.black, // Màu chữ trên secondary color
    onError: Colors.white, // Màu chữ trên error color
    onBackground: Colors.white, // Màu chữ trên background color
    onSurface: Colors.white, // Màu chữ trên surface color
  ),
);
