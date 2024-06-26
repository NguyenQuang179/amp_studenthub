import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeProvider({
    ThemeMode mode = ThemeMode.light,
  }) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
