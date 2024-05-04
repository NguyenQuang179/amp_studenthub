import 'package:intl/intl.dart';

class Project {
  final num id;
  final String companyId;
  final String companyName;
  final int projectScopeFlag;
  final String title;
  final String description;
  final int numberOfStudents;
  final int? typeFlag;
  final int countProposals;
  late final bool isFavorite;
  final String createdDate;

  Project({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.projectScopeFlag,
    required this.title,
    required this.description,
    required this.numberOfStudents,
    required this.typeFlag,
    required this.countProposals,
    required this.isFavorite,
    required this.createdDate,
  });

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num,
        companyId = json['companyId'] as String,
        companyName = json['companyName'] as String,
        projectScopeFlag = json['projectScopeFlag'] as int,
        title = json['title'] as String,
        description = json['description'] as String,
        numberOfStudents = json['numberOfStudents'] as int,
        typeFlag = json['typeFlag'] as int,
        countProposals = json['countProposals'] as int,
        isFavorite = json['isFavorite'] as bool,
        createdDate = _formatDate(json['createdAt'] as String);

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyId': companyId,
        'companyName': companyName,
        'projectScopeFlag': projectScopeFlag,
        'title': title,
        'description': description,
        'numberOfStudents': numberOfStudents,
        'typeFlag': typeFlag,
        'countProposals': countProposals,
        'isFavorite': isFavorite,
      };

  static String _formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate;
  }
}
