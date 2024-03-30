import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
        body: SafeArea(
          child: Center(
              child: Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //logo
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
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: const Text(
                          'SIGN IN',
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
                            hintText: 'Username',
                            obscureText: false),
                      ),
                      //password textfield
                      Textfield(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true),
                    ],
                  ))
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: ClipPath(
                clipper:
                    OvalTopBorderClipper(), // Custom clipper for rounded cone
                child: Container(
                  padding: const EdgeInsets.only(top: 52),
                  width: 500,
                  color: Constant.primaryColor,
                  child: Center(
                      child: Column(
                    children: [
                      //sign in button
                      Button(onTap: signIn, text: 'Sign In'),
                      //forgot password?
                      Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Constant.onPrimaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      //not a member? register
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('New to StudentsHub?',
                                style:
                                    TextStyle(color: Constant.onPrimaryColor)),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {
                                context.pushNamed(RouteConstants.signUp1);
                              },
                              child: const Text('Join Now',
                                  style: TextStyle(
                                      color: Constant.onPrimaryColor,
                                      fontWeight: FontWeight.normal)),
                            )
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
