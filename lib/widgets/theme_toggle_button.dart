import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings_provider.dart';
import '../themes/light_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context);
    return IconButton(
      icon: Icon(userSettingsProvider.currentTheme == lightTheme
          ? Icons.dark_mode
          : Icons.light_mode),
      onPressed: () {
        userSettingsProvider.toggleTheme();
      },
    );
  }
}