import 'dart:convert';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/models/meeting.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class ChatVideoSchedule extends StatefulWidget {
  final bool isCurrentUser;
  final String username;
  final String startTime;
  final String endTime;
  final String meetingName;
  final String duration;
  final bool isCancelled;
  final String timeCreated;
  final Interview interview;

  const ChatVideoSchedule(
      {super.key,
      required this.isCurrentUser,
      required this.username,
      required this.startTime,
      required this.endTime,
      required this.meetingName,
      required this.duration,
      required this.isCancelled,
      required this.timeCreated,
      required this.interview});

  @override
  State<ChatVideoSchedule> createState() => _ChatVideoScheduleState();
}

class _ChatVideoScheduleState extends State<ChatVideoSchedule> {
  final interviewTitleController = TextEditingController();
  final endDateController = TextEditingController();
  final startDateController = TextEditingController();

  Future<void> scheduleInterview(BuildContext context, String title,
      String startTime, String endTime) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      final interview = widget.interview;
      var endpoint = '${Constant.baseURL}/api/interview/${interview.id}';
      var data = {
        "title": title,
        "startTime": startTime,
        "endTime": endTime,
      };

      final Response response = await dio.patch(
        endpoint,
        data: jsonEncode(data),
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        print("INTERVIEW DATA: ");
        print(result);
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final responseData = e.response?.data;
        print(responseData);
      } else {
        print(e.message);
      }
    }
  }

  Future<void> cancelInterview(BuildContext context) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      final interview = widget.interview;
      var endpoint =
          '${Constant.baseURL}/api/interview/${interview.id}/disable';

      final Response response = await dio.patch(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        print("INTERVIEW DATA: ");
        print(result);
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final responseData = e.response?.data;
        print(responseData);
      } else {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
        child: Row(
          mainAxisAlignment: widget.isCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            !widget.isCurrentUser
                ? const Text("")
                : Text(
                    widget.timeCreated,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12,
                    ),
                  ),
            Text(
              " ${widget.username} ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 12,
              ),
              textAlign:
                  widget.isCurrentUser ? TextAlign.right : TextAlign.left,
            ),
            widget.isCurrentUser
                ? const Text("")
                : Text(
                    widget.timeCreated,
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
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.meetingName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  Text(
                    widget.duration,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  )
                ],
              ),
              Text(
                "Start Time: ${widget.startTime}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              Text(
                "End Time: ${widget.endTime}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              widget.isCancelled
                  ? Text("Meeting cancelled",
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.red[300]))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String? meetingRoomCode =
                                widget.interview.meetingRoom.meetingRoomCode;
                            if (meetingRoomCode != "") {
                              context.pushNamed(RouteConstants.videoCall,
                                  queryParameters: {
                                    meetingRoomCode: meetingRoomCode
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(
                            "Join Meeting",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                        PopupMenuButton(itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return SingleChildScrollView(
                                            child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: SizedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                      child: Text(
                                                          "Schedule An Interview",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    const Divider(),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 16,
                                                              bottom: 8),
                                                      child: Text(
                                                        "Title:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 16),
                                                      child: TextFormField(
                                                          controller:
                                                              interviewTitleController,
                                                          decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.only(
                                                                  top: 8,
                                                                  left: 16,
                                                                  right: 16),
                                                              filled: true,
                                                              fillColor: Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                              hintText:
                                                                  "Enter interview title...",
                                                              labelStyle: TextStyle(
                                                                  color: Colors.grey[
                                                                      600]),
                                                              border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(
                                                                      12),
                                                                  borderSide: BorderSide(
                                                                      color: Theme.of(context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                      width:
                                                                          1)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)))),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Text(
                                                        "Start time:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 16),
                                                      child: TextFormField(
                                                          controller:
                                                              startDateController,
                                                          onTap: () async {
                                                            DateTime? dateTime =
                                                                await showOmniDateTimePicker(
                                                                    context:
                                                                        context);
                                                            if (dateTime !=
                                                                null) {
                                                              startDateController
                                                                      .value =
                                                                  TextEditingValue(
                                                                      text: DateFormat(
                                                                              "yyyy-MM-dd HH:mm:ss")
                                                                          .format(
                                                                              dateTime));
                                                            }
                                                          },
                                                          decoration: InputDecoration(
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .calendar_month_rounded),
                                                              contentPadding:
                                                                  const EdgeInsets.only(
                                                                      top: 8,
                                                                      left: 16,
                                                                      right:
                                                                          16),
                                                              filled: true,
                                                              fillColor:
                                                                  Theme.of(context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                              hintText:
                                                                  "DD/MM/YYYY HH:MM",
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      Colors.grey[
                                                                          600]),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                  borderSide: BorderSide(
                                                                      color: Theme.of(context).colorScheme.secondary,
                                                                      width: 1)),
                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)))),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Text(
                                                        "End time:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 16),
                                                      child: TextFormField(
                                                          controller:
                                                              endDateController,
                                                          onTap: () async {
                                                            DateTime? dateTime =
                                                                await showOmniDateTimePicker(
                                                                    context:
                                                                        context);
                                                            if (dateTime !=
                                                                null) {
                                                              endDateController
                                                                      .value =
                                                                  TextEditingValue(
                                                                      text: DateFormat(
                                                                              "yyyy-MM-dd HH:mm:ss")
                                                                          .format(
                                                                              dateTime));
                                                            }
                                                          },
                                                          decoration: InputDecoration(
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .calendar_month_rounded),
                                                              contentPadding:
                                                                  const EdgeInsets.only(
                                                                      top: 8,
                                                                      left: 16,
                                                                      right:
                                                                          16),
                                                              filled: true,
                                                              fillColor:
                                                                  Theme.of(context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                              hintText:
                                                                  "DD/MM/YYYY HH:MM",
                                                              labelStyle: TextStyle(
                                                                  color: Theme.of(context)
                                                                      .colorScheme
                                                                      .tertiary),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                  borderSide: BorderSide(
                                                                      color: Theme.of(context).colorScheme.secondary,
                                                                      width: 1)),
                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)))),
                                                    ),
                                                    Text(
                                                      "Duration: 60 minutes",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<
                                                                      Color>(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary),
                                                                  foregroundColor: MaterialStateProperty.all<
                                                                      Color>(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                              onPressed: () {
                                                                interviewTitleController
                                                                    .clear();
                                                                startDateController
                                                                    .clear();
                                                                endDateController
                                                                    .clear();
                                                                context.pop();
                                                              },
                                                              child: const Text(
                                                                  "Cancel"),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<
                                                                      Color>(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary),
                                                                  foregroundColor: MaterialStateProperty.all<
                                                                      Color>(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary)),
                                                              onPressed: () {
                                                                scheduleInterview(
                                                                    context,
                                                                    interviewTitleController
                                                                        .text,
                                                                    startDateController
                                                                        .text,
                                                                    endDateController
                                                                        .text);
                                                                interviewTitleController
                                                                    .clear();
                                                                startDateController
                                                                    .clear();
                                                                endDateController
                                                                    .clear();

                                                                context.pop();
                                                              },
                                                              child: const Text(
                                                                  "Confirm"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ));
                                      });
                                    });
                              },
                              child: const Text("Reschedule"),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                cancelInterview(context);
                                setState(() {});
                              },
                              child: const Text("Cancel"),
                            ),
                          ];
                        })
                      ],
                    )
            ],
          ))
    ]);
  }
}
