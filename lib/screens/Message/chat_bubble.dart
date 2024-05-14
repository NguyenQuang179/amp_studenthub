import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String message;
  final String username;
  final String timeCreated;
  const ChatBubble(
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
          margin:
              const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              !isCurrentUser
                  ? const Text("")
                  : Text(
                      timeCreated,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 12,
                      ),
                    ),
              Text(
                " $username ",
                textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 12,
                ),
              ),
              isCurrentUser
                  ? const Text("")
                  : Text(
                      timeCreated,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
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
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )),
      ],
    );
  }
}
