import 'package:amp_studenthub/models/company_profile.dart';
import 'package:amp_studenthub/models/student_profile.dart';

class User {
  final int id;
  final String fullname;
  final List<dynamic> roles;
  final CompanyProfile? company;
  // final StudentProfile? student;

  User(
    this.id,
    this.fullname,
    this.roles, {
    this.company,
    /*this.student*/
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        fullname = json['fullname'] as String,
        roles = json['roles'] as List<dynamic>,
        // student = json.containsKey('student')
        //     ? StudentProfile.fromJson(json['student'])
        //     : null,
        company = json['company'] != null
            ? CompanyProfile.fromJson(json['company'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'roles': roles,
        // 'student': student?.toJson(),
        'company': company?.toJson(),
      };
}
