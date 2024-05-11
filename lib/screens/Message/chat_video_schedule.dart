import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/meeting.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatVideoSchedule extends StatelessWidget {
  final bool isCurrentUser;
  final String username;
  final String startTime;
  final String endTime;
  final String meetingName;
  final String duration;
  final bool isCancelled;
  final String timeCreated;
  final Interview interview;

  ChatVideoSchedule(
      {super.key,
      required this.isCurrentUser,
      required this.username,
      required this.startTime,
      required this.endTime,
      required this.meetingName,
      required this.duration,
      required this.isCancelled,
      required this.timeCreated,
      required this.interview});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !isCurrentUser
                ? const Text("")
                : Text(
                    timeCreated,
                    style: const TextStyle(
                      color: Constant.textColor,
                      fontSize: 12,
                    ),
                  ),
            Text(
              " $username",
              style: const TextStyle(
                color: Constant.textColor,
                fontSize: 12,
              ),
              textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
            ),
            isCurrentUser
                ? const Text("")
                : Text(
                    timeCreated,
                    style: const TextStyle(
                      color: Constant.textColor,
                      fontSize: 12,
                    ),
                  ),
          ],
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Constant.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Constant.primaryColor,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meetingName,
                    style: const TextStyle(color: Constant.textColor),
                  ),
                  Text(
                    duration,
                    style: const TextStyle(color: Constant.textColor),
                  )
                ],
              ),
              Text(
                "Start Time: $startTime",
                style: const TextStyle(color: Constant.textColor),
              ),
              Text(
                "End Time: $endTime",
                style: const TextStyle(color: Constant.textColor),
              ),
              isCancelled
                  ? Text("Meeting cancelled",
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.red[300]))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String? meetingRoomCode =
                                interview.meetingRoom.meetingRoomCode;
                            if (meetingRoomCode != null &&
                                meetingRoomCode != "") {
                              context.pushNamed(RouteConstants.videoCall,
                                  queryParameters: {
                                    meetingRoomCode: meetingRoomCode
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.primaryColor,
                          ),
                          child: const Text(
                            "Join Meeting",
                            style: TextStyle(color: Constant.onPrimaryColor),
                          ),
                        ),
                        // IconButton(
                        //     color: Constant.secondaryColor,
                        //     onPressed: () {},
                        //     icon: Icon(Icons.more_horiz_rounded))
                        PopupMenuButton(itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              onTap: () {},
                              child: const Text("Reschedule"),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: const Text("Cancel"),
                            ),
                          ];
                        })
                      ],
                    )
            ],
          ))
    ]);
  }
}
