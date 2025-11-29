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
  List<TimerStage> _stages = [];
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
    _stages = await widget.database.getStagesForCyclock(widget.cyclock.id);
    
    _timerEngine = TimerEngine();
    _timerEngine.initialize(
      _stages,
      widget.cyclock.repeatCount,
      repeatIndefinitely: widget.cyclock.repeatIndefinitely,
    );
    
    _timerEngine.onTick = (stageIndex, remainingSeconds) {
      if (mounted) {
        setState(() {
          _currentStageIndex = stageIndex;
          _remainingSeconds = remainingSeconds;
        });
      }
    };
    
    _timerEngine.onStageComplete = (stageIndex) {
      // Stage completion is handled automatically
    };
    
    _timerEngine.onCycleComplete = () {
      if (mounted) {
        setState(() {
          _currentCycle = _timerEngine.currentCycle;
        });
      }
    };
    
    _timerEngine.onAllCyclesComplete = () {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cyclock completed!')),
        );
      }
    };
    
    // Initialize the countdown controller with the first stage duration
    if (_stages.isNotEmpty) {
      _remainingSeconds = _stages.first.durationSeconds;
    }
  }
  
  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timerEngine.start();
    _countDownController.start();
  }
  
  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timerEngine.pause();
    _countDownController.pause();
  }
  
  void _resumeTimer() {
    setState(() {
      _isRunning = true;
    });
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
      default: return Colors.blue;
    }
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _timerEngine.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_stages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final currentStage = _currentStageIndex < _stages.length 
        ? _stages[_currentStageIndex] 
        : _stages.first;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cyclock.name),
        backgroundColor: _getStageColor(currentStage.color),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Current stage info
          Container(
            padding: const EdgeInsets.all(16),
            color: _getStageColor(currentStage.color).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentStage.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Stage ${_currentStageIndex + 1} of ${_stages.length}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  'Cycle ${_currentCycle + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Circular timer
          Expanded(
            child: Center(
              child: CircularCountDownTimer(
                duration: currentStage.durationSeconds,
                initialDuration: _remainingSeconds,
                controller: _countDownController,
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: Colors.grey[300]!,
                fillColor: _getStageColor(currentStage.color),
                backgroundColor: Colors.transparent,
                strokeWidth: 12.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: false,
                onComplete: () {
                  // Handled by timer engine
                },
              ),
            ),
          ),
          
          // Next stages preview
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stages.length,
              itemBuilder: (context, index) {
                final stage = _stages[index];
                return Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _getStageColor(stage.color).withOpacity(
                      index == _currentStageIndex ? 1.0 : 0.3
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(stage.durationSeconds),
                        style: TextStyle(
                          color: index == _currentStageIndex 
                              ? Colors.white 
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        stage.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: index == _currentStageIndex 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Control buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _stopTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Stop'),
                ),
                
                if (!_isRunning) ...[
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: _pauseTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pause'),
                  ),
                ],
                
                if (!_isRunning && _currentStageIndex > 0) ...[
                  ElevatedButton(
                    onPressed: _resumeTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Resume'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}