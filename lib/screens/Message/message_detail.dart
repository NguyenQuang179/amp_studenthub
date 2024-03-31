import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/Message/message_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageDetail extends StatelessWidget {
  const MessageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constant.backgroundColor,
        toolbarHeight: 60,
        title: const Text(
          'Luis Pham Irecnus',
          style: TextStyle(
              color: Constant.primaryColor, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: IconButton.outlined(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.ellipsis,
                    size: 16,
                  ))),
        ],
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return MessageDetailItem(
                  isCurrentUser: index.isEven,
                  message: 'Hello World',
                  isScheduleItem: index % 3 == 0 ? true : false,
                );
              },
            )),
            //userInput
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(),
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
