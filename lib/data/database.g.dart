// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isDefault,
    repeatCount,
    repeatIndefinitely,
    colorPalette,
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
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
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
    if (data.containsKey('repeat_indefinitely')) {
      context.handle(
        _repeatIndefinitelyMeta,
        repeatIndefinitely.isAcceptableOrUnknown(
          data['repeat_indefinitely']!,
          _repeatIndefinitelyMeta,
        ),
      );
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
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      repeatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_count'],
      )!,
      repeatIndefinitely: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repeat_indefinitely'],
      )!,
      colorPalette: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_palette'],
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
  final bool isDefault;
  final int repeatCount;
  final bool repeatIndefinitely;
  final String colorPalette;
  const Cyclock({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.repeatCount,
    required this.repeatIndefinitely,
    required this.colorPalette,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_default'] = Variable<bool>(isDefault);
    map['repeat_count'] = Variable<int>(repeatCount);
    map['repeat_indefinitely'] = Variable<bool>(repeatIndefinitely);
    map['color_palette'] = Variable<String>(colorPalette);
    return map;
  }

  CyclocksCompanion toCompanion(bool nullToAbsent) {
    return CyclocksCompanion(
      id: Value(id),
      name: Value(name),
      isDefault: Value(isDefault),
      repeatCount: Value(repeatCount),
      repeatIndefinitely: Value(repeatIndefinitely),
      colorPalette: Value(colorPalette),
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
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      repeatCount: serializer.fromJson<int>(json['repeatCount']),
      repeatIndefinitely: serializer.fromJson<bool>(json['repeatIndefinitely']),
      colorPalette: serializer.fromJson<String>(json['colorPalette']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
      'repeatCount': serializer.toJson<int>(repeatCount),
      'repeatIndefinitely': serializer.toJson<bool>(repeatIndefinitely),
      'colorPalette': serializer.toJson<String>(colorPalette),
    };
  }

  Cyclock copyWith({
    int? id,
    String? name,
    bool? isDefault,
    int? repeatCount,
    bool? repeatIndefinitely,
    String? colorPalette,
  }) => Cyclock(
    id: id ?? this.id,
    name: name ?? this.name,
    isDefault: isDefault ?? this.isDefault,
    repeatCount: repeatCount ?? this.repeatCount,
    repeatIndefinitely: repeatIndefinitely ?? this.repeatIndefinitely,
    colorPalette: colorPalette ?? this.colorPalette,
  );
  Cyclock copyWithCompanion(CyclocksCompanion data) {
    return Cyclock(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      repeatCount: data.repeatCount.present
          ? data.repeatCount.value
          : this.repeatCount,
      repeatIndefinitely: data.repeatIndefinitely.present
          ? data.repeatIndefinitely.value
          : this.repeatIndefinitely,
      colorPalette: data.colorPalette.present
          ? data.colorPalette.value
          : this.colorPalette,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cyclock(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('repeatCount: $repeatCount, ')
          ..write('repeatIndefinitely: $repeatIndefinitely, ')
          ..write('colorPalette: $colorPalette')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    isDefault,
    repeatCount,
    repeatIndefinitely,
    colorPalette,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cyclock &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDefault == this.isDefault &&
          other.repeatCount == this.repeatCount &&
          other.repeatIndefinitely == this.repeatIndefinitely &&
          other.colorPalette == this.colorPalette);
}

class CyclocksCompanion extends UpdateCompanion<Cyclock> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDefault;
  final Value<int> repeatCount;
  final Value<bool> repeatIndefinitely;
  final Value<String> colorPalette;
  const CyclocksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.repeatCount = const Value.absent(),
    this.repeatIndefinitely = const Value.absent(),
    this.colorPalette = const Value.absent(),
  });
  CyclocksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDefault = const Value.absent(),
    this.repeatCount = const Value.absent(),
    this.repeatIndefinitely = const Value.absent(),
    required String colorPalette,
  }) : name = Value(name),
       colorPalette = Value(colorPalette);
  static Insertable<Cyclock> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDefault,
    Expression<int>? repeatCount,
    Expression<bool>? repeatIndefinitely,
    Expression<String>? colorPalette,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
      if (repeatCount != null) 'repeat_count': repeatCount,
      if (repeatIndefinitely != null) 'repeat_indefinitely': repeatIndefinitely,
      if (colorPalette != null) 'color_palette': colorPalette,
    });
  }

  CyclocksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDefault,
    Value<int>? repeatCount,
    Value<bool>? repeatIndefinitely,
    Value<String>? colorPalette,
  }) {
    return CyclocksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      repeatCount: repeatCount ?? this.repeatCount,
      repeatIndefinitely: repeatIndefinitely ?? this.repeatIndefinitely,
      colorPalette: colorPalette ?? this.colorPalette,
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
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (repeatCount.present) {
      map['repeat_count'] = Variable<int>(repeatCount.value);
    }
    if (repeatIndefinitely.present) {
      map['repeat_indefinitely'] = Variable<bool>(repeatIndefinitely.value);
    }
    if (colorPalette.present) {
      map['color_palette'] = Variable<String>(colorPalette.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclocksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('repeatCount: $repeatCount, ')
          ..write('repeatIndefinitely: $repeatIndefinitely, ')
          ..write('colorPalette: $colorPalette')
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
      'REFERENCES cyclocks (id)',
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
  static const VerificationMeta _isFuseMeta = const VerificationMeta('isFuse');
  @override
  late final GeneratedColumn<bool> isFuse = GeneratedColumn<bool>(
    'is_fuse',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_fuse" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cyclockId,
    orderIndex,
    name,
    durationSeconds,
    color,
    sound,
    isFuse,
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
    if (data.containsKey('is_fuse')) {
      context.handle(
        _isFuseMeta,
        isFuse.isAcceptableOrUnknown(data['is_fuse']!, _isFuseMeta),
      );
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
      isFuse: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_fuse'],
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
  final int cyclockId;
  final int orderIndex;
  final String name;
  final int durationSeconds;
  final String color;
  final String sound;
  final bool isFuse;
  const TimerStage({
    required this.id,
    required this.cyclockId,
    required this.orderIndex,
    required this.name,
    required this.durationSeconds,
    required this.color,
    required this.sound,
    required this.isFuse,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cyclock_id'] = Variable<int>(cyclockId);
    map['order_index'] = Variable<int>(orderIndex);
    map['name'] = Variable<String>(name);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['color'] = Variable<String>(color);
    map['sound'] = Variable<String>(sound);
    map['is_fuse'] = Variable<bool>(isFuse);
    return map;
  }

  TimerStagesCompanion toCompanion(bool nullToAbsent) {
    return TimerStagesCompanion(
      id: Value(id),
      cyclockId: Value(cyclockId),
      orderIndex: Value(orderIndex),
      name: Value(name),
      durationSeconds: Value(durationSeconds),
      color: Value(color),
      sound: Value(sound),
      isFuse: Value(isFuse),
    );
  }

  factory TimerStage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimerStage(
      id: serializer.fromJson<int>(json['id']),
      cyclockId: serializer.fromJson<int>(json['cyclockId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      name: serializer.fromJson<String>(json['name']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      color: serializer.fromJson<String>(json['color']),
      sound: serializer.fromJson<String>(json['sound']),
      isFuse: serializer.fromJson<bool>(json['isFuse']),
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
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'color': serializer.toJson<String>(color),
      'sound': serializer.toJson<String>(sound),
      'isFuse': serializer.toJson<bool>(isFuse),
    };
  }

  TimerStage copyWith({
    int? id,
    int? cyclockId,
    int? orderIndex,
    String? name,
    int? durationSeconds,
    String? color,
    String? sound,
    bool? isFuse,
  }) => TimerStage(
    id: id ?? this.id,
    cyclockId: cyclockId ?? this.cyclockId,
    orderIndex: orderIndex ?? this.orderIndex,
    name: name ?? this.name,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    color: color ?? this.color,
    sound: sound ?? this.sound,
    isFuse: isFuse ?? this.isFuse,
  );
  TimerStage copyWithCompanion(TimerStagesCompanion data) {
    return TimerStage(
      id: data.id.present ? data.id.value : this.id,
      cyclockId: data.cyclockId.present ? data.cyclockId.value : this.cyclockId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      name: data.name.present ? data.name.value : this.name,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      color: data.color.present ? data.color.value : this.color,
      sound: data.sound.present ? data.sound.value : this.sound,
      isFuse: data.isFuse.present ? data.isFuse.value : this.isFuse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimerStage(')
          ..write('id: $id, ')
          ..write('cyclockId: $cyclockId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('color: $color, ')
          ..write('sound: $sound, ')
          ..write('isFuse: $isFuse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cyclockId,
    orderIndex,
    name,
    durationSeconds,
    color,
    sound,
    isFuse,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimerStage &&
          other.id == this.id &&
          other.cyclockId == this.cyclockId &&
          other.orderIndex == this.orderIndex &&
          other.name == this.name &&
          other.durationSeconds == this.durationSeconds &&
          other.color == this.color &&
          other.sound == this.sound &&
          other.isFuse == this.isFuse);
}

class TimerStagesCompanion extends UpdateCompanion<TimerStage> {
  final Value<int> id;
  final Value<int> cyclockId;
  final Value<int> orderIndex;
  final Value<String> name;
  final Value<int> durationSeconds;
  final Value<String> color;
  final Value<String> sound;
  final Value<bool> isFuse;
  const TimerStagesCompanion({
    this.id = const Value.absent(),
    this.cyclockId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.color = const Value.absent(),
    this.sound = const Value.absent(),
    this.isFuse = const Value.absent(),
  });
  TimerStagesCompanion.insert({
    this.id = const Value.absent(),
    required int cyclockId,
    required int orderIndex,
    required String name,
    required int durationSeconds,
    required String color,
    required String sound,
    this.isFuse = const Value.absent(),
  }) : cyclockId = Value(cyclockId),
       orderIndex = Value(orderIndex),
       name = Value(name),
       durationSeconds = Value(durationSeconds),
       color = Value(color),
       sound = Value(sound);
  static Insertable<TimerStage> custom({
    Expression<int>? id,
    Expression<int>? cyclockId,
    Expression<int>? orderIndex,
    Expression<String>? name,
    Expression<int>? durationSeconds,
    Expression<String>? color,
    Expression<String>? sound,
    Expression<bool>? isFuse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cyclockId != null) 'cyclock_id': cyclockId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (name != null) 'name': name,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (color != null) 'color': color,
      if (sound != null) 'sound': sound,
      if (isFuse != null) 'is_fuse': isFuse,
    });
  }

  TimerStagesCompanion copyWith({
    Value<int>? id,
    Value<int>? cyclockId,
    Value<int>? orderIndex,
    Value<String>? name,
    Value<int>? durationSeconds,
    Value<String>? color,
    Value<String>? sound,
    Value<bool>? isFuse,
  }) {
    return TimerStagesCompanion(
      id: id ?? this.id,
      cyclockId: cyclockId ?? this.cyclockId,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      color: color ?? this.color,
      sound: sound ?? this.sound,
      isFuse: isFuse ?? this.isFuse,
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
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sound.present) {
      map['sound'] = Variable<String>(sound.value);
    }
    if (isFuse.present) {
      map['is_fuse'] = Variable<bool>(isFuse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimerStagesCompanion(')
          ..write('id: $id, ')
          ..write('cyclockId: $cyclockId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('color: $color, ')
          ..write('sound: $sound, ')
          ..write('isFuse: $isFuse')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CyclocksTable cyclocks = $CyclocksTable(this);
  late final $TimerStagesTable timerStages = $TimerStagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cyclocks, timerStages];
}

typedef $$CyclocksTableCreateCompanionBuilder =
    CyclocksCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDefault,
      Value<int> repeatCount,
      Value<bool> repeatIndefinitely,
      required String colorPalette,
    });
typedef $$CyclocksTableUpdateCompanionBuilder =
    CyclocksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDefault,
      Value<int> repeatCount,
      Value<bool> repeatIndefinitely,
      Value<String> colorPalette,
    });

final class $$CyclocksTableReferences
    extends BaseReferences<_$AppDatabase, $CyclocksTable, Cyclock> {
  $$CyclocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimerStagesTable, List<TimerStage>>
  _timerStagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timerStages,
    aliasName: $_aliasNameGenerator(db.cyclocks.id, db.timerStages.cyclockId),
  );

  $$TimerStagesTableProcessedTableManager get timerStagesRefs {
    final manager = $$TimerStagesTableTableManager(
      $_db,
      $_db.timerStages,
    ).filter((f) => f.cyclockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timerStagesRefsTable($_db));
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

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repeatIndefinitely => $composableBuilder(
    column: $table.repeatIndefinitely,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorPalette => $composableBuilder(
    column: $table.colorPalette,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timerStagesRefs(
    Expression<bool> Function($$TimerStagesTableFilterComposer f) f,
  ) {
    final $$TimerStagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timerStages,
      getReferencedColumn: (t) => t.cyclockId,
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

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repeatIndefinitely => $composableBuilder(
    column: $table.repeatIndefinitely,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorPalette => $composableBuilder(
    column: $table.colorPalette,
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

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get repeatIndefinitely => $composableBuilder(
    column: $table.repeatIndefinitely,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorPalette => $composableBuilder(
    column: $table.colorPalette,
    builder: (column) => column,
  );

  Expression<T> timerStagesRefs<T extends Object>(
    Expression<T> Function($$TimerStagesTableAnnotationComposer a) f,
  ) {
    final $$TimerStagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timerStages,
      getReferencedColumn: (t) => t.cyclockId,
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
          PrefetchHooks Function({bool timerStagesRefs})
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
                Value<bool> isDefault = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
                Value<bool> repeatIndefinitely = const Value.absent(),
                Value<String> colorPalette = const Value.absent(),
              }) => CyclocksCompanion(
                id: id,
                name: name,
                isDefault: isDefault,
                repeatCount: repeatCount,
                repeatIndefinitely: repeatIndefinitely,
                colorPalette: colorPalette,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDefault = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
                Value<bool> repeatIndefinitely = const Value.absent(),
                required String colorPalette,
              }) => CyclocksCompanion.insert(
                id: id,
                name: name,
                isDefault: isDefault,
                repeatCount: repeatCount,
                repeatIndefinitely: repeatIndefinitely,
                colorPalette: colorPalette,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CyclocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({timerStagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (timerStagesRefs) db.timerStages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (timerStagesRefs)
                    await $_getPrefetchedData<
                      Cyclock,
                      $CyclocksTable,
                      TimerStage
                    >(
                      currentTable: table,
                      referencedTable: $$CyclocksTableReferences
                          ._timerStagesRefsTable(db),
                      managerFromTypedResult: (p0) => $$CyclocksTableReferences(
                        db,
                        table,
                        p0,
                      ).timerStagesRefs,
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
      PrefetchHooks Function({bool timerStagesRefs})
    >;
typedef $$TimerStagesTableCreateCompanionBuilder =
    TimerStagesCompanion Function({
      Value<int> id,
      required int cyclockId,
      required int orderIndex,
      required String name,
      required int durationSeconds,
      required String color,
      required String sound,
      Value<bool> isFuse,
    });
typedef $$TimerStagesTableUpdateCompanionBuilder =
    TimerStagesCompanion Function({
      Value<int> id,
      Value<int> cyclockId,
      Value<int> orderIndex,
      Value<String> name,
      Value<int> durationSeconds,
      Value<String> color,
      Value<String> sound,
      Value<bool> isFuse,
    });

final class $$TimerStagesTableReferences
    extends BaseReferences<_$AppDatabase, $TimerStagesTable, TimerStage> {
  $$TimerStagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclocksTable _cyclockIdTable(_$AppDatabase db) =>
      db.cyclocks.createAlias(
        $_aliasNameGenerator(db.timerStages.cyclockId, db.cyclocks.id),
      );

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

  ColumnFilters<bool> get isFuse => $composableBuilder(
    column: $table.isFuse,
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

  ColumnOrderings<bool> get isFuse => $composableBuilder(
    column: $table.isFuse,
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

  GeneratedColumn<bool> get isFuse =>
      $composableBuilder(column: $table.isFuse, builder: (column) => column);

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
          PrefetchHooks Function({bool cyclockId})
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
                Value<int> cyclockId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> sound = const Value.absent(),
                Value<bool> isFuse = const Value.absent(),
              }) => TimerStagesCompanion(
                id: id,
                cyclockId: cyclockId,
                orderIndex: orderIndex,
                name: name,
                durationSeconds: durationSeconds,
                color: color,
                sound: sound,
                isFuse: isFuse,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cyclockId,
                required int orderIndex,
                required String name,
                required int durationSeconds,
                required String color,
                required String sound,
                Value<bool> isFuse = const Value.absent(),
              }) => TimerStagesCompanion.insert(
                id: id,
                cyclockId: cyclockId,
                orderIndex: orderIndex,
                name: name,
                durationSeconds: durationSeconds,
                color: color,
                sound: sound,
                isFuse: isFuse,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimerStagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cyclockId = false}) {
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
                    if (cyclockId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cyclockId,
                                referencedTable: $$TimerStagesTableReferences
                                    ._cyclockIdTable(db),
                                referencedColumn: $$TimerStagesTableReferences
                                    ._cyclockIdTable(db)
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
      PrefetchHooks Function({bool cyclockId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CyclocksTableTableManager get cyclocks =>
      $$CyclocksTableTableManager(_db, _db.cyclocks);
  $$TimerStagesTableTableManager get timerStages =>
      $$TimerStagesTableTableManager(_db, _db.timerStages);
}
