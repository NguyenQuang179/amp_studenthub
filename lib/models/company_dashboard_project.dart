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
  final int? countMessages;
  final int? countHired;
  final String createdAt;
  // final String updatedAt;
  // final String? deletedAt;
  final bool isFavorite;

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
    this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
    this.isFavorite,
  );
  //default constructor
  CompanyProject.empty()
      : id = 0,
        companyId = '',
        title = '',
        description = '',
        projectScopeFlag = 0,
        numberOfStudents = 0,
        typeFlag = 0,
        proposals = '',
        countProposals = 0,
        countMessages = 0,
        countHired = 0,
        createdAt = '',
        // updatedAt = '',
        // deletedAt = '',
        isFavorite = false;

  CompanyProject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        companyId = json['companyId'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        projectScopeFlag = json['projectScopeFlag'] as int,
        numberOfStudents = json['numberOfStudents'] as int,
        typeFlag = json['typeFlag'] ?? 0,
        proposals = json['proposals'] as dynamic,
        countProposals = json['countProposals'] as int,
        countMessages = json['countMessages'] ?? 0,
        countHired = json['countHired'] ?? 0,
        createdAt = json['createdAt'] as String,
        // updatedAt = json['updatedAt'] as String,
        // deletedAt = json['deletedAt'] as String?,
        isFavorite = json['isFavorite'] ?? false;

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
        'createdAt': createdAt,
        // 'updatedAt': updatedAt,
        // 'deletedAt': deletedAt,
        'isFavorite': isFavorite
      };
}
