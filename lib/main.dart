import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyclocks/data/database.dart';
import 'package:cyclocks/presentation/screens/cyclocks_index_screen.dart';
import 'package:cyclocks/helpers/theme.dart';
import 'package:cyclocks/helpers/database_helper.dart';
import 'package:cyclocks/providers/settings_provider.dart';

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