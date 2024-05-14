// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';

class VideoCallScreen extends StatelessWidget {
  final String conferenceId;

  const VideoCallScreen({
    super.key,
    required this.conferenceId,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID: Constant.appId,
          appSign: Constant.appSign,
          userID: userProvider.userInfo['id']!.toString(),
          userName: userProvider.userInfo['fullname'],
          conferenceID: conferenceId,
          config: ZegoUIKitPrebuiltVideoConferenceConfig(),
        ),
      ),
    );
  }
}
