import 'dart:convert';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
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
  final dynamic interview;

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
      var endpoint = '${Constant.baseURL}/api/interview/${interview['id']}';
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
          '${Constant.baseURL}/api/interview/${interview['id']}/disable';

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
                    style: const TextStyle(
                      color: Constant.textColor,
                      fontSize: 12,
                    ),
                  ),
            Text(
              " ${widget.username}",
              style: const TextStyle(
                color: Constant.textColor,
                fontSize: 12,
              ),
              textAlign:
                  widget.isCurrentUser ? TextAlign.right : TextAlign.left,
            ),
            widget.isCurrentUser
                ? const Text("")
                : Text(
                    widget.timeCreated,
                    style: const TextStyle(
                      color: Constant.textColor,
                      fontSize: 12,
                    ),
                  ),
          ],
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Constant.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Constant.primaryColor,
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
                    style: const TextStyle(color: Constant.textColor),
                  ),
                  Text(
                    widget.duration,
                    style: const TextStyle(color: Constant.textColor),
                  )
                ],
              ),
              Text(
                "Start Time: ${DateFormat('HH:mm MM-dd').format(DateTime.parse(widget.startTime))}",
                style: const TextStyle(color: Constant.textColor),
              ),
              Text(
                "End Time: ${DateFormat('HH:mm MM-dd').format(DateTime.parse(widget.endTime))}",
                style: const TextStyle(color: Constant.textColor),
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
                            String? meetingRoomCode = widget
                                .interview['meetingRoom']['meeting_room_code'];
                            if (meetingRoomCode != null &&
                                meetingRoomCode != "") {
                              context.pushNamed(RouteConstants.videoCall,
                                  queryParameters: {
                                    meetingRoomCode: meetingRoomCode
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.primaryColor,
                          ),
                          child: const Text(
                            "Join Meeting",
                            style: TextStyle(color: Constant.onPrimaryColor),
                          ),
                        ),
                        // IconButton(
                        //     color: Constant.secondaryColor,
                        //     onPressed: () {},
                        //     icon: Icon(Icons.more_horiz_rounded))
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
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      child: Text(
                                                          "Schedule An Interview",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Constant
                                                                  .primaryColor,
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
                                                      child: const Text(
                                                        "Title:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Constant
                                                                .textColor),
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
                                                              contentPadding:
                                                                  const EdgeInsets.only(
                                                                      top: 8,
                                                                      left: 16,
                                                                      right:
                                                                          16),
                                                              filled: true,
                                                              fillColor: Constant
                                                                  .onPrimaryColor,
                                                              hintText:
                                                                  "Enter interview title...",
                                                              labelStyle: TextStyle(
                                                                  color: Colors.grey[
                                                                      600]),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                  borderSide: const BorderSide(
                                                                      color: Constant
                                                                          .secondaryColor,
                                                                      width:
                                                                          1)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)))),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: const Text(
                                                        "Start time:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Constant
                                                                .textColor),
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
                                                              prefixIcon: const Icon(Icons
                                                                  .calendar_month_rounded),
                                                              contentPadding: const EdgeInsets.only(
                                                                  top: 8,
                                                                  left: 16,
                                                                  right: 16),
                                                              filled: true,
                                                              fillColor: Constant
                                                                  .onPrimaryColor,
                                                              hintText:
                                                                  "DD/MM/YYYY HH:MM",
                                                              labelStyle: TextStyle(
                                                                  color: Colors.grey[
                                                                      600]),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                  borderSide: const BorderSide(
                                                                      color: Constant
                                                                          .secondaryColor,
                                                                      width:
                                                                          1)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(12),
                                                                  borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)))),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: const Text(
                                                        "End time:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Constant
                                                                .textColor),
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
                                                              prefixIcon: const Icon(Icons
                                                                  .calendar_month_rounded),
                                                              contentPadding: const EdgeInsets.only(
                                                                  top: 8,
                                                                  left: 16,
                                                                  right: 16),
                                                              filled: true,
                                                              fillColor: Constant
                                                                  .onPrimaryColor,
                                                              hintText:
                                                                  "DD/MM/YYYY HH:MM",
                                                              labelStyle: TextStyle(
                                                                  color: Colors.grey[
                                                                      600]),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                  borderSide: const BorderSide(
                                                                      color: Constant
                                                                          .secondaryColor,
                                                                      width:
                                                                          1)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(12),
                                                                  borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Constant.secondaryColor, width: 1)))),
                                                    ),
                                                    Text(
                                                      "Duration: 60 minutes",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[600]!),
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
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Constant
                                                                              .onPrimaryColor),
                                                                  foregroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Constant
                                                                              .primaryColor)),
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
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Constant
                                                                              .primaryColor),
                                                                  foregroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Constant
                                                                              .onPrimaryColor)),
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
