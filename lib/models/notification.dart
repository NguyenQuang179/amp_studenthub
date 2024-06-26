class NotificationType {
  static int offer = 0;
  static int interview = 1;
  static int submitted = 2;
  static int message = 3;
  static int hired = 4;
}

class UserNotification {
  final String id;
  final String content;
  final String type;
  final String createdAt;

  UserNotification(this.id, this.content, this.type, this.createdAt);

  UserNotification.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        content = json['content'] as String,
        type = json['type'] as String,
        createdAt = json['createdAt'] as String;

  Map<String, dynamic> toJson() =>
      {'id': id, 'content': content, 'type': type, 'createdAt': createdAt};
}
