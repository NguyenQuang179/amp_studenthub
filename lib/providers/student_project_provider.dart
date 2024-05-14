import 'dart:collection';

import 'package:amp_studenthub/models/project.dart';
import 'package:flutter/material.dart';

class StudentProjectProvider extends ChangeNotifier {
  List<Project> _searchedProjects = [];
  String _searchedQuery = '';
  late int _projectScopeFlag = -1;
  late String _proposals = '';
  late String _students = '';

  void clear() {
    _projectScopeFlag = -1;
    _proposals = '';
    _students = '';
  }

  void updateProjectScopeFlag(int query) {
    _projectScopeFlag = query;
    notifyListeners();
  }

  int get projectScopeFlag => _projectScopeFlag;

  void updateSearchQuery(String query) {
    _searchedQuery = query;
    notifyListeners();
  }

  String get proposals => _proposals;

  void updateProposals(String query) {
    _proposals = query;
    notifyListeners();
  }

  String get searchQuery => _searchedQuery;

  void updateStudents(String query) {
    _students = query;
    notifyListeners();
  }

  String get students => _students;

  void updateList(List<Project> list) {
    _searchedProjects = List<Project>.from(list);
    notifyListeners();
  }

  List<Project> get searchProjects => _searchedProjects;

  void removeAllList() {
    _searchedProjects.clear();
    notifyListeners();
  }
}
