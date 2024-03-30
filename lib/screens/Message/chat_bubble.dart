import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String message;
  final String username;
  final String timeCreated;
  ChatBubble(
      {super.key,
      required this.isCurrentUser,
      required this.message,
      required this.username,
      required this.timeCreated});

  @override
  Widget build(BuildContext context) {
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.,
      children: [
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
                " " + username + " ",
                textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Constant.textColor,
                  fontSize: 12,
                ),
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
              color: isCurrentUser
                  ? Constant.primaryColor
                  : Constant.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              message,
              style: TextStyle(
                color: Constant.onPrimaryColor,
              ),
            )),
      ],
    );
  }
}
