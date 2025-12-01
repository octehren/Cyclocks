import 'package:flutter/material.dart';
import 'package:cyclock/data/database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:cyclock/helpers/sound_helper.dart';

class CyclockEditScreen extends StatefulWidget {
  final AppDatabase database;
  // --- Null for creation, not null for editing. ---
  final Cyclock? cyclock;
  
  const CyclockEditScreen({
    super.key,
    required this.database,
    this.cyclock,
  });
  
  @override
  State<CyclockEditScreen> createState() => _CyclockEditScreenState();
}

class _CyclockEditScreenState extends State<CyclockEditScreen> {
  final _nameController = TextEditingController();
  
  // Cyclock Global Settings
  bool _repeatIndefinitely = false;
  bool _hasFuse = false;
  int _fuseDuration = 10;
  String _fuseSound = 'fuseburn.wav';

  List<CycleForm> _cycles = [];
  
  final List<Color> _availableColors = [
    Colors.red, Colors.green, Colors.blue, Colors.orange, 
    Colors.purple, Colors.pink, Colors.teal, Colors.amber, Colors.grey
  ];
  
  @override
  void initState() {
    super.initState();
    if (widget.cyclock != null) {
      _nameController.text = widget.cyclock!.name;
      _repeatIndefinitely = widget.cyclock!.repeatIndefinitely;
      _hasFuse = widget.cyclock!.hasFuse;
      _fuseDuration = widget.cyclock!.fuseDuration;
      _fuseSound = widget.cyclock!.fuseSound;
      _loadExistingCyclock();
    } else {
      _addCycle(); // Start with 1 empty cycle
    }
  }

  Future<void> _loadExistingCyclock() async {
    if (widget.cyclock == null) return;
    
    final dbCycles = await widget.database.cyclesDao.getCyclesForCyclock(widget.cyclock!.id);
    List<CycleForm> loadedCycles = [];
    
    for (var dbCycle in dbCycles) {
      final stages = await widget.database.timerStagesDao.getStagesForCycle(dbCycle.id);
      
      List<TimerStageForm> formStages = stages.map((s) => TimerStageForm(
        name: s.name,
        durationMinutes: s.durationSeconds ~/ 60,
        durationSeconds: s.durationSeconds % 60,
        color: _getColorFromString(s.color),
        sound: s.sound,
      )).toList();

      loadedCycles.add(CycleForm(
        name: dbCycle.name,
        repeatCount: dbCycle.repeatCount,
        backgroundColor: _getColorFromString(dbCycle.backgroundColor),
        stages: formStages,
      ));
    }

    setState(() {
      _cycles = loadedCycles;
    });
  }

  Color _getColorFromString(String colorString) {
    final map = {
      'red': Colors.red, 'green': Colors.green, 'blue': Colors.blue,
      'orange': Colors.orange, 'purple': Colors.purple, 'pink': Colors.pink,
      'teal': Colors.teal, 'amber': Colors.amber, 'grey': Colors.grey, 'darkblue': Colors.blue[900]
    };
    return map[colorString] ?? Colors.blue;
  }

