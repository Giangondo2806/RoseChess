import 'dart:async';

import 'package:get_it/get_it.dart';

import '../database/database.dart';
import '../database/repositories/config_repository.dart';
import '../engine/rose.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<RoseDatabase>(() => RoseDatabase());
  // getIt.registerLazySingletonAsync<Rose>(() async {
  //   final completer = Completer<Rose>();
  //   Rose(completer: completer);
  //   return await completer.future;
  // });
  getIt.registerLazySingleton<ConfigRepository>(() => ConfigRepository(getIt())); // Thêm dòng này
}

Future<void> resetLocator() async {
  await getIt.reset();
  setupLocator();
}