class NotificationModel {
  final dynamic id;
  final DateTime createdAt;
  final dynamic receiverId;
  final dynamic senderId;
  final dynamic messageId;
  final dynamic title;
  final dynamic notifyFlag;
  final dynamic typeNotifyFlag;
  final dynamic proposalId;
  final dynamic content;
  final dynamic message;
  final dynamic sender;
  final dynamic receiver;
  final dynamic proposal;

  NotificationModel(
    this.id,
    this.createdAt,
    this.receiverId,
    this.senderId,
    this.messageId,
    this.title,
    this.notifyFlag,
    this.typeNotifyFlag,
    this.proposalId,
    this.content,
    this.message,
    this.sender,
    this.receiver,
    this.proposal,
  );

  NotificationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = DateTime.parse(json['createdAt']),
        receiverId = json['receiverId'],
        senderId = json['senderId'],
        messageId = json['messageId'],
        title = json['title'],
        notifyFlag = json['notifyFlag'],
        typeNotifyFlag = int.parse(json['typeNotifyFlag']),
        proposalId = json['proposalId'],
        content = json['content'],
        message = json['message'],
        sender = json['sender'],
        receiver = json['receiver'],
        proposal = json['proposal'];
}

class Message {
  final dynamic id;
  final DateTime createdAt;
  dynamic senderId;
  final dynamic receiverId;
  final dynamic projectId;
  final dynamic interviewId;
  final dynamic content;
  final dynamic messageFlag;
  final dynamic interview;

  Message(
    this.id,
    this.createdAt,
    this.senderId,
    this.receiverId,
    this.projectId,
    this.interviewId,
    this.content,
    this.messageFlag,
    this.interview,
  );

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = DateTime.parse(json['createdAt']),
        senderId = json['senderId'],
        receiverId = json['receiverId'],
        projectId = json['projectId'],
        interviewId = json['interviewId'],
        content = json['content'],
        messageFlag = json['messageFlag'],
        interview = json['interview'];
}

class Chatter {
  final dynamic id;
  final DateTime createdAt;
  final dynamic email;
  final dynamic fullname;
  final List<dynamic>? roles;
  final bool verified;
  final bool isConfirmed;

  Chatter(
    this.id,
    this.createdAt,
    this.email,
    this.fullname,
    this.roles,
    this.verified,
    this.isConfirmed,
  );

  Chatter.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = DateTime.parse(json['createdAt']),
        email = json['email'],
        fullname = json['fullname'],
        roles =
            json['roles'] != null ? List<dynamic>.from(json['roles']) : null,
        verified = json['verified'],
        isConfirmed = json['isConfirmed'];
}
