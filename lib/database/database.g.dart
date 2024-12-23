// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConfigTable extends Config with TableInfo<$ConfigTable, ConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dark'));
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
      'lang', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<int> hash = GeneratedColumn<int>(
      'hash', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(128));
  static const VerificationMeta _coreMeta = const VerificationMeta('core');
  @override
  late final GeneratedColumn<int> core = GeneratedColumn<int>(
      'core', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  @override
  List<GeneratedColumn> get $columns => [id, theme, lang, hash, core];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config';
  @override
  VerificationContext validateIntegrity(Insertable<ConfigData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('lang')) {
      context.handle(
          _langMeta, lang.isAcceptableOrUnknown(data['lang']!, _langMeta));
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    }
    if (data.containsKey('core')) {
      context.handle(
          _coreMeta, core.isAcceptableOrUnknown(data['core']!, _coreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      lang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang'])!,
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hash'])!,
      core: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}core'])!,
    );
  }

  @override
  $ConfigTable createAlias(String alias) {
    return $ConfigTable(attachedDatabase, alias);
  }
}

class ConfigData extends DataClass implements Insertable<ConfigData> {
  final int id;
  final String theme;
  final String lang;
  final int hash;
  final int core;
  const ConfigData(
      {required this.id,
      required this.theme,
      required this.lang,
      required this.hash,
      required this.core});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme'] = Variable<String>(theme);
    map['lang'] = Variable<String>(lang);
    map['hash'] = Variable<int>(hash);
    map['core'] = Variable<int>(core);
    return map;
  }

  ConfigCompanion toCompanion(bool nullToAbsent) {
    return ConfigCompanion(
      id: Value(id),
      theme: Value(theme),
      lang: Value(lang),
      hash: Value(hash),
      core: Value(core),
    );
  }

  factory ConfigData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigData(
      id: serializer.fromJson<int>(json['id']),
      theme: serializer.fromJson<String>(json['theme']),
      lang: serializer.fromJson<String>(json['lang']),
      hash: serializer.fromJson<int>(json['hash']),
      core: serializer.fromJson<int>(json['core']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'theme': serializer.toJson<String>(theme),
      'lang': serializer.toJson<String>(lang),
      'hash': serializer.toJson<int>(hash),
      'core': serializer.toJson<int>(core),
    };
  }

  ConfigData copyWith(
          {int? id, String? theme, String? lang, int? hash, int? core}) =>
      ConfigData(
        id: id ?? this.id,
        theme: theme ?? this.theme,
        lang: lang ?? this.lang,
        hash: hash ?? this.hash,
        core: core ?? this.core,
      );
  ConfigData copyWithCompanion(ConfigCompanion data) {
    return ConfigData(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      lang: data.lang.present ? data.lang.value : this.lang,
      hash: data.hash.present ? data.hash.value : this.hash,
      core: data.core.present ? data.core.value : this.core,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigData(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('lang: $lang, ')
          ..write('hash: $hash, ')
          ..write('core: $core')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, theme, lang, hash, core);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigData &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.lang == this.lang &&
          other.hash == this.hash &&
          other.core == this.core);
}

class ConfigCompanion extends UpdateCompanion<ConfigData> {
  final Value<int> id;
  final Value<String> theme;
  final Value<String> lang;
  final Value<int> hash;
  final Value<int> core;
  const ConfigCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.lang = const Value.absent(),
    this.hash = const Value.absent(),
    this.core = const Value.absent(),
  });
  ConfigCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.lang = const Value.absent(),
    this.hash = const Value.absent(),
    this.core = const Value.absent(),
  });
  static Insertable<ConfigData> custom({
    Expression<int>? id,
    Expression<String>? theme,
    Expression<String>? lang,
    Expression<int>? hash,
    Expression<int>? core,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (lang != null) 'lang': lang,
      if (hash != null) 'hash': hash,
      if (core != null) 'core': core,
    });
  }

  ConfigCompanion copyWith(
      {Value<int>? id,
      Value<String>? theme,
      Value<String>? lang,
      Value<int>? hash,
      Value<int>? core}) {
    return ConfigCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      lang: lang ?? this.lang,
      hash: hash ?? this.hash,
      core: core ?? this.core,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (hash.present) {
      map['hash'] = Variable<int>(hash.value);
    }
    if (core.present) {
      map['core'] = Variable<int>(core.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('lang: $lang, ')
          ..write('hash: $hash, ')
          ..write('core: $core')
          ..write(')'))
        .toString();
  }
}

