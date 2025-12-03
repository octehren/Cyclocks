import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for input formatters
import 'package:cyclocks/data/database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:cyclocks/helpers/sound_helper.dart';
import 'package:audioplayers/audioplayers.dart';

class CyclockEditScreen extends StatefulWidget {
  final AppDatabase database;
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Audio State Tracking
  PlayerState _playerState = PlayerState.stopped;
  String? _playingSoundFile;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;
  
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
    
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playerState = PlayerState.stopped);
    });

    if (widget.cyclock != null) {
      _nameController.text = widget.cyclock!.name;
      _repeatIndefinitely = widget.cyclock!.repeatIndefinitely;
      _hasFuse = widget.cyclock!.hasFuse;
      _fuseDuration = widget.cyclock!.fuseDuration;
      _fuseSound = widget.cyclock!.fuseSound;
      _loadExistingCyclock();
    } else {
      _addCycle(); 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleFuseSound() async {
    if (_playerState == PlayerState.playing && _playingSoundFile == _fuseSound) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.stop();
      _playingSoundFile = _fuseSound;

      final sound = SoundHelper.getByFileName(_fuseSound);
      if (sound?.type == SoundType.loop) {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      } else {
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      }
      await _audioPlayer.play(AssetSource('sounds/$_fuseSound'));
    }
  }

  Future<void> _previewTimerSound(String fileName) async {
    try {
      await _audioPlayer.stop();
      _playingSoundFile = fileName; 
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint("Error playing sound preview: $e");
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
        backgroundColor: Colors.blue,
        stages: [],
      );
      // New cycle starts with a "Work" timer, default 25m to be helpful
      newCycle.stages.add(TimerStageForm(
        name: 'Work',
        durationMinutes: 0,
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
        durationMinutes: 0, // No default value (0)
        durationSeconds: 0, // No default value (0)
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

    // VALIDATION: Check for timers < 5 seconds
    for (int i = 0; i < _cycles.length; i++) {
      for (int j = 0; j < _cycles[i].stages.length; j++) {
        final stage = _cycles[i].stages[j];
        final totalSeconds = (stage.durationMinutes * 60) + stage.durationSeconds;
        
        if (totalSeconds < 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer "${stage.name}" in Cycle ${i + 1} is too short (min 5s).'),
              backgroundColor: Colors.red,
            )
          );
          return; // Stop saving
        }
      }
    }

    int cyclockId;
    final palette = _cycles.map((c) => _getColorString(c.backgroundColor)).toSet().join(',');
    
    final companion = CyclocksCompanion(
      name: Value(_nameController.text),
      repeatIndefinitely: Value(_repeatIndefinitely),
      colorPalette: Value(palette),
      hasFuse: Value(_hasFuse),
      fuseDuration: Value(_fuseDuration),
      fuseSound: Value(_fuseSound),
    );

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
      await widget.database.cyclesDao.deleteCyclesForCyclock(cyclockId);
    } else {
      cyclockId = await widget.database.cyclocksDao.insertCyclock(companion);
    }

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
      body: Column(
        children: [
          // Global Settings in a fixed container or scrollable area if needed
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildGlobalSettings(),
          ),
          const Divider(thickness: 2, height: 1),
          // List takes the rest of the space
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 80, left: 16, right: 16, top: 16),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCycle,
        icon: const Icon(Icons.add_circle),
        label: const Text("Add Cycle"),
      ),
    );
  }

  Widget _buildGlobalSettings() {
    final isPlayingFuse = _playerState == PlayerState.playing && _playingSoundFile == _fuseSound;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Prevents expanding unnecessarily
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
                      min: 2, max: 60, // CHANGED: 2s to 60s
                      divisions: 58,   // CHANGED: 1s steps (60-2 = 58)
                      label: '$_fuseDuration s',
                      value: _fuseDuration.toDouble().clamp(2.0, 60.0), // Ensure value is within new bounds
                      onChanged: (v) => setState(() => _fuseDuration = v.toInt()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _fuseSound,
                underline: Container(),
                items: SoundHelper.loopSounds.map((s) {
                  return DropdownMenuItem(value: s.fileName, child: Text(s.name));
                }).toList(),
                onChanged: (v) => setState(() => _fuseSound = v!),
              ),
              IconButton(
                icon: Icon(isPlayingFuse ? Icons.pause_circle_filled : Icons.play_circle_fill),
                color: Theme.of(context).primaryColor,
                onPressed: _toggleFuseSound,
              )
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCycleCard(int index) {
    final cycle = _cycles[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      key: ValueKey(cycle),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: cycle.backgroundColor.withOpacity(isDark ? 0.15 : 0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cycle.backgroundColor, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  width: 70,
                  child: TextFormField(
                    initialValue: cycle.repeatCount.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Loops', isDense: true),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text("Color: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._availableColors.map((c) => InkWell(
                    onTap: () => setState(() => cycle.backgroundColor = c),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: cycle.backgroundColor == c 
                            ? Border.all(width: 2, color: isDark ? Colors.white : Colors.black) 
                            : null
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const Divider(),
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
        color: Theme.of(context).canvasColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  initialValue: stage.name,
                  decoration: const InputDecoration(
                    labelText: 'Task', 
                    isDense: true, 
                    contentPadding: EdgeInsets.all(12), 
                    border: OutlineInputBorder()
                  ),
                  onChanged: (v) => stage.name = v,
                ),
              ),
              const SizedBox(width: 8),
              
              // CHANGED: Minutes Text Box (0-240)
              SizedBox(
                width: 50,
                child: TextFormField(
                  initialValue: stage.durationMinutes.toString(),
                  keyboardType: TextInputType.number,
                  maxLength: 3, // Prevent overflow
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Min', 
                    counterText: "", // Hides the char counter
                    isDense: true, 
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4), 
                    border: OutlineInputBorder()
                  ),
                  onChanged: (v) {
                    int val = int.tryParse(v) ?? 0;
                    // Enforce 0-240
                    if (val > 240) val = 240;
                    if (val < 0) val = 0;
                    stage.durationMinutes = val;
                  },
                ),
              ),
              const SizedBox(width: 4),
              
              // CHANGED: Seconds Text Box (0-59)
              SizedBox(
                width: 45,
                child: TextFormField(
                  initialValue: stage.durationSeconds.toString(),
                  keyboardType: TextInputType.number,
                  maxLength: 2, // Prevent overflow
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Sec', 
                    counterText: "",
                    isDense: true, 
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4), 
                    border: OutlineInputBorder()
                  ),
                  onChanged: (v) {
                    int val = int.tryParse(v) ?? 0;
                    // Enforce 0-59
                    if (val > 59) val = 59;
                    if (val < 0) val = 0;
                    stage.durationSeconds = val;
                  },
                ),
              ),
              
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => setState(() => cycle.stages.removeAt(index)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(), // Compresses button size
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
               IconButton(
                 icon: const Icon(Icons.volume_up, size: 20, color: Colors.grey),
                 onPressed: () => _previewTimerSound(stage.sound),
                 tooltip: "Preview Sound",
               ),
               DropdownButton<String>(
                 value: stage.sound,
                 isDense: true,
                 underline: Container(),
                 style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
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