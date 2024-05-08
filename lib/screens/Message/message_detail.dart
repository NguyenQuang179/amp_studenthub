import 'dart:async';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/message.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/screens/Message/message_detail_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_io_socket/flutter_io_socket.dart' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class MessageDetail extends StatefulWidget {
  final int userId;
  final int receiverId;
  final int projectId;
  String? receiverName;

  MessageDetail(
      {super.key,
      required this.userId,
      required this.receiverId,
      required this.projectId,
      this.receiverName});

  @override
  State<MessageDetail> createState() => _MessageDetailState(
      userId: userId,
      receiverId: receiverId,
      projectId: projectId,
      receiverName: receiverName);
}

class _MessageDetailState extends State<MessageDetail> {
  late io.Socket socket;
  final interviewTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final sendMessageDetailController = TextEditingController();
  final _ListScrollController = ScrollController();

  final int userId;
  final int receiverId;
  final int projectId;
  String? receiverName = ' ';
  String senderName = '';

  _MessageDetailState(
      {required this.userId,
      required this.receiverId,
      required this.projectId,
      this.receiverName});

  bool socketInitialized = false;
  List<dynamic> messages = [];
  @override
  void initState() {
    super.initState();
    init();
  }

  void scrollToBottom() {
    _ListScrollController.animateTo(
      _ListScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> getMessage(receiverId, projectId) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;

      final endpoint =
          '${Constant.baseURL}/api/message/$projectId/user/$receiverId';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      print(endpoint);
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      print(result);
      final List<Message> fetchedMessages = [];
      final fetchedReceiverId = result[0]['receiver']['id'];
      final fetchedSenderId = result[0]['sender']['id'];
      if (receiverId == fetchedReceiverId) {
        receiverName = result[0]['receiver']['fullname'];
        senderName = result[0]['sender']['fullname'];
      } else if (receiverId == fetchedSenderId) {
        receiverName = result[0]['sender']['fullname'];
        senderName = result[0]['receiver']['fullname'];
      } else {
        receiverName = 'errorName';
        senderName = 'errorName';
      }
      print(receiverName);
      print(senderName);
      for (var message in result) {
        Message detailMsg = Message.fromJson(message);
        detailMsg.senderId = message['sender']['id'];
        print(detailMsg.senderId);
        fetchedMessages.add(detailMsg);
      }

      if (mounted) {
        setState(() {
          messages = fetchedMessages;
        });
        Timer(Duration(milliseconds: 500), () => scrollToBottom());
      }
      print(messages);
    } catch (e) {
      print(e);
    }
  }

