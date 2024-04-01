class Job {
  final String id;
  final String title;
  final String duration;
  final int requiredStudents;
  final String description;
  final String createdAt;

  Job(this.id, this.title, this.duration, this.requiredStudents,
      this.description, this.createdAt);

  Job.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        duration = json['duration'] as String,
        requiredStudents = json['requiredStudents'] as int,
        description = json['description'] as String,
        createdAt = json['createdAt'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'requiredStudents': requiredStudents,
        'description': description,
        'createdAt': createdAt
      };
}
