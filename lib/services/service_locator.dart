import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:rose_chess/database/repositories/move_repository.dart';

import '../database/database.dart';
import '../database/repositories/config_repository.dart';
import '../engine/rose.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<RoseDatabase>(() => RoseDatabase());
  if (!getIt.isRegistered<Rose>()) {
    getIt.registerLazySingleton<Rose>(() => Rose());
  }
  getIt.registerLazySingleton<ConfigRepository>(
      () => ConfigRepository(getIt())); 
  getIt.registerLazySingleton<ChessRepository>(
      () => ChessRepository(getIt()));
}

Future<void> resetLocator() async {
  await getIt.reset();
  setupLocator();
}
