import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class SignUpStepOne extends StatelessWidget {
  SignUpStepOne({super.key});

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
              child: Column(
            children: [
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
                height: 60,
              ),
              //sign in button
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Constant.primaryColor, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Button(onTap: signIn, text: 'Join as Student'),
                    const SizedBox(
                      height: 40,
                    ),
                    Button(onTap: signIn, text: 'Join as Company'),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                    text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Constant.textColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Find and onboard '),
                    TextSpan(
                        text: "best-skilled student ",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: 'for your product. Student works to '),
                    TextSpan(
                        text: 'gain experience & skills ',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: 'from '),
                    TextSpan(
                        text: 'real-world projects.',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                )),
              ),
              const SizedBox(
                height: 50,
              ),
              Button(onTap: signIn, text: 'Return to sign in'),
              //not a member? register
            ],
          )),
        ));
  }
}
