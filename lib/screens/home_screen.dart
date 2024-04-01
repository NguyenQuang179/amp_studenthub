import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.backgroundColor,
        toolbarHeight: 64,
        title: const Text(
          'StudentHub',
          style: TextStyle(
              color: Constant.primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Constant.primaryColor,
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: Constant.onPrimaryColor,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 32, right: 32),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Constant.backgroundColor,
                      child: Center(
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                          height: 120,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: RichText(
                                text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.8,
                                color: Constant.textColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'StudentHub ',
                                    style: TextStyle(
                                        color: Constant.primaryColor,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                  text:
                                      'is university market place to connect high-skilled student and company on a real - world project.',
                                ),
                              ],
                            ))))
                  ],
                )),
          ),
          Expanded(
            flex: 6,
            child: Container(
                decoration: const BoxDecoration(
                    color: Constant.backgroundColor,
                    border: BorderDirectional(
                        top: BorderSide(width: 2, color: Constant.primaryColor),
                        start:
                            BorderSide(width: 2, color: Constant.primaryColor),
                        end:
                            BorderSide(width: 2, color: Constant.primaryColor)),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32))),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: RichText(
                        text: const TextSpan(
                            style: TextStyle(
                              fontSize: 24,
                              height: 1.8,
                              color: Constant.primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "Build your product with\n"),
                              TextSpan(
                                  text: "high-skilled student",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: RichText(
                          text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Constant.textColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Find and onboard '),
                          TextSpan(
                              text: "best-skilled student ",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: 'for your product. Student works to '),
                          TextSpan(
                              text: 'gain experience & skills ',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: 'from '),
                          TextSpan(
                              text: 'real-world projects.',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      )),
                    ),
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Join with us as:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: double.infinity,
                                height: 48,
                                child: TextButton(
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .goNamed(RouteConstants.company);
                                  },
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      backgroundColor: Constant.primaryColor,
                                      foregroundColor: Constant.onPrimaryColor),
                                  child: const Text(
                                    'Student',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                            SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      side: const BorderSide(
                                          width: 1,
                                          color: Constant.primaryColor),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      backgroundColor: Constant.backgroundColor,
                                      foregroundColor: Constant.primaryColor),
                                  child: const Text(
                                    'Company',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))
                          ],
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
