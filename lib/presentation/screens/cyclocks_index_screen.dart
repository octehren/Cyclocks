import 'package:flutter/material.dart';
import 'package:cyclocks/data/database.dart';
import 'package:cyclocks/presentation/screens/cyclock_running_screen.dart';
import 'package:cyclocks/presentation/screens/settings_screen.dart';
import 'package:cyclocks/presentation/screens/cyclock_edit_screen.dart';

class CyclocksIndexScreen extends StatefulWidget {
  final AppDatabase database;
  
  const CyclocksIndexScreen({super.key, required this.database});
  
  @override
  State<CyclocksIndexScreen> createState() => _CyclocksIndexScreenState();
}

class _CyclocksIndexScreenState extends State<CyclocksIndexScreen> {
  List<Cyclock> _cyclocks = [];
  Map<int, List<Color>> _cyclockColors = {}; // Maps Cyclock ID to [MainColor, SecondaryColor]
  
  @override
  void initState() {
    super.initState();
    _loadCyclocks();
  }
  
  Future<void> _loadCyclocks() async {
    final cyclocks = await widget.database.cyclocksDao.getAllCyclocks();
    
    // Calculate color stats for each cyclock
    final Map<int, List<Color>> colorStats = {};
    
    for (var cyclock in cyclocks) {
      final cycles = await widget.database.cyclesDao.getCyclesForCyclock(cyclock.id);
      final Map<String, int> colorCounts = {};
      
      for (var cycle in cycles) {
        // Count cycle background color
        colorCounts[cycle.backgroundColor] = (colorCounts[cycle.backgroundColor] ?? 0) + 1;
        
        // Count stage colors
        final stages = await widget.database.timerStagesDao.getStagesForCycle(cycle.id);
        for (var stage in stages) {
          colorCounts[stage.color] = (colorCounts[stage.color] ?? 0) + 1;
        }
      }
      
      // Sort colors by frequency
      var sortedEntries = colorCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)); // Descending order
        
      Color mainColor;
      Color secondaryColor;
      
      if (sortedEntries.isEmpty) {
        mainColor = Colors.grey;
        secondaryColor = Colors.blueGrey;
      } else {
        mainColor = _parseColor(sortedEntries[0].key);
        if (sortedEntries.length > 1) {
          secondaryColor = _parseColor(sortedEntries[1].key);
        } else {
          // If only one color is used, derive a lighter/darker shade or use white
          secondaryColor = Colors.white.withOpacity(0.5); 
        }
      }
      
      colorStats[cyclock.id] = [mainColor, secondaryColor];
    }

    if (mounted) {
      setState(() {
        _cyclocks = cyclocks;
        _cyclockColors = colorStats;
      });
    }
  }

  Color _parseColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red': return Colors.red;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'pink': return Colors.pink;
      case 'grey': return Colors.grey;
      case 'orange': return Colors.orange;
      case 'purple': return Colors.purple;
      case 'teal': return Colors.teal;
      case 'amber': return Colors.amber;
      case 'darkblue': return Colors.blue[900]!;
      default: return Colors.blue;
    }
  }

  Color _getContrastingColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark 
        ? Colors.white 
        : Colors.black;
  }

  // Helper to confirm and execute deletion
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
      await widget.database.transaction(() async {
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
  
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = _getCrossAxisCount(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyclocks'),
        // Use Theme default colors for consistency
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(database: widget.database),
                ),
              ).then((_) => _loadCyclocks());
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
        itemCount: _cyclocks.length + 1,
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
    // Get calculated colors or fallback
    final colors = _cyclockColors[cyclock.id] ?? [Colors.grey, Colors.blueGrey];
    final cardColor = colors[0];
    final iconBgColor = colors[1];
    final textColor = _getContrastingColor(cardColor);
    final iconGlyphColor = _getContrastingColor(iconBgColor);

    return Card(
      elevation: 4,
      color: cardColor, // 1. Most used color fills the card
      clipBehavior: Clip.antiAlias,
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
                        color: iconBgColor, // 2. Second most used color fills the icon background
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                        ]
                      ),
                      child: Icon(
                        Icons.timer,
                        color: iconGlyphColor, // Ensure icon is visible
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cyclock.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Ensure text is visible
                      ),
                    ),
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
              icon: Icon(Icons.more_vert, size: 20, color: textColor.withOpacity(0.7)),
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
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 20, color: Colors.red),
                      const SizedBox(width: 12),
                      const Text('Delete', style: TextStyle(color: Colors.red)),
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
      // Use theme surface color for the 'Add' button to distinguish it
      color: Theme.of(context).cardColor, 
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
          children: [
            Icon(
              Icons.add,
              size: 40,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5) ?? Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Cyclock',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}