// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
mixin _$CyclocksDaoMixin on DatabaseAccessor<AppDatabase> {
  $CyclocksTable get cyclocks => attachedDatabase.cyclocks;
}
mixin _$CyclesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CyclocksTable get cyclocks => attachedDatabase.cyclocks;
  $CyclesTable get cycles => attachedDatabase.cycles;
}
mixin _$TimerStagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CyclocksTable get cyclocks => attachedDatabase.cyclocks;
  $CyclesTable get cycles => attachedDatabase.cycles;
  $TimerStagesTable get timerStages => attachedDatabase.timerStages;
}

class $CyclocksTable extends Cyclocks with TableInfo<$CyclocksTable, Cyclock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorPaletteMeta = const VerificationMeta(
    'colorPalette',
  );
  @override
  late final GeneratedColumn<String> colorPalette = GeneratedColumn<String>(
    'color_palette',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatIndefinitelyMeta =
      const VerificationMeta('repeatIndefinitely');
  @override
  late final GeneratedColumn<bool> repeatIndefinitely = GeneratedColumn<bool>(
    'repeat_indefinitely',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repeat_indefinitely" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasFuseMeta = const VerificationMeta(
    'hasFuse',
  );
  @override
  late final GeneratedColumn<bool> hasFuse = GeneratedColumn<bool>(
    'has_fuse',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_fuse" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fuseDurationMeta = const VerificationMeta(
    'fuseDuration',
  );
  @override
  late final GeneratedColumn<int> fuseDuration = GeneratedColumn<int>(
    'fuse_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _fuseSoundMeta = const VerificationMeta(
    'fuseSound',
  );
  @override
  late final GeneratedColumn<String> fuseSound = GeneratedColumn<String>(
    'fuse_sound',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fuseburn.wav'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorPalette,
    repeatIndefinitely,
    hasFuse,
    fuseDuration,
    fuseSound,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cyclocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cyclock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_palette')) {
      context.handle(
        _colorPaletteMeta,
        colorPalette.isAcceptableOrUnknown(
          data['color_palette']!,
          _colorPaletteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_colorPaletteMeta);
    }
    if (data.containsKey('repeat_indefinitely')) {
      context.handle(
        _repeatIndefinitelyMeta,
        repeatIndefinitely.isAcceptableOrUnknown(
          data['repeat_indefinitely']!,
          _repeatIndefinitelyMeta,
        ),
      );
    }
    if (data.containsKey('has_fuse')) {
      context.handle(
        _hasFuseMeta,
        hasFuse.isAcceptableOrUnknown(data['has_fuse']!, _hasFuseMeta),
      );
    }
    if (data.containsKey('fuse_duration')) {
      context.handle(
        _fuseDurationMeta,
        fuseDuration.isAcceptableOrUnknown(
          data['fuse_duration']!,
          _fuseDurationMeta,
        ),
      );
    }
    if (data.containsKey('fuse_sound')) {
      context.handle(
        _fuseSoundMeta,
        fuseSound.isAcceptableOrUnknown(data['fuse_sound']!, _fuseSoundMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cyclock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cyclock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorPalette: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_palette'],
      )!,
      repeatIndefinitely: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repeat_indefinitely'],
      )!,
      hasFuse: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_fuse'],
      )!,
      fuseDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fuse_duration'],
      )!,
      fuseSound: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuse_sound'],
      )!,
    );
  }

  @override
  $CyclocksTable createAlias(String alias) {
    return $CyclocksTable(attachedDatabase, alias);
  }
}

