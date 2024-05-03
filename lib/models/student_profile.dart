class StudentProfile {
  final num id;
  final num techStackId;
  final String? resume;
  final String? transcript;
  final dynamic proposals;
  final dynamic techStack;
  final List<dynamic> educations;
  final List<dynamic> languages;
  final List<dynamic> experiences;
  final List<dynamic> skillSets;

  StudentProfile(
      this.id,
      this.techStackId,
      this.resume,
      this.transcript,
      this.proposals,
      this.techStack,
      this.educations,
      this.languages,
      this.experiences,
      this.skillSets);

  StudentProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num,
        techStackId = json['techStackId'] as num,
        resume = json['resume'],
        transcript = json['transcript'],
        proposals = json['proposals'] as dynamic,
        techStack = json['techStack'] as dynamic,
        educations = json['educations'] as List<dynamic>,
        languages = json['languages'] as List<dynamic>,
        experiences = json['experiences'] as List<dynamic>,
        skillSets = json['skillSets'] as List<dynamic>;

  Map<String, dynamic> toJson() => {
        'id': id,
        'techStackId': techStackId,
        'resume': resume,
        'transcript': transcript,
        'proposals': proposals,
        'techStack': techStack,
        'educations': educations,
        'languages': languages,
        'experiences': experiences,
        'skillSets': skillSets,
      };
}
