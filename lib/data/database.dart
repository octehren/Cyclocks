// Conditional imports remain the same
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
  TextColumn get colorPalette => text()();

  // -- Global Loop --
  BoolColumn get repeatIndefinitely => boolean().withDefault(const Constant(false))(); 


  // -- Fuse Properties --
  BoolColumn get hasFuse => boolean().withDefault(const Constant(false))();
  IntColumn get fuseDuration => integer().withDefault(const Constant(10))();
  TextColumn get fuseSound => text().withDefault(const Constant('fuseburn.wav'))();
}

// -- Cycles Table --
@DataClassName('Cycle')
class Cycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Cascade delete: if Cyclock is deleted, its cycles are deleted
  IntColumn get cyclockId => integer().references(Cyclocks, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();
  TextColumn get name => text().withDefault(const Constant('Cycle'))();
  IntColumn get repeatCount => integer().withDefault(const Constant(1))();
  TextColumn get backgroundColor => text().withDefault(const Constant('blue'))();
}

@DataClassName('TimerStage')
class TimerStages extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Linked to Cycle instead of Cyclock
  IntColumn get cycleId => integer().references(Cycles, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();
  TextColumn get name => text()();
  IntColumn get durationSeconds => integer()();
  TextColumn get color => text()();
  TextColumn get sound => text()();
}

// -----------------------------------------------------------------------------
// DAOs
// -----------------------------------------------------------------------------

@DriftAccessor(tables: [Cyclocks])
class CyclocksDao extends DatabaseAccessor<AppDatabase> with _$CyclocksDaoMixin {
  CyclocksDao(super.db);
  Future<int> insertCyclock(CyclocksCompanion cyclock) => into(cyclocks).insert(cyclock);
  Future<List<Cyclock>> getAllCyclocks() => select(cyclocks).get();
  Future updateCyclock(Cyclock cyclock) => update(cyclocks).replace(cyclock);
  Future deleteCyclock(Cyclock cyclock) => delete(cyclocks).delete(cyclock);
}

@DriftAccessor(tables: [Cycles])
class CyclesDao extends DatabaseAccessor<AppDatabase> with _$CyclesDaoMixin {
  CyclesDao(super.db);
  Future<int> insertCycle(CyclesCompanion cycle) => into(cycles).insert(cycle);
  Future<List<Cycle>> getCyclesForCyclock(int cyclockId) {
    return (select(cycles)
      ..where((t) => t.cyclockId.equals(cyclockId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
      .get();
  }
  Future<void> deleteCyclesForCyclock(int cyclockId) {
    return (delete(cycles)..where((t) => t.cyclockId.equals(cyclockId))).go();
  }
}

@DriftAccessor(tables: [TimerStages])
class TimerStagesDao extends DatabaseAccessor<AppDatabase> with _$TimerStagesDaoMixin {
  TimerStagesDao(super.db);
  Future<int> insertTimerStage(TimerStagesCompanion stage) => into(timerStages).insert(stage);
  Future<List<TimerStage>> getStagesForCycle(int cycleId) {
    return (select(timerStages)
      ..where((t) => t.cycleId.equals(cycleId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
      .get();
  }
}

// -----------------------------------------------------------------------------
// DATABASE DEFINITION
// -----------------------------------------------------------------------------

@DriftDatabase(tables: [Cyclocks, TimerStages], daos: [CyclocksDao, TimerStagesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Explicitly expose DAOs here to fix "getter not defined" errors
  late final CyclocksDao cyclocksDao = CyclocksDao(this as AppDatabase);
  late final CyclesDao cyclesDao = CyclesDao(this as AppDatabase);
  late final TimerStagesDao timerStagesDao = TimerStagesDao(this as AppDatabase);

  // A private constructor ensures that this class can only be instantiated from within this file.
  AppDatabase._internal() : super(db_connection.openConnection());
  
  // As the name implies, a constructor meant for testing purposes only.
  AppDatabase.namedConstructorForTestingOnly(super.e);

  // Singleton.
  static final AppDatabase instance = AppDatabase._internal();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cyclocks_db.sqlite'));
    return NativeDatabase(file);
  });
}