import 'package:amp_studenthub/core/socket_manager.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../configs/constant.dart';

class CompanyNavbarScaffold extends StatefulWidget {
  final Widget child;
  final String location;
  const CompanyNavbarScaffold(
      {super.key, required this.child, required this.location});

  @override
  State<CompanyNavbarScaffold> createState() => _CompanyNavbarScaffoldState();
}

class _CompanyNavbarScaffoldState extends State<CompanyNavbarScaffold> {
  int selectedIndex = 0;
  bool hasNotification = false;
  int notificationCount = 0;
  late Socket socket;

  final routePaths = ['/project', '/dashboard', '/message', '/notification'];

  void navigateTab(BuildContext context, int index) {
    if (index == selectedIndex) return;
    if (index == 3) {
      setState(() {
        hasNotification = false;
        notificationCount = 0;
      });
    }
    String location = routePaths[index];
    setState(() {
      selectedIndex = index;
    });
    GoRouter.of(context).go(location);
  }

  @override
  void initState() {
    super.initState();
    getUnreadNotiCount();
    connectSocket();
  }

  @override
  void dispose() {
    SocketManager().unregisterSocketListener(onReceiveMessage);
    print("dispose");
    super.dispose();
  }

  void getUnreadNotiCount() async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      final userId = userProvider.userInfo['id'];
      final endpoint =
          '${Constant.baseURL}/api/notification/getByReceiverId/$userId';
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
      int count = 0;
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
      for (var noti in result) {
        print(noti["notifyFlag"]);
        // detailMsg.senderId = message['sender']['id'];
        if (noti['notifyFlag'] == "0") {
          count++;
        }
      }
      print(count);
      if (mounted) {
        setState(() {
          notificationCount = count;
        });
      }
      print(notificationCount);
    } catch (e) {
      print(e);
    }
  }

  void onReceiveMessage(data) {
    print(data);
    print("receiveNoti");
    print(notificationCount);
    setState(() {
      hasNotification = true;
      notificationCount = notificationCount + 1;
    });
    print(notificationCount);
  }

  Future<void> connectSocket() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userInfo['id'];
    final socketManager = SocketManager();
    socket = await socketManager.connectSocket(context, userId);
    SocketManager().registerSocketListener(onReceiveMessage);
    print(socket);
  }

  String displayNotiCount(notificationCount) {
    if (notificationCount > 99) {
      return "99+";
    } else {
      return "$notificationCount";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        height: 80,
        backgroundColor: Constant.backgroundWithOpacity,
        indicatorColor: Constant.primaryColor,
        surfaceTintColor: Constant.onPrimaryColor,
        selectedIndex: routePaths.contains(widget.location) &&
                routePaths.indexOf(widget.location) < routePaths.length
            ? routePaths.indexOf(widget.location)
            : 0,
        onDestinationSelected: (value) => {navigateTab(context, value)},
        destinations: [
          const NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
          const NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.solidFolder), label: "Dashboard"),
          const NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.solidEnvelope), label: "Message"),
          NavigationDestination(
              icon: notificationCount > 0
                  ? Stack(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.solidBell),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              displayNotiCount(notificationCount),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  : FaIcon(FontAwesomeIcons.solidBell),
              label: "Notification"),
        ],
      ),
    );
  }
}
