// ==============================================================================
// FILE: presentation/screens/cyclock_running_screen.dart
// 
// PURPOSE:
// This is the main "Workout" screen. It handles the active execution of a Cyclock.
// It visualizes the current timer using a Liquid Progress effect, shows the 
// current step name, and renders a scrollable timeline of all steps.
// 
// FEATURES:
// - Liquid Timer visualization
// - Flattened execution queue (converting complex cycles into a linear list)
// - Audio and Wakelock integration (via TimerEngine)
// - Timeline navigation (Tap to jump with confirmation)
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:cyclocks/data/database.dart';
import 'package:cyclocks/helpers/timer_engine.dart';

class CyclockRunningScreen extends StatefulWidget {
  final AppDatabase database;
  final Cyclock cyclock;
  
  const CyclockRunningScreen({
    super.key,
    required this.database,
    required this.cyclock,
  });
  
  @override
  State<CyclockRunningScreen> createState() => _CyclockRunningScreenState();
}

class _CyclockRunningScreenState extends State<CyclockRunningScreen> {
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------
  
  // The engine handles the actual Ticking, Audio, and Wakelock logic
  late TimerEngine _timerEngine;
  
  // A "Flattened" list of all steps.
  // Example: If Cycle A (Work, Rest) repeats 2 times, the queue is:
  // [Work, Rest, Work, Rest]
  List<TimerStage> _executionQueue = [];
  
  // Parallel list to store the Cycle color for each step (for borders/timeline)
  List<Color> _executionQueueColors = [];

  // Current State
  int _currentStageIndex = 0;
  int _remainingSeconds = 0;
  double _totalStageDuration = 1.0; // Used to calculate liquid fill percentage (0.0 - 1.0)
  
