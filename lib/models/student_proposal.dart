class StudentProposal {
  final String id;
  final String name;
  final String jobPosition;
  final int studentYear;
  final String studentGrade;
  final String proposal;

  StudentProposal(this.id, this.name, this.jobPosition, this.studentYear,
      this.studentGrade, this.proposal);

  StudentProposal.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        jobPosition = json['jobPosition'] as String,
        studentYear = json['studentYear'] as int,
        studentGrade = json['studentGrade'] as String,
        proposal = json['proposal'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'jobPosition': jobPosition,
        'studentYear': studentYear,
        'studentGrade': studentGrade,
        'proposal': proposal
      };
}
