// ==============================================================================
// FILE: presentation/screens/cyclock_edit_screen.dart
// 
// PURPOSE:
// This screen handles the creation and editing of "Cyclocks" (workouts/timers).
// It manages a complex form state including:
// - Global settings (Name, Loop indefinitely, Fuse/Warmup)
// - A list of Cycles (Reorderable)
// - A list of Timers per Cycle
// - Audio previewing and selection
// - Database persistence (Insert/Update)
// ==============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For limiting input to digits
import 'package:cyclocks/data/database.dart';
import 'package:drift/drift.dart' show Value; // Drift helper for SQL values
import 'package:cyclocks/helpers/sound_helper.dart';
import 'package:audioplayers/audioplayers.dart';

class CyclockEditScreen extends StatefulWidget {
  final AppDatabase database;
  // If null, we are creating a new Cyclock. If provided, we are editing.
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
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------
  
  // Controllers
  final _nameController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Audio Playback State (for Fuse toggle and preview icons)
  PlayerState _playerState = PlayerState.stopped;
  String? _playingSoundFile; // Tracks which specific file is currently playing
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;
  
  // Form Data: Global Settings
  bool _repeatIndefinitely = false;
  bool _hasFuse = false;
  int _fuseDuration = 10;
  String _fuseSound = 'fuseburn.wav';

  // Form Data: The structural hierarchy (List of Cycles -> List of Timers)
  List<CycleForm> _cycles = [];
  
  // Constant palette for UI selection
  final List<Color> _availableColors = [
    Colors.red, Colors.green, Colors.blue, Colors.orange, 
    Colors.purple, Colors.pink, Colors.teal, Colors.amber, Colors.grey
  ];
  
  // ---------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // ---------------------------------------------------------------------------
  
