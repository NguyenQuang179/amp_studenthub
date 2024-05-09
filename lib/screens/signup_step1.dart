import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/signup_role_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpStepOne extends StatelessWidget {
  SignUpStepOne({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.backgroundColor,
        body: SafeArea(
          child: Center(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: const Text(
                  'StudentHub',
                  style: TextStyle(
                      color: Constant.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  AppLocalizations.of(context)!.signUpTitle,
                  style: const TextStyle(
                      color: Constant.secondaryColor,
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
                            style: const TextStyle(
                                color: Constant.textColor,
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
                                    side: const BorderSide(
                                        color: Constant.primaryColor, width: 2),
                                    foregroundColor: Constant.primaryColor),
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
                                    side: const BorderSide(
                                        color: Constant.primaryColor, width: 2),
                                    foregroundColor: Constant.primaryColor),
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
                  color: Constant.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Text(
                          AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: const TextStyle(
                              fontSize: 16, color: Constant.onPrimaryColor),
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
                                style: const TextStyle(
                                  color: Constant.onPrimaryColor,
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
