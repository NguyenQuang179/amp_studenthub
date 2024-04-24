class CompanyProject {
  final int id;
  final String companyId;
  final String title;
  final String description;
  final int projectScopeFlag;
  final int numberOfStudents;
  final int typeFlag;
  final dynamic proposals;
  final int countProposals;
  final int countMessages;
  final int countHired;
  final String createdAt;

  CompanyProject(
      this.id,
      this.companyId,
      this.title,
      this.description,
      this.projectScopeFlag,
      this.numberOfStudents,
      this.typeFlag,
      this.proposals,
      this.countProposals,
      this.countMessages,
      this.countHired,
      this.createdAt);

  CompanyProject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        companyId = json['companyId'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        projectScopeFlag = json['projectScopeFlag'] as int,
        numberOfStudents = json['numberOfStudents'] as int,
        typeFlag = json['typeFlag'] as int,
        proposals = json['proposals'] as dynamic,
        countProposals = json['countProposals'] as int,
        countMessages = json['countMessages'] as int,
        countHired = json['countHired'] as int,
        createdAt = json['createdAt'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyId': companyId,
        'title': title,
        'description': description,
        'projectScopeFlag': projectScopeFlag,
        'numberOfStudents': numberOfStudents,
        'typeFlag': typeFlag,
        'proposals': proposals,
        'countProposals': countProposals,
        'countMessages': countMessages,
        'countHired': countHired,
        'createdAt': createdAt
      };
}
