import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/models/student_profile.dart';

class Proposal {
  final int id;
  final int projectId;
  final int studentId;
  final int statusFlag;
  final int disableFlag;
  final String coverLetter;
  final CompanyProject? project;
  final StudentProfile? student;

  Proposal(this.id, this.projectId, this.studentId, this.statusFlag,
      this.disableFlag, this.coverLetter, this.project, this.student);
  //default constructor
  Proposal.empty()
      : id = 0,
        projectId = 0,
        studentId = 0,
        disableFlag = 0,
        statusFlag = 0,
        coverLetter = '',
        project = null,
        student = null;

  Proposal.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        coverLetter = json['coverLetter'] as String,
        projectId = json['projectId'] as int,
        studentId = json['studentId'] as int,
        disableFlag = json['disableFlag'] as int,
        statusFlag = json['statusFlag'] as int,
        project = json['project'] != null
            ? CompanyProject.fromJson(json['project'])
            : null,
        student = json['student'] != null
            ? StudentProfile.fromJson(json['student'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'coverLetter': coverLetter,
        'projectId': projectId,
        'studentId': studentId,
        'disableFlag': disableFlag,
        'statusFlag': statusFlag,
        'project': project,
        'student': student
      };
}
