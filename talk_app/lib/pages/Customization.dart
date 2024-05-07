import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';
import 'package:talk_app/pages/SettingModel/ThemeWidget.dart';

// Model to manage the app settings

class Customization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listening to theme changes to rebuild the widget when theme changes
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customization'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SwitchListTile(
                title: Text('Toggle Theme'),
                value: themeProvider.isDarkMode, // Assumes 'isDarkMode' is a getter in your ThemeModel
                onChanged: (value) {
                  final provider = Provider.of<ThemeProvider>(context,listen: false);
                  provider.toggleTheme(value);
                },
              ),
            ),
          ),
          // Additional content can be added here
        ],
      ),
    );
  }
}