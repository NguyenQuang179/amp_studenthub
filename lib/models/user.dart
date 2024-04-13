import 'package:amp_studenthub/models/company_profile.dart';
import 'package:amp_studenthub/models/student_profile.dart';

class User {
  final String id;
  final String fullname;
  final List<num> roles;
  final CompanyProfile? company;
  final StudentProfile? student;

  User(this.id, this.fullname, this.roles, this.company, this.student);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        fullname = json['fullname'] as String,
        roles = json['roles'] as List<num>,
        student = json['student'] as StudentProfile,
        company = json['company'] as CompanyProfile;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': fullname,
        'roles': roles,
        'student': student,
        'company': company
      };
}
