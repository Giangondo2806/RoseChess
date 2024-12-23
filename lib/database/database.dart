import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'models/config.dart';
part 'database.g.dart';

@DriftDatabase(tables: [Config])
class RoseDatabase extends _$RoseDatabase {
  RoseDatabase._create(QueryExecutor e)
      : super(e); // Constructor chính vẫn là private

  // Factory constructor để tạo instance
  factory RoseDatabase() {
    return RoseDatabase._create(_openConnection());
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
