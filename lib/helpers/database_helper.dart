import 'package:drift/drift.dart';
import 'package:cyclock/data/database.dart';

class DatabaseHelper {
  static Future<void> initializeDefaultCyclocks(AppDatabase db) async {
    final existing = await db.getAllCyclocks();
    if (existing.isNotEmpty) return;
    
    // Pomodoro Cyclock
    final pomodoroId = await db.insertCyclock(CyclocksCompanion(
      name: const Value('Pomodoro'),
      isDefault: const Value(true),
      repeatCount: const Value(1),
      repeatIndefinitely: const Value(false),
      colorPalette: const Value('red,green'),
    ));
    
    await _insertPomodoroStages(db, pomodoroId);
    
    // Squats Cyclock
    final squatsId = await db.insertCyclock(CyclocksCompanion(
      name: const Value('Squats'),
      isDefault: const Value(true),
      repeatCount: const Value(1),
      repeatIndefinitely: const Value(false),
      colorPalette: const Value('darkblue,grey'),
    ));
    
    await _insertSquatsStages(db, squatsId);
    
    // Stretching Cyclock
    final stretchingId = await db.insertCyclock(CyclocksCompanion(
      name: const Value('Stretching'),
      isDefault: const Value(true),
      repeatCount: const Value(1),
      repeatIndefinitely: const Value(false),
      colorPalette: const Value('pink,white'),
    ));
    
    await _insertStretchingStages(db, stretchingId);
  }
  
  static Future<void> _insertPomodoroStages(AppDatabase db, int cyclockId) async {
    // Fuse (60 seconds)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(0),
      name: const Value('Fuse'),
      durationSeconds: const Value(60),
      color: const Value('red'),
      sound: const Value('fuse_burning'),
      isFuse: const Value(true),
    ));
    
    // 3 cycles of work + short break
    for (int cycle = 0; cycle < 3; cycle++) {
      // Work timer (25 minutes)
      await db.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(1 + (cycle * 2)),
        name: const Value('Work'),
        durationSeconds: const Value(25 * 60), // 25 minutes
        color: const Value('red'),
        sound: const Value('timer_start'),
        isFuse: const Value(false),
      ));
      
      // Short break (5 minutes)
      await db.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(2 + (cycle * 2)),
        name: const Value('Short Break'),
        durationSeconds: const Value(5 * 60), // 5 minutes
        color: const Value('green'),
        sound: const Value('timer_start'),
        isFuse: const Value(false),
      ));
    }
    
    // Final work timer (25 minutes)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(7),
      name: const Value('Work'),
      durationSeconds: const Value(25 * 60), // 25 minutes
      color: const Value('red'),
      sound: const Value('timer_start'),
      isFuse: const Value(false),
    ));
    
    // Long break (30 minutes)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(8),
      name: const Value('Long Break'),
      durationSeconds: const Value(30 * 60), // 30 minutes
      color: const Value('green'),
      sound: const Value('timer_start'),
      isFuse: const Value(false),
    ));
  }
  
  static Future<void> _insertSquatsStages(AppDatabase db, int cyclockId) async {
    // Fuse (10 seconds)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(0),
      name: const Value('Fuse'),
      durationSeconds: const Value(10),
      color: const Value('darkblue'),
      sound: const Value('fuse_burning'),
      isFuse: const Value(true),
    ));
    
    // 2 cycles of exercise + rest
    for (int cycle = 0; cycle < 2; cycle++) {
      // Exercise (2 minutes)
      await db.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(1 + (cycle * 2)),
        name: const Value('Exercise'),
        durationSeconds: const Value(2 * 60), // 2 minutes
        color: const Value('darkblue'),
        sound: const Value('timer_start'),
        isFuse: const Value(false),
      ));
      
      // Rest (30 seconds)
      await db.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(2 + (cycle * 2)),
        name: const Value('Rest'),
        durationSeconds: const Value(30), // 30 seconds
        color: const Value('grey'),
        sound: const Value('timer_start'),
        isFuse: const Value(false),
      ));
    }
    
    // Final exercise (2 minutes)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(5),
      name: const Value('Exercise'),
      durationSeconds: const Value(2 * 60), // 2 minutes
      color: const Value('darkblue'),
      sound: const Value('timer_start'),
      isFuse: const Value(false),
    ));
  }
  
  static Future<void> _insertStretchingStages(AppDatabase db, int cyclockId) async {
    // Fuse (10 seconds)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(0),
      name: const Value('Fuse'),
      durationSeconds: const Value(10),
      color: const Value('pink'),
      sound: const Value('fuse_burning'),
      isFuse: const Value(true),
    ));
    
    // 5 cycles of stretch + pause
    for (int cycle = 0; cycle < 5; cycle++) {
      // Stretch (45 seconds)
      await db.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(1 + (cycle * 2)),
        name: const Value('Stretch'),
        durationSeconds: const Value(45), // 45 seconds
        color: const Value('pink'),
        sound: const Value('timer_start'),
        isFuse: const Value(false),
      ));
      
      // Pause (15 seconds)
      await db.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(2 + (cycle * 2)),
        name: const Value('Pause'),
        durationSeconds: const Value(15), // 15 seconds
        color: const Value('white'),
        sound: const Value('timer_start'),
        isFuse: const Value(false),
      ));
    }
    
    // Final stretch (45 seconds)
    await db.insertTimerStage(TimerStagesCompanion(
      cyclockId: Value(cyclockId),
      orderIndex: const Value(11),
      name: const Value('Stretch'),
      durationSeconds: const Value(45), // 45 seconds
      color: const Value('pink'),
      sound: const Value('timer_start'),
      isFuse: const Value(false),
    ));
  }
}