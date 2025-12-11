// helpers/audio_player_singleton.dart
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerSingleton {
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._internal();
  final AudioPlayer _player = AudioPlayer();
  
  factory AudioPlayerSingleton() => _instance;
  
  AudioPlayerSingleton._internal();
  
  // Main method to play sounds
  Future<void> playSound(String fileName, {bool loop = false}) async {
    await _player.stop();
    await _player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
    await _player.play(AssetSource('sounds/$fileName'));
  }
  
  // Alternative method if you need direct control
  AudioPlayer get player => _player;
  
  Future<void> stop() async {
    await _player.stop();
  }
  
  Future<void> pause() async {
    await _player.pause();
  }
  
  Future<void> resume() async {
    await _player.resume();
  }
  
  // Don't dispose in singleton - it's used throughout the app
  // void dispose() {
  //   _player.dispose();
  // }
}