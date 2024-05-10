import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/signup_role_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupStepTwo extends StatefulWidget {
  final int role;

  const SignupStepTwo({super.key, required this.role});
  @override
  _SignupStepTowState createState() => _SignupStepTowState();
}

class _SignupStepTowState extends State<SignupStepTwo> {
  bool _isChecked = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  // signin
  // void signUp() {
  //   print('Username: ${usernameController.text}');
  //   print('Password: ${passwordController.text}');
  //   print('Role: ${role}');
  // }
  String? validatePassword(String password) {
    // Define a regular expression pattern
    final RegExp passwordPattern = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
    );

    // Check if the password matches the pattern
    if (!passwordPattern.hasMatch(password)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit';
    }
    // Return null if password is valid
    return null;
  }

  Future<void> signUp() async {
    if (!_isChecked) {
      Fluttertoast.showToast(msg: 'Please accept the Terms & Conditions');
      return;
    }
    final dio = Dio();
    try {
      const endpoint = '${Constant.baseURL}/api/auth/sign-up';
      final submitData = {
        "email": usernameController.text,
        "password": passwordController.text,
        "fullname": fullnameController.text,
        "role": widget.role
      };

      final Response response = await dio.post(
        endpoint,
        data: submitData,
      );

      final responseData = response.data;

      if (responseData['result'] != null) {
        final message = responseData['result']['message'];
        Fluttertoast.showToast(msg: message);
      } else if (responseData['errorDetails'] != null) {
        final errorDetails = responseData['errorDetails'];
        Fluttertoast.showToast(msg: errorDetails[0]);
      } else {
        // Handle other cases if needed
        Fluttertoast.showToast(msg: 'Unexpected response');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // The request was made and the server responded with an error status code
        final responseData = e.response?.data;
        Fluttertoast.showToast(msg: responseData.toString());
      } else {
        // Something else happened, such as network error
        Fluttertoast.showToast(msg: e.message as String);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constant.backgroundColor,
        appBar: const AuthAppBar(),
        body: Column(children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    AppLocalizations.of(context)!.signUpTitle,
                    style: const TextStyle(
                        color: Constant.secondaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 32),
                  ),
                ),

                //username texfield
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Textfield(
                      controller: fullnameController,
                      hintText: AppLocalizations.of(context)!.fullNameLabel,
                      obscureText: false),
                ),

                //password textfield
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Textfield(
                      controller: usernameController,
                      hintText: AppLocalizations.of(context)!.emailLabel,
                      obscureText: false),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Textfield(
                      controller: passwordController,
                      hintText: AppLocalizations.of(context)!.passwordLabel,
                      obscureText: true),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Todo add check and link term and condition
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value as bool;
                        });
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.iHaveRead,
                      style: const TextStyle(
                        color: Constant.secondaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle click on Terms & Conditions
                        // Example: Navigate to a Terms & Conditions page
                        Fluttertoast.showToast(msg: 'Terms & Conditions');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.termConditions,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipPath(
              clipper:
                  OvalTopBorderClipper(), // Custom clipper for rounded cone
              child: Container(
                width: 500,
                height: MediaQuery.of(context).size.height * 0.5,
                color: Constant.primaryColor,
                child: Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    //sign in button
                    Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        child: Button(
                            onTap: signUp,
                            text: AppLocalizations.of(context)!.signUpButton)),

                    //forgot password?

                    //not a member? register
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(AppLocalizations.of(context)!.lookingProject,
                          style:
                              const TextStyle(color: Constant.onPrimaryColor)),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Provider.of<RoleProvider>(context, listen: false)
                              .setRole(1 - widget.role); // For student
                          context.pushNamed(RouteConstants.signUp2);
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(
                                color: Constant.onPrimaryColor, width: 2),
                            foregroundColor: Constant.onPrimaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.role == 1
                                  ? AppLocalizations.of(context)!.joinAsStudent
                                  : AppLocalizations.of(context)!.joinAsCompany,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                )),
              ),
            ),
          ),
        ]));
  }
}
