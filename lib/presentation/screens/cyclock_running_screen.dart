import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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
  bool _isRunning = false;
  int _currentCycle = 0;
  
  final CountDownController _countDownController = CountDownController();
  
  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }
  
  Future<void> _initializeTimer() async {
    List<TimerStage> flattenedQueue = [];
    List<Color> flattenedColors = [];

    // 1. Add Fuse if enabled
    if (widget.cyclock.hasFuse) {
      // Create a temporary stage for the fuse. ID -1 indicates it's not in DB.
      flattenedQueue.add(TimerStage(
        id: -1, 
        cycleId: -1,
        orderIndex: -1,
        name: 'Fuse',
        durationSeconds: widget.cyclock.fuseDuration,
        color: 'red', // Fuse is typically red
        sound: widget.cyclock.fuseSound,
      ));
      // Fuse uses the Cyclock's primary color or just neutral for background
      flattenedColors.add(Colors.black87); 
    }

    // 2. Fetch Cycles from DB
    final dbCycles = await widget.database.cyclesDao.getCyclesForCyclock(widget.cyclock.id);
    
    // 3. Flatten Logic
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
    
    // 4. Init Engine
    _timerEngine = TimerEngine();
    _timerEngine.initialize(
      flattenedQueue, 
      1, // Engine treats queue as one giant cycle
      repeatIndefinitely: widget.cyclock.repeatIndefinitely,
    );
    
    _timerEngine.onTick = (stageIndex, remainingSeconds) {
      if (mounted) {
        setState(() {
          _currentStageIndex = stageIndex % flattenedQueue.length;
          _remainingSeconds = remainingSeconds;
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
        }
      });
    }
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timerEngine.start();
    _countDownController.start();
  }
  
  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timerEngine.pause();
    _countDownController.pause();
  }
  
  void _resumeTimer() {
    setState(() => _isRunning = true);
    _timerEngine.resume();
    _countDownController.resume();
  }
  
  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _currentStageIndex = 0;
    });
    _timerEngine.stop();
    _countDownController.restart();
    _countDownController.pause();
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
    final currentCycleColor = _executionQueueColors[_currentStageIndex];
    
    return Scaffold(
      backgroundColor: currentCycleColor.withOpacity(0.05),
      appBar: AppBar(
        title: Text(widget.cyclock.name),
        backgroundColor: currentCycleColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentStage.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Step ${_currentStageIndex + 1} of ${_executionQueue.length}',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ],
                ),
                if (widget.cyclock.repeatIndefinitely)
                   Text('Loop ${_currentCycle + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Main Timer
          Expanded(
            child: Center(
              child: CircularCountDownTimer(
                duration: currentStage.durationSeconds,
                initialDuration: _remainingSeconds,
                controller: _countDownController,
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.4,
                ringColor: Colors.grey[300]!,
                fillColor: _getStageColor(currentStage.color),
                backgroundColor: Colors.transparent,
                strokeWidth: 15.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: false,
                onComplete: () {},
              ),
            ),
          ),
          
          // Timeline
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _executionQueue.length,
              itemBuilder: (context, index) {
                final stage = _executionQueue[index];
                final isCurrent = index == _currentStageIndex;
                return Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _getStageColor(stage.color).withOpacity(isCurrent ? 1.0 : 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: isCurrent ? Border.all(color: Colors.black, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(stage.durationSeconds),
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.black,
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
                          style: TextStyle(fontSize: 10, color: isCurrent ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Controls
          Padding(
            padding: const EdgeInsets.all(24),
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