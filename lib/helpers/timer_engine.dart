import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cyclocks/data/database.dart';
import 'package:cyclocks/helpers/sound_helper.dart';
import 'package:wakelock_plus/wakelock_plus.dart';  // Allows app not to sleep on mobile devices

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
  // Checks end of current stage to calculate delta-time so even if device (usually mobile) sleeps,
  // app uses past Time.now to current Time.now instead of relying on computer clock
  DateTime? _stageEndTime; // Add this class variable
  
  Function(int stageIndex, int remainingSeconds)? onTick;
  Function(int stageIndex)? onStageComplete;
  Function()? onAllCyclesComplete;
  Function()? onCycleComplete;
  
  // Getters
  int get currentCycle => _currentCycle;
  bool get isRunning => _isRunning;
  
  void initialize(List<TimerStage> stages, int totalCycles, {bool repeatIndefinitely = false}) {
    _stages = stages;
    _totalCycles = repeatIndefinitely ? 999999 : totalCycles;
    _currentCycle = 0;
    _currentStageIndex = 0;
    _isRunning = false;
    _isPaused = false;

    // ANDROID SETUP: Ensure audio plays even if screen dims/locks momentarily
    final AudioContext audioContext = AudioContext(
      // iOS: AudioContextIOS(
      //   category: AVAudioSessionCategory.playback,
      //   options: const {
      //     AVAudioSessionOptions.mixWithOthers,
      //     AVAudioSessionOptions.duckOthers,
      //   },
      // ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);
    
    // Reset player mode
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    
    if (_stages.isNotEmpty) {
      _remainingSeconds = _stages.first.durationSeconds;
    }
  }
  
  void start() {
    if (_stages.isEmpty || _isRunning) return;
    
    _isRunning = true;
    _isPaused = false;

    // ENABLE WAKELOCK: Keep screen on while timer runs
    WakelockPlus.enable();
    
    // Play sound immediately when starting/resuming a stage
    _playCurrentStageSound();
    _startTicker();
  }
  
  void pause() {
    _currentTimer?.cancel();
    _audioPlayer.pause(); // Pause audio if it's a loop
    _isRunning = false;
    _isPaused = true;
  }
  
  void resume() {
    if (!_isPaused) return;
    
    _isRunning = true;
    _isPaused = false;
    _audioPlayer.resume(); // Resume audio
    // RE-ENABLE WAKELOCK: Keep screen on while timer runs
    WakelockPlus.enable();

    _startTicker();
  }
  
  void stop() {
    _currentTimer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _isRunning = false;
    _isPaused = false;
    _currentStageIndex = 0;
    _currentCycle = 0;

    // DISABLE WAKELOCK
    WakelockPlus.disable();
    
    if (_stages.isNotEmpty) {
      _remainingSeconds = _stages.first.durationSeconds;
    }
  }
  
  void _startTicker() {
    // Calculate when this specific stage should end based on NOW + Remaining
    _stageEndTime = DateTime.now().add(Duration(seconds: _remainingSeconds));

    _currentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      // Calculate remaining based on real time difference
      final remaining = _stageEndTime!.difference(now).inSeconds;
      
      // Update local variable for display
      _remainingSeconds = remaining;
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _audioPlayer.stop(); // Stop any looping sounds from previous stage
        onStageComplete?.call(_currentStageIndex);
        _currentStageIndex++;
        _handleStageTransition();
      } else {
        // _remainingSeconds is now updated above
        // _remainingSeconds--;
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
      
      // Reset the target time for the new stage
      _stageEndTime = DateTime.now().add(Duration(seconds: _remainingSeconds));
      
      if (_isRunning) {
        _playCurrentStageSound();
        _startTicker();
      }
    }
  }

  Future<void> _playCurrentStageSound() async {
    if (_currentStageIndex >= _stages.length) return;
    
    final stage = _stages[_currentStageIndex];
    final soundDef = SoundHelper.getByFileName(stage.sound);
    
    if (soundDef == null) return;

    try {
      await _audioPlayer.stop(); // Stop previous sound
      
      if (soundDef.type == SoundType.loop) {
        // For Fuse/Loops: Set to loop and play
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource('sounds/${soundDef.fileName}'));
      } else {
        // For Triggers: Set to stop (play once) and play
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        await _audioPlayer.play(AssetSource('sounds/${soundDef.fileName}'));
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
  
  void _handleCycleCompletion() {
    _currentCycle++;
    onCycleComplete?.call();
    
    if (_currentCycle >= _totalCycles) {
      _isRunning = false;
      _audioPlayer.stop();
      onAllCyclesComplete?.call();
    } else {
      _currentStageIndex = 0;
      _handleStageTransition();
    }
  }
  
  void dispose() {
    _currentTimer?.cancel();
    _audioPlayer.dispose();
    WakelockPlus.disable(); // Safety cleanup
  }
}