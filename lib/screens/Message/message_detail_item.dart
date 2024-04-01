import 'package:amp_studenthub/screens/Message/chat_bubble.dart';
import 'package:amp_studenthub/screens/Message/chat_video_schedule.dart';
import 'package:flutter/material.dart';

class MessageDetailItem extends StatelessWidget {
  final bool isCurrentUser;
  final bool isScheduleItem;
  final String message;
  MessageDetailItem(
      {super.key,
      required this.isCurrentUser,
      required this.message,
      required this.isScheduleItem});

  @override
  Widget build(BuildContext context) {
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        alignment: alignment,
        child: isScheduleItem
            ? ChatVideoSchedule(
                isCurrentUser: isCurrentUser,
                message: message,
                username: 'John Doe',
                startTime: '10:00',
                endTime: '11:00',
                meetingName: 'Meeting',
                duration: '1 hour',
                isCancelled: isCurrentUser,
                timeCreated: '12:30am',
              )
            : ChatBubble(
                isCurrentUser: isCurrentUser,
                message: message,
                username: 'John Doe',
                timeCreated: '12:30am',
              ));
  }
}
