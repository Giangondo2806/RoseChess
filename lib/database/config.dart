import 'package:drift/drift.dart';

class Configs extends Table {
  IntColumn get id => integer()();
  TextColumn get theme => text().withDefault(const Constant('dark'))();
  TextColumn get lang => text().withDefault(const Constant('en'))();
  IntColumn get hash => integer().withDefault(const Constant(128))();
  IntColumn get core => integer().withDefault(const Constant(2))();

  @override
  Set<Column> get primaryKey => {id};
}