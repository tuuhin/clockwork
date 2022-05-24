import 'package:flutter/material.dart';

class ThemeContext extends ChangeNotifier {
  bool _isCurrentThemeIsDark = ThemeMode.system == ThemeMode.dark;
  bool get currentThemeIsDark => _isCurrentThemeIsDark;

  void switchCurrentTheme(bool isLightTheme) {
    _isCurrentThemeIsDark = isLightTheme;
    notifyListeners();
  }
}
