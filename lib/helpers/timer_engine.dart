import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cyclocks/data/database.dart';
import 'package:cyclocks/helpers/sound_helper.dart';
import 'package:wakelock_plus/wakelock_plus.dart';  // Allows app not to sleep on mobile devices
// NOTIFICATIONS ON MOBILE DEVICES
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cyclocks/main.dart'; // To access the global notification plugin

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
  DateTime? _stageEndTime;
  
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
    // CANCEL ANY PENDING ALARM
    flutterLocalNotificationsPlugin.cancelAll();
  }
  
  void resume() {
    if (!_isPaused) return;
    
    _isRunning = true;
    _isPaused = false;
    // RE-ENABLE WAKELOCK: Keep screen on while timer runs
    WakelockPlus.enable();
    _audioPlayer.resume(); // Resume audio

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

    // CANCEL ALARMS
    flutterLocalNotificationsPlugin.cancelAll();
    
    if (_stages.isNotEmpty) {
      _remainingSeconds = _stages.first.durationSeconds;
    }
  }
  
  void _startTicker() {
    // Calculate when this specific stage should end based on NOW + Remaining
    _stageEndTime = DateTime.now().add(Duration(seconds: _remainingSeconds));

    // 2. SCHEDULE NOTIFICATION
    // If the app dies/sleeps, this notification will wake the user up.
    _scheduleStageEndNotification(_remainingSeconds);

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
        // Timer finished normally while app was open, 
        // cancel the backup notification so we don't get double sound.
        flutterLocalNotificationsPlugin.cancel(0); 

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

  // Schedules a notification for when the timer hits 0
  Future<void> _scheduleStageEndNotification(int secondsFromNow) async {
    if (secondsFromNow <= 0) return;

    // Determine the name of the NEXT stage (what starts when this ends)
    String nextUp = "Next stage starting";
    if (_currentStageIndex + 1 < _stages.length) {
      nextUp = "Up next: ${_stages[_currentStageIndex + 1].name}";
    } else if (_currentCycle + 1 < _totalCycles) {
      nextUp = "Cycle complete. Starting next loop.";
    } else {
      nextUp = "Workout Complete!";
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID (use 0 to keep overwriting the previous one)
      'Timer Finished',
      nextUp,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: secondsFromNow)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'cyclock_timer_channel',
          'Timer Alerts',
          channelDescription: 'Alerts when a timer finishes',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          // You can add a custom sound resource to android/app/src/main/res/raw
          // sound: RawResourceAndroidNotificationSound('notification_sound'),
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBanner: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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