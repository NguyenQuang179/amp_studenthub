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
  final dynamic user;

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
      this.skillSets,
      this.user);

  StudentProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num,
        techStackId = json['techStackId'] as num,
        resume = json['resume'],
        transcript = json['transcript'],
        proposals = json['proposals'] as dynamic,
        techStack = json['techStack'] as dynamic,
        educations = json['educations'] ?? [],
        languages = json['languages'] ?? [],
        experiences = json['experiences'] ?? [],
        skillSets = json['skillSets'] ?? [],
        user = json['user'] as dynamic;

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
        'user': user
      };
}
