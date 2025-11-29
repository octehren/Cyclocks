// Conditional imports remain the same
// EXPLANATION: This is a powerful Dart feature for writing cross-platform code. The `if` directive checks for the availability of a core library (`dart.library.html` or `dart.library.io`). If the code is compiled for the web, `web.dart` is imported. If it's compiled for a native platform (mobile/desktop), `native.dart` is imported. `unsupported.dart` acts as a fallback. This allows you to define the same `openConnection()` function with different implementations for different platforms.
import 'package:cyclock/data/connection/unsupported.dart'
    if (dart.library.html) 'package:cyclock/data/connection/web.dart'
    if (dart.library.io) 'package:cyclock/data/connection/native.dart'
    as db_connection;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
part 'database.g.dart';

@DataClassName('Cyclock')
class Cyclocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get repeatCount => integer().withDefault(const Constant(1))();
  BoolColumn get repeatIndefinitely => boolean().withDefault(const Constant(false))();
  TextColumn get colorPalette => text()(); // Store as JSON
}

@DataClassName('TimerStage')
class TimerStages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cyclockId => integer().references(Cyclocks, #id)();
  IntColumn get orderIndex => integer()();
  TextColumn get name => text()();
  IntColumn get durationSeconds => integer()();
  TextColumn get color => text()();
  TextColumn get sound => text()();
  BoolColumn get isFuse => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Cyclocks, TimerStages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Cyclock CRUD operations
  Future<int> insertCyclock(CyclocksCompanion cyclock) => into(cyclocks).insert(cyclock);
  Future<List<Cyclock>> getAllCyclocks() => select(cyclocks).get();
  Future updateCyclock(Cyclock cyclock) => update(cyclocks).replace(cyclock);
  Future deleteCyclock(Cyclock cyclock) => delete(cyclocks).delete(cyclock);

  // TimerStage operations
  Future<int> insertTimerStage(TimerStagesCompanion stage) => into(timerStages).insert(stage);
  Future<List<TimerStage>> getStagesForCyclock(int cyclockId) {
    return (select(timerStages)
      ..where((t) => t.cyclockId.equals(cyclockId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
      .get();
  }

  // EXPLANATION: A private constructor ensures that this class can only be instantiated from within this file. This is key to implementing the singleton pattern.
  AppDatabase._internal() : super(db_connection.openConnection());
  // As the name implies, a constructor meant for testing purposes only, to create in-memory DBs.
  AppDatabase.namedConstructorForTestingOnly(super.e);

  // EXPLANATION: This is the Singleton pattern. A `static final` instance is created once. Any time another part of the app needs to access the database, it will always get this exact same instance by calling `AppDatabase.instance`. This prevents multiple database connections from being opened.
  static final AppDatabase instance = AppDatabase._internal();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cyclock_db.sqlite'));
    return NativeDatabase(file);
  });
}