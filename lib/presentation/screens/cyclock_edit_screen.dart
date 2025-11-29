import 'package:flutter/material.dart';
import 'package:cyclock/data/database.dart';
import 'package:drift/drift.dart' hide Column; // has same name as presentation widget

class CyclockEditScreen extends StatefulWidget {
  final AppDatabase database;
  final Cyclock? cyclock; // null for creation, not null for editing
  
  CyclockEditScreen({
    super.key,
    required this.database,
    this.cyclock,
  });
  
  @override
  State<CyclockEditScreen> createState() => _CyclockEditScreenState();
}

class _CyclockEditScreenState extends State<CyclockEditScreen> {
  final _nameController = TextEditingController();
  final _repeatCountController = TextEditingController(text: '1');
  
  // Cyclock properties
  bool _hasFuse = false;
  int _fuseDuration = 60; // seconds
  String _fuseSound = 'fuse_burning';
  bool _repeatIndefinitely = false;
  int _repeatCount = 1;
  
  // Timer stages
  final List<TimerStageForm> _timerStages = [];
  
  // Available colors for timers
  final List<Color> _availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];
  
  // Available sounds
  final List<String> _availableSounds = [
    'timer_start',
    'bell',
    'chime',
    'beep',
    'alarm',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cyclock != null) {
      _nameController.text = widget.cyclock!.name;
      _repeatCountController.text = widget.cyclock!.repeatCount.toString();
      _repeatIndefinitely = widget.cyclock!.repeatIndefinitely;
      _loadExistingCyclock();
    } else {
      // Add one default timer stage for new cyclocks
      _timerStages.add(TimerStageForm(
        name: 'Timer 1',
        durationMinutes: 1,
        durationSeconds: 0,
        color: _availableColors[0],
        sound: _availableSounds[0],
      ));
    }
  }

  Future<void> _loadExistingCyclock() async {
    if (widget.cyclock == null) return;
    
    // accessing TimerStagesDao
    final stages = await widget.database.timerStagesDao.getStagesForCyclock(widget.cyclock!.id);
    
    setState(() {
      for (int i = 0; i < stages.length; i++) {
        final stage = stages[i];
        if (stage.isFuse) {
          _hasFuse = true;
          _fuseDuration = stage.durationSeconds;
          _fuseSound = stage.sound;
        } else {
          _timerStages.add(TimerStageForm(
            name: stage.name,
            durationMinutes: stage.durationSeconds ~/ 60,
            durationSeconds: stage.durationSeconds % 60,
            color: _getColorFromString(stage.color),
            sound: stage.sound,
          ));
        }
      }
    });
  }

  Color _getColorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red': return Colors.red;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'orange': return Colors.orange;
      case 'purple': return Colors.purple;
      case 'pink': return Colors.pink;
      case 'teal': return Colors.teal;
      case 'amber': return Colors.amber;
      default: return Colors.blue;
    }
  }

  String _getColorString(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.green) return 'green';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.orange) return 'orange';
    if (color == Colors.purple) return 'purple';
    if (color == Colors.pink) return 'pink';
    if (color == Colors.teal) return 'teal';
    if (color == Colors.amber) return 'amber';
    return 'blue';
  }

  void _addTimerStage() {
    setState(() {
      _timerStages.add(TimerStageForm(
        name: 'Timer ${_timerStages.length + 1}',
        durationMinutes: 1,
        durationSeconds: 0,
        color: _availableColors[_timerStages.length % _availableColors.length],
        sound: _availableSounds[0],
      ));
    });
  }

  void _removeTimerStage(int index) {
    setState(() {
      _timerStages.removeAt(index);
      // Update names
      for (int i = 0; i < _timerStages.length; i++) {
        _timerStages[i].name = 'Timer ${i + 1}';
      }
    });
  }

  void _moveTimerStageUp(int index) {
    if (index > 0) {
      setState(() {
        final temp = _timerStages[index];
        _timerStages[index] = _timerStages[index - 1];
        _timerStages[index - 1] = temp;
      });
    }
  }

  void _moveTimerStageDown(int index) {
    if (index < _timerStages.length - 1) {
      setState(() {
        final temp = _timerStages[index];
        _timerStages[index] = _timerStages[index + 1];
        _timerStages[index + 1] = temp;
      });
    }
  }

  Future<void> _saveCyclock() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for the cyclock')),
      );
      return;
    }

    if (_timerStages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one timer stage')),
      );
      return;
    }

    try {
      final cyclockId = await _saveCyclockData();
      await _saveTimerStages(cyclockId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cyclock saved successfully!')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving cyclock: $e')),
      );
    }
  }

  Future<int> _saveCyclockData() async {
    if (widget.cyclock != null) {
      // Update existing cyclock
      await widget.database.cyclocksDao.updateCyclock(widget.cyclock!.copyWith(
        name: _nameController.text,
        repeatCount: _repeatIndefinitely ? 1 : _repeatCount,
        repeatIndefinitely: _repeatIndefinitely,
        colorPalette: _getColorPaletteString(),
      ));
      return widget.cyclock!.id;
    } else {
      // Create new cyclock
      return await widget.database.cyclocksDao.insertCyclock(CyclocksCompanion(
        name: Value(_nameController.text),
        isDefault: const Value(false),
        repeatCount: Value(_repeatIndefinitely ? 1 : _repeatCount),
        repeatIndefinitely: Value(_repeatIndefinitely),
        colorPalette: Value(_getColorPaletteString()),
      ));
    }
  }

  String _getColorPaletteString() {
    final colors = _timerStages.map((stage) => _getColorString(stage.color)).toList();
    return colors.join(',');
  }

  Future<void> _saveTimerStages(int cyclockId) async {
    // Delete existing stages if saving after editing
    // accessing TimerStagesDao to clean up old stages
    if (widget.cyclock != null) {
       await widget.database.timerStagesDao.deleteStagesForCyclock(cyclockId);
    }

    int orderIndex = 0;

    // Save fuse if enabled
    if (_hasFuse) {
      // accessing TimerStagesDao
      await widget.database.timerStagesDao.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(orderIndex++),
        name: const Value('Fuse'),
        durationSeconds: Value(_fuseDuration),
        color: const Value('red'), 
        sound: Value(_fuseSound),
        isFuse: const Value(true),
      ));
    }

    // Save timer stages
    for (int i = 0; i < _timerStages.length; i++) {
      final stage = _timerStages[i];
      // accessing TimerStagesDao
      await widget.database.timerStagesDao.insertTimerStage(TimerStagesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(orderIndex++),
        name: Value(stage.name),
        durationSeconds: Value(stage.durationMinutes * 60 + stage.durationSeconds),
        color: Value(_getColorString(stage.color)),
        sound: Value(stage.sound),
        isFuse: const Value(false),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cyclock == null ? 'Create Cyclock' : 'Edit Cyclock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCyclock,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Cyclock Name
            _buildNameSection(),
            const SizedBox(height: 24),
            
            // Fuse Configuration
            _buildFuseSection(),
            const SizedBox(height: 24),
            
            // Timer Stages
            _buildTimerStagesSection(),
            const SizedBox(height: 24),
            
            // Repeat Settings
            _buildRepeatSection(),
            const SizedBox(height: 32),
            
            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cyclock Name',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter cyclock name',
            labelText: 'Name',
          ),
        ),
      ],
    );
  }

  Widget _buildFuseSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fireplace_outlined, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Fuse Timer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                  value: _hasFuse,
                  onChanged: (value) {
                    setState(() {
                      _hasFuse = value;
                    });
                  },
                ),
              ],
            ),
            if (_hasFuse) ...[
              const SizedBox(height: 16),
              const Text('Fuse Duration:'),
              Slider(
                value: _fuseDuration.toDouble(),
                min: 5,
                max: 300,
                divisions: 59,
                label: '${_fuseDuration}s',
                onChanged: (value) {
                  setState(() {
                    _fuseDuration = value.toInt();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${_fuseDuration} seconds'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Fuse Sound:'),
              DropdownButton<String>(
                value: _fuseSound,
                isExpanded: true,
                items: _availableSounds.map((String sound) {
                  return DropdownMenuItem<String>(
                    value: sound,
                    child: Text(_formatSoundName(sound)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _fuseSound = newValue!;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimerStagesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Timer Stages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _addTimerStage,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Timer'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_timerStages.isEmpty)
              const Center(
                child: Text(
                  'No timer stages added',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ..._timerStages.asMap().entries.map((entry) {
                final index = entry.key;
                final stage = entry.value;
                return _buildTimerStageCard(index, stage);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerStageCard(int index, TimerStageForm stage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: stage.color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: stage.name),
                    decoration: const InputDecoration(
                      labelText: 'Timer Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        stage.name = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Color Picker
                PopupMenuButton<Color>(
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: stage.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                  itemBuilder: (context) => _availableColors.map((color) {
                    return PopupMenuItem<Color>(
                      value: color,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    );
                  }).toList(),
                  onSelected: (Color color) {
                    setState(() {
                      stage.color = color;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Duration:'),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<int>(
                              value: stage.durationMinutes,
                              isExpanded: true,
                              items: List.generate(60, (i) => i)
                                  .map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value minutes'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  stage.durationMinutes = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<int>(
                              value: stage.durationSeconds,
                              isExpanded: true,
                              items: List.generate(60, (i) => i)
                                  .map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value seconds'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  stage.durationSeconds = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sound:'),
                      DropdownButton<String>(
                        value: stage.sound,
                        isExpanded: true,
                        items: _availableSounds.map((String sound) {
                          return DropdownMenuItem<String>(
                            value: sound,
                            child: Text(_formatSoundName(sound)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            stage.sound = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () => _moveTimerStageUp(index),
                  tooltip: 'Move Up',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () => _moveTimerStageDown(index),
                  tooltip: 'Move Down',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeTimerStage(index),
                  tooltip: 'Delete Timer',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Repeat Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Repeat Indefinitely'),
                const Spacer(),
                Switch(
                  value: _repeatIndefinitely,
                  onChanged: (value) {
                    setState(() {
                      _repeatIndefinitely = value;
                    });
                  },
                ),
              ],
            ),
            if (!_repeatIndefinitely) ...[
              const SizedBox(height: 16),
              const Text('Number of Cycles:'),
              TextField(
                controller: _repeatCountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter number of cycles',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _repeatCount = int.tryParse(value) ?? 1;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _saveCyclock,
      icon: const Icon(Icons.save),
      label: const Text(
        'Save Cyclock',
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  String _formatSoundName(String sound) {
    return sound.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _repeatCountController.dispose();
    super.dispose();
  }
}

class TimerStageForm {
  String name;
  int durationMinutes;
  int durationSeconds;
  Color color;
  String sound;

  TimerStageForm({
    required this.name,
    required this.durationMinutes,
    required this.durationSeconds,
    required this.color,
    required this.sound,
  });
}