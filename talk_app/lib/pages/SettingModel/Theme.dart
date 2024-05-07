import 'package:flutter/material.dart';


class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  Color currentColor = Colors.white;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn){
    themeMode = isOn?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }

  void updateColor(Color newColor){
    currentColor = newColor;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: currentColor,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: currentColor,
    );
  }
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: Colors.white,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.black,
);
