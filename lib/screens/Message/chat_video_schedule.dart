import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class ChatVideoSchedule extends StatelessWidget {
  final bool isCurrentUser;
  final String message;
  final String username;
  final String startTime;
  final String endTime;
  final String meetingName;
  final String duration;
  final bool isCancelled;
  final String timeCreated;

  ChatVideoSchedule(
      {super.key,
      required this.isCurrentUser,
      required this.message,
      required this.username,
      required this.startTime,
      required this.endTime,
      required this.meetingName,
      required this.duration,
      required this.isCancelled,
      required this.timeCreated});

  @override
  Widget build(BuildContext context) {
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !isCurrentUser
                ? Text("")
                : Text(
                    timeCreated,
                    style: TextStyle(
                      color: Constant.textColor,
                      fontSize: 12,
                    ),
                  ),
            Text(
              " " + username + " want to schedule a meeting" + " ",
              style: TextStyle(
                color: Constant.textColor,
                fontSize: 12,
              ),
              textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
            ),
            isCurrentUser
                ? Text("")
                : Text(
                    timeCreated,
                    style: TextStyle(
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
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Constant.primaryColor,
              width: 2,
            ),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meetingName,
                    style: TextStyle(color: Constant.textColor),
                  ),
                  Text(
                    duration,
                    style: TextStyle(color: Constant.textColor),
                  )
                ],
              ),
              Text(
                "Start Time:" + startTime,
                style: TextStyle(color: Constant.textColor),
              ),
              Text(
                "End Time:" + endTime,
                style: TextStyle(color: Constant.textColor),
              ),
              isCancelled
                  ? Text("Meeting cancelled",
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.red[300]))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Join Meeting",
                            style: TextStyle(color: Constant.onPrimaryColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.primaryColor,
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
                              child: Text("Reschedule"),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text("Cancel"),
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
