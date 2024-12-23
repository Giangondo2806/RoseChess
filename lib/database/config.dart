import 'package:isar/isar.dart';

part 'config.g.dart';

@collection
class Config {
  Id id = Isar.autoIncrement;

  String theme = 'dark';
  String lang = 'en';
  int hash = 128;
  int core = 2;

  Config({
    this.theme = 'dark',
    this.lang = 'en',
    this.hash = 128,
    this.core = 2,
  });
}
