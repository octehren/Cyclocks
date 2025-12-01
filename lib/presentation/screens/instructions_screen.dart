import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How to Use Cyclock',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              number: 1,
              title: 'What Are Cyclocks?',
              description: 'A cyclock is a set of cycles, and a cycle is a set of timers. For example, suppose a person will use the Pomodoro technique to structure a moment of focused work, in 3 bursts of 25 minutes of work followed by 5 minutes of rest and then a final burst of 25 minutes of work followed by 30 minutes of rest. This will be represented by 3 cycles of a 25 minutes timer followed by a 5 minutes one, and then one cycle of a 25 minutes timer followed by a 30 minutes one.',
            ),
            _buildInstructionStep(
              number: 2,
              title: 'Browse Cyclocks',
              description: 'On the main screen, you can see all your available cyclocks. Tap any cyclock to start it.',
            ),
            
            _buildInstructionStep(
              number: 3,
              title: 'Create Custom Cyclocks',
              description: 'Tap the "+" button to create your own cyclock with custom cycles and timers.',
            ),
            
            _buildInstructionStep(
              number: 4,
              title: 'Cyclock Structure',
              description: 'Each cyclock consists of an optional fuse timer and one or more cycles, each with one or more timers. Every timer can be assigned a custom sound on its beginning',
            ),
            
            _buildInstructionStep(
              number: 5,
              title: 'Fuse Timer',
              description: 'The fuse is an initial countdown to kickstart the cycles. It plays a sound in loop.',
            ),
            
            _buildInstructionStep(
              number: 6,
              title: 'Timer Stages',
              description: 'Each timer stage can have its own duration, color, and trigger sound.',
            ),
            
            _buildInstructionStep(
              number: 7,
              title: 'Cycles',
              description: 'Set how many times the timer sequence should repeat, or set it to repeat indefinitely.',
            ),
            
            _buildInstructionStep(
              number: 8,
              title: 'Running Cyclocks',
              description: 'During execution, you can see visual representations of time remaining for each timer. You can also set individualized properties for each cyclock.',
            ),
            
            _buildInstructionStep(
              number: 9,
              title: 'Settings',
              description: 'Access settings to toggle dark mode, change language, export/import data, and read instructions.',
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Default Cyclocks:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            _buildDefaultCyclockInfo(
              name: 'Pomodoro',
              description: '60s fuse, 3 cycles of 25min work + 5min break, final cycle of 25min work + 30min break',
            ),
            
            _buildDefaultCyclockInfo(
              name: 'Squats',
              description: '10s fuse, 2 cycles of 2min exercise + 30s rest, final 2min exercise',
            ),
            
            _buildDefaultCyclockInfo(
              name: 'Stretching',
              description: '10s fuse, 5 cycles of 45s stretch + 15s pause, final 45s stretch',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInstructionStep({
    required int number,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDefaultCyclockInfo({
    required String name,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}