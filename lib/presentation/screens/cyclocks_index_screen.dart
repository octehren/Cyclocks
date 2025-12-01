import 'package:flutter/material.dart';
import 'package:cyclock/data/database.dart';
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
    final cyclocks = await widget.database.cyclocksDao.getAllCyclocks();
    setState(() {
      _cyclocks = cyclocks;
    });
  }

  // Added: Helper to confirm and execute deletion
  Future<void> _confirmDelete(Cyclock cyclock) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cyclock?'),
        content: Text('Are you sure you want to delete "${cyclock.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Execute as a transaction to ensure stages are deleted with the cyclock
      await widget.database.transaction(() async {
        await widget.database.timerStagesDao.deleteStagesForCyclock(cyclock.id);
        await widget.database.cyclocksDao.deleteCyclock(cyclock);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cyclock.name} deleted')),
        );
        _loadCyclocks();
      }
    }
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
              ).then((_) => _loadCyclocks()); // Refresh in case data changed in settings
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
      clipBehavior: Clip.antiAlias, // Ensures the InkWell and Menu don't overflow rounded corners
      child: Stack(
        children: [
          // 1. Main Action: Tap to Run
          Positioned.fill(
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
                ).then((_) => _loadCyclocks());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50, 
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getPrimaryColor(cyclock.colorPalette),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cyclock.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
            ),
          ),

          // 2. Secondary Action: Top Right Menu
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[600]),
              tooltip: 'Options',
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CyclockEditScreen(
                        database: widget.database,
                        cyclock: cyclock,
                      ),
                    ),
                  ).then((_) => _loadCyclocks());
                } else if (value == 'delete') {
                  _confirmDelete(cyclock);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20, color: Colors.grey),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddCyclockButton() {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CyclockEditScreen(
                database: widget.database,
              ),
            ),
          ).then((_) => _loadCyclocks());
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