class Cyclock extends DataClass implements Insertable<Cyclock> {
  final int id;
  final String name;
  final String colorPalette;
  final bool repeatIndefinitely;
  final bool hasFuse;
  final int fuseDuration;
  final String fuseSound;
  const Cyclock({
    required this.id,
    required this.name,
    required this.colorPalette,
    required this.repeatIndefinitely,
    required this.hasFuse,
    required this.fuseDuration,
    required this.fuseSound,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_palette'] = Variable<String>(colorPalette);
    map['repeat_indefinitely'] = Variable<bool>(repeatIndefinitely);
    map['has_fuse'] = Variable<bool>(hasFuse);
    map['fuse_duration'] = Variable<int>(fuseDuration);
    map['fuse_sound'] = Variable<String>(fuseSound);
    return map;
  }

  CyclocksCompanion toCompanion(bool nullToAbsent) {
    return CyclocksCompanion(
      id: Value(id),
      name: Value(name),
      colorPalette: Value(colorPalette),
      repeatIndefinitely: Value(repeatIndefinitely),
      hasFuse: Value(hasFuse),
      fuseDuration: Value(fuseDuration),
      fuseSound: Value(fuseSound),
    );
  }

  factory Cyclock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cyclock(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorPalette: serializer.fromJson<String>(json['colorPalette']),
      repeatIndefinitely: serializer.fromJson<bool>(json['repeatIndefinitely']),
      hasFuse: serializer.fromJson<bool>(json['hasFuse']),
      fuseDuration: serializer.fromJson<int>(json['fuseDuration']),
      fuseSound: serializer.fromJson<String>(json['fuseSound']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorPalette': serializer.toJson<String>(colorPalette),
      'repeatIndefinitely': serializer.toJson<bool>(repeatIndefinitely),
      'hasFuse': serializer.toJson<bool>(hasFuse),
      'fuseDuration': serializer.toJson<int>(fuseDuration),
      'fuseSound': serializer.toJson<String>(fuseSound),
    };
  }

  Cyclock copyWith({
    int? id,
    String? name,
    String? colorPalette,
    bool? repeatIndefinitely,
    bool? hasFuse,
    int? fuseDuration,
    String? fuseSound,
  }) => Cyclock(
    id: id ?? this.id,
    name: name ?? this.name,
    colorPalette: colorPalette ?? this.colorPalette,
    repeatIndefinitely: repeatIndefinitely ?? this.repeatIndefinitely,
    hasFuse: hasFuse ?? this.hasFuse,
    fuseDuration: fuseDuration ?? this.fuseDuration,
    fuseSound: fuseSound ?? this.fuseSound,
  );
  Cyclock copyWithCompanion(CyclocksCompanion data) {
    return Cyclock(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorPalette: data.colorPalette.present
          ? data.colorPalette.value
          : this.colorPalette,
      repeatIndefinitely: data.repeatIndefinitely.present
          ? data.repeatIndefinitely.value
          : this.repeatIndefinitely,
      hasFuse: data.hasFuse.present ? data.hasFuse.value : this.hasFuse,
      fuseDuration: data.fuseDuration.present
          ? data.fuseDuration.value
          : this.fuseDuration,
      fuseSound: data.fuseSound.present ? data.fuseSound.value : this.fuseSound,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cyclock(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorPalette: $colorPalette, ')
          ..write('repeatIndefinitely: $repeatIndefinitely, ')
          ..write('hasFuse: $hasFuse, ')
          ..write('fuseDuration: $fuseDuration, ')
          ..write('fuseSound: $fuseSound')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    colorPalette,
    repeatIndefinitely,
    hasFuse,
    fuseDuration,
    fuseSound,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cyclock &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorPalette == this.colorPalette &&
          other.repeatIndefinitely == this.repeatIndefinitely &&
          other.hasFuse == this.hasFuse &&
          other.fuseDuration == this.fuseDuration &&
          other.fuseSound == this.fuseSound);
}

class CyclocksCompanion extends UpdateCompanion<Cyclock> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> colorPalette;
  final Value<bool> repeatIndefinitely;
  final Value<bool> hasFuse;
  final Value<int> fuseDuration;
  final Value<String> fuseSound;
  const CyclocksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorPalette = const Value.absent(),
    this.repeatIndefinitely = const Value.absent(),
    this.hasFuse = const Value.absent(),
    this.fuseDuration = const Value.absent(),
    this.fuseSound = const Value.absent(),
  });
  CyclocksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String colorPalette,
    this.repeatIndefinitely = const Value.absent(),
    this.hasFuse = const Value.absent(),
    this.fuseDuration = const Value.absent(),
    this.fuseSound = const Value.absent(),
  }) : name = Value(name),
       colorPalette = Value(colorPalette);
  static Insertable<Cyclock> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorPalette,
    Expression<bool>? repeatIndefinitely,
    Expression<bool>? hasFuse,
    Expression<int>? fuseDuration,
    Expression<String>? fuseSound,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorPalette != null) 'color_palette': colorPalette,
      if (repeatIndefinitely != null) 'repeat_indefinitely': repeatIndefinitely,
      if (hasFuse != null) 'has_fuse': hasFuse,
      if (fuseDuration != null) 'fuse_duration': fuseDuration,
      if (fuseSound != null) 'fuse_sound': fuseSound,
    });
  }

  CyclocksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? colorPalette,
    Value<bool>? repeatIndefinitely,
    Value<bool>? hasFuse,
    Value<int>? fuseDuration,
    Value<String>? fuseSound,
  }) {
    return CyclocksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorPalette: colorPalette ?? this.colorPalette,
      repeatIndefinitely: repeatIndefinitely ?? this.repeatIndefinitely,
      hasFuse: hasFuse ?? this.hasFuse,
      fuseDuration: fuseDuration ?? this.fuseDuration,
      fuseSound: fuseSound ?? this.fuseSound,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorPalette.present) {
      map['color_palette'] = Variable<String>(colorPalette.value);
    }
    if (repeatIndefinitely.present) {
      map['repeat_indefinitely'] = Variable<bool>(repeatIndefinitely.value);
    }
    if (hasFuse.present) {
      map['has_fuse'] = Variable<bool>(hasFuse.value);
    }
    if (fuseDuration.present) {
      map['fuse_duration'] = Variable<int>(fuseDuration.value);
    }
    if (fuseSound.present) {
      map['fuse_sound'] = Variable<String>(fuseSound.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclocksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorPalette: $colorPalette, ')
          ..write('repeatIndefinitely: $repeatIndefinitely, ')
          ..write('hasFuse: $hasFuse, ')
          ..write('fuseDuration: $fuseDuration, ')
          ..write('fuseSound: $fuseSound')
          ..write(')'))
        .toString();
  }
}

