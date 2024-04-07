class User {
  final num id;
  final String fullname;
  final List<num> roles;
  final int studentYear;
  final String studentGrade;
  final String proposal;

  User(this.id, this.fullname, this.roles, this.studentYear, this.studentGrade,
      this.proposal);

  // User.fromJson(Map<String, dynamic> json)
  //     : id = json['id'] as String,
  //       fullname = json['name'] as String,
  //       roles = json['jobPosition'] as String,
  //       studentYear = json['studentYear'] as int,
  //       studentGrade = json['studentGrade'] as String,
  //       proposal = json['proposal'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': fullname,
        'jobPosition': roles,
        'studentYear': studentYear,
        'studentGrade': studentGrade,
        'proposal': proposal
      };
}
