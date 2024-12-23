// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `en`
  String get currentLang {
    return Intl.message(
      'en',
      name: 'currentLang',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `User Settings`
  String get userSettingsTitle {
    return Intl.message(
      'User Settings',
      name: 'userSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get japanese {
    return Intl.message(
      'Japanese',
      name: 'japanese',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Board Color`
  String get boardColor {
    return Intl.message(
      'Board Color',
      name: 'boardColor',
      desc: '',
      args: [],
    );
  }

  /// `Piece Set`
  String get pieceSet {
    return Intl.message(
      'Piece Set',
      name: 'pieceSet',
      desc: '',
      args: [],
    );
  }

  /// `Application Settings`
  String get applicationSettingsTitle {
    return Intl.message(
      'Application Settings',
      name: 'applicationSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Engine`
  String get engine {
    return Intl.message(
      'Engine',
      name: 'engine',
      desc: '',
      args: [],
    );
  }

  /// `Hash Size`
  String get hashSize {
    return Intl.message(
      'Hash Size',
      name: 'hashSize',
      desc: '',
      args: [],
    );
  }

  /// `Book Settings`
  String get bookSettingsTitle {
    return Intl.message(
      'Book Settings',
      name: 'bookSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon...`
  String get comingSoon {
    return Intl.message(
      'Coming Soon...',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get book {
    return Intl.message(
      'Book',
      name: 'book',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation`
  String get evaluation {
    return Intl.message(
      'Evaluation',
      name: 'evaluation',
      desc: '',
      args: [],
    );
  }

  /// `Graph`
  String get graph {
    return Intl.message(
      'Graph',
      name: 'graph',
      desc: '',
      args: [],
    );
  }

  /// `Move`
  String get move {
    return Intl.message(
      'Move',
      name: 'move',
      desc: '',
      args: [],
    );
  }

  /// `score`
  String get score {
    return Intl.message(
      'score',
      name: 'score',
      desc: '',
      args: [],
    );
  }

  /// `Winrate`
  String get winrate {
    return Intl.message(
      'Winrate',
      name: 'winrate',
      desc: '',
      args: [],
    );
  }

  /// `P`
  String get P {
    return Intl.message(
      'P',
      name: 'P',
      desc: '',
      args: [],
    );
  }

  /// `C`
  String get C {
    return Intl.message(
      'C',
      name: 'C',
      desc: '',
      args: [],
    );
  }

  /// `R`
  String get R {
    return Intl.message(
      'R',
      name: 'R',
      desc: '',
      args: [],
    );
  }

  /// `N`
  String get N {
    return Intl.message(
      'N',
      name: 'N',
      desc: '',
      args: [],
    );
  }

  /// `B`
  String get B {
    return Intl.message(
      'B',
      name: 'B',
      desc: '',
      args: [],
    );
  }

  /// `A`
  String get A {
    return Intl.message(
      'A',
      name: 'A',
      desc: '',
      args: [],
    );
  }

  /// `K`
  String get K {
    return Intl.message(
      'K',
      name: 'K',
      desc: '',
      args: [],
    );
  }

  /// `+`
  String get forward {
    return Intl.message(
      '+',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `-`
  String get backward {
    return Intl.message(
      '-',
      name: 'backward',
      desc: '',
      args: [],
    );
  }

  /// `=`
  String get horizontally {
    return Intl.message(
      '=',
      name: 'horizontally',
      desc: '',
      args: [],
    );
  }

  /// `+`
  String get front {
    return Intl.message(
      '+',
      name: 'front',
      desc: '',
      args: [],
    );
  }

  /// `-`
  String get rear {
    return Intl.message(
      '-',
      name: 'rear',
      desc: '',
      args: [],
    );
  }

  /// `=`
  String get middle {
    return Intl.message(
      '=',
      name: 'middle',
      desc: '',
      args: [],
    );
  }

  /// `Depth`
  String get depth {
    return Intl.message(
      'Depth',
      name: 'depth',
      desc: '',
      args: [],
    );
  }

  /// `nps`
  String get nps {
    return Intl.message(
      'nps',
      name: 'nps',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
