class StudentProfile {
  final num id;
  final String fullname;
  final int studentYear;
  final String studentGrade;
  final String proposal;

  StudentProfile(this.id, this.fullname, this.studentYear, this.studentGrade,
      this.proposal);

  // StudentProfile.fromJson(Map<String, dynamic> json)
  //     : id = json['id'] as num,
  //       fullname = json['name'] as String,
  //       studentYear = json['studentYear'] as int,
  //       studentGrade = json['studentGrade'] as String,
  //       proposal = json['proposal'] as String;

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'fullname': fullname,
  //       'studentYear': studentYear,
  //       'studentGrade': studentGrade,
  //       'proposal': proposal
  //     };
}