class $CyclesTable extends Cycles with TableInfo<$CyclesTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cyclockIdMeta = const VerificationMeta(
    'cyclockId',
  );
  @override
  late final GeneratedColumn<int> cyclockId = GeneratedColumn<int>(
    'cyclock_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cyclocks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Cycle'),
  );
  static const VerificationMeta _repeatCountMeta = const VerificationMeta(
    'repeatCount',
  );
  @override
  late final GeneratedColumn<int> repeatCount = GeneratedColumn<int>(
    'repeat_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _backgroundColorMeta = const VerificationMeta(
    'backgroundColor',
  );
  @override
  late final GeneratedColumn<String> backgroundColor = GeneratedColumn<String>(
    'background_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('blue'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cyclockId,
    orderIndex,
    name,
    repeatCount,
    backgroundColor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cyclock_id')) {
      context.handle(
        _cyclockIdMeta,
        cyclockId.isAcceptableOrUnknown(data['cyclock_id']!, _cyclockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cyclockIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('repeat_count')) {
      context.handle(
        _repeatCountMeta,
        repeatCount.isAcceptableOrUnknown(
          data['repeat_count']!,
          _repeatCountMeta,
        ),
      );
    }
    if (data.containsKey('background_color')) {
      context.handle(
        _backgroundColorMeta,
        backgroundColor.isAcceptableOrUnknown(
          data['background_color']!,
          _backgroundColorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cyclockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cyclock_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      repeatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_count'],
      )!,
      backgroundColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_color'],
      )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final int id;
  final int cyclockId;
  final int orderIndex;
  final String name;
  final int repeatCount;
  final String backgroundColor;
  const Cycle({
    required this.id,
    required this.cyclockId,
    required this.orderIndex,
    required this.name,
    required this.repeatCount,
    required this.backgroundColor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cyclock_id'] = Variable<int>(cyclockId);
    map['order_index'] = Variable<int>(orderIndex);
    map['name'] = Variable<String>(name);
    map['repeat_count'] = Variable<int>(repeatCount);
    map['background_color'] = Variable<String>(backgroundColor);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      cyclockId: Value(cyclockId),
      orderIndex: Value(orderIndex),
      name: Value(name),
      repeatCount: Value(repeatCount),
      backgroundColor: Value(backgroundColor),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<int>(json['id']),
      cyclockId: serializer.fromJson<int>(json['cyclockId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      name: serializer.fromJson<String>(json['name']),
      repeatCount: serializer.fromJson<int>(json['repeatCount']),
      backgroundColor: serializer.fromJson<String>(json['backgroundColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cyclockId': serializer.toJson<int>(cyclockId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'name': serializer.toJson<String>(name),
      'repeatCount': serializer.toJson<int>(repeatCount),
      'backgroundColor': serializer.toJson<String>(backgroundColor),
    };
  }

  Cycle copyWith({
    int? id,
    int? cyclockId,
    int? orderIndex,
    String? name,
    int? repeatCount,
    String? backgroundColor,
  }) => Cycle(
    id: id ?? this.id,
    cyclockId: cyclockId ?? this.cyclockId,
    orderIndex: orderIndex ?? this.orderIndex,
    name: name ?? this.name,
    repeatCount: repeatCount ?? this.repeatCount,
    backgroundColor: backgroundColor ?? this.backgroundColor,
  );
  Cycle copyWithCompanion(CyclesCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      cyclockId: data.cyclockId.present ? data.cyclockId.value : this.cyclockId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      name: data.name.present ? data.name.value : this.name,
      repeatCount: data.repeatCount.present
          ? data.repeatCount.value
          : this.repeatCount,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('cyclockId: $cyclockId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('repeatCount: $repeatCount, ')
          ..write('backgroundColor: $backgroundColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cyclockId,
    orderIndex,
    name,
    repeatCount,
    backgroundColor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.cyclockId == this.cyclockId &&
          other.orderIndex == this.orderIndex &&
          other.name == this.name &&
          other.repeatCount == this.repeatCount &&
          other.backgroundColor == this.backgroundColor);
}

class CyclesCompanion extends UpdateCompanion<Cycle> {
  final Value<int> id;
  final Value<int> cyclockId;
  final Value<int> orderIndex;
  final Value<String> name;
  final Value<int> repeatCount;
  final Value<String> backgroundColor;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.cyclockId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.repeatCount = const Value.absent(),
    this.backgroundColor = const Value.absent(),
  });
  CyclesCompanion.insert({
    this.id = const Value.absent(),
    required int cyclockId,
    required int orderIndex,
    this.name = const Value.absent(),
    this.repeatCount = const Value.absent(),
    this.backgroundColor = const Value.absent(),
  }) : cyclockId = Value(cyclockId),
       orderIndex = Value(orderIndex);
  static Insertable<Cycle> custom({
    Expression<int>? id,
    Expression<int>? cyclockId,
    Expression<int>? orderIndex,
    Expression<String>? name,
    Expression<int>? repeatCount,
    Expression<String>? backgroundColor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cyclockId != null) 'cyclock_id': cyclockId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (name != null) 'name': name,
      if (repeatCount != null) 'repeat_count': repeatCount,
      if (backgroundColor != null) 'background_color': backgroundColor,
    });
  }

  CyclesCompanion copyWith({
    Value<int>? id,
    Value<int>? cyclockId,
    Value<int>? orderIndex,
    Value<String>? name,
    Value<int>? repeatCount,
    Value<String>? backgroundColor,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      cyclockId: cyclockId ?? this.cyclockId,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      repeatCount: repeatCount ?? this.repeatCount,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cyclockId.present) {
      map['cyclock_id'] = Variable<int>(cyclockId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (repeatCount.present) {
      map['repeat_count'] = Variable<int>(repeatCount.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<String>(backgroundColor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('cyclockId: $cyclockId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('repeatCount: $repeatCount, ')
          ..write('backgroundColor: $backgroundColor')
          ..write(')'))
        .toString();
  }
}

class $TimerStagesTable extends TimerStages
    with TableInfo<$TimerStagesTable, TimerStage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimerStagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soundMeta = const VerificationMeta('sound');
  @override
  late final GeneratedColumn<String> sound = GeneratedColumn<String>(
    'sound',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    orderIndex,
    name,
    durationSeconds,
    color,
    sound,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timer_stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimerStage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('sound')) {
      context.handle(
        _soundMeta,
        sound.isAcceptableOrUnknown(data['sound']!, _soundMeta),
      );
    } else if (isInserting) {
      context.missing(_soundMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimerStage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimerStage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      sound: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sound'],
      )!,
    );
  }

  @override
  $TimerStagesTable createAlias(String alias) {
    return $TimerStagesTable(attachedDatabase, alias);
  }
}

class TimerStage extends DataClass implements Insertable<TimerStage> {
  final int id;
  final int cycleId;
  final int orderIndex;
  final String name;
  final int durationSeconds;
  final String color;
  final String sound;
  const TimerStage({
    required this.id,
    required this.cycleId,
    required this.orderIndex,
    required this.name,
    required this.durationSeconds,
    required this.color,
    required this.sound,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cycle_id'] = Variable<int>(cycleId);
    map['order_index'] = Variable<int>(orderIndex);
    map['name'] = Variable<String>(name);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['color'] = Variable<String>(color);
    map['sound'] = Variable<String>(sound);
    return map;
  }

  TimerStagesCompanion toCompanion(bool nullToAbsent) {
    return TimerStagesCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      orderIndex: Value(orderIndex),
      name: Value(name),
      durationSeconds: Value(durationSeconds),
      color: Value(color),
      sound: Value(sound),
    );
  }

  factory TimerStage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimerStage(
      id: serializer.fromJson<int>(json['id']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      name: serializer.fromJson<String>(json['name']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      color: serializer.fromJson<String>(json['color']),
      sound: serializer.fromJson<String>(json['sound']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cycleId': serializer.toJson<int>(cycleId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'name': serializer.toJson<String>(name),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'color': serializer.toJson<String>(color),
      'sound': serializer.toJson<String>(sound),
    };
  }

  TimerStage copyWith({
    int? id,
    int? cycleId,
    int? orderIndex,
    String? name,
    int? durationSeconds,
    String? color,
    String? sound,
  }) => TimerStage(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    orderIndex: orderIndex ?? this.orderIndex,
    name: name ?? this.name,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    color: color ?? this.color,
    sound: sound ?? this.sound,
  );
  TimerStage copyWithCompanion(TimerStagesCompanion data) {
    return TimerStage(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      name: data.name.present ? data.name.value : this.name,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      color: data.color.present ? data.color.value : this.color,
      sound: data.sound.present ? data.sound.value : this.sound,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimerStage(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('color: $color, ')
          ..write('sound: $sound')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, orderIndex, name, durationSeconds, color, sound);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimerStage &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.orderIndex == this.orderIndex &&
          other.name == this.name &&
          other.durationSeconds == this.durationSeconds &&
          other.color == this.color &&
          other.sound == this.sound);
}

class TimerStagesCompanion extends UpdateCompanion<TimerStage> {
  final Value<int> id;
  final Value<int> cycleId;
  final Value<int> orderIndex;
  final Value<String> name;
  final Value<int> durationSeconds;
  final Value<String> color;
  final Value<String> sound;
  const TimerStagesCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.color = const Value.absent(),
    this.sound = const Value.absent(),
  });
  TimerStagesCompanion.insert({
    this.id = const Value.absent(),
    required int cycleId,
    required int orderIndex,
    required String name,
    required int durationSeconds,
    required String color,
    required String sound,
  }) : cycleId = Value(cycleId),
       orderIndex = Value(orderIndex),
       name = Value(name),
       durationSeconds = Value(durationSeconds),
       color = Value(color),
       sound = Value(sound);
  static Insertable<TimerStage> custom({
    Expression<int>? id,
    Expression<int>? cycleId,
    Expression<int>? orderIndex,
    Expression<String>? name,
    Expression<int>? durationSeconds,
    Expression<String>? color,
    Expression<String>? sound,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (name != null) 'name': name,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (color != null) 'color': color,
      if (sound != null) 'sound': sound,
    });
  }

  TimerStagesCompanion copyWith({
    Value<int>? id,
    Value<int>? cycleId,
    Value<int>? orderIndex,
    Value<String>? name,
    Value<int>? durationSeconds,
    Value<String>? color,
    Value<String>? sound,
  }) {
    return TimerStagesCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      color: color ?? this.color,
      sound: sound ?? this.sound,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sound.present) {
      map['sound'] = Variable<String>(sound.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimerStagesCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('color: $color, ')
          ..write('sound: $sound')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CyclocksTable cyclocks = $CyclocksTable(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $TimerStagesTable timerStages = $TimerStagesTable(this);
  late final CyclocksDao cyclocksDao = CyclocksDao(this as AppDatabase);
  late final TimerStagesDao timerStagesDao = TimerStagesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cyclocks,
    cycles,
    timerStages,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cyclocks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cycles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cycles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('timer_stages', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CyclocksTableCreateCompanionBuilder =
    CyclocksCompanion Function({
      Value<int> id,
      required String name,
      required String colorPalette,
      Value<bool> repeatIndefinitely,
      Value<bool> hasFuse,
      Value<int> fuseDuration,
      Value<String> fuseSound,
    });
typedef $$CyclocksTableUpdateCompanionBuilder =
    CyclocksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> colorPalette,
      Value<bool> repeatIndefinitely,
      Value<bool> hasFuse,
      Value<int> fuseDuration,
      Value<String> fuseSound,
    });

final class $$CyclocksTableReferences
    extends BaseReferences<_$AppDatabase, $CyclocksTable, Cyclock> {
  $$CyclocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CyclesTable, List<Cycle>> _cyclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cycles,
    aliasName: $_aliasNameGenerator(db.cyclocks.id, db.cycles.cyclockId),
  );

  $$CyclesTableProcessedTableManager get cyclesRefs {
    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.cyclockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cyclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CyclocksTableFilterComposer
    extends Composer<_$AppDatabase, $CyclocksTable> {
  $$CyclocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorPalette => $composableBuilder(
    column: $table.colorPalette,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repeatIndefinitely => $composableBuilder(
    column: $table.repeatIndefinitely,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasFuse => $composableBuilder(
    column: $table.hasFuse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fuseDuration => $composableBuilder(
    column: $table.fuseDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuseSound => $composableBuilder(
    column: $table.fuseSound,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cyclesRefs(
    Expression<bool> Function($$CyclesTableFilterComposer f) f,
  ) {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.cyclockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclocksTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclocksTable> {
  $$CyclocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorPalette => $composableBuilder(
    column: $table.colorPalette,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repeatIndefinitely => $composableBuilder(
    column: $table.repeatIndefinitely,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasFuse => $composableBuilder(
    column: $table.hasFuse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fuseDuration => $composableBuilder(
    column: $table.fuseDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuseSound => $composableBuilder(
    column: $table.fuseSound,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CyclocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclocksTable> {
  $$CyclocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorPalette => $composableBuilder(
    column: $table.colorPalette,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get repeatIndefinitely => $composableBuilder(
    column: $table.repeatIndefinitely,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasFuse =>
      $composableBuilder(column: $table.hasFuse, builder: (column) => column);

  GeneratedColumn<int> get fuseDuration => $composableBuilder(
    column: $table.fuseDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuseSound =>
      $composableBuilder(column: $table.fuseSound, builder: (column) => column);

  Expression<T> cyclesRefs<T extends Object>(
    Expression<T> Function($$CyclesTableAnnotationComposer a) f,
  ) {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.cyclockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclocksTable,
          Cyclock,
          $$CyclocksTableFilterComposer,
          $$CyclocksTableOrderingComposer,
          $$CyclocksTableAnnotationComposer,
          $$CyclocksTableCreateCompanionBuilder,
          $$CyclocksTableUpdateCompanionBuilder,
          (Cyclock, $$CyclocksTableReferences),
          Cyclock,
          PrefetchHooks Function({bool cyclesRefs})
        > {
  $$CyclocksTableTableManager(_$AppDatabase db, $CyclocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorPalette = const Value.absent(),
                Value<bool> repeatIndefinitely = const Value.absent(),
                Value<bool> hasFuse = const Value.absent(),
                Value<int> fuseDuration = const Value.absent(),
                Value<String> fuseSound = const Value.absent(),
              }) => CyclocksCompanion(
                id: id,
                name: name,
                colorPalette: colorPalette,
                repeatIndefinitely: repeatIndefinitely,
                hasFuse: hasFuse,
                fuseDuration: fuseDuration,
                fuseSound: fuseSound,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String colorPalette,
                Value<bool> repeatIndefinitely = const Value.absent(),
                Value<bool> hasFuse = const Value.absent(),
                Value<int> fuseDuration = const Value.absent(),
                Value<String> fuseSound = const Value.absent(),
              }) => CyclocksCompanion.insert(
                id: id,
                name: name,
                colorPalette: colorPalette,
                repeatIndefinitely: repeatIndefinitely,
                hasFuse: hasFuse,
                fuseDuration: fuseDuration,
                fuseSound: fuseSound,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CyclocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cyclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cyclesRefs) db.cycles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cyclesRefs)
                    await $_getPrefetchedData<Cyclock, $CyclocksTable, Cycle>(
                      currentTable: table,
                      referencedTable: $$CyclocksTableReferences
                          ._cyclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CyclocksTableReferences(db, table, p0).cyclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cyclockId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CyclocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclocksTable,
      Cyclock,
      $$CyclocksTableFilterComposer,
      $$CyclocksTableOrderingComposer,
      $$CyclocksTableAnnotationComposer,
      $$CyclocksTableCreateCompanionBuilder,
      $$CyclocksTableUpdateCompanionBuilder,
      (Cyclock, $$CyclocksTableReferences),
      Cyclock,
      PrefetchHooks Function({bool cyclesRefs})
    >;
typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      Value<int> id,
      required int cyclockId,
      required int orderIndex,
      Value<String> name,
      Value<int> repeatCount,
      Value<String> backgroundColor,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<int> id,
      Value<int> cyclockId,
      Value<int> orderIndex,
      Value<String> name,
      Value<int> repeatCount,
      Value<String> backgroundColor,
    });

final class $$CyclesTableReferences
    extends BaseReferences<_$AppDatabase, $CyclesTable, Cycle> {
  $$CyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclocksTable _cyclockIdTable(_$AppDatabase db) => db.cyclocks
      .createAlias($_aliasNameGenerator(db.cycles.cyclockId, db.cyclocks.id));

  $$CyclocksTableProcessedTableManager get cyclockId {
    final $_column = $_itemColumn<int>('cyclock_id')!;

    final manager = $$CyclocksTableTableManager(
      $_db,
      $_db.cyclocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cyclockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TimerStagesTable, List<TimerStage>>
  _timerStagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timerStages,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.timerStages.cycleId),
  );

  $$TimerStagesTableProcessedTableManager get timerStagesRefs {
    final manager = $$TimerStagesTableTableManager(
      $_db,
      $_db.timerStages,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timerStagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CyclesTableFilterComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclocksTableFilterComposer get cyclockId {
    final $$CyclocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cyclockId,
      referencedTable: $db.cyclocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclocksTableFilterComposer(
            $db: $db,
            $table: $db.cyclocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> timerStagesRefs(
    Expression<bool> Function($$TimerStagesTableFilterComposer f) f,
  ) {
    final $$TimerStagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timerStages,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimerStagesTableFilterComposer(
            $db: $db,
            $table: $db.timerStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclocksTableOrderingComposer get cyclockId {
    final $$CyclocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cyclockId,
      referencedTable: $db.cyclocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclocksTableOrderingComposer(
            $db: $db,
            $table: $db.cyclocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => column,
  );

  $$CyclocksTableAnnotationComposer get cyclockId {
    final $$CyclocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cyclockId,
      referencedTable: $db.cyclocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclocksTableAnnotationComposer(
            $db: $db,
            $table: $db.cyclocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> timerStagesRefs<T extends Object>(
    Expression<T> Function($$TimerStagesTableAnnotationComposer a) f,
  ) {
    final $$TimerStagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timerStages,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimerStagesTableAnnotationComposer(
            $db: $db,
            $table: $db.timerStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclesTable,
          Cycle,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (Cycle, $$CyclesTableReferences),
          Cycle,
          PrefetchHooks Function({bool cyclockId, bool timerStagesRefs})
        > {
  $$CyclesTableTableManager(_$AppDatabase db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cyclockId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
                Value<String> backgroundColor = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                cyclockId: cyclockId,
                orderIndex: orderIndex,
                name: name,
                repeatCount: repeatCount,
                backgroundColor: backgroundColor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cyclockId,
                required int orderIndex,
                Value<String> name = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
                Value<String> backgroundColor = const Value.absent(),
              }) => CyclesCompanion.insert(
                id: id,
                cyclockId: cyclockId,
                orderIndex: orderIndex,
                name: name,
                repeatCount: repeatCount,
                backgroundColor: backgroundColor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CyclesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({cyclockId = false, timerStagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timerStagesRefs) db.timerStages,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (cyclockId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cyclockId,
                                    referencedTable: $$CyclesTableReferences
                                        ._cyclockIdTable(db),
                                    referencedColumn: $$CyclesTableReferences
                                        ._cyclockIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timerStagesRefs)
                        await $_getPrefetchedData<
                          Cycle,
                          $CyclesTable,
                          TimerStage
                        >(
                          currentTable: table,
                          referencedTable: $$CyclesTableReferences
                              ._timerStagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CyclesTableReferences(
                                db,
                                table,
                                p0,
                              ).timerStagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclesTable,
      Cycle,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (Cycle, $$CyclesTableReferences),
      Cycle,
      PrefetchHooks Function({bool cyclockId, bool timerStagesRefs})
    >;
typedef $$TimerStagesTableCreateCompanionBuilder =
    TimerStagesCompanion Function({
      Value<int> id,
      required int cycleId,
      required int orderIndex,
      required String name,
      required int durationSeconds,
      required String color,
      required String sound,
    });
typedef $$TimerStagesTableUpdateCompanionBuilder =
    TimerStagesCompanion Function({
      Value<int> id,
      Value<int> cycleId,
      Value<int> orderIndex,
      Value<String> name,
      Value<int> durationSeconds,
      Value<String> color,
      Value<String> sound,
    });

final class $$TimerStagesTableReferences
    extends BaseReferences<_$AppDatabase, $TimerStagesTable, TimerStage> {
  $$TimerStagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclesTable _cycleIdTable(_$AppDatabase db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.timerStages.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<int>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimerStagesTableFilterComposer
    extends Composer<_$AppDatabase, $TimerStagesTable> {
  $$TimerStagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimerStagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimerStagesTable> {
  $$TimerStagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimerStagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimerStagesTable> {
  $$TimerStagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimerStagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimerStagesTable,
          TimerStage,
          $$TimerStagesTableFilterComposer,
          $$TimerStagesTableOrderingComposer,
          $$TimerStagesTableAnnotationComposer,
          $$TimerStagesTableCreateCompanionBuilder,
          $$TimerStagesTableUpdateCompanionBuilder,
          (TimerStage, $$TimerStagesTableReferences),
          TimerStage,
          PrefetchHooks Function({bool cycleId})
        > {
  $$TimerStagesTableTableManager(_$AppDatabase db, $TimerStagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimerStagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimerStagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimerStagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> sound = const Value.absent(),
              }) => TimerStagesCompanion(
                id: id,
                cycleId: cycleId,
                orderIndex: orderIndex,
                name: name,
                durationSeconds: durationSeconds,
                color: color,
                sound: sound,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cycleId,
                required int orderIndex,
                required String name,
                required int durationSeconds,
                required String color,
                required String sound,
              }) => TimerStagesCompanion.insert(
                id: id,
                cycleId: cycleId,
                orderIndex: orderIndex,
                name: name,
                durationSeconds: durationSeconds,
                color: color,
                sound: sound,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimerStagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (cycleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleId,
                                referencedTable: $$TimerStagesTableReferences
                                    ._cycleIdTable(db),
                                referencedColumn: $$TimerStagesTableReferences
                                    ._cycleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimerStagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimerStagesTable,
      TimerStage,
      $$TimerStagesTableFilterComposer,
      $$TimerStagesTableOrderingComposer,
      $$TimerStagesTableAnnotationComposer,
      $$TimerStagesTableCreateCompanionBuilder,
      $$TimerStagesTableUpdateCompanionBuilder,
      (TimerStage, $$TimerStagesTableReferences),
      TimerStage,
      PrefetchHooks Function({bool cycleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CyclocksTableTableManager get cyclocks =>
      $$CyclocksTableTableManager(_db, _db.cyclocks);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$TimerStagesTableTableManager get timerStages =>
      $$TimerStagesTableTableManager(_db, _db.timerStages);
}
