import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/meeting.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/Message/chat_video_schedule.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActiveInterview extends StatefulWidget {
  const ActiveInterview({super.key});

  @override
  _ActiveInterviewState createState() => _ActiveInterviewState();
}

class _ActiveInterviewState extends State<ActiveInterview> {
  bool isLoading = false;
  List<Interview> aInterviewList = [];

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

  Future<void> getActiveInterviewList() async {
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
      final userId = userProvider.userInfo['id'];
      final endpoint = '${Constant.baseURL}/api/interview/user/$userId';
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
      final List<Interview> fetchedInterview = [];
      for (var interview in result) {
        // Message detailMsg = Message.fromJson(message);
        // final senderID = message['sender']['id'];
        // print(senderID);
        // print(userId);
        // if (senderID == userId) {
        //   continue;
        // }
        final inter = Interview.fromJson(interview);
        print(inter);
        fetchedInterview.add(inter);
      }

      if (mounted) {
        setState(() {
          aInterviewList = fetchedInterview;
        });
      }
      print(aInterviewList);
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
    getActiveInterviewList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Text(
                  "Messages: ",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary),
                )),
            isLoading
                ? Expanded(
                    child: Center(
                        child: SpinKitThreeBounce(
                            size: 32,
                            duration: Durations.extralong4,
                            color: Theme.of(context).colorScheme.primary)),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: aInterviewList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final interview = aInterviewList[index];

                          return ChatVideoSchedule(
                              isCurrentUser: true,
                              username: "",
                              startTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(interview.startTime),
                              endTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(interview.endTime),
                              meetingName: interview.title,
                              duration:
                                  "${interview.endTime.difference(interview.startTime).inHours.toString()} hours",
                              isCancelled:
                                  interview.disableFlag == 1, //enable = 0
                              timeCreated: "",
                              interview: interview);
                        })),
          ],
        )),
      ),
    );
  }
}
