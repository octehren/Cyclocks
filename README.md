# cyclock

A new Flutter project.

Reset DB:
```bash
dart run build_runner build --delete-conflicting-outputs
```
## PLUGINS (In Systems)
- Play audio on Linux, needs GStreamer plugins.
Examples: 
```bash
# Debian-based:
sudo apt-get update
sudo apt-get install -y \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  gstreamer1.0-tools \
  gstreamer1.0-x \
  gstreamer1.0-alsa \
  gstreamer1.0-gl \
  gstreamer1.0-gtk3

# Fedora
sudo dnf install \
  gstreamer1-plugins-base \
  gstreamer1-plugins-good \
  gstreamer1-plugins-bad-free \
  gstreamer1-plugins-bad-free-extras \
  gstreamer1-plugins-bad-freeworld \
  gstreamer1-plugins-ugly \
  gstreamer1-libav
# Arch
sudo pacman -S gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
```
## SUMARRY OF CHANGES
- 04-Cyclock-Settings-Implementation
  Further customize cyclocks with settings,like:
  - Focus mode (only shows timer running, no description)
  - Clean mode (shows timer running & description of current task)
  - Full mode (shows timer running, descriptions & timers below with their colors but no descriptions)
  - Detailed mode (shows timer running, descriptions & timers below with color & descriptions)
- 03-UI-improvements
  UI polishing, like:
  - Add liquid effect on running timer
  - Timers & Descriptions centered below circular running timer
  - Timers will have the border colored like the cycle color & the background like timer color
  - Edit screen: click on sound icon & play selected sound
  - BUG: clicking 'stop' on finished timer will raise an error.
- 02-sound-mechanics
  Add basic sound mechanics, like playing a sound on trigger of new timer and adding fuse timers (these will loop and only play at the beginning).
- 01-add-cycles
  Add cycles to make a cyclock be a set of cycles instead of timers. Reflect this in the UI, in particular the cyclock edition/creation page.
  Changes:
    Database (data/database.dart):
        Added a Cycles table. This sits between Cyclocks and TimerStages.
        Updated TimerStages table: replaced cyclockId with cycleId.
        Added CyclesDao to handle cycle operations.
        Bumped schemaVersion to 2.
    Database Helper (helpers/database_helper.dart):
        Updated the seeding logic (Pomodoro, Squats, etc.) to use the new Cycle hierarchy.
        Example: Pomodoro is now defined as 2 Cycles:
        3x Repeats of [Work, Short Break]
        1x Repeat of [Work, Long Break]
    Edit Screen (presentation/screens/cyclock_edit_screen.dart):
        Major Refactor: The UI now displays a list of Cycle Cards.
        Inside each Cycle Card, you can add/edit/reorder Timers.
        Added UI controls for Cycle properties (Background Color, Repeat Count).
    Running Screen (presentation/screens/cyclock_running_screen.dart):
        Added logic to flatten the hierarchical database structure into a linear list of timers for the TimerEngine to execute.
        It calculates the sequence: (Cycle 1 Timers * Cycle 1 Repeat) + (Cycle 2 Timers * Cycle 2 Repeat)...