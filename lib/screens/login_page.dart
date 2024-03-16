import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

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
            const SizedBox(
              height: 50,
            ),
            //logo
            const Text(
              'StudentHub',
              style: TextStyle(
                  color: Constant.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'SIGN IN',
              style: TextStyle(
                  color: Constant.secondaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 40),
            ),
            const SizedBox(
              height: 50,
            ),
            //username texfield
            Textfield(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false),
            const SizedBox(
              height: 20,
            ),
            //password textfield
            Textfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true),
            const SizedBox(
              height: 40,
            ),
            ClipPath(
              clipper:
                  OvalTopBorderClipper(), // Custom clipper for rounded cone
              child: Container(
                width: 500,
                height: MediaQuery.of(context).size.height * 0.6,
                color: Constant.primaryColor,
                child: Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    //sign in button
                    Button(onTap: signIn, text: 'Sign In'),
                    const SizedBox(
                      height: 50,
                    ),
                    //forgot password?
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Constant.onPrimaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //not a member? register
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('New to StudentsHub?',
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
          ])),
        ));
  }
}
