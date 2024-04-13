import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  int _role = 0;

  int get role => _role;

  void setRole(int role) {
    _role = role;
    notifyListeners();
  }
}
