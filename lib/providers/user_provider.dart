import 'package:amp_studenthub/models/account.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  String _userToken = "";
  String _userRole = "";
  bool _isCompanyProfile = false;
  bool _isStudentProfile = false;
  Account _currentAccount = Account(fullName: '', type: -1);
  List<Account> _accountList = [];
  dynamic _userInfo = {};

  List<Account> get accountList => _accountList;

  void updateAccountList(List<Account> list) {
    _accountList = list;
    notifyListeners();
  }

  Account get currentAccount => _currentAccount;

  void updateCurrentAccount(Account newAcc) {
    _currentAccount = newAcc;
    notifyListeners();
  }

  bool get isCompanyProfile => _isCompanyProfile;

  void updateIsCompanyProfile(bool isAvail) {
    _isCompanyProfile = isAvail;
    notifyListeners();
  }

  bool get isStudentProfile => _isStudentProfile;

  void updateIsStudentProfile(bool isAvail) {
    _isStudentProfile = isAvail;
    notifyListeners();
  }

  String get userRole => _userRole;

  void updateRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  /// An unmodifiable view of the companyJobs in the cart.
  String get userToken => _userToken;

  void updateToken(String token) {
    _userToken = token;
    notifyListeners();
  }

  dynamic get userInfo => _userInfo;

  void updateUserInfo(dynamic data) {
    _userInfo = data;
    notifyListeners();
  }
}
