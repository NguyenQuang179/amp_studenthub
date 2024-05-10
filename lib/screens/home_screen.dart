import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 16, left: 32, right: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                            height: 120,
                          ),
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: RichText(
                                  text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'StudentHub ',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .homeAppDesc,
                                  ),
                                ],
                              ))))
                    ],
                  )),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: BorderDirectional(
                          top: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                          start: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                          end: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary)),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32))),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontSize: 24,
                                height: 1.8,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${AppLocalizations.of(context)!.buildProductWith}\n'),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .highSkilledStudent,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: RichText(
                            text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${AppLocalizations.of(context)!.findAndOnboard} '),
                            TextSpan(
                                text:
                                    '${AppLocalizations.of(context)!.bestSkilledStudent} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text:
                                    '${AppLocalizations.of(context)!.forYourProduct} '),
                            TextSpan(
                                text:
                                    '${AppLocalizations.of(context)!.gainExp} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: '${AppLocalizations.of(context)!.from} '),
                            TextSpan(
                                text:
                                    '${AppLocalizations.of(context)!.realWorldProject}.',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        )),
                      ),
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.joinWithUsAs,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  width: double.infinity,
                                  height: 48,
                                  child: TextButton(
                                    onPressed: () {
                                      final userProvider =
                                          Provider.of<UserProvider>(context,
                                              listen: false);
                                      userProvider.updateRole("Student");
                                      GoRouter.of(context)
                                          .goNamed(RouteConstants.login);
                                    },
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    child: Text(
                                      AppLocalizations.of(context)!.roleStudent,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                              SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      final userProvider =
                                          Provider.of<UserProvider>(context,
                                              listen: false);
                                      userProvider.updateRole("Company");
                                      GoRouter.of(context)
                                          .goNamed(RouteConstants.login);
                                    },
                                    style: TextButton.styleFrom(
                                        side: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: Text(
                                      AppLocalizations.of(context)!.roleCompany,
                                      style: const TextStyle(
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
      ),
    );
  }
}
