import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/notification.dart';
import 'package:amp_studenthub/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  Set<DashboardFilterOptions> selectedFilterOptions = {
    DashboardFilterOptions.all
  };

  final List<UserNotification> allNotifications = [
    UserNotification(
        'notification1',
        "Submitted for project \"Javis - AI Copilot\"",
        NotificationType.activity,
        '2024-03-19'),
    UserNotification(
        'notification2',
        "Invited to interview for project \"Javis - AI Copilot\"",
        NotificationType.interview,
        '2024-03-19'),
    UserNotification(
        'notification3',
        "Offered to join project \"Javis - AI Copilot\"",
        NotificationType.offer,
        '2024-03-19'),
    UserNotification('notification4', "New message from Quang Nguyen",
        NotificationType.message, '2024-03-19'),
    UserNotification(
        'notification5',
        "Invited to interview for project \"Front-end Project\"",
        NotificationType.interview,
        '2024-03-19')
  ];

  getNotificationIcon(String type) {
    if (type == NotificationType.activity) {
      return const FaIcon(FontAwesomeIcons.bell,
          color: Constant.onPrimaryColor);
    }
    if (type == NotificationType.interview) {
      return const FaIcon(FontAwesomeIcons.calendar,
          color: Constant.onPrimaryColor);
    }
    if (type == NotificationType.offer) {
      return const FaIcon(FontAwesomeIcons.clipboard,
          color: Constant.onPrimaryColor);
    }
    if (type == NotificationType.message) {
      return const FaIcon(
        FontAwesomeIcons.envelope,
        color: Constant.onPrimaryColor,
      );
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
              if (allNotifications.isEmpty)
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
                          "Welcome, Quang!\nYour job list is empty",
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
                              physics: const ClampingScrollPhysics(),
                              itemCount: allNotifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                UserNotification notification =
                                    allNotifications[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: InkWell(
                                    onTap: () {},
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
                                                        child:
                                                            getNotificationIcon(
                                                                notification
                                                                    .type),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notification.content,
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
                                                          notification
                                                              .createdAt,
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
                                            notification.type ==
                                                        NotificationType
                                                            .interview ||
                                                    notification.type ==
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
                                                            onPressed: () {},
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
                                                                    notification.type ==
                                                                            NotificationType.interview
                                                                        ? "Join Interview"
                                                                        : "View Offer",
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
