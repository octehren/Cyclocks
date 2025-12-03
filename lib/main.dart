import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyclocks/data/database.dart';
import 'package:cyclocks/presentation/screens/cyclocks_index_screen.dart';
import 'package:cyclocks/helpers/theme.dart';
import 'package:cyclocks/helpers/database_helper.dart';
import 'package:cyclocks/providers/settings_provider.dart';
// SEND NOTIFICATIONS IN MOBILE DEVICES
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// GLOBAL NOTIFICATION INSTANCE
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();

  // 1. Initialize Timezone Database
  tz.initializeTimeZones();

  // 2. Initialize Notifications
  // Android Notifs
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // mac & iOS notifs
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  // Linux Notifs
  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin, // macOS uses the same as iOS
    linux: initializationSettingsLinux,  // Linux specific
    // Windows is handled automatically by the plugin defaults usually, 
    // or doesn't require specific init settings object in basic cases.
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await DatabaseHelper.initializeDefaultCyclocks(database);
  
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  
  const MyApp({super.key, required this.database});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Cyclock',
            theme: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: CyclocksIndexScreen(database: database),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}