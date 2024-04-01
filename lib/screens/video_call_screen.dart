import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        child: Center(
            child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[500]!),
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[500]!),
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                  ),
                )
              ],
            )),
            //userInput
            SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.microphone),
                    onPressed: () {},
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.camera),
                      onPressed: () {},
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.phoneSlash),
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
