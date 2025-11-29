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

// -----------------------------------------------------------------------------
// DAO DEFINITIONS
// -----------------------------------------------------------------------------

@DriftAccessor(tables: [Cyclocks])
class CyclocksDao extends DatabaseAccessor<AppDatabase> with _$CyclocksDaoMixin {
  CyclocksDao(super.db);

  Future<int> insertCyclock(CyclocksCompanion cyclock) => into(cyclocks).insert(cyclock);
  Future<List<Cyclock>> getAllCyclocks() => select(cyclocks).get();
  Future updateCyclock(Cyclock cyclock) => update(cyclocks).replace(cyclock);
  Future deleteCyclock(Cyclock cyclock) => delete(cyclocks).delete(cyclock);
}

@DriftAccessor(tables: [TimerStages])
class TimerStagesDao extends DatabaseAccessor<AppDatabase> with _$TimerStagesDaoMixin {
  TimerStagesDao(super.db);

  Future<int> insertTimerStage(TimerStagesCompanion stage) => into(timerStages).insert(stage);
  
  Future<List<TimerStage>> getStagesForCyclock(int cyclockId) {
    return (select(timerStages)
      ..where((t) => t.cyclockId.equals(cyclockId))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
      .get();
  }
  
  Future<void> deleteStagesForCyclock(int cyclockId) {
    return (delete(timerStages)..where((t) => t.cyclockId.equals(cyclockId))).go();
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

  // EXPLANATION: A private constructor ensures that this class can only be instantiated from within this file.
  AppDatabase._internal() : super(db_connection.openConnection());
  
  // As the name implies, a constructor meant for testing purposes only.
  AppDatabase.namedConstructorForTestingOnly(super.e);

  // EXPLANATION: Singleton pattern.
  static final AppDatabase instance = AppDatabase._internal();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cyclock_db.sqlite'));
    return NativeDatabase(file);
  });
}