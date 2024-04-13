import 'dart:convert';

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

class SignupStepTwo extends StatefulWidget {
  final int role;

  SignupStepTwo({required this.role});
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
        backgroundColor: Constant.backgroundColor,
        appBar: const AuthAppBar(),
        body: SafeArea(
          child: Center(
              child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
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
                        hintText: 'Fullname',
                        obscureText: false),
                  ),

                  //password textfield
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Textfield(
                        controller: usernameController,
                        hintText: 'Email Address',
                        obscureText: false),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Textfield(
                        controller: passwordController,
                        hintText: 'password',
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
                        'I have read & accept the ',
                        style: TextStyle(
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
                          'Terms & Conditions',
                          style: TextStyle(
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
                          child: Button(onTap: signUp, text: 'Sign Up')),

                      //forgot password?

                      //not a member? register
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Looking for projects?',
                                style:
                                    TextStyle(color: Constant.onPrimaryColor)),
                            const SizedBox(width: 20),
                            TextButton(
                              onPressed: () {
                                Provider.of<RoleProvider>(context,
                                        listen: false)
                                    .setRole(
                                        1 - widget.role as int); // For student
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
                                        ? 'Join as student'
                                        : 'Join as company',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 8, horizontal: 12),
                            //   decoration: BoxDecoration(
                            //     color: Colors.transparent,
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all(
                            //         color: Constant.onPrimaryColor, width: 2),
                            //   ),
                            //   child: const Text('Join as student',
                            //       style: TextStyle(
                            //           color: Constant.onPrimaryColor,
                            //           fontWeight: FontWeight.normal)),
                            // )
                          ]),
                    ],
                  )),
                ),
              ),
            ),
          ])),
        ));
  }
}
