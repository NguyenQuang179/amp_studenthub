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
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        onChanged: (value) {},
                        onSubmitted: (String value) =>
                            handleSubmit(context, value),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16),
                            filled: true,
                            fillColor: Constant.onPrimaryColor,
                            prefixIcon: const Icon(Icons.search),
                            prefixStyle: const TextStyle(),
                            hintText: "Search for job...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: IconButton(
                        style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Constant.primaryColor,
                            foregroundColor: Constant.onPrimaryColor),
                        onPressed: () => checkSaved(context),
                        icon: const Icon(Icons.favorite_border)),
                  )
                ],
              ),
            ),
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