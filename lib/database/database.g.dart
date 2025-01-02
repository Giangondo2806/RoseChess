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
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
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

class $BaseMovesTable extends BaseMoves
    with TableInfo<$BaseMovesTable, BaseMove> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BaseMovesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _notationMeta =
      const VerificationMeta('notation');
  @override
  late final GeneratedColumn<String> notation = GeneratedColumn<String>(
      'notation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _evaluationMeta =
      const VerificationMeta('evaluation');
  @override
  late final GeneratedColumn<int> evaluation = GeneratedColumn<int>(
      'evaluation', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fenMeta = const VerificationMeta('fen');
  @override
  late final GeneratedColumn<String> fen = GeneratedColumn<String>(
      'fen', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depthMeta = const VerificationMeta('depth');
  @override
  late final GeneratedColumn<int> depth = GeneratedColumn<int>(
      'depth', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncMeta = const VerificationMeta('sync');
  @override
  late final GeneratedColumn<DateTime> sync = GeneratedColumn<DateTime>(
      'sync', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, notation, evaluation, fen, depth, sync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'base_moves';
  @override
  VerificationContext validateIntegrity(Insertable<BaseMove> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notation')) {
      context.handle(_notationMeta,
          notation.isAcceptableOrUnknown(data['notation']!, _notationMeta));
    } else if (isInserting) {
      context.missing(_notationMeta);
    }
    if (data.containsKey('evaluation')) {
      context.handle(
          _evaluationMeta,
          evaluation.isAcceptableOrUnknown(
              data['evaluation']!, _evaluationMeta));
    } else if (isInserting) {
      context.missing(_evaluationMeta);
    }
    if (data.containsKey('fen')) {
      context.handle(
          _fenMeta, fen.isAcceptableOrUnknown(data['fen']!, _fenMeta));
    } else if (isInserting) {
      context.missing(_fenMeta);
    }
    if (data.containsKey('depth')) {
      context.handle(
          _depthMeta, depth.isAcceptableOrUnknown(data['depth']!, _depthMeta));
    } else if (isInserting) {
      context.missing(_depthMeta);
    }
    if (data.containsKey('sync')) {
      context.handle(
          _syncMeta, sync.isAcceptableOrUnknown(data['sync']!, _syncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BaseMove map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaseMove(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      notation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notation'])!,
      evaluation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}evaluation'])!,
      fen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fen'])!,
      depth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}depth'])!,
      sync: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sync']),
    );
  }

  @override
  $BaseMovesTable createAlias(String alias) {
    return $BaseMovesTable(attachedDatabase, alias);
  }
}

class BaseMove extends DataClass implements Insertable<BaseMove> {
  final int id;
  final String notation;
  final int evaluation;
  final String fen;
  final int depth;
  final DateTime? sync;
  const BaseMove(
      {required this.id,
      required this.notation,
      required this.evaluation,
      required this.fen,
      required this.depth,
      this.sync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['notation'] = Variable<String>(notation);
    map['evaluation'] = Variable<int>(evaluation);
    map['fen'] = Variable<String>(fen);
    map['depth'] = Variable<int>(depth);
    if (!nullToAbsent || sync != null) {
      map['sync'] = Variable<DateTime>(sync);
    }
    return map;
  }

  BaseMovesCompanion toCompanion(bool nullToAbsent) {
    return BaseMovesCompanion(
      id: Value(id),
      notation: Value(notation),
      evaluation: Value(evaluation),
      fen: Value(fen),
      depth: Value(depth),
      sync: sync == null && nullToAbsent ? const Value.absent() : Value(sync),
    );
  }

  factory BaseMove.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaseMove(
      id: serializer.fromJson<int>(json['id']),
      notation: serializer.fromJson<String>(json['notation']),
      evaluation: serializer.fromJson<int>(json['evaluation']),
      fen: serializer.fromJson<String>(json['fen']),
      depth: serializer.fromJson<int>(json['depth']),
      sync: serializer.fromJson<DateTime?>(json['sync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notation': serializer.toJson<String>(notation),
      'evaluation': serializer.toJson<int>(evaluation),
      'fen': serializer.toJson<String>(fen),
      'depth': serializer.toJson<int>(depth),
      'sync': serializer.toJson<DateTime?>(sync),
    };
  }

  BaseMove copyWith(
          {int? id,
          String? notation,
          int? evaluation,
          String? fen,
          int? depth,
          Value<DateTime?> sync = const Value.absent()}) =>
      BaseMove(
        id: id ?? this.id,
        notation: notation ?? this.notation,
        evaluation: evaluation ?? this.evaluation,
        fen: fen ?? this.fen,
        depth: depth ?? this.depth,
        sync: sync.present ? sync.value : this.sync,
      );
  BaseMove copyWithCompanion(BaseMovesCompanion data) {
    return BaseMove(
      id: data.id.present ? data.id.value : this.id,
      notation: data.notation.present ? data.notation.value : this.notation,
      evaluation:
          data.evaluation.present ? data.evaluation.value : this.evaluation,
      fen: data.fen.present ? data.fen.value : this.fen,
      depth: data.depth.present ? data.depth.value : this.depth,
      sync: data.sync.present ? data.sync.value : this.sync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaseMove(')
          ..write('id: $id, ')
          ..write('notation: $notation, ')
          ..write('evaluation: $evaluation, ')
          ..write('fen: $fen, ')
          ..write('depth: $depth, ')
          ..write('sync: $sync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, notation, evaluation, fen, depth, sync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseMove &&
          other.id == this.id &&
          other.notation == this.notation &&
          other.evaluation == this.evaluation &&
          other.fen == this.fen &&
          other.depth == this.depth &&
          other.sync == this.sync);
}

class BaseMovesCompanion extends UpdateCompanion<BaseMove> {
  final Value<int> id;
  final Value<String> notation;
  final Value<int> evaluation;
  final Value<String> fen;
  final Value<int> depth;
  final Value<DateTime?> sync;
  const BaseMovesCompanion({
    this.id = const Value.absent(),
    this.notation = const Value.absent(),
    this.evaluation = const Value.absent(),
    this.fen = const Value.absent(),
    this.depth = const Value.absent(),
    this.sync = const Value.absent(),
  });
  BaseMovesCompanion.insert({
    this.id = const Value.absent(),
    required String notation,
    required int evaluation,
    required String fen,
    required int depth,
    this.sync = const Value.absent(),
  })  : notation = Value(notation),
        evaluation = Value(evaluation),
        fen = Value(fen),
        depth = Value(depth);
  static Insertable<BaseMove> custom({
    Expression<int>? id,
    Expression<String>? notation,
    Expression<int>? evaluation,
    Expression<String>? fen,
    Expression<int>? depth,
    Expression<DateTime>? sync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notation != null) 'notation': notation,
      if (evaluation != null) 'evaluation': evaluation,
      if (fen != null) 'fen': fen,
      if (depth != null) 'depth': depth,
      if (sync != null) 'sync': sync,
    });
  }

  BaseMovesCompanion copyWith(
      {Value<int>? id,
      Value<String>? notation,
      Value<int>? evaluation,
      Value<String>? fen,
      Value<int>? depth,
      Value<DateTime?>? sync}) {
    return BaseMovesCompanion(
      id: id ?? this.id,
      notation: notation ?? this.notation,
      evaluation: evaluation ?? this.evaluation,
      fen: fen ?? this.fen,
      depth: depth ?? this.depth,
      sync: sync ?? this.sync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notation.present) {
      map['notation'] = Variable<String>(notation.value);
    }
    if (evaluation.present) {
      map['evaluation'] = Variable<int>(evaluation.value);
    }
    if (fen.present) {
      map['fen'] = Variable<String>(fen.value);
    }
    if (depth.present) {
      map['depth'] = Variable<int>(depth.value);
    }
    if (sync.present) {
      map['sync'] = Variable<DateTime>(sync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaseMovesCompanion(')
          ..write('id: $id, ')
          ..write('notation: $notation, ')
          ..write('evaluation: $evaluation, ')
          ..write('fen: $fen, ')
          ..write('depth: $depth, ')
          ..write('sync: $sync')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _whitePlayerMeta =
      const VerificationMeta('whitePlayer');
  @override
  late final GeneratedColumn<String> whitePlayer = GeneratedColumn<String>(
      'white_player', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _blackPlayerMeta =
      const VerificationMeta('blackPlayer');
  @override
  late final GeneratedColumn<String> blackPlayer = GeneratedColumn<String>(
      'black_player', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumnWithTypeConverter<GameResult, String> result =
      GeneratedColumn<String>('result', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<GameResult>($GamesTable.$converterresult);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startTime, endTime, whitePlayer, blackPlayer, result];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(Insertable<Game> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('white_player')) {
      context.handle(
          _whitePlayerMeta,
          whitePlayer.isAcceptableOrUnknown(
              data['white_player']!, _whitePlayerMeta));
    }
    if (data.containsKey('black_player')) {
      context.handle(
          _blackPlayerMeta,
          blackPlayer.isAcceptableOrUnknown(
              data['black_player']!, _blackPlayerMeta));
    }
    context.handle(_resultMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      whitePlayer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}white_player']),
      blackPlayer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}black_player']),
      result: $GamesTable.$converterresult.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameResult, String, String> $converterresult =
      const EnumNameConverter<GameResult>(GameResult.values);
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final String? whitePlayer;
  final String? blackPlayer;
  final GameResult result;
  const Game(
      {required this.id,
      required this.startTime,
      this.endTime,
      this.whitePlayer,
      this.blackPlayer,
      required this.result});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || whitePlayer != null) {
      map['white_player'] = Variable<String>(whitePlayer);
    }
    if (!nullToAbsent || blackPlayer != null) {
      map['black_player'] = Variable<String>(blackPlayer);
    }
    {
      map['result'] =
          Variable<String>($GamesTable.$converterresult.toSql(result));
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      whitePlayer: whitePlayer == null && nullToAbsent
          ? const Value.absent()
          : Value(whitePlayer),
      blackPlayer: blackPlayer == null && nullToAbsent
          ? const Value.absent()
          : Value(blackPlayer),
      result: Value(result),
    );
  }

  factory Game.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      whitePlayer: serializer.fromJson<String?>(json['whitePlayer']),
      blackPlayer: serializer.fromJson<String?>(json['blackPlayer']),
      result: $GamesTable.$converterresult
          .fromJson(serializer.fromJson<String>(json['result'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'whitePlayer': serializer.toJson<String?>(whitePlayer),
      'blackPlayer': serializer.toJson<String?>(blackPlayer),
      'result': serializer
          .toJson<String>($GamesTable.$converterresult.toJson(result)),
    };
  }

  Game copyWith(
          {int? id,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          Value<String?> whitePlayer = const Value.absent(),
          Value<String?> blackPlayer = const Value.absent(),
          GameResult? result}) =>
      Game(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        whitePlayer: whitePlayer.present ? whitePlayer.value : this.whitePlayer,
        blackPlayer: blackPlayer.present ? blackPlayer.value : this.blackPlayer,
        result: result ?? this.result,
      );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      whitePlayer:
          data.whitePlayer.present ? data.whitePlayer.value : this.whitePlayer,
      blackPlayer:
          data.blackPlayer.present ? data.blackPlayer.value : this.blackPlayer,
      result: data.result.present ? data.result.value : this.result,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('whitePlayer: $whitePlayer, ')
          ..write('blackPlayer: $blackPlayer, ')
          ..write('result: $result')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startTime, endTime, whitePlayer, blackPlayer, result);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.whitePlayer == this.whitePlayer &&
          other.blackPlayer == this.blackPlayer &&
          other.result == this.result);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<String?> whitePlayer;
  final Value<String?> blackPlayer;
  final Value<GameResult> result;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.whitePlayer = const Value.absent(),
    this.blackPlayer = const Value.absent(),
    this.result = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.whitePlayer = const Value.absent(),
    this.blackPlayer = const Value.absent(),
    required GameResult result,
  })  : startTime = Value(startTime),
        result = Value(result);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? whitePlayer,
    Expression<String>? blackPlayer,
    Expression<String>? result,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (whitePlayer != null) 'white_player': whitePlayer,
      if (blackPlayer != null) 'black_player': blackPlayer,
      if (result != null) 'result': result,
    });
  }

  GamesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<String?>? whitePlayer,
      Value<String?>? blackPlayer,
      Value<GameResult>? result}) {
    return GamesCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      whitePlayer: whitePlayer ?? this.whitePlayer,
      blackPlayer: blackPlayer ?? this.blackPlayer,
      result: result ?? this.result,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (whitePlayer.present) {
      map['white_player'] = Variable<String>(whitePlayer.value);
    }
    if (blackPlayer.present) {
      map['black_player'] = Variable<String>(blackPlayer.value);
    }
    if (result.present) {
      map['result'] =
          Variable<String>($GamesTable.$converterresult.toSql(result.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('whitePlayer: $whitePlayer, ')
          ..write('blackPlayer: $blackPlayer, ')
          ..write('result: $result')
          ..write(')'))
        .toString();
  }
}

class $GameMovesTable extends GameMoves
    with TableInfo<$GameMovesTable, GameMove> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameMovesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
      'game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES games (id)'));
  static const VerificationMeta _moveNumberMeta =
      const VerificationMeta('moveNumber');
  @override
  late final GeneratedColumn<int> moveNumber = GeneratedColumn<int>(
      'move_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _baseMoveIdMeta =
      const VerificationMeta('baseMoveId');
  @override
  late final GeneratedColumn<int> baseMoveId = GeneratedColumn<int>(
      'base_move_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES base_moves (id)'));
  static const VerificationMeta _parentMoveIdMeta =
      const VerificationMeta('parentMoveId');
  @override
  late final GeneratedColumn<int> parentMoveId = GeneratedColumn<int>(
      'parent_move_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES game_moves (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, gameId, moveNumber, baseMoveId, parentMoveId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_moves';
  @override
  VerificationContext validateIntegrity(Insertable<GameMove> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('move_number')) {
      context.handle(
          _moveNumberMeta,
          moveNumber.isAcceptableOrUnknown(
              data['move_number']!, _moveNumberMeta));
    } else if (isInserting) {
      context.missing(_moveNumberMeta);
    }
    if (data.containsKey('base_move_id')) {
      context.handle(
          _baseMoveIdMeta,
          baseMoveId.isAcceptableOrUnknown(
              data['base_move_id']!, _baseMoveIdMeta));
    } else if (isInserting) {
      context.missing(_baseMoveIdMeta);
    }
    if (data.containsKey('parent_move_id')) {
      context.handle(
          _parentMoveIdMeta,
          parentMoveId.isAcceptableOrUnknown(
              data['parent_move_id']!, _parentMoveIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameMove map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameMove(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}game_id'])!,
      moveNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}move_number'])!,
      baseMoveId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_move_id'])!,
      parentMoveId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_move_id']),
    );
  }

  @override
  $GameMovesTable createAlias(String alias) {
    return $GameMovesTable(attachedDatabase, alias);
  }
}

class GameMove extends DataClass implements Insertable<GameMove> {
  final int id;
  final int gameId;
  final int moveNumber;
  final int baseMoveId;
  final int? parentMoveId;
  const GameMove(
      {required this.id,
      required this.gameId,
      required this.moveNumber,
      required this.baseMoveId,
      this.parentMoveId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['move_number'] = Variable<int>(moveNumber);
    map['base_move_id'] = Variable<int>(baseMoveId);
    if (!nullToAbsent || parentMoveId != null) {
      map['parent_move_id'] = Variable<int>(parentMoveId);
    }
    return map;
  }

  GameMovesCompanion toCompanion(bool nullToAbsent) {
    return GameMovesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      moveNumber: Value(moveNumber),
      baseMoveId: Value(baseMoveId),
      parentMoveId: parentMoveId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentMoveId),
    );
  }

  factory GameMove.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameMove(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      moveNumber: serializer.fromJson<int>(json['moveNumber']),
      baseMoveId: serializer.fromJson<int>(json['baseMoveId']),
      parentMoveId: serializer.fromJson<int?>(json['parentMoveId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'moveNumber': serializer.toJson<int>(moveNumber),
      'baseMoveId': serializer.toJson<int>(baseMoveId),
      'parentMoveId': serializer.toJson<int?>(parentMoveId),
    };
  }

  GameMove copyWith(
          {int? id,
          int? gameId,
          int? moveNumber,
          int? baseMoveId,
          Value<int?> parentMoveId = const Value.absent()}) =>
      GameMove(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        moveNumber: moveNumber ?? this.moveNumber,
        baseMoveId: baseMoveId ?? this.baseMoveId,
        parentMoveId:
            parentMoveId.present ? parentMoveId.value : this.parentMoveId,
      );
  GameMove copyWithCompanion(GameMovesCompanion data) {
    return GameMove(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      moveNumber:
          data.moveNumber.present ? data.moveNumber.value : this.moveNumber,
      baseMoveId:
          data.baseMoveId.present ? data.baseMoveId.value : this.baseMoveId,
      parentMoveId: data.parentMoveId.present
          ? data.parentMoveId.value
          : this.parentMoveId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameMove(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('moveNumber: $moveNumber, ')
          ..write('baseMoveId: $baseMoveId, ')
          ..write('parentMoveId: $parentMoveId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, moveNumber, baseMoveId, parentMoveId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameMove &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.moveNumber == this.moveNumber &&
          other.baseMoveId == this.baseMoveId &&
          other.parentMoveId == this.parentMoveId);
}

class GameMovesCompanion extends UpdateCompanion<GameMove> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> moveNumber;
  final Value<int> baseMoveId;
  final Value<int?> parentMoveId;
  const GameMovesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.moveNumber = const Value.absent(),
    this.baseMoveId = const Value.absent(),
    this.parentMoveId = const Value.absent(),
  });
  GameMovesCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int moveNumber,
    required int baseMoveId,
    this.parentMoveId = const Value.absent(),
  })  : gameId = Value(gameId),
        moveNumber = Value(moveNumber),
        baseMoveId = Value(baseMoveId);
  static Insertable<GameMove> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? moveNumber,
    Expression<int>? baseMoveId,
    Expression<int>? parentMoveId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (moveNumber != null) 'move_number': moveNumber,
      if (baseMoveId != null) 'base_move_id': baseMoveId,
      if (parentMoveId != null) 'parent_move_id': parentMoveId,
    });
  }

  GameMovesCompanion copyWith(
      {Value<int>? id,
      Value<int>? gameId,
      Value<int>? moveNumber,
      Value<int>? baseMoveId,
      Value<int?>? parentMoveId}) {
    return GameMovesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      moveNumber: moveNumber ?? this.moveNumber,
      baseMoveId: baseMoveId ?? this.baseMoveId,
      parentMoveId: parentMoveId ?? this.parentMoveId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (moveNumber.present) {
      map['move_number'] = Variable<int>(moveNumber.value);
    }
    if (baseMoveId.present) {
      map['base_move_id'] = Variable<int>(baseMoveId.value);
    }
    if (parentMoveId.present) {
      map['parent_move_id'] = Variable<int>(parentMoveId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameMovesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('moveNumber: $moveNumber, ')
          ..write('baseMoveId: $baseMoveId, ')
          ..write('parentMoveId: $parentMoveId')
          ..write(')'))
        .toString();
  }
}

