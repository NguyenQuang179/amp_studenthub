import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageItem extends StatelessWidget {
  final String messageReceiver;
  final String jobCreatedDate;
  final String receiverPosition;
  final onClick;
  final isSaved;
  const MessageItem(
      {super.key,
      required this.messageReceiver,
      required this.jobCreatedDate,
      required this.receiverPosition,
      required this.onClick,
      required this.isSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Constant.backgroundColor,
            border: Border.all(color: Colors.grey[500]!),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  //avatar
                  Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(left: 24, right: 8),
                      child: FaIcon(FontAwesomeIcons.user, size: 16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Text(
                            messageReceiver,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Text(
                              " ${receiverPosition}",
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                        Text("Created at $jobCreatedDate",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