  @override
  void initState() {
    super.initState();
    
    // 1. Setup Audio Listeners to update UI icons when sound starts/stops
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playerState = PlayerState.stopped);
    });

    // 2. Load Data if editing, or initialize defaults if creating
    if (widget.cyclock != null) {
      _nameController.text = widget.cyclock!.name;
      _repeatIndefinitely = widget.cyclock!.repeatIndefinitely;
      _hasFuse = widget.cyclock!.hasFuse;
      _fuseDuration = widget.cyclock!.fuseDuration;
      _fuseSound = widget.cyclock!.fuseSound;
      _loadExistingCyclock();
    } else {
      _addCycle(); // Start with one empty cycle for convenience
    }
  }

  @override
  void dispose() {
    // Clean up controllers and streams to prevent memory leaks
    _nameController.dispose();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // AUDIO LOGIC
  // ---------------------------------------------------------------------------

  // Handles the Play/Pause logic for the Fuse sound in Global Settings
  Future<void> _toggleFuseSound() async {
    // If clicking the button while THIS sound is playing, stop it.
    if (_playerState == PlayerState.playing && _playingSoundFile == _fuseSound) {
      await _audioPlayer.stop();
    } else {
      // Stop any other sound, setup this one
      await _audioPlayer.stop();
      _playingSoundFile = _fuseSound;

      final sound = SoundHelper.getByFileName(_fuseSound);
      // Fuses typically loop, so check metadata
      if (sound?.type == SoundType.loop) {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      } else {
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      }
      await _audioPlayer.play(AssetSource('sounds/$_fuseSound'));
    }
  }

  // Plays a short preview of a timer sound (Trigger type)
  Future<void> _previewTimerSound(String fileName) async {
    try {
      await _audioPlayer.stop();
      _playingSoundFile = fileName; 
      await _audioPlayer.setReleaseMode(ReleaseMode.stop); // Triggers play once
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint("Error playing sound preview: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // DATA LOADING & PARSING
  // ---------------------------------------------------------------------------

  // Fetches data from Drift DB and populates the local _cycles list
  Future<void> _loadExistingCyclock() async {
    if (widget.cyclock == null) return;
    
    // 1. Get Cycles
    final dbCycles = await widget.database.cyclesDao.getCyclesForCyclock(widget.cyclock!.id);
    List<CycleForm> loadedCycles = [];
    
    for (var dbCycle in dbCycles) {
      // 2. Get Timers for each Cycle
      final stages = await widget.database.timerStagesDao.getStagesForCycle(dbCycle.id);
      
      // 3. Map DB objects to Form objects
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

  // Helper: String -> Color object
  Color _getColorFromString(String colorString) {
    final map = {
      'red': Colors.red, 'green': Colors.green, 'blue': Colors.blue,
      'orange': Colors.orange, 'purple': Colors.purple, 'pink': Colors.pink,
      'teal': Colors.teal, 'amber': Colors.amber, 'grey': Colors.grey, 'darkblue': Colors.blue[900]
    };
    return map[colorString] ?? Colors.blue;
  }

  // Helper: Color object -> String (for DB storage)
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

  // ---------------------------------------------------------------------------
  // FORM MANIPULATION (CRUD on local list)
  // ---------------------------------------------------------------------------

  void _addCycle() {
    setState(() {
      final newCycle = CycleForm(
        name: 'Cycle ${_cycles.length + 1}',
        repeatCount: 1,
        backgroundColor: Colors.blue, // Default color
        stages: [],
      );
      // Auto-add a default timer so the cycle isn't empty
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
        durationMinutes: 0, // Explicitly 0 to force user input
        durationSeconds: 0,
        color: _availableColors[0],
        sound: SoundHelper.triggerSounds[0].fileName,
      ));
    });
  }

  // ---------------------------------------------------------------------------
  // SAVE LOGIC (Persistence)
  // ---------------------------------------------------------------------------

  Future<void> _saveCyclock() async {
    // 1. Basic Validation
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a name')));
      return;
    }
    if (_cycles.any((c) => c.stages.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All cycles must have timers')));
      return;
    }

    // 2. Deep Validation (Duration Limits)
    for (int i = 0; i < _cycles.length; i++) {
      for (int j = 0; j < _cycles[i].stages.length; j++) {
        final stage = _cycles[i].stages[j];
        final totalSeconds = (stage.durationMinutes * 60) + stage.durationSeconds;
        
        // Min Duration Check
        if (totalSeconds < 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer "${stage.name}" in Cycle ${i + 1} is too short (min 5s).'),
              backgroundColor: Colors.red,
            )
          );
          return;
        }

        // Max Duration Check (Requested Feature)
        // 240 minutes * 60 seconds = 14,400 seconds
        if (totalSeconds > 14400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer "${stage.name}" in Cycle ${i + 1} is too long (max 240 min).'),
              backgroundColor: Colors.red,
            )
          );
          return;
        }
      }
    }

    // 3. Prepare Cyclock Data
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

    // 4. Update or Insert Parent (Cyclock)
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
      // Cascade delete strategy: wipe children and re-insert
      await widget.database.cyclesDao.deleteCyclesForCyclock(cyclockId);
    } else {
      cyclockId = await widget.database.cyclocksDao.insertCyclock(companion);
    }

    // 5. Insert Children (Cycles & Timers)
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

  // ---------------------------------------------------------------------------
  // WIDGET BUILDER
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cyclock == null ? 'Create Cyclock' : 'Edit Cyclock'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveCyclock)],
      ),
      body: Column(
        children: [
          // Section 1: Global Settings (Name, Fuse, Loop)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildGlobalSettings(),
          ),
          const Divider(thickness: 2, height: 1),
          
          // Section 2: Reorderable List of Cycles
          Expanded(
            child: ReorderableListView.builder(
              // IMPORTANT: Disable default drag handles to allow custom placement
              buildDefaultDragHandles: false,
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

  // Helper: Builds the upper form section
  Widget _buildGlobalSettings() {
    final isPlayingFuse = _playerState == PlayerState.playing && _playingSoundFile == _fuseSound;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                    // Slider Logic: 2s to 60s, 1s steps
                    Slider(
                      min: 2, max: 60,
                      divisions: 58,
                      label: '$_fuseDuration s',
                      value: _fuseDuration.toDouble().clamp(2.0, 60.0),
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

  // Helper: Builds an individual Cycle Card (Container for timers)
  Widget _buildCycleCard(int index) {
    final cycle = _cycles[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      key: ValueKey(cycle), // Required for reordering
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      // Visual: Card background tint matches cycle color
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
            // Row 1: Drag Handle (Left) | Name | Loop Count | Delete
            Row(
              children: [
                // Custom Reorder Listener applied specifically to this icon
                ReorderableDragStartListener(
                  index: index,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.drag_handle, color: Colors.grey),
                  ),
                ),
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
            
            // Row 2: Color Palette Picker
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
                        // Selection indicator (border)
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
            
            // Row 3+: Timers list
            ...cycle.stages.asMap().entries.map((entry) {
              return _buildTimerRow(cycle, entry.key, entry.value);
            }).toList(),
            
            // Bottom: Add Timer Button
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

  // Helper: Builds an individual Timer input row
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
          // Row A: Task Name | Min | Sec | Delete
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
              
              // Min Input: 0-240
              SizedBox(
                width: 50,
                child: TextFormField(
                  initialValue: stage.durationMinutes.toString(),
                  keyboardType: TextInputType.number,
                  maxLength: 3, 
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Min', 
                    counterText: "",
                    isDense: true, 
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4), 
                    border: OutlineInputBorder()
                  ),
                  onChanged: (v) {
                    int val = int.tryParse(v) ?? 0;
                    if (val > 240) val = 240;
                    if (val < 0) val = 0;
                    stage.durationMinutes = val;
                  },
                ),
              ),
              const SizedBox(width: 4),
              
              // Sec Input: 0-59
              SizedBox(
                width: 45,
                child: TextFormField(
                  initialValue: stage.durationSeconds.toString(),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
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
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Row B: Color Picker | Sound Preview | Sound Picker
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

// ---------------------------------------------------------------------------
// HELPER CLASSES (Form Data Models)
// ---------------------------------------------------------------------------

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