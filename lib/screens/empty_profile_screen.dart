import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EmptyProfileScreen extends StatefulWidget {
  const EmptyProfileScreen({super.key});

  @override
  State<EmptyProfileScreen> createState() => _EmptyProfileScreenState();
}

class _EmptyProfileScreenState extends State<EmptyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final String userRole =
        Provider.of<UserProvider>(context, listen: false).userRole;
    return SizedBox.expand(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  // Layout Container Expand All Height
                  child: Column(children: [
                // Title
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/update.svg',
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Text(
                          'Not have corresponding profile\nPlease create your profile first',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: () {
                              if (userRole == "Student") {
                                context.pushNamed(
                                    RouteConstants.createStudentProfile1);
                              } else {
                                context.pushNamed(
                                    RouteConstants.createCompanyProfile);
                              }
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    'Create $userRole Profile',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    child: const Icon(Icons.add)),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ]))
            ])));
  }
}
