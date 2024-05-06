import 'dart:math';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

var userID = Random().nextInt(1000).toString();

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

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
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.ellipsis,
                    size: 16,
                  ))),
        ],
      ),
      body: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID:
              301809692, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign:
              '6847d07a0f58a41c1a72bf864fc8f9d22d39700611c94f9f1f30ba2d521d0f24', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: userID,
          userName: 'user_$userID',
          conferenceID: '123',
          config: ZegoUIKitPrebuiltVideoConferenceConfig(),
        ),
      ),
    );
  }
}
