import 'package:drift/drift.dart';
import 'package:rose_chess/database/database.dart';

class ConfigRepository {
  final RoseDatabase _database;

  ConfigRepository(this._database);

  Future<ConfigData?> getConfig(int id) async {
    final query = _database.select(_database.config)
      ..where((t) => t.id.equals(id));
    return await query.getSingleOrNull();
  }

  // Phương thức mới để lấy config có id lớn nhất
  Future<ConfigData?> getLastConfig() async {
    final query = _database.select(_database.config)
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
      ..limit(1);
    return await query.getSingleOrNull();
  }

  Future<void> saveConfig(Insertable<ConfigData> config) async {
    await _database.into(_database.config).insertOnConflictUpdate(config);
  }
}