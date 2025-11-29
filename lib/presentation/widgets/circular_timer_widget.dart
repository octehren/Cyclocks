import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class CircularTimerWidget extends StatelessWidget {
  final int durationSeconds;
  final String color;
  final VoidCallback? onComplete;
  final bool autoStart;
  
  const CircularTimerWidget({
    super.key,
    required this.durationSeconds,
    required this.color,
    this.onComplete,
    this.autoStart = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      duration: durationSeconds,
      initialDuration: 0,
      controller: CountDownController(),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      ringColor: Colors.grey[300]!,
      fillColor: _parseColor(color),
      backgroundColor: Colors.transparent,
      strokeWidth: 10.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
        fontSize: 33.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: autoStart,
      onComplete: onComplete,
    );
  }
  
  Color _parseColor(String colorString) {
    // Implement your color parsing logic
    switch (colorString) {
      case 'red': return Colors.red;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'pink': return Colors.pink;
      default: return Colors.blue;
    }
  }
}