import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {},
    );
  }
}
