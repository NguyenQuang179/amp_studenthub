import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  String _userToken = "";

  /// An unmodifiable view of the companyJobs in the cart.
  String get userToken => _userToken;

  void update(String token) {
    _userToken = token;
    notifyListeners();
  }
}
