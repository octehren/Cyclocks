import 'package:flutter/material.dart';

enum SoundType {
  trigger, // Plays once (e.g., "Ding")
  loop,    // Loops while stage is active (e.g., "Fuse burning")
}

class AppSound {
  final String name;
  final String fileName;
  final SoundType type;

  const AppSound({
    required this.name,
    required this.fileName,
    required this.type,
  });
}

class SoundHelper {
  static const List<AppSound> allSounds = [
    // // --- Triggers (For Timer Stages) ---
    AppSound(name: 'Ding', fileName: 'ding_bellboy.wav', type: SoundType.trigger),
    AppSound(name: 'Double Ding', fileName: 'ding_double_bellboy.ogg', type: SoundType.trigger),
    AppSound(name: 'Powerup', fileName: 'powerup.wav', type: SoundType.trigger),
    AppSound(name: 'Rooster', fileName: 'rooster.wav', type: SoundType.trigger),
    AppSound(name: 'Xylophone', fileName: 'mxylo2.ogg', type: SoundType.trigger),
    
    
    // Examples:
    // AppSound(name: 'Beep', fileName: 'beep.mp3', type: SoundType.trigger),
    // AppSound(name: 'Bell', fileName: 'bell.mp3', type: SoundType.trigger),
    // AppSound(name: 'Chime', fileName: 'chime.mp3', type: SoundType.trigger),
    // AppSound(name: 'Whistle', fileName: 'whistle.mp3', type: SoundType.trigger),
    // AppSound(name: 'Arcade', fileName: 'arcade.mp3', type: SoundType.trigger),
    // AppSound(name: 'Timer Start', fileName: 'timer_start.mp3', type: SoundType.trigger),
    AppSound(name: 'Fuse Burn', fileName: 'fuseburn.wav', type: SoundType.loop),
    AppSound(name: 'Low Alert', fileName: 'beep.ogg', type: SoundType.loop),
    // // --- Loops (For Fuses) ---
    // AppSound(name: 'Fuse Burn', fileName: 'fuseburn.wav', type: SoundType.loop),
    // AppSound(name: 'Ticking Clock', fileName: 'ticking.mp3', type: SoundType.loop),
    // AppSound(name: 'White Noise', fileName: 'whitenoise.mp3', type: SoundType.loop),
  ];

  // Getters for UI filtering
  static List<AppSound> get triggerSounds => 
      allSounds.where((s) => s.type == SoundType.trigger).toList();

  static List<AppSound> get loopSounds => 
      allSounds.where((s) => s.type == SoundType.loop).toList();

  // Helper to find sound by filename (for DB loading)
  static AppSound? getByFileName(String fileName) {
    try {
      return allSounds.firstWhere((s) => s.fileName == fileName);
    } catch (e) {
      return null;
    }
  }

  // Helper for human-readable display
  static String getDisplayName(String fileName) {
    final sound = getByFileName(fileName);
    return sound?.name ?? fileName;
  }
}