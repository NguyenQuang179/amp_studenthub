import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/Message/message_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  bool isLoading = false;
  List<dynamic> messagesList = [];

  checkDetail(receiverId, projectId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = userProvider.userInfo;
    final userId = userInfo['id'];
    print({
      'userId': userId.toString(),
      'receiverId': receiverId.toString(),
      'projectId': projectId.toString(),
    });
    GoRouter.of(context).pushNamed(
      RouteConstants.messageDetail,
      queryParameters: {
        'userId': userId.toString(),
        'receiverId': receiverId.toString(),
        'projectId': projectId.toString(),
      },
    );
  }

  checkSaved(context) {
    GoRouter.of(context).push('/projectListSaved');
  }

  handleSubmit(context, value) {
    GoRouter.of(context).push('/projectListFiltered');
    print(value);
  }

  Future<void> getMessage() async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      const endpoint = '${Constant.baseURL}/api/message/';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      print(result);
      final List<dynamic> fetchedMessages = [];
      for (var message in result) {
        // Message detailMsg = Message.fromJson(message);
        // final senderID = message['sender']['id'];
        // print(senderID);
        // print(userId);
        // if (senderID == userId) {
        //   continue;
        // }
        fetchedMessages.add(message);
      }

      if (mounted) {
        setState(() {
          messagesList = fetchedMessages;
        });
      }
      print(messagesList);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch jobs when the widget is initialized
    getMessage();
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Messages: ",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Constant.primaryColor),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          context.pushNamed(RouteConstants.activeInterviewList);
                        },
                        child: const Text("Active Interview")),
                  ],
                )),
            isLoading
                ? const Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                            size: 32,
                            duration: Durations.extralong4,
                            color: Constant.primaryColor)),
                  )
                : messagesList.isEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/empty.svg',
                                height: 320,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              child: const Text(
                                'Your message list is empty',
                                style: TextStyle(
                                  color: Constant.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                        itemCount: messagesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message = messagesList[index];
                          final isCurrentUser = message["sender"]["id"] ==
                              Provider.of<UserProvider>(context, listen: false)
                                  .userInfo['id'];
                          final receiverId = isCurrentUser
                              ? message["receiver"]["id"]
                              : message["sender"]["id"];
                          return MessageItem(
                              messageReceiver: isCurrentUser
                                  ? message["receiver"]["fullname"]
                                  : message["sender"]["fullname"],
                              message: message["content"],
                              receiverPosition: message["project"]["title"],
                              onClick: () => checkDetail(
                                  receiverId, message["project"]["id"]),
                              isSaved: false);
                        },
                      )),
          ],
        )),
      ),
    );
  }
}
