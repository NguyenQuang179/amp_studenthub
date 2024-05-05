import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/screens/Message/message_detail_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_io_socket/flutter_io_socket.dart' as io;
import 'package:flutter_io_socket/flutter_io_socket.dart' as io;


class MessageDetail extends StatefulWidget {
  //    final int userId;
  // final int receiverId;
  // final int projectId;
  // final String receiverName;

  const MessageDetail({super.key});

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  late io.Socket socket;
  final interviewTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final int userId = 139;
  final int receiverId = 139;
  final int projectId = 2;
  final String receiverName = 'Luis Pham ';
  bool socketInitialized = false;
  late final dynamic messages;
  @override
  void initState() {
    super.initState();
    init();
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

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      print(result);
      if (mounted) {
        setState(() {
          messages = result;
        });
      }
      print(this.messages);
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

  @override
  void dispose() {
    super.dispose();
    print(socket.connected);
    socket.disconnect();
    print(socket.connected);

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
          .disableAutoConnect()
          .build(),
    );
    socket.io.options['extraHeaders'] = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDUsImZ1bGxuYW1lIjoiR2lhIEh1eSIsImVtYWlsIjoicmV4ZnVyeTEyMUBnbWFpbC5jb20iLCJyb2xlcyI6WzBdLCJpYXQiOjE3MTQ4OTM5NzUsImV4cCI6MTcxNjEwMzU3NX0.o48lN9Qhhg7ch5mbKZMh-DMrgZ04PWHfc7bTKTlDBSE',
    };
    socket.io.options['query'] = {
      'project_id': projectId.toString(),
    };
    print(socket);
    socket.connect();
    socket.onConnect((data) => print('Connected'));
    socket.onDisconnect((data) => print('Disconnected'));

    socket.onConnectError((data) => print('connect error: $data'));
    socket.onError((data) => print('error: $data'));
    socket.on('RECEIVE_MESSAGE', (data) => print(data));
    socket.on('RECEIVE_INTERVIEW', (data) => print(data));
    socket.on('ERROR', (data) => print(data));

    setState(() {
      socketInitialized = true;
    });
//     socket = IO.io(
//         'https://api.studenthub.dev',
//         IO.OptionBuilder()
//             .setTransports(['websocket', 'polling'])
//             .disableAutoConnect()
//             .setExtraHeaders({"Authorization": "Bearer $accessToken"})
//             .build());

// //Add query param to url
//     socket.io.options?['query'] = {'project_id': 2};

//     print(IO.OptionBuilder()
//         .setTransports(['websocket', 'polling'])
//         .disableAutoConnect()
//         .setExtraHeaders({"Authorization": "Bearer $accessToken"})
//         .build());
//     print("Connecting to socket.io server");
//     // socket.io.options?['query'] = {'project_id': projectId};

//     // Add authorization to header
//     print('Bearer $accessToken');
//     print(socket.io.options);
//     // socket.io.options?['extraHeaders'] = {
//     //   'Authorization': 'Bearer $accessToken',
//     // };
//     // print(socket.io.options?['extraHeaders']);
// // Connect to the socket.io server
// //     socket.connect();
// //     socket.on('RECEIVE_MESSAGE', (data) {
// //       print(data);
// //       // Update the state with the received message
// //     });
// //     socket.onConnect((data) => {
// //           print('Connected'),
// //         });

// //     socket.onDisconnect((data) => {
// //           print('Disconnected'),
// //         });
// //     // Listen to socket events
// //     socket.onAny((String event, data) {
// //       print([event, data]);
// //     });

// // Add authorization to header
//     print(socket.io.options?['extraHeaders']);

//     socket.io.options?['extraHeaders'] = {
//       'Authorization': 'Bearer ${accessToken}',
//     };
//     print(socket.io.options?['extraHeaders']);

//     socket.connect();

//     socket.onConnect((data) => {
//           print('Connected'),
//         });

//     socket.onDisconnect((data) => {
//           print('Disconnected'),
//         });

//     socket.onConnectError((data) => print('$data connect error error error'));
//     socket.onError((data) => print(data));
//     // socket.onConnectTimeout((data) => print('$data connect timeout'));
// //Listen to channel receive message
//     socket.on('RECEIVE_MESSAGE', (data) {
//       // Your code to update ui
//       print(data);
//     });
// //Listen for error from socket
//     socket.on("ERROR", (data) => print('$data error'));
//     socket.on("NOTI_1", (data) => print(data));
  }

  void sendMessage(String message) {
    final form = {
      "senderId": userId,
      "receiverId": receiverId,
      "projectId": projectId,
      "content": message,
      "messageFlag": 0,
    };
    socket.emit('SEND_MESSAGE', form);
  }

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
                    onPressed: () {
                      socket.emit('SEND_MESSAGE', {
                        'content': 'Hello World',
                        'projectId': 1,
                        'senderId': 139,
                        'receiverId': 2,
                        'messageFlag': 0,
                      });
                    },
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
