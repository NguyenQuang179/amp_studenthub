import 'package:amp_studenthub/models/project.dart';

class Proposal {
  final int id;
  final int projectId;
  final int studentId;
  final int statusFlag;
  final int disableFlag;
  final String coverLetter;
  final Project project;

  Proposal(
    this.id,
    this.projectId,
    this.studentId,
    this.statusFlag,
    this.disableFlag,
    this.coverLetter,
    this.project,
  );
  //default constructor
  Proposal.empty()
      : id = 0,
        projectId = 0,
        studentId = 0,
        disableFlag = 0,
        statusFlag = 0,
        coverLetter = '',
        project = Project.empty();

  Proposal.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        coverLetter = json['coverLetter'] as String,
        projectId = json['projectId'] as int,
        studentId = json['studentId'] as int,
        disableFlag = json['disableFlag'] as int,
        project = Project(
            id: json['project']['id'],
            companyId: json['project']['companyId'],
            companyName: '',
            projectScopeFlag: json['project']['projectScopeFlag'],
            title: json['project']['title'],
            description: json['project']['description'],
            numberOfStudents: json['project']['numberOfStudents'],
            typeFlag: json['project']['typeFlag'],
            countProposals: 0,
            isFavorite: false,
            createdDate: json['project']['createdAt']),
        statusFlag = json['statusFlag'] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'coverLetter': coverLetter,
        'projectId': projectId,
        'studentId': studentId,
        'disableFlag': disableFlag,
        'statusFlag': statusFlag,
        'project': project
      };
}