abstract class _$RoseDatabase extends GeneratedDatabase {
  _$RoseDatabase(QueryExecutor e) : super(e);
  $RoseDatabaseManager get managers => $RoseDatabaseManager(this);
  late final $ConfigTable config = $ConfigTable(this);
  late final $BaseMovesTable baseMoves = $BaseMovesTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $GameMovesTable gameMoves = $GameMovesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [config, baseMoves, games, gameMoves];
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
typedef $$BaseMovesTableCreateCompanionBuilder = BaseMovesCompanion Function({
  Value<int> id,
  required String notation,
  required int evaluation,
  required String fen,
  required int depth,
  Value<DateTime?> sync,
});
typedef $$BaseMovesTableUpdateCompanionBuilder = BaseMovesCompanion Function({
  Value<int> id,
  Value<String> notation,
  Value<int> evaluation,
  Value<String> fen,
  Value<int> depth,
  Value<DateTime?> sync,
});

final class $$BaseMovesTableReferences
    extends BaseReferences<_$RoseDatabase, $BaseMovesTable, BaseMove> {
  $$BaseMovesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GameMovesTable, List<GameMove>>
      _gameMovesRefsTable(_$RoseDatabase db) => MultiTypedResultKey.fromTable(
          db.gameMoves,
          aliasName:
              $_aliasNameGenerator(db.baseMoves.id, db.gameMoves.baseMoveId));

  $$GameMovesTableProcessedTableManager get gameMovesRefs {
    final manager = $$GameMovesTableTableManager($_db, $_db.gameMoves)
        .filter((f) => f.baseMoveId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_gameMovesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BaseMovesTableFilterComposer
    extends Composer<_$RoseDatabase, $BaseMovesTable> {
  $$BaseMovesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notation => $composableBuilder(
      column: $table.notation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get evaluation => $composableBuilder(
      column: $table.evaluation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fen => $composableBuilder(
      column: $table.fen, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get depth => $composableBuilder(
      column: $table.depth, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sync => $composableBuilder(
      column: $table.sync, builder: (column) => ColumnFilters(column));

  Expression<bool> gameMovesRefs(
      Expression<bool> Function($$GameMovesTableFilterComposer f) f) {
    final $$GameMovesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.baseMoveId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableFilterComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BaseMovesTableOrderingComposer
    extends Composer<_$RoseDatabase, $BaseMovesTable> {
  $$BaseMovesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notation => $composableBuilder(
      column: $table.notation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get evaluation => $composableBuilder(
      column: $table.evaluation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fen => $composableBuilder(
      column: $table.fen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get depth => $composableBuilder(
      column: $table.depth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sync => $composableBuilder(
      column: $table.sync, builder: (column) => ColumnOrderings(column));
}

class $$BaseMovesTableAnnotationComposer
    extends Composer<_$RoseDatabase, $BaseMovesTable> {
  $$BaseMovesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notation =>
      $composableBuilder(column: $table.notation, builder: (column) => column);

  GeneratedColumn<int> get evaluation => $composableBuilder(
      column: $table.evaluation, builder: (column) => column);

  GeneratedColumn<String> get fen =>
      $composableBuilder(column: $table.fen, builder: (column) => column);

  GeneratedColumn<int> get depth =>
      $composableBuilder(column: $table.depth, builder: (column) => column);

  GeneratedColumn<DateTime> get sync =>
      $composableBuilder(column: $table.sync, builder: (column) => column);

  Expression<T> gameMovesRefs<T extends Object>(
      Expression<T> Function($$GameMovesTableAnnotationComposer a) f) {
    final $$GameMovesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.baseMoveId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableAnnotationComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BaseMovesTableTableManager extends RootTableManager<
    _$RoseDatabase,
    $BaseMovesTable,
    BaseMove,
    $$BaseMovesTableFilterComposer,
    $$BaseMovesTableOrderingComposer,
    $$BaseMovesTableAnnotationComposer,
    $$BaseMovesTableCreateCompanionBuilder,
    $$BaseMovesTableUpdateCompanionBuilder,
    (BaseMove, $$BaseMovesTableReferences),
    BaseMove,
    PrefetchHooks Function({bool gameMovesRefs})> {
  $$BaseMovesTableTableManager(_$RoseDatabase db, $BaseMovesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BaseMovesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BaseMovesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BaseMovesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> notation = const Value.absent(),
            Value<int> evaluation = const Value.absent(),
            Value<String> fen = const Value.absent(),
            Value<int> depth = const Value.absent(),
            Value<DateTime?> sync = const Value.absent(),
          }) =>
              BaseMovesCompanion(
            id: id,
            notation: notation,
            evaluation: evaluation,
            fen: fen,
            depth: depth,
            sync: sync,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String notation,
            required int evaluation,
            required String fen,
            required int depth,
            Value<DateTime?> sync = const Value.absent(),
          }) =>
              BaseMovesCompanion.insert(
            id: id,
            notation: notation,
            evaluation: evaluation,
            fen: fen,
            depth: depth,
            sync: sync,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BaseMovesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({gameMovesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gameMovesRefs) db.gameMoves],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gameMovesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$BaseMovesTableReferences._gameMovesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BaseMovesTableReferences(db, table, p0)
                                .gameMovesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.baseMoveId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BaseMovesTableProcessedTableManager = ProcessedTableManager<
    _$RoseDatabase,
    $BaseMovesTable,
    BaseMove,
    $$BaseMovesTableFilterComposer,
    $$BaseMovesTableOrderingComposer,
    $$BaseMovesTableAnnotationComposer,
    $$BaseMovesTableCreateCompanionBuilder,
    $$BaseMovesTableUpdateCompanionBuilder,
    (BaseMove, $$BaseMovesTableReferences),
    BaseMove,
    PrefetchHooks Function({bool gameMovesRefs})>;
typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<String?> whitePlayer,
  Value<String?> blackPlayer,
  required GameResult result,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<String?> whitePlayer,
  Value<String?> blackPlayer,
  Value<GameResult> result,
});

final class $$GamesTableReferences
    extends BaseReferences<_$RoseDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GameMovesTable, List<GameMove>>
      _gameMovesRefsTable(_$RoseDatabase db) => MultiTypedResultKey.fromTable(
          db.gameMoves,
          aliasName: $_aliasNameGenerator(db.games.id, db.gameMoves.gameId));

  $$GameMovesTableProcessedTableManager get gameMovesRefs {
    final manager = $$GameMovesTableTableManager($_db, $_db.gameMoves)
        .filter((f) => f.gameId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_gameMovesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GamesTableFilterComposer extends Composer<_$RoseDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whitePlayer => $composableBuilder(
      column: $table.whitePlayer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blackPlayer => $composableBuilder(
      column: $table.blackPlayer, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<GameResult, GameResult, String> get result =>
      $composableBuilder(
          column: $table.result,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> gameMovesRefs(
      Expression<bool> Function($$GameMovesTableFilterComposer f) f) {
    final $$GameMovesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.gameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableFilterComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$RoseDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whitePlayer => $composableBuilder(
      column: $table.whitePlayer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blackPlayer => $composableBuilder(
      column: $table.blackPlayer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));
}

class $$GamesTableAnnotationComposer
    extends Composer<_$RoseDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get whitePlayer => $composableBuilder(
      column: $table.whitePlayer, builder: (column) => column);

  GeneratedColumn<String> get blackPlayer => $composableBuilder(
      column: $table.blackPlayer, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameResult, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  Expression<T> gameMovesRefs<T extends Object>(
      Expression<T> Function($$GameMovesTableAnnotationComposer a) f) {
    final $$GameMovesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.gameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableAnnotationComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GamesTableTableManager extends RootTableManager<
    _$RoseDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, $$GamesTableReferences),
    Game,
    PrefetchHooks Function({bool gameMovesRefs})> {
  $$GamesTableTableManager(_$RoseDatabase db, $GamesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<String?> whitePlayer = const Value.absent(),
            Value<String?> blackPlayer = const Value.absent(),
            Value<GameResult> result = const Value.absent(),
          }) =>
              GamesCompanion(
            id: id,
            startTime: startTime,
            endTime: endTime,
            whitePlayer: whitePlayer,
            blackPlayer: blackPlayer,
            result: result,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<String?> whitePlayer = const Value.absent(),
            Value<String?> blackPlayer = const Value.absent(),
            required GameResult result,
          }) =>
              GamesCompanion.insert(
            id: id,
            startTime: startTime,
            endTime: endTime,
            whitePlayer: whitePlayer,
            blackPlayer: blackPlayer,
            result: result,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GamesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({gameMovesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gameMovesRefs) db.gameMoves],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gameMovesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$GamesTableReferences._gameMovesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GamesTableReferences(db, table, p0).gameMovesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gameId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GamesTableProcessedTableManager = ProcessedTableManager<
    _$RoseDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, $$GamesTableReferences),
    Game,
    PrefetchHooks Function({bool gameMovesRefs})>;
typedef $$GameMovesTableCreateCompanionBuilder = GameMovesCompanion Function({
  Value<int> id,
  required int gameId,
  required int moveNumber,
  required int baseMoveId,
  Value<int?> parentMoveId,
});
typedef $$GameMovesTableUpdateCompanionBuilder = GameMovesCompanion Function({
  Value<int> id,
  Value<int> gameId,
  Value<int> moveNumber,
  Value<int> baseMoveId,
  Value<int?> parentMoveId,
});

final class $$GameMovesTableReferences
    extends BaseReferences<_$RoseDatabase, $GameMovesTable, GameMove> {
  $$GameMovesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$RoseDatabase db) => db.games
      .createAlias($_aliasNameGenerator(db.gameMoves.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final manager = $$GamesTableTableManager($_db, $_db.games)
        .filter((f) => f.id($_item.gameId!));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BaseMovesTable _baseMoveIdTable(_$RoseDatabase db) =>
      db.baseMoves.createAlias(
          $_aliasNameGenerator(db.gameMoves.baseMoveId, db.baseMoves.id));

  $$BaseMovesTableProcessedTableManager get baseMoveId {
    final manager = $$BaseMovesTableTableManager($_db, $_db.baseMoves)
        .filter((f) => f.id($_item.baseMoveId!));
    final item = $_typedResult.readTableOrNull(_baseMoveIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GameMovesTable _parentMoveIdTable(_$RoseDatabase db) =>
      db.gameMoves.createAlias(
          $_aliasNameGenerator(db.gameMoves.parentMoveId, db.gameMoves.id));

  $$GameMovesTableProcessedTableManager? get parentMoveId {
    if ($_item.parentMoveId == null) return null;
    final manager = $$GameMovesTableTableManager($_db, $_db.gameMoves)
        .filter((f) => f.id($_item.parentMoveId!));
    final item = $_typedResult.readTableOrNull(_parentMoveIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GameMovesTableFilterComposer
    extends Composer<_$RoseDatabase, $GameMovesTable> {
  $$GameMovesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get moveNumber => $composableBuilder(
      column: $table.moveNumber, builder: (column) => ColumnFilters(column));

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableFilterComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BaseMovesTableFilterComposer get baseMoveId {
    final $$BaseMovesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseMoveId,
        referencedTable: $db.baseMoves,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BaseMovesTableFilterComposer(
              $db: $db,
              $table: $db.baseMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GameMovesTableFilterComposer get parentMoveId {
    final $$GameMovesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentMoveId,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableFilterComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GameMovesTableOrderingComposer
    extends Composer<_$RoseDatabase, $GameMovesTable> {
  $$GameMovesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get moveNumber => $composableBuilder(
      column: $table.moveNumber, builder: (column) => ColumnOrderings(column));

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableOrderingComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BaseMovesTableOrderingComposer get baseMoveId {
    final $$BaseMovesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseMoveId,
        referencedTable: $db.baseMoves,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BaseMovesTableOrderingComposer(
              $db: $db,
              $table: $db.baseMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GameMovesTableOrderingComposer get parentMoveId {
    final $$GameMovesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentMoveId,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableOrderingComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GameMovesTableAnnotationComposer
    extends Composer<_$RoseDatabase, $GameMovesTable> {
  $$GameMovesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get moveNumber => $composableBuilder(
      column: $table.moveNumber, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableAnnotationComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BaseMovesTableAnnotationComposer get baseMoveId {
    final $$BaseMovesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseMoveId,
        referencedTable: $db.baseMoves,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BaseMovesTableAnnotationComposer(
              $db: $db,
              $table: $db.baseMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GameMovesTableAnnotationComposer get parentMoveId {
    final $$GameMovesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentMoveId,
        referencedTable: $db.gameMoves,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GameMovesTableAnnotationComposer(
              $db: $db,
              $table: $db.gameMoves,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GameMovesTableTableManager extends RootTableManager<
    _$RoseDatabase,
    $GameMovesTable,
    GameMove,
    $$GameMovesTableFilterComposer,
    $$GameMovesTableOrderingComposer,
    $$GameMovesTableAnnotationComposer,
    $$GameMovesTableCreateCompanionBuilder,
    $$GameMovesTableUpdateCompanionBuilder,
    (GameMove, $$GameMovesTableReferences),
    GameMove,
    PrefetchHooks Function({bool gameId, bool baseMoveId, bool parentMoveId})> {
  $$GameMovesTableTableManager(_$RoseDatabase db, $GameMovesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameMovesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameMovesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameMovesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> gameId = const Value.absent(),
            Value<int> moveNumber = const Value.absent(),
            Value<int> baseMoveId = const Value.absent(),
            Value<int?> parentMoveId = const Value.absent(),
          }) =>
              GameMovesCompanion(
            id: id,
            gameId: gameId,
            moveNumber: moveNumber,
            baseMoveId: baseMoveId,
            parentMoveId: parentMoveId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int gameId,
            required int moveNumber,
            required int baseMoveId,
            Value<int?> parentMoveId = const Value.absent(),
          }) =>
              GameMovesCompanion.insert(
            id: id,
            gameId: gameId,
            moveNumber: moveNumber,
            baseMoveId: baseMoveId,
            parentMoveId: parentMoveId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GameMovesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {gameId = false, baseMoveId = false, parentMoveId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (gameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gameId,
                    referencedTable:
                        $$GameMovesTableReferences._gameIdTable(db),
                    referencedColumn:
                        $$GameMovesTableReferences._gameIdTable(db).id,
                  ) as T;
                }
                if (baseMoveId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseMoveId,
                    referencedTable:
                        $$GameMovesTableReferences._baseMoveIdTable(db),
                    referencedColumn:
                        $$GameMovesTableReferences._baseMoveIdTable(db).id,
                  ) as T;
                }
                if (parentMoveId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentMoveId,
                    referencedTable:
                        $$GameMovesTableReferences._parentMoveIdTable(db),
                    referencedColumn:
                        $$GameMovesTableReferences._parentMoveIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GameMovesTableProcessedTableManager = ProcessedTableManager<
    _$RoseDatabase,
    $GameMovesTable,
    GameMove,
    $$GameMovesTableFilterComposer,
    $$GameMovesTableOrderingComposer,
    $$GameMovesTableAnnotationComposer,
    $$GameMovesTableCreateCompanionBuilder,
    $$GameMovesTableUpdateCompanionBuilder,
    (GameMove, $$GameMovesTableReferences),
    GameMove,
    PrefetchHooks Function({bool gameId, bool baseMoveId, bool parentMoveId})>;

class $RoseDatabaseManager {
  final _$RoseDatabase _db;
  $RoseDatabaseManager(this._db);
  $$ConfigTableTableManager get config =>
      $$ConfigTableTableManager(_db, _db.config);
  $$BaseMovesTableTableManager get baseMoves =>
      $$BaseMovesTableTableManager(_db, _db.baseMoves);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$GameMovesTableTableManager get gameMoves =>
      $$GameMovesTableTableManager(_db, _db.gameMoves);
}
