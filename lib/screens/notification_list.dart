import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/core/socket_manager.dart';
import 'package:amp_studenthub/models/message.dart';
import 'package:amp_studenthub/models/notification.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/utilities/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  bool isLoading = false;
  bool isSubmitting = false;
  Set<DashboardFilterOptions> selectedFilterOptions = {
    DashboardFilterOptions.all
  };

  late io.Socket socket;
  final interviewTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final sendMessageDetailController = TextEditingController();
  final _ListScrollController = ScrollController();

  String senderName = '';

  _NotificationListScreenState();

  var userId = 0;
  bool socketInitialized = false;
  List<NotificationModel> notifications = [];
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

  Future<void> getNotification(receiverId, projectId) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;

      final endpoint =
          '${Constant.baseURL}/api/notification/getByReceiverId/$receiverId';
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
      print(response);
      print(result);
      final List<NotificationModel> fetchedNoti = [];
      // final fetchedReceiverId = result[0]['receiver']['id'];
      // final fetchedSenderId = result[0]['sender']['id'];
      // if (receiverId == fetchedReceiverId) {
      //   receiverName = result[0]['receiver']['fullname'];
      //   senderName = result[0]['sender']['fullname'];
      // } else if (receiverId == fetchedSenderId) {
      //   receiverName = result[0]['sender']['fullname'];
      //   senderName = result[0]['receiver']['fullname'];
      // } else {
      //   receiverName = 'errorName';
      //   senderName = 'errorName';
      // }
      // print(receiverName);
      // print(senderName);
      for (var message in result) {
        NotificationModel noti = NotificationModel.fromJson(message);
        // detailMsg.senderId = message['sender']['id'];
        print(noti);
        fetchedNoti.add(noti);
      }
      if (mounted) {
        setState(() {
          notifications = fetchedNoti;
        });
      }
      print(notifications);
    } catch (e) {
      print(e);
    }
  }

  Future<void> init() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userId = userProvider.userInfo['id'];
    //get message
    await getNotification(userId, "");
    if (socketInitialized == false) {
      print(socketInitialized);
      await connectSocket();
      socketInitialized = true;
    }
  }

  addMessage(notification) {
    final notiNew = notifications;
    notiNew.insert(0, notification);
    setState(() {
      notifications = notiNew;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // print(socket.connected);
    // socket.disconnect();
    // socket.dispose();
    // print(socket.connected);
    _ListScrollController.dispose();
    interviewTitleController.dispose();
    startDateController.dispose();
    endDateController.dispose();

    sendMessageDetailController.dispose();
    SocketManager().unregisterSocketListener(onReceiveNotification);
    print('Socket Disconnected');
  }

  void onReceiveNotification(data) {
    print(data);
    print(data["notification"]);

    try {
      final notification = NotificationModel.fromJson(data["notification"]);
      print(notification);
      addMessage(notification);
      print(notifications[0].typeNotifyFlag);
      // final notification = NotificationModel.fromJson(data);
      // print(notification);
      // final newMsg = Message.fromJson(data["notification"]);
      // if (newMsg.senderId != receiverId ||
      //     newMsg.receiverId != userId ||
      //     projectId != newMsg.projectId) {
      //   print(
      //       "rejected ${newMsg.senderId != receiverId} || ${newMsg.receiverId != userId} || ${projectId != newMsg.projectId}");
      //   return;
      // }
      // addMessage(newMsg);
      // print(messages);
      // // print(notification.sender.fullname);
      // // print(notification.receiver.fullname);
      // scrollToBottom();
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectSocket() async {
    final socketManager = SocketManager();
    socket = await socketManager.connectSocket(context, userId);
    SocketManager().registerSocketListener(onReceiveNotification);
    print(socket);
    if (mounted) {
      setState(() {
        socketInitialized = true;
      });
    }
  }

  // final List<UserNotification> allNotifications = [
  //   UserNotification(
  //       'notification1',
  //       "Submitted for project \"Javis - AI Copilot\"",
  //       NotificationType.activity,
  //       '2024-03-19'),
  //   UserNotification(
  //       'notification2',
  //       "Invited to interview for project \"Javis - AI Copilot\"",
  //       NotificationType.interview,
  //       '2024-03-19'),
  //   UserNotification(
  //       'notification3',
  //       "Offered to join project \"Javis - AI Copilot\"",
  //       NotificationType.offer,
  //       '2024-03-19'),
  //   UserNotification('notification4', "New message from Quang Nguyen",
  //       NotificationType.message, '2024-03-19'),
  //   UserNotification(
  //       'notification5',
  //       "Invited to interview for project \"Front-end Project\"",
  //       NotificationType.interview,
  //       '2024-03-19')
  // ];

  checkMessageDetail(NotificationModel notification) {
    if (notification.typeNotifyFlag != NotificationType.message) {
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = userProvider.userInfo;
    final userId = userInfo['id'];
    final projectId = notification.message['projectId'];
    final senderId = notification.message['senderId'];
    print({
      'userId': userId.toString(),
      'receiverId': senderId.toString(),
      'projectId': projectId.toString(),
    });
    GoRouter.of(context).pushNamed(
      RouteConstants.messageDetail,
      queryParameters: {
        'userId': userId.toString(),
        'receiverId': senderId.toString(),
        'projectId': projectId.toString(),
      },
    );
  }

  getNotificationIcon(int typeNotifyFlag) {
    if (typeNotifyFlag == NotificationType.submitted) {
      return const FaIcon(FontAwesomeIcons.bell,
          color: Constant.onPrimaryColor);
    }
    if (typeNotifyFlag == NotificationType.interview) {
      return const FaIcon(FontAwesomeIcons.calendar,
          color: Constant.onPrimaryColor);
    }
    if (typeNotifyFlag == NotificationType.offer) {
      return const FaIcon(FontAwesomeIcons.clipboard,
          color: Constant.onPrimaryColor);
    }
    if (typeNotifyFlag == NotificationType.message) {
      return const FaIcon(
        FontAwesomeIcons.envelope,
        color: Constant.onPrimaryColor,
      );
    }
    if (typeNotifyFlag == NotificationType.hired) {
      return const FaIcon(FontAwesomeIcons.check,
          color: Constant.onPrimaryColor);
    }
  }

  markAsRead(notification) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      final dio = Dio();
      final endpoint =
          '${Constant.baseURL}/api/notification/readNoti/${notification.id}';
      final Response response = await dio.patch(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      print(endpoint);
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      print("successful + $response");
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProposalStatusFlag(int statusFlag, int proposalId) async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isSubmitting = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String updateStatusFlagEndpoint =
          '${Constant.baseURL}/api/proposal/$proposalId';
      await dio.patch(updateStatusFlagEndpoint,
          data: {'statusFlag': statusFlag},
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.statusCode);
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              // Layout Container Expand All Height
              child: Column(
            children: [
              // Title
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: const Text(
                    "Notifications: ",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Constant.primaryColor),
                  )),
              // Render Job List
              if (notifications.isEmpty)
                Expanded(
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
                          "Your notification list is empty",
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
              else
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                              //bottom up
                              physics: const ClampingScrollPhysics(),
                              itemCount: notifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                NotificationModel notification =
                                    notifications[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: InkWell(
                                    onTap: () {
                                      if (notification.typeNotifyFlag ==
                                          NotificationType.message) {
                                        checkMessageDetail(notification);
                                        markAsRead(notification);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey[500]!),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      // Column Layout Of Card
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 16),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Container(
                                                        height: 48,
                                                        width: 48,
                                                        color: Constant
                                                            .primaryColor,
                                                        alignment:
                                                            Alignment.center,
                                                        child: getNotificationIcon(
                                                            notification
                                                                .typeNotifyFlag),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${notification.content}",
                                                        style: const TextStyle(
                                                            color: Constant
                                                                .secondaryColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 4),
                                                        child: Text(
                                                          DateFormat(
                                                                  'hh:mm MM-dd')
                                                              .format(notification
                                                                  .createdAt),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            notification.typeNotifyFlag ==
                                                        NotificationType
                                                            .interview ||
                                                    notification
                                                            .typeNotifyFlag ==
                                                        NotificationType.offer
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 8),
                                                        child: const Divider(),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height: 48,
                                                          child: TextButton(
                                                            onPressed: () {
                                                              if (notification
                                                                      .typeNotifyFlag ==
                                                                  NotificationType
                                                                      .interview) {
                                                              } else {
                                                                updateProposalStatusFlag(
                                                                    3,
                                                                    notification
                                                                            .proposal[
                                                                        'id']);
                                                              }
                                                            },
                                                            style: TextButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                                side: const BorderSide(
                                                                    color: Constant
                                                                        .backgroundColor,
                                                                    width: 1),
                                                                foregroundColor:
                                                                    Constant
                                                                        .primaryColor),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    notification.typeNotifyFlag ==
                                                                            NotificationType.interview
                                                                        ? "Join Interview"
                                                                        : "Accept Offer",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                    ],
                                                  )
                                                : Container()
                                          ]),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                )
            ],
          )),
        ]),
      ),
    ));
  }
}
