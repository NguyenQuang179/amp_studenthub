import 'dart:collection';

import 'package:amp_studenthub/models/job.dart';
import 'package:flutter/material.dart';

class CompanyProjectProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Job> _companyJobs = [
    Job('job1', "Front End Job", '1 to 3 months', 2, "Description...",
        '2024-03-19'),
    Job('job2', "Back End Job", '3 to 6 months', 2, "Description...",
        '2024-03-19'),
    Job('job3', "React JS Job", '1 to 3 months', 2, "Description...",
        '2024-03-19'),
    Job('job4', "Nest JS Job", '3 to 6 months', 2, "Description...",
        '2024-03-19'),
    Job('job5', "Data Engineer Job", '1 to 3 months', 2, "Description...",
        '2024-03-19')
  ];

  /// An unmodifiable view of the companyJobs in the cart.
  UnmodifiableListView<Job> get companyJobs =>
      UnmodifiableListView(_companyJobs);

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Job item) {
    _companyJobs.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all companyJobs from the cart.
  void removeAll() {
    _companyJobs.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
