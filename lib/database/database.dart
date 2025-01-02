import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'models/config.dart';
import 'models/move.dart'; // file config cũ của bạn

part 'database.g.dart';

@DriftDatabase(tables: [Config, BaseMoves, Games, GameMoves]) // Thêm các bảng mới
class RoseDatabase extends _$RoseDatabase {
  RoseDatabase._create(QueryExecutor e) : super(e);

  factory RoseDatabase() {
    return RoseDatabase._create(_openConnection());
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(baseMoves);
          await m.createTable(games);
          await m.createTable(gameMoves);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}