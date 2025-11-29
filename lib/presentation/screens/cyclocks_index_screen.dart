import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyclock/data/database.dart';
import 'package:cyclock/providers/settings_provider.dart';
import 'package:cyclock/presentation/screens/cyclock_running_screen.dart';
import 'package:cyclock/presentation/screens/settings_screen.dart';
import 'package:cyclock/presentation/screens/cyclock_edit_screen.dart';

class CyclocksIndexScreen extends StatefulWidget {
  final AppDatabase database;
  
  const CyclocksIndexScreen({super.key, required this.database});
  
  @override
  State<CyclocksIndexScreen> createState() => _CyclocksIndexScreenState();
}

class _CyclocksIndexScreenState extends State<CyclocksIndexScreen> {
  List<Cyclock> _cyclocks = [];
  
  @override
  void initState() {
    super.initState();
    _loadCyclocks();
  }
  
  Future<void> _loadCyclocks() async {
    final cyclocks = await widget.database.getAllCyclocks();
    setState(() {
      _cyclocks = cyclocks;
    });
  }
  
  int _getCrossAxisCount(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    
    if (orientation == Orientation.landscape) {
      if (width > 1200) return 4;
      if (width > 800) return 3;
      return 2;
    } else {
      return 3;
    }
  }
  
  Color _getPrimaryColor(String colorPalette) {
    try {
      // Simple color mapping - you can enhance this with JSON parsing
      if (colorPalette.contains('red')) return Colors.red;
      if (colorPalette.contains('blue')) return Colors.blue;
      if (colorPalette.contains('pink')) return Colors.pink;
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = _getCrossAxisCount(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyclock'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(database: widget.database),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: _cyclocks.length + 1, // +1 for add button
        itemBuilder: (context, index) {
          if (index == _cyclocks.length) {
            // Add new cyclock button
            return _buildAddCyclockButton();
          } else {
            final cyclock = _cyclocks[index];
            return _buildCyclockCard(cyclock);
          }
        },
      ),
    );
  }
  
  Widget _buildCyclockCard(Cyclock cyclock) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CyclockRunningScreen(
                database: widget.database,
                cyclock: cyclock,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getPrimaryColor(cyclock.colorPalette),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timer,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cyclock.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (cyclock.isDefault) ...[
              const SizedBox(height: 4),
              Text(
                'Default',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddCyclockButton() {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          // Navigate to create cyclock screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CyclockEditScreen(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Add Cyclock',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}