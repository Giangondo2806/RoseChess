import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'providers/isar_service.dart';
import 'providers/user_settings_provider.dart';
import 'screens/engine_loader_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarService = await IsarService.create();
  runApp(
    MultiProvider(
      providers: [
        Provider<IsarService>(
          create: (_) => isarService, // Cung cấp IsarService
        ),
        ChangeNotifierProvider<UserSettingsProvider>(
          create: (context) => UserSettingsProvider(
            Provider.of<IsarService>(context,
                listen: false), // Truyền IsarService vào UserSettingsProvider
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context);
   
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ja', ''),
        Locale('vi', ''),
      ],
      locale: userSettingsProvider.currentLocale,
      theme: userSettingsProvider.currentTheme,
      home: const EngineLoaderScreen(), // Dẫn đến EngineLoaderScreen
    );
  }


}
