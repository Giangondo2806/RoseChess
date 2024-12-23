import 'package:get_it/get_it.dart';

import '../database/database.dart';


final getIt = GetIt.instance;

void setupDatabase() {
  getIt.registerLazySingleton<MyDatabase>(() => MyDatabase());
}