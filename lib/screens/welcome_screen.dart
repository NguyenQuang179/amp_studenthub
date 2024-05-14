import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          toolbarHeight: 64,
          title: Text(
            'StudentHub',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.user,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.all(32),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                      "Easy way to recruit student for your real-world projects ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                margin: const EdgeInsets.symmetric(vertical: 72),
                child: SvgPicture.asset(
                  'assets/welcome.svg',
                  height: 320,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        onPressed: () {
                          context.goNamed(RouteConstants.company);
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary),
                        child: const Text(
                          'Get Started!',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )),
              ),
            ]),
          ),
        ));
  }
}
