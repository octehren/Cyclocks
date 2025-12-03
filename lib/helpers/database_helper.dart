import 'package:drift/drift.dart';
import 'package:cyclocks/data/database.dart';

class DatabaseHelper {
  static Future<void> initializeDefaultCyclocks(AppDatabase db) async {
    final existing = await db.cyclocksDao.getAllCyclocks();
    if (existing.isNotEmpty) return;
    
    // --- 1. Pomodoro ---
    // 60s Fuse -> [Work, Short] x3 -> [Work, Long] x1
    final pomodoroId = await db.cyclocksDao.insertCyclock(CyclocksCompanion(
      name: const Value('Pomodoro'),
      repeatIndefinitely: const Value(false),
      colorPalette: const Value('red,green'),
      // Fuse properties
      hasFuse: const Value(true),
      fuseDuration: const Value(60),
      fuseSound: const Value('fuseburn.wav'),
    ));

    // Cycle 1: 3x Work + Short Break
    await _createCycle(
      db, pomodoroId, 0, "Core Intervals", 3, "red",
      [
        _makeStage(0, 'Work', 25 * 60, 'red', 'rooster.wav'),
        _makeStage(1, 'Short Break', 5 * 60, 'green', 'ding_bellboy.wav'),
      ]
    );

    // Cycle 2: 1x Work + Long Break
    await _createCycle(
      db, pomodoroId, 1, "Final Set", 1, "green",
      [
        _makeStage(0, 'Work', 25 * 60, 'red', 'rooster.wav'),
        _makeStage(1, 'Long Break', 30 * 60, 'green', 'ding_double_bellboy.ogg'),
      ]
    );
    
    // --- 2. Squats ---
    // 10s Fuse -> [Exercise, Rest] x2 -> [Exercise] x1
    final squatsId = await db.cyclocksDao.insertCyclock(CyclocksCompanion(
      name: const Value('Squats'),
      repeatIndefinitely: const Value(false),
      colorPalette: const Value('darkblue,grey'),
      // Fuse properties
      hasFuse: const Value(true),
      fuseDuration: const Value(10),
      fuseSound: const Value('fuseburn.wav'),
    ));

    await _createCycle(
      db, squatsId, 0, "Sets", 2, "darkblue",
      [
        _makeStage(0, 'Exercise', 2 * 60, 'darkblue', 'powerup.wav'),
        _makeStage(1, 'Rest', 30, 'grey', 'ding_double_bellboy.wav'),
      ]
    );

    await _createCycle(
      db, squatsId, 1, "Final Burn", 1, "darkblue",
      [
        _makeStage(0, 'Exercise', 2 * 60, 'darkblue', 'timer_start'),
      ]
    );
  }
  
  static Future<void> _createCycle(
    AppDatabase db, 
    int cyclockId, 
    int order, 
    String name, 
    int repeats, 
    String bgColor,
    List<TimerStagesCompanion> stages
  ) async {
    final cycleId = await db.cyclesDao.insertCycle(CyclesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: Value(order),
      name: Value(name),
      repeatCount: Value(repeats),
      backgroundColor: Value(bgColor),
    ));

    for (var stage in stages) {
      await db.timerStagesDao.insertTimerStage(
        stage.copyWith(cycleId: Value(cycleId))
      );
    }
  }

  static TimerStagesCompanion _makeStage(
    int order, String name, int duration, String color, String sound
  ) {
    return TimerStagesCompanion(
      orderIndex: Value(order),
      name: Value(name),
      durationSeconds: Value(duration),
      color: Value(color),
      sound: Value(sound),
      cycleId: const Value(0), // Placeholder, filled in _createCycle
    );
  }
}