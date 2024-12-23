import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'config.dart';
part 'database.g.dart';

@DriftDatabase(tables: [Configs])
class MyDatabase extends _$MyDatabase {
  MyDatabase._create(QueryExecutor e)
      : super(e); // Constructor chính vẫn là private

  // Factory constructor để tạo instance
  factory MyDatabase() {
    return MyDatabase._create(_openConnection());
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/db.sqlite');
    return NativeDatabase(file);
  });
}
