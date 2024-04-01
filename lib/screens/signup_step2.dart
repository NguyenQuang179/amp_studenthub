import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class SignupStepTwo extends StatelessWidget {
  SignupStepTwo({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // signin
  void signIn() {
    print('Username: ${usernameController.text}');
    print('Password: ${passwordController.text}');
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
                        controller: usernameController,
                        hintText: 'Fullname',
                        obscureText: false),
                  ),

                  //password textfield
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Textfield(
                        controller: passwordController,
                        hintText: 'Email Address',
                        obscureText: true),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Textfield(
                        controller: usernameController,
                        hintText: 'password',
                        obscureText: false),
                  ),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(value: false, onChanged: null),
                      Text(
                        'I have read & accept the Terms & Conditions',
                        style: TextStyle(
                          color: Constant.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ClipPath(
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
                        child: Button(onTap: signIn, text: 'Sign Up')),

                    //forgot password?

                    //not a member? register
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Looking for projects?',
                          style: TextStyle(color: Constant.onPrimaryColor)),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Constant.onPrimaryColor, width: 2),
                        ),
                        child: const Text('Join as student',
                            style: TextStyle(
                                color: Constant.onPrimaryColor,
                                fontWeight: FontWeight.normal)),
                      )
                    ]),
                  ],
                )),
              ),
            ),
          ])),
        ));
  }
}
