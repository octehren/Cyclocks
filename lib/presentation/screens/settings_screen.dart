import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cyclock/data/database.dart';
import 'package:cyclock/providers/settings_provider.dart';
import 'package:cyclock/presentation/screens/instructions_screen.dart';
import 'package:cyclock/presentation/screens/cyclock_edit_screen.dart'; // both creates & edits

class SettingsScreen extends StatelessWidget {
  final AppDatabase database;
  
  const SettingsScreen({super.key, required this.database});
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Instructions Button
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Instructions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InstructionsScreen(),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Create New Cyclock Button
          Card(
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Create New Cyclock'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Cyclock Creation Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CyclockEditScreen(),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          const Text(
            'App Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Dark Mode Switch
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              value: settings.isDarkMode,
              onChanged: settings.toggleDarkMode,
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          
          // Language Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('English'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLanguageDialog(context, settings);
              },
            ),
          ),
          
          const SizedBox(height: 24),
          const Text(
            'Data Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Export Data
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Export Cyclocks Data'),
              onTap: _exportData,
            ),
          ),
          
          // Import Data
          Card(
            child: ListTile(
              leading: const Icon(Icons.install_desktop),
              title: const Text('Import Cyclocks Data'),
              onTap: () => _importData(context),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: const Icon(Icons.check),
              onTap: () {
                settings.setLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Spanish'),
              leading: const Icon(Icons.language),
              onTap: () {
                settings.setLanguage('es');
                Navigator.pop(context);
              },
            ),
            // Add more languages as needed
          ],
        ),
      ),
    );
  }
  
  Future<void> _exportData() async {
    // TODO: Implement data export functionality
    // ScaffoldMessenger.of( navigatorKey.currentContext!).showSnackBar(
    //   const SnackBar(content: Text('Export functionality - TODO')),
    // );
  }
  
  Future<void> _importData(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      
      if (result != null) {
        // TODO: Implement data import functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Import functionality - TODO')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing data: $e')),
      );
    }
  }
}