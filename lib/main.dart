import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyclock/data/database.dart';
import 'package:cyclock/presentation/screens/cyclocks_index_screen.dart';
import 'package:cyclock/helpers/theme.dart';
import 'package:cyclock/helpers/database_helper.dart';
import 'package:cyclock/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
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