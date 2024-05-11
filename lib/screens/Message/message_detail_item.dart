import 'package:amp_studenthub/models/meeting.dart';
import 'package:amp_studenthub/screens/Message/chat_bubble.dart';
import 'package:amp_studenthub/screens/Message/chat_video_schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageDetailItem extends StatelessWidget {
  final bool isCurrentUser;
  final bool isScheduleItem;
  final String message;
  final String fullname;
  final String timeCreated;
  final Interview? interview;
  const MessageDetailItem(
      {super.key,
      required this.isCurrentUser,
      required this.message,
      required this.isScheduleItem,
      required this.fullname,
      required this.timeCreated,
      this.interview});

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
                startTime: DateFormat('hh:mm a').format(interview!.startTime),
                endTime: DateFormat('hh:mm a').format(interview!.endTime),
                meetingName: interview!.title,
                duration: interview!.endTime
                    .difference(interview!.startTime)
                    .inHours
                    .toString(),
                isCancelled: interview!.disableFlag == 1,
                timeCreated: timeCreated,
                interview: interview!)
            : ChatBubble(
                isCurrentUser: isCurrentUser,
                message: message,
                username: fullname,
                timeCreated: timeCreated,
              ));
  }
}
