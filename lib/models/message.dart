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
  final Message message;
  final Chatter sender;
  final Chatter receiver;
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
      : id = json['notification']['id'],
        createdAt = DateTime.parse(json['notification']['createdAt']),
        receiverId = json['notification']['receiverId'],
        senderId = json['notification']['senderId'],
        messageId = json['notification']['messageId'],
        title = json['notification']['title'],
        notifyFlag = json['notification']['notifyFlag'],
        typeNotifyFlag = json['notification']['typeNotifyFlag'],
        proposalId = json['notification']['proposalId'],
        content = json['notification']['content'],
        message = Message.fromJson(json['notification']['message']),
        sender = Chatter.fromJson(json['notification']['sender']),
        receiver = Chatter.fromJson(json['notification']['receiver']),
        proposal = json['notification']['proposal'];
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