abstract class _$RoseDatabase extends GeneratedDatabase {
  _$RoseDatabase(QueryExecutor e) : super(e);
  $RoseDatabaseManager get managers => $RoseDatabaseManager(this);
  late final $ConfigTable config = $ConfigTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [config];
}

typedef $$ConfigTableCreateCompanionBuilder = ConfigCompanion Function({
  Value<int> id,
  Value<String> theme,
  Value<String> lang,
  Value<int> hash,
  Value<int> core,
});
typedef $$ConfigTableUpdateCompanionBuilder = ConfigCompanion Function({
  Value<int> id,
  Value<String> theme,
  Value<String> lang,
  Value<int> hash,
  Value<int> core,
});

class $$ConfigTableFilterComposer
    extends Composer<_$RoseDatabase, $ConfigTable> {
  $$ConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get core => $composableBuilder(
      column: $table.core, builder: (column) => ColumnFilters(column));
}

class $$ConfigTableOrderingComposer
    extends Composer<_$RoseDatabase, $ConfigTable> {
  $$ConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get core => $composableBuilder(
      column: $table.core, builder: (column) => ColumnOrderings(column));
}

class $$ConfigTableAnnotationComposer
    extends Composer<_$RoseDatabase, $ConfigTable> {
  $$ConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<int> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<int> get core =>
      $composableBuilder(column: $table.core, builder: (column) => column);
}

class $$ConfigTableTableManager extends RootTableManager<
    _$RoseDatabase,
    $ConfigTable,
    ConfigData,
    $$ConfigTableFilterComposer,
    $$ConfigTableOrderingComposer,
    $$ConfigTableAnnotationComposer,
    $$ConfigTableCreateCompanionBuilder,
    $$ConfigTableUpdateCompanionBuilder,
    (ConfigData, BaseReferences<_$RoseDatabase, $ConfigTable, ConfigData>),
    ConfigData,
    PrefetchHooks Function()> {
  $$ConfigTableTableManager(_$RoseDatabase db, $ConfigTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<String> lang = const Value.absent(),
            Value<int> hash = const Value.absent(),
            Value<int> core = const Value.absent(),
          }) =>
              ConfigCompanion(
            id: id,
            theme: theme,
            lang: lang,
            hash: hash,
            core: core,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<String> lang = const Value.absent(),
            Value<int> hash = const Value.absent(),
            Value<int> core = const Value.absent(),
          }) =>
              ConfigCompanion.insert(
            id: id,
            theme: theme,
            lang: lang,
            hash: hash,
            core: core,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfigTableProcessedTableManager = ProcessedTableManager<
    _$RoseDatabase,
    $ConfigTable,
    ConfigData,
    $$ConfigTableFilterComposer,
    $$ConfigTableOrderingComposer,
    $$ConfigTableAnnotationComposer,
    $$ConfigTableCreateCompanionBuilder,
    $$ConfigTableUpdateCompanionBuilder,
    (ConfigData, BaseReferences<_$RoseDatabase, $ConfigTable, ConfigData>),
    ConfigData,
    PrefetchHooks Function()>;

class $RoseDatabaseManager {
  final _$RoseDatabase _db;
  $RoseDatabaseManager(this._db);
  $$ConfigTableTableManager get config =>
      $$ConfigTableTableManager(_db, _db.config);
}
