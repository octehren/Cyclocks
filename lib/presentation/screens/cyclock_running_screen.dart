import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:cyclock/data/database.dart';
import 'package:cyclock/helpers/timer_engine.dart';

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
  late TimerEngine _timerEngine;
  List<TimerStage> _executionQueue = [];
  List<Color> _executionQueueColors = [];

  int _currentStageIndex = 0;
  int _remainingSeconds = 0;
  double _totalStageDuration = 1.0; 
  
  bool _isRunning = false;
  int _currentCycle = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }
  
  Future<void> _initializeTimer() async {
    List<TimerStage> flattenedQueue = [];
    List<Color> flattenedColors = [];

    // 1. Add Fuse
    if (widget.cyclock.hasFuse) {
      flattenedQueue.add(TimerStage(
        id: -1, 
        cycleId: -1,
        orderIndex: -1,
        name: 'Fuse',
        durationSeconds: widget.cyclock.fuseDuration,
        color: 'red', 
        sound: widget.cyclock.fuseSound,
      ));
      flattenedColors.add(Colors.black87); 
    }

    // 2. Fetch Cycles
    final dbCycles = await widget.database.cyclesDao.getCyclesForCyclock(widget.cyclock.id);
    
    // 3. Flatten
    for (var cycle in dbCycles) {
      final cycleStages = await widget.database.timerStagesDao.getStagesForCycle(cycle.id);
      final cycleColor = _getStageColor(cycle.backgroundColor);

      for (int i = 0; i < cycle.repeatCount; i++) {
        for (var stage in cycleStages) {
          flattenedQueue.add(stage);
          flattenedColors.add(cycleColor);
        }
      }
    }
    
    _timerEngine = TimerEngine();
    _timerEngine.initialize(
      flattenedQueue, 
      1, 
      repeatIndefinitely: widget.cyclock.repeatIndefinitely,
    );
    
    _timerEngine.onTick = (stageIndex, remainingSeconds) {
      if (mounted) {
        setState(() {
          _currentStageIndex = stageIndex % flattenedQueue.length;
          _remainingSeconds = remainingSeconds;
          
          if (stageIndex < flattenedQueue.length) {
            _totalStageDuration = flattenedQueue[stageIndex].durationSeconds.toDouble();
            if (_totalStageDuration == 0) _totalStageDuration = 1;
          }
        });
      }
    };
    
    _timerEngine.onCycleComplete = () {
      if (mounted) setState(() => _currentCycle++);
    };
    
    _timerEngine.onAllCyclesComplete = () {
      if (mounted) {
        setState(() => _isRunning = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout Complete!')));
      }
    };
    
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
      if (_executionQueue.isNotEmpty) {
        _remainingSeconds = _executionQueue[0].durationSeconds;
        _totalStageDuration = _executionQueue[0].durationSeconds.toDouble();
      }
    });
    _timerEngine.stop();
  }
  
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

  // Used only for the timeline boxes which have colored backgrounds
  Color _getContrastingColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark 
        ? Colors.white 
        : Colors.black;
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _timerEngine.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_executionQueue.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final currentStage = _executionQueue[_currentStageIndex];
    // We still need colors for the timer borders/fill, but NOT for the scaffold/appbar
    final currentCycleColor = _executionQueueColors[_currentStageIndex];
    final timerColor = _getStageColor(currentStage.color);
    
    double percent = (_remainingSeconds / _totalStageDuration).clamp(0.0, 1.0);

    return Scaffold(
      // CHANGED: Removed custom background color. Uses Theme default.
      appBar: AppBar(
        title: Text(widget.cyclock.name),
        // CHANGED: Removed custom background/foreground colors. Uses Theme default.
      ),
      body: SafeArea( 
        child: Column(
          children: [
            // Upper Section: Timer + Description
            Expanded(
              child: Column(
                children: [
                  // 1. TIMER SECTION
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
      
                  // 2. DESCRIPTION SECTION
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
                                // CHANGED: Use Theme text styles
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
                            // CHANGED: Use Theme text styles
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (widget.cyclock.repeatIndefinitely)
                            Text(
                              'Loop ${_currentCycle + 1}', 
                              // CHANGED: Use Theme text styles
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
            
            // 3. TIMELINE (CENTERED)
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
                      
                      return Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: stageTimerColor.withOpacity(isCurrent ? 1.0 : 0.6),
                          borderRadius: BorderRadius.circular(8),
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
                                // Keep this logic for boxes with specific colored backgrounds
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
                                  // Keep this logic for boxes with specific colored backgrounds
                                  color: _getContrastingColor(stageTimerColor)
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            
            // 4. CONTROLS
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