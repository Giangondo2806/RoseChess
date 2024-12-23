import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../providers/user_settings_provider.dart';
import '../themes/dark_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(lang.settingsTitle),
      ),
      body: ListView(
        children: [
          // User Settings
          ListTile(
            title: Text(lang.userSettingsTitle,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Language Setting with Dropdown
          Consumer<UserSettingsProvider>(
            builder: (context, userSettingsProvider, child) {
              return ListTile(
                title: Text(lang.language),
                trailing: DropdownButton<String>(
                  value: userSettingsProvider.currentLocale.languageCode,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      userSettingsProvider.changeLanguage(newValue);
                    }
                  },
                  items: <String>['en', 'ja', 'vi']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'en'
                            ? lang.english
                            : value == 'ja'
                                ? lang.japanese
                                : lang.vietnamese,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          // Theme Setting
          Consumer<UserSettingsProvider>(
            builder: (context, userSettingsProvider, child) {
              return ListTile(
                title: Text(lang.theme),
                trailing: Switch(
                  value: userSettingsProvider.currentTheme == darkTheme,
                  onChanged: (bool value) {
                    userSettingsProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
          // Other settings (Board Color, Piece Set, etc.)
          ListTile(
            title: Text(lang.boardColor),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to board color selection screen (not implemented yet)
            },
          ),
          ListTile(
            title: Text(lang.pieceSet),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to piece set selection screen (not implemented yet)
            },
          ),

          // Application Settings
          ListTile(
            title: Text(lang.applicationSettingsTitle,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text(lang.engine),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to engine selection screen (not implemented yet)
            },
          ),
          ListTile(
            title: Text(lang.hashSize),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to hash size selection screen (not implemented yet)
            },
          ),

          // Book Settings
          ListTile(
            title: Text(lang.bookSettingsTitle,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text(lang.comingSoon),
          ),
        ],
      ),
    );
  }
}