  Future<void> init() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;
    //get message
    await getMessage(receiverId, projectId);
    if (socketInitialized == false) {
      print(socketInitialized);
      await connectSocket();
      socketInitialized = true;
    }
  }

  addMessage(message) {
    setState(() {
      messages.add(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    print(socket.connected);
    socket.disconnect();
    socket.dispose();
    print(socket.connected);
    _ListScrollController.dispose();
    interviewTitleController.dispose();
    startDateController.dispose();
    endDateController.dispose();

    sendMessageDetailController.dispose();

    print('Socket Disconnected');
  }

  Future<void> connectSocket() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;
    // Initialize socket with server URL

    // var map = new Map<String, dynamic>();
    // map['Authorization'] = clientID;
    // map['project_id'] = clientSecret;
    // map['grant_type'] = grantType;
    // map['redirect_uri'] = rediUrl;
    // map['code'] = _accessCode;

    print('Bearer $accessToken');
    socket = io.io(
      'https://api.studenthub.dev',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $accessToken'})
          // .setAuth({'Authorization': 'Bearer $accessToken'})
          .setQuery({
            'project_id': projectId.toString(),
          })
          .disableAutoConnect()
          .build(),
    );
    socket.connect();
    socket.onConnect((data) => print('Connected'));
    socket.onDisconnect((data) => print('Disconnected'));

    socket.onConnectError((data) => print('connect error: $data'));
    socket.onError((data) => print('error: $data'));
    socket.on('NOTI_$userId', (data) {
      print(data);
      print(data["notification"]);

      try {
        // final notification = NotificationModel.fromJson(data);
        // print(notification);
        final newMsg = Message.fromJson(data["notification"]["message"]);
        addMessage(newMsg);
        print(messages);
        // print(notification.sender.fullname);
        // print(notification.receiver.fullname);
        scrollToBottom();
      } catch (e) {
        print(e);
      }
    });
    socket.on('RECEIVE_INTERVIEW', (data) => print(data));
    socket.on('ERROR', (data) => print('ERROR: $data'));

    setState(() {
      socketInitialized = true;
    });
  }

  // here we set the timer to call the event
  Future<void> sendMessage(String message) async {
    final newMessage = Message(
      1,
      DateTime.now(),
      userId,
      receiverId,
      projectId,
      null, //interviewId
      message,
      0, //messageFlag
      null, //interview
    );
    //optimistic
    addMessage(newMessage);

    final form = {
      "senderId": userId,
      "receiverId": receiverId,
      "projectId": projectId,
      "content": message,
      "messageFlag": 0,
    };
    print(form);
    final dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;

    const endpoint = '${Constant.baseURL}/api/message/sendMessage';
    try {
      final Response response = await dio.post(
        endpoint,
        data: form,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final responseData = response.data;
      print(responseData);

      scrollToBottom();
    } catch (error) {
      print(error);
      Fluttertoast.showToast(
          msg: 'An error occurred',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constant.backgroundColor,
        toolbarHeight: 60,
        title: Text(
          receiverName ?? "",
          style: TextStyle(
              color: Constant.primaryColor, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: IconButton.outlined(
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return SingleChildScrollView(
                              child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        child: Text("Schedule An Interview",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Constant.primaryColor,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center),
                                      ),
                                      const Divider(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 16, bottom: 8),
                                        child: const Text(
                                          "Title:",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Constant.textColor),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child: TextFormField(
                                            controller:
                                                interviewTitleController,
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 16,
                                                    right: 16),
                                                filled: true,
                                                fillColor:
                                                    Constant.onPrimaryColor,
                                                hintText:
                                                    "Enter interview title...",
                                                labelStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color: Constant
                                                            .secondaryColor,
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color: Constant.secondaryColor,
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)))),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: const Text(
                                          "Start time:",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Constant.textColor),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child: TextFormField(
                                            controller: startDateController,
                                            onTap: () async {
                                              DateTime? dateTime =
                                                  await showOmniDateTimePicker(
                                                      context: context);
                                              if (dateTime != null) {
                                                startDateController.value =
                                                    TextEditingValue(
                                                        text: DateFormat(
                                                                "yyyy-MM-dd HH:mm:ss")
                                                            .format(dateTime));
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(Icons
                                                    .calendar_month_rounded),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 8,
                                                        left: 16,
                                                        right: 16),
                                                filled: true,
                                                fillColor:
                                                    Constant.onPrimaryColor,
                                                hintText: "DD/MM/YYYY HH:MM",
                                                labelStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color: Constant
                                                            .secondaryColor,
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color: Constant.secondaryColor,
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)))),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: const Text(
                                          "End time:",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Constant.textColor),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child: TextFormField(
                                            controller: endDateController,
                                            onTap: () async {
                                              DateTime? dateTime =
                                                  await showOmniDateTimePicker(
                                                      context: context);
                                              if (dateTime != null) {
                                                endDateController.value =
                                                    TextEditingValue(
                                                        text: DateFormat(
                                                                "yyyy-MM-dd HH:mm:ss")
                                                            .format(dateTime));
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(Icons
                                                    .calendar_month_rounded),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 8,
                                                        left: 16,
                                                        right: 16),
                                                filled: true,
                                                fillColor:
                                                    Constant.onPrimaryColor,
                                                hintText: "DD/MM/YYYY HH:MM",
                                                labelStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color: Constant
                                                            .secondaryColor,
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: const BorderSide(
                                                        color: Constant.secondaryColor,
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)))),
                                      ),
                                      Text(
                                        "Duration: 60 minutes",
                                        style:
                                            TextStyle(color: Colors.grey[600]!),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Constant
                                                                  .onPrimaryColor),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Constant
                                                                  .primaryColor)),
                                                  onPressed: () {
                                                    interviewTitleController
                                                        .clear();
                                                    startDateController.clear();
                                                    endDateController.clear();
                                                    context.pop();
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Constant
                                                                  .primaryColor),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Constant
                                                                  .onPrimaryColor)),
                                                  onPressed: () {
                                                    interviewTitleController
                                                        .clear();
                                                    startDateController.clear();
                                                    endDateController.clear();
                                                    context.pop();
                                                  },
                                                  child: const Text("Confirm"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ));
                        });
                      }),
                  icon: const FaIcon(
                    FontAwesomeIcons.calendar,
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
              controller: _ListScrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                final isCurrentUser = message.senderId == userId;
                return MessageDetailItem(
                  isCurrentUser: isCurrentUser,
                  fullname: isCurrentUser ? senderName : receiverName ?? "",
                  timeCreated: DateFormat('HH:mm MM-dd')
                      .format(DateTime.parse(message.createdAt.toString())),
                  message: message.content ?? "empty??",
                  isScheduleItem: false,
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
                      controller: sendMessageDetailController,
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
                      onPressed: () {
                        sendMessage
                            // (messageController.text);
                            (sendMessageDetailController.text);
                        sendMessageDetailController.clear();
                      }),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
