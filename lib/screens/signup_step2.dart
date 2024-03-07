import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
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
              'SIGN UP',
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
                hintText: 'Fullname',
                obscureText: false),
            const SizedBox(
              height: 20,
            ),
            //password textfield
            Textfield(
                controller: passwordController,
                hintText: 'Work Email Address',
                obscureText: true),
            const SizedBox(
              height: 20,
            ),
            Textfield(
                controller: usernameController,
                hintText: 'password',
                obscureText: false),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Checkbox(value: false, onChanged: null),
                const Text(
                  'I have read & accept the Terms & Conditions',
                  style: TextStyle(
                    color: Constant.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                    Button(onTap: signIn, text: 'Sign Up'),
                    const SizedBox(
                      height: 50,
                    ),
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
