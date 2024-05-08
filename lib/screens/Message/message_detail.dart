import 'dart:convert';
import 'dart:math';

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

class MessageDetail extends StatefulWidget {
  const MessageDetail({super.key});

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  final interviewTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  Future<void> scheduleInterview(BuildContext context, String title,
      String startTime, String endTime) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      const endpoint = '${Constant.baseURL}/api/interview';
      var data = {
        "title": title,
        "content": "string",
        "startTime": startTime,
        "endTime": endTime,
        "projectId": 835,
        "senderId": 341,
        "receiverId": 227,
        "meeting_room_code": Random().nextInt(1000000).toString(),
        "meeting_room_id": Random().nextInt(1000000).toString(),
        "expired_at": endTime
      };

      final Response response = await dio.post(
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
                                                    scheduleInterview(
                                                        context,
                                                        interviewTitleController
                                                            .text,
                                                        startDateController
                                                            .text,
                                                        endDateController.text);
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
                    onPressed: () {},
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
