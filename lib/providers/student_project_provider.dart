import 'dart:collection';

import 'package:amp_studenthub/models/project.dart';
import 'package:flutter/material.dart';

class StudentProjectProvider extends ChangeNotifier {
  List<Project> _searchedProjects = [];
  String _searchedQuery = '';

  void updateSearchQuery(String query) {
    _searchedQuery = query;
    notifyListeners();
  }

  String get searchQuery => _searchedQuery;

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
