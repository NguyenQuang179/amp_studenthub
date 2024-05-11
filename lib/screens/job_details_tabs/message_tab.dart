import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/Message/message_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MessageTab extends StatefulWidget {
  final String projectId;
  const MessageTab({super.key, required this.projectId});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  bool isLoading = false;
  List<dynamic> messagesList = [];
  CompanyProject? projectDetails;

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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      String endpoint = '${Constant.baseURL}/api/message/${widget.projectId}';
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
    }
  }

  Future<void> fetchCompanyProjectDetails() async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String endpoint = '${Constant.baseURL}/api/project/${widget.projectId}';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      final CompanyProject projectDetailRes = CompanyProject.fromJson(result);
      if (mounted) {
        setState(() {
          projectDetails = projectDetailRes;
        });
      }
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
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyProjectDetails();
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                width: double.infinity,
                child: const Text(
                  'Message:',
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Constant.primaryColor),
                )),
            isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: const Center(
                        child: SpinKitThreeBounce(
                            size: 32,
                            duration: Durations.extralong4,
                            color: Constant.primaryColor)),
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
                          receiverPosition: projectDetails?.title ?? "",
                          onClick: () =>
                              checkDetail(receiverId, widget.projectId),
                          isSaved: false);
                    },
                  )),
          ],
        )),
      ),
    );
  }
}
