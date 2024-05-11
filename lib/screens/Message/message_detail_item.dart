import 'package:amp_studenthub/screens/Message/chat_bubble.dart';
import 'package:amp_studenthub/screens/Message/chat_video_schedule.dart';
import 'package:flutter/material.dart';

class MessageDetailItem extends StatelessWidget {
  final bool isCurrentUser;
  final bool isScheduleItem;
  final String message;
  final String fullname;
  final String timeCreated;
  final dynamic interview;
  const MessageDetailItem(
      {super.key,
      required this.isCurrentUser,
      required this.message,
      required this.isScheduleItem,
      required this.fullname,
      required this.timeCreated,
      required this.interview});

  @override
  Widget build(BuildContext context) {
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: alignment,
        child: isScheduleItem
            ? ChatVideoSchedule(
                isCurrentUser: isCurrentUser,
                username: fullname,
                startTime: interview['startTime'],
                endTime: interview['endTime'],
                meetingName: interview['title'],
                duration: '1 hour',
                isCancelled: false,
                timeCreated: timeCreated,
                interview: interview)
            : ChatBubble(
                isCurrentUser: isCurrentUser,
                message: message,
                username: fullname,
                timeCreated: timeCreated,
              ));
  }
}