  bool _isRunning = false; // Is the timer currently ticking?
  int _currentCycle = 0; // Tracks global loops if "Repeat Indefinitely" is on
  
  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------
  
  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }
  
  @override
  void dispose() {
    _timerEngine.dispose(); // Cleanup audio players and timers
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // INITIALIZATION LOGIC
  // ---------------------------------------------------------------------------

  Future<void> _initializeTimer() async {
    List<TimerStage> flattenedQueue = [];
    List<Color> flattenedColors = [];

    // 1. Add Fuse (Warmup) if enabled
    // We create a temporary "Stage" object for the fuse
    if (widget.cyclock.hasFuse) {
      flattenedQueue.add(TimerStage(
        id: -1, 
        cycleId: -1,
        orderIndex: -1,
        name: 'Fuse',
        durationSeconds: widget.cyclock.fuseDuration,
        color: 'red', // Fuses are usually red
        sound: widget.cyclock.fuseSound,
      ));
      flattenedColors.add(Colors.black87); // Fuse border color
    }

    // 2. Fetch Cycles from DB
    final dbCycles = await widget.database.cyclesDao.getCyclesForCyclock(widget.cyclock.id);
    
    // 3. Flatten Logic: Convert Hierarchical DB structure to Linear List
    for (var cycle in dbCycles) {
      final cycleStages = await widget.database.timerStagesDao.getStagesForCycle(cycle.id);
      final cycleColor = _getStageColor(cycle.backgroundColor);

      // Repeat stages based on cycle's repeat count
      for (int i = 0; i < cycle.repeatCount; i++) {
        for (var stage in cycleStages) {
          flattenedQueue.add(stage);
          flattenedColors.add(cycleColor);
        }
      }
    }
    
    // 4. Initialize Engine
    _timerEngine = TimerEngine();
    _timerEngine.initialize(
      flattenedQueue, 
      1, // The engine treats the flattened queue as 1 giant cycle
      repeatIndefinitely: widget.cyclock.repeatIndefinitely,
    );
    
    // 5. Setup Callbacks
    
    // Called every second: Updates UI numbers
    _timerEngine.onTick = (stageIndex, remainingSeconds) {
      if (mounted) {
        setState(() {
          _currentStageIndex = stageIndex % flattenedQueue.length;
          _remainingSeconds = remainingSeconds;
          
          // Update ref for percentage calculation
          if (stageIndex < flattenedQueue.length) {
            _totalStageDuration = flattenedQueue[stageIndex].durationSeconds.toDouble();
            if (_totalStageDuration == 0) _totalStageDuration = 1;
          }
        });
      }
    };
    
    // Called when the whole list finishes (if looping)
    _timerEngine.onCycleComplete = () {
      if (mounted) setState(() => _currentCycle++);
    };
    
    // Called when everything is done
    _timerEngine.onAllCyclesComplete = () {
      if (mounted) {
        setState(() => _isRunning = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout Complete!')));
      }
    };
    
    // 6. Initial State Set
    if (mounted) {
      setState(() {
        _executionQueue = flattenedQueue;
        _executionQueueColors = flattenedColors;
        if (_executionQueue.isNotEmpty) {
          _remainingSeconds = _executionQueue.first.durationSeconds;
          _totalStageDuration = _executionQueue.first.durationSeconds.toDouble();
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // CONTROL LOGIC
  // ---------------------------------------------------------------------------

  void _startTimer() {
    setState(() => _isRunning = true);
    _timerEngine.start();
  }
  
  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timerEngine.pause();
  }
  
  void _resumeTimer() {
    setState(() => _isRunning = true);
    _timerEngine.resume();
  }
  
  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _currentStageIndex = 0;
      // Reset display to first item
      if (_executionQueue.isNotEmpty) {
        _remainingSeconds = _executionQueue[0].durationSeconds;
        _totalStageDuration = _executionQueue[0].durationSeconds.toDouble();
      }
    });
    _timerEngine.stop();
  }

  // ---------------------------------------------------------------------------
  // JUMP / SKIP LOGIC
  // ---------------------------------------------------------------------------

  // Triggered when user taps a box in the timeline
  void _onStepTapped(int index) {
    // Prevent jumping to the currently running step
    if (index == _currentStageIndex) return;

    // Show Confirmation
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Jump to Step?"),
        content: Text("Do you want to skip to '${_executionQueue[index].name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              _performJump(index); // Execute Jump
            },
            child: const Text("Jump"),
          ),
        ],
      ),
    );
  }

  void _performJump(int index) {
    // 1. Update UI State immediately
    setState(() {
      _currentStageIndex = index;
      _remainingSeconds = _executionQueue[index].durationSeconds;
      _totalStageDuration = _remainingSeconds.toDouble();
      if (_totalStageDuration == 0) _totalStageDuration = 1.0;
    });

    // 2. Tell Engine to sync up
    // NOTE: This assumes TimerEngine has a `jumpToStep` method.
    // See comment at the top of the file/response.
    try {
       // We invoke this dynamically or assuming you added the method to TimerEngine
       _timerEngine.jumpToStep(index);
    } catch (e) {
      debugPrint("Error jumping: TimerEngine might need a jumpToStep method. $e");
    }
  }
  
  // ---------------------------------------------------------------------------
  // UI HELPERS
  // ---------------------------------------------------------------------------

  Color _getStageColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red': return Colors.red;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'pink': return Colors.pink;
      case 'grey': return Colors.grey;
      case 'orange': return Colors.orange;
      case 'purple': return Colors.purple;
      case 'teal': return Colors.teal;
      case 'amber': return Colors.amber;
      case 'darkblue': return Colors.blue[900]!;
      default: return Colors.blue;
    }
  }

  // Calculates text color (Black/White) based on background brightness
  Color _getContrastingColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark 
        ? Colors.white 
        : Colors.black;
  }
  
  // Formats seconds into MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
  
  // ---------------------------------------------------------------------------
  // MAIN WIDGET BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_executionQueue.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    // Current State Data
    final currentStage = _executionQueue[_currentStageIndex];
    final currentCycleColor = _executionQueueColors[_currentStageIndex];
    final timerColor = _getStageColor(currentStage.color);
    
    // Liquid Fill Percentage
    double percent = (_remainingSeconds / _totalStageDuration).clamp(0.0, 1.0);

    return Scaffold(
      // Standard App Bar (Uses Theme colors)
      appBar: AppBar(
        title: Text(widget.cyclock.name),
      ),
      body: SafeArea( 
        child: Column(
          children: [
            // =======================================================
            // SECTION 1: MAIN DISPLAY (Liquid Timer + Text)
            // =======================================================
            Expanded(
              child: Column(
                children: [
                  // 1A: LIQUID TIMER
                  // Uses LayoutBuilder to stay square and fit screen
                  Expanded(
                    flex: 5,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double minDimension = constraints.maxWidth < constraints.maxHeight 
                            ? constraints.maxWidth 
                            : constraints.maxHeight;
                        double timerSize = minDimension * 0.75;
      
                        return Center(
                          child: SizedBox(
                            width: timerSize,
                            height: timerSize,
                            child: LiquidCircularProgressIndicator(
                              value: percent, 
                              valueColor: AlwaysStoppedAnimation(timerColor),
                              backgroundColor: Colors.grey[300]!, 
                              borderColor: currentCycleColor,
                              borderWidth: 5.0,
                              direction: Axis.vertical,
                              center: Text(
                                _formatTime(_remainingSeconds),
                                style: TextStyle(
                                  fontSize: timerSize * 0.25, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(blurRadius: 4, color: Colors.black.withOpacity(0.5), offset: const Offset(1,1))
                                  ]
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      
                  // 1B: DESCRIPTION TEXT
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                currentStage.name,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Step ${_currentStageIndex + 1} of ${_executionQueue.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (widget.cyclock.repeatIndefinitely)
                            Text(
                              'Loop ${_currentCycle + 1}', 
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // =======================================================
            // SECTION 2: TIMELINE (Scrollable Row)
            // =======================================================
            Container(
              height: 90,
              width: double.infinity, 
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _executionQueue.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stage = entry.value;
                      
                      final stageCycleColor = _executionQueueColors[index];
                      final stageTimerColor = _getStageColor(stage.color);
                      final isCurrent = index == _currentStageIndex;
                      
                      // WRAP IN INKWELL for Tap Interaction
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => _onStepTapped(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              // Background = Timer Color
                              color: stageTimerColor.withOpacity(isCurrent ? 1.0 : 0.6),
                              borderRadius: BorderRadius.circular(8),
                              // Border = Cycle Color
                              border: Border.all(
                                color: stageCycleColor, 
                                width: isCurrent ? 4 : 2
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(stage.durationSeconds),
                                  style: TextStyle(
                                    color: _getContrastingColor(stageTimerColor),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    stage.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10, 
                                      color: _getContrastingColor(stageTimerColor)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            
            // =======================================================
            // SECTION 3: CONTROLS (Start/Stop/Pause)
            // =======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('Stop', Colors.red, _stopTimer),
                  if (!_isRunning)
                    _buildButton('Start', Colors.green, _startTimer)
                  else
                    _buildButton('Pause', Colors.orange, _pauseTimer),
                    
                  if (!_isRunning && _currentStageIndex > 0)
                    _buildButton('Resume', Colors.blue, _resumeTimer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}