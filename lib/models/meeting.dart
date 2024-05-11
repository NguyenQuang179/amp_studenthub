class Interview {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final int disableFlag;
  final int meetingRoomId;
  final MeetingRoom meetingRoom;

  Interview({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.disableFlag,
    required this.meetingRoomId,
    required this.meetingRoom,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'],
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      disableFlag: json['disableFlag'],
      meetingRoomId: json['meetingRoomId'],
      meetingRoom: MeetingRoom.fromJson(json['meetingRoom']),
    );
  }
}

class MeetingRoom {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String meetingRoomCode;
  final String meetingRoomId;
  final DateTime expiredAt;

  MeetingRoom({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.meetingRoomCode,
    required this.meetingRoomId,
    required this.expiredAt,
  });

  factory MeetingRoom.fromJson(Map<String, dynamic> json) {
    return MeetingRoom(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'],
      meetingRoomCode: json['meeting_room_code'],
      meetingRoomId: json['meeting_room_id'],
      expiredAt: DateTime.parse(json['expired_at']),
    );
  }
}
