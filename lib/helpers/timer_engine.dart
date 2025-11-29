import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cyclock/data/database.dart';

class TimerEngine {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _currentTimer;
  int _remainingSeconds = 0;
  List<TimerStage> _stages = [];
  int _currentStageIndex = 0;
  int _currentCycle = 0;
  int _totalCycles = 1;
  bool _isRunning = false;
  bool _isPaused = false;
  
  Function(int stageIndex, int remainingSeconds)? onTick;
  Function(int stageIndex)? onStageComplete;
  Function()? onAllCyclesComplete;
  Function()? onCycleComplete;
  
  // Getters for current state
  int get currentStageIndex => _currentStageIndex;
  int get currentCycle => _currentCycle;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  List<TimerStage> get stages => _stages;
  
  void initialize(List<TimerStage> stages, int totalCycles, {bool repeatIndefinitely = false}) {
    _stages = stages;
    _totalCycles = repeatIndefinitely ? 999999 : totalCycles;
    _currentCycle = 0;
    _currentStageIndex = 0;
    _isRunning = false;
    _isPaused = false;
    
    if (_stages.isNotEmpty) {
      _remainingSeconds = _stages.first.durationSeconds;
    }
  }
  
  void start() {
    if (_stages.isEmpty || _isRunning) return;
    
    _isRunning = true;
    _isPaused = false;
    
    // If we're at the beginning, play the first stage
    if (_currentStageIndex == 0 && _remainingSeconds == _stages.first.durationSeconds) {
      _playSound(_stages.first.sound);
    }
    
    _startCurrentStage();
  }
  
  void pause() {
    _currentTimer?.cancel();
    _isRunning = false;
    _isPaused = true;
  }
  
  void resume() {
    if (!_isPaused) return;
    
    _isRunning = true;
    _isPaused = false;
    _startCurrentStage();
  }
  
  void stop() {
    _currentTimer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _currentStageIndex = 0;
    _currentCycle = 0;
    
    if (_stages.isNotEmpty) {
      _remainingSeconds = _stages.first.durationSeconds;
    }
  }
  
  void skipToNextStage() {
    _currentTimer?.cancel();
    _currentStageIndex++;
    _handleStageTransition();
  }
  
  void _startCurrentStage() {
    if (_currentStageIndex >= _stages.length) {
      _handleCycleCompletion();
      return;
    }
    
    final currentStage = _stages[_currentStageIndex];
    
    _currentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        onStageComplete?.call(_currentStageIndex);
        _currentStageIndex++;
        _handleStageTransition();
      } else {
        _remainingSeconds--;
        onTick?.call(_currentStageIndex, _remainingSeconds);
      }
    });
  }
  
  void _handleStageTransition() {
    if (_currentStageIndex >= _stages.length) {
      _handleCycleCompletion();
    } else {
      final nextStage = _stages[_currentStageIndex];
      _remainingSeconds = nextStage.durationSeconds;
      
      // Play sound for the new stage
      _playSound(nextStage.sound);
      
      if (_isRunning) {
        _startCurrentStage();
      }
    }
  }
  
  void _handleCycleCompletion() {
    _currentCycle++;
    onCycleComplete?.call();
    
    if (_currentCycle >= _totalCycles) {
      _isRunning = false;
      onAllCyclesComplete?.call();
    } else {
      // Reset to start of cycle
      _currentStageIndex = 0;
      _handleStageTransition();
    }
  }
  
  Future<void> _playSound(String soundAsset) async {
    try {
      // For now, we'll use a placeholder sound system
      // You can replace this with actual sound files
      if (soundAsset.isNotEmpty) {
        // Simple system sound as placeholder
        await _audioPlayer.play(AssetSource(soundAsset));
        print('Playing sound: $soundAsset');
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
  
  String getCurrentStageName() {
    if (_currentStageIndex < _stages.length) {
      return _stages[_currentStageIndex].name;
    }
    return '';
  }
  
  String getCurrentStageColor() {
    if (_currentStageIndex < _stages.length) {
      return _stages[_currentStageIndex].color;
    }
    return 'blue';
  }
  
  int getCurrentStageDuration() {
    if (_currentStageIndex < _stages.length) {
      return _stages[_currentStageIndex].durationSeconds;
    }
    return 0;
  }
  
  void dispose() {
    _currentTimer?.cancel();
    _audioPlayer.dispose();
  }
}