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

  const SignupStepTwo({super.key, required this.role});
  @override
  _SignupStepTowState createState() => _SignupStepTowState();
}

class _SignupStepTowState extends State<SignupStepTwo> {
  bool _isChecked = false;
  String? _passwordErrorText;
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
    print(password);
    print(passwordPattern.hasMatch(password));
    // Check if the password matches the pattern
    if (!passwordPattern.hasMatch(password)) {
      return 'Minimum 8 characters long with 1 upper, lowercase and digit';
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: passwordController,
                        onChanged: (text) {
                          setState(() {
                            // Update the error text dynamically when the text changes
                            // by calling setState to trigger a rebuild
                            // validatePassword returns null if the password is valid
                            // or a validation error message if the password is invalid
                            // Update the error text accordingly
                            _passwordErrorText = validatePassword(text);
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constant.primaryColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constant.secondaryColor),
                          ),
                          fillColor: Constant.backgroundWithOpacity,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          hintText: "new password",
                          errorText: _passwordErrorText, // Set errorText here
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Todo add check and link term and condition
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _isChecked = value as bool;
                            });
                          }
                        },
                      ),
                      const Text(
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
                        child: const Text(
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
                                        ? 'Join as student'
                                        : 'Join as company',
                                    style: const TextStyle(
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
