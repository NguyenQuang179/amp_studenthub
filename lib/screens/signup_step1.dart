import 'package:amp_studenthub/providers/signup_role_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpStepOne extends StatelessWidget {
  SignUpStepOne({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Text(
                  'StudentHub',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  AppLocalizations.of(context)!.signUpTitle,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 32),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            AppLocalizations.of(context)!.joinWithUsAs,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              height: 52,
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<RoleProvider>(context,
                                          listen: false)
                                      .setRole(0); // For student
                                  context.pushNamed(RouteConstants.signUp2);
                                },
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.roleStudent,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              height: 52,
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<RoleProvider>(context,
                                          listen: false)
                                      .setRole(1); // For student
                                  context.pushNamed(RouteConstants.signUp2);
                                },
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.roleCompany,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Text(
                          AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            context.goNamed(RouteConstants.login);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.signInNow,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
        ));
  }
}
