// New File: Handles database connections for native platforms (Mobile & Desktop).
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// New Comment: This function defines how to create the database on native platforms.
// It finds the application's documents directory and creates a 'db.sqlite' file there.
// This is the standard approach for persistent storage on iOS, Android, macOS, Windows, and Linux.
QueryExecutor openConnection() {
  // New Comment: The `LazyDatabase` wrapper ensures that the database file is only opened when it's first used.
  // EXPLANATION: `LazyDatabase` is an optimization. Instead of opening the database file the moment the app starts, it waits until the very first query is executed. This can improve app startup time.
  return LazyDatabase(() async {
    // EXPLANATION: `path_provider` finds the correct, platform-specific directory to store app data. The `path` package (`p`) provides tools to safely join path segments together (e.g., `directory/db.sqlite`) without worrying about forward or backslashes.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // New Comment: Using `NativeDatabase.createInBackground` can help avoid UI freezes
    // by performing the potentially slow file I/O on a background thread.
    // EXPLANATION: File operations can sometimes be slow. `createInBackground` is another optimization that performs the initial database connection on a background isolate, preventing any potential stutters or freezes on the main UI thread.
    return NativeDatabase.createInBackground(file);
  });
}