  String _getColorString(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.green) return 'green';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.blue[900]) return 'darkblue';
    if (color == Colors.orange) return 'orange';
    if (color == Colors.purple) return 'purple';
    if (color == Colors.pink) return 'pink';
    if (color == Colors.teal) return 'teal';
    if (color == Colors.amber) return 'amber';
    if (color == Colors.grey) return 'grey';
    return 'blue';
  }

  void _addCycle() {
    setState(() {
      final newCycle = CycleForm(
        name: 'Cycle ${_cycles.length + 1}',
        repeatCount: 1,
        backgroundColor: Colors.blue.withOpacity(0.1),
        stages: [],
      );
      newCycle.stages.add(TimerStageForm(
        name: 'Work',
        durationMinutes: 25,
        durationSeconds: 0,
        color: Colors.red,
        sound: SoundHelper.triggerSounds[0].fileName,
      ));
      _cycles.add(newCycle);
    });
  }

  void _addTimerToCycle(int cycleIndex) {
    setState(() {
      _cycles[cycleIndex].stages.add(TimerStageForm(
        name: 'Timer',
        durationMinutes: 1,
        durationSeconds: 0,
        color: _availableColors[0],
        sound: SoundHelper.triggerSounds[0].fileName,
      ));
    });
  }

  Future<void> _saveCyclock() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a name')));
      return;
    }
    if (_cycles.any((c) => c.stages.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All cycles must have timers')));
      return;
    }

    int cyclockId;
    final palette = _cycles.map((c) => _getColorString(c.backgroundColor)).toSet().join(',');
    
    // 1. Prepare Data
    final companion = CyclocksCompanion(
      name: Value(_nameController.text),
      repeatIndefinitely: Value(_repeatIndefinitely),
      colorPalette: Value(palette),
      hasFuse: Value(_hasFuse),
      fuseDuration: Value(_fuseDuration),
      fuseSound: Value(_fuseSound),
    );

    // 2. Insert or Update Parent
    if (widget.cyclock != null) {
      cyclockId = widget.cyclock!.id;
      await widget.database.cyclocksDao.updateCyclock(widget.cyclock!.copyWith(
        name: _nameController.text,
        repeatIndefinitely: _repeatIndefinitely,
        colorPalette: palette,
        hasFuse: _hasFuse,
        fuseDuration: _fuseDuration,
        fuseSound: _fuseSound,
      ));
      // Clear old structure
      await widget.database.cyclesDao.deleteCyclesForCyclock(cyclockId);
    } else {
      cyclockId = await widget.database.cyclocksDao.insertCyclock(companion);
    }

    // 3. Insert Children
    for (int i = 0; i < _cycles.length; i++) {
      final cycleForm = _cycles[i];
      final cycleId = await widget.database.cyclesDao.insertCycle(CyclesCompanion(
        cyclockId: Value(cyclockId),
        orderIndex: Value(i),
        name: Value(cycleForm.name),
        repeatCount: Value(cycleForm.repeatCount),
        backgroundColor: Value(_getColorString(cycleForm.backgroundColor)),
      ));

      for (int j = 0; j < cycleForm.stages.length; j++) {
        final stage = cycleForm.stages[j];
        await widget.database.timerStagesDao.insertTimerStage(TimerStagesCompanion(
          cycleId: Value(cycleId),
          orderIndex: Value(j),
          name: Value(stage.name),
          durationSeconds: Value(stage.durationMinutes * 60 + stage.durationSeconds),
          color: Value(_getColorString(stage.color)),
          sound: Value(stage.sound),
        ));
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cyclock == null ? 'Create Cyclock' : 'Edit Cyclock'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveCyclock)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGlobalSettings(),
            const Divider(thickness: 2),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _cycles.length,
                onReorder: (oldIndex, newIndex) {
                   setState(() {
                    if (oldIndex < newIndex) newIndex -= 1;
                    final item = _cycles.removeAt(oldIndex);
                    _cycles.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) => _buildCycleCard(index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCycle,
        icon: const Icon(Icons.add_circle),
        label: const Text("Add Cycle"),
      ),
    );
  }

  Widget _buildGlobalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Cyclock Name', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Loop entire workout indefinitely?'),
          value: _repeatIndefinitely,
          onChanged: (v) => setState(() => _repeatIndefinitely = v),
          contentPadding: EdgeInsets.zero,
        ),
        
        // Fuse Settings
        SwitchListTile(
          title: const Text('Start with Fuse?'),
          subtitle: Text(_hasFuse ? '$_fuseDuration sec' : 'Off'),
          value: _hasFuse,
          onChanged: (v) => setState(() => _hasFuse = v),
          contentPadding: EdgeInsets.zero,
        ),
        if (_hasFuse) ...[
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fuse Duration'),
                    Slider(
                      min: 5, max: 120, divisions: 23,
                      label: '$_fuseDuration s',
                      value: _fuseDuration.toDouble(),
                      onChanged: (v) => setState(() => _fuseDuration = v.toInt()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Fuse Sound Dropdown (Loops only)
              DropdownButton<String>(
                value: _fuseSound,
                underline: Container(),
                // If current value isn't in loop list (e.g. imported legacy data), handle gracefully
                items: SoundHelper.loopSounds.map((s) {
                  return DropdownMenuItem(value: s.fileName, child: Text(s.name));
                }).toList(),
                onChanged: (v) => setState(() => _fuseSound = v!),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCycleCard(int index) {
    final cycle = _cycles[index];
    return Card(
      key: ValueKey(cycle),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cycle.backgroundColor, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle Header
            Row(
              children: [
                const Icon(Icons.drag_handle, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: cycle.name,
                    decoration: const InputDecoration(labelText: 'Cycle Name', isDense: true),
                    onChanged: (v) => cycle.name = v,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: cycle.repeatCount.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Repeats', isDense: true),
                    onChanged: (v) => cycle.repeatCount = int.tryParse(v) ?? 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => _cycles.removeAt(index)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Background Color Picker
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text("Cycle Color: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._availableColors.map((c) => InkWell(
                    onTap: () => setState(() => cycle.backgroundColor = c),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: cycle.backgroundColor == c ? Border.all(width: 2, color: Colors.black) : null
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const Divider(),
            // Timers
            ...cycle.stages.asMap().entries.map((entry) {
              return _buildTimerRow(cycle, entry.key, entry.value);
            }).toList(),
            
            Center(
              child: TextButton.icon(
                onPressed: () => _addTimerToCycle(index),
                icon: const Icon(Icons.add),
                label: const Text("Add Timer"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerRow(CycleForm cycle, int index, TimerStageForm stage) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: stage.name,
                  decoration: const InputDecoration(labelText: 'Task', isDense: true, contentPadding: EdgeInsets.all(12), border: OutlineInputBorder()),
                  onChanged: (v) => stage.name = v,
                ),
              ),
              const SizedBox(width: 8),
              // Duration
              SizedBox(
                width: 65,
                child: DropdownButtonFormField<int>(
                  value: stage.durationMinutes,
                  decoration: const InputDecoration(labelText: 'Min', isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
                  items: List.generate(60, (i) => DropdownMenuItem(value: i, child: Text('$i'))),
                  onChanged: (v) => setState(() => stage.durationMinutes = v!),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 65,
                child: DropdownButtonFormField<int>(
                  value: stage.durationSeconds,
                  decoration: const InputDecoration(labelText: 'Sec', isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
                  items: List.generate(60, (i) => DropdownMenuItem(value: i, child: Text('$i'))),
                  onChanged: (v) => setState(() => stage.durationSeconds = v!),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => setState(() => cycle.stages.removeAt(index)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
               ..._availableColors.take(5).map((c) => InkWell(
                  onTap: () => setState(() => stage.color = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 20, height: 20,
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: stage.color == c ? Border.all(width: 2) : null),
                  ),
               )),
               const Spacer(),
               const Icon(Icons.volume_up, size: 16, color: Colors.grey),
               const SizedBox(width: 4),
               // Timer Sound Dropdown (Triggers only)
               DropdownButton<String>(
                 value: stage.sound,
                 isDense: true,
                 underline: Container(),
                 style: const TextStyle(fontSize: 12, color: Colors.black),
                 items: SoundHelper.triggerSounds.map((s) {
                   return DropdownMenuItem(value: s.fileName, child: Text(s.name));
                 }).toList(),
                 onChanged: (v) => setState(() => stage.sound = v!),
               )
            ],
          )
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class CycleForm {
  String name;
  int repeatCount;
  Color backgroundColor;
  List<TimerStageForm> stages;
  CycleForm({required this.name, required this.repeatCount, required this.backgroundColor, required this.stages});
}

class TimerStageForm {
  String name;
  int durationMinutes;
  int durationSeconds;
  Color color;
  String sound;
  TimerStageForm({required this.name, required this.durationMinutes, required this.durationSeconds, required this.color, required this.sound});
}