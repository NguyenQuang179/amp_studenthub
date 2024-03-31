import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/Message/message_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});
  checkDetail(context) {
    GoRouter.of(context).push('/messageDetail');
  }

  checkSaved(context) {
    GoRouter.of(context).push('/projectListSaved');
  }

  handleSubmit(context, value) {
    GoRouter.of(context).push('/projectListFiltered');
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: const Text(
                  "Messages: ",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Constant.primaryColor),
                )),
            Expanded(
                child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return MessageItem(
                    jobCreatedDate: '16/03/2024',
                    messageReceiver: 'Luis Pham Irecnus',
                    receiverPosition: 'Senior frontend dev (Fintech)',
                    onClick: () => checkDetail(context),
                    isSaved: false);
              },
            )),
          ],
        )),
      ),
    );
  }
}
