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
        // --- Loops (For Fuses) ---
    AppSound(name: 'Alert', fileName: 'low_beep.wav', type: SoundType.loop),
    AppSound(name: 'Fuse Burn', fileName: 'fuseburn.wav', type: SoundType.loop),
    AppSound(name: 'Static TV', fileName: 'teevea.wav', type: SoundType.loop),
    // // --- Triggers (For Timer Stages) ---
    AppSound(name: 'Beep x3', fileName: 'soundCountdown.wav', type: SoundType.trigger),
    AppSound(name: 'Ding', fileName: 'ding_bellboy.wav', type: SoundType.trigger),
    AppSound(name: 'Double Ding', fileName: 'ding_double_bellboy.wav', type: SoundType.trigger),
    AppSound(name: 'Game On!', fileName: 'soundGameOn.wav', type: SoundType.trigger),
    AppSound(name: 'Hit, Crowd Cheers', fileName: 'soundHitCrowdCheer.wav', type: SoundType.trigger),
    AppSound(name: 'Powerup', fileName: 'powerup.wav', type: SoundType.trigger),
    AppSound(name: 'Rooster', fileName: 'rooster.wav', type: SoundType.trigger),
    AppSound(name: 'Unfolding', fileName: 'soundBallMedium.wav', type: SoundType.trigger),
    AppSound(name: 'Xylophone', fileName: 'mxylo2.wav', type: SoundType.trigger),